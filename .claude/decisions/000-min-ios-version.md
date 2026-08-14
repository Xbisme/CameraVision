# Decision 000-A — Min iOS = 17.0

- **Ngày chốt**: 2026-08-14
- **Trạng thái**: ✅ Đã chốt (constitution v1.0.1)
- **Liên quan**: Spec #000 (contract freeze), Spec #002b (Segmentation Engine — iOS)

## Bối cảnh

`platform-channel-contract.md` từ đầu đã có mã lỗi `UNSUPPORTED_OS_VERSION` mô tả "dưới iOS 17", còn `project-context.md` vẫn để ngỏ giữa iOS 16 và 17. Màn Cài đặt trong bundle design hiển thị `IOS 17+ · 0 MB` cho mục "Mô hình tách nền". Ba nguồn cùng nghiêng về 17 nhưng chưa ai chốt chính thức.

## Quyết định

**Min iOS = 17.0.**

## Lý do

- `VNGenerateForegroundInstanceMaskRequest` (subject lifting) là API iOS 17. Đây là toàn bộ engine tách nền trên iOS — không có nó thì không còn sản phẩm, chỉ còn một app camera thường.
- Hạ xuống iOS 16 buộc phải bundle thêm một model riêng cho iOS, làm mất lợi thế lớn nhất của bản iOS: **0 MB dung lượng model**. Đồng thời sinh ra một engine thứ ba phải benchmark và bảo trì, trong khi Android đã có một engine chưa chốt.
- Đổi lại là mất một phần thiết bị cũ ở thị trường Việt Nam — chấp nhận, vì người dùng mục tiêu (bán hàng online, chụp ảnh sản phẩm hằng ngày) thường không dùng máy quá cũ, và bản Android phủ phân khúc máy thấp.

## Hệ quả

- Deployment target iOS = 17.0 ở Spec #001.
- `UNSUPPORTED_OS_VERSION` là đường xử lý **bắt buộc**, không phải tuỳ chọn: máy dưới 17.0 phải bị chặn tính năng kèm giải thích rõ ràng bằng ngôn ngữ người thường (Principle III — không hiện mã lỗi thô), tuyệt đối không crash.
- App Store minimum OS version phải khai đúng để máy cũ không tải được rồi mới phát hiện không dùng được.

## Đảo ngược

Hạ xuống iOS 16 sau này là **amendment MINOR** của constitution, kèm kế hoạch fallback (bundle model cho iOS) và ước tính lại dung lượng `.ipa` — không phải thay đổi thường ngày.
