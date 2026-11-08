# Motif Glossary: design note

**Status:** idea, written up 2026-11-08. Nothing built yet.

## The idea

A Motif app's repo carries a **glossary**: the words the team and its coding agent use for the things in the system, each with an agreed meaning. It starts when the app is first sketched and is kept up to date for the app's whole life.

Motif Sketch fixes the *shape* of a solution: the plan tells the agent which projects, ports and adapters to build. The glossary fixes the *names*. Agents are consistent within a session but drift across sessions: one day it's `Project`, the next `Workspace`, then `Document`. A glossary the agent reads at the start of every session stops that drift, and it gives people and agents the same words for design discussions.

This is the idea of a "ubiquitous language" from domain-driven design, kept plain: a file of agreed terms, not a methodology.

## Decisions so far

1. **The file is the product.** The glossary is a Markdown file in the app's repo, edited and reviewed in pull requests like any other text. It doesn't live inside a tool.
2. **No app yet.** For now the glossary is a file format plus conventions. A Motif Glossary app comes later, if editing the file by hand gets tedious, and it would read and write the same file.
3. **Motif.Sketch is the first test run.** Its repo gets the first glossary, kept up by hand while we learn what the format needs.
4. **Name:** *Motif Glossary* (`Motif.Glossary`) if it becomes a tool. "Language" is ambiguous in .NET (C#, a DSL, localisation).

## The file

`GLOSSARY.md` at the repo root, next to `README.md`, so people and agents find it without being told. The repo's `CLAUDE.md` or `AGENTS.md` points to it, with an instruction to use its terms and avoid the words it lists under **Avoid**.

One `##` heading per term, in alphabetical order. Under it, a one- or two-sentence definition, then a short list of fields. Every field except the definition is optional.

```markdown
## Port

A named boundary of the system that adapters plug into. A port is on the
driving side (things that use the system) or the driven side (things the
system uses).

- **Kind:** sketch concept
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
| **Kind** | What sort of term it is. The first kinds come from Motif Sketch: actor, external system, storage, port. Others: domain concept, process, rule. The list stays open while we learn. |
| **Avoid** | Synonyms not to use. This is the opinionated part, and the part that stops drift. |
| **In code** | The name in code, when it differs from the term, such as a type name. |
| **Status** | *proposed* or *agreed*. An agent can propose terms; people agree them. A term without a status counts as agreed. |
| **Sketch** | The id of the Motif Sketch element or port this term came from, so a rename in Sketch can be carried across. |
| **See also** | Related terms, linked by heading. |

Markdown, not JSON, because people read and review it far more often than tools parse it. The fixed shape (one heading per term, a bold-labelled field list) keeps it parseable for a later tool.

## Where terms come from

1. **From the sketch.** A `.motifsketch.json` already names the system's actors, external systems, storage and ports, mostly with one-line descriptions. Each one is a starting entry. In Motif Sketch's own design these are *Architect*, *Projects*, *Autosave*, *Diagram Exports*, *Solution Stubs* and *Clipboard*.
2. **From inside the ports.** The domain nouns the ports deal in come next: *Projects* brings in *Project*, *Context diagram*, *Snapshot link*. An agent can propose these from the solution plan and the code, and people agree them.
3. **From the work.** Any time a new word turns up in a discussion, an issue or a review, it gets an entry, or an existing entry gets another **Avoid**.

## Keeping it current

- **Renames.** When something is renamed in the sketch, the entry with that **Sketch** id is renamed too, and the old name moves to **Avoid**.
- **The agent maintains it.** When the agent introduces a new concept, it adds a *proposed* entry in the same change. A reviewer agrees it or renames it.
- **Later, checking.** A check could flag **Avoid** words in code, comments and docs. That would make the glossary a working part of the lifecycle, not just a document.

## How Motif Sketch could help, later

- **Export glossary:** writes starting entries from the sketch, or merges new ones into an existing `GLOSSARY.md` by **Sketch** id without touching anything people wrote.
- The solution plan could link to the glossary, so the agent reads both before stubbing.

Neither is needed for the test run.

## Test run on Motif.Sketch

1. Write `GLOSSARY.md` for Motif.Sketch by hand, starting from its sketch and SPEC.md.
2. Point its `CLAUDE.md` at it.
3. Use it in normal work for a while, and note where the format chafes: missing fields, fields nobody fills in, terms that don't fit a kind.
4. Revise this note with what we learn.

## Suite convention this suggests

Motif tools work together through **files in the app's repo**, not by calling each other. Each tool owns its files, and the formats are documented (and perhaps shared through a small `Motif.Core` library). So Motif Sketch writes the sketch and the plan, the glossary sits beside them, and a later tool reads whichever it needs.

## Open questions

- Root `GLOSSARY.md`, or a `/motif/` folder holding all the Motif files (sketch, plan, glossary)? Root for now.
- Is a flat list enough, or do bigger systems need sections, such as one per bounded context?
- Should **Kind** be a fixed list once we've seen what's actually used?
