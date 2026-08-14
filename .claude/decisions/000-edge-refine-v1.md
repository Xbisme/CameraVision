# Decision 000-B — "Chỉnh viền" thuộc phạm vi v1, xử lý phía Dart

- **Ngày chốt**: 2026-08-14
- **Trạng thái**: ✅ Đã chốt (constitution v1.0.1)
- **Liên quan**: Spec #004 (Capture & Review), Spec #004b (Edge Refine), `platform-channel-contract.md` v0.2.0

## Bối cảnh

Bản `screen-inventory.md` đầu tiên viết: *"tính năng tinh chỉnh viền thủ công có thể cần ở v2, chưa đưa vào roadmap v1"*. Nhưng bundle design đã dựng sẵn sheet **Chỉnh viền** ngay trong màn Kết quả, với hai slider **Thu / giãn viền** (−10…+10 px) và **Làm mềm mép** (0…10 px), và nó là lối thoát duy nhất của cảnh báo `EdgeNotice` khi viền phức tạp.

## Quyết định

1. **Chỉnh viền thuộc v1** — thành Spec `004b-edge-refine`, phụ thuộc #004.
2. **Xử lý hoàn toàn phía Dart** trên mask PNG đã nhận từ `captureAndSegment` (erode/dilate cho thu/giãn + feather cho làm mềm). **KHÔNG thêm method channel, KHÔNG gọi lại native.**

## Lý do

- Rủi ro số 3 trong brief gốc là độ chính xác viền phức tạp (lông/tóc/vật trong suốt), và v1 đã chấp nhận độ chính xác thấp hơn. Nếu chấp nhận viền chưa hoàn hảo mà **không cho người dùng lối sửa**, cảnh báo `EdgeNotice` trở thành ngõ cụt: app nói "viền hơi phức tạp" rồi không đưa ra được việc gì để làm.
- Không có backend và không có bản trả phí, nên cũng không có lý do thương mại nào để đẩy tính năng này sang v2.
- Đặt ở Dart vì đây là phép biến đổi hình thái học trên một mask đã có sẵn trong bộ nhớ. Đẩy qua native sẽ tốn một vòng xử lý full-res mỗi lần kéo slider — phá vỡ yêu cầu preview tức thì và vi phạm Principle V.
- Giữ ranh giới native đúng trách nhiệm: **native chỉ tạo mask, mọi thứ sau đó là việc của Dart** (đã ghi thành mục "Những gì KHÔNG đi qua channel" trong contract v0.2.0).

## Hệ quả

- Contract v0.2.0 **không đổi** vì quyết định này — đó chính là điểm mấu chốt.
- Spec #004b phải xử lý mask ngoài UI isolate (Principle V) và preview cập nhật theo slider không được giật.
- Kết quả chỉnh viền chỉ đổi mép cắt, **không đổi độ phân giải ảnh xuất** (đúng như dòng chú thích trong design).
- Mask sau khi chỉnh phải được lưu để màn Nền & bóng (#005) và Lịch sử (#007) dùng lại đúng bản đã chỉnh, không quay về mask gốc.
