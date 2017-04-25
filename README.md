# GMod-ForceRenderMode
A simple fix for Entity's Min/Max Distance from default (broken) Gmod's RENDERMODE_NORMAL mode.

# Purpose
Due from this: https://github.com/Facepunch/garrysmod-issues/issues/2926
Entities may no longer fades properly if entity's Rendermode is set to RENDERMODE_NORMAL.
This simple script will help fix this problem and makes the prop fades properly.

Currently this code will act as temporary fix, if this issue has been solved from the Garry's Mod issue tracker, this code might be removed or left as reference only.

# Install
## Shipping from Map Addon
Create a folder inside your map addon: `lua/autorun/server` Place "sv_force_rendermode.lua" within the `/server` directory.

## Server Side (Dedicated/Listen)
Place the script under your `garrysmod/lua/autorun/server`.

# ConVars
`render_force_map_rendermode 1/0` 

Toggle force default Entity's RENDERMODE from RENDERMODE_NORMAL to RENDERMODE_TRANSALPHA Rendering mode.

`render_force_mode_type 4` 

Set Default RenderMode type. (default is 4 = RENDERMODE_TRANSALPHA)

Nore: **!! Using improper render mode may cause improper rendering!**

See: http://wiki.garrysmod.com/page/Enums/RENDERMODE

# Issues
Having issues? Not working? or conflicted with your addon? Post a specific problem on "Issue tracker" above.

Be sure the code **MUST** be installed under /lua/autorun/server directory!
