--[[ 

by my.name
	big thx to :P E2Slayer for your work u can see your ideas donwn here im learning sry

Changelog :

	- Activator : 
		- _BotRK [DONE]
		- _QSS (Cleans) [To_Do]
		- _Potion [DONE]
		- _Sumoners(Barier, Heal) [DONE]
		- _
		
	- Utility
		- _FlashTracerk [DONE] - TO INPROVE
		- _DontHideOnBush [DONE]
		- _BaseUlty [done by someone else]
		- _WardHelper [To_Do]
		
	- Chempions
		- _Vayne [dont work cuz of orbwalk]
		- _Caitlyn [DONE] :
			- _Look_For_Low_Target [To_Do]
			- _Better_R_Logic [To_Do]
		- _Ashe [To_Do]
		- _Kog'Mav [To_Do]
		- _Jhin [To_Do]
		- _Sivir [To_Do]

]]--


local _champions  = {'Vayne', 'Caitlyn',}
local myname_aio = 1.0
--------------------------------------
--------------------------------- Core
--------------------------------------


require("common.log")
module("myname_aio", package.seeall, log.setup)
-------------------------------------- require
 
 local DamageLib = require("lol/Modules/Common/DamageLib")
-------------------------------------- api

 local Pred = _G.Libs.Prediction
 local HealthPred = _G.Libs.HealthPred
 local DamageLib = _G.Libs.DamageLib
 local Collision = _G.Libs.CollisionLib
 local Orbwalker = _G.Libs.Orbwalker
 local TS = _G.Libs.TargetSelector

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
 local Atack = Input.Attack
 local _Q = SpellSlots.Q
 local _W = SpellSlots.W
 local _E = SpellSlots.E
 local _R = SpellSlots.R 
 local _sum1 = SpellSlots.Summoner1
 local _sum2 = SpellSlots.Summoner2
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
 local M_Menu = i_Menu:AddMenu("M_Menu", "[MarksManShip_AiO]:")
--Activator
	local A_Menu = i_Menu.M_Menu:AddMenu("A_Menu","[Activator]:")
	 local A_MenuLabel = i_Menu.M_Menu.A_Menu:AddLabel("A_MenuLabel",":[Activator]")
--Utility
	local U_Menu = i_Menu.M_Menu:AddMenu("U_Menu","[Utility]:")
	 local U_Menu_Label = i_Menu.M_Menu.U_Menu:AddLabel("U_Menu_Label",":[Utility]")
--Chapions
	local Champion_Menu = i_Menu.M_Menu:AddMenu("Champion_Menu","[Chapions]:")
	 local Champion_Menu_Label = i_Menu.M_Menu.Champion_Menu:AddLabel("Champion_Menu_Menu_Label",":[Chapions]")

------


--Class
local BaseClass = {}
 function BaseClass:OnTick() end
 function BaseClass:OnBuffGain(obj, buff) end
 function BaseClass:OnPostAttack() end
 function BaseClass:OnProcessSpell(obj, spell) end
 function BaseClass:OnDraw() end
 
local ItemsActivator = {}
 setmetatable(ItemsActivator, {__index = BaseClass})

local Bush = {}
 setmetatable(Bush, {__index = BaseClass})

local FlashTracerk = {}
 setmetatable(FlashTracerk, {__index = BaseClass})

local Potions = {}
 setmetatable(Potions, {__index = BaseClass})


local Vayne = {}
 setmetatable(Vayne, {__index = BaseClass})

local Caitlyn = {}
 setmetatable(Caitlyn, {__index = BaseClass})
 
local Summoners = {}
 setmetatable(Summoners, {__index = BaseClass})

local H1_Classes = {classes = {ItemsActivator, Potions, Summoners, Bush, FlashTracerk, }}

if Player.CharName == 'Caitlyn' then
	insert(H1_Classes.classes, Caitlyn)
end
if Player.CharName == 'Vayne' then
	insert(H1_Classes.classes, Vayne)
end

