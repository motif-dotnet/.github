# Motif.NET brand

The one source for the suite's mark and wordmarks. Tools use these files (or copy them) instead of drawing their own.

| File | Use |
|---|---|
| [mark.svg](mark.svg) / [mark-dark.svg](mark-dark.svg) | The mark on its own, for light or dark backgrounds |
| [favicon.svg](favicon.svg) | Browser tab icon: the mark on a white rounded tile, so it shows on dark tab bars too |
| [motif-net.svg](motif-net.svg) / [motif-net-dark.svg](motif-net-dark.svg) | The suite lockup: mark + **Motif**.NET |
| [motif-sketch.svg](motif-sketch.svg) / [motif-sketch-dark.svg](motif-sketch-dark.svg) | Motif Sketch's lockup: mark + Motif **Sketch** |
| [avatar.svg](avatar.svg) / [avatar.png](avatar.png) | The org avatar, 512 × 512 on white (GitHub rounds the corners) |
| [social-preview-net.png](social-preview-net.png) / [social-preview-sketch.png](social-preview-sketch.png) | Link-preview cards, 1280 × 640, for each repo's Settings → Social preview: the lockup, a one-line description, the URL and an orange bar |
| [linkedin-banner-light.png](linkedin-banner-light.png) / [linkedin-banner-dark.png](linkedin-banner-dark.png) | LinkedIn profile banners, 1584 × 396: the lockup, the tagline and the org URL, kept to the right so the profile photo doesn't cover them |

## The mark

Three rounded squares stepping up to the right: an outline, a solid slate square, and a solid orange one. A shape repeating and taking form, from sketch to production.

On a 24 × 24 grid:

- All three squares are **7.16** wide with corner radius **1.86**, stepped by **6.42**, so they span 2 to 22.
- The bottom-left square's outline (1.8 wide) sits **inside** its square, so all three are the same size and both corner gaps are identical (**0.5**).
- Squares: `(2, 14.84)` outline, `(8.42, 8.42)` slate, `(14.84, 2)` orange.

## Colours

| | Light | Dark |
|---|---|---|
| Mark slate | `#334155` | `#CBD5E1` |
| Accent orange | `#EA580C` | `#FB923C` |
| Wordmark, strong | `#0F172A` | `#F1F5F9` |
| Wordmark, muted | `#64748B` | `#94A3B8` |

These are the Tailwind slate and orange values the tools already use. In an app that has its own light and dark themes, draw the mark with the theme's colours (`currentColor` and the accent variable) rather than these fixed ones.

## Wordmarks

IBM Plex Sans at 30 px beside a 48 px mark, 16 px apart. The suite name sets **Motif** in SemiBold and **.NET** in Regular, muted. A tool sets **Motif** in Regular, muted, and its own name in SemiBold, 8 px after.

The lockups embed IBM Plex Sans (Regular and SemiBold, Latin-1), so they render the same everywhere. IBM Plex is licensed under the SIL Open Font License 1.1.

## Adding a tool

Copy `motif-sketch.svg`, change the second `<text>` and its `<title>`, and set the width to fit the name.
