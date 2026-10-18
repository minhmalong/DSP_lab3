# DSP -- Lab 3 (Scilab)

**Trường Đại học Bách khoa - ĐHQG TP.HCM (HCMUT)**  
**Môn:** Xử lý tín hiệu số (CO2036) | **Học kỳ:** HK262  
**Sinh viên:** Đoàn Hiếu Minh (2412036)

## Nội dung

| Tệp | Mô tả |
| --- | --- |
| `DSP_Lab3.sci` | 6 hàm thực hành: `delay`, `advance`, `fold`, `add`, `multi`, `convolution` |
| `lab3_addition.sci` | Bài bổ sung 2.26–2.35: các hàm `ex226` đến `ex235` |
| `screenshots/` | Ảnh minh chứng chạy Scilab (có thể thay bằng ảnh mới từ phiên chạy cuối) |

Hai tệp `.sci` **chỉ khai báo hàm**. Lệnh `exec` không tự chạy ví dụ hay mở đồ thị.

## Cách chạy (Scilab 2026)

Trong thư mục chứa hai tệp, thực hiện:

```scilab
exec("DSP_Lab3.sci", -1);
exec("lab3_addition.sci", -1);
```

Gọi một ví dụ từ bài chính:

```scilab
[yn, yorigin] = delay([1, -2, 3, 6], 3, 1);
[yn, yorigin] = add([0, 1, 3, -2], 1, [1, 1, 2, 3], 2);
```

Gọi một ví dụ từ phần bổ sung:

```scilab
[n, y] = ex226(1, 0, 8);
[n, h] = ex231(8);
```

Các hàm vẽ đồ thị khi **được gọi**; hình không hiện ra chỉ bằng cách nạp tệp. Các hàm bài chính dùng **vị trí gốc tính từ 1**: `origin` là vị trí mẫu ứng với `n = 0`. Gốc có thể nằm ngoài vectơ do dịch thời gian.

## Minh chứng

Ảnh gốc theo thứ tự `ex1.png`–`ex6.png` và `add226.png`–`add235.png`. Sau khi thay mã nguồn, nên **chạy lại các ví dụ và chụp đồ thị mới** để phần trình bày được đồng nhất (trục n nguyên, các mẫu có chấm tròn, ít lưới hơn).

## Lưu ý học thuật

- Bài 2.26 và 2.30 có điều kiện đầu chưa được chỉ rõ, vì vậy được truyền qua tham số.
- Bài 2.34 tính các mẫu đầu vào yêu cầu trong khoảng `n = 0..8`, không mặc định tín hiệu vào bằng 0 sau khoảng đó.
- Không thay đổi công thức và kết quả số học khi chỉnh lại đồ họa và định dạng mã nguồn.