isAGapcloserUnitTarget = {
        ['AkaliR']					= {true, Champ = 'Akali', 		spellKey = 'R'},
        ['Headbutt']     			= {true, Champ = 'Alistar', 	spellKey = 'W'},
        ['DianaE']       	= {true, Champ = 'Diana', 		spellKey = 'E'},
        ['IreliaGatotsu']     		= {true, Champ = 'Irelia',		spellKey = 'Q'},
        ['JaxLeapStrike']         	= {true, Champ = 'Jax', 		spellKey = 'Q'},
        ['JayceToTheSkies']       	= {true, Champ = 'Jayce',		spellKey = 'Q'},
        ['MaokaiUnstableGrowth']    = {true, Champ = 'Maokai',		spellKey = 'W'},
        ['MonkeyKingNimbus']  		= {true, Champ = 'MonkeyKing',	spellKey = 'E'},
        ['Pantheon_LeapBash']   	= {true, Champ = 'Pantheon',	spellKey = 'W'},
        ['PoppyHeroicCharge']       = {true, Champ = 'Poppy',		spellKey = 'E'},
        ['QuinnE']       			= {true, Champ = 'Quinn',		spellKey = 'E'},
        ['XenZhaoSweep']     		= {true, Champ = 'XinZhao',		spellKey = 'E'},
        ['blindmonkqtwo']	    	= {true, Champ = 'LeeSin',		spellKey = 'Q'},
        ['FizzPiercingStrike']	    = {true, Champ = 'Fizz',		spellKey = 'Q'},
        ['RengarLeap']	    		= {true, Champ = 'Rengar',		spellKey = 'Q/R'},
		['PykeE']					= {true, Champ = 'Pyke', 		spellKey = 'E'},
		['HecarimE']				= {true, Champ = 'Hecarim', 	spellKey = 'E'},
    }

isAGapcloserUnitNoTarget = {
        ['GalioE']					= {true, Champ = 'Galio', 		range = 650,   	projSpeed = 2300, spellKey = 'E'},
        ['GragasE']					= {true, Champ = 'Gragas', 		range = 600,   	projSpeed = 2000, spellKey = 'E'},
        ['GravesMove']				= {true, Champ = 'Graves', 		range = 425,   	projSpeed = 2000, spellKey = 'E'},
        ['HecarimUlt']				= {true, Champ = 'Hecarim', 	range = 1000,   projSpeed = 1200, spellKey = 'R'},
        ['JarvanIVDragonStrike']	= {true, Champ = 'JarvanIV',	range = 770,   	projSpeed = 2000, spellKey = 'Q'},
        ['JarvanIVCataclysm']		= {true, Champ = 'JarvanIV', 	range = 650,   	projSpeed = 2000, spellKey = 'R'},
        ['KhazixE']					= {true, Champ = 'Khazix', 		range = 900,   	projSpeed = 2000, spellKey = 'E'},
        ['khazixelong']				= {true, Champ = 'Khazix', 		range = 900,   	projSpeed = 2000, spellKey = 'E'},
        ['LeblancSlide']			= {true, Champ = 'Leblanc', 	range = 600,   	projSpeed = 2000, spellKey = 'W'},
        ['LeblancSlideM']			= {true, Champ = 'Leblanc', 	range = 600,   	projSpeed = 2000, spellKey = 'WMimic'},
        ['LeonaZenithBlade']		= {true, Champ = 'Leona', 		range = 900,  	projSpeed = 2000, spellKey = 'E'},
        ['UFSlash']					= {true, Champ = 'Malphite', 	range = 1000,  	projSpeed = 1800, spellKey = 'R'},
        ['RenektonSliceAndDice']	= {true, Champ = 'Renekton', 	range = 450,  	projSpeed = 2000, spellKey = 'E'},
        ['SejuaniArcticAssault']	= {true, Champ = 'Sejuani', 	range = 650,  	projSpeed = 2000, spellKey = 'Q'},
        ['ShenE']					= {true, Champ = 'Shen', 		range = 600,  	projSpeed = 2000, spellKey = 'E'},
        ['RocketJump']				= {true, Champ = 'Tristana', 	range = 900,  	projSpeed = 2000, spellKey = 'W'},
        ['slashCast']				= {true, Champ = 'Tryndamere', 	range = 650,  	projSpeed = 1450, spellKey = 'E'},
		['DariusAxeGrabCone']				= {true, Champ = 'Darius', 	range = 550,  	projSpeed = 2000, spellKey = 'E'},
    }

