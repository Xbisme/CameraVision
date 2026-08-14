# Decision 001 — Tên app, bundle id, min Android SDK

- **Ngày chốt**: 2026-08-14
- **Trạng thái**: ✅ Đã chốt (constitution v1.1.1)
- **Liên quan**: Spec #001 (Project Foundation), Spec #002 (Segmentation Engine — Android)

## Quyết định

| | development | production |
|---|---|---|
| Bundle id | `com.productcam.app.dev` | `com.productcam.app` |
| Tên hiển thị | `ProductCam Dev` | `ProductCam` |

- **Tên app: ProductCam** (giữ working name).
- **Min Android API: 24** (Android 7.0).
- Min iOS: 17.0 (đã chốt trước đó — xem `000-min-ios-version.md`).

## Lý do

**Tên/bundle id** — repo GitHub tên `CameraVision`, nhưng toàn bộ tài liệu trong `.claude/` và cả bundle design (wordmark, copy, tên design system) đều dùng "ProductCam". Đổi tên app theo repo sẽ phải sửa ~6 file docs cộng wordmark trong design mà không được lợi gì; tên repo và tên sản phẩm không bắt buộc trùng nhau. **Lệch tên là có chủ ý, không phải lỗi** — ghi lại ở đây để người sau khỏi "sửa cho khớp".

**App id khác nhau giữa 2 flavor** — để cài song song hai bản trên cùng một máy thật. Điều này quan trọng với app này hơn bình thường: Principle V bắt mỗi thay đổi pipeline real-time phải đo lại trên máy Android tầm thấp thật, nên cần giữ một bản đang chạy ổn để so sánh mà không phải gỡ ra cài lại giữa hai lần đo.

**minSdk 24** — cân bằng giữa hai rủi ro:
- Phủ ~97% thiết bị đang hoạt động, đủ rộng cho nhóm người dùng mục tiêu (tiểu thương, máy tầm trung/thấp).
- Chặn API 21–23: nhóm này gần như chắc chắn không đạt ngân sách 150ms/`previewFrame` (Principle V). Cho họ cài được rồi để họ chịu preview giật là cách nhanh nhất kiếm review 1 sao trong khi app không hề chạy sai.
- NNAPI chỉ có từ API 27; dưới đó chạy CPU/GPU delegate. minSdk 24 chấp nhận điều này, và benchmark ở Spec #002 phải đo **cả máy dưới 27** để biết đường lùi có thật sự dùng được không.

## Hệ quả

- `minSdkVersion 24` trong `android/app/build.gradle` ở Spec #001.
- Spec #002 phải benchmark ít nhất một máy API 24–26 (không NNAPI) — nếu model chốt được không chạy nổi ở đó, nâng minSdk là **amendment MINOR** kèm ước tính % thiết bị mất đi, không phải sửa lặng lẽ.
- Android `productFlavors` + iOS scheme/`.xcconfig` dựng theo bảng trên.
