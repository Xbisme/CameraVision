# Platform Channel Contract — ProductCam

> **Vai trò**: Tương đương `api-context.md` ở project có backend — đây là "hợp đồng" giữa code Dart (Flutter) và code native mỗi platform (Swift/iOS, Kotlin/Android). Suy ra từ [`screen-inventory.md`](screen-inventory.md). Khi thêm/sửa method channel, sửa file này trước, rồi mới code native.
>
> Last updated: 2026-08-14 · Version: **`v0.2.0`** (đồng bộ với bundle design — xem [`screen-inventory.md`](screen-inventory.md))
>
> **Channel name**: `com.productcam.app/segmentation` (MethodChannel), `com.productcam.app/segmentation_stream` (EventChannel cho overlay real-time)

---

## Khác biệt triển khai theo platform (đọc trước khi code native)

| | iOS | Android |
|---|---|---|
| Engine | `Vision` framework — `VNGenerateForegroundInstanceMaskRequest` (subject lifting, class-agnostic, system API) | Model TFLite bundle sẵn trong app (MODNet/U2-Net/ISNet export) chạy qua `MediaPipe Tasks` hoặc trực tiếp TFLite Interpreter |
| Cần bundle model riêng? | KHÔNG — dùng model hệ thống, giảm dung lượng app | CÓ — model TFLite nhúng sẵn, tăng dung lượng app (~10-50MB tuỳ model) |
| Yêu cầu hệ điều hành | **iOS 17.0 — đã chốt** (subject lifting là API iOS 17; xem `decisions/000-min-ios-version.md`) | Không giới hạn OS, nhưng hiệu năng phụ thuộc chip (NNAPI/GPU delegate) — min API chốt cùng benchmark Spec #002 |
| Chất lượng dự kiến | Cao hơn (model do Apple train trên tập dữ liệu lớn, tối ưu Neural Engine) | Phụ thuộc model chọn — cần benchmark cụ thể trước khi chốt model nào (MODNet nhẹ hơn, ISNet chính xác hơn nhưng nặng hơn) |

**Interface Dart phải giống hệt nhau cho cả 2 platform** — mọi khác biệt triển khai nằm ở native code, Dart chỉ gọi qua contract dưới đây.

---

## Method Channel: `com.productcam.app/segmentation`

### `initSegmenter()`
- **Input**: `{}`
- **Output thành công**:
```json
{
  "status": "ready",
  "engine": "vision_framework" | "tflite_modnet_v1",
  "engine_label": "Vision · Subject lifting",
  "model_size_bytes": 0
}
```
  - `engine_label` + `model_size_bytes` phục vụ **màn Cài đặt** (mục "Mô hình tách nền" hiển thị engine đang dùng và dung lượng mô hình). iOS trả `0` vì dùng API hệ thống, không nhúng model. Dart CẤM tự hardcode hai giá trị này (constitution — Principle X).
- **Lỗi**:
  - `MODEL_LOAD_FAILED` (Android only) — không load được model TFLite (file thiếu/corrupt)
  - `UNSUPPORTED_OS_VERSION` (iOS) — dưới iOS 17, cần fallback hoặc báo user
- Gọi 1 lần khi mở Camera Capture screen, trước khi bắt đầu preview.

