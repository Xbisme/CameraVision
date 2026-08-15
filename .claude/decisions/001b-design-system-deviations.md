# Sai lệch & quyết định khi port design system (Spec #001b)

> Ngày: 2026-08-14 · Spec: [`specs/001b-design-system-theme/`](../../specs/001b-design-system-theme/)
>
> Ghi theo `dev-workflow.md` mục Per-Spec Hygiene #5 và #6: mọi chỗ code lệch
> khỏi bundle design, hoặc khỏi tài liệu nền, phải được ghi lại chứ không im
> lặng chọn một bên.

## 1. `ui_kits/productcam-app/` không tồn tại trên đĩa — DEFECT TÀI LIỆU

`dev-workflow.md` (mục Design Fidelity Check, bước 1) và **Constitution
Principle VIII** đều chỉ người implement đọc
`_ds/…/ui_kits/productcam-app/`. Thư mục đó **không có trong bundle**.

Bundle thực tế chỉ có `tokens/`, `styles.css`, `readme.md`, `_ds_bundle.js`,
`_ds_manifest.json`. 16 primitive + shell đã được compile vào `_ds_bundle.js`.
Nguồn đọc được bằng mắt là `ProductCam App.html` và `pc-screens.jsx`.

- **Đã sửa**: `dev-workflow.md` trỏ sang hai file có thật.
- **Chưa sửa**: Constitution VIII — sửa nguyên tắc phải qua amendment kèm bump
  version, không phải việc của spec này. **Cần làm trước khi Spec #004 bắt đầu**,
  vì #004 là spec UI đầu tiên thực sự đi theo chỉ dẫn đó.

## 2. `lucide-static@0.474.0` không tồn tại trên npm

Design ghim `lucide@0.474.0`. Bản `lucide-static` trên npm nhảy thẳng từ
`0.473.0` sang `0.477.0` — không có `0.474.0`.

Constitution XIV nói package không tồn tại đúng tên/URL thì **dừng và hỏi**,
không thay bằng package na ná. Ở đây không phải thay package: tag git
`0.474.0` trong repo `lucide-icons/lucide` **có tồn tại**, và đó là nguồn gốc
mà npm chỉ là bản đóng gói lại. Đã vendor từ tag git đó — cùng bộ icon, cùng
version, chỉ khác kênh phân phối.

## 3. `more-horizontal` đã được đổi tên thành `ellipsis`

Bundle design liệt kê `more-horizontal`; Lucide đã đổi tên upstream. File
vendor giữ tên `more-horizontal.svg` theo design, nội dung lấy từ
`ellipsis.svg`. Giữ tên của design để `screen-inventory` và bundle vẫn tra được.

## 4. Lucide ship stroke 2, design yêu cầu 1.75

Cả 26 file SVG được ghi lại `stroke-width="1.75"` khi vendor. **Đây chính là lý
do chọn vector glyph thay vì icon font** (clarification Q1): icon font nướng
stroke vào glyph và scale theo cỡ chữ, không bao giờ giữ đúng 1.75 ở cả 4 cỡ
icon mà design dùng. Có test khẳng định cả 26 file đúng stroke.

## 5. Manrope chỉ có bản variable trên Google Fonts

Cần 5 static instance (400/500/600/700/800) theo research R5. Đã tách bằng
`fontTools.varLib.instancer` từ `Manrope[wght].ttf`, rồi subset Latin +
Vietnamese. IBM Plex Mono có sẵn static Medium nên lấy thẳng.

Kết quả: 6 file, **312 KB** — dư ngân sách 1.5 MB của SC-008.

## 6. `assets/fonts/` KHÔNG khai báo làm asset directory

Font vào bundle qua mục `fonts:` của pubspec. Nếu khai báo thêm
`assets/fonts/` ở mục `assets:` thì mỗi file `.ttf` bị đóng gói **hai lần**.
Dung lượng app là rủi ro top-3 của project nên không làm thế. Text license
chuyển sang `assets/licenses/`.

## 7. Bán kính blur là giá trị **suy ra**, chưa hiệu chỉnh bằng mắt (T011 còn mở)

Ba hệ quy ước khác nhau về "blur":

| Nguồn | Ý nghĩa con số |
|---|---|
| CSS `box-shadow` / `drop-shadow` | bán kính blur, σ ≈ R/2 |
| CSS `filter: blur(R)` | R **chính là** độ lệch chuẩn σ |
| Flutter `BoxShadow.blurRadius` | quy đổi nội bộ σ = R × 0.57735 + 0.5 |

Chép thẳng số CSS vào `blurRadius` sẽ **dư ~20%** blur. Đã suy ngược để trúng σ
của CSS: `blurRadius = (σ − 0.5) / 0.57735`, ghi công thức và nguồn cạnh từng
giá trị trong `pc_elevation.dart`.

**Vẫn nợ**: 9 giá trị này cần so bằng mắt với bundle dựng trong trình duyệt
trước khi coi là chốt (research R10).

## 8. `ThumbBand` để hai khe bên co giãn, không cố định 104

Bản đầu tôi đặt hai khe hai bên cứng ở `touchShutterHit` (104). Test T067a
phát hiện **tràn 24px trên máy 320dp**: 104 × 3 + gutter 32 = 344 > 320.

Đã đổi sang `Expanded` cho hai bên, giữ nút chụp cố định ở giữa. Nguyên tắc:
thứ **không bao giờ** được bóp là vùng chạm 104 của nút chụp, không phải các
hành động phụ bên cạnh. Không lệch khỏi design — design không quy định chiều
rộng khe bên.

## 9. Cặp role ↔ tracking do readme quyết định, không do CSS

CSS shorthand `font:` mang family/weight/size/line-height nhưng **không mang
letter-spacing**, nên 10 composed role trong `typography.css` không tự nói
tracking của mình. Ghép theo quy tắc văn xuôi trong readme bundle: tracking âm
cho cỡ display, +0.08em cho readout mono, không tracking cho body. Ghi lại vì
đây là **quyết định**, không phải phiên dịch.

## 10. Cổng `check_no_hardcode.sh` có hai bug, lộ ra khi chạy thử

Siết cổng theo research R14 xong, chạy thử mới thấy:

1. `Colors\.` khớp cả phần đuôi của `PcColors.fromTokens()` → báo nhầm. Đã thêm
   ranh giới từ.
2. Luật số đo mới sót `EdgeInsets.all(13)` (dấu `(` bị alternation nuốt mất) và
   báo nhầm `context.pcSpacing.sp5` (chữ số nằm trong tên token). Đã tách thành
   hai dạng và chỉ bắt số literal đứng độc lập.

Ghi lại vì nó biện minh cho T004/T062: **cổng phải được chạy thử cả hai chiều**,
không chỉ viết ra. Một cổng báo nhầm sẽ bị người ta nới lỏng chứ không tuân theo.