isAChampToInterrupt = {


        ['KatarinaR']					= {true, Champ = 'Katarina',	spellKey = 'R'},
        ['GalioR']						= {true, Champ = 'Galio',		spellKey = 'R'},
        ['Crowstorm']					= {true, Champ = 'FiddleSticks',spellKey = 'R'},
        ['Drain']						= {true, Champ = 'FiddleSticks',spellKey = 'W'},
        ['AbsoluteZero']				= {true, Champ = 'Nunu',		spellKey = 'R'},
        ['ShenStandUnited']				= {true, Champ = 'Shen',		spellKey = 'R'},
        ['UrgotSwap2']					= {true, Champ = 'Urgot',		spellKey = 'R'},
        ['AlZaharNetherGrasp']			= {true, Champ = 'Malzahar',	spellKey = 'R'},
        ['FallenOne']					= {true, Champ = 'Karthus',		spellKey = 'R'},
        ['Pantheon_GrandSkyfall_Jump']	= {true, Champ = 'Pantheon',	spellKey = 'R'},
        ['VarusQ']						= {true, Champ = 'Varus',		spellKey = 'Q'},
        ['CaitlynAceintheHole']			= {true, Champ = 'Caitlyn',		spellKey = 'R'},
        ['MissFortuneBulletTime']		= {true, Champ = 'MissFortune',	spellKey = 'R'},
        ['InfiniteDuress']				= {true, Champ = 'Warwick',		spellKey = 'R'},
        ['LucianR']						= {true, Champ = 'Lucian',		spellKey = 'R'},

    }


TS = _G.Libs.TargetSelector(Orbwalker.Menu)

--AddFunction
local function sReady(spelltocheck)
	return Player:GetSpellState(spelltocheck) == SpellStates.Ready 
end
-------- Find Enemy in range
local function GetEnemisInRange(startPos, radius, speed, delay, maxResults, allyOrEnemy)
    local res = {Result = false, Objects = {}, Positions = {}}
    if not maxResults then maxResults = 1 end
    if type(allyOrEnemy) ~= "string" or allyOrEnemy ~= "ally" then allyOrEnemy = "enemy" end
			local spellRadius = Geometry.Circle(startPos, radius)
			for k, obj in pairs(ObjManager.Get(allyOrEnemy, "heroes")) do 
				local hero = obj.AsHero
				local pos = hero:FastPrediction(delay + hero:EdgeDistance(spellRadius) / speed)
				
				if pos:Distance(spellRadius) < radius and hero.IsTargetable then
				insert(res.Positions, hero.Position)
				res.Result = true
				insert(res.Objects, hero)
				if #res.Objects >= maxResults then break end
            end
        end
	return res
end
-------- Find turets in range
local function GetturretsisInRange(startPos, radius, speed, delay, maxResults)
    local res = {Result = false, Objects = {}, Positions = {}}
    if not maxResults then maxResults = 1 end
 
			local spellRadius = Geometry.Circle(startPos, radius)
			local turrets = ObjManager.Get("enemy", "turrets")
			for k, obj in pairs(turrets) do 
				local turrets2 = obj.AsAI
				local pos = obj.Position
				
				if pos:Distance(spellRadius) < radius then
				insert(res.Positions, turrets2.Position)
				res.Result = true
				insert(res.Objects, turrets2)
				if #res.Objects >= maxResults then break end
            end
        end
	return res
end
--------CircleCircleIntersection
local function CircleCircleIntersection(c1, c2, r1, r2)
        local D = c1:Distance(c2)
        if D > r1 + r2 or D <= abs(r1 - r2) then return nil end
        local A = (r1 * r2 - r2 * r1 + D * D) / (2 * D)
        local H = sqrt(r1 * r1 - A * A)
        local Direction = (c2 - c1):Normalized()
        local PA = c1 + A * Direction
        local S1 = PA + H * Direction:Perpendicular()
        local S2 = PA - H * Direction:Perpendicular()
        return S1, S2
    end	
