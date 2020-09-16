--[[
 ▄ .▄  ▪       ▄▄▄· ▪        
██▪▐█  ██     ▐█ ▀█ ██ ▪     
██▀▐█  ▐█·    ▄█▀▀█ ▐█· ▄█▀▄ 
██▌▐▀  ▐█▌    ▐█ ▪▐▌▐█▌▐█▌.▐▌
▀▀▀ ·  ▀▀▀     ▀  ▀ ▀▀▀ ▀█▄▀▪
by h1d31n455
	big thx to :P E2Slayer for your work u can see your ideas donwn here im learning sry

Changelog :

	- Activator : 
		- _BotRK [DONE]
		- _QSS []
		- _Potion []
		- _Sumoners(Barier, Heal) []
		-
		
	- Utility
		- _FlashTracerk [DONE] - TO INPROVE
		- _DontHideOnBush [DONE]
		- _Look_For_Low_Target []
		-
		
	- Chempions
		- _Vayne []
		- _Caitlyn []
		- _i_dont_know


]]--


local _champions  = {'Vayne',}
local h1d31n455_aio = 1.0
--------------------------------------
--------------------------------- Core
--------------------------------------


require("common.log")
module("H1_AiO", package.seeall, log.setup)
-------------------------------------- require
 
 local DamageLib = require("lol/Modules/Common/DamageLib")
-------------------------------------- api

 local Pred = _G.Libs.Prediction
 local HealthPred = _G.Libs.HealthPred
 local DamageLib = _G.Libs.DamageLib
 local Collision = _G.Libs.CollisionLib
 local Orbwalker = _G.Libs.Orbwalker

 local _Core = _G.CoreEx
 local Nav = _Core.Nav
 local ObjManager = _Core.ObjectManager
 local EventManager = _Core.EventManager
 local Input = _Core.Input
 local Enums = _Core.Enums
 local Game = _Core.Game
 local SpellSlots = Enums.SpellSlots
 local SpellStates = Enums.SpellStates
 local Player = ObjManager.Player
 local Events = Enums.Events
 local BuffTypes = Enums.BuffTypes
 local Geometry = _Core.Geometry
 local Renderer = _Core.Renderer
 local Vector = Geometry.Vector
 local DistanceSqr = Vector.DistanceSqr
 local LineDistance = Vector.LineDistance
 local FireEvent = EventManager.FireEvent
---------------------------------- api_shorts
 local insert = table.insert 
 local remove = table.remove 
 local Cast = Input.Cast
 local _Q = SpellSlots.Q
 local _W = SpellSlots.W
 local _E = SpellSlots.E
 local _R = SpellSlots.R 
 local Trinket = SpellSlots.Trinket

 local enemies = ObjManager.Get("enemy", "heroes")
 local allayys = ObjManager.Get("ally", "heroes")
 local all = ObjManager.Get("all", "heroes")
 local turrets = ObjManager.Get("enemy", "turrets")

------------------------------------ math
local sqrt, min, max, cos, sin, pi, huge, ceil, floor, round, random, abs, deg, asin, acos = math.sqrt,math.min, math.max, math.cos, math.sin, math.pi, math.huge, math.ceil, math.floor, math.round, math.random, math.abs, math.deg, math.asin, math.acos


-------------------------------------- core_functions
------Menu
--Main_Menu
 local i_Menu = _G.Libs.Menu
 local M_Menu = i_Menu:AddMenu("H1AiOMenu", "[H1_AiO]:")
--Activator
	local A_Menu = M_Menu:AddMenu("Activator_Menu","[Activator]:")
	 local A_MenuLabel = A_Menu:AddLabel("Activator_Menu",":[Activator]")
--Utility
	local U_Menu = M_Menu:AddMenu("U_Menu1","[Utility]:")
	 local U_Menu_Label = U_Menu:AddLabel("U_Menu_Label",":[Utility]")
------


--Class
local BaseClass = {}
 function BaseClass:OnTick() end
 function BaseClass:OnBuffGain(obj, buff) end
 function BaseClass:OnPostAttack() end
 function BaseClass:OnProcessSpell(obj, spell) end
 function BaseClass:OnDraw() end
 
local BotRK = {}
setmetatable(BotRK, {__index = BaseClass})

local Bush = {}
setmetatable(Bush, {__index = BaseClass})

local FlashTracerk = {}
setmetatable(FlashTracerk, {__index = BaseClass})


local H1_Classes = {BotRK, Bush, FlashTracerk}


--AddFunction
local function sReady(spelltocheck)
	return Player:GetSpellState(spelltocheck) == SpellStates.Ready 
end









--------------------------------------
---------------------------- Activator
--------------------------------------

--------------- BotRK
function BotRK:Init()
	BotRK:Menu()
end

