require("common.log")
module("DickVayne v1.0", package.seeall, log.setup)
--- api


local _SDK = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game = _SDK.ObjectManager, _SDK.EventManager, _SDK.Input, _SDK.Enums, _SDK.Game
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player
local Events = _SDK.Enums.Events
local BuffTypes = _SDK.Enums.BuffTypes
local Renderer = _G.CoreEx.Renderer
local Input = _G.CoreEx.Input
local Vector = _G.CoreEx.Geometry.Vector
local DistanceSqr = _G.CoreEx.Geometry.Vector.DistanceSqr
local LineDistance = _G.CoreEx.Geometry.Vector.LineDistance

local Orb = require("lol/Modules/Common/Orb")
local ts = require("lol/Modules/Common/simpleTS")

local _Q = SpellSlots.Q
local _W = SpellSlots.W
local _E = SpellSlots.E
local _R = SpellSlots.R

----------------------
--- calculation
----------------------
--- SILVER BOLTS STACKS
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
--- Q DMG
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
--- E DMG logic
		--- E No WAll
local function getEdmg(target)
	local vayneE = {50, 85, 120, 155, 190}
	local dmgE = vayneE[Player:GetSpell(SpellSlots.E).Level]
	return (dmgE + (Player.BonusAD * 0.5) ) * (100.0 / (100 + target.Armor ) )
end
		--- E Wall
local function getEdmgWall(target)
	local vayneEWall = {50, 85, 120, 155, 190}
	local dmgEWall = vayneEWall[Player:GetSpell(SpellSlots.E).Level]
	local vayneEWallbonus = {75, 127.5, 180, 232.5, 285}
	local dmgEWallbonus = vayneEWallbonus[Player:GetSpell(SpellSlots.E).Level]
	return ((dmgEWall + (Player.BonusAD * 0.5) ) + (dmgEWallbonus + (Player.BonusAD * 0.75) )) * (100.0 / (100 + target.Armor ) )
end		
		
--- KS EW DMG logiv
local function getKSWEdmg(target)
	return getEdmg(target) + getWdmg(target)
end
--- KS EW wall DMG logiv
local function getKSWEdmgWall(target)
	return getEdmgWall(target) + getWdmg(target)
end
--- KS W+Qaa DMG logiv
local function getKSQWdmg(target)
	return getQdmg(target) + getWdmg(target)
end
		
		
		
		
----------------------
-- Tumble and Condemn Logic
----------------------
---- TumbleLogic
local function Tumble()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local buffCountBolts = countWStacks(hero) 
			local dist = myPos:DistanceSqr(hero.Position)
			local mousepos = Renderer.GetMousePos()
			local AfterTumblePos = myPos + (mousepos - myPos):Normalized() * 300
			local DistanceAfterTumble = DistanceSqr(AfterTumblePos, hero.Position)
			
            if  DistanceAfterTumble < 630*630 and DistanceAfterTumble > 300*300 and (hero.Health) < (hero.MaxHealth*0.8) and (hero.Health) > (hero.MaxHealth*0.1) then
                Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)
				
			elseif	DistanceAfterTumble < 630*630 and DistanceAfterTumble > 300*300 and (hero.Health) <= (Player.Health) and (hero.Health) > (hero.MaxHealth*0.05) then
                Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)
            end
			
            if dist > 630*630 and DistanceAfterTumble < 630*630 and (hero.Health) > (hero.MaxHealth*0.05) then
                Input.Cast(SpellSlots.Q, mousepos)
				Input.Attack(hero)
			end		
		end	
	end 
end
---- CondemnLogic
function Condemn()
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")
	
	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
			for handle, obj in pairs(enemies) do  
				

				local hero = obj.AsHero   
				local buffCountBolts = countWStacks(hero) 
					if hero and hero.IsTargetable and myPos:Distance(hero.Position) <= 800 and myPos:Distance(hero.Position) > 0 then
					local PushDistance = 400
				if hero.IsMoving then	
								local ezPredict = hero:FastPrediction(300)
								local PushPositionM = ezPredict + (ezPredict - Player.Position):Normalized()*(PushDistance)
								local WallPointM = Vector.IsWall(PushPositionM) 
									if WallPointM and (hero.Health) >= (hero.MaxHealth*0.3) then
										Input.Cast(SpellSlots.E, hero)
									end	
									if WallPointM and getKSWEdmg(hero) > (hero.Health) then
										Input.Cast(SpellSlots.E, hero)
									end	

				
				elseif Player.Position:Distance(hero.Position) <= 799 then
								local PushPosition = hero.Position + (hero.Position - Player.Position):Normalized()*(PushDistance)
								local WallPoint = Vector.IsWall(PushPosition) 


									if WallPoint and (hero.Health) >= (hero.MaxHealth*0.3) then
										Input.Cast(SpellSlots.E, hero)
									end	
									if WallPoint and getKSWEdmgWall(hero) > (hero.Health) and buffCountBolts == 2 then
										Input.Cast(SpellSlots.E, hero)
									end	

						end
									
						end

	end
end

----------------------
-- KillSecure
----------------------
-- Auto Qaa
local function AutoQ()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	
	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local buffCountBolts = countWStacks(hero) 
		
			if getQdmg(hero) > (hero.Health) then	
					Tumble(hero)
			end

			if buffCountBolts == 2 and getKSQWdmg(hero) > (hero.Health) then	
					Tumble(hero)					

			end
		end		
	end	
end 
----------------------
-- Chanling GapCloser WIP
----------------------
-- AutoE
local function AutoE()
	local enemies = ObjManager.Get("enemy", "heroes")
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)	
	
	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end

	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			local dist = myPos:Distance(hero.Position)
-- Stop Chanling Closer			
			if dist <= 550 and hero.IsChanneling then
				Input.Cast(SpellSlots.E, hero) 
			elseif dist > 630 and hero.IsChanneling and dist < 750 and Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
		
			Tumble(hero)
			Input.Cast(SpellSlots.E, hero)
			end

end
end
end
----------------------
local function OnTick()	
	Condemn()
	AutoQ()	
	AutoE()
	local target = Orb.Mode.Combo and ts:GetTarget(1150,ts.Priority.LowestHealth)
	if target then 
	
	Tumble(target)
	end


	

end

--- On Load
function OnLoad() 
	if Player.CharName ~= "Vayne" then return false end 
	
	
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
		

	Orb.Load()
	Game.PrintChat("DickVayne Loaded !")
    
	return true
end				
				
				
				
				
				
				
				
				
				
				
				
				