--------IsFacing
local function IsFacing(unit, p2)
		local puk = unit.AsAI
        p2 = p2 or Player        
        p2 = p2.Position or p2
        local V = puk.Position - p2
        local D = puk.Direction
        local Angle = 180 - deg(acos(V*D/(V:Len()*D:Len())))
        if abs(Angle) < 80 then 
            return true  
        end        
    end
--------------------------------------
---------------------------- Activator
--------------------------------------

--------------- ItemsActivator
function ItemsActivator:Init()
	ItemsActivator:Menu()
end

function ItemsActivator:Menu()
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

function ItemsActivator:OnTick()	
	local target = Orbwalker.GetTarget()
	if self.BotRK_MenuMode_On_Off.Value and target then
		local dist = Player.Position:Distance(target.Position)	
		for i=SpellSlots.Item1, SpellSlots.Item6 do
			local _item = Player:GetSpell(i)
			if _item ~= nil and _item then
				if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" then
							if sReady(i) then
								if ( Orbwalker.GetMode() == "Combo" and self.BotRK_MenuMode_Combo.Value ) or ( Orbwalker.GetMode() == "Harass" and self.BotRK_MenuMode_Harass.Value) then
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
	
--------------- Potion
function Potions:Init()
	self.PotionNamesBuff = {"RegenerationPotion", "ItemCrystalFlask", "ItemDarkCrystalFlask",}
	Potions:Menu()
	
end

function Potions:Menu()
		self.Potion_Menu = A_Menu:AddMenu("Potion_Menu","[Potions]:")
		 self.Potion_Label1 = self.Potion_Menu:AddLabel("Potion_Label1",":[Potions]")
				self.Potion_HP_On_Off = self.Potion_Menu:AddBool("Potion_HP_On_Off", "Auto_Potion On/Off", false)
				self.Potion_HP_setting = self.Potion_Menu:AddSlider("Potion_HP_setting", "Auto_Potion %HP",0,100,1,20)

end

function Potions:OnTick()
if not self.Potion_HP_On_Off.Value then return end
	for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
			-- Auto Potion
			if _item.Name == "RegenerationPotion" or _item.Name == "ItemCrystalFlask" or _item.Name == "ItemDarkCrystalFlask" then
				if sReady(i) then
						local Drink = self:CanDrink()

					if Player.Health <= (Player.MaxHealth*self.Potion_HP_setting.Value/100) and Drink then
						Cast(i)
					end

				end
			end
		end
	end
end

function Potions:CanDrink()
	for i, buffName in ipairs(self.PotionNamesBuff) do
		if Player:GetBuff(buffName) then
			return false
		end
	end		
	return true	
end

--------------- Summoners
function Summoners:Init()
	self.IgniteDMG = ((50+(20 * Player.Level))*0.8)

	

 Summoners:Menu()
	self._ignite = false
	self._barier = false
	self._heal = false
	self._not_suppor = false
end

function Summoners:GetSumms()
			for s=_sum1,_sum2 do
				local sum = Player:GetSpell(s)
				if sum.Name == "SummonerDot" then self._ignite = true end
				if sum.Name == "SummonerBarrier" then self._barier = true end
				if sum.Name == "SummonerHeal" then self._heal = true end
			
			end
end

function Summoners:GetSlot(SummName)
    for slot = _sum1,_sum2, 1 do
      if Player:GetSpell(slot).Name and (string.find(string.lower(Player:GetSpell(slot).Name), SummName)) then
        return slot
      end
    end
    return nil
end

