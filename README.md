# Hệ thống giao tiếp PC ↔ DE2, gửi ảnh, lưu vào bộ nhớ và hiển thị qua VGA

> **Đồ án môn HDL**

Repository này dùng để quản lý, phát triển, tài liệu hóa và demo đồ án với đề tài: **hiện thực hệ thống giao tiếp giữa PC và board DE2, gửi dữ liệu ảnh từ PC xuống board, lưu vào bộ nhớ trên board, sau đó đọc ảnh từ bộ nhớ và hiển thị lên màn hình qua VGA**.

---

## 1. Giới thiệu đề tài

Mục tiêu của đồ án là xây dựng một hệ thống phần cứng - phần mềm hoàn chỉnh, trong đó:
- PC gửi dữ liệu ảnh xuống FPGA board **DE2**.
- Dữ liệu ảnh được lưu vào bộ nhớ trên board (**SRAM/SDRAM - chưa chốt**).
- Hệ thống đọc lại dữ liệu ảnh từ bộ nhớ.
- Ảnh được hiển thị lên màn hình thông qua chuẩn **VGA**.

Đây là một đề tài mang tính hệ thống vì bao gồm nhiều khối chức năng liên kết chặt chẽ với nhau:
- Khối giao tiếp giữa PC và FPGA
- Khối nhận và kiểm tra dữ liệu ảnh
- Khối điều khiển bộ nhớ ngoài
- Khối đọc dữ liệu ảnh
- Khối điều khiển **VGA**
- Khối tích hợp và kiểm thử toàn hệ thống

---

## 2. Mục tiêu đồ án

Nhóm hướng đến các mục tiêu chính sau:
1. Xây dựng đường truyền dữ liệu ảnh từ PC xuống board DE2.
2. Lưu dữ liệu ảnh vào bộ nhớ trên board một cách chính xác và có tổ chức.
3. Đọc lại dữ liệu ảnh từ bộ nhớ và đồng bộ hóa để xuất ra **VGA**.
4. Hiển thị thành công ảnh trên màn hình ngoài.

---

## 3. Phạm vi thực hiện

### Bao gồm
- Thiết kế phần cứng bằng HDL cho các khối trên FPGA.
- Xây dựng phần mềm phía PC để gửi ảnh.
- Thiết kế khối ghi/đọc bộ nhớ.
- Thiết kế khối hiển thị **VGA**.
- Mô phỏng, kiểm thử, tích hợp và demo hệ thống.
- Tài liệu hóa toàn bộ quá trình phát triển.

### Chưa chốt
Hiện tại một số quyết định kỹ thuật vẫn đang được xem xét và sẽ tiếp tục được cập nhật trong quá trình làm đồ án:
- Giao tiếp giữa PC và DE2 sẽ dùng **UART**, **USB-Blaster/JTAG**, **Ethernet** hay phương án khác?
- Bộ nhớ chính sẽ dùng **SRAM**, **SDRAM**, hay kết hợp cả hai?
- Ảnh hiển thị sẽ là **grayscale** hay **RGB**?
- Độ phân giải mục tiêu là bao nhiêu?

---

## 4. Các câu hỏi thiết kế còn mở

Phần này dùng để ghi rõ các vấn đề chưa chốt để cả nhóm cùng theo dõi.

### Câu hỏi 1. Giao tiếp PC ↔ DE2 sẽ dùng gì?
Các phương án đang cân nhắc:
- **UART**
- **USB-Blaster / JTAG-based communication**
- **Ethernet**
- Phương án khác

Tiêu chí lựa chọn:
- Dễ hiện thực
- Tốc độ truyền phù hợp
- Dễ kiểm thử và `debug`
- Phù hợp với tài nguyên của DE2

### Câu hỏi 2. Bộ nhớ chính sẽ dùng loại nào?
Các phương án đang cân nhắc:
- **SRAM**
- **SDRAM**
- Kết hợp cả **SRAM** và **SDRAM**

