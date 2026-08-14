# ProductCam — Design System

ProductCam (working name) is a **mobile utility app**: a smart camera that separates the background from product photos in real time. Open it and you immediately see the object's contour traced over the live viewfinder, before the shutter is pressed — like a dedicated product-photo instrument. Capture, and the cutout is produced automatically: transparent, white, coloured, gradient, with or without a drop shadow.

- **Users:** online sellers, small shop owners, freelancers in Vietnam. Fast, repetitive work. No Photoshop knowledge, no interest in learning it.
- **Platforms:** iOS, Android, tablet — one Flutter codebase.
- **Job to be done:** shoot → check the cutout → set a background → export. Then close the app. It is a tool, not a place to spend time.
- **Primary competitors:** Background Eraser, remove.bg, PhotoRoom. All look alike: white background, blue accent, big soft buttons, generic outline icons.

## Sources

The only source for this system was the written brief pasted into chat (in Vietnamese) describing the product, target users, screen list, and constraints. **No codebase, Figma file, repository, screenshots, logo, fonts, icon set, or product photography were provided.** Everything here was authored from that brief. If the real assets exist, hand them over and this system should be re-grounded on them — see **Open gaps** at the bottom.

---

## The signature element: the live contour

The competitive advantage of this app is that **you see the result while you aim**, not after you upload. So the interface is built around the thing that proves it: a traced object contour, and the visual grammar that comes from it.

**How it is drawn — always two strokes:**

1. a 6px near-black halo (`--contour-halo`, ink at 62%)
2. a 2.5px mint core on top (`--contour-core`, `#1FE3C2`)

The halo is not decoration. The camera can point at anything — a white paper sweep, warm cardboard, black leather, a backlit window — and a single-colour line will vanish against one of them. The dark-under-bright pair survives all of them, which is why the contour is never allowed to be drawn as one stroke.

**State is carried by dash and motion, not by hue** (so it survives blown highlights and colour-blindness):

| State | Look | Meaning |
| --- | --- | --- |
| `scanning` | mint dashes marching (1.1s loop) + a soft sweep inside the silhouette | edge found but not yet stable — hold still |
| `locked` | solid, brighter core (`#EAFFFA`) + one 380ms pulse + mint glow, shutter ring turns mint | edge is stable — shoot now |
| `review` | amber dotted (`2 7`) | complex edge (fur, hair, glass) — usable, may want a manual pass |

**How the motif spreads through the system** — this is what makes it a design language rather than a feature:

- **The shutter ring is a status light.** White while scanning, mint + glow the instant the contour locks. The user's finger is already on it; the confirmation happens under their thumb.
- **Progress is a traced ring** (`ProgressTrace`) — the same line being drawn around a subject, applied to time.
- **Selection is a lock**, not a border colour change: background swatches and batch thumbnails get the mint ring + tick, the same mark the viewfinder used to promise the cutout.
- **The contour reappears on the result** in Review, over the checkerboard. The mark that made the promise confirms it.
- **Corner framing ticks** (instrument reticle) bracket the subject, echoed by the mono readouts.

### Self-critique: is this the generic utility-camera formula?

The formula to avoid was *white background + blue accent + generic outline icons + one big round button*. Checks made while building the tokens:

- **Light UI was rejected.** A camera app whose main surface is a live video feed cannot be white; chrome must recede so the subject dominates. Ink navy (`#04090F`–`#112232`) also makes the mint contour readable, which a white shell would not.
- **Blue was rejected** for the accent. Blue is the category default and is a common colour in real products and packaging, so it competes with the subject. Mint-cyan `#1FE3C2` is rare in physical goods and rare in the category.
- **Risk acknowledged:** dark UI + cyan accent is its own cliché ("developer tool"). The defence is that the accent is *functional* — it only appears where the machine is reporting what it sees (contour, lock, progress, selection) — plus a deliberately unfashionable second voice: IBM Plex Mono readouts in uppercase, which read as instrument, not as consumer app.
- **Amber, not red, for complex edges.** Target users are not technical. A red warning would read as "your photo failed" when the photo is fine.
- **The checkerboard was not redesigned.** It is the one convention already in the users' eyes from other tools. Inventing a new symbol for transparency would be a net loss.
- **The shutter is spec'd before it is styled:** 80px visible disc inside a 104px hit target, centred in the bottom 132px thumb band, nothing tappable within 12px. In batch mode it shows a mono shot count so the user never has to look away.

