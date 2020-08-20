
require("common.log")
module("DickKillSecure", package.seeall, log.setup)


-- REQUIEREMENTS

local Orb = require("lol/Modules/Common/OGOrbWalker")
local ts = require("lol/Modules/Common/OGsimpleTS")


-- API
local _Core = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game, Renderer, Vector  = _Core.ObjectManager, _Core.EventManager, _Core.Input, _Core.Enums, _Core.Game, _Core.Renderer, _Core.Geometry.Vector
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player



-- CALCULATION
local function getHextechdmg(target)
	local Hextechdmg = {175, 179.59, 184.18, 188.76, 193.35, 197.94, 202.53, 207.12, 211.71, 216.29, 220.88, 225.47, 230.06, 234.65, 239.24, 243.82, 248.41, 253}
	local Hextechdmglvl = Hextechdmg[Player.Level]
	local Hextechdmgtotal = Hextechdmglvl + (0.3 * Player.TotalAP)
	return Hextechdmgtotal * (100.0 / (100 + target.FlatMagicReduction) )
end




-- FUNCION

local function UseItemsCombo2(target)	
	for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
			-- BOTRK + HEXTECH GUNBLADE + RANDUIN
			if _item.Name == "HextechGunblade" then
				if Player:GetSpellState(i) == SpellStates.Ready then
					if Player.Position:Distance(target.Position) <= _item.DisplayRange then
						Input.Cast(i, target)
					end
					break
				end
			end
		end
	end
end


local function OnTick()
	local target = ts:GetTarget(1200, ts.Priority.LowestHealth)
	local isMelee = false
	if target and getHextechdmg(target) > (target.Health) then
		UseItemsCombo2(target)
	end
end


-- OnLoad
function OnLoad()

	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	Game.PrintChat("DickKillSecure Loaded !")
	return true
end