Tiêu chí lựa chọn:
- Dung lượng
- Mức độ phù hợp với kiểu truy cập ảnh
- Độ phức tạp của `controller`
- Mức độ thuận tiện khi đọc dữ liệu ra **VGA**

### Câu hỏi 3. Ảnh hiển thị sẽ dùng định dạng nào?
Các phương án đang cân nhắc:
- **grayscale**
- **RGB**

Tiêu chí lựa chọn:
- Mức dùng tài nguyên phần cứng
- Nhu cầu bộ nhớ
- Chất lượng demo
- Thời gian triển khai

### Câu hỏi 4. Độ phân giải mục tiêu là bao nhiêu?
Các mức có thể cân nhắc:
- 160 × 120
- 320 × 240
- 640 × 480

Tiêu chí lựa chọn:
- Dung lượng ảnh cần lưu
- Băng thông truyền từ PC xuống board
- Độ phức tạp của khối **VGA**
- Khả năng đáp ứng của bộ nhớ

---

## 5. Luồng hoạt động đề xuất

1. Người dùng chọn ảnh trên PC.
2. Phần mềm phía PC chuyển đổi ảnh về định dạng phù hợp với phần cứng.
3. Ảnh được truyền từ PC xuống board DE2 qua giao tiếp đã chọn.
4. Khối nhận dữ liệu trên FPGA tiếp nhận và kiểm tra dữ liệu.
5. Khối điều khiển bộ nhớ ghi dữ liệu ảnh vào **SRAM/SDRAM**.
6. Khối đọc ảnh lấy dữ liệu từ bộ nhớ theo thứ tự hiển thị.
7. Khối điều khiển **VGA** phát tín hiệu đồng bộ và dữ liệu điểm ảnh ra màn hình.

---

## 6. Kiến trúc mức cao

```text
+------------------+        +---------------------------+        +------------------+
|      PC App      | -----> |  Khối nhận giao tiếp      | -----> |   Image Buffer   |
| (Python / C++)   |        |         trên FPGA         |        | (SRAM / SDRAM)   |
+------------------+        +---------------------------+        +------------------+
                                                                         |
                                                                         v
                                                               +------------------+
                                                               |  VGA Readout &   |
                                                               |  Timing Control  |
                                                               +------------------+
                                                                         |
                                                                         v
                                                               +------------------+
                                                               |    VGA Display    |
                                                               +------------------+
```

### Các khối chức năng chính
- **PC App**: đọc ảnh, tiền xử lý dữ liệu, đóng gói dữ liệu, gửi xuống board.
- **Communication Receiver**: nhận dòng dữ liệu từ PC.
- **Frame Buffer Controller**: quản lý cách lưu ảnh trong bộ nhớ.
- **Memory Interface**: xử lý tín hiệu đọc/ghi đối với **SRAM** hoặc **SDRAM**.
- **VGA Controller**: tạo `HSYNC`, `VSYNC`, tọa độ điểm ảnh và thời gian hiển thị.
- **Top-Level Integration**: kết nối toàn bộ các khối và ánh xạ ra chân board.

---

## 7. Cấu trúc repo đề xuất

```text
.
├── README.md
├── rtl/
│   ├── top/
│   ├── comm/
│   ├── memory/
│   ├── vga/
│   ├── image_pipeline/
│   └── common/
├── tb/
│   ├── unit/
│   ├── integration/
│   ├── test_vectors/
│   └── sim_scripts/
├── software_pc/
│   ├── python/
│   ├── cpp/
│   ├── sample_images/
│   ├── converted_data/
│   └── tools/
├── quartus/
│   ├── project/
│   ├── qsf/
│   ├── pin_assignments/
│   └── output_files/
├── docs/
│   ├── architecture/
│   ├── interface_spec/
│   ├── timing/
│   ├── memory_map/
│   ├── meeting_notes/
│   ├── decisions/
│   └── references/
├── demo/
│   ├── photos/
│   ├── videos/
│   ├── screenshots/
│   └── demo_cases/
├── report/
│   ├── proposal/
│   ├── midterm/
│   ├── final/
│   └── slides/
└── .gitignore
```

