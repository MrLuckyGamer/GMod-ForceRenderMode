# GMod-ForceRenderMode
A simple fix for Entity's Min/Max Distance (BaseFadeProp) from default (broken) Gmod's RENDERMODE_NORMAL mode.

## Purpose
Due from this: https://github.com/Facepunch/garrysmod-issues/issues/2926, Entities distance fading may no longer working with RenderMode sets to RENDERMODE_NORMAL by default.
This simple script will help prevent the 'poping out' effect and fixes problem to makes the props fades properly from the distance.

Currently this code will act as temporary fixes, if this issue has been solved from the Garry's Mod issue tracker, this code might be removed or will be left as a reference.

## Install
### Shipping to your Map Addon
Create a folder inside your map addon: `lua/autorun/server` Place "sv_force_rendermode.lua" within the `/server` directory.

### Server Side (Dedicated/Listen)
Place the script under your `garrysmod/lua/autorun/server`.

### (Optional) Disable Forcing Rendermode from your map
- Create 'lua_run' entity. 
- Set 'Code' keyvalue to `if RENDER_DISABLE_FORCE_RENDERMODE == nil then RENDER_DISABLE_FORCE_RENDERMODE = true end` (or simply) `RENDER_DISABLE_FORCE_RENDERMODE = true`
- Make sure that this lua_run must be executed on every map spawn, which can be triggered from logic_auto or logic_relay with OnMapSpawn/OnSpawn output.

## ConVars
`render_force_map_rendermode 1/0` 

Toggle force default Entity's RENDERMODE from RENDERMODE_NORMAL to RENDERMODE_TRANSALPHA Rendering mode.

`render_force_mode_type 4` 

Set Default RenderMode type. (default is 4 = RENDERMODE_TRANSALPHA)

Nore: **Using improper render mode may cause improper rendering!!** | See: http://wiki.garrysmod.com/page/Enums/RENDERMODE

`render_force_verbosemsg 1/0`

print Verbosely to console when applying the Render Modes.

## Issues
Having issues? Not working? or conflicted with your addon? Post a specific problem on "Issue tracker" above.

Be sure the code **MUST** be installed under /lua/autorun/server directory!