function Summoners:Menu()
	self:GetSumms()
		self.Summoners_Menu = A_Menu:AddMenu("Summoners_Menu","[Summoners_Spell]:")
		 self.Summoners_Label1 = self.Summoners_Menu:AddLabel("Summoners_Label1",":[Summoners_Spell]")
		 
	if self._ignite == true then	 
				self.Ignite_Menu = self.Summoners_Menu:AddMenu("Ignite_Menu","[Ignite]:")
				 self.Ignite_Label = self.Ignite_Menu:AddLabel("Ignite_Label",":[Ignite]")
					self.Ignite_Let_Them_Burn = self.Ignite_Menu:AddBool("Ignite_Let_Them_Burn", "LetThemBurn", true)
	end			 
	if self._barier == true then				
				self.Barrier_Menu = self.Summoners_Menu:AddMenu("Barrier_Menu","[Barrier]:")
				 self.Barrier_Label = self.Barrier_Menu:AddLabel("Barrier_Label",":[Barrier]")
					self.Use_barier = self.Barrier_Menu:AddBool("Use_barier", "Auto_Barier On/Off", true)
					self.Use_Hp_Info =  self.Barrier_Menu:AddSlider("Use_Hp_Info", "Auto_Barier %HP",0,100,1,8)
	end	
	if self._heal == true then				
				self.Heal_Menu = self.Summoners_Menu:AddMenu("Heal_Menu","[Heal]:")
				 self.Heal_Label = self.Heal_Menu:AddLabel("Heal_Label",":[Heal]")
					self.Save_Your_Self = self.Heal_Menu:AddBool("Save_Your_Self", "SaveYourSelf", true)
					self.Save_Ally =  self.Heal_Menu:AddBool("Save_Ally", "Save_Ally", true)
					self.Save_HP_Info =  self.Heal_Menu:AddSlider("Save_HP_Info", "Auto_Heal %HP",0,100,1,80)
					
	end	

end

---Ignite
function Summoners:Ignite()
---Ignite

		for _,obj in pairs(enemies) do 
			if obj and not obj.IsDead then
			local hero = obj.AsHero
			local dist = Player.Position:Distance(hero.Position)
			
			if dist < 600 and sReady(self:GetSlot("summonerdot")) and hero.Health <= self.IgniteDMG then
				
					Cast(self:GetSlot("summonerdot"), hero)
				end
			end
		end
	
end

---Heal
function Summoners:Heal()

		for _,ally in pairs(allayys) do
			if ally and not ally.IsDead and self:GetSlot("summonerheal") and sReady(self:GetSlot("summonerheal")) then
			local hero = ally.AsHero
			local alPos = Player.Position:Distance(hero.Position)
				if hero.IsAlly and not hero.IsMe and self.Save_Ally.Value and hero.Health <= hero.MaxHealth*self.Save_HP_Info.Value/100 and alPos <= 850 then 
					Cast(self:GetSlot("summonerheal"))
				end
				if hero.IsMe and self.Save_Your_Self.Value and Player.Health <= Player.MaxHealth*self.Save_HP_Info.Value/100 then 
					Cast(self:GetSlot("summonerheal"))
				end
			end
		end

end

---Barier
function Summoners:Barrier()
		if self.Use_barier.Value and Player.Health <= Player.MaxHealth*self.Use_Hp_Info.Value/100 and self:GetSlot("summonerbarrier") and sReady(self:GetSlot("summonerbarrier")) then 
			Cast(self:GetSlot("summonerbarrier"))
		end
end	

function Summoners:OnTick()
	if self._ignite == true then
		self:Ignite()
	end
	if self._heal == true then	
		self:Heal()
	end
	if self._barier == true then
		self:Barrier()
	end
