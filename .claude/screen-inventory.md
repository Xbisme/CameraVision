# Screen Inventory — ProductCam

> **Vai trò**: Bước làm TRƯỚC khi chốt platform-channel-contract.md. Không có backend/API — chỉ có ranh giới Dart ↔ Native cần chốt.
>
> Last updated: 2026-08-14 · Platform-channel-contract version tương ứng: `v0.2.0`
>
> **Nguồn chân lý giao diện**: bundle design tại [`design/`](design/) — `project/ProductCam App.html`, `project/pc-screens.jsx`, `project/_ds/.../ui_kits/productcam-app/`. Khi file này mâu thuẫn với bundle design → **design thắng**, và phải cập nhật lại file này.

## Bối cảnh khác biệt so với LiveCanvas/SoundWave

- **Không có backend, không có tài khoản** — 100% xử lý on-device, offline hoàn toàn.
- **Không có API contract** — thay vào đó là "contract" giữa Flutter (Dart) và code native mỗi platform (iOS Vision framework / Android TFLite), xem [`platform-channel-contract.md`](platform-channel-contract.md).
- **Free hoàn toàn** — không có paywall/IAP.
- **Kiến trúc native khác nhau theo platform**: iOS dùng Vision framework subject lifting (system API, không cần bundle model) · Android bundle model TFLite riêng (MODNet/U2-Net/ISNet export sẵn).

## Danh sách màn hình (theo design)

7 màn + 3 sheet. Thứ tự và tên đúng như thanh điều hướng trong bản dựng design.

| # | Màn hình | Nội dung/Data | Action |
|---|---|---|---|
| 1 | **Camera** (`Camera Capture`) | Feed camera + overlay contour real-time (3 trạng thái: `scanning` / `locked` / `review`) · readout mono "Đang tìm vật thể" ↔ "Đã khoá viền" + kích thước · lưới bố cục 1/3 · dải thumbnail các ảnh đã chụp trong phiên (chế độ Loạt) | Chụp (nút 80px, hiện số ảnh khi ở chế độ Loạt) · flash bật/tắt · lưới bật/tắt · đổi camera trước/sau · toggle **Đơn ↔ Loạt** · mở Phiên chụp (có badge số ảnh) · mở Cài đặt |
| 2 | **Kết quả** (`Processing/Review`) | Ảnh đã tách nền trên nền checkerboard · trong lúc xử lý: `ProgressTrace` + badge "ĐANG XỬ LÝ" · xong: contour vẽ lại đè lên kết quả + badge "XONG" · readout trạng thái viền + badge kích thước/dung lượng · cảnh báo `EdgeNotice` khi viền phức tạp | Chụp lại · Chấp nhận (→ Nền & bóng) · **Chỉnh viền** (mở sheet) · bỏ qua cảnh báo |
| 3 | **Nền & bóng** (`Background Editor`) | Preview ảnh trên nền đang chọn, cập nhật tức thì · readout nền hiện tại | Chọn nền (7 swatch: Trong suốt · Trắng · Kem · Xám · gradient Mint · gradient Nắng · Đậm) · chọn preset bóng (Không / Nhẹ / Vừa / Đậm) · slider **Độ đậm** (%) và **Độ mềm** (px) · Xuất ảnh (mở sheet Xuất) |
| 4 | **Phiên chụp** (`Batch Session`) | Lưới thumbnail 3 cột (gap 6px) kèm trạng thái từng ảnh (`queued` / `working` / `done` / `review` / `error`) · readout "Đang xử lý N ảnh" ↔ "Đã xong tất cả" + đếm `xong/tổng` · badge "N XEM LẠI", "N LỖI" | Lọc theo trạng thái (Tất cả / Xong / Cần xem lại / Lỗi) · tap 1 ảnh → mở Kết quả hoặc Nền & bóng tuỳ trạng thái · Chụp thêm · Xuất tất cả |
| 5 | **Xuất** (`Export` — bottom sheet) | Số ảnh đã chọn · ước tính dung lượng theo định dạng × kích thước × số ảnh | Chọn định dạng **PNG (trong suốt) / JPG / WEBP** · chọn kích thước **1000 / 1200 / 2048 px** · Lưu vào máy (toast "Đã lưu N ảnh vào máy" + hành động "Xem") · Chia sẻ |
| 6 | **Lịch sử** (`History`) | Ảnh đã xử lý, **nhóm theo ngày** ("Hôm nay · 14:32", "09/08 · 20:11") · lưới 3 cột · tổng số ảnh + "lưu trên máy" | Lọc (Tất cả / Hôm nay / Cần xem lại) · tìm kiếm · tap 1 ảnh → sheet thao tác · Mở camera |
| 7 | **Cài đặt** (`Settings`) | Chế độ hiệu năng (3 lựa chọn, kèm readout thông số) · trạng thái quyền camera/thư viện ảnh · thông tin mô hình theo platform (iOS: Vision · Subject lifting · 0 MB — Android: model TFLite + dung lượng) · dung lượng lưu trữ · phiên bản app | Đổi chế độ hiệu năng · mở cài đặt hệ thống · xoá dữ liệu tạm |