function BotRK:Menu()
 --

		self.BotRK_Menu = A_Menu:AddMenu("BotRK_Label","[BotRK]:")
		 self.BotRK_Label1 = self.BotRK_Menu:AddLabel("BotRK_Label",":[BotRK]")
		 
				self.BotRK_MenuMode = self.BotRK_Menu:AddMenu("BotRK_MenuMode", "[Mode Selector]:")
					self.BotRK_MenuMode_Label1 = self.BotRK_MenuMode:AddLabel("BotRK_MenuMode_Label1", ":[Mode Selector]")
					self.BotRK_MenuMode_Label2 = self.BotRK_MenuMode:AddLabel("BotRK_MenuMode_Label2", "When to use BotRK")
					self.BotRK_MenuMode_On_Off = self.BotRK_MenuMode:AddBool("BotRK_MenuMode_On_Off", "on/off", true)
					self.BotRK_MenuMode_Combo = self.BotRK_MenuMode:AddBool("BotRK_MenuMode_Combo", "FightMode", true)
					self.BotRK_MenuMode_Harass = self.BotRK_MenuMode:AddBool("BotRK_MenuMode_Harass", "HarassMode", false)
					
				self.BotRK_MenuHP = self.BotRK_Menu:AddMenu("BotRK_MenuHP", "[HP Settings]:")
					self.BotRK_MenuHP_Label1 = self.BotRK_MenuHP:AddLabel("BotRK_MenuHP_Label1", ":[HP Settings]")
					self.BotRK_MenuHP_Label2 = self.BotRK_MenuHP:AddLabel("BotRK_MenuHP_Label2", "Setting to us BotRK")
					self.BotRK_MenuHP_MyHP = self.BotRK_MenuHP:AddSlider("BotRK_MenuHP_MyHP", "Max Own HP",0,100,1,50)
					self.BotRK_MenuHP_EHP = self.BotRK_MenuHP:AddSlider("BotRK_MenuHP_EHP", "Min Enamy HP",0,100,1,20)	

end

function BotRK:OnTick()	
	local target = Orbwalker.GetTarget()
	if self.BotRK_MenuMode_On_Off.Value and target then
		local myPos = Player.Position
		local dist = myPos:Distance(target.Position)	
		for i=SpellSlots.Item1, SpellSlots.Item6 do
			local _item = Player:GetSpell(i)
			if _item ~= nil and _item then
				if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" then
							if sReady(i) then
								if ( Orbwalker.GetMode() == "Combo" and BotRK_MenuMode_Combo.Value ) or ( Orbwalker.GetMode() == "Harass" and BotRK_MenuMode_Harass.Value) then
									if (target.Health) >= ((target.MaxHealth*(self.BotRK_MenuHP_EHP.Value / 100))) and (Player.Health) >= ((Player.MaxHealth*(self.BotRK_MenuHP_MyHP.Value / 100))) then
										if dist <= _item.DisplayRange then
											Cast(i, target)
										end
									break
									end
								end
							end
				end
			end
		end
	end
end	

--------------- QSS

--------------------------------------
------------------------------ Utility
--------------------------------------

--------------- DontHideOnBush
function Bush:Init()
	Bush:Menu()
	self.lasttime = {}
	self.next_wardtime = 0	
	self.lastpos = {}
end

function Bush:Menu()
 --
	 
		self.Bush_Menu = U_Menu:AddMenu('DontHideOnBush','[DontHideOnBush]:')
		 self.Bush_Menu_Label = self.Bush_Menu:AddLabel('Bush_Label1',':[DontHideOnBush]')

			self.Bush_On_Off = self.Bush_Menu:AddBool('On_Off','DontHideOnBush', true)
			self.Bush_Menu_Label2 = self.Bush_Menu:AddLabel('Bush_Label2','Max Time to check Enemy in Bush')
			self.Bush_Time = self.Bush_Menu:AddSlider('Bush_Time','Time in sec',0,10,1,3)
		
end

function Bush:OnTick()
if self.Bush_On_Off.Value then
	for _,c in pairs(enemies) do		
		if c.IsVisible and c.AsHero then
			self.lastpos[c] = c.Position
			self.lasttime[c] = os.clock()
		elseif not c.IsDead and not c.IsVisible then

				local time=self.lasttime[c] --last seen time
				local pos=self.lastpos[c]   --last seen pos
				local clock=os.clock()
				if time and pos and clock-time<self.Bush_Time.Value and clock>self.next_wardtime and Player.Position:DistanceSqr(pos)<1000*1000 then
					local FoundBush = Bush:FindBush(pos.x,pos.y,pos.z,100)
					if FoundBush and Player.Position:DistanceSqr(FoundBush)<600*600 then
						if sReady(Trinket) then
							Cast(Trinket,FoundBush)
							self.next_wardtime=clock+0.5
							return
						end
					end
				end
			end
		end
	end
