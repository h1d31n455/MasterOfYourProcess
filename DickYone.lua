require("common.log")
module("DickYone v0.1", package.seeall, log.setup)
--- api


local _SDK = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game = _SDK.ObjectManager, _SDK.EventManager, _SDK.Input, _SDK.Enums, _SDK.Game
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player
local Events = _SDK.Enums.Events
local BuffTypes = _SDK.Enums.BuffTypes
local Renderer = _G.CoreEx.Renderer
local Input = _G.CoreEx.Input

local Orbwalker = require("lol/Modules/Common/OGOrbWalker")

--- calculation
local function getQdmg(target)
	local yoneQdmg = {20, 40, 60, 80, 100}
	local dmgQ = yoneQdmg[Player:GetSpell(SpellSlots.Q).Level]
	return (dmgQ + Player.TotalAD) * (100.0 / (100 + target.Armor ) )
end

local function getWdmg(target)
	local yoneWdmg = {10, 20, 30, 40, 50}
	local dmgW = yoneWdmg[Player:GetSpell(SpellSlots.W).Level]
	local yoneWdmgHP = {0.11, 0.12, 0.13, 0.14, 0.15}
	local dmgWHP = yoneWdmgHP[Player:GetSpell(SpellSlots.W).Level]
	return (dmgW * (100.0 / (100 + target.Armor))) + (target.MaxHealth * yoneWdmgHP)
end

local function AutoQ()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			
			local dist = myPos:Distance(hero.Position)
			local mousepos = Renderer.GetMousePos()
--- Q + aa	

				if dist <= 475  then 
					Input.Cast(SpellSlots.Q, hero.Position)
				end
		end		
	end	
end 

local function AutoQcombo()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			 
			local dist = myPos:Distance(hero.Position)
			local mousepos = Renderer.GetMousePos()
--- Q + aa			
				if dist <= 475 and getQdmg(hero) > (hero.MaxHealth) then 
					Input.Cast(SpellSlots.Q, hero.Position)
				end
		end		
	end	
end 

local function AutoW()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	if Player:GetSpellState(SpellSlots.W) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			
			local dist = myPos:Distance(hero.Position)
			local mousepos = Renderer.GetMousePos()
--- Q + aa			
				if dist <= 475 then 
					Input.Cast(SpellSlots.W, hero.Position)
				end
		end		
	end	
end 

local function OnTick()	
	AutoQcombo()
	local target = Orbwalker.Mode == 1
	if target then 
	AutoQ()
	AutoW()
	end
end


function OnLoad() 
	if Player.CharName ~= "Yone" then return false end 
	
	
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
		
	Orbwalker.Initialize()

	Game.PrintChat("DickYone v0.1 Loaded !")
    
	return true
end				
			