end

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
		elseif not c.IsDead and not c.IsVisible  then -- Trinket.Name ~= 'OracleLens' and Trinket.Name ~= 'EyeOftheHerald'

				local time=self.lasttime[c] --last seen time
				local pos=self.lastpos[c]   --last seen pos
				local clock=os.clock()
				if time and pos and clock-time<self.Bush_Time.Value and clock>self.next_wardtime and Player.Position:DistanceSqr(pos)<900*900 then
					local FoundBush = self:FindBush(pos.x,pos.y,pos.z,100)
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
---FindBush
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
	if obj.AsHero and self.FlashTracerk_On_Off.Value and not obj.IsMe then 
	self.caster=obj
	local z = spell.Name
	local rt = spell.EndPos
	local et = spell.StartPos
	if z == "SummonerFlash" then
	self.EndPos = rt 
	self.StartPos = et
	delay(2500, function()
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
-- ////////////////// Caitlyn

function Caitlyn:Init()
self.spellQ = {Range=1300, Radius=60, Speed=2200, Delay=0.625, Type="Linear"}
self.spellW = {Range=800, Radius=60, Speed=1450, Delay=0.3, Type="Circular"}
-- self.spellE = {Range=750, Radius=70, Speed=2500, Delay=0.4, Type="Linear"}
self.spellE = {Range=750, Radius=70, Speed=1600, Delay=0.25, Type="Linear"}

self.Qdmg_raw = (10+40*Player:GetSpell(_Q).Level)+((1.20+0.10*Player:GetSpell(_Q).Level)*Player.TotalAD)
self.Edmg_raw = 30+40*Player:GetSpell(_Q).Level+0.8*Player.TotalAP
self.Rdmg_raw = (75+225*Player:GetSpell(_Q).Level)+2*Player.BonusAD

self.HeadShot_ = {'caitlynyordletrapdebuff', 'caitlynyordletrapinternal'}
self.SNIPE = false
Caitlyn:Menu()
end

function Caitlyn:Menu()
	self.Caitlyn_Menu = Champion_Menu:AddMenu("Caitlyn_Menu","[Caitlyn]:")
	 self.Caitlyn_Menu_Label = self.Caitlyn_Menu:AddLabel("Caitlyn_Menu_Label",":[Caitlyn]")

		 self.Auto_Menu = self.Caitlyn_Menu:AddMenu("Auto_Menu","[Auto_Cast]:")
			 self.Auto_Label = self.Auto_Menu:AddLabel("Combo_Label",":[Auto_Cast]")
			 
					self.Auto_Q = self.Auto_Menu:AddBool("Auto_Q","Use Q [Piltover Peacemaker]", false)
					self.Auto_W = self.Auto_Menu:AddBool("Auto_W","Use W [Yordle Snap Trap]", false)
					-- self.Auto_Q_Mode = self.Auto_Menu:AddDropDown("Auto_Q_Mode","Cast Mode: Q",{'Standard','Immobile'}) 
					-- self.Auto_W_Mode = self.Auto_Menu:AddDropDown("Auto_W_Mode","Cast Mode: W",{'Standard','Immobile'}) 
					self.Auto_Mana_Settings = self.Auto_Menu:AddSlider("Auto_Mana_Settings","Mana-Manage",0,100,5,40)

		self.Combo_Menu = self.Caitlyn_Menu:AddMenu("Combo_Menu","[Combo]:")
		 self.Combo_Label = self.Combo_Menu:AddLabel("Combo_Label",":[Combo]")
		 
				self.Combo_Q = self.Combo_Menu:AddBool("Combo_Q","Use Q [Piltover Peacemaker]", true)
				self.Combo_W = self.Combo_Menu:AddBool("Combo_W","Use W [Yordle Snap Trap]", true)	
				self.Combo_E = self.Combo_Menu:AddBool("Combo_E","Use E [90 Caliber Net]", true)

		self.KillSecure_Menu = self.Caitlyn_Menu:AddMenu("KillSecure_Menu","[KillSecure]:")
		 self.KillSecure_Label = self.KillSecure_Menu:AddLabel("KillSecure_Label",":[KillSecure]")
		 
				self.KS_Q = self.KillSecure_Menu:AddBool("KS_Q","Use Q [Piltover Peacemaker]", true)

				self.KS_R_Auto = self.KillSecure_Menu:AddBool("KS_R_Auto","Auto R !CARE!", true)
				
		self.AnitGapClose_Manu = self.Caitlyn_Menu:AddMenu("AnitGapClose_Manu","[AntiGapcloser]:")
		 self.AnitGapClose_Label = self.AnitGapClose_Manu:AddLabel("AnitGapClose_Label",":[AntiGapcloser]")
		 
				self.GapClose_W = self.AnitGapClose_Manu:AddBool("GapClose_W","Use W [Yordle Snap Trap]", true)	
				self.GapClose_E = self.AnitGapClose_Manu:AddBool("GapClose_E","Use E [90 Caliber Net]", true)
				self.GapClose_W_Dis = self.AnitGapClose_Manu:AddSlider("GapClose_W_Dis","Distance: W",25,500,25,350)
				self.GapClose_E_Dis = self.AnitGapClose_Manu:AddSlider("GapClose_E_Dis","Distance: E",25,500,25,350)
				

		self.HitChance_Menu = self.Caitlyn_Menu:AddMenu("HitChance_Menu","[HitChance]:")
		 self.HitChance_Label = self.HitChance_Menu:AddLabel("HitChance_Label",":[HitChance]")
		 
				self.HitChance_ = self.HitChance_Menu:AddSlider("HitChance_","HitChance:",0.05,1,0.05,0.75)



end

-------- GetSpellPred
function Caitlyn:GetPred(target, spell, chance)

local chancePre = chance or self.HitChance_.Value
local PredQ = nil
local PredW = nil
local PredE = nil

---Q
	if spell == '_Q' then
		local PredQ = Pred.GetPredictedPosition(target, self.spellQ, Player.Position)
		if PredQ and PredQ.HitChance >= chancePre then
			PredQ = PredQ.CastPosition
		else
			PredQ = nil
		end
				return PredQ
	end
---W
	if spell == '_W' then
		local PredW = Pred.GetPredictedPosition(target, self.spellW, Player.Position)
		if PredW and PredW.HitChance >= chancePre then
			PredW = PredW.CastPosition
		else
			PredW = nil
		end
				return PredW
	end	
---E
	if spell == '_E' then
		local PredE = Pred.GetPredictedPosition(target, self.spellE, Player.Position)
		if PredE and PredE.HitChance >= chancePre then
			PredE = PredE.CastPosition
		else
			PredE = nil
		end
				return PredE
	end	
end
-------- Combo
function Caitlyn:Combo(target)
local dis = Player.Position:Distance(target.Position)
		local ORBMOD = Orbwalker.GetMode()
		if ORBMOD == "Combo" and self.Combo_Q.Value and dis < 1300 and sReady(_Q) then

			local castPosQ = self:GetPred(target, '_Q')
			if castPosQ then 
				Cast(_Q, castPosQ)
			end
		end
		if ORBMOD == "Combo" and self.Combo_W.Value and dis < 800 and sReady(_W) then

			local castPosW = self:GetPred(target, '_W')
			if castPosW then 
				Cast(_W, castPosW)
			end
		end
		if ORBMOD == "Combo" and self.Combo_E.Value and dis < 750 and sReady(_E) then

			local castPosE = self:GetPred(target, '_E')
			if castPosE then 
				Cast(_E, castPosE)
			end
		end
end
-------- AutoHead / Immobile
function Caitlyn:OnBuffGain(obj, buff)
	for handle, obj in pairs(enemies) do        
	 local hero = obj.AsHero   
	 local dis = Orbwalker.GetTrueAutoAttackRange(Player, hero)
	 local disSpell = Player.Position:Distance(hero.Position)
--- AutoHead
		if not hero or hero.IsDead then return end
			if buff.Name == self.HeadShot_ and dis < 1300 then
				Atack(hero)
			end
--- Immobile		
		if hero.IsTargetable and not hero.CanMove and  Player.Mana > (self.Auto_Mana_Settings.Value/100)*Player.MaxMana then
			--Q
			if self.Auto_Q.Value and sReady(_Q) then 
				Cast(_Q, hero.Position)
			end
			--W
			if self.Auto_W.Value and sReady(_W) then
				Cast(_W, hero.Position)
			end
		end
	end
end

-------- AutoKillSecure
function Caitlyn:KillSecure()

	for handle, obj in pairs(enemies) do        
	 local hero = obj.AsHero	
	 local dis = Player.Position:Distance(hero)
	 local castPosQ = self:GetPred(hero, '_Q') 
		if hero or not hero.IsAlive and  sReady(_Q) then 
			if self.KS_Q.Value and  dis <= 1300 and DamageLib.CalculatePhysicalDamage(Player, hero, self.Qdmg_raw) > hero.Health then
				Cast(_Q, castPosQ)
			end
			end
		if hero and hero.IsAlive and  sReady(_R) then 
			if dis <= 3500 and DamageLib.CalculatePhysicalDamage(Player, hero, self.Rdmg_raw) > hero.Health then

				local enyinrange = GetEnemisInRange(Player.Position, 500, 1000, 400, 5, "enemy")
					if #enyinrange.Objects <= 1 and self.KS_R_Auto.Value then
						Cast(_R, hero)
						end
			end
		end
	end
end


-------- GapClose
function Caitlyn:GapClose()

	for i,obj in pairs(enemies) do
	local hero = obj.AsHero
	if hero and hero.IsAlive then 
	  local dis = Player.Position:Distance(hero.Position)
--- Gap Close E
		if sReady(_E) then
		local posE = self:GetPred(hero, '_E')
			if  dis < self.GapClose_E_Dis.Value then
				Cast(_E, posE)
			end
		end
--- Gap Close W
		if sReady(_W) then
		local posW = self:GetPred(hero, '_W')
			if dis < self.GapClose_W_Dis.Value then
				Cast(_W, posW)
			end
		end
	end
end
end
-------- OnProcessSpell Dash
function Caitlyn:OnProcessSpell(obj, spell)
if not obj and not spell then return end
if obj.IsAlive and obj.IsDashing and obj.IsEnemy and obj.AsHero and Player.Mana > (self.Auto_Mana_Settings.Value/100)*Player.MaxMana then 
local castPosQ = self:GetPred(target, '_Q', 1)
local castPosW = self:GetPred(target, '_W', 1)
-- Auto Q
	if self.Auto_Q.Value and sReady(_Q) then
		Cast(_Q, castPosQ)
	end
-- Auto W
	if self.Auto_W.Value and sReady(_W) then
		Cast(_W, castPosW)
	end
end
end

-------- Tick
function Caitlyn:OnTick()
	local target = TS:GetTarget(1500, true)
		if target then
			self:Combo(target)

		end
		self:GapClose()
		self:KillSecure()
end

-- \\\\\\\\\\\\\\\\\\ Caitlyn
-- ////////////////// Vayne

function Vayne:Init()
self.Mode = Orbwalker.GetMode()
self.Qdmg_raw = (0.55 + 0.05 * Player:GetSpell(_Q).Level) * Player.TotalAD
self.Wdmg_persentage = 0.015 + 0.025 * Player:GetSpell(_Q).Level
self.SilverBulet = {'VayneSilveredDebuff'}
Vayne:Menu()
end

function Vayne:Menu()
	self.Vayne_Menu = Champion_Menu:AddMenu("Vayne_Menu","[Vayne]:")
	 self.Vayne_Label = self.Vayne_Menu:AddLabel("Vayne_Label",":[Vayne]")
end

-- \\\\\\\\\\\\\\\\\\ Vayne
--------------------------------------
--------------------------------- Load
--------------------------------------
function OnTick()
	for i, class in ipairs(H1_Classes.classes) do
		class:OnTick()
	end
end

function OnDraw()
	for i, class in ipairs(H1_Classes.classes) do
		class:OnDraw()
	end
end

function OnProcessSpell(obj, spell)
	for i, class in ipairs(H1_Classes.classes) do
		class:OnProcessSpell(obj, spell)
	end
end

function OnPostAttack()
	for i, class in ipairs(H1_Classes.classes) do
		class:OnPostAttack()
	end
end

function OnBuffGain(obj, buff)
	for i, class in ipairs(H1_Classes.classes) do
		class:OnBuffGain(obj, buff)
	end
end

--------------- OnLoad
function OnLoad()
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
 	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
	EventManager.RegisterCallback(Enums.Events.OnPostAttack, OnPostAttack)
	EventManager.RegisterCallback(Enums.Events.OnBuffGain, OnBuffGain)
	
	for i, class in ipairs(H1_Classes.classes) do
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
Game.PrintChat('    <font color="#FFD700">MarksManShip_AiO</font> <font color="#ffffff">Loaded.</font>')
Game.PrintChat('    <font color="#b4b4b4">AiO_Version:</font> <font color="#ffffff">  ' .. string.format("%.1f", myname_aio) .. '</font>')
Game.PrintChat('    <font color="#b4b4b4">AiO_Activator:</font> <font color="#ffffff">Loaded.</font>')
Game.PrintChat('    <font color="#b4b4b4">AiO_Utility:</font> <font color="#ffffff">Loaded.</font>')
if Supp() then
Game.PrintChat('    <font color="#b4b4b4">AiO_Champion:</font> <font color="#48e32d">  ' .. Player.CharName..'_Supported</font>')
else
Game.PrintChat('    <font color="#b4b4b4">AiO_Champion:</font> <font color="#FF0000">  '..Player.CharName..'_Not_Supported</font>')
end
Game.PrintChat('__________________________')
	return true
end	
	