end
--------FindBush
function Bush:FindBush(x0, y0, z0, maxRadius, precision) --returns the nearest non-wall-position of the given position(Credits to gReY)
    --Convert to vector
    local vec = Vector(x0, y0, z0)
    --If the given position it a non-wall-position return it
	--if IsWallOfGrass(vec) then
	--	return vec 
	--end
    --Optional arguments
    precision = precision or 50
    maxRadius = maxRadius and math.floor(maxRadius / precision) or math.huge
    --Round x, z
    x0, z0 = math.round(x0 / precision) * precision, math.round(z0 / precision) * precision
    --Init vars
    local radius = 2
    --Check if the given position is a non-wall position
    local function checkP(x, y) 
        vec.x, vec.z = x0 + x * precision, z0 + y * precision 
        return Vector.IsGrass(vec) 
    end
    --Loop through incremented radius until a non-wall-position is found or maxRadius is reached
    while radius <= maxRadius do
        --A lot of crazy math (ask gReY if you don't understand it. I don't)
        if checkP(0, radius) or checkP(radius, 0) or checkP(0, -radius) or checkP(-radius, 0) then 
			--print("#2:"..radius)
            return vec 
        end
        local f, x, y = 1 - radius, 0, radius
        while x < y - 1 do
            x = x + 1
            if f < 0 then 
                f = f + 1 + 2 * x
            else 
                y, f = y - 1, f + 1 + 2 * (x - y)
            end
            if checkP(x, y) or checkP(-x, y) or checkP(x, -y) or checkP(-x, -y) or 
               checkP(y, x) or checkP(-y, x) or checkP(y, -x) or checkP(-y, -x) then 
			--	print("#3:"..radius)
                return vec 
            end
        end
        --Increment radius every iteration
        radius = radius + 1
    end
end

--------------- FlashTracerk
function FlashTracerk:Init()
	FlashTracerk:Menu()
	
	self.StartPos={}
	self.EndPos={}
	self.caster={}
end

function FlashTracerk:Menu()
		self.FlashTracerk_Menu = U_Menu:AddMenu('FlashTracerk','[FlashTracerk]:')
		 self.FlashTracerk_Menu_Label1 = self.FlashTracerk_Menu:AddLabel('FlashTracerk_Menu_Label1',':[FlashTracerk]')
		 self.FlashTracerk_Menu_Label2 = self.FlashTracerk_Menu:AddLabel('FlashTracerk_Menu_Label2','FlashTracerkEnemyOnly')
			self.FlashTracerk_On_Off = self.FlashTracerk_Menu:AddBool('FlashTracerk_On_Off','ON/OFF', true)
end

function FlashTracerk:OnProcessSpell(obj, spell)
	if obj.AsHero and not obj.IsMe and self.FlashTracerk_On_Off.Value then
	self.caster=obj
	local z = spell.Name
	local rt = spell.EndPos
	local et = spell.StartPos
	if z == "SummonerFlash" then
	self.EndPos = rt 
	self.StartPos = et
	delay(3000, function()
	self.StartPos = {}
	self.EndPos = {}
	end)
	end
end
end

function FlashTracerk:OnDraw()
	local endpos = self.EndPos
	local stapos = self.StartPos
	Renderer.DrawLine3D(stapos, endpos, 1, 0xFFFF00FF)
	Renderer.DrawText(Renderer.WorldToScreen(endpos), Vector(30, 15, 0), 'Here', 0xFF0000FF)
end


--------------------------------------
---------------------------- Chempions
--------------------------------------

--------------------------------------
--------------------------------- Load
--------------------------------------
function OnTick()
	for i, class in ipairs(H1_Classes) do
		class:OnTick()
	end
end
function OnDraw()
	for i, class in ipairs(H1_Classes) do
		class:OnDraw()
	end
end
function OnProcessSpell(obj, spell)
	for i, class in ipairs(H1_Classes) do
		class:OnProcessSpell(obj, spell)
	end
end


function OnLoad()
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
 	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
	for i, class in ipairs(H1_Classes) do
		class:Init()
	end
	
	function Supp()
	for i, chemp in ipairs(_champions) do
		if chemp == Player.CharName then 
			 return true
		end
	  end
	  return false
	end	
	
	
	
Game.PrintChat('__________________________')
Game.PrintChat('    <font color="#00ffea">[h1d31n455]</font>')
Game.PrintChat('    <font color="#FFD700">H1_AiO</font> <font color="#ffffff">Loaded.</font>')
Game.PrintChat('    <font color="#b4b4b4">AiO_Version:</font> <font color="#ffffff">  ' .. string.format("%.1f", h1d31n455_aio) .. '</font>')
if Supp() then
	Game.PrintChat('    <font color="#b4b4b4">AiO_Champion:</font> <font color="#48e32d">  ' .. Player.CharName..'_Supported</font>')
else
	Game.PrintChat('    <font color="#b4b4b4">AiO_Champion:</font> <font color="#FF0000">  '..Player.CharName..'_Not_Supported</font>')
end
Game.PrintChat('__________________________')
	return true
end	