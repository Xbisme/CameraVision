# ProductCam v1.0 — Spec Roadmap

> 1 repo duy nhất, không có track song song. Numbering đơn giản `NNN` (không prefix BE-/MO- vì không có repo thứ 2).
> Last updated: 2026-08-14 (Spec #001 đã merge vào `main` · đã cập nhật theo bundle design + constitution v1.1.1)

## Dependency Graph

```
Spec #000: Platform-Channel Contract Freeze
           (.claude/platform-channel-contract.md v1.0)
    │
    ▼
001: Project Foundation
(Flutter skeleton clean architecture, DI,
 Result/AppFailure, l10n ARB, flavor
 dev/prod, navigation, permission)
    │
    ├──────────────┬──────────────┐
    ▼              ▼              ▼
001b: Design    002: Segmentation  003: Real-time
System & Theme  Engine — Android   Preview Engine
(token →        (benchmark, chốt   (camera stream,
 ThemeExtension, model, Kotlin)    downsample, contour
 font nhúng,        │              CustomPainter,
 16 component,      ▼              isolate)
 golden test)   002b: Segmentation
    │           Engine — iOS
    │           (Vision, Swift)
    │               │              │
    └───────┬───────┴──────────────┘
            ▼
       004: Capture & Review Flow
       (chụp → captureAndSegment → màn Kết quả,
        checkerboard, EdgeNotice viền phức tạp)
            │
            ▼
       004b: Edge Refine  ← MỚI, theo design
       (sheet Chỉnh viền: thu/giãn viền,
        làm mềm mép — xử lý phía Dart)
            │
            ▼
       005: Background Editor
       (7 swatch nền, preset bóng + slider,
        composite real-time khi chỉnh)
            │
            ├──────────────┐
            ▼              ▼
       006: Batch Mode  007: Export & History
       (queue nền, lưới  (PNG/JPG/WEBP,
        5 trạng thái,     1000/1200/2048,
        lọc, Xuất tất cả) sheet thao tác, Hoàn tác)
            │              │
            └──────┬───────┘
                   ▼
       008: Settings & Performance Tuning
       (3 chế độ hiệu năng, quyền, thông tin
        mô hình, lưu trữ, benchmark máy thật)
                   │
                   ▼
       009: Polish & Store Submission
```

## Spec Details

### Spec #000: Platform-Channel Contract Freeze
- **Status**: 🟡 In progress
- Review `screen-inventory.md` → `platform-channel-contract.md`. Checklist: xác nhận method channel names, xác nhận contour trả về dạng tỉ lệ 0.0-1.0 (không phải pixel), xác nhận error code catalog đủ cho mọi trường hợp lỗi native, xác nhận `initSegmenter` trả đủ `engine_label` + `model_size_bytes` cho màn Cài đặt, xác nhận danh sách "những gì KHÔNG đi qua channel" (v0.2.0).

### 001: Project Foundation
- **Status**: ✅ Merged (2026-08-14, PR #1 → `f2c05ae`). 60/63 task, 21/21 test pass, 6/6 cổng CI đã kiểm chứng đúng chiều. Còn nợ 3 task cần máy Android thật: T051 build APK release flavor `development`, T052 cài song song 2 bản, T060 đo cold-start.
- **Branch**: `001-project-foundation` (đã merge)
- **Depends on**: #000
- **Scope**: Flutter skeleton theo clean architecture feature-first (`core/` + `features/<feature>/{domain,data,presentation}`); DI composition root; `Result<T>` + `AppFailure` phủ đủ error catalog; l10n ARB **`en` (mặc định + fallback) + `vi`** với `AppLocalizations`; flavor `development`/`production`; navigation (Camera là màn mặc định); xin quyền camera/thư viện ảnh (`permission_handler`); CI (`dart format`, `flutter analyze`, `flutter test`).
- **Constitution gate**: Principle I, III, IX, X, XV.

### 001b: Design System & Theme  ← MỚI
- **Branch**: `001b-design-system-theme`
- **Depends on**: 001 (chạy song song được với 002/002b/003)
- **Scope**: Port token từ `.claude/design/project/_ds/.../tokens/*.css` sang `lib/core/theme/tokens/` (colors, typography, spacing, radius, elevation, motion, contour); phơi qua `ThemeExtension` (`PcColors`, `PcSpacing`, `PcRadius`, `PcTypography`, `PcElevation`, `PcMotion`, `PcContour`); nhúng font Manrope + IBM Plex Mono (Vietnamese subset) vào `assets/fonts/` — **không tải qua mạng**; dựng component dùng chung trong `core/widgets/` ánh xạ 1:1 với bundle design (`PcButton`, `PcIconButton`, `PcChip`, `PcBadge`, `PcSheet`, `PcIcon`, `PcSlider`, `PcToast`, `EdgeNotice`, `Readout`, `ShutterButton`, `ModeToggle`, `ContourOverlay`, `CheckerSurface`, `BackgroundSwatchPicker`, `BatchThumb`, `ProgressTrace`, `ScreenHeader`, `ThumbBand`); golden test cho từng component.
- **⚠️ Quan trọng**: spec này phải merge TRƯỚC bất kỳ spec UI nào (004 trở đi), nếu không mỗi màn sẽ tự đẻ ra style riêng và vi phạm Principle VII.
- **Constitution gate**: Principle VII, VIII, XI, XII (golden test).

### 002: Segmentation Engine — Android
- **Branch**: `002-segmentation-engine-android`
- **Depends on**: 001
- **Scope**: Benchmark MODNet vs ISNet vs U2-Net trên ≥3 thiết bị Android tầm thấp/trung/cao thực tế (đo: thời gian xử lý, dung lượng model, độ chính xác viền phức tạp) → chốt 1 model; implement `SegmentationEngine.kt` đúng `platform-channel-contract.md` (`initSegmenter`, `previewFrame`, `captureAndSegment`, `dispose`).
- **⚠️ Quan trọng**: spec rủi ro cao nhất roadmap — kết quả benchmark có thể đổi ước tính dung lượng app và có thể phải sửa lại contract. Con số `MODNET · 12.4 MB` đang hiển thị trong design chỉ là placeholder, phải thay bằng số đo thật.

### 002b: Segmentation Engine — iOS
- **Branch**: `002b-segmentation-engine-ios`
- **Depends on**: 001 (song song với 002)
- **Scope**: Implement `SegmentationEngine.swift` dùng `VNGenerateForegroundInstanceMaskRequest`; xử lý `UNSUPPORTED_OS_VERSION` (chặn tính năng + giải thích, không crash); đúng contract như 002.
- **Đã chốt**: min iOS **17.0**, không bundle model fallback cho iOS ở v1 — xem `decisions/000-min-ios-version.md`.

### 003: Real-time Preview Engine
- **Branch**: `003-realtime-preview-engine`
- **Depends on**: 001 (cần 001b nếu vẽ overlay theo token; test tích hợp cùng 002/002b trước khi merge 004)
- **Scope**: Camera stream (`camera` package); pipeline downsample frame trước khi gửi `previewFrame`; contour overlay vẽ bằng `CustomPainter` **hai nét (halo + lõi mint)** trong `RepaintBoundary`; chạy trên background isolate; điều tiết tần suất theo profile hiệu năng; 3 trạng thái contour `scanning`/`locked`/`review`.
- **Constitution gate**: Principle V (đo `previewFrame` p50/p95 trên máy Android tầm thấp thật, ghi vào DoD).

### 004: Capture & Review Flow
- **Branch**: `004-capture-review-flow`
- **Depends on**: 001b, 002, 002b, 003
- **Scope**: Nút chụp (80px, hit 104px) → lưu ảnh tạm → `captureAndSegment` → màn Kết quả (checkerboard, `ProgressTrace` khi đang xử lý, contour vẽ lại khi xong, badge kích thước/dung lượng, Chụp lại / Chấp nhận); `EdgeNotice` amber khi `edge_complexity_warning: true` (icon `scissors`, **không dùng cảnh báo đỏ**).

### 004b: Edge Refine — Chỉnh viền  ← MỚI (theo design)
- **Branch**: `004b-edge-refine`
- **Depends on**: 004
- **Scope**: Sheet "Chỉnh viền" ở màn Kết quả: slider **Thu / giãn viền** (−10…+10 px) và **Làm mềm mép** (0…10 px), preview cập nhật trực tiếp trên checkerboard. Xử lý **hoàn toàn phía Dart** trên mask PNG (erode/dilate + feather) — không thêm method channel.
- **Đã chốt**: thuộc phạm vi v1, xử lý phía Dart, không thêm method channel — xem `decisions/000-edge-refine-v1.md`. Mask sau khi chỉnh phải được lưu để #005 và #007 dùng lại đúng bản đã chỉnh.

### 005: Background Editor
- **Branch**: `005-background-editor`
- **Depends on**: 004b
- **Scope**: Composite mask lên nền mới với **7 swatch cố định** (Trong suốt · Trắng · Kem · Xám · gradient Mint · gradient Nắng · Đậm); bóng đổ theo **preset** (Không/Nhẹ/Vừa/Đậm) + slider Độ đậm (%) / Độ mềm (px); preview cập nhật tức thì khi kéo slider (xử lý phía Dart, không gọi lại native). Không có color picker tự do ở v1.

### 006: Batch Mode
- **Branch**: `006-batch-mode`
- **Depends on**: 005
- **Scope**: Toggle Đơn↔Loạt ở màn Camera; chụp liên tiếp không chờ ảnh trước xử lý xong; background queue; màn Phiên chụp (lưới 3 cột gap 6px, **5 trạng thái** `queued`/`working`/`done`/`review`/`error`, readout "Đang xử lý N ảnh" ↔ "Đã xong tất cả", badge đếm "N XEM LẠI"/"N LỖI", lọc theo trạng thái); dải thumbnail phiên chụp ở màn Camera; Chụp thêm / Xuất tất cả.

### 007: Export & History
- **Branch**: `007-export-history`
- **Depends on**: 005 (song song được với 006)
- **Scope**: Sheet Xuất (định dạng **PNG/JPG/WEBP**, kích thước **1000/1200/2048 px**, ước tính dung lượng, Lưu vào máy + Chia sẻ, toast "Đã lưu N ảnh vào máy" kèm hành động "Xem"); lưu thư viện ảnh (`gal`) + chia sẻ (`share_plus`); Lịch sử local (Hive/`drift`) **nhóm theo ngày**, lọc (Tất cả/Hôm nay/Cần xem lại), sheet thao tác từng ảnh (Chỉnh nền lại · Xuất lại · Chia sẻ · Xoá kèm **Hoàn tác**).
- **Cần chốt trong spec**: nút tìm kiếm ở màn Lịch sử tìm theo tiêu chí gì — hoặc bỏ, hoặc chỉ lọc theo ngày/trạng thái.

### 008: Settings & Performance Tuning
- **Branch**: `008-settings-performance-tuning`
- **Depends on**: 003, 004, 007
- **Scope**: Màn Cài đặt đầy đủ theo design (3 chế độ hiệu năng kèm readout thông số; trạng thái quyền camera/thư viện + lối mở cài đặt hệ thống; **thông tin mô hình theo platform lấy từ `initSegmenter`**, không hardcode; dung lượng lưu trữ; xoá dữ liệu tạm); benchmark thực tế để chốt thông số frame-skip/downsample cho từng chế độ; đo và tối ưu dung lượng app cuối cùng.

### 009: Polish & Store Submission
- **Branch**: `009-polish-store-submission`
- **Depends on**: 006, 007, 008
- **Scope**: App icon, store metadata, TestFlight + Internal testing, submit App Store/Play Store.
