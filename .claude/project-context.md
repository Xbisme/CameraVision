# ProductCam — Project Context

> Repo: `productcam` (Flutter — 1 repo duy nhất, KHÔNG có backend)
>
> Last updated: 2026-08-14 (Đã có bundle design + constitution v1.0.0 — chưa có spec nào triển khai)

## Snapshot

- **App**: ProductCam (placeholder name) — camera tách nền real-time cho ảnh sản phẩm, dành cho người bán hàng online/tiểu thương/freelancer.
- **Kiến trúc**: 100% on-device, offline hoàn toàn, KHÔNG có backend, KHÔNG có tài khoản, free hoàn toàn.
- **Kiến trúc code**: Clean Architecture **feature-first** + **BLoC** (KHÔNG MVVM — bloc đã là lớp quản lý state, thêm ViewModel là trùng lặp). Xem [`.specify/memory/constitution.md`](../.specify/memory/constitution.md).
- **Platform**: iOS + Android + tablet, 1 codebase Flutter, nhưng **native code khác nhau hoàn toàn theo platform**:
  - iOS: Vision framework `VNGenerateForegroundInstanceMaskRequest` (subject lifting, system API, không cần bundle model).
  - Android: model TFLite bundle sẵn (MODNet/U2-Net/ISNet — chưa chốt cụ thể, cần benchmark).
- **"Contract" thay cho API**: [`platform-channel-contract.md`](platform-channel-contract.md) — ranh giới Dart ↔ Native, đóng vai trò tương đương `api-context.md` ở project có backend.
- **Giao diện đã có design**: bundle trong [`design/`](design/) (7 màn + 3 sheet + design system 16 component + token). **Design là nguồn chân lý về UI** — không tự chế layout mới.
- **Rủi ro kỹ thuật hàng đầu** (từ brief gốc, luôn nhắc lại khi làm spec liên quan): hiệu năng máy tầm thấp, dung lượng app do model Android nhúng sẵn, độ chính xác viền phức tạp (lông/tóc/vật trong suốt).
- **Communication**: Tiếng Việt giữa user + Claude · Tiếng Anh cho code/comment/commit.
- **Ngôn ngữ trong app**: ship `en` (mặc định + fallback) và `vi` (hỗ trợ). Copy tiếng Việt trong bundle design là nguồn của `app_vi.arb`; bản EN phải viết mới đúng giọng văn.

## Current Focus

- **Trạng thái**: Repo mới khởi tạo, chưa merge spec nào. Constitution v1.0.0 đã ratify (2026-08-14).
- **Đã có sẵn**: `screen-inventory.md` (đã cập nhật theo design), `platform-channel-contract.md` v0.2.0 (draft), bundle design đầy đủ, `.specify/memory/constitution.md`.
- **Spec tiếp theo**: `001-project-foundation` (sau khi contract #000 freeze), rồi `001b-design-system-theme` — **phải merge trước mọi spec UI**.
- **Thay đổi phạm vi do design (2026-08-14, đã chốt)**:
  - **"Chỉnh viền" thủ công vào v1** (trước xếp v2) → thêm Spec `004b-edge-refine`, xử lý phía Dart, không thêm method channel. → [`decisions/000-edge-refine-v1.md`](decisions/000-edge-refine-v1.md)
  - **Min iOS 17.0** → [`decisions/000-min-ios-version.md`](decisions/000-min-ios-version.md)
  - Định dạng xuất thêm **WEBP**; kích thước xuất chọn được **1000/1200/2048 px**.
  - Bảng nền cố định 7 lựa chọn; bóng đổ theo preset + slider.
  - Màn Cài đặt hiển thị thông tin mô hình → `initSegmenter` phải trả `engine_label` + `model_size_bytes` (contract v0.2.0).
- **Chưa quyết định** (cần confirm trước khi implement):
  - **Model Android cụ thể** — MODNet vs ISNet vs U2-Net — cần benchmark thực tế trên vài thiết bị tầm trung/thấp, ảnh hưởng trực tiếp dung lượng app. (`MODNET · 12.4 MB` trong design chỉ là placeholder.)
  - Ngưỡng "máy tầm thấp" cụ thể (RAM/chip) để chốt frame-skip/downsample mặc định.
  - **Tên/bundle id chính thức** — đề xuất `com.productcam.app.dev` / `com.productcam.app`.
  - **Font binary** Manrope + IBM Plex Mono (Vietnamese subset) — phải nhúng assets, không tải qua mạng.

## Repo Layout

```
.specify/
└── memory/constitution.md            # Constitution v1.0.0 — nguyên tắc không thương lượng

.claude/
├── project-context.md
├── sdd-roadmap.md
├── dev-workflow.md
├── screen-inventory.md               # màn hình cần gì → đọc TRƯỚC khi sửa contract
├── platform-channel-contract.md      # tương đương api-context.md — đọc TRƯỚC khi code native
├── changelog.md
├── decisions/
└── design/                           # bundle design (nguồn chân lý UI)
    └── project/
        ├── ProductCam App.html       # bản dựng click-through 7 màn
        ├── pc-screens.jsx            # Camera · Kết quả · Lịch sử · Cài đặt
        └── _ds/…/                    # design system: tokens/ + components/ + ui_kits/

lib/
├── core/
│   ├── error/                        # AppFailure, Result<T>
│   ├── platform/                     # MethodChannel wrapper (ranh giới native duy nhất)
│   ├── di/                           # composition root
│   ├── theme/                        # tokens + ThemeExtension (chỉ nơi này có literal style)
│   ├── l10n/                         # ARB (vi) + generated
│   ├── config/                       # flavor/config
│   └── widgets/                      # component design system dùng chung
└── features/<feature>/               # domain/ · data/ · presentation/(bloc, pages, widgets)
    ├── camera_capture/               # Live preview + overlay real-time
    ├── review/                       # Kết quả sau khi chụp + chỉnh viền
    ├── background_editor/            # Nền & bóng đổ
    ├── batch/                        # Phiên chụp
    ├── export/                       # Xuất/chia sẻ
    ├── history/                      # Lịch sử local
    └── settings/                      # Chế độ hiệu năng, quyền, thông tin mô hình

ios/
├── Runner/
└── SegmentationEngine.swift           # Vision framework implementation

android/
├── app/src/main/kotlin/
│   └── SegmentationEngine.kt          # TFLite implementation
└── app/src/main/assets/
    └── model.tflite                   # Model nhúng sẵn (chưa chốt model nào)

specs/                                 # NNN-feature-name/ folders (speckit output)
```

## Key Documents

| File | Vai trò |
|---|---|
| [`.specify/memory/constitution.md`](../.specify/memory/constitution.md) | Nguyên tắc không thương lượng (kiến trúc, theme, no-hardcode, hiệu năng) |
| [`design/`](design/) | Nguồn chân lý giao diện — đọc trước khi làm bất kỳ màn nào |
| [`screen-inventory.md`](screen-inventory.md) | Màn hình cần gì → đọc TRƯỚC khi sửa platform-channel-contract |
| [`platform-channel-contract.md`](platform-channel-contract.md) | Ranh giới Dart ↔ Native — tương đương api-context.md |
| [`sdd-roadmap.md`](sdd-roadmap.md) | Spec planning (1 track duy nhất, không có BE-/MO-) |
| [`dev-workflow.md`](dev-workflow.md) | Quy trình speckit — đơn giản hơn LiveCanvas/SoundWave vì không có repo thứ 2 cần đồng bộ |