### Giải thích thư mục

#### `rtl/`
Chứa mã HDL tổng hợp được.
- `top/`: khối tích hợp mức cao nhất
- `comm/`: các khối giao tiếp PC ↔ FPGA
- `memory/`: `controller` cho **SRAM/SDRAM** và khối quản lý vùng nhớ ảnh
- `vga/`: khối tạo timing và xuất dữ liệu điểm ảnh
- `image_pipeline/`: xử lý định dạng, địa chỉ, ánh xạ điểm ảnh
- `common/`: các khối dùng lại như `counter`, `FSM`, `FIFO`, tiện ích chung

#### `tb/`
Chứa `testbench` và tài nguyên phục vụ mô phỏng.
- `unit/`: `testbench` cho từng khối nhỏ
- `integration/`: `testbench` cho các khối tích hợp
- `test_vectors/`: dữ liệu ảnh mẫu cho mô phỏng
- `sim_scripts/`: script chạy mô phỏng bằng `ModelSim` hoặc công cụ tương đương

#### `software_pc/`
Chứa phần mềm phía PC.
- `python/`: chương trình gửi ảnh viết bằng **Python**
- `cpp/`: chương trình gửi ảnh viết bằng **C++**
- `sample_images/`: ảnh gốc dùng để thử nghiệm
- `converted_data/`: dữ liệu ảnh đã được chuyển đổi
- `tools/`: công cụ hỗ trợ như resize, convert, pack dữ liệu

#### `quartus/`
Chứa project và cấu hình cho FPGA.
- `project/`: file project của **Quartus**
- `qsf/`: file cấu hình và gán tài nguyên
- `pin_assignments/`: tài liệu hoặc file gán chân board
- `output_files/`: file tạo ra sau khi biên dịch

#### `docs/`
Chứa tài liệu kỹ thuật của đề tài.
- `architecture/`: sơ đồ khối và mô tả kiến trúc
- `interface_spec/`: đặc tả giao tiếp giữa các khối
- `timing/`: ghi chú về clock và timing
- `memory_map/`: sơ đồ địa chỉ bộ nhớ
- `meeting_notes/`: biên bản họp nhóm
- `decisions/`: ghi lại các quyết định thiết kế
- `references/`: tài liệu tham khảo, datasheet, manual của DE2

#### `demo/`
Chứa minh chứng tiến độ và kết quả demo.
- `photos/`: ảnh chụp hệ thống
- `videos/`: video demo
- `screenshots/`: ảnh chụp màn hình hoặc kết quả hiển thị
- `demo_cases/`: mô tả các kịch bản demo

#### `report/`
Chứa tài liệu phục vụ nộp môn.
- `proposal/`: đề cương
- `midterm/`: báo cáo giữa kỳ
- `final/`: báo cáo cuối kỳ
- `slides/`: slide thuyết trình

---

## 8. Thông tin nhóm

### Số lượng thành viên
- 03 thành viên

### Danh sách thành viên
| STT | Họ và tên | MSSV | Vai trò |
|---|---|---|---|
| 1 | Thạch Via Sa Na | 23520966 |   |
| 2 | Trương Quốc Thịnh | 23521516 |   |
| 3 | Dương Gia Bảo | 23520097 |   |

> Vai trò có thể điều chỉnh lại tùy theo phân công thực tế của nhóm.

---

## 9. Kế hoạch triển khai

### Giai đoạn 1 - Xác định yêu cầu
- Khảo sát tài nguyên của board DE2.
- So sánh các phương án giao tiếp.
- So sánh **SRAM** và **SDRAM**.
- Chọn định dạng ảnh và độ phân giải mục tiêu.

### Giai đoạn 2 - Nguyên mẫu giao tiếp PC
- Xây dựng chương trình gửi dữ liệu đơn giản từ PC.
- Gửi `test pattern` trước khi gửi ảnh thật.
- Kiểm tra tính đúng đắn của dữ liệu nhận trên FPGA.

