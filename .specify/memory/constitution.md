<!--
================================================================================
SYNC IMPACT REPORT
================================================================================
Version Change: (placeholder template) → 1.0.0 (initial ratification)
                1.0.0 → 1.0.1 (chốt min iOS 17.0 + Chỉnh viền thuộc v1)
                1.0.1 → 1.1.0 (ship EN + VI; `en` là mặc định và fallback)

v1.1.0 (2026-08-14): Principle IX được mở rộng đáng kể. App ship **hai ngôn
ngữ**: **`en` là ngôn ngữ mặc định + template locale + fallback**, `vi` là ngôn
ngữ được hỗ trợ (trước đó v1 chỉ ship `vi`). Kèm theo: cấm thiếu key ở bất kỳ
locale nào, copy tiếng Việt trong design là nguồn của `app_vi.arb` chứ không
phải `app_en.arb` (bản EN phải viết mới đúng giọng văn, cấm dịch máy để nguyên),
và layout phải kiểm tra ở cả hai locale. MINOR — mở rộng một nguyên tắc đã có,
không bỏ nguyên tắc nào.

v1.0.1 (2026-08-14): Hai follow-up TODO được chốt và chuyển thành ràng buộc:
(a) **min iOS = 17.0** — trước đó là giả định; nay là mốc chính thức, kéo theo
`UNSUPPORTED_OS_VERSION` trong contract là đường xử lý bắt buộc chứ không phải
tuỳ chọn (xem `.claude/decisions/000-min-ios-version.md`); (b) **Chỉnh viền
thủ công thuộc phạm vi v1**, xử lý hoàn toàn phía Dart, KHÔNG thêm method
channel (xem `.claude/decisions/000-edge-refine-v1.md`). PATCH — làm rõ giả
định đã có, không thêm/bớt nguyên tắc nào.

v1.0.0 (2026-08-14): Ratify lần đầu. Đây là constitution cho ProductCam —
camera tách nền real-time cho ảnh sản phẩm, 1 repo Flutter duy nhất, KHÔNG
backend, KHÔNG tài khoản, 100% xử lý on-device. Toàn bộ nguyên tắc được viết
riêng cho domain này; không bê nguyên văn từ project khác. Chỗ nào "vần" với
constitution của một project SwiftUI thì nội dung đã được viết lại cho Flutter
+ BLoC + platform channel.

Newly Added Principles:
- I.    Clean Architecture Feature-First (KHÔNG MVVM — BLoC là lớp trình bày)
- II.   BLoC & Unidirectional State
- III.  Typed Failure (Result + AppFailure)
- IV.   Platform-Channel Contract Là Nguồn Chân Lý Dart ↔ Native
- V.    Hiệu Năng Là Ràng Buộc Kiến Trúc (NON-NEGOTIABLE)
- VI.   On-Device, Offline, Không Tài Khoản, Không Backend
- VII.  Design System & Theming — KHÔNG Hardcode Style
- VIII. Design Fidelity — UI Bám Bundle Design
- IX.   Không Hardcode Chuỗi Hiển Thị (l10n)
- X.    Không Hardcode Cấu Hình & Magic Value
- XI.   Touch, Tương Phản & Trạng Thái Không Chỉ Bằng Màu
- XII.  Testing Discipline
- XIII. Simplicity & YAGNI
- XIV.  Dependency Hygiene
- XV.   Build Flavors (ĐÚNG development + production)

Templates Requiring Updates:
- .specify/templates/plan-template.md ✅ (mục Constitution Check chung vẫn đúng,
  không có tham chiếu principle inline cần sửa)
