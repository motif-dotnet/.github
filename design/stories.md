# Motif Stories: design note

**Status:** an idea, from a grilling on 2026-11-21. Nothing is built. It's meant as a test of the whole Motif idea, so it starts once the [deep adapters](adapters.md) rollout is done, and perhaps more coding standards.

## The idea

A story-map tool that works as a front end over GitHub issues: a simpler take on the story-mapping tools that exist, with the map kept in GitHub itself.

A story map, after Jeff Patton, lays out what users do as a **backbone**: **activities** along the top, and the **steps** of each activity under them. The stories (here, issues) hang under the steps, and **release slices** cut across the whole map, so each slice is a thin, usable version of the product.

**Why it suits Motif.** A Motif app's steps are its User Tasks, and its first slice is a walking skeleton. Mapping a Motif app gives the User Tasks to build first, and the specs Motif wants (one per User Task, breadth first) follow the first slice. As an app, it brings Motif's first sign-in and its first app with GitHub behind a driven port, a good test for Seams and Fittings.

## Decisions so far

1. **The map lives in a GitHub Project, one project per map.** Issues are the stories. Single-select fields hold the Activity, Step and Release. The order within a cell comes from the project's own item order.
   - *Why:* it's how the Motif.NET board already runs, it spans repos, and the map stays readable in GitHub without the tool, as a table grouped by Activity and Step.
   - *Costs:* Projects is in GitHub's GraphQL API only. It keeps one item order for the whole project, so each cell's order is filtered from it, and rearranging in GitHub's own views changes the map's order too. GitHub has no fields that depend on each other, so a card can have a Step from a different Activity.
   - *Turned down:* sub-issues (activities and steps clutter the issue list as issues that never close, and milestones belong to one repo); labels and milestones (GitHub stores no order); a map file in the repo (every rearrangement is a commit, and the map is invisible in GitHub).
2. **A map covers any repos, with a default repo for each map,** where new stories go once there's editing. A Motif map could span Motif.Sketch, Motif.Glossary and `.github`, as the Motif.NET board does.
   - *Turned down:* one repo per map (rules out cross-repo maps); choosing a repo for every new story (slows down a mapping session).
3. **People bring their own GitHub token,** pasted into the app and kept in the browser. No server, so it's hosted on GitHub Pages like the other tools.
   - *Why:* Projects needs a sign-in even to read. GitHub's usual sign-in needs a server to keep a secret, and the device-code sign-in that `gh` uses is blocked when called from a browser page.
   - *Costs:* setting up a token is friction. A token in browser storage is only as safe as the page, so the app loads no scripts from elsewhere, and "forget when I close the tab" would help.
   - *For the Motif test:* the token is an outside thing in its own right, a Seam with a browser-storage Fitting, so its rules ("missing", "rejected", "lacks project access") run in the specs.
   - *Turned down:* a small sign-in service (a server to host and secure, and hosting is out of scope); a local `dotnet` tool that borrows `gh auth token` (has to be installed, and a map can't be shared as a link; it could come later with the `dotnet motif` CLI, [#4](https://github.com/motif-dotnet/.github/issues/4)).
4. **Read-only first,** a viewer, as Motif Glossary started. Editing cards, and later the backbone, come once the viewer and the spike have proved the queries and the token.
   - *Helps:* a read-only token is enough, which is easier to explain and safer to keep in a browser.
   - *Costs:* a viewer adds less over GitHub's own board view (Step in columns, Release in swimlanes) than an editor would; mainly the Activity row along the top.
   - *Turned down:* editing cards from the start; full editing, backbone included.
5. **The viewer opens a map from a project link and finds its fields by fixed names.**
   - **Opening a map:** a link naming the project, like Motif's repo links: `#project=owner/number`.
   - **The layout:** activities along the top, steps under them, and release slices as bands down the page.
   - **Cards:** title, open or closed, and repo, each linking to its issue on GitHub. Each slice shows how many of its cards are done.
   - **Fields:** the project must have single-select fields named Activity, Step and Release, so setting up a map is "make a project with these three fields".
   - **When something's missing, the viewer says so plainly** rather than showing an empty map, each case a typed outcome carrying its own wording ([adapters](adapters.md) rule 20). A project with no Activity, Step or Release field says which. Cards with no Step go in an **Unplaced** area, as in Motif Sketch's Unplaced list.
   - *Turned down:* choosing which fields play each part, saved in the link (long links, and choices before you see anything); the grid without release slices (slices are half of what a story map is for).
6. **It's a Motif tool,** in the suite with the web kit and the tool switcher. That a Motif app's steps are its User Tasks is a convention in the docs, with no feature for it in the first version.
   - *Later:* the tool switcher carries a repo link, but this tool opens a project, so a repo's `motif/` folder could record its map's project link.
   - *Turned down:* exporting steps as User Task names into `motif/` in the first version (needs a token that writes to repos, and it's a feature before anyone has used the map); a tool outside the suite (it's meant to test the whole Motif idea).
7. **Name:** *Motif Stories* (`Motif.Stories`), for now. One plain word, like Sketch, Glossary and Memory. It names the cards rather than the map, so the tagline and the glossary carry the "map" part.
   - *Turned down:* Motif Story Map (clear, but two words); Motif Map ("map" means object mapping in .NET, and brushes against "context map"); Motif Board (GitHub's Board view, and "the board" already means the Motif.NET project board; it also suggests a kanban); Backbone (obscure); Slices (says neither map nor stories); Journey (suggests user-journey diagrams); Plan and Tasks (already mean other things in Motif).

## Before building: a spike

An hour or two against a throwaway project, to prove what the design leans on:

- **What a token can reach.** Fine-grained tokens have historically reached projects owned by an organisation but not those owned by a personal account. Which kinds of token, with which permissions, can read a project's items and fields?
- **Keeping Activity and Step consistent,** given that GitHub has no dependent fields. Is one Step field with the Activity in each option's name tidier?
- **Changing a field's options.** The API is believed to replace the whole option list at once, which may lose the values already set on items. This matters only once there's editing.

## Open questions

- Draft items: Projects has cards that aren't issues yet. In a mapping session, new cards could be drafts by default, with "make it an issue", into the map's default repo, as a separate step. For when there's editing.
- Should the order of cards come from the project's single item order, or would that surprise people who rearrange the project in GitHub's own views?

## Terms

Entries in the glossary format, for the app's `motif/glossary.md` to take.

```markdown
## Story map

A map of what users do: activities along the top, the steps of each activity
under them, and stories under each step, cut across by release slices.

- **Kind:** domain concept
- **Avoid:** board (GitHub's view of a project), roadmap (a different thing)

## Release slice

A band across the story map holding the stories for one release, each slice a
thin, usable version of the product.

- **Kind:** domain concept
- **Avoid:** milestone (GitHub's per-repo grouping), sprint
```
