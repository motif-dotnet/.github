# Deep adapters: design note

**Status:** Motif's rule since 2026-11-21, after a trial on Motif.Memory's Memory Files adapter. The rollout to Motif's own apps is under way (see [Rollout](#rollout)). Rules marked *for now* may be revisited.

## The idea

Make adapters deep modules, in John Ousterhout's sense: a small port with real work behind it. Only a thin, injected part that touches the outside world, the **Fitting**, gets faked. So the adapter's own logic runs in every spec, and adapter specs of their own are needed only by exception. The same idea reaches the driving side: specs drive the User port, and whatever a second UI would have to write again goes behind it.

**Why.** In Motif.Memory, the Memory Files adapter's rules ("empty means nothing but `.git`", "it may have filled since it was picked", "each folder is written to once", the error wording) lived in untested JavaScript, and `FakeMemoryFiles` re-implemented them by hand. A port fake drifts from the adapter it stands in for, and no spec notices.

**What the trial showed.** Before, no spec ran the folder adapter. After, specs reached every line and branch behind the port, and Stryker killed 93% of the folder adapter's mutants, with nothing faked but the Fittings. The cost was about 40% more code behind the port, partly from wording moving in from the view.

## Driven adapters

1. **Policy goes in the domain, unless enforcing it needs the outside world.** Then the port promises it in the app's terms, and the adapter keeps the promise. In Memory Files, "write into the folder picked, if it's still empty" is one call on the port, not "list the folder" for a use case to combine. Depth belongs to the adapter, the module; the port is its interface, and should be small. Don't call a port "deep".
2. **The Fitting is only the operations this adapter needs, each one call to the outside world, with no branches worth testing.** Anything with an `if` in it moves into the adapter. The fake Fitting stays trivial, and the logic is where specs reach it. *Turned down:* mirroring the outside API (the fake would have to be a small file system); protected virtual methods overridden in specs (the fake is a subclass of the real adapter, and it's easy to override too much).
3. **The interface between an adapter and its Fitting is a Seam.** A Seam isn't a kind of port. A port is a boundary of meaning: the app owns it, and it's named for a purpose. A Seam is a boundary for testing: the adapter owns it, and it lives in the adapter's project. Cockburn's ports were already test seams, with the fake as an adapter at the port; deep adapters move the fake one level down, so the port keeps only the meaning.
4. **Only Fittings are faked.** Every spec, from use-case specs to whole-system specs, runs the real adapters over fake Fittings, and port fakes go away. Spec setup gets more realistic and a little longer ("folder not empty" means putting a file in the fake folder), and the specs project references every adapter project, which Motif.NET's architecture checks must allow. *Turned down:* port fakes and fake Fittings both (two fakes to keep in step); port fakes as recorded exceptions (reopen it if one ever earns its place).
5. **An adapter with no rules of its own is its own Fitting.** Its port serves as its Seam, and its fake is a fake Fitting, so rule 4 holds everywhere. Motif.Sketch's Clipboard (a 3-line `clipboard.js` behind a 17-line adapter) is one. Whether an adapter has rules worth testing is a judgement call; once it gains one, it gets a Seam.
6. **Reuse a Seam the platform provides when it's small and stable,** such as `HttpMessageHandler`: a few members whose behaviour is a public standard. This is a named exception to rule 2. For an HTTP adapter it means building URLs, checking status codes, paging and parsing JSON all run in every spec; a Seam of our own would leave the parsing in the real Fitting, which no spec runs. Write your own Seam when the platform's API is big or awkward, as the File System Access API is.
7. **The Fitting asks where.** A port that needs a location takes none (`ChooseWhere()`). The Seam's `Choose()` is a picker in the browser, or in a CLI the path its Fitting was built with. A Seam's failures are its own kinds (declined, refused), not the platform's error names, which the real Fitting maps. Passing a location through the port instead would carry a browser's folder handle through the User port.
8. **Fake Fittings follow a contract written on the Seam,** in its doc comments: for a folder, that the listing includes `.git`, that writing `a/b.md` creates `a`, and that the user declining fails differently from access being refused. Each real Fitting has a few manual checks in the app's manual-checks doc, run before a release when it has changed. Playwright is added only if a regression gets through, as in Motif.Sketch's decision 45. Since every spec runs over fake Fittings, a fake that drifts makes every spec wrong, and it's caught only by hand: tighten the contract when that bites.
9. **Adapter specs only by exception:** for adapter behaviour the app's behaviour specs can't reach, or can reach only awkwardly, such as a zip's exact format (UTF-8 with no byte order mark). They live in the app's specs project, in a folder per adapter (`Checks/Motif.Memory.Specs/Adapters/ZipDownload/`), and move to a project of their own only for an adapter shared between apps.
10. **Fake Fittings live in the app's Fakes project,** as fakes did before. Production code holds no test code, so the Seam must be public. *Turned down:* fakes built into the real Fitting, as James Shore's nullables are.
11. **An adapter has one constructor, which takes its Seam,** and the composition root registers the real Fitting: `AddSingleton<Folder, JsInteropFolder>()`. One construction path, shared by specs and the app. *For now.*

## Names

12. **Ports are named for what the app uses them for, starting "For…",** as Cockburn names them: `ForSavingTheMemory`. A purpose name says what may plug in, without a technology in it.
13. **Adapters are named `<Port>Via<Way>`:** `ForSavingTheMemoryViaFolder`, `ForSavingTheMemoryViaZipDownload`, and for a port with one adapter, `ForCopyingViaBrowserClipboard`. A port's adapters sort together, and the name reads as English. Names fall into two families at a glance: "For…" is a port or an adapter; anything else is a Seam or a Fitting. Motif's guideline to name an implementation for what makes it different, difference first (`SystemClock`), has this exception: for adapters, the difference comes after `Via`. *Turned down:* technology first (`ZipDownloadForSavingTheMemory`; doesn't sort or read as well); short adapter names (`ZipDownload`; clashes with Seams); an underscore (`ForSavingTheMemory_ZipDownload`; against CA1707, and in Motif underscores mean spec names).
14. **Seams are named for what they reach, in the app's terms; the technology goes only in the real Fitting's name:** the Seam `Folder`, the real Fitting `JsInteropFolder` (a CLI's would be `FileSystemFolder`), the fake `FakeFolder`. No `I` prefix. The term goes in the Seam's doc comment ("The Folder Seam: …"), since `Folder` reads like a domain noun. A Seam named for its technology (`BrowserFolder`) would make a second UI copy the adapter that sits over it.

## Several adapters at one port

15. **Each way of doing something is its own adapter at the port:** for Motif.Memory, the folder and the zip at `ForSavingTheMemory`, maybe GitHub later. Each gives its name, whether it's available here, choosing where, and doing it. The use case offers the user the ones available. A browser with no folder picker loses the folder because that adapter isn't available, not through an `if` in the UI. *Turned down:* a port per way (nothing can be swapped); one adapter covering both (its members still name the folder and the zip).
16. **Each adapter is registered as the port, and offered in the order registered.** The composition root (`Program.cs`) says the order, with a comment, and the first available is the default. *Turned down:* a composite adapter that picks (the user must choose, so the list leaks out anyway); a second port listing the ways (a port with no outside world behind it).
17. **The order spec checks the order the use case is given,** through the Fixture, which builds the adapters in the same order as `Program.cs`. `Program.cs`'s own order is a manual check. Swapping its lines passes every spec. *For now:* a shared registration method would let a spec see it, but the specs project would reference the WebAssembly app, and `Program.cs` would no longer show the order.

## Driving adapters

18. **Specs drive the use cases through the User port, not the UI,** as Cockburn's test harness does, so the approach fits every app type (web, desktop, MAUI). Specs through a UI framework's in-memory host (bUnit, Avalonia headless) only by exception; otherwise the view gets manual checks, as Fittings do. On the driving side the User port does both jobs, the boundary of meaning and the place specs stand in for the UI, and the view plays the Fitting's part.
19. **The second-UI test: the meaning a UI in another technology would need goes behind the User port,** where specs reach it: a way's name, a short phrase for what it does ("Pick folder", "Write to “Notes”"), why it isn't ready, what's offered and enabled, and what to say when something finishes. Each view keeps its technology's own: layout, focus, gestures, menus, theme, toast mechanics, and widget form such as ellipses and icons. A view can't hold a label per way, since branching on the adapter would break rule 15's open list. A presentation model only for a screen whose display state gets complicated. *Turned down:* all user-facing text behind the port, fixed copy too (fills the port with text that isn't logic); only state-dependent text (each UI writes a way's fixed meaning again).
20. **Outcomes reach the User port as one typed value carrying its own wording,** never as parallel strings: a closed set of records where the kinds differ (`Chosen`, `Kept`, `Refused(Title, Problem)`). Finer kinds only when a UI needs them, such as a CLI's exit codes.

**Noticed, with a CLI as a second UI in mind:** the User port takes one choice at a time, while a CLI takes them all as flags. It can replay them as tasks, so nothing breaks, but it tests whether the choices should also exist as one value. A CLI is cheap to spec through itself, in process, with arguments, output and exit code, so rule 18's exception would usually apply. Fixed copy, such as section explanations, could double as `--help` text.

## In Motif.Sketch

21. **A Seam is a property of its adapter in the model, not an element of its own.** The plan export names it, and the stubs generate the Seam and a fake Fitting rather than a port fake. The sketch draws nothing for it yet. *For now:* the sketch's visuals are to be revisited ([ideas](ideas.md#the-list)).
22. **Apps keep ports from the start.** Starting with Seams and Fittings and no ports is an [idea](ideas.md#the-list), to try on the next new app.

## Terms

Entries in the glossary format, for each app's `motif/glossary.md` to take when it uses them.

```markdown
## Deep adapter

An adapter with real work behind a small port, whose own logic runs in every
spec because only its Fitting is faked.

- **Kind:** domain concept
- **Avoid:** deep port (depth belongs to the module, not its interface)
- **See also:** Fitting, Seam

## Fitting

The thin part of an adapter that touches the outside world. Each member is one
call to it, with no branches worth testing. There's a real Fitting and a fake
one, and specs fake the Fitting.

- **Kind:** domain concept
- **Avoid:** core (the domain), driver (the driving side), gateway, wrapper
- **See also:** Seam

## Seam

The interface between an adapter and its Fitting, owned by the adapter and
named for what it reaches (after Michael Feathers: a place where behaviour can
be swapped without editing the code around it). Not a kind of port.

- **Kind:** domain concept
- **Avoid:** inner port (it would be mistaken for a port in the sketch)
- **See also:** Fitting
```

"Fitting" carries on the plumbing and electrical metaphor of ports and adapters, and clashes with nothing in ports and adapters, .NET, Blazor or the browser. *Turned down:* wrapper (loose), humble object (a property rather than a role), touchpoint, shell, gateway, contact, edge, effects, binding.

## Rollout

Top down, in four layers:

1. **Write the rules down:** this note, then the agents' guidelines and roles: "fakes only for Fittings" in place of "fakes for the driven ones", rule 13's exception to the naming guideline, adapter specs by exception, and manual Fitting checks before a release.
2. **Retrofit Motif.Glossary** (2 ports, Files over JavaScript), and merge or drop the Motif.Memory trial (branch `deep-adapter-memory-files`), renamed to rules 12 to 14 and changed for rules 7, 19 and 20. Done before the tools, as a second data point, since generator changes cost most to undo.
3. **The tools:** Motif.Sketch's model (adapter kinds, fake naming, Seams per rule 21, several real adapters at a port in order), plan export and stubs (a Seam and a fake Fitting, not a port fake); Motif.Glossary's kinds, if Seam and Fitting need them. Then re-export Motif.Memory's plan.
4. **Retrofit Motif.Sketch** (7 ports, 6 over JavaScript; Autosave clearly deep, Clipboard and Repos their own Fittings). Ports without an obvious purpose phrase yet, such as `Projects`, are named then.

Motif.Is and Motif.Is.Core have no adapters.
