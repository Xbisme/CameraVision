# Dev Workflow — ProductCam

> 1 repo duy nhất, KHÔNG có "Contract Sync" giữa 2 repo như LiveCanvas/SoundWave. Thay vào đó có 1 lưu ý riêng: đồng bộ giữa `.claude/platform-channel-contract.md` và 2 phần code native (iOS/Android) trong CÙNG repo.
>
> Luật cao nhất là [`.specify/memory/constitution.md`](../.specify/memory/constitution.md). Quy trình dưới đây là cách thực thi nó hằng ngày.

## ⚠️ Design Fidelity Check (bắt buộc với mọi spec có UI)

Giao diện đã có sẵn trong [`design/`](design/) — **design là nguồn chân lý về UI**, không tự chế layout mới.

1. Trước khi viết widget: đọc màn tương ứng trong `design/project/` — `ProductCam App.html` và `pc-screens.jsx` — cùng `_ds/…/readme.md`.
   ⚠️ `readme.md` có mục Index nhắc tới `components/`, `guidelines/`, `ui_kits/productcam-app/`. **Ba thư mục đó không tồn tại trên đĩa**; nguồn của chúng đã được compile vào `_ds_bundle.js`. Constitution Principle VIII cũng đang trỏ sai chỗ này — sửa nguyên tắc cần amendment, xem [`decisions/001b-design-system-deviations.md`](decisions/001b-design-system-deviations.md) §1.
2. Prototype là HTML/CSS/JS — **tái hiện kết quả hình ảnh**, không bê cấu trúc DOM thành cây widget.
3. Mọi giá trị style lấy từ `lib/core/theme/` (ThemeExtension), mọi chuỗi lấy từ ARB. Không có ngoại lệ "để tạm rồi sửa sau".
4. Cần một màn/luồng chưa có trong design → **dừng, hỏi, cập nhật `screen-inventory.md` trước**, đừng tự vẽ.
5. Xung đột: design thắng về UI · `platform-channel-contract.md` thắng về ranh giới Dart↔Native · product context thắng về phạm vi. Ghi lại vào `decisions/`.

## ⚠️ Native Contract Check (bắt buộc đọc trước Step 1)

Vì 1 contract (`platform-channel-contract.md`) phải khớp với **2 bộ code native khác nhau** (Swift + Kotlin) cùng sống trong 1 repo:

1. Đổi method channel (thêm field response, đổi tên method...) → sửa `.claude/platform-channel-contract.md` trước.
2. Cập nhật **CẢ 2 bên native** (`ios/Runner/SegmentationEngine.swift` VÀ `android/.../SegmentationEngine.kt`) trong cùng 1 PR — không merge nếu chỉ 1 bên khớp contract, vì Dart code gọi chung 1 interface cho cả 2 platform.
3. Test thủ công trên **cả 2 platform thật** trước khi merge bất kỳ spec nào đụng tới `002`/`002b`/`003`/`004` — khác biệt hành vi giữa 2 native engine dễ bị bỏ sót nếu chỉ test 1 bên.

## Flow For Each Spec

1. **Pre-spec Discussion** — review `.specify/memory/constitution.md`, `project-context.md`, `sdd-roadmap.md`, `screen-inventory.md`, `platform-channel-contract.md`, và màn tương ứng trong `design/`.
2. **Claude soạn prompt `/speckit.specify`** — nếu spec đụng native code, ghi rõ cần implement cho platform nào (iOS/Android/cả 2).
3. **User chạy `/speckit.specify`** → branch `NNN-feature-name` (hoặc `NNNb-...` cho sub-spec chạy song song, vd `002b`).
4. **Clarify** — `/speckit.clarify`, tối đa 5 câu/vòng.
5. **Plan & Tasks** — `/speckit.plan`, `/speckit.tasks`; nếu spec đụng contract, đối chiếu `data-model.md`/`plan.md` với `platform-channel-contract.md`.
6. **Final Review** — `/speckit.analyze`.
7. **Implement** — `/speckit.implement`. Pre-commit bắt buộc:
   - `dart format .`
   - `flutter analyze` (fallback `dart analyze` nếu lỗi local toolchain, xem note gốc)
   - `flutter test`
   - **Cổng no-hardcode** (Constitution VII/IX/X) — không được có kết quả nào ngoài tầng token:
     ```bash
     grep -rn "Color(0x\|Colors\." lib/ --include=*.dart | grep -v "core/theme/tokens"
     grep -rn "Text('" lib/features --include=*.dart
     ```
   - **Riêng spec đụng native**: build thử cả 2 platform (`flutter build ios`, `flutter build apk`) trước khi merge, không chỉ dựa vào CI.
   - **Riêng spec đụng real-time**: kèm số đo `previewFrame` (p50/p95) trên máy Android tầm thấp thật.