### Giai đoạn 3 - Khối bộ nhớ
- Hiện thực logic ghi ảnh vào bộ nhớ.
- Hiện thực logic đọc ảnh từ bộ nhớ.
- Kiểm tra địa chỉ và cách sắp xếp dữ liệu.

### Giai đoạn 4 - Khối VGA
- Thiết kế bộ tạo timing cho **VGA**.
- Hiển thị `test pattern` để kiểm tra trước.
- Kết nối dữ liệu ảnh đã lưu vào bộ nhớ để hiển thị.

### Giai đoạn 5 - Tích hợp toàn hệ thống
- Kết nối khối giao tiếp, bộ nhớ và **VGA**.
- Kiểm thử toàn bộ luồng gửi ảnh và hiển thị.
- Sửa lỗi đồng bộ, timing và định dạng dữ liệu.

### Giai đoạn 6 - Demo và hoàn thiện tài liệu
- Quay video, chụp hình demo.
- Hoàn thiện báo cáo và slide.
- Làm sạch repo trước khi nộp và công bố.

---

## 10. Quản lý công việc

Để repo được tổ chức chuyên nghiệp, nhóm nên tuân theo quy ước làm việc rõ ràng.

### Quy ước nhánh
- `main`: phiên bản ổn định, có thể demo
- `develop`: nhánh tích hợp chính trong quá trình phát triển
- `feature/<ten-tinh-nang>`: phát triển chức năng mới
- `fix/<ten-loi>`: sửa lỗi
- `docs/<ten-noi-dung>`: cập nhật tài liệu

### Ví dụ tên nhánh
- `feature/uart-receiver`
- `feature/vga-controller`
- `feature/sdram-framebuffer`
- `fix/pixel-address-overflow`
- `docs/update-architecture`

### Quy ước `commit`
Nên dùng câu ngắn, rõ ràng, thể hiện hành động cụ thể.

Ví dụ:
- `feat: add VGA timing generator`
- `fix: correct SRAM write address logic`
- `test: add testbench for image receiver`
- `docs: update system architecture`
- `refactor: clean top-level signal naming`

### Quản lý `issue`
Gợi ý một số `label`:
- `architecture`
- `communication`
- `memory`
- `vga`
- `software-pc`
- `verification`
- `documentation`
- `bug`
- `enhancement`
- `demo`

---

## 11. Quy tắc tài liệu hóa

Mỗi quyết định thiết kế quan trọng nên ghi lại các ý sau:
- Đã quyết định điều gì?
- Vì sao chọn phương án đó?
- Đã cân nhắc những phương án nào khác?
- Chấp nhận những đánh đổi nào?

### Vị trí lưu tài liệu quyết định
```text
docs/decisions/
```

### Gợi ý cách đặt tên
```text
ADR-001-communication-interface.md
ADR-002-memory-selection.md
ADR-003-vga-format-resolution.md
```

Việc này đặc biệt cần thiết vì hiện tại vẫn còn nhiều quyết định kỹ thuật chưa chốt.

---

## 12. Chiến lược kiểm thử

### Kiểm thử từng khối
- `testbench` cho khối nhận giao tiếp
- `testbench` cho khối ghi bộ nhớ
- `testbench` cho khối đọc bộ nhớ
- `testbench` cho khối tạo timing **VGA**
- `testbench` cho khối sinh địa chỉ và dữ liệu điểm ảnh

### Kiểm thử tích hợp
- Luồng dữ liệu từ PC → khối nhận → bộ nhớ ghi
- Luồng dữ liệu từ bộ nhớ → khối đọc → **VGA**
- Luồng đầy đủ: ảnh được gửi → lưu → đọc lại → hiển thị

### Kiểm thử mức demo
- Gửi ảnh kiểm tra đơn giản dạng `grayscale`
- Gửi `checkerboard` hoặc `color bar`
- Gửi ảnh thật từ PC và kiểm tra kết quả hiển thị trên màn hình

---

## 13. Hướng dẫn bắt đầu

