# Specification Quality Checklist: Design System & Theme

**Purpose**: Validate specification completeness and quality before proceeding to planning
**Created**: 2026-08-14
**Feature**: [spec.md](../spec.md)

## Content Quality

- [x] No implementation details (languages, frameworks, APIs)
- [x] Focused on user value and business needs
- [x] Written for non-technical stakeholders
- [x] All mandatory sections completed

## Requirement Completeness

- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Requirements are testable and unambiguous
- [x] Success criteria are measurable
- [x] Success criteria are technology-agnostic (no implementation details)
- [x] All acceptance scenarios are defined
- [x] Edge cases are identified
- [x] Scope is clearly bounded
- [x] Dependencies and assumptions identified

## Feature Readiness

- [x] All functional requirements have clear acceptance criteria
- [x] User scenarios cover primary flows
- [x] Feature meets measurable outcomes defined in Success Criteria
- [x] No implementation details leak into specification

## Notes

**Validation result: 16/16 pass after the 2026-08-14 clarification session.**
Initial validation was 15/16 with two open markers (FR-015, FR-026); both were
resolved along with three further ambiguities. See "Resolved by clarification" below.

Four items needed a judgement call rather than a plain tick, recorded here so a
reviewer does not have to re-derive them:

1. **"No implementation details" in a spec whose subject is infrastructure.** The
   spec deliberately names no framework construct, no package, no typeface brand,
   and no file path in its requirements — it says "definition layer" rather than
   the framework's theming mechanism, "the product's two typefaces" rather than
   the font names, and "single entry point" rather than a wrapper class. What it
   does name are *design decisions already ratified* (two-stroke contour, mint as
   the only signal colour, amber never meaning failure, fixed 56/132 bands, touch
   minimums). Those are the deliverable, not the approach. Counted as pass.

2. **This spec has two audiences, as Spec #001 did.** Stories 1–3 are observable
   by any reviewer who opens the app. Stories 4 and 5 serve the development team
   and are deprioritized to P2 to reflect that they are not user-facing. They were
   kept because they are the entire reason the spec must merge before Spec #004 —
   without them the visual system does not survive six more screen specs.

3. **SC-008's 1.5 MB type budget is a chosen ceiling, not a measured baseline.**
   It exists to catch a careless full-character-set embed, in a project where app
   size is a named top-three risk. If correct Vietnamese coverage cannot fit inside
   it, the budget is what gets revisited — not the coverage. Flagged in Assumptions.

4. **Reference-image checks are scoped to the pinned toolchain.** Cross-environment
   rendering differences are declared out of scope rather than engineered around.
   This is only defensible because the toolchain is pinned exactly (Spec #001) and
   the typefaces are embedded rather than fetched. If either changes, revisit.

**Resolved by clarification (session 2026-08-14):**

- **FR-026 / FR-026a** — icons ship as bundled vector glyphs at the documented
  stroke weight, limited to the design's working vocabulary. A pre-rendered set was
  rejected because its baked stroke weight would have been frozen into every
  reference image as the standard.
- **FR-015** — six embedded weights, not eight. An audit of the ten composed type
  roles found all five prose weights referenced but only one of three mono weights.
- **FR-015a / SC-012** — enlarged system text is honoured to 1.3× and capped there,
  so the fixed 56/132 bands never stretch and the shutter stays under the thumb.
- **FR-022a** — the light checkerboard is the default at preview size; the dark
  variant is for grid thumbnails only. This unblocks Specs #004, #005 and #007,
  which would otherwise each have guessed.
- **FR-027a** — reduced motion stops every loop and pulse; states hold their static
  shape and stay separable by dash pattern alone.

**Deliberately excluded and worth confirming during planning:**

- No product capability, no new screen, no layout work. The seven placeholder areas
  gain appearance only (FR-008, SC-011).
- No live camera wiring for the contour — Spec #003 owns that (FR-019). This spec
  builds the renderer against a supplied outline, so the two specs must not both
  build it.
- No light theme, no runtime appearance switch, no colour picker (FR-007). Adding
  one is a constitutional amendment, not a follow-up task.
- No fixed content inside components that later specs own — the seven backgrounds
  (Spec #005) and the batch states (Spec #006) stay with their own specs (FR-022).

**Known documentation defect surfaced while writing this spec:** `dev-workflow.md`
and Constitution Principle VIII both direct implementers to a `ui_kits/productcam-app/`
folder inside the design bundle. That folder does not exist on disk; the component
sources are compiled into `_ds_bundle.js`. The spec's Assumptions section works
around it, but the two documents should be corrected — the constitution change
requires an amendment.
