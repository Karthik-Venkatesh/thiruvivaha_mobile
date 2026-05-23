---
name: Thiruvivaha
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#594141'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#8c7071'
  outline-variant: '#e0bfbf'
  surface-tint: '#b02a3e'
  primary: '#7b001f'
  on-primary: '#ffffff'
  primary-container: '#9e1b32'
  on-primary-container: '#ffb0b3'
  inverse-primary: '#ffb3b5'
  secondary: '#864e5a'
  on-secondary: '#ffffff'
  secondary-container: '#feb6c3'
  on-secondary-container: '#7b4450'
  tertiary: '#4e3700'
  on-tertiary: '#ffffff'
  tertiary-container: '#694d0c'
  on-tertiary-container: '#e7bf75'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdada'
  primary-fixed-dim: '#ffb3b5'
  on-primary-fixed: '#40000c'
  on-primary-fixed-variant: '#8f0c28'
  secondary-fixed: '#ffd9df'
  secondary-fixed-dim: '#fbb3c0'
  on-secondary-fixed: '#360c18'
  on-secondary-fixed-variant: '#6b3742'
  tertiary-fixed: '#ffdea5'
  tertiary-fixed-dim: '#e9c176'
  on-tertiary-fixed: '#261900'
  on-tertiary-fixed-variant: '#5d4201'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Playfair Display
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Playfair Display
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 38px
  headline-lg-mobile:
    fontFamily: Playfair Display
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 20px
  stack-gap-sm: 12px
  stack-gap-md: 24px
  stack-gap-lg: 40px
  grid-gutter: 16px
---

## Brand & Style
The design system is centered on the concepts of "Enduring Elegance" and "Matrimonial Trust." It targets an audience seeking serious, long-term relationships, necessitating a UI that feels both romantic and authoritative. 

The aesthetic style is **Premium Minimalism** with subtle **Glassmorphism**. It prioritizes high-quality photography and expansive white space to allow profile details to breathe. The emotional response should be one of calm confidence—moving away from the frantic nature of dating apps toward the intentionality of a matrimony service. Elements are refined, using thin strokes and sophisticated color transitions to evoke a sense of luxury and tradition.

## Colors
The palette uses a "Heritage Crimson" as the primary anchor, symbolizing deep-rooted tradition and passion. This is complemented by "Petal Rose" for secondary interactions, softening the overall experience. "Champagne Gold" is reserved for premium features, success states, and decorative accents to signify high-value matches.

The background is predominantly "Alabaster White" (#FFFFFF) with "Mist Grey" (#F2F2F2) used for surface differentiation. This high-contrast environment ensures that profile imagery remains the focal point while maintaining a clean, editorial look.

## Typography
The typography strategy pairings a sophisticated Serif (Playfair Display) for headlines to evoke a sense of history and editorial quality, with a modern Sans-Serif (Manrope) for body text to ensure maximum readability on mobile devices.

Headlines should use tight letter spacing for a more "locked-in" professional look, while body text uses a generous 1.6x line height to prevent fatigue during long profile browsing sessions. Labels and metadata use uppercase Manrope to create a distinct hierarchy between personal narrative and structured data.

## Layout & Spacing
The layout follows a **Fluid Grid** model optimized for narrow mobile viewports. It utilizes a 4-column grid for mobile and an 8-column grid for tablet. 

Spacing is governed by an 8px base unit. A "Comfortable" density is preferred, meaning larger vertical gaps between distinct sections (e.g., separating 'Personal Bio' from 'Family Details' with 40px) to imply a premium, unhurried experience. Margins are fixed at 20px on mobile to prevent content from feeling cramped against the screen edges.

## Elevation & Depth
Depth is created through **Tonal Layers** and **Ambient Shadows**. Instead of heavy shadows, the system uses "Tinted Elevations" where an elevated card might have a very subtle Crimson or Gold glow rather than a neutral grey shadow.

Profile images utilize a **Champagne Glassmorphism** overlay at the bottom 30% of the image to house names and ages, using a backdrop-blur (12px) and a semi-transparent white fill (60% opacity). This ensures text legibility over any photo background while maintaining a light, airy feel.

## Shapes
The shape language is "Softly Formal." While sharp corners are too aggressive for a matchmaking app, fully circular pills can feel too "social media" or casual. A **Rounded (0.5rem)** corner radius is the standard for cards and input fields. 

Buttons utilize a slightly larger radius (1rem) to feel more inviting to the touch. Profile pictures should use a subtle squircle or a 1.5rem radius to stand out from structural containers.

## Components

### Buttons
- **Primary:** Heritage Crimson background with White text. Used for "Connect" or "Send Interest."
- **Secondary:** Outlined Crimson or Petal Rose background. Used for "Message" or "View Details."
- **Ghost:** Gold text only, for secondary actions like "Skip" or "Report."

### Cards
- Profile cards should have a "Photo-First" layout. The image occupies the top 70%, with a soft transition or glassmorphic overlay for name and location. 
- Information cards (Bio, Education) use a Mist Grey background to separate them from the Alabaster page surface.

### Input Fields
- Inputs are "Floating Label" style. The border is a 1px Mist Grey, turning Heritage Crimson on focus. 
- Error states should use a soft rose background tint with dark red text.

### Chips & Badges
- Used for "Interests" or "Values." These are small, Petal Rose tinted containers with Crimson text, using the `label-caps` typography style.

### Connection Feedback
- When a match occurs, use a full-screen "Champagne Gold" gradient overlay with high-contrast Playfair Display typography to celebrate the moment.