---

## CONTENT FUNDAMENTALS

**Language:** the product ships in Vietnamese. All UI copy in this system is Vietnamese; English appears only in code, tokens, and documentation.

**Voice:** plain, practical, second-person implied. The app describes what it is doing or what the user can do, and stops. No enthusiasm, no marketing adjectives, no exclamation marks.

- Status: `Đang tìm vật thể` · `Đã khoá viền` · `Đang xử lý 3 ảnh` · `Đã xong tất cả`
- Actions: `Chụp lại` · `Chấp nhận` · `Xuất tất cả (10)` · `Lưu vào máy` · `Chụp thêm`
- Gentle hint: **Viền hơi phức tạp** — "Ảnh có phần lông/tóc hoặc vùng trong suốt. Bạn có thể dùng luôn, hoặc chỉnh viền cho gọn hơn." Then two exits: `Chỉnh viền` / `Vẫn dùng`.
- Confirmation: `Đã lưu 6 ảnh vào máy` + `Xem`.

**Rules:**

- **Never blame the user, never dramatise.** The word for imperfect output is *phức tạp* (complex), not *lỗi* (error). `Lỗi` is reserved for a genuine processing failure that can be retried.
- **Casing:** sentence case for anything a person wrote. UPPERCASE only in mono readouts and badges (`XONG`, `CẦN XEM LẠI`, `PNG · 1200×1200`).
- **Numbers are facts, and they are always in mono.** Counts, dimensions, file sizes, durations, shot indices (`04 / 12`).
- **Labels are short enough to read at arm's length while holding a product:** 1–3 words on buttons, 1–4 words in a readout.
- **No emoji, anywhere.** This is an instrument.
- **No feature marketing inside the app.** No "AI-powered", no "magic". The contour already demonstrates the capability.
- **Tone in error states:** state the fact, offer the retry. `1 ảnh xử lý chưa xong` + `Thử lại`.

---

## VISUAL FOUNDATIONS

**Colour.** Cool ink navy shell (`--ink-950` → `--ink-600`) carries every surface; mint (`--mint-500`) is the single signal colour and is spent only on machine feedback and the one primary action per screen; amber (`--amber-500`) means "worth a look", never failure; coral (`--coral-500`) is failure only. Maximum two background values on a screen (`--bg-app` + `--bg-surface`/`--bg-surface-raised`). Light surfaces exist only as the checkerboard and inside export previews.

**Type.** Manrope for everything a human wrote (400/500/600/700/800, tracking −0.01 to −0.03em on display sizes); IBM Plex Mono for machine facts, uppercase, +0.08em tracking. Both carry the Vietnamese subset. Scale: 34 / 26 / 21 / 18 / 17 / 16 / 14 / 13 / 11. Body line-height 1.45, `text-wrap: pretty` on any paragraph. Prose is never set in mono; readouts are never set in Manrope.

**Spacing & layout.** 4px base (`--sp-1` … `--sp-12`), 16px gutter, 20px sheet padding, **6px** grid gap between photo thumbnails (the photos are the interface; chrome between them is waste). Fixed bands, always in the same place: 44px status bar, 56px header, and a **132px bottom thumb band** (`--thumb-band`) that holds every primary action. Nothing destructive ever lives in that band. Touch: 44px minimum, 56px comfortable, 80px shutter inside a 104px hit area.

**Backgrounds.** No photography in the chrome, no illustration, no pattern except one: the transparency checkerboard (8px squares, `#FFFFFF`/`#D8DEE3` — the Photoshop/Figma values). Over the live feed, content legibility comes from two scrim gradients (`--scrim-top`, `--scrim-bottom`), never from a solid bar. Gradients appear in exactly two other places: user-selectable export backgrounds, and the mint sweep inside a scanning contour. **No decorative gradients on chrome.**