- .specify/templates/spec-template.md ✅ (không có mục gắn principle cụ thể)
- .claude/sdd-roadmap.md ✅ (đã bổ sung Spec #001b Design System & Theme để
  thoả Principle VII/VIII, và Spec #004b Edge Refine theo design)
- .claude/dev-workflow.md ✅ (đã bổ sung Design Fidelity Check + cổng
  no-hardcode vào pre-commit)
- .claude/screen-inventory.md ✅ (đã viết lại theo bundle design)

Follow-up TODOs:
- **Tên sản phẩm** vẫn là working name "ProductCam"; bundle id chưa chốt. Đề
  xuất theo flavor: development `com.productcam.app.dev`, production
  `com.productcam.app` — cần confirm trước Spec #001.
- ~~Min iOS~~ **ĐÃ CHỐT 2026-08-14: iOS 17.0** (v1.0.1). Hạ xuống iOS 16 sau
  này là amendment MINOR kèm kế hoạch fallback, không phải thay đổi thường ngày.
- **Model Android** chưa chốt (MODNet / ISNet / U2-Net). Màn Cài đặt trong
  design đang hiển thị `MODNET · TFLITE · 12.4 MB` như một placeholder — con số
  này KHÔNG phải quyết định, phải thay bằng kết quả benchmark thật ở Spec #002.
- **Fonts**: Manrope + IBM Plex Mono (bản Vietnamese subset) chưa có file
  binary trong repo. Principle VI cấm tải font qua mạng lúc runtime → phải
  nhúng file vào `assets/fonts/` ở Spec #001b.
- **Icon set**: design dùng Lucide như một bản thay thế được đánh dấu rõ. Nếu
  sau này có bộ icon riêng, chỉ được sửa 1 file wrapper `PcIcon` (Principle VII).
- **PRD**: `.claude/` chưa có `PRD.md`. Trước khi có, nguồn chân lý sản phẩm là
  `.claude/project-context.md` + `.claude/screen-inventory.md` + bundle design.
================================================================================
-->

# ProductCam Constitution

> Working name: "ProductCam" — camera tách nền real-time cho ảnh sản phẩm, dành
> cho người bán hàng online, tiểu thương, freelancer.
> Lợi thế cạnh tranh duy nhất: **thấy viền vật thể ngay trên khung hình trước
> khi bấm chụp**. Mọi quyết định kỹ thuật phải phục vụ điều đó.
> 1 repo Flutter · iOS + Android + tablet · KHÔNG backend · KHÔNG tài khoản ·
> KHÔNG paywall · 100% xử lý on-device, chạy được khi không có mạng.

## Core Principles

### I. Clean Architecture Feature-First (KHÔNG MVVM — BLoC là lớp trình bày)

Code được tổ chức **theo feature**, mỗi feature có đúng 3 lớp `domain` →
`data` → `presentation`. **KHÔNG dùng MVVM**: BLoC/Cubit đã là lớp quản lý
state của presentation, thêm một tầng ViewModel nữa là trùng lặp vô ích và bị
CẤM.

- Layout bắt buộc:
  ```
  lib/
    core/
      error/          AppFailure, Result<T>
      platform/       MethodChannel/EventChannel wrapper (ranh giới native duy nhất)
      di/             composition root (get_it/injectable) — khai báo 1 chỗ
      theme/          design tokens + ThemeExtension (Principle VII)
      l10n/           ARB + generated localization (Principle IX)
      config/         flavor/config (Principle X, XV)
      widgets/        component dùng chung của design system (Principle VII)
    features/<feature>/
      domain/
        entities/       model thuần Dart, không import Flutter, không fromJson
        repositories/   ABSTRACT interface (hợp đồng mà bloc phụ thuộc vào)
        usecases/       CHỈ khi có orchestration nhiều bước (xem bên dưới)
      data/
        models/         DTO — khớp 1:1 payload platform channel / bảng DB
        datasources/    native (qua core/platform), local (file, SQLite/Hive)
        repositories/   IMPLEMENTATION của interface trong domain
        mappers/        DTO ↔ entity
      presentation/
        bloc/           bloc|cubit + event + state
        pages/          Page/Screen
        widgets/        widget riêng của feature
  ```
- **Chiều phụ thuộc một chiều**: `presentation` → `domain` ← `data`.
  `domain` KHÔNG được import `data`, KHÔNG import `flutter/*`, KHÔNG biết gì về
  platform channel, JSON hay database.
- **Bloc PHẢI phụ thuộc vào interface repository trong `domain`**, không bao giờ
  phụ thuộc vào implementation hoặc datasource cụ thể. Inject bằng constructor
  qua composition root — không service locator gọi rải rác trong widget.
- Một feature KHÔNG được import file nội bộ của feature khác. Muốn dùng chung
  thì đưa lên `core/` hoặc đi qua interface trong `domain`.
- **KHÔNG viết UseCase cho mỗi thao tác đơn lẻ.** Một class chỉ để gọi lại đúng
  một hàm repository là ceremony thừa. UseCase CHỈ hợp lệ khi thật sự
  orchestration nhiều bước — ví dụ `ProcessCapturedPhoto` (gọi native
  segmentation → composite mask lên nền → ghi file → ghi history) hoặc
  `ProcessBatchQueue`. Ngoài các ca đó, bloc gọi thẳng repository.
- Ảnh và mask là **file trên đĩa**, entity chỉ giữ đường dẫn + metadata. CẤM
  nhét `Uint8List` ảnh full-res vào state của bloc (xem Principle V).

**Rationale**: App này chỉ có một luồng nghiệp vụ chính (chụp → tách → đổi nền →
xuất) nhưng có hai bộ code native khác nhau phía dưới. Tách domain khỏi data là
cách duy nhất để đổi engine Android (MODNet → ISNet) hay đổi API Vision mà
không đụng vào UI. Còn MVVM chồng lên BLoC thì chỉ tạo ra hai chỗ giữ state cho
cùng một màn hình.

### II. BLoC & Unidirectional State

Mọi state của màn hình chảy một chiều: **UI → event → Bloc → state → UI**.

- Mỗi màn hình/surface có đúng một `Bloc` hoặc `Cubit`. Dùng `Bloc` khi luồng
  có nhiều sự kiện rời rạc cần truy vết (camera, batch queue); dùng `Cubit` cho
  state đơn giản (settings, editor sliders).
- State PHẢI là **immutable** và mô hình hoá bằng **sealed class / union**
  (`Initial | Loading | Ready | Failure`) hoặc một class có `copyWith` — CẤM
  một mớ `bool` rời rạc có thể mâu thuẫn nhau (`isLoading && hasError`).
- Widget CẤM chứa logic nghiệp vụ: không gọi platform channel, không parse dữ
  liệu, không tính toán mask/composite trong `build()`. Widget chỉ đọc state và
  bắn event.
- `setState` chỉ được dùng cho state thuần trình diễn, cục bộ trong một widget
  (animation controller, trạng thái nhấn giữ, mở/đóng sheet). Không dùng
  `setState` cho bất cứ dữ liệu nào đến từ domain.
- Side effect (mở system settings, lưu ảnh vào thư viện, chia sẻ, hiển thị
  toast) được phát ra từ bloc dưới dạng state/stream rời rạc rồi widget mới
  thực thi — không gọi thẳng trong `build()`.
- **Bắt buộc `dispose`**: camera controller, isolate, stream subscription,
  `ImageStream`. Rò rỉ ở màn Camera là lỗi chặn merge, không phải nợ kỹ thuật.

**Rationale**: Màn Camera vừa chạy stream frame liên tục, vừa nhận kết quả
segmentation bất đồng bộ, vừa chồng batch queue chạy nền. Không có một chiều
duy nhất thì các nguồn state này sẽ đá nhau và bug chỉ hiện trên máy thật.

### III. Typed Failure (Result + AppFailure)

Mọi thao tác có thể lỗi PHẢI trả về failure có kiểu, không để exception thô nổi
lên UI. `throw` chỉ dành cho lỗi lập trình.

- `core/error/` PHẢI định nghĩa `AppFailure` (sealed) phủ tối thiểu:
  `modelLoadFailed`, `unsupportedOsVersion`, `segmenterNotInitialized`,
  `segmentationFailed`, `outOfMemory`, `imageLoadFailed`, `permissionDenied`,
  `permissionPermanentlyDenied`, `storageFull`, `exportFailed`,
  `unknown(cause)`. Danh sách này PHẢI phủ trọn Error Code Catalog trong
  `.claude/platform-channel-contract.md` (Principle IV).
- Repository trả `Result<T>` (hoặc `Either<AppFailure, T>`); bloc map failure
  thành state `Failure(AppFailure)`.
- **Chuỗi hiển thị cho lỗi PHẢI đi qua mapping `AppFailure` → key l10n**
  (Principle IX). CẤM hiển thị `e.toString()`, `PlatformException.message`, hay
  mã lỗi native cho người dùng.
- Giọng văn lỗi theo design: nói sự thật + cho lối thoát. Viền chưa đẹp là
  **"phức tạp"** chứ không phải **"lỗi"**; chữ "lỗi" chỉ dành cho thất bại xử lý
  thật sự có thể thử lại. Không đổ lỗi cho người dùng, không kịch tính hoá.

**Rationale**: Người dùng mục tiêu không rành kỹ thuật. `OUT_OF_MEMORY` bắn
thẳng lên màn hình vừa vô nghĩa vừa làm họ nghĩ mình làm hỏng gì đó. Một kiểu
lỗi đóng buộc mỗi ca phải được xử lý và dịch có chủ đích.

### IV. Platform-Channel Contract Là Nguồn Chân Lý Dart ↔ Native

`.claude/platform-channel-contract.md` đóng vai trò như API contract ở project
có backend. Nó cao hơn spec lẻ khi xung đột.

- Đổi channel (thêm/bớt field, đổi tên method, đổi mã lỗi) → **sửa contract
  TRƯỚC**, tăng version contract, rồi mới code native.
- **Cả hai bên native phải khớp trong CÙNG một PR**: `ios/.../SegmentationEngine.swift`
  VÀ `android/.../SegmentationEngine.kt`. Dart chỉ có một interface duy nhất cho
  cả hai platform — merge lệch một bên là lỗi chặn merge.
- Toàn bộ lời gọi native đi qua **một wrapper duy nhất** trong `core/platform/`.
  CẤM `MethodChannel('...')` rải rác trong feature; CẤM tên channel/method viết
  chuỗi thẳng tại call site (Principle X).
- Khác biệt triển khai (Vision subject lifting vs TFLite) nằm hoàn toàn bên
  native. Dart CẤM `if (Platform.isIOS)` để đổi hành vi nghiệp vụ; chỉ chấp nhận
  ở tầng trình bày cho khác biệt bắt buộc của HĐH (ví dụ luồng xin quyền).
- Contract cũng ràng buộc **đơn vị**: contour trả về toạ độ tỉ lệ `0.0–1.0`,
  không phải pixel. Bên nào trả pixel là vi phạm contract.

**Rationale**: Một contract, hai bộ code native, không có CI nào tự bắt được
lệch pha. Chỉ có kỷ luật "sửa contract trước, cập nhật cả hai bên cùng lúc" mới
giữ được app hành xử giống nhau trên hai platform.

### V. Hiệu Năng Là Ràng Buộc Kiến Trúc (NON-NEGOTIABLE)

Đây là rủi ro số 1 của sản phẩm, không phải bảo mật. App không có dữ liệu nhạy
cảm; thứ giết app là giật lag trên máy tầm thấp.

- **CẤM tuyệt đối chạy segmentation, decode, composite hay encode ảnh trên UI
  thread/main isolate.** Dart dùng isolate riêng (`compute`/`Isolate.run`/worker
  bền); native chạy background thread riêng.
- **Ngân sách `previewFrame` ≤ 150ms** ở chế độ Cân bằng trên máy tầm trung.
  Vượt ngưỡng → Dart tự giảm tần suất gọi, TUYỆT ĐỐI không để hàng đợi frame dồn
  lại. Native KHÔNG tự throttle — việc điều tiết thuộc về Dart để hai platform
  hành xử giống nhau.
- **Frame gửi qua channel phải được downsample trước ở Dart**, theo profile hiệu
  năng đang chọn (giá trị mặc định lấy từ màn Cài đặt trong design, sẽ chốt lại
  bằng benchmark ở Spec #003/#008):

  | Chế độ | Độ phân giải | Tần suất |
  |---|---|---|
  | Cân bằng (mặc định) | 360p | 1/3 frame |
  | Tiết kiệm pin | 270p | 1/5 frame |
  | Chất lượng cao | 540p | 1/2 frame |

- **Chế độ hiệu năng KHÔNG được ảnh hưởng chất lượng ảnh xuất.** Nó chỉ đổi tốc
  độ/độ phân giải của viền xem trước. Ảnh xuất luôn ở chất lượng cao nhất.
- Overlay contour PHẢI vẽ bằng `CustomPainter` trong `RepaintBoundary`, được
  điều khiển bằng `ValueListenable`/stream — CẤM rebuild cả cây widget của màn
  Camera mỗi khi có contour mới.
- Bộ nhớ ảnh: mask và ảnh gốc giữ dưới dạng file, giải phóng `ui.Image` sau khi
  dùng, không giữ hai bản full-res cùng lúc. `OUT_OF_MEMORY` phải được xử lý
  như một trạng thái bình thường, không phải crash.
- Batch mode: chụp tiếp KHÔNG bao giờ bị chặn bởi việc xử lý ảnh trước; xử lý
  chạy trong queue nền, tiến độ hiện trên lưới thumbnail.
- **Spec nào đụng `previewFrame`/pipeline real-time PHẢI đo lại trên ít nhất 1
  máy Android tầm thấp THẬT** và ghi số đo vào Definition of Done. Simulator/máy
  dev mạnh KHÔNG phải bằng chứng.
- **Theo dõi dung lượng app** (`.apk`/`.ipa`) sau mỗi spec đụng model Android;
  tăng bất thường phải báo ngay trong PR.

**Rationale**: Cả sản phẩm được bán bằng một câu: "thấy viền trước khi chụp".
Nếu preview giật hoặc app chết trên máy phổ thông của tiểu thương thì mọi tính
năng còn lại đều vô nghĩa.

### VI. On-Device, Offline, Không Tài Khoản, Không Backend

App PHẢI chạy đầy đủ khi tắt hoàn toàn mạng. Đây vừa là cam kết sản phẩm vừa là
tuyên bố về quyền riêng tư.

- KHÔNG backend, KHÔNG đăng nhập, KHÔNG đồng bộ đám mây, KHÔNG paywall/IAP.
  Thêm bất kỳ thứ nào trong số đó là thay đổi MAJOR, cần amendment.
- **CẤM mọi lời gọi mạng lúc runtime** — kể cả tải model, tải font, tải icon,
  analytics, crash reporting bên thứ ba, remote config. Font (Manrope, IBM Plex
  Mono bản Vietnamese subset) và model TFLite PHẢI nhúng trong assets; CẤM dùng
  `google_fonts` ở chế độ tải qua mạng.
- Ảnh, mask, metadata history nằm hoàn toàn trong storage của app (file system +
  SQLite/Hive). Chỉ rời khỏi app khi người dùng chủ động Lưu vào máy hoặc Chia sẻ.
- Quyền được xin **đúng lúc dùng**: camera khi mở màn Camera, thư viện ảnh khi
  bấm Lưu — không xin gộp lúc khởi động. Lý do hiển thị phải mô tả đúng việc app
  làm.
- Màn Cài đặt PHẢI nói thật về nơi lưu trữ và về việc không có đồng bộ đám mây
  (design đã chốt các dòng này).

**Rationale**: Người bán hàng chụp ảnh sản phẩm ở kho, ở chợ, chỗ sóng yếu.
Offline không phải tính năng phụ mà là điều kiện dùng được. Không tài khoản +
không mạng cũng khiến "ảnh của bạn không đi đâu cả" là sự thật kiểm chứng được,
không phải khẩu hiệu marketing.

### VII. Design System & Theming — KHÔNG Hardcode Style

Toàn bộ giá trị hình ảnh PHẢI đến từ tầng token sinh ra từ bundle design. **Zero
hardcode style** là quy tắc cứng, review được, không phải khuyến nghị.

- Token trong `.claude/design/.../tokens/*.css` được port 1:1 sang
  `lib/core/theme/tokens/`: `pc_colors.dart`, `pc_typography.dart`,
  `pc_spacing.dart`, `pc_radius.dart`, `pc_elevation.dart`, `pc_motion.dart`,
  `pc_contour.dart`. **Chỉ những file này được phép chứa literal thô**
  (`Color(0xFF1FE3C2)`, `16.0`, `Duration(milliseconds: 220)`).
- Token được phơi ra qua `ThemeExtension`: `PcColors`, `PcSpacing`, `PcRadius`,
  `PcTypography`, `PcElevation`, `PcMotion`, `PcContour`. Call site đọc qua
  `Theme.of(context)` (khuyến khích extension `context.pcColors`).
- Tại call site, CẤM:
  - literal màu: `Color(0xFF...)`, `Colors.white`, `Colors.blue`, ...
  - `TextStyle(fontSize: ..., fontWeight: ...)` viết tay — phải lấy từ
    `PcTypography` (`display / h1 / h2 / h3 / body / bodyStrong / caption /
    button / readout / readoutSm`);
  - số đo rời rạc: `EdgeInsets.all(13)`, `SizedBox(height: 22)`,
    `BorderRadius.circular(9)` — phải là token `sp*`, `r*`, `touch*`;
  - `Duration`/`Curve` viết tay cho animation — phải lấy từ `PcMotion`.
- **Bảng màu ngữ nghĩa là luật**: mint (`--mint-500`) là màu tín hiệu duy nhất,
  chỉ dùng cho phản hồi của máy (contour, khoá viền, tiến độ, lựa chọn) và cho
  **một** hành động chính mỗi màn. Amber = "cần xem lại", KHÔNG BAO GIỜ là lỗi.
  Coral = lỗi thật. Tối đa 2 giá trị nền trên một màn (`bg-app` +
  `bg-surface`/`bg-surface-raised`).
- App khoá **chrome tối** (`ThemeMode.dark`) trong v1 — design đã bác bỏ light
  UI vì màn chính là feed camera. Bề mặt sáng chỉ tồn tại ở checkerboard trong
  suốt và preview ảnh xuất. Thêm light theme là amendment.
- **Component dùng chung nằm trong `core/widgets/`, không tái hiện theo màn**:
  `PcButton`, `PcIconButton`, `PcChip`, `PcBadge`, `PcSheet`, `PcIcon`,
  `PcSlider`, `PcToast`, `EdgeNotice`, `Readout`, `ShutterButton`, `ModeToggle`,
  `ContourOverlay`, `CheckerSurface`, `BackgroundSwatchPicker`, `BatchThumb`,
  `ProgressTrace`, `ScreenHeader`, `ThumbBand` — ánh xạ 1:1 với 16 primitive +
  shell của bundle design.
- Icon đi qua **một wrapper `PcIcon` duy nhất** (hiện dùng Lucide, stroke 1.75,
  monochrome, thừa kế màu hiện hành). Đổi bộ icon sau này chỉ được đụng 1 file.
  **CẤM emoji và CẤM ký tự unicode thay cho icon** ở mọi nơi trong app.
- Chữ số máy móc (kích thước, dung lượng, số ảnh, thời lượng, chỉ số ảnh) PHẢI
  set bằng font mono, UPPERCASE, tracking `.08em`. Văn xuôi TUYỆT ĐỐI không set
  bằng mono; readout không set bằng font UI.
- Contour PHẢI vẽ hai nét (halo tối 6px dưới, lõi mint 2.5px trên). CẤM vẽ một
  nét — một nét đơn sẽ biến mất trên nền trắng hoặc nền tối tuỳ cảnh.

**Rationale**: Engine tách nền thì ai cũng copy được; thứ khó copy là hệ thống
hình ảnh và cảm giác "thiết bị đo" của app. Đồng thời, một tầng token duy nhất
là cách duy nhất để đổi màu/khoảng cách toàn app mà không phải đi sửa 40 file
và bỏ sót 3 chỗ.

### VIII. Design Fidelity — UI Bám Bundle Design

Bundle trong `.claude/design/` là nguồn chân lý về giao diện. Đã có design
thì KHÔNG tự chế layout mới.

- Mỗi màn hình PHẢI khớp với màn tương ứng trong `.claude/design/project/`
  (`ProductCam App.html`, `pc-screens.jsx`, `_ds/.../ui_kits/productcam-app/`)
  về: cấu trúc, thứ tự các khối, vị trí hành động chính, trạng thái, và copy
  tiếng Việt.
- Prototype là HTML/CSS/JS — **tái hiện kết quả hình ảnh, không bê cấu trúc
  nội bộ**. Không cần và không nên dịch từng `div` thành một widget.
- Các dải bố cục cố định là bắt buộc: header 56px, **thumb band 132px ở đáy giữ
  mọi hành động chính**, gutter 16px, khoảng cách lưới thumbnail 6px. **CẤM đặt
  hành động phá huỷ (xoá) trong thumb band.**
- Khi design mâu thuẫn với doc cũ: **design thắng về UI**;
  `platform-channel-contract.md` thắng về ranh giới Dart↔Native; PRD/product
  context thắng về phạm vi sản phẩm. Xung đột phải được ghi nhận vào
  `.claude/decisions/` chứ không im lặng chọn một bên.
- Muốn thêm màn hình/luồng chưa có trong design → dừng lại, hỏi, cập nhật
  `.claude/screen-inventory.md` trước khi code.

**Rationale**: Design đã giải xong bài toán khó nhất của app này (bố cục một
tay, chrome không che vật thể, trạng thái đọc được trên nền camera bất kỳ). Đi
chệch khỏi nó trong lúc code là làm lại từ đầu bằng thông tin ít hơn.

### IX. Không Hardcode Chuỗi Hiển Thị (l10n)

Mọi chuỗi người dùng đọc được PHẢI đi qua tầng localization. Không có ngoại lệ
cho "chuỗi tạm" hay "màn debug sẽ xoá sau".

- Chuỗi nằm trong ARB (`lib/core/l10n/app_vi.arb`, …), truy cập qua
  `AppLocalizations` đã generate. **CẤM string literal hiển thị trong widget**,
  kể cả nhãn nút, tiêu đề, placeholder, nội dung toast, thông báo lỗi và
  `semanticsLabel`.
- **Ngôn ngữ mặc định là tiếng Anh (`en`); tiếng Việt (`vi`) là ngôn ngữ được
  hỗ trợ.** Cả hai đều ship ở v1. `en` là **template locale** (nguồn của
  `app_en.arb`) và là **fallback** khi thiếu key hoặc khi locale hệ thống không
  phải `vi`. Máy đặt tiếng Việt hiển thị tiếng Việt.
- **Không được thiếu key ở bất kỳ locale nào.** Thiếu key thì rơi về `en` — đó
  là lưới an toàn, không phải cách làm việc. `flutter analyze` phải sạch cảnh
  báo l10n trước khi merge.
- Cấu trúc phải cho phép thêm locale mới mà **không đụng vào widget nào** —
  thêm locale chỉ là thêm file ARB.
- **Copy tiếng Việt trong bundle design là nguồn của `app_vi.arb`**, không phải
  của `app_en.arb`. Bản tiếng Anh phải được viết mới theo đúng giọng văn ở
  Principle VIII/IX (câu trần thuật ngắn, không tính từ quảng cáo, không dấu
  chấm than, nhãn nút 1–3 từ) — **CẤM dịch máy rồi để nguyên**.
- Chuỗi hai ngôn ngữ dài ngắn khác nhau: layout PHẢI được kiểm tra ở CẢ HAI
  locale (nút không tràn, readout không xuống dòng). Golden test cho màn chính
  chạy ít nhất một locale mỗi ngôn ngữ.
- Số/ngày/dung lượng dùng formatter theo locale (`intl`), không tự nối chuỗi.
  Riêng readout dạng máy (`1200×1200`, `PNG · 340 KB`, `04 / 12`) theo đúng quy
  ước typographic ở Principle VII.
- Giọng văn theo design: câu trần thuật ngắn, ngôi thứ hai ngầm, không tính từ
  quảng cáo, không dấu chấm than, không emoji. Nhãn nút 1–3 từ, readout 1–4 từ.
- Sentence case cho câu do người viết; UPPERCASE chỉ ở readout mono và badge
  (`XONG`, `CẦN XEM LẠI`).

**Rationale**: App ship hai ngôn ngữ ngay từ v1, nên mọi chuỗi hardcode là một
lỗi hiển thị đang chờ xảy ra chứ không phải nợ kỹ thuật có thể trả sau. Chuỗi
hardcode luôn được biện minh là "tạm" rồi ở lại tới lúc phát hành. Ngoài ra
copy tiếng Việt đã được viết sẵn trong design — chép thẳng vào widget là tự
đánh mất chỗ duy nhất để sửa giọng văn cho cả hai ngôn ngữ.

### X. Không Hardcode Cấu Hình & Magic Value

Ngoài style và chuỗi, mọi hằng số có ý nghĩa nghiệp vụ cũng phải có tên và có
một chỗ ở.

- Tên channel, tên method, mã lỗi, key lưu trữ, tên bảng/box, tên file model
  PHẢI là hằng có tên trong `core/platform/` hoặc `core/config/` — CẤM chuỗi thô
  tại call site.
- Ngưỡng hiệu năng (độ phân giải downsample, tần suất frame, timeout, kích thước
  xuất, chất lượng nén) PHẢI là hằng có tên/enum profile — CẤM `360`, `0.33`,
  `2048` rơi giữa logic.
- Giá trị phụ thuộc môi trường (flavor, mức log, cờ bật benchmark) đọc từ tầng
  config theo flavor (Principle XV), KHÔNG rải `kDebugMode` khắp code feature.
- Đường dẫn/thư mục lấy qua `path_provider` + helper tập trung, không ghép chuỗi
  đường dẫn thủ công trong feature.

**Rationale**: Magic value là thứ luôn tồn tại ở hai bản sao lệch nhau — một
trong Dart, một trong native — và bug do lệch ngưỡng thì chỉ hiện trên một dòng
máy nào đó ngoài thị trường.

### XI. Touch, Tương Phản & Trạng Thái Không Chỉ Bằng Màu

App được dùng một tay, ngoài trời, trong lúc tay kia đang cầm sản phẩm.

- Kích thước chạm là mức tối thiểu cứng: **44px tối thiểu, 56px thoải mái, nút
  chụp 80px hiển thị trong vùng chạm 104px**, không có gì bấm được trong bán
  kính 12px quanh nút chụp.
- Trạng thái KHÔNG BAO GIỜ chỉ được truyền tải bằng màu. Contour phân biệt bằng
  nét đứt + chuyển động (`scanning` = nét chạy, `locked` = nét liền + nhịp
  sáng, `review` = chấm amber). Badge có chấm + chữ, không chỉ có màu.
- Chữ trên feed camera PHẢI nằm trên scrim gradient hoặc nền kính
  (`--bg-glass` + blur), không bao giờ đặt trần trên video.
- Mọi control PHẢI có `Semantics`/`semanticsLabel` lấy từ l10n; icon-only button
  bắt buộc có nhãn.
- Tôn trọng cài đặt hệ thống: cỡ chữ (layout không được vỡ ở text scale lớn) và
  giảm chuyển động (`MediaQuery.disableAnimations` → tắt hiệu ứng chạy nét,
  giữ nguyên ý nghĩa trạng thái bằng hình dạng).
- Chuyển động là phản hồi, không phải trang trí: 90ms nhấn, 140ms đổi màu,
  220ms sheet, 380ms nhịp khoá. Vòng lặp duy nhất trong app là contour trace
  1.1s và nó là đèn báo trạng thái. CẤM bounce, spring, parallax, motion trang trí.

**Rationale**: Đây là dụng cụ lao động, dùng lặp lại hàng chục lần mỗi phiên.
Nút nhỏ hoặc trạng thái chỉ phân biệt bằng sắc độ sẽ hỏng ngay ngoài nắng, trên
máy màn hình kém, hoặc với người dùng mù màu.

### XII. Testing Discipline

Domain và data phải được unit test kỹ; bloc test theo chuyển trạng thái; UI test
có trọng điểm; hiệu năng đo trên máy thật.

- Unit test bắt buộc cho: mapper DTO ↔ entity, mọi implementation repository
  (với datasource fake), mapping `AppFailure`, logic composite nền/bóng đổ,
  logic hàng đợi batch, tính toán downsample/frame-skip.
- **Mọi Bloc/Cubit PHẢI có test** (`bloc_test`) phủ đủ chuyển trạng thái, gồm
  cả nhánh failure.
- Contract test cho tầng platform: mock `MethodChannel` để khẳng định Dart gửi
  đúng tên method/payload và parse đúng response + mọi mã lỗi trong catalog.
- **Golden test** cho component design system và cho các màn chính, để bắt hồi
  quy hình ảnh khi đổi token.
- Test PHẢI tất định: không phụ thuộc mạng (app vốn không có mạng), không phụ
  thuộc camera thật, không phụ thuộc thời gian thực (inject clock).
- Spec đụng real-time: DoD PHẢI ghi số đo `previewFrame` (p50/p95) trên máy
  Android tầm thấp thật + FPS preview.
- Độ phủ đánh giá theo đường đi quan trọng, không theo con số phần trăm cứng.

**Rationale**: Hai chỗ bug âm thầm tệ nhất là mask sai (ảnh xuất hỏng mà không
ai báo lỗi) và hiệu năng tụt (chỉ hiện trên máy yếu ngoài thị trường). Cả hai
đều phải được chặn bằng test và bằng phép đo trên phần cứng thật.

### XIII. Simplicity & YAGNI

App làm đúng một việc: chụp → tách nền → đổi nền → xuất. Độ phức tạp phải được
biện minh bằng nhu cầu cụ thể, hiện tại.

- Chọn cách làm đơn giản nhất chạy được; ba dòng lặp lại tốt hơn một abstraction
  sớm.
- CẤM thêm (nếu không có spec yêu cầu rõ): tài khoản, đồng bộ đám mây, mạng xã
  hội, analytics, remote config, hệ thống feature flag, editor ảnh đầy đủ.
- Ưu tiên thư viện chuẩn/Flutter first-party khi năng lực tương đương
  (Principle XIV).
- Tính năng chỉ hợp lệ khi có mặt trong `.claude/screen-inventory.md` hoặc
  trong bundle design; ý tưởng ngoài phạm vi phải qua roadmap trước.

**Rationale**: Người dùng mở app ra để xong việc rồi đóng lại. Mỗi tính năng
thêm vào đều đổi bằng dung lượng, thời gian khởi động và một chỗ nữa có thể
chậm trên máy yếu.

### XIV. Dependency Hygiene

Mọi package mới PHẢI được tra từ nguồn chính thức (pub.dev), không đoán tên,
không copy version từ project khác.

- Pin version trong `pubspec.yaml`, commit `pubspec.lock`. Kiểm tra: null-safety,
  còn được bảo trì, hỗ trợ đủ cả iOS/Android, kích thước đóng góp vào app.
- Package nào **không tồn tại đúng tên/URL đã ghi thì DỪNG và hỏi** — không thay
  bằng package "na ná".
- Mỗi package mới phải nêu lý do trong PR + ảnh hưởng tới dung lượng app. Ưu
  tiên bỏ package nếu chỉ dùng một hàm nhỏ.
- CẤM package cần mạng lúc runtime hoặc gửi telemetry (Principle VI).
- Nâng MAJOR phải đọc changelog chính thức và ghi một dòng đánh giá tác động.

**Rationale**: App offline, dung lượng nhạy cảm (model Android đã chiếm phần
lớn ngân sách). Mỗi dependency là thêm dung lượng, thêm thời gian khởi động và
thêm một khả năng lén gọi mạng.

### XV. Build Flavors (ĐÚNG development + production)

Project PHẢI có ĐÚNG HAI flavor: **`development`** và **`production`**. Không có
`staging`.

- Giá trị theo flavor (app id, tên hiển thị, mức log, cờ bật màn benchmark) đọc
  từ tầng config theo flavor — CẤM hardcode trong widget và CẤM rải `#if`/
  `kDebugMode` trong code feature.
- `development` bật đo đạc/log hiệu năng; `production` tắt log chi tiết và
  không được kèm màn debug nào.
- Thêm flavor thứ ba là amendment, không phải thay đổi thường ngày.

**Rationale**: Không có backend thì cũng không có môi trường server để tách.
Hai flavor đủ cho một bản dev có đo đạc và một bản phát hành sạch; flavor thứ ba
chỉ thêm bề mặt ký ứng dụng mà không thêm giá trị.

## Technical Standards

### Platform & Stack

- **Ngôn ngữ/UI**: Dart + Flutter (stable channel), Material 3 chỉ dùng như nền
  kỹ thuật — hình ảnh do design system quyết định (Principle VII).
- **Kiến trúc**: Clean Architecture feature-first + BLoC (KHÔNG MVVM).
- **Platform**: iOS (Vision `VNGenerateForegroundInstanceMaskRequest`) +
  Android (TFLite bundle sẵn) + tablet. **Min iOS: 17.0 (đã chốt)** — máy dưới
  17.0 nhận `UNSUPPORTED_OS_VERSION` và phải được chặn tính năng có giải thích
  rõ, không crash; Android min API cần chốt cùng benchmark ở Spec #002.
- **Ranh giới native**: MethodChannel `com.productcam.app/segmentation` +
  EventChannel `com.productcam.app/segmentation_stream`
  (xem `.claude/platform-channel-contract.md`).
- **State**: `flutter_bloc` (Bloc + Cubit), state immutable.
- **DI**: constructor injection + composition root (`get_it`/`injectable`).
- **Lưu trữ**: file system cho ảnh/mask + SQLite/Hive cho metadata history.
  Không cloud.
- **Design system**: token port từ `.claude/design/.../tokens/` sang
  `ThemeExtension`; component dùng chung trong `core/widgets/`.
- **Typography**: Manrope (UI) + IBM Plex Mono (readout), bản có Vietnamese
  subset, **nhúng trong assets** (Principle VI).
- **i18n**: ARB + `AppLocalizations`. **Mặc định + fallback `en`, hỗ trợ `vi`**
  (`supportedLocales: [en, vi]`). Font Manrope + IBM Plex Mono đều phải có
  Vietnamese subset vì `vi` là ngôn ngữ ship.
- **Lint/format**: `dart format`, `flutter analyze` zero warning; khuyến khích
  lint rule chặn hardcode màu/chuỗi (Principle VII, IX).
- **Test**: `flutter_test`, `bloc_test`, `mocktail`, golden test.
- **Flavor**: `development` + `production` (Principle XV).

### Surfaces (theo `.claude/screen-inventory.md` + bundle design)

Camera Capture (viewfinder + contour real-time, flash/lưới/đổi camera, toggle
Đơn↔Loạt, dải thumbnail phiên chụp, nút chụp 80px) · Kết quả (checkerboard +
contour xác nhận, cảnh báo viền phức tạp, sheet **Chỉnh viền**) · Nền & bóng
(swatch nền trong suốt/màu/gradient, preset bóng + slider độ đậm/độ mềm) ·
Phiên chụp (lưới trạng thái, lọc theo trạng thái, Chụp thêm / Xuất tất cả) ·
Xuất (sheet: định dạng PNG/JPG/WEBP, kích thước 1000/1200/2048, ước tính dung
lượng, Lưu vào máy / Chia sẻ) · Lịch sử (nhóm theo ngày, lọc, sheet thao tác
từng ảnh, xoá có Hoàn tác) · Cài đặt (chế độ hiệu năng, quyền, thông tin mô
hình theo platform, lưu trữ, xoá dữ liệu tạm).

## Development Workflow

### Pre-Commit Checklist (BẮT BUỘC)

```bash
dart format .                 # định dạng
flutter analyze               # zero warning
flutter test                  # toàn bộ test, gồm bloc_test + golden
```

Ngoài ra, tự rà bằng mắt/grep trước khi mở PR:

```bash
# Không được có kết quả nào NGOÀI lib/core/theme/tokens/
grep -rn "Color(0x\|Colors\." lib/ --include=*.dart | grep -v "core/theme/tokens"
# Chuỗi hiển thị hardcode trong widget
grep -rn "Text('" lib/features --include=*.dart
```

Spec đụng native → build thử **cả hai platform** (`flutter build ios`,
`flutter build apk`) trước khi merge, không chỉ dựa vào CI.
Spec đụng real-time → kèm số đo trên **máy Android tầm thấp thật**.

### Testing Gates

Mọi PR PHẢI qua: unit test domain/data, bloc test cho bloc thay đổi, contract
test cho thay đổi platform channel, golden test cho UI thay đổi, `flutter
analyze` zero warning. PR đụng `previewFrame`/pipeline phải kèm số đo hiệu năng.
PR đụng contract phải cập nhật cả Swift lẫn Kotlin trong cùng PR.

### Design Fidelity Check

Trước khi mở PR có UI: đối chiếu màn đang làm với màn tương ứng trong
`.claude/design/project/` (bố cục, thứ tự khối, trạng thái, copy tiếng Việt) và
xác nhận không có literal style/chuỗi nào lọt ra ngoài tầng token/l10n.

### Review Requirements

- Mọi thay đổi phải được review trước khi merge.
- Soi kỹ hơn ở: code native (hai bên phải khớp contract), pipeline real-time
  (Principle V), tầng theme/token (Principle VII), và bất kỳ chỗ nào đụng bộ
  nhớ ảnh.
- Package mới phải nêu lý do + ảnh hưởng dung lượng (Principle XIV).

### Quality Checks

- Chạy thử trên máy thật: chụp liên tiếp ở chế độ Loạt, cuộn lịch sử dài, đổi
  chế độ hiệu năng — preview phải mượt và bộ nhớ phải ổn định.
- Kiểm tra ở chế độ máy bay: mọi tính năng vẫn chạy đủ (Principle VI).
- Kiểm tra khi từ chối quyền camera/thư viện: app không crash, có lối đi tới
  cài đặt hệ thống.
- Kiểm tra text scale lớn và giảm chuyển động: layout không vỡ, trạng thái vẫn
  đọc được (Principle XI).

## Governance

Constitution này đặt ra các nguyên tắc không thương lượng cho ProductCam. Mọi
quyết định triển khai PHẢI tuân thủ.

### Amendment Process

1. Đề xuất sửa đổi PHẢI kèm lý do.
2. Sửa đổi PHẢI được đánh giá tác động lên code hiện có.
3. Thay đổi phá vỡ PHẢI có kế hoạch migration trước khi duyệt.
4. Version theo semantic versioning:
   - **MAJOR**: bỏ hoặc định nghĩa lại một nguyên tắc theo cách không tương
     thích (ví dụ: thêm backend/tài khoản, cho phép gọi mạng runtime, cho phép
     hardcode màu/chuỗi, thêm flavor thứ ba, quay lại MVVM).
   - **MINOR**: thêm nguyên tắc mới hoặc mở rộng đáng kể (ví dụ: chốt model
     Android kèm ràng buộc dung lượng, thêm ngôn ngữ thứ hai).
   - **PATCH**: làm rõ, sửa câu chữ.

### Compliance

- Mọi PR PHẢI tự xác nhận tuân thủ các principle liên quan.
- Độ phức tạp vượt chuẩn PHẢI được biện minh rõ ràng.
- Sai lệch PHẢI được ghi lại kèm lý do và được project lead duyệt, lưu tại
  `.claude/decisions/`.
- Hướng dẫn vận hành hằng ngày: `.claude/dev-workflow.md`; trạng thái kế hoạch:
  `.claude/project-context.md` + `.claude/sdd-roadmap.md`; ranh giới native:
  `.claude/platform-channel-contract.md`; giao diện: `.claude/design/`.

**Version**: 1.1.0 | **Ratified**: 2026-08-14 | **Last Amended**: 2026-08-14
