# Motif web kit

The look and chrome every Motif web tool shares, so a new tool, or the suite's landing page, starts consistent and stays that way. Motif Sketch and Motif Glossary both use it.

Each app keeps its own **copy**, made by `scripts/sync-suite.sh`, rather than a package: no publishing step, and an app builds offline. A workflow in each app (`.github/workflows/suite.yml`) runs `scripts/sync-suite.sh --check` on every push and weekly, and goes red when the app's copy differs from this folder. It never blocks a deploy.

## What's in it

| File | Copied to (in the app project) | What it is |
|---|---|---|
| [motif.css](motif.css) | `wwwroot/css/motif.css` | IBM Plex, the slate palette with its dark twin, and the shared chrome: splash, app bar, brand, commands, buttons, menus, banners, cards and dialogs, fields, toasts, Blazor's error bar, and the narrow and phone breakpoints |
| [fonts/](fonts/) | `wwwroot/fonts/` | IBM Plex Sans (Regular, Medium, SemiBold) and Mono (Regular), Latin-1 subsets, with the SIL Open Font License |
| [Suite/](Suite/) | `Suite/` | C# and Razor in namespace `Motif.Suite`: the icons, the tool list, the toaster, and four components |
| [sync-suite.sh](sync-suite.sh) | `scripts/sync-suite.sh` (repo root) | The script that copies all this, and checks for drift |

The components in `Suite/`:

| Component | Use |
|---|---|
| `ToolSwitcher` | The brand at the left of the app bar: the mark and "Motif *Tool*", opening a menu of the Motif tools (from `Tools.All`), with this tool marked |
| `ThemeMenu` | System, Light or Dark, with icons and "Remembered in this browser only." The app stores the choice in `localStorage` under `motif-theme`, which every tool on motif-dotnet.github.io shares |
| `HelpDialog` | The Help dialog's frame, titled with the tool's name and line. The app writes the content |
| `ToastList` | Toasts at the bottom right, from a `Toaster` |

The components hold no state of their own: the app says which menu is open and what the theme is, so one click outside closes every menu.

## Conventions

- **Orange means "look here"**: the selection, proposed, a warning, the primary button. Never decoration.
- **Banners** show the state of what's on screen, for as long as it lasts (read-only, a sketch file that couldn't be read). **Toasts** report the outcome of a command (saved, copied, couldn't be opened). A title-only note goes after 3.5 s; anything with a sentence to read, and every warning or problem, stays 10 s.
- **Code**: `<code>` is code in prose (file, class and member names), in monospace in the text colour. `.code` is keys and formats (`Ctrl+S`, `SVG`), muted.
- **Narrow screens** (below 900 px): a command's label goes in a `<span class="wide">`, so only its icon shows. **Phones** (below 600 px) drop "Motif" from the brand, and any `.long` text in pills and primary buttons.
- **Help**: every tool has a Help button at the right of the app bar, after the theme menu.
- The app's own `css/app.css` comes after `css/motif.css`, and holds only what's specific to the app.

## Using it in a tool

1. Copy `sync-suite.sh` to `scripts/` at the repo root and run it (`bash scripts/sync-suite.sh`, or `--from ../path/to/.github` for a local clone).
2. Add `@using Motif.Suite` to `_Imports.razor`, and register a `Toaster` (or a class derived from it) as a singleton.
3. In `index.html`: link `css/motif.css` before `css/app.css`, preload the Plex Regular and SemiBold fonts, apply the remembered theme before the first paint, show the splash, and give the error bar a sentence that says what's safe (Motif Sketch's and Motif Glossary's `index.html` are the models).
4. Add the tool to `Tools.All` in [Suite/Tools.cs](Suite/Tools.cs), then sync the other tools so their switchers list it.
5. Copy [the workflow](https://github.com/motif-dotnet/Motif.Glossary/blob/main/.github/workflows/suite.yml) into `.github/workflows/`.

To change the kit, edit this folder, then run `scripts/sync-suite.sh` in each tool and commit there.