### `previewFrame(bytes: Uint8List, width: int, height: int, rotation: int)`
- Dùng cho overlay real-time — **input đã downsample sẵn ở phía Dart** (vd 360p) trước khi gửi qua channel, không gửi frame full-res.
- **Output thành công**: `{ "contour_points": [[x, y], [x, y], ...], "confidence": 0.0-1.0 }` — toạ độ contour tính theo tỉ lệ 0.0-1.0 (không phải pixel), để Dart tự scale lên kích thước preview thật.
- **Output khi không phát hiện vật thể rõ ràng**: `{ "contour_points": [], "confidence": 0.0 }` (không phải lỗi — Dart tự ẩn overlay khi mảng rỗng)
- **Lỗi**: `SEGMENTER_NOT_INITIALIZED` — gọi trước `initSegmenter()`
- **Ràng buộc hiệu năng**: Dart chỉ gọi method này theo tần suất của chế độ hiệu năng đang chọn — native code KHÔNG tự ý throttle, trách nhiệm điều tiết thuộc về Dart để nhất quán giữa 2 platform. Giá trị khởi điểm (từ màn Cài đặt trong design, sẽ chốt lại bằng benchmark ở Spec #003/#008):

  | Chế độ | Downsample | Tần suất gọi |
  |---|---|---|
  | Cân bằng (mặc định) | 360p | 1/3 frame |
  | Tiết kiệm pin | 270p | 1/5 frame |
  | Chất lượng cao | 540p | 1/2 frame |

- `confidence` là dữ liệu để Dart chọn trạng thái contour hiển thị: `scanning` (chưa ổn định) → `locked` (ổn định) → `review` (viền phức tạp, tô amber). Ngưỡng chuyển trạng thái do Dart quyết định và phải là hằng có tên, không phải magic number rải trong widget.

### `captureAndSegment(imagePath: String)`
- Chạy segmentation full-res trên ảnh tĩnh đã chụp (path file local).
- **Output thành công**:
```json
{
  "status": "success",
  "mask_png_path": "/path/to/mask_alpha.png",
  "confidence": 0.92,
  "processing_time_ms": 340,
  "edge_complexity_warning": false
}
```
  - `mask_png_path`: file PNG grayscale (alpha mask), Dart tự composite lên ảnh gốc.
  - `edge_complexity_warning: true` — khi model phát hiện vùng viền phức tạp (lông/tóc/trong suốt), Dart hiển thị cảnh báo cho user ở màn Processing/Review.
- **Lỗi**:
  - `SEGMENTATION_FAILED` — không tách được vật thể (ảnh không có subject rõ ràng)
  - `OUT_OF_MEMORY` — máy không đủ RAM xử lý full-res (Dart nên gợi ý thử lại ở độ phân giải thấp hơn)
  - `IMAGE_LOAD_FAILED` — file ảnh input lỗi/không tồn tại

### `dispose()`
- **Input**: `{}` · Giải phóng model/tài nguyên native, gọi khi rời Camera Capture screen.

---

## Những gì KHÔNG đi qua channel (xử lý hoàn toàn phía Dart)

Ranh giới này quan trọng ngang phần trên: mọi thứ dưới đây **không được** thêm method channel mới.

| Việc | Vì sao ở Dart |
|---|---|
| **Chỉnh viền** (thu/giãn viền, làm mềm mép — sheet ở màn Kết quả) | Là phép biến đổi trên mask PNG đã nhận (erode/dilate + feather). Gọi lại native chỉ tốn thêm một vòng xử lý full-res. |
| **Composite nền + bóng đổ** (màn Nền & bóng) | Chỉ là vẽ mask lên nền mới; cần phản hồi tức thì khi kéo slider, không chịu được độ trễ qua channel. |
| **Xuất ảnh** (PNG/JPG/WEBP, 1000/1200/2048 px) | Encode ảnh là việc của Dart/plugin lưu ảnh; native chỉ chịu trách nhiệm tạo mask. |
| **Trạng thái ảnh trong Phiên chụp / Lịch sử** (`queued`/`working`/`done`/`review`/`error`) | Suy ra từ hàng đợi phía Dart + `edge_complexity_warning` + mã lỗi trả về; native không giữ khái niệm "phiên chụp". |
| **Checkerboard, contour overlay, mọi thứ hiển thị** | Thuần trình bày. |

---

## Error Code Catalog (dùng chung cho toàn bộ method channel)

| Code | Platform | Ý nghĩa | Dart nên làm gì |
|---|---|---|---|
| `MODEL_LOAD_FAILED` | Android | Model TFLite không load được | Báo lỗi, gợi ý cài lại app |
| `UNSUPPORTED_OS_VERSION` | iOS | Dưới iOS 17.0 | Chặn tính năng kèm giải thích bằng ngôn ngữ người thường (không hiện mã lỗi thô), không crash. KHÔNG có fallback bundle model cho iOS ở v1. |
| `SEGMENTER_NOT_INITIALIZED` | Cả 2 | Gọi method trước `initSegmenter()` | Lỗi lập trình — không nên xảy ra ở production |
| `SEGMENTATION_FAILED` | Cả 2 | Không tách được vật thể | Cho phép Chụp lại, gợi ý đặt vật thể rõ hơn trên nền tương phản |
| `OUT_OF_MEMORY` | Cả 2 (Android phổ biến hơn) | Không đủ RAM xử lý full-res | Thử lại với ảnh giảm độ phân giải, hoặc báo máy không đủ mạnh |
| `IMAGE_LOAD_FAILED` | Cả 2 | File ảnh input lỗi | Chụp lại |

---

## Performance Budget (ràng buộc bắt buộc, không phải gợi ý)

- `previewFrame` phải trả kết quả trong **≤150ms** ở chế độ Cân bằng trên thiết bị tầm trung (benchmark cụ thể cần làm ở Spec #003) — vượt ngưỡng này, Dart tự động giảm tần suất gọi thay vì để hàng đợi dồn lại.
- `previewFrame` chạy trên **background isolate riêng** (Dart) / **background thread riêng** (native) — không bao giờ block UI thread, kể cả khi xử lý chậm.
- `captureAndSegment` được phép chạy lâu hơn (tới vài giây) nhưng **bắt buộc có progress/loading indicator** ở UI, không để màn hình đứng im không phản hồi.