### Yêu cầu cơ bản
- Công cụ **Intel/Altera Quartus**
- Board DE2
- Màn hình hỗ trợ **VGA**
- Môi trường phát triển cho **Python** hoặc **C++** phía PC
- Phương thức kết nối sẽ được chốt sau

### Checklist khởi tạo
- [ ] Tạo project **Quartus** cho DE2
- [ ] Tạo cấu trúc thư mục HDL cơ bản
- [ ] Tạo `top-level module` ban đầu
- [ ] Thực hiện thí nghiệm giao tiếp đầu tiên
- [ ] Tạo khối sinh `test pattern` cho **VGA**
- [ ] Chốt định dạng dữ liệu ảnh
- [ ] Tạo biên bản họp đầu tiên trong `docs/meeting_notes/`

---

## 14. Sản phẩm đầu ra

Các sản phẩm dự kiến của đồ án bao gồm:
- Mã HDL cho toàn bộ hệ thống trên FPGA
- Phần mềm phía PC để gửi ảnh
- `testbench` và kết quả mô phỏng
- Tài liệu kiến trúc và đặc tả giao tiếp
- Hình ảnh, video, ảnh chụp màn hình phục vụ demo
- Báo cáo giữa kỳ, cuối kỳ và slide thuyết trình

---

## 15. Các mốc đề xuất

| Mốc | Nội dung |
|---|---|
| M1 | Chốt kiến trúc tổng thể và giao tiếp PC ↔ DE2 |
| M2 | Gửi được dữ liệu thử nghiệm từ PC xuống DE2 |
| M3 | Ghi và đọc đúng dữ liệu từ bộ nhớ |
| M4 | Hiển thị đúng `test pattern` trên VGA |
| M5 | Hiển thị được ảnh đã truyền từ PC trên màn hình |
| M6 | Hoàn thiện bộ demo và tài liệu cuối cùng |

---

## 16. Rủi ro và thách thức

Một số rủi ro kỹ thuật có thể gặp:
- Băng thông giao tiếp không đủ cho định dạng ảnh đã chọn.
- `Controller` bộ nhớ phức tạp hơn dự kiến.
- Lỗi timing của **VGA** làm hình ảnh không ổn định.
- Sai khác giữa định dạng dữ liệu phía PC và giả định của phần cứng.
- Chốt quyết định kỹ thuật quá muộn làm giảm thời gian hiện thực.

### Hướng giảm rủi ro
- Bắt đầu từ độ phân giải thấp và ảnh `grayscale` đơn giản.
- Kiểm thử từng khối riêng biệt trước khi tích hợp.
- Chốt kiến trúc sớm.
- Cập nhật tài liệu sau mỗi thay đổi lớn.

---

## 17. Trạng thái hiện tại

- **Giai đoạn hiện tại:** lập kế hoạch và xác định kiến trúc
- **Trạng thái:** đang thực hiện
- **Ưu tiên hiện tại:** chốt giao tiếp, bộ nhớ và định dạng ảnh cho **VGA**

---

## 18. Hướng mở rộng

Sau khi hoàn thiện phiên bản cơ bản, đề tài có thể mở rộng theo các hướng sau:
- Truyền ảnh liên tục thay vì chỉ gửi từng ảnh đơn lẻ
- `Double buffering` để hiển thị mượt hơn
- Xử lý ảnh đơn giản trên FPGA trước khi xuất **VGA**
- Hỗ trợ nhiều độ phân giải hơn
- Xây dựng giao diện phần mềm phía PC thân thiện hơn

---

## 19. Giảng viên hướng dẫn

- **Giảng viên:** *Điền sau*
- **Bộ môn:** Thiết kế hệ thống số với HDL - CE213.Q22*
- **Trường:** trường Đại học Công Nghệ Thông Tin - Đại học Quốc Gia Thành phố Hồ Chí Minh*

---

## 20. Ghi chú sử dụng

Repository này hiện được định hướng phục vụ mục đích học tập, nghiên cứu và phát triển đồ án môn học.
