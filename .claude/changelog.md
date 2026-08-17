# Changelog — ProductCam

> Mỗi spec merge vào `main` thêm một entry. Format xem `dev-workflow.md`.
> Giai đoạn trước Spec #001 ghi cả các thay đổi tài liệu nền vì chúng ràng buộc mọi spec sau.

### 2026-08-14 — Spec #001b Design System & Theme 🟡 IMPLEMENTED (chưa merge)

- **Tầng token**: 196 custom property từ 9 file CSS của bundle → 7 file trong `lib/core/theme/tokens/`, phủ đủ, không sót cái nào. Test `token_catalogue_test.dart` đối chiếu theo **tên token CSS** nên xoá một token là không compile được, còn bỏ sót thì lệch số đếm.
- **7 `ThemeExtension`** (`PcColors`/`PcTypography`/`PcSpacing`/`PcRadius`/`PcElevation`/`PcMotion`/`PcContour`) đăng ký trên **một** `ThemeData` tối, đọc qua `context.pcColors`. `lerp` viết thật cho từng field — `lerp` trả về `this` sẽ compile được và làm chết mọi theme transition mà không test đọc-giá-trị nào bắt được.
- **Font tự host**: 6 file TTF (Manrope 400/500/600/700/800 + IBM Plex Mono 500), subset Latin + Vietnamese, **312 KB** — dư ngân sách 1.5 MB. `@import` từ CDN của bundle là dòng duy nhất trong design không thể tôn trọng (Principle VI). Đã kiểm cmap: cả 6 file phủ 90 codepoint dải `U+1EA0-1EF9` + `₫`, **kể cả face mono** — chỗ mà thiếu subset sẽ chỉ lộ ra khi badge `CẦN XEM LẠI` xuất hiện ở production.
- **19 component dùng chung** + **26 icon** vendor từ tag git `lucide 0.474.0`, ghi lại stroke về **1.75** (Lucide ship 2). `PcIcon` nhận enum đóng nên glyph chưa vendor là lỗi biên dịch, không phải ô trắng lúc chạy.
- **Cỡ chữ** tôn trọng tới **1.3×** rồi chặn (`MediaQuery.withClampedTextScaling`); **giảm chuyển động** dừng mọi loop và pulse, ba trạng thái contour vẫn phân biệt được bằng nét đứt.
- **88/88 test không-golden pass**; **68 golden case** đã viết (12 contour × 4 nền tham chiếu, 55 component, 1 charset).
- Cổng `check_no_hardcode.sh` siết từ `lib/core/theme/` xuống `lib/core/theme/tokens/` và thêm luật số đo. **Chạy thử phát hiện 2 bug trong chính cổng** — xem `decisions/001b-design-system-deviations.md` §10.
- Test T067a phát hiện `ThumbBand` **tràn 24px trên máy 320dp**; đã sửa hai khe bên thành co giãn, giữ nguyên vùng chạm 104 của nút chụp.
- **Dung lượng iOS đo bằng build release thật**, so với baseline `main` dựng trong worktree riêng: **15.784 KB → 16.284 KB, delta 500 KB (0,49 MB)** — ngân sách SC-008 là 1,5 MB.
- **Quy đổi blur đã chốt bằng chứng cứ, không phải phỏng đoán**: `Shadow.convertRadiusToSigma(r) = r × 0.57735 + 0.5` đọc thẳng từ `sky_engine/lib/ui/painting.dart:8731`, `BoxShadow.toPaint()` dùng đúng `blurSigma` đó. 5 giá trị suy ra trúng σ mục tiêu trong sai số < 0,003, khoá bằng `blur_conversion_test.dart`.
- **Ba luật thiết kế từng chỉ duyệt bằng mắt nay có cổng tự động** (`design_laws_test.dart`): FR-009 duyệt render tree đếm giá trị nền mỗi màn (≤2), FR-010 đếm nút primary mỗi màn (≤1), FR-027 quét source cấm bounce/spring/elastic/parallax. Cộng kiểm SC-011: pubspec không có `camera`/`gal`/`share_plus`/storage, `lib/` không chạm `CameraController`/`HttpClient`/`File(`.
- **Tách trạng thái contour khi bỏ màu, đo được**: scanning↔locked 7,31% pixel khác, scanning↔review 4,35%, locked↔review 8,96% — Principle XI không còn dựa vào lời hứa.
- **109/109 test không-golden pass.**
- ⚠️ **Còn nợ 2 việc, đều ở ngoài máy dev**: (1) chạy job `update-goldens` trên CI Linux để tạo 68 baseline lần đầu — trước đó test golden đỏ là đúng thiết kế; (2) đi hết quickstart trên máy thật. Ngoài ra dung lượng **Android** vẫn chưa đo được (`flutter doctor` báo không có Android SDK ở `ANDROID_HOME`), và Constitution VIII còn trỏ tới `ui_kits/` không tồn tại — **cần amendment trước Spec #004**.

