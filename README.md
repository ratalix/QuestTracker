# QuestTracker — addon for Ephinea PSO (Blue Burst)

Quest run tracker for the Ephinea client (psobbaddonplugin, Lua / imgui). Version 1.0.

## Features / Fonctions
- Run counter, live timer, personal best (PB), average and history per quest, difficulty and episode
- Automatic detection of quest start and completion (no manual input needed): quest end registers when known, game messages otherwise
- Time Attack tab: PB / average table per quest, "Quest farm reset" mode (PB and average even for runs you don't finish)
- Per-quest monster window, Anguish 1/2/3 detection, Simulator 2.0 timing (starts at "Stage 1", stops when Dal Ral Lie dies)
- Quest list with search, history with invalid-run cleanup, double-confirmation quest reset
- Languages: Français / English / 日本語 (the Japanese text needs a font that has Japanese glyphs)

## Requirements
- Ephinea PSO Blue Burst client with the addon plugin (psobbaddonplugin) enabled
- The default `core_mainmenu` addon (included with the plugin)
- No other addon or library needed

## Installation
1. Copy the whole `QuestTracker` folder into `<PSO folder>/addons/`
   so you get `addons/QuestTracker/init.lua`, `quest_monsters.lua` and `quest_abbr.lua`.
2. Make sure the addon plugin is enabled, then in game open the addon menu and press **Reload**.
3. A **Quest Tracker** button appears in the main addon menu.

Your data (`data.lua`, `history.lua`, `settings.lua`) is created automatically next to `init.lua`.
To update: replace `init.lua` (and the other files if they changed) — your data is kept.

## Notes
- Diagnostic files (`ang_scan.txt`, `ang_status.txt`) may be created while playing; they can be deleted.
- Optional: `fin_quete.txt` — extra end-of-quest phrases, one per line (lines starting with `#` are comments).
- Memory addresses are taken from the Kill Counter addon that ships with Ephinea.

## Credits
- Made by Ratalix.
- Memory addresses come from Ephinea's Kill Counter addon; the addon relies on the Ephinea addon plugin API.
- Not affiliated with Ephinea or SEGA.

## License
MIT — see `LICENSE`.

Quest end registers (`quest_registers.lua`) come from [psostats-client](https://github.com/phelix-/psostats-client) (MIT, phelix-).
