# Changelog — ProductCam

> Mỗi spec merge vào `main` thêm một entry. Format xem `dev-workflow.md`.
> Giai đoạn trước Spec #001 ghi cả các thay đổi tài liệu nền vì chúng ràng buộc mọi spec sau.

### 2026-08-14 — Design alignment + Constitution v1.1.0 ✅ LANDED

- **Constitution v1.0.0** ratify lần đầu tại `.specify/memory/constitution.md` — 15 nguyên tắc cho Flutter/ProductCam: Clean Architecture feature-first + BLoC (**không MVVM**), typed failure, contract-first với native, hiệu năng là ràng buộc kiến trúc, offline tuyệt đối, design system zero-hardcode (style/text/config), touch & tương phản, testing, YAGNI, dependency hygiene, 2 flavor.
- **Constitution v1.0.1** — chốt hai giả định còn treo: **min iOS 17.0** và **Chỉnh viền thuộc v1** (PATCH, không thêm/bớt nguyên tắc).
- **Constitution v1.1.0** — mở rộng Principle IX: app ship **hai ngôn ngữ**, **`en` là mặc định + template + fallback**, `vi` là ngôn ngữ hỗ trợ (trước đó v1 chỉ ship `vi`). Copy tiếng Việt trong design là nguồn của `app_vi.arb`; `app_en.arb` phải viết mới đúng giọng văn, cấm dịch máy để nguyên. Cấm thiếu key ở bất kỳ locale nào; layout kiểm ở cả hai locale.
- **`screen-inventory.md`** viết lại theo bundle design: 7 màn + 3 sheet (Chỉnh viền, Thao tác ảnh, Xuất ảnh), đúng copy tiếng Việt, 5 trạng thái ảnh (`queued`/`working`/`done`/`review`/`error`), dải bố cục cố định (header 56 · thumb band 132 · gutter 16 · grid gap 6).
- **`platform-channel-contract.md` v0.1.0 → v0.2.0**:
  - `initSegmenter` trả thêm `engine_label` + `model_size_bytes` (màn Cài đặt hiển thị thông tin mô hình, Dart không được hardcode).
  - Thêm bảng profile hiệu năng (Cân bằng `360p·1/3` · Tiết kiệm pin `270p·1/5` · Chất lượng cao `540p·1/2`) — giá trị khởi điểm từ design, chốt lại bằng benchmark ở #003/#008.
  - Thêm mục **"Những gì KHÔNG đi qua channel"**: chỉnh viền, composite nền/bóng, export, trạng thái batch đều xử lý phía Dart. Native chỉ chịu trách nhiệm tạo mask.
  - `UNSUPPORTED_OS_VERSION` chuyển từ "fallback hoặc chặn" thành **chặn kèm giải thích**, không có fallback bundle model cho iOS ở v1.
- **`sdd-roadmap.md`**: thêm **#001b Design System & Theme** (phải merge trước mọi spec UI) và **#004b Edge Refine**; cập nhật scope #005 (7 swatch nền + preset bóng), #006 (5 trạng thái + lọc), #007 (PNG/JPG/WEBP · 1000/1200/2048 · Hoàn tác), #008 (thông tin mô hình lấy từ native).
- **`dev-workflow.md`**: thêm **Design Fidelity Check** và cổng grep no-hardcode vào pre-commit; sửa toàn bộ path `docs/` → `.claude/` (thư mục `docs/` không tồn tại).
- **`decisions/`**: `000-min-ios-version.md`, `000-edge-refine-v1.md`.
- ⚠️ Chưa đụng code — repo vẫn chưa có `lib/`. Con số `MODNET · 12.4 MB` trong design là **placeholder**, phải thay bằng kết quả benchmark thật ở Spec #002.