### 2026-08-14 — Spec #001 Project Foundation ✅ MERGED (PR #1 → `f2c05ae`)

- Khung Flutter chạy được: Clean Architecture feature-first cho 7 khu vực (`lib/core/` + `lib/features/<area>/{domain,data,presentation}`), BLoC/Cubit ở presentation, **không có ViewModel**.
- `sealed AppFailure` (11 biến thể, phủ trọn Error Code Catalog của contract v0.2.0) + `sealed Result<T>` + mapping sang key l10n bằng `switch` vét cạn — thêm biến thể mà quên message thì **không compile được**.
- l10n: `en` (mặc định + template + fallback) và `vi`, ngôn ngữ theo hệ điều hành, không lưu trữ gì.
- 2 flavor: `com.productcam.app.dev` / `com.productcam.app`, tách bằng entry point + Gradle productFlavors + xcconfig. Route `/dev` **chỉ được import bởi `main_development.dart`** → bản production không tham chiếu tới `lib/dev/`.
- Khoá portrait ở cả native (manifest + Info.plist, có key `~ipad`) lẫn Dart.
- Quyền just-in-time, 4 trạng thái (`granted`/`denied`/`permanentlyDenied`/`restricted`), đọc lại khi resume.
- **21/21 test pass**; **6/6 cổng CI đã kiểm chứng fail đúng lúc bị vi phạm** — trong đó 2 cổng ban đầu **im lặng cho qua** và đã phải sửa: script chặn import chéo bị chính đường dẫn file làm nhiễu, và `flutter gen-l10n` bỏ qua tham số dòng lệnh khi có `l10n.yaml`.
- Sai lệch so với plan: `intl` phải là **0.20.2** chứ không phải 0.20.3 — `flutter_localizations` trong SDK pin cứng; ràng buộc SDK thắng phiên bản mới nhất trên pub.
- ⚠️ **Còn nợ 3 task, cần thiết bị Android thật** (merge trước, trả nợ sau): T051 `flutter build apk --release --flavor development` + xác nhận `showsDeveloperSurfaces` vẫn true; T052 cài song song 2 bản trên máy Android thật; T060 đo cold-start kèm model máy + phiên bản OS. Máy dev hiện **chưa cài Android SDK**. Phía iOS của T051 đã kiểm chứng xong (release build của flavor `development` ra `com.productcam.app.dev`).

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
- **Constitution v1.1.1** — chốt nền tảng cho Spec #001: tên app **ProductCam**, bundle id `com.productcam.app.dev` / `com.productcam.app`, **min Android API 24**. Bổ sung vào Principle XV: **flavor ≠ build mode** — phải chạy được release build của flavor `development` để đo hiệu năng thật, cờ bật công cụ đo do flavor quyết định chứ không do `kDebugMode`.
- **`decisions/`**: `000-min-ios-version.md`, `000-edge-refine-v1.md`, `001-app-identity-and-min-sdk.md`.
- ⚠️ Chưa đụng code — repo vẫn chưa có `lib/`. Con số `MODNET · 12.4 MB` trong design là **placeholder**, phải thay bằng kết quả benchmark thật ở Spec #002.