**Elevation.** Depth is rims and glow, not drop shadows: `--rim` (1px inset white 8%) on every raised surface, `--glow-accent` for anything locked or focused. Real shadows appear only where a layer floats over the live feed or over content — `--shadow-float` for pills, `--shadow-sheet` for bottom sheets, `--shadow-thumb` for thumbnails.

**Transparency & blur.** Glass (`--bg-glass` + `--blur-chrome`, 18px blur / 1.1 saturate) is used only for controls sitting on top of the camera feed or a photo — camera chrome, readouts, toasts, mode toggle. Never on an opaque screen; a sheet over a solid background is solid.

**Borders.** Hairlines only: `--border-hairline` (white 8%) for structure, `--border-subtle` (14%) on glass, `--border-accent` for a locked/selected element. No 2px outlines except the contour and selection rings.

**Corner radii.** 6 / 10 / 14 / 20 / 28; sheets 24 (top corners only), thumbnails 12, pills for every control that is pressed. Cards are `--r-md` surfaces with a rim and no border — never a shadowed white card, never a coloured left border.

**Motion.** Feedback only. 90ms press, 140ms colour, 220ms sheets and the mode-toggle slide, 380ms lock pulse. `--ease-snap` (`cubic-bezier(.2,.9,.2,1)`) for anything the finger caused; `--ease-out` for entrances. The single loop in the product is the 1.1s contour trace + sweep, and it is a status indicator, not an animation. No bounce, no spring, no parallax, no decorative motion — battery and speed both matter to someone shooting 40 items.

**Press & hover.** This is a touch product: press states are primary. Press = `scale(.955)` (shutter `.90`) plus one step darker fill (`--accent-press`). Hover exists only for the desktop preview of these files and does nothing more than lift the surface one step. No hover-only affordances.

**Imagery.** Product photography is the content, never the decoration; the app adds nothing to it. Cutouts always sit on the checkerboard or on a user-chosen background — never on ink, which would fake a "premium studio" look the app did not produce. Colour treatment of the user's photo is untouched: no filters, no grain, no warm/cool grade.

---

## ICONOGRAPHY

