
require("common.log")
module("DickHelp", package.seeall, log.setup)


-- REQUIEREMENTS

local Orbwalker = require("lol/Modules/Common/OGOrbWalker")
local ts = require("lol/Modules/Common/OGsimpleTS")


-- API
local _Core = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game, Renderer, Vector  = _Core.ObjectManager, _Core.EventManager, _Core.Input, _Core.Enums, _Core.Game, _Core.Renderer, _Core.Geometry.Vector
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player

local AsAi = GameObject

local _Q = SpellSlots.Q
local _W = SpellSlots.W
local _E = SpellSlots.E
local _R = SpellSlots.R



-- CALCULATION
--- HextechGunblade
local function getHextechdmg(target)
	local Hextechdmg = {175, 179.59, 184.18, 188.76, 193.35, 197.94, 202.53, 207.12, 211.71, 216.29, 220.88, 225.47, 230.06, 234.65, 239.24, 243.82, 248.41, 253}
	local Hextechdmglvl = Hextechdmg[Player.Level]
	local Hextechdmgtotal = Hextechdmglvl + (0.3 * Player.TotalAP)
	return Hextechdmgtotal * (100.0 / (100 + target.FlatMagicReduction) )
end




-- FUNCION
--- HextechGunblade
local function useHextech(target)	
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
--- SwordOfFeastAndFamine  BilgewaterCutlass  RanduinsOmen
local function UseItemsCombo(target)	
	for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
			-- BOTRK + HEXTECH GUNBLADE + RANDUIN
			if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" or _item.Name == "RanduinsOmen" then
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




--- OnTick events
--- HextechGunblade
local function OnTick()
	local target = ts:GetTarget(1200, ts.Priority.LowestHealth)
	local isMelee = false
	if target and getHextechdmg(target) > (target.Health) then
		useHextech(target)
	end
end

--------------- HUtils
function OnTeleport(hero, name, idk, duration, status)
	Game.PrintChat(hero.CharName.." "..name.." "..status)
end
--- RegenerationPotion  ItemCrystalFlask  ItemDarkCrystalFlask
local function UseItemsAuto()
for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
			-- Auto Potion
			if _item.Name == "RegenerationPotion" or _item.Name == "ItemCrystalFlask" or _item.Name == "ItemDarkCrystalFlask" then
				if Player:GetSpellState(i) == SpellStates.Ready then
					if Player.Health <= (Player.MaxHealth*0.2) then
						Input.Cast(i)
					end
					break
				end
			end
		end
	end
end

--- SwordOfFeastAndFamine  BilgewaterCutlass  RanduinsOmen
local function OnTick2()
	UseItemsAuto()
	local target = Orbwalker.Mode == 1 and Orbwalker.CurrentTarget
	if target and (target.Health) <= ((target.MaxHealth*0.6)) then
		UseItemsCombo(target)
	end
end

local function OnDraw()
	for s=_Q,_R do
		if Player:GetSpellState(s) == SpellStates.Ready then
			local srange = Player:GetSpell(s).DisplayRange
			local draw_S = Renderer.DrawCircle3D(Player.Position, srange, 30, 1, 0xFF0000FF)
		end
	end	
end
-- Auto QSS
local function OnBuffGain(Player, buffInst)
	for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
		
			if _item.Name == "QuicksilverSash" or _item.Name == "ItemMercurial" then
				if Player:GetSpellState(i) ~= SpellStates.Ready then return end

					if Player.IsTaunted or Player.IsCharmed or Player.IsAsleep or buffInst.IsDisarm or Player.IsImmovable then
						Input.Cast(i)
	
					end
				end
				break
			end
		end
	end


-- OnLoad
function OnLoad()
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick2)
	EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
	EventManager.RegisterCallback(Enums.Events.OnBuffGain, OnBuffGain)
	EventManager.RegisterCallback(Enums.Events.OnTeleport, OnTeleport)
	Game.PrintChat("DickHelp Loaded !")
	return true
end
