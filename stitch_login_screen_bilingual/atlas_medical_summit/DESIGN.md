# Design System Specification: The Academic Editorial

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Curator"**

This design system moves away from the clinical, cold "software" look of traditional medical portals. Instead, it adopts the persona of a high-end, authoritative medical journal or a curated gallery. The "Digital Curator" approach prioritizes intellectual breathing room, using intentional asymmetry and high-contrast typography to guide the eye through complex medical data and conference schedules.

To break the "template" feel, we reject rigid, boxed-in grids. Instead, we use **layered surfaces** and **editorial-style white space**. Elements should feel "placed" on a page rather than "slotted" into a table. By utilizing a high-contrast scale between Noto Serif (Display) and Inter (UI), we create an environment that feels both historically prestigious and technologically advanced.

---

### 2. Colors & Surface Philosophy

The palette is anchored in intellectual depth. We utilize a "Tonal-First" approach, where hierarchy is defined by light and shadow rather than lines.

#### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts. For instance, a `surface-container-low` section should sit against a `surface` background. If you feel the need for a line, increase the padding instead.

#### Surface Hierarchy & Nesting
Treat the UI as a physical stack of premium cardstock.
- **Base Layer:** `surface` (#f3faff)
- **Deep Content Wells:** `surface-container-lowest` (#ffffff) for primary reading areas.
- **Interactive Layers:** `surface-container` (#dbf1fe) for navigation or secondary panels.
- **Elevated VIP Zones:** Use `tertiary_fixed` (#ffdea5) sparingly to denote prestigious content or VIP status, creating a "gold-leaf" effect against the navy.

#### Signature Textures & Gradients
To avoid a flat, "cheap" digital feel:
- **The Hero Gradient:** Use a subtle linear transition from `primary` (#000666) to `primary_container` (#1a237e) for large header backgrounds.
- **Glassmorphism:** For floating navigation or modal overlays, use `surface` at 80% opacity with a `24px` backdrop-blur. This ensures the medical photography beneath stays visible but non-distracting.

---

### 3. Typography: The Bilingual Authority

The system uses a pairing of **Noto Serif** (Sophistication/Tradition) and **Inter** (Precision/Clarity).

- **Display & Headlines (Noto Serif):** Used for titles, keynote speaker names, and section headers. The serif nature suggests the long-standing tradition of medical excellence.
- **UI & Labels (Inter):** Used for data, schedules, and interactive elements. Its high X-height ensures legibility in both English and Chinese at small scales.

**Bilingual Hierarchy:**
When displaying English and Chinese together, the Chinese text should be set 10% smaller than the English text to balance visual "weight," as Chinese characters appear denser. Use `on_surface_variant` (#454652) for translated sub-text to maintain a clear primary focus.

---

### 4. Elevation & Depth

We convey importance through **Tonal Layering** rather than traditional shadows.

- **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a soft, natural lift that mimics the way light hits layered paper.
- **Ambient Shadows:** Shadows are reserved for "Floating" elements only (e.g., Modals). Use the `on_surface` color tinted at 4% opacity with a 32px blur and 8px Y-offset. Never use pure black shadows.
- **The "Ghost Border" Fallback:** If accessibility requires a container edge, use the `outline_variant` token at **15% opacity**. This provides a "suggestion" of a boundary without cluttering the editorial flow.

---

### 5. Components

#### Buttons
- **Primary:** `primary` background with `on_primary` text. Use `xl` (0.75rem) roundedness for a modern yet stable feel. Use a subtle gradient transition on hover.
- **VIP Action:** `tertiary_fixed` background. Reserved strictly for registration or high-value conversions.
- **Tertiary:** No background. Use `primary` text weight `600` with a `surface-variant` hover state.

#### Input Fields
- **Style:** Use "Quiet" inputs. No heavy borders. Only an `outline-variant` bottom-stroke (10% opacity) that becomes `primary` (100% opacity) on focus.
- **Background:** `surface-container-low`.

#### Cards & Lists
- **The No-Divider Rule:** Forbid the use of horizontal divider lines. Use `12` (4rem) spacing from the scale to separate list items, or subtle background shifts (`surface-container-low` vs `surface-container-high`).
- **Medical Professionals Cards:** Use high-quality photography with a `surface-container-lowest` base. The image should slightly overlap the card boundary (asymmetric layout) to break the grid.

#### Chips
- **Filter Chips:** Use `secondary_container` with `on_secondary_container` text. Roundedness should be `full` to contrast against the sharp editorial layout.

---

### 6. Do’s and Don’ts

#### Do
- **Do** use `20` (7rem) or `24` (8.5rem) spacing between major sections to emphasize authority and calm.
- **Do** align serif headlines to the left, but allow body text to be inset by `8` (2.75rem) to create an asymmetrical editorial rhythm.
- **Do** use `on_tertiary_fixed_variant` for text over Gold accents to ensure AAA accessibility.

#### Don’t
- **Don’t** use shadows on cards that are resting on the background; use tonal shifts instead.
- **Don’t** use "Medical Blue" (#007AFF); stick to our `Deep Navy` for a more prestigious, conference-grade feel.
- **Don’t** use 100% black text. Always use `on_surface` (#071e27) for a softer, premium ink-on-paper look.
- **Don’t** crowd the interface. If a screen feels "busy," the design system is being misused. Authority comes from what you choose to leave out.