- **System:** [Lucide](https://lucide.dev) (`lucide@0.474.0`), loaded from the unpkg CDN and wrapped by the `Icon` component. **This is a substitution, flagged:** the brief supplied no icon set, and Lucide's 1.75px-ish geometric outline style matches an instrument-like camera utility better than a filled/rounded set. If ProductCam has its own glyphs, drop them in and rewrite `Icon` to read them; nothing else needs to change.
- **Stroke weight is fixed at 1.75** (`--stroke-icon`), round caps and joins. Sizes: 14 in badges/readouts, 16–18 inline, 22 in chrome, 26 in `IconButton lg`.
- Icons are **monochrome and inherit `currentColor`.** They are never coloured for decoration; colour only follows state (mint = locked/confirm, amber = review, coral = error).
- **No emoji, ever.** No unicode glyphs standing in for icons. Only two non-Lucide marks are permitted, both typographic: the middot separator in readouts (`PNG · 1200×1200`) and `×` in dimensions.
- Working vocabulary: `camera`, `images`, `layers`, `image`, `zap` / `zap-off`, `refresh-cw`, `rotate-ccw` / `rotate-cw`, `grid-3x3`, `settings-2`, `check`, `x`, `scissors` (complex edge / edit edge), `download`, `share-2`, `clock`, `search`, `chevron-left`, `more-horizontal`, `loader`, `plus`, `undo-2`, `signal-high`, `wifi`, `battery-full`.
- **`scissors`, never `alert-triangle`,** for the complex-edge notice. No triangles, no exclamation marks, no red circles anywhere in the product.
- **No logo was supplied.** The brand name is set in type (Manrope 800, −0.03em, "Cam" in `--mint-500`) wherever a mark would go — see `guidelines/wordmark.card.html`. Do not draw or approximate a mark.

---

## Flutter mapping

Tokens are named so they land in `ThemeData` without translation:

| CSS | Flutter |
| --- | --- |
| `--bg-app`, `--bg-surface`, `--bg-surface-raised` | `ColorScheme.dark(surface:, surfaceContainer:, surfaceContainerHigh:)` |
| `--accent`, `--accent-press`, `--text-on-accent` | `primary`, pressed overlay, `onPrimary` |
| `--caution`, `--danger` | custom `ThemeExtension` (`PcSemantics`) + `error` |
| `--type-*` roles | `TextTheme` (`displaySmall`, `headlineSmall`, `titleMedium`, `bodyLarge`, `bodyMedium`, `labelSmall` for mono readouts) |
| `--r-*` | `BorderRadius` constants; `--r-pill` → `StadiumBorder` |
| `--sp-*`, `--touch-*`, `--thumb-band` | `PcSpacing` ThemeExtension |
| `--dur-*`, `--ease-*` | `PcMotion` ThemeExtension (`Duration` + `Curves.cubic`) |
| `--contour-*`, `--checker-*` | `PcContour` ThemeExtension, consumed by the `CustomPainter` that draws the mask outline |

The contour is a `CustomPainter` over the camera preview: paint the halo `Path` first (stroke width 6, `ink 62%`), then the core (2.5, mint), then the dash phase animation. `--checker-size: 16px` = an 8px `TileMode.repeated` shader.

---

## Index

**Root**
- `styles.css` — the single entry point consumers link (imports only).
- `readme.md` — this file. `SKILL.md` — Agent Skills wrapper. `thumbnail.html` — homepage tile.

**`tokens/`** — `fonts.css` (Google Fonts CDN: Manrope + IBM Plex Mono), `colors.css`, `typography.css`, `spacing.css`, `radius.css`, `elevation.css`, `motion.css`, `contour.css` (signature layer + checkerboard + keyframes), `base.css`.

**`guidelines/`** — 15 specimen cards: Colors (ink, mint, status, surfaces, transparency), Type (display, body, mono), Spacing (scale, touch targets, radii, elevation), Brand (contour states, motion, wordmark).

**`components/`** — 16 primitives, each with `.jsx`, `.d.ts`, `.prompt.md`; one `@dsCard` per folder.

| Group | Components |
| --- | --- |
| `core/` | `Icon`, `Button`, `IconButton`, `Chip`, `Badge`, `Sheet` |
| `camera/` | `ContourOverlay` ★, `ShutterButton` ★, `ModeToggle`, `Readout` |
| `editor/` | `CheckerSurface` ★, `BackgroundSwatchPicker` ★, `Slider` |
| `batch/` | `BatchThumb` ★, `ProgressTrace` |
| `feedback/` | `EdgeNotice`, `Toast` |

★ = the repeated elements called out in the brief.

**`templates/camera-capture/`** — a Design Component template (`CameraCapture.dc.html`) consuming projects can start from: the viewfinder screen with tweakable contour state, subject, capture mode, shot count.

**`ui_kits/productcam-app/`** — 6 screens + `Shell.jsx` + click-through `index.html`. See its README.

### Intentional additions
- **`Icon`** — a thin wrapper over the Lucide CDN set. Needed because no icon assets were supplied; it exists so a future swap to real glyphs touches one file.
- **`Toast`** — not named in the brief, but Export and delete/undo both need a non-blocking confirmation. Kept to one line, one action.

## Open gaps (please fill)

1. **Fonts** — no binaries supplied. Manrope + IBM Plex Mono are loaded from the Google Fonts CDN (both include the Vietnamese subset). Send the real brand fonts and I will self-host them with proper `@font-face` rules.
2. **Logo / app icon** — none supplied; the wordmark is plain type by design.
3. **Icons** — Lucide substitution, flagged above.
4. **Product photography** — every camera feed and cutout is a CSS/SVG placeholder.
5. **Naming** — "ProductCam" is the working name from the brief.
