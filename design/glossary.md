# Motif Glossary: design note

**Status:** format on trial since 2026-11-08. A viewer app, [Motif.Glossary](https://github.com/motif-dotnet/Motif.Glossary), is being built.

## The idea

A Motif app's repo carries a **glossary**: the words the team and its coding agent use for the things in the system, each with an agreed meaning. It starts when the app is first sketched and is kept up to date for the app's whole life.

Motif Sketch fixes the *shape* of a solution: the plan tells the agent which projects, ports and adapters to build. The glossary fixes the *names*. Agents are consistent within a session but drift across sessions: one day it's `Project`, the next `Workspace`, then `Document`. A glossary the agent reads at the start of every session stops that drift, and it gives people and agents the same words for design discussions.

This is the idea of a "ubiquitous language" from domain-driven design, kept plain: a file of agreed terms, not a methodology.

## Decisions so far

1. **The file is the product.** The glossary is a Markdown file in the app's repo, edited and reviewed in pull requests like any other text. It doesn't live inside a tool.
2. **A viewer first.** The glossary is a file format plus conventions, edited by hand. The first app, [Motif Glossary](https://github.com/motif-dotnet/Motif.Glossary), only reads it: it shows a whole glossary grouped by kind, so it's easy to review ([#10](https://github.com/motif-dotnet/.github/issues/10)). An editor may follow, if editing the file by hand gets tedious, and it would read and write the same file.
3. **Motif.Sketch is the first test run.** Its repo gets the first glossary, kept up by hand while we learn what the format needs.
4. **Name:** *Motif Glossary* (`Motif.Glossary`). "Language" is ambiguous in .NET (C#, a DSL, localisation).

## The file

`motif/glossary.md`, in the repo's Motif folder (see [Repo layout](#repo-layout)). `motif/README.md` tells agents to read it first, use its terms and avoid the words it lists under **Avoid**.

One `##` heading per term, in alphabetical order. Under it, a one- or two-sentence definition, then a short list of fields. Every field except the definition is optional.

```markdown
## Port

A named boundary of the system that adapters plug into. A port is on the
driving side (things that use the system) or the driven side (things the
system uses).

- **Kind:** domain concept
- **Avoid:** interface (that's how a port appears in code, not what it is)
- **Status:** agreed

## Snapshot link

A link that carries a whole project inside its URL, so it can be shared
without saving a file. Opens in Viewer mode.

- **Kind:** domain concept
- **Avoid:** share link, permalink
- **Status:** proposed
```

| Field | Meaning |
|---|---|
| **Kind** | Where the term sits. One of seven: *system*, *actor*, *external system*, *storage*, *port* and *adapter* come from the sketch; *domain concept* covers everything else the app is about. A term that is both an element and the port that reaches it (Clipboard) has two kinds, never more. |
| **Avoid** | Synonyms not to use. This is the opinionated part, and the part that stops drift. |
| **In code** | The name in code, when it differs from the term, such as a type name. |
| **Status** | *proposed* or *agreed*. An agent can propose terms; people agree them. A term without a status counts as agreed. |
| **Sketch** | The id of the Motif Sketch element or port this term came from, so a rename in Sketch can be carried across. |
| **See also** | Related terms, linked by heading. |

Markdown, not JSON, because people read and review it far more often than tools parse it. The fixed shape (one heading per term, a bold-labelled field list) keeps it parseable for a later tool.

### Terms in prose

- **Names take Title Case.** The names of specific things (systems, actors, external systems, storage, ports, adapters, and roles where an app has them) are proper nouns: the Developer, the Memory Files port.
- **Other terms stay lower case**, even though they're deliberate: snapshot link, temporary doc.
- **Italics only when writing about the word itself**, as when contrasting *Project* with *planned project*. There are no other markers in running text. What makes a term deliberate is using it consistently and avoiding its **Avoid** words, which a check can flag. How it looks doesn't.
- **A doc for people may link a term to its entry the first time it appears**, where a reader might not know it.

## Where terms come from

1. **From the sketch.** A `.motifsketch.json` already names the system's actors, external systems, storage and ports, mostly with one-line descriptions. Each one is a starting entry. In Motif Sketch's own design these are *Architect*, *Projects*, *Autosave*, *Diagram Exports*, *Solution Stubs* and *Clipboard*.
2. **From inside the ports.** The domain nouns the ports deal in come next: *Projects* brings in *Project*, *Context diagram*, *Snapshot link*. An agent can propose these from the solution plan and the code, and people agree them.
3. **From the work.** Any time a new word turns up in a discussion, an issue or a review, it gets an entry, or an existing entry gets another **Avoid**.

## Keeping it current

- **Renames.** When something is renamed in the sketch, the entry with that **Sketch** id is renamed too, and the old name moves to **Avoid**.
- **The agent maintains it.** When the agent introduces a new concept, it adds a *proposed* entry in the same change. A reviewer agrees it or renames it.
- **Later, checking.** A check could flag **Avoid** words in code, comments and docs. That would make the glossary a working part of the lifecycle, not just a document.

## How Motif Sketch helps

- **Export glossary** (built, [Motif.Sketch#5](https://github.com/motif-dotnet/Motif.Sketch/issues/5)): writes starting entries from the sketch's actors, external systems, storage and ports, or merges new ones into an existing `motif/glossary.md` by **Sketch** id (or name) without touching anything people wrote. New entries are *proposed*. Renames aren't carried across yet.
- **Later:** the solution plan could link to the glossary, so the agent reads both before stubbing.

## Repo layout

Motif tools work together through **files in the app's repo**, not by calling each other. They all live in one folder, `motif/`:

```
AGENTS.md                      one line: "This repo uses Motif.NET. Read motif/README.md first."
motif/
  README.md                    what's here, the reading order, and the rules for agents
  glossary.md                  the project's terms (people and agents edit it)
  sketch.motifsketch.json      the design (Motif Sketch, or agents when asked)
  plan.md                      the solution plan exported from the sketch (Motif Sketch only)
  diagrams/
    context-diagram.svg        exported from the sketch (Motif Sketch only)
    ports-and-adapters.svg
```

- **A plain folder, not `.motif/`.** A dot-folder says "tool machinery, don't touch", but people read and edit what's in here. Lowercase sets it apart from the capitalised .NET project folders.
- **Fixed file names**, so the rules can name them and every Motif repo looks the same.
- **Motif owns `motif/README.md`; the repo owns `AGENTS.md`.** The repo's agent file needs only one line pointing at the folder, so Motif's rules can change without touching it. `AGENTS.md` is read by most coding agents; Claude Code's `CLAUDE.md` can include it with `@AGENTS.md`.
- **The plan is committed and re-exported** whenever the sketch changes. The diff of `plan.md` then tells the agent what to add, rename or remove, so the sketch stays useful after the first stubbing.
- **Agents may change the sketch when asked.** It's plain JSON, so an agent can make a change a person asks for, keeping it a file Motif Sketch can open. The plan and the diagrams are still only exported, never edited by hand, so they're re-exported afterwards.
- **Not yet:** a manifest (`motif/motif.json`) with suite and format versions. It's added when a second tool needs it.
- **Later:** a `dotnet motif` CLI could `init` the folder and pointer, and `check` for **Avoid** words and a plan that's out of date with the sketch.

## Test run on Motif.Sketch

Done on 2026-11-08: Motif.Sketch's repo has the layout above, with 36 glossary terms taken from its sketch, SPEC.md and code. There, the sketch is also the app's bundled example, and the specs fail if `plan.md` or the diagrams don't match what the sketch exports.

What it showed so far:

- **The glossary settles real ambiguities.** *Project* (a Motif Sketch file) and *planned project* (a .NET project in the plan) share a word. *Stub* collides with *Solution Stubs*. *Primary/secondary* are actor types, so they can't also name the port sides. *Link* means a snapshot link, so relationships aren't links.
- **It caught drift in its own sketch on day one:** two relationship labels say "share links", a word the glossary avoids.
- **One term can have two sketch ids.** Clipboard and Diagram Exports are each an element and a port with the same name, so **Sketch** and **Kind** can hold two values.
- **Near-synonyms between storage and ports** (Project Files and Projects, Solution Plans and Solution Stubs) are worth noticing in the sketch itself.
- **Most adapters aren't glossary terms.** Adapter names are usually technology names (IndexedDB, SVG Files). An adapter gets an entry only if people talk about it, as with Web App and Specs.
- **Kind was too loose.** The test run used ten kinds. Most of the extras (sketch concept, element type, adapter kind) were Motif Sketch's own domain, since it is a tool about sketches. Settled as a fixed list of seven ([#1](https://github.com/motif-dotnet/.github/issues/1)): the six kinds of thing in a sketch, plus *domain concept*.

Next: use it in normal work for a while, and keep noting where the format chafes.

## Open questions

- Is a flat list enough, or do bigger systems need sections, such as one per bounded context?
