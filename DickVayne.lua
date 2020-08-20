require("common.log")
module("DickVayne v0.6", package.seeall, log.setup)
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





--- Q DMG logic
local function getQdmg(target)
	local vayneQ = {0.6, 0.65, 0.7, 0.75, 0.8}
	local dmgQ = vayneQ[Player:GetSpell(SpellSlots.Q).Level]
	return ( (dmgQ * Player.TotalAD) + Player.TotalAD ) * (100.0 / (100 + target.Armor ) )
end
--- W DMG logic
function getWdmg(target)
		local VayneW = {0.04, 0.065, 0.09, 0.115, 0.14}
		local dmgW = VayneW[Player:GetSpell(SpellSlots.W).Level]
		return target.MaxHealth * dmgW
end

local function countWStacks(target) 
	local ai = target.AsAI
    if ai and ai.IsValid then
		for i = 0, ai.BuffCount do
			local buff = ai:GetBuff(i)
			if buff then
				if buff.Name ~= "x" then
					if buff.Count ~= nil then
						return buff.Count
					end
				end
			end
		end
	end
	return 0
end
------------------------------
--- E DMG logic
local function getEdmg(target)
	local vayneE = {50, 85, 120, 155, 190}
	local dmgE = vayneE[Player:GetSpell(SpellSlots.E).Level]
	return (dmgE + (Player.BonusAD * 0.5) ) * (100.0 / (100 + target.Armor ) )
end
------------------------------

------------------------------
--- KS EW DMG logiv
local function getKSWEdmg(target)
	return getEdmg(target) + getWdmg(target)
end
------------------------------
--- KS W+Qaa DMG logiv
local function getKSQWdmg(target)
	return getQdmg(target) + getWdmg(target)
end
------------------------------
-- KS Qaa+W+E logic
local function getKSWQEdmg(target)
	return getWdmg(target) + getQdmg(target) + getEdmg(target)
end
------------------------------
-- KS Qaa+E
local function getKSQEdmg(target)
	return getQdmg(target) + getEdmg(target)
end

----------------------
---- Q settings
----------------------
local function AutoQ()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local buffCountBolts = countWStacks(hero) 
			local dist = myPos:Distance(hero.Position)
			local mousepos = Renderer.GetMousePos()
--- Q + aa			
			if dist < 580 and getQdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)
			elseif	dist > 580 and dist < 750 and getQdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, hero.Position)
				Input.Attack(hero)
---  Q + aa(W_passive)
			elseif dist < 580 and buffCountBolts == 2 and getKSQWdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)					
			elseif dist > 580 and dist < 750 and buffCountBolts == 2 and getKSQWdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, hero.Position)
				Input.Attack(hero)	
			end
		end		
	end	
end 
------
----------------------
---- E settings
----------------------
local function AutoE()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	
	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local buffCountBolts = countWStacks(hero) 
			local dist = myPos:Distance(hero.Position)
			local mousepos = Renderer.GetMousePos()
-- Stop Chanling Closer			
			if dist <= 550 and hero.IsChanneling then
				Input.Cast(SpellSlots.E, hero) 
			elseif dist > 550 and hero.IsChanneling and dist < 750 and Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
			Input.Cast(SpellSlots.Q, hero.Position)
			Input.Cast(SpellSlots.E, hero)
			end
-- Anti-Gap Closer			
			if dist <= 200 then				
				Input.Cast(SpellSlots.E, hero) 
--- E(W_passive)				
			elseif dist <= 550 and buffCountBolts == 2 and getKSWEdmg(hero) > (hero.Health) then
				Input.Cast(SpellSlots.E, hero)				
			end
		end		
	end	
end 


local function AutoQE()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
	if  Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local buffCountBolts = countWStacks(hero) 
			local dist = myPos:Distance(hero.Position)
			
			local mousepos = Renderer.GetMousePos()
--- Q + aa(W_passive) + E			
			if dist < 580 and getKSQEdmg(hero) > (hero.Health)then	
				Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)
    --toadd EventManager.FireEvent(Events.OnAutoAttack)
			elseif dist > 580 and dist < 750  and getKSQEdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, hero.Position)
				Input.Attack(hero)
    --toadd EventManager.FireEvent(Events.OnAutoAttack)
--- Q + aa + E	
			elseif dist < 580 and buffCountBolts == 2 and getKSWQEdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)				
    --toadd EventManager.FireEvent(Events.OnAutoAttack)
			elseif dist > 580 and dist < 750 and buffCountBolts == 2 and getKSWQEdmg(hero) > (hero.Health) then	
				Input.Cast(SpellSlots.Q, hero.Position)
				Input.Attack(hero)
    --toadd EventManager.FireEvent(Events.OnAutoAttack)
			end
		end		
	end	
end 

				
				
----------------------
----------------------
--- Ticking this shit

local function OnTick()	
	AutoE()
	AutoQ()
---	AutoQE()	   --toadd EventManager.FireEvent(Events.OnAutoAttack)

	local target = Orbwalker.Mode == 1 and Orbwalker.CurrentTarget
	if target then 

	end
end

--- On Load
function OnLoad() 
	if Player.CharName ~= "Vayne" then return false end 
	
	
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
		
	Orbwalker.Initialize()

	Game.PrintChat("DickVayne v0.6 Loaded !")
    
	return true
end				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				