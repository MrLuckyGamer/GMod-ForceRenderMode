--[[
	Realm: 
	Server
	
	Purpose: 
	Fixes default map entity min/max fade distance (BaseFadeProp) in Garry's Mod, which caused from RENDERMODE_NORMAL not fading properly from a distance.
	This script will help prevent the 'poping out' effect from a distance which it will sets to RENDERMODE_TRANSALPHA on every map starts by default (Configurable via ConVar below)
	
	Triggers:
	InitPostEntity
	PostCleanupMap
	lua_run Map Entity. (Use: RENDER_DISABLE_FORCE_RENDERMODE)
	
	Related Garry's mod Issue:
	https://github.com/Facepunch/garrysmod-issues/issues/2926
]]--

-- ConVar
if !ConVarExists("render_force_map_rendermode") then
	CreateConVar("render_force_map_rendermode", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}, "Toggle default BaseFadeProp behaviour to force set the Entity\'s RENDERMODE from RENDERMODE_NORMAL to RENDERMODE_TRANSALPHA Rendering mode.")
	CreateConVar("render_force_mode_type", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}, "Set Default RenderMode type. (default is 4 = RENDERMODE_TRANSALPHA)\n\n!! Using improper render mode may cause improper rendering!\nSee: http://wiki.garrysmod.com/page/Enums/RENDERMODE")
	CreateConVar("render_force_verbosemsg", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}, "Toggle verbose message when applying the Forced Entity's RenderMode?")
end

-- Applies to entity verbosely
local function pVerbose(msg)
	if GetConVar("render_force_verbosemsg"):GetBool() then
		print(msg)
	end
end

-- Entities, What entities should have to change. (this is default entity that affects to.)
local Ents = {
	-- props
	["prop_physics"] 				= true,
	["prop_physics_multiplayer"]	= true,
	["prop_physics_override"] 		= true,
	["prop_dynamic"] 			= true,
	["prop_dynamic_override"]	= true,
	["prop_ragdoll"] 			= true,
	-- map specific entity
	["func_lod"] 		= true,
	["info_overlay"] 	= true,	-- I don't think info_overlay can be set here...
	-- npc
	["npc_barnacle"] 	= true,
	["npc_antliongrub"] = true,
	-- Crates/Supply Crate Cache
	["item_item_crate"] = true,
	["item_ammo_crate"] = true
}

-- Custom Config. Called from lua_run map enttiy. Use logic_auto or logic_case with OnMapSpawn/OnSpawn output with delay 0.00 (Immediately).
RENDER_DISABLE_FORCE_RENDERMODE = false

local function UpdateRenderMode(bIsCleanUp)
	if GetConVar("render_force_map_rendermode"):GetBool() then
		
		local CUR_RENDERMODE = GetConVar("render_force_mode_type"):GetInt()
	
		if CUR_RENDERMODE < 0 or CUR_RENDERMODE > 10 then
			pVerbose("[ForceRenderMode] WARNING: Invalid RENDERMODE enum type set! ("..tostring(CUR_RENDERMODE)..") -- Reverting to RENDERMODE_TRANSALPHA(4) instead...")
			CUR_RENDERMODE = RENDERMODE_TRANSALPHA
		end
		
		local function ForceRenderMode()
			for _,ent in pairs(ents.GetAll()) do
				-- Get All Entities matches from table.
				if IsValid(ent) && (Ents[ent:GetClass()] && ent:GetRenderMode() == RENDERMODE_NORMAL) && ent:CreatedByMap() then
					pVerbose("[ForceRenderMode] Applying RENDERMODE("..CUR_RENDERMODE..") on entity: "..ent:GetClass().." [ID:"..ent:EntIndex().."/MAPID: "..ent:MapCreationID().."]")
					ent:SetRenderMode(CUR_RENDERMODE)
				end
				
				-- Get All entities if they are Weapons -- MAKE SURE THOSE ENTITY ARE CREATED FROM MAP!
				if IsValid(ent) && (ent:IsWeapon() && ent:CreatedByMap()) && ent:GetRenderMode() == RENDERMODE_NORMAL then
					pVerbose("[ForceRenderMode] Applying RENDERMODE("..CUR_RENDERMODE..") on weapon entity: "..ent:GetClass().." [ID:"..ent:EntIndex().."/MAPID: "..ent:MapCreationID().."]")
					ent:SetRenderMode(CUR_RENDERMODE)
				end
				
				-- Get All entities if they are item_* entities.
				if IsValid(ent) && string.find(ent:GetClass(),"item_") && (ent:CreatedByMap() && ent:GetRenderMode() == RENDERMODE_NORMAL) then
					pVerbose("[ForceRenderMode] Applying RENDERMODE("..CUR_RENDERMODE..") on item entity: "..ent:GetClass().." [ID:"..ent:EntIndex().."/MAPID: "..ent:MapCreationID().."]")
					ent:SetRenderMode(CUR_RENDERMODE)
				end
			end
		end
		
		if !bIsCleanUp then
			--safe timing call.
			timer.Simple(2.5, function()
				if RENDER_DISABLE_FORCE_RENDERMODE == true then return end
					
				print("[ForceRenderMode] Initializing entity Render Mode for better Min/Max Fade distance optimisation...")
				ForceRenderMode()
			end)
		else
			timer.Simple(1, function()
				if RENDER_DISABLE_FORCE_RENDERMODE == true then return end
					
				print("[ForceRenderMode] Initializing PostCleanup entity Render Mode for better Min/Max Fade distance optimisation...")
				ForceRenderMode()
			end)
		end
		
	end
end

hook.Add("InitPostEntity", "WOLVIN_INIT.ApplyRenderMode_Fix", function()
	UpdateRenderMode(false)
end)

hook.Add("PostCleanupMap", "WOLVIN_CLN.ApplyRenderMode_Fix", function()
	UpdateRenderMode(true)
end)
