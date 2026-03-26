module VGA_patten #(
    parameter           H_SYNC_PULSE = 96,    // small delay after visible area
    parameter           V_SYNC_PULSE = 2,     // small delay after visible area
    parameter           H_BACK_PORCH = 48,    // delay before visible area
    parameter           V_BACK_PORCH = 33,    // delay before visible area
    parameter           H_FRONT_PORCH = 16,   // delay after visible area
    parameter           V_FRONT_PORCH = 10,   // delay after visible area 
    parameter           H_ACTIVE = 640,       // width of visible area
    parameter           V_ACTIVE = 480        // height of visible area
)(
    input wire          clk25m,
    input wire          rst_n,
    output wire         hsync,
    output wire         vsync,
    output wire [3:0]   red,
    output wire [3:0]   green,
    output wire [3:0]   blue
);

    parameter                   H_TOTAL = H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE + H_FRONT_PORCH;
    parameter                   V_TOTAL = V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE + V_FRONT_PORCH;

    localparam                  ACTIVE_AREA = 2'b00,
                                FRONT_PORCH_AREA = 2'b01,
                                SYNC_PULSE_AREA = 2'b10,
                                BACK_PORCH_AREA = 2'b11;

    reg [$clog2(H_TOTAL)-1:0]   h_count_r = 0;
    reg [$clog2(V_TOTAL)-1:0]   v_count_r = 0;

    reg [1:0]                   h_state_r = ACTIVE_AREA;
    reg [1:0]                   v_state_r = ACTIVE_AREA;

    reg hsync_r = 1;
    reg vsync_r = 1;

    reg [3:0]                   red_r = 0;
    reg [3:0]                   green_r = 0;
    reg [3:0]                   blue_r = 0;
    
    // hsync generation
    always @(posedge clk25m or negedge rst_n) begin
        if(!rst_n) begin
            h_count_r <= 0;
            h_state_r <= ACTIVE_AREA;
            hsync_r <= 1;
        end else begin
            case (h_state_r)

                ACTIVE_AREA: begin
                    hsync_r <= 1;
                    if(h_count_r >= H_ACTIVE -1)
                        h_state_r <= FRONT_PORCH_AREA;
                    else
                        h_state_r <= ACTIVE_AREA;

                    h_count_r <= h_count_r + 1;
                end

                FRONT_PORCH_AREA: begin
                    hsync_r <= 1;
                    if(h_count_r >= H_ACTIVE + H_FRONT_PORCH - 1)
                        h_state_r <= SYNC_PULSE_AREA;
                    else
                        h_state_r <= FRONT_PORCH_AREA;

                    h_count_r <= h_count_r + 1;
                end

                SYNC_PULSE_AREA: begin
                    hsync_r <= 0;
                    if(h_count_r >= H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE - 1)
                        h_state_r <= BACK_PORCH_AREA;
                    else
                        h_state_r <= SYNC_PULSE_AREA;

                    h_count_r <= h_count_r + 1;
                end

                BACK_PORCH_AREA: begin
                    hsync_r <= 1;

                    if(h_count_r >= H_TOTAL -1) begin
                        h_count_r <= 0;
                        h_state_r <= ACTIVE_AREA;
                    end else begin
                        h_state_r <= BACK_PORCH_AREA;
                        h_count_r <= h_count_r + 1;
                    end
                end

            endcase
        end
    end

    // vsync generation
    always @(posedge clk25m or negedge rst_n) begin
        if(!rst_n) begin
            v_count_r <= 0;
            v_state_r <= ACTIVE_AREA;
            vsync_r <= 1;
        end else begin
            case (v_state_r)

                ACTIVE_AREA: begin
                    vsync_r <= 1;
                    if(v_count_r >= V_ACTIVE -1)
                        v_state_r <= FRONT_PORCH_AREA;
                    else
                        v_state_r <= ACTIVE_AREA;
                    if(h_count_r == H_TOTAL - 1) // increment vertical count at end of horizontal line
                        v_count_r <= v_count_r + 1;
                    else
                        v_count_r <= v_count_r; // maintain vertical count until horizontal line ends
                end

                FRONT_PORCH_AREA: begin
                    vsync_r <= 1;
                    if(v_count_r >= V_ACTIVE + V_FRONT_PORCH - 1)
                        v_state_r <= SYNC_PULSE_AREA;
                    else
                        v_state_r <= FRONT_PORCH_AREA;

                    if(h_count_r == H_TOTAL - 1) // increment vertical count at end of horizontal line
                        v_count_r <= v_count_r + 1;
                    else
                        v_count_r <= v_count_r; // maintain vertical count until horizontal line ends
                end

                SYNC_PULSE_AREA: begin
                    vsync_r <= 0;
                    if(v_count_r >= V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE - 1)
                        v_state_r <= BACK_PORCH_AREA;
                    else
                        v_state_r <= SYNC_PULSE_AREA;

                    if(h_count_r == H_TOTAL - 1) // increment vertical count at end of horizontal line
                        v_count_r <= v_count_r + 1;
                    else
                        v_count_r <= v_count_r; // maintain vertical count until horizontal line ends
                end

                BACK_PORCH_AREA: begin
                    vsync_r <= 1;

                    if(v_count_r >= V_TOTAL -1) begin
                        v_count_r <= 0;
                        v_state_r <= ACTIVE_AREA;
                    end else begin
                        v_state_r <= BACK_PORCH_AREA;
                        if(h_count_r == H_TOTAL - 1) // increment vertical count at end of horizontal line
                            v_count_r <= v_count_r + 1;
                        else
                            v_count_r <= v_count_r; // maintain vertical count until horizontal line ends
                    end
                end

            endcase
        end
    end

    // color generation
    always @(posedge clk25m or negedge rst_n) begin
        if(!rst_n) begin
            red_r <= 0;
            green_r <= 0;
            blue_r <= 0;
        end else begin
            blue_r <= h_count_r[3:0]; // blue color based on horizontal count
            if(blue_r == 4'hf)
                green_r <= green_r + 4'h1; // reset blue when it reaches max value
            
            if(green_r == 4'hf)
                red_r <= red + 4'h1; // reset green when it reaches max value

        end
    end


    // assign output
    assign hsync = hsync_r;
    assign vsync = vsync_r;
    assign red = red_r;
    assign green = green_r;
    assign blue = blue_r;


endmodule