## Principles

- Claude KHÔNG trực tiếp chạy speckit.
- `.specify/memory/constitution.md` là luật cao nhất; spec nào mâu thuẫn thì spec sai, trừ khi có amendment.
- `platform-channel-contract.md` là nguồn chân lý cho ranh giới Dart↔Native, cao hơn spec riêng lẻ khi xung đột.
- `design/` là nguồn chân lý giao diện.
- **Clean Architecture feature-first + BLoC, KHÔNG MVVM** — bloc đã giữ state của presentation, thêm ViewModel là trùng lặp.
- **Không hardcode**: không màu/số đo/kiểu chữ ngoài `core/theme/tokens/`, không chuỗi hiển thị ngoài ARB, không magic value ngoài `core/config/`.
- Tiếng Việt giao tiếp · Tiếng Anh code/comment/commit.
- **Prompt cho speckit (`/speckit.specify`, `/speckit.plan`, …) viết bằng tiếng Anh** — tiếng Việt trong prompt dài dễ bị hiểu sai/rơi ý. Tài liệu trong `.claude/` vẫn giữ tiếng Việt; riêng copy hiển thị trong app theo Principle IX (`en` mặc định + `vi`).
- **Hiệu năng là ưu tiên hàng đầu** (không phải bảo mật như 2 project trước — app này không có dữ liệu nhạy cảm/tài khoản):
  - Mọi thay đổi ở `previewFrame`/pipeline real-time phải đo lại thời gian xử lý trên ít nhất 1 thiết bị tầm thấp thật trước khi merge, không chỉ test trên máy dev/simulator mạnh.
  - Không bao giờ chạy segmentation trên UI thread.
  - Theo dõi dung lượng app (`.ipa`/`.apk` size) sau mỗi spec đụng tới model Android — báo ngay nếu tăng bất thường.
- UI/UX nguyên bản — không copy layout của app tách nền khác (Background Eraser, remove.bg app...). Điều này **đã được giải trong `design/`** (chrome tối, contour mint hai nét, readout mono kiểu thiết bị đo); việc khi code là bám sát nó, không phải nghĩ lại từ đầu.

## Per-Spec Hygiene

1. Cập nhật `project-context.md` (Current Focus)
2. Cập nhật `sdd-roadmap.md` (trạng thái spec)
3. Thêm entry `changelog.md`
4. Nếu đổi `platform-channel-contract.md` → xác nhận cả 2 native engine đã cập nhật khớp (xem Native Contract Check)
5. Archive alignment vào `decisions/<NNN>-<topic>.md` nếu có, đặc biệt quyết định chọn model Android (Spec #002) cần archive đầy đủ kết quả benchmark
6. Nếu UI khác design (thêm màn, đổi luồng) → cập nhật `screen-inventory.md` + ghi lý do vào `decisions/`, không để design và code lệch nhau âm thầm
7. Nếu spec làm thay đổi một nguyên tắc → amendment `.specify/memory/constitution.md` kèm bump version (xem mục Governance)

## Branch Naming

- `NNN-feature-name` (vd `001-project-foundation`)
- Sub-spec chạy song song: `NNNb-feature-name` (vd `002b-segmentation-engine-ios`, tương tự `002` bản Android)
- Hotfix: `hotfix/<short-description>`
- `main` bảo vệ khỏi push trực tiếp

## Commit Message Style

- Conventional Commits: `<type>: <subject>` (vd `feat: add contour overlay painter`)
- Imperative, sentence case, ≤72 ký tự
- `Co-Authored-By: Claude <noreply@anthropic.com>` khi Claude hỗ trợ

## Changelog Entry Format

```
### YYYY-MM-DD — Spec #NNN <Name> ✅ <verb>

- Scope đã ship, ghi chú kỹ thuật (đặc biệt số liệu benchmark hiệu năng nếu có), follow-up, package mới.
- ⚠️ Nếu đổi contract: xác nhận đã cập nhật cả Swift lẫn Kotlin.
```

`<verb>`: `MERGED INTO MAIN` · `COMPLETE` · `IMPLEMENTED` · `LANDED`
