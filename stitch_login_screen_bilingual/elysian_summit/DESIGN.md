```markdown
# Design System Specification: The Executive Presence

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Concierge"**

This design system is not a utility; it is a world-class environment designed for high-stakes professional networking and global exchange. To move beyond the "template" look of standard corporate apps, we employ a philosophy of **Editorial Depth**. We treat the screen as a series of physical, layered materials—obsidian glass, fine-milled charcoal paper, and illuminated gold leaf. 

The system rejects the rigid, boxy constraints of traditional Material Design in favor of **Intentional Asymmetry**. We use high-contrast typography scales (the tension between massive `display-lg` headings and whisper-quiet `label-sm` metadata) to create a rhythm that feels curated, not generated.

---

## 2. Colors
Our palette is rooted in the "Deep Night" spectrum, using tonal shifts rather than lines to define the interface.

### The "No-Line" Rule
**Explicit Instruction:** Solid 1px borders for sectioning are strictly prohibited. Boundaries must be defined solely through background color shifts. For example, a `surface-container-low` section sitting on a `surface` background creates a natural, sophisticated break.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack. The deeper the content, the darker the surface.
*   **Base Layer:** `surface` (#131313)
*   **Secondary Content:** `surface-container-low` (#1C1B1B)
*   **Elevated Cards:** `surface-container` (#201F1F)
*   **Interactive Overlays:** `surface-container-highest` (#353534)

### The "Glass & Gold" Signature
*   **Glassmorphism:** For floating navigation or modal headers, use `surface-variant` at 60% opacity with a `20px` backdrop blur. This allows the deep navy (`primary-container`) to bleed through, creating a "frosted obsidian" effect.
*   **Gilded Accents:** Use the Tertiary Gold (`tertiary` #E9C176) sparingly. It is reserved for high-value CTAs, "VIP" status indicators, and key active states. It should feel like a rare metallic inlay, not a primary color.

---

## 3. Typography
We utilize a pairing of **Manrope** (Display) and **Inter** (Interface).

*   **Display & Headline (Manrope):** These are our "Voice." Use `display-lg` with a `-0.02em` tracking for a tight, authoritative impact. For `headline-sm`, use `0.05em` letter spacing to evoke the feeling of a premium watch brand's catalog.
*   **Body & Label (Inter):** These are our "Utility." Inter provides the high legibility required for dense conference schedules. 
*   **The Hierarchy Shift:** To convey world-class authority, always pair a `display-md` headline with a `label-md` uppercase subtitle (using the `tertiary` gold color) placed *above* the headline.

---

## 4. Elevation & Depth
We abandon the "drop shadow" of 2014. We achieve depth through **Tonal Layering**.

### The Layering Principle
Depth is achieved by "stacking" the surface-container tiers. Place a `surface-container-lowest` card on a `surface-container-low` section to create a soft, natural recession. 

### Ambient Shadows
When a floating effect is required (e.g., a Bottom Sheet or Modal), use an **Ambient Shadow**:
*   **Y-Offset:** 16px | **Blur:** 40px
*   **Color:** `on-background` at 6% opacity. 
*   *Note: This creates a glow of light rather than a dark "shadow," making the element feel like it’s emitting presence.*

### The "Ghost Border" Fallback
If an element requires a container (like an input field), use a **Ghost Border**:
*   `outline-variant` (#454652) at **15% opacity**.
*   It should be felt, not seen.

---

## 5. Components

### Buttons
*   **Primary:** `primary-container` (#1A237E) background with `on-primary-container` text. Apply a subtle linear gradient from top-left (Primary) to bottom-right (Primary Container) for a "silk" finish.
*   **Secondary:** Ghost style. No background, `outline-variant` Ghost Border, `on-surface` text.
*   **Shape:** Use `rounded-md` (0.375rem) for a sharp, professional "tailored" look. Avoid full-rounded pills which feel too "consumer-grade."

### Cards & Schedules
*   **Strict Rule:** No dividers. Use `spacing-6` (2rem) of vertical white space to separate sessions.
*   **Visual Anchor:** Use a 4px vertical bar of `tertiary` (Gold) on the left side of "Live Now" session cards.

### Input Fields
*   **State:** Background should be `surface-container-lowest`. 
*   **Focus:** Transition the Ghost Border to 100% opacity `primary` (#BDC2FF) and add a 2px "outer glow" using the same color at 10% opacity.

### Featured Component: The "VIP Speaker" Card
A specialized card using `surface-container-high`, a `tertiary` (gold) `label-sm` for the speaker's title, and a background-blur treatment on the speaker's name to ensure legibility over professional photography.

---

## 6. Do's and Don'ts

### Do
*   **Do** use `spacing-12` and `spacing-16` for section breathing room. Luxury is defined by wasted space.
*   **Do** use `tertiary-fixed-dim` for "Gold" text on dark backgrounds to ensure WCAG AA accessibility.
*   **Do** use intentional asymmetry—place a small `label-md` element off-center to break the "grid" feel.

### Don't
*   **Don't** use 100% white (#FFFFFF). Use `on-surface` (#E5E2E1) to reduce eye strain and maintain the premium "charcoal" atmosphere.
*   **Don't** use standard "Success Green" or "Warning Orange" at full saturation. Tint them with `surface-variant` to keep them within the professional palette.
*   **Don't** use heavy card shadows. If the background shift isn't enough, your layout is too crowded. Simplify.

---

## 7. Spacing Scale
Always use the following increments to maintain rhythmic consistency:
*   **Micro-adjustments:** `0.5` (0.175rem) or `1` (0.35rem)
*   **Component Padding:** `3` (1rem) or `4` (1.4rem)
*   **Section Gaps:** `8` (2.75rem) or `12` (4rem)
*   **Hero Margins:** `20` (7rem)