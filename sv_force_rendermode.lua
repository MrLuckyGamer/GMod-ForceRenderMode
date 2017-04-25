--[[
	Realm: 
	Server
	
	Purpose: 
	Fixes default map entity min/max fade distance which caused from RENDERMODE_NORMAL not being fade properly and changed to RENDERMODE_TRANSALPHA by default.
	This should be applied whenever map has been loaded, and after game.CleanUpMap() being called.
	
	This purpose is used for optimisation which prevent some unwanted 'pop' effect for entity fading from a distance.
	
	Issue can be tracked here:
	https://github.com/Facepunch/garrysmod-issues/issues/2926
]]--

if !ConVarExists("render_force_map_rendermode") then
	CreateConVar("render_force_map_rendermode", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}, "Toggle force default Entity's RENDERMODE from RENDERMODE_NORMAL to RENDERMODE_TRANSALPHA Rendering mode.")
	CreateConVar("render_force_mode_type", "4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}, "Set Default RenderMode type. (default is 4 = RENDERMODE_TRANSALPHA)\n\n!! Using improper render mode may cause improper rendering!\nSee: http://wiki.garrysmod.com/page/Enums/RENDERMODE")
end

local Ents = {
	-- props
	["prop_physics"] = true,
	["prop_dynamic"] = true,
	["prop_ragdoll"] = true,
	-- map specific entity
	["func_lod"] = true,
	["info_overlay"] = true,	-- I don't think info_overlay can be set here...
	-- npc
	["npc_barnacle"] = true,
	["npc_antliongrub"] = true
}

-- Called from lua_run map enttiy. Use logic_auto or logic_case with OnMapSpawn/OnSpawn output with delay 0.00 (Immediately).
RENDER_DISABLE_FORCE_RENDERMODE = false

local function UpdateRenderMode(bIsCleanUp)
	if (GetConVar("render_force_map_rendermode"):GetBool() or RENDER_DISABLE_FORCE_RENDERMODE) then
	
	local CUR_RENDERMODE = GetConVar("render_force_mode_type"):GetInt()
	
		if CUR_RENDERMODE < 0 or CUR_RENDERMODE > 10 then
			print("WARNING: Invalid RENDERMODE enum type set! ("..tostring(CUR_RENDERMODE)..") -- Reverting to RENDERMODE_TRANSALPHA(4) instead...")
			CUR_RENDERMODE = RENDERMODE_TRANSALPHA
		end
		
		local function ForceRenderMode()
			print("Initializing entity Render Mode for better Min/Max Fade distance optimisation...")
			for _,ent in pairs(ents.GetAll()) do
				-- Get All Entities matches from table.
				if IsValid(ent) && (Ents[ent:GetClass()] && ent:GetRenderMode() == RENDERMODE_NORMAL) then
					ent:SetRenderMode(CUR_RENDERMODE)
				end
				
				-- Get All entities if they are Weapons -- MAKE SURE THEY ARE FROM MAP CREATED ENTITY!
				if IsValid(ent) && (ent:IsWeapon() && ent:CreatedByMap()) && ent:GetRenderMode() == RENDERMODE_NORMAL then
					ent:SetRenderMode(CUR_RENDERMODE)
				end
				
				-- Get All entities if they are item_ entties.
				if IsValid(ent) && string.find(ent:GetClass(),"item_") && (ent:CreatedByMap() && ent:GetRenderMode() == RENDERMODE_NORMAL) then
					ent:SetRenderMode(CUR_RENDERMODE)
				end
			end
		end
		
		if !bIsCleanUp then
			--safe timing call.
			timer.Simple(2.5, function()
				ForceRenderMode()
			end)
		else
			timer.Simple(1, function()
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