### Sheet phụ (theo design)

| Sheet | Mở từ | Nội dung | Action |
|---|---|---|---|
| **Chỉnh viền** (`EdgeRefineSheet`) | Kết quả (#2) | Preview trên checkerboard cập nhật theo slider | Slider **Thu / giãn viền** (−10…+10 px) · slider **Làm mềm mép** (0…10 px) · Xong |
| **Thao tác ảnh** (`ItemSheet`) | Lịch sử (#6) | Tên ảnh + metadata (PNG · 1200×1200 · 340 KB) | Chỉnh nền lại · Xuất lại · Chia sẻ · **Xoá ảnh** (kèm toast "Hoàn tác") |
| **Xuất ảnh** (`ExportSheet`) | Nền & bóng (#3), Phiên chụp (#4), Lịch sử (#6) | Xem hàng #5 ở trên | — |

### Thành phần khung dùng chung

`ScreenHeader` (56px: nút quay lại + tiêu đề + meta + slot phải) · **`ThumbBand` 132px ở đáy giữ mọi hành động chính** (không bao giờ đặt hành động xoá ở đây) · scrim gradient trên/dưới khi chrome nằm trên feed camera · `Toast` một dòng một hành động · `Readout` mono cho mọi con số.

## Quyết định đã chốt (ảnh hưởng platform-channel-contract)

- **Real-time overlay là contour nhẹ, KHÔNG phải mask pixel đầy đủ** — chạy trên frame đã downsample (vd 360p) mỗi vài frame (không phải mọi frame), để giữ FPS mượt trên máy tầm thấp. Đây là cách duy nhất để "thấy trước khi chụp" mà không làm app giật lag.
- **Segmentation chất lượng cao chỉ chạy 1 lần trên ảnh đã chụp** (không phải real-time) — ảnh tĩnh xử lý full-res, chấp nhận vài trăm ms tới vài giây tuỳ máy, có loading indicator (`ProgressTrace` ở màn Kết quả).
- **Batch mode**: chụp nhiều ảnh liên tiếp trước, xử lý segmentation full-res chạy nền (background queue) sau khi chụp xong từng ảnh — không block việc bấm chụp ảnh tiếp theo. Lưới ở màn Phiên chụp chính là bảng trạng thái của queue này.
- **Chế độ hiệu năng** (Cài đặt) chỉ ảnh hưởng tốc độ/độ phân giải overlay real-time, KHÔNG ảnh hưởng chất lượng ảnh xuất. Thông số mặc định theo design: Cân bằng `360p · 1/3 frame` · Tiết kiệm pin `270p · 1/5 frame` · Chất lượng cao `540p · 1/2 frame`.
- **Lưu trữ**: hoàn toàn local (SQLite/Hive cho metadata History + file system cho ảnh), không sync cloud.

## Quyết định mới đến từ design (2026-08-14)

- **✅ "Chỉnh viền" thủ công thuộc v1 (đã chốt 2026-08-14)** — bản inventory trước xếp tính năng này vào v2. Design đã đưa nó thành một sheet ngay ở màn Kết quả (thu/giãn viền + làm mềm mép), nên v1 phải có. **Xử lý hoàn toàn phía Dart trên mask PNG đã nhận** (erode/dilate + feather), KHÔNG thêm method channel mới, KHÔNG gọi lại native. Chi tiết: [`decisions/000-edge-refine-v1.md`](decisions/000-edge-refine-v1.md).
- **✅ Min iOS 17.0 (đã chốt 2026-08-14)** — máy dưới 17.0 nhận `UNSUPPORTED_OS_VERSION`, bị chặn tính năng kèm giải thích rõ, không crash. Chi tiết: [`decisions/000-min-ios-version.md`](decisions/000-min-ios-version.md).
- **Định dạng xuất có thêm WEBP** (trước chỉ PNG/JPG) và **kích thước xuất chọn được**: 1000 / 1200 / 2048 px.
- **Bảng nền cố định 7 lựa chọn** — trong suốt, 4 màu (Trắng, Kem, Xám, Đậm), 2 gradient (Mint, Nắng). Không có color picker tự do ở v1.
- **Bóng đổ đi theo preset trước, slider sau** — Không / Nhẹ / Vừa / Đậm, mỗi preset set sẵn Độ đậm + Độ mềm, người dùng tinh chỉnh thêm nếu muốn.
- **Trạng thái ảnh trong batch/history có 5 giá trị**: `queued`, `working`, `done`, `review` (viền phức tạp — amber), `error` (coral). Contract cần đủ dữ liệu để Dart suy ra 5 trạng thái này.
- **Màn Cài đặt hiển thị thông tin mô hình theo platform** → cần lấy được từ native (tên engine + dung lượng model). Xem `initSegmenter` trong contract v0.2.0.
- **Ngôn ngữ ship v1: `en` (mặc định) + `vi` (hỗ trợ)** — toàn bộ copy trong bundle design là tiếng Việt, nên **design là nguồn của `app_vi.arb`**; bản `app_en.arb` phải viết mới theo đúng giọng văn (không dịch máy để nguyên). Mọi chuỗi đi qua ARB, không hardcode (Principle IX). Layout phải kiểm ở cả hai locale vì độ dài chuỗi khác nhau — cụ thể các nhãn ngắn trong thumb band và readout mono.

## Giả định chưa xác nhận

- **Ngưỡng máy tầm thấp**: chưa xác định RAM/chip tối thiểu hỗ trợ chính thức — cần benchmark thực tế trước `Spec #003` (Real-time Preview Engine) để chốt ngưỡng downsample/frame-skip cụ thể. Thông số trong bảng chế độ hiệu năng ở trên là **giá trị khởi điểm từ design**, chưa phải kết quả đo.
- **Model Android**: màn Cài đặt trong design hiển thị `MODNET · TFLITE · 12.4 MB` như placeholder — con số thật phải thay bằng kết quả benchmark ở Spec #002.
- **Độ chính xác viền phức tạp** (lông, tóc, vật trong suốt) — chấp nhận độ chính xác thấp hơn ở v1; app hiển thị `EdgeNotice` (amber, icon `scissors`, **không phải cảnh báo đỏ**) và cho người dùng tự chỉnh bằng sheet Chỉnh viền.
- **Tìm kiếm ở màn Lịch sử** — design có nút tìm kiếm nhưng chưa định nghĩa tìm theo tiêu chí gì (không có tên/tag cho ảnh). Cần chốt ở Spec #007: hoặc bỏ nút, hoặc chỉ lọc theo ngày/trạng thái.
