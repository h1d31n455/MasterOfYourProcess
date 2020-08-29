--[[



·▄▄▄▄  ▪   ▄▄· ▄ •▄  ▌ ▐· ▄▄▄·  ▄· ▄▌ ▐ ▄ ▄▄▄ .
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪▪█·█▌▐█ ▀█ ▐█▪██▌•█▌▐█▀▄.▀·
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·▐█▐█•▄█▀▀█ ▐█▌▐█▪▐█▐▐▌▐▀▀▪▄
██. ██ ▐█▌▐███▌▐█.█▌ ███ ▐█ ▪▐▌ ▐█▀·.██▐█▌▐█▄▄▌
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀. ▀   ▀  ▀   ▀ • ▀▀ █▪ ▀▀▀ 
by h1d31n455
Version 1.2.3 


Changelog :
1.1a
- make it work with xD hutilyu no no 

1.1b 
- works xD

1.2.2a
- Upgrade Condemn Logic
- add Predic Condemn Drawing
- add Ward Bush affter Condemn WIP 
- Upgrade Tumble Logic 
- Update Chanling and Interrupt for Sellected_spells :NowWorks:

[If u find any Skill you will find a way to tell me or add it your self]
[list of all skills https://github.com/h1d31n455/MasterOfYourProcess/wiki/DickVayne-Skill-list]

1.2.2c
- small update menu will be hidden when not using DickVayne
- a little change to Condemn Logic so Modules\Common\Collision.lua is needed 
( you can downloa it with Download robur - master of your process process on main page)

1.2.3 
- Upgrade Ward on Bush afret Condemn
- You know I have no idea about what I'm doing so Now DickVayne should works not fucking every thing u have load too xD 

--to do ? 
- Upgrade Condemn Prediction
- Upgrade Tumble Logic
- tidy up this script cuz its a mess

]]--
------------------------
-------- REQUIEREMENTS
------------------------
require("common.log")
module("DickVayne", package.seeall, log.setup)

winapi = require("utils.winapi")
local col = require("lol/Modules/Common/Collision")
local Orb = require("lol/Modules/Common/OGOrbWalker")
local ts = require("lol/Modules/Common/OGsimpleTS")
local UIMenu = require("lol/Modules/Common/Menu")
------------------------
-------- API
------------------------
local _SDK = _G.CoreEx
local Nav = _G.CoreEx.Nav
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
local Collision = _G.Libs.CollisionLib
local FireEvent = EventManager.FireEvent
------------------------
-------- Spells
------------------------
local _Q = SpellSlots.Q
local _W = SpellSlots.W
local _E = SpellSlots.E
local _R = SpellSlots.R





--------------------------------
-------- Spell Table
--------------------------------
 
local isAGapcloserUnitTarget = {
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

local isAGapcloserUnitNoTarget = {
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

local isAChampToInterrupt = {


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
        ['LucianR']						= {true, Champ = 'Lucian',		spellKey = 'R'}
    }

--------------------------------
-------- Combo Keys
--------------------------------
local DickVayne = {
    Setting = {
        Key = {
            Combo = 32, -- Spacebar
            LastHit = 88, -- X			--- WIP
            Harras = 67, -- C			
            LaneClear = 86, -- V		--- WIP
            LaneFreeze = 89, -- Y		--- WIP
            Flee = 84, -- T				--- WIP
        },
    },
    Mode = {
        Combo = false,
        LaneClear = false,				--- WIP
        Harras = false,					--- WIP
        LastHit = false,				--- WIP
        LaneFreeze = false,				--- WIP
    },
}
--------------------------------
-------- Menu
--------------------------------

if Player.CharName == "Vayne" then
 dvmenu = UIMenu:AddMenu("DickVayne")

---Tumble	
	 Qmenu = dvmenu:AddMenu("[Tumble]:")
	
		 Qmmod = Qmenu:AddLabel("[Tumble]:")
		 Qmmod = Qmenu:AddMenu("Mode Selector")
				 Qmmodinfo = Qmmod:AddLabel("Mode Selector")
				 Qmmodinfo = Qmmod:AddLabel("When to use Q")
				 Qmcom = Qmmod:AddBool("FightMode", true)
				 Qmhara = Qmmod:AddBool("HarassMode", false)
				
		 Qksmod = Qmenu:AddMenu("Kill Secure Settings")
				 QKSinfo0 = Qksmod:AddLabel("Kill Secure Settings")
				 QKSonoff = Qksmod:AddBool("Kill Secure", true)
				 QKSet = Qksmod:AddDropDown("Save Q",{"TurnOff", "SaveBelowTargetHP"})
				 QKShp = Qksmod:AddSlider("%hp",0,100,1,20)
				
		 Qmmp = Qmenu:AddMenu("MP Settings")
				 Qmmpinfo10 = Qmmp:AddLabel("MP Settings")
				 Qmmpinfo1 = Qmmp:AddLabel("MinMP to use Q in FightMode")
				 Qmpcom = Qmmp:AddSlider("%MP Fight",0,100,1,0)
				 Qmmpinfo2 = Qmmp:AddLabel("MinMP to use Q in HarassMode")
				 Qmphara = Qmmp:AddSlider("%MP Harass",0,100,1,50)
				
---Condemn
	 Emenu = dvmenu:AddMenu("[Condemn]:")
		 Emenu12 = Emenu:AddLabel("[Condemn]:")
		 Emenustu = Emenu:AddMenu("AutoStun Settings")
				 Emenuof = Emenustu:AddLabel("AutoStun Settings")
				 Emenuof = Emenustu:AddBool("TryStun?", true)
				 EmenuofT = Emenustu:AddBool("DontHideOnBush", false)
				 Edis = Emenustu:AddSlider("PushDistance",350,450,10,400)
				 EDRAW = Emenustu:AddMenu("Drawing")
				 Edrawonstun = EDRAW:AddDropDown("Draw Predic?",{"Drawing_OFF", "Line"})
				 Edrawonstun2 = EDRAW:AddRGBAMenu("Color",0xFF0000FF)
				
				
				--  Etower = Emenu:AddLabel("Unter a Tower", false) WIP
				
		 Emenuint = Emenu:AddMenu("Interrupt Settings")
				 Einter0 = Emenuint:AddLabel("Interrupt Settings")
				 Einter = Emenuint:AddDropDown("Interrupt",{"Allspells", "Sellected_spells", "DontInterrupt"})
				
		 EmenuGap = Emenu:AddMenu("Unti-GapClose Settings")
				 Egap0 = EmenuGap:AddLabel("Unti-GapClose Settings")
				 Egap = EmenuGap:AddDropDown("DontTuchME",{"AllDisSetX", "SelectedSpellsWIP", "off"})
				 Egapdis = EmenuGap:AddSlider("x",0,550,10,200)
				
				
---BotRK
	 RKmenu = dvmenu:AddMenu("[BotRK]:")
	
		 RKmmod0 = RKmenu:AddLabel("[BotRK]:")
		 RKmmod = RKmenu:AddMenu("Mode Selector")
				 RKmmodinfo0 = RKmmod:AddLabel("Mode Selector")
				 RKmmodinfo = RKmmod:AddLabel("When to use BotRK")
				 RKonoff = RKmmod:AddBool("on/off", true)
				 RKmcom = RKmmod:AddBool("FightMode", true)
				 RKmhara = RKmmod:AddBool("HarassMode", false)
				
		 RKmhp = RKmenu:AddMenu("HP Settings")
				 RKinfo0 = RKmhp:AddLabel("HP Settings")
				 RKinfo = RKmhp:AddLabel("Setting to us BotRK")
				 RKphp = RKmhp:AddSlider("Max Own HP",0,100,1,50)
				 RKehp = RKmhp:AddSlider("Min Enamy HP",0,100,1,20)
---Target Selector			
 TSmenu = dvmenu:AddMenu("[Target Selector]:")
 TSset = TSmenu:AddLabel("nothing here leave")
 TSset = TSmenu:AddDropDown("WIP",{"WIP","told you","to leave","why ppl","never","listen","to me","fuck you!"})
--  TSset = TSmenu:AddDropDown("WIP",{"LowestHealth","LowestMaxHealth","LowestArmor","Closest","CloseToMouse","MostAD","MostAP"})
end

--------------------------------
-------- Calculation
--------------------------------
--- SILVER BOLTS STACKS
local function countWStacks(target) 
	local ai = target.AsAI
    if ai and ai.IsValid then
		for i = 0, ai.BuffCount do
			local buff = ai:GetBuff(i)
			if buff then
				if buff.Name == "VayneSilveredDebuff" then
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
local function getQdmg(obj)
	local vayneQ = {0.6, 0.65, 0.7, 0.75, 0.8}
	local dmgQ = vayneQ[Player:GetSpell(SpellSlots.Q).Level]
	return ( (dmgQ * Player.TotalAD) + Player.TotalAD ) * (100.0 / (100 + obj.Armor ) )
end
--- W DMG logic
local function getWdmg(obj)
		local VayneW = {0.04, 0.065, 0.09, 0.115, 0.14}
		local dmgW = VayneW[Player:GetSpell(SpellSlots.W).Level]
		return obj.MaxHealth * dmgW
end
--- KS W+Qaa DMG logiv
local function getKSQWdmg(obj)
	return getQdmg(obj) + getWdmg(obj)
end
--------------------------------
-------- Tumble Logic
--------------------------------
local function Tumble()
local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
local enemies = ObjManager.Get("enemy", "heroes")



	for handle, obj in pairs(enemies) do        
		local hero = obj.AsHero        
		if hero and hero.IsTargetable then
			
			local dist = myPos:DistanceSqr(hero.Position)
			local mousepos = Renderer.GetMousePos()
			local AfterTumblePos = myPos + (mousepos - myPos):Normalized() * 300
			local DistanceAfterTumble = DistanceSqr(AfterTumblePos, hero.Position)

								if  DistanceAfterTumble < 630*630 and DistanceAfterTumble > 300*300 then 
									Input.Cast(SpellSlots.Q, mousepos)
								end
							
								if dist > 630*630 and DistanceAfterTumble < 630*630 and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) then 
									Input.Cast(SpellSlots.Q, mousepos)
								end
		end
	end
end


local function TumbleCombat()
		
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")			
			


	if Qmcom.Value or Qmhara.Value then
			if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
			local enemies = ObjManager.Get("enemy", "heroes") 
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
	


		
-------------- save Q
		if QKSet.Value == "SaveBelowTargetHP" and QKSonoff.Value then
				if DickVayne.Mode.Combo and Qmcom.Value and (Player.Mana) >= (Player.MaxMana * (Qmpcom.Value / 100)) and (hero.Health) > (hero.MaxHealth*QKShp.Value/100) then 
						Tumble()
				end
				if DickVayne.Mode.Harras and Qmhara.Value and (Player.Mana) >= (Player.MaxMana * (Qmphara.Value / 100)) and (hero.Health) >= (hero.MaxHealth*QKShp.Value/100) then 
						Tumble()
				end
-------------- dont save Q				
		else 
			if DickVayne.Mode.Combo and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) then 
					Tumble()
				end
			if DickVayne.Mode.Harras and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) then 
					Tumble()
				end
		end	
		
end
end
end
end

--------------------------------
-------- Condemn Logic
--------------------------------
local function Condemn()
if Emenuof.Value then
local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
local enemies = ObjManager.Get("enemy", "heroes")

	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
			
	for handle, obj in pairs(enemies) do  
		local hero = obj.AsHero   
		
		if hero and hero.IsTargetable and myPos:Distance(hero.Position) <= 630 and myPos:Distance(hero.Position) > 0 then
			local PushDistance = Edis.Value
			local FoundGrass = false
			local checks = 30
			local ChecksD = math.ceil(PushDistance / checks)

			local tmat = (myPos:Distance(hero.Position)+PushDistance)/2200
			local ezPredict = hero:FastPrediction(tmat)
			local myPredict = Player:FastPrediction(tmat)
				for i = 1, checks do
				local PushPositionM = Vector(ezPredict) + Vector(Vector(ezPredict) - Vector(myPredict)):Normalized()*(ChecksD*i)

				 if not FoundGrass and Nav.IsGrass(PushPositionM) then
					
					FoundGrass = PushPositionM
				end
				
				-- local WallPoint = Nav.IsWall(PushPositionM)
				local WallPoint = Collision.SearchWall(ezPredict, PushPositionM, 1, 2200, tmat)
						CastEDraw = PushPositionM
						if Edrawonstun.Value == "Line" then
						Renderer.DrawLine(Renderer.WorldToScreen(hero.Position), Renderer.WorldToScreen(CastEDraw), 1.0, Edrawonstun2.Value)
						end
						

		
						if WallPoint.Result then
						-- if WallPoint then
							
							Input.Cast(SpellSlots.E, hero)
						if FoundGrass and EmenuofT.Value and hero.IsAlive and myPos:Distance(hero.Position) <= 1000 then
								 

								local xaaa = FoundGrass

						
						
						
						
						
							EventManager.RegisterCallback(Events.OnVisionLost, function()
							if xaaa == FoundGrass then 
							Input.Cast(SpellSlots.Trinket, FoundGrass) 
							end 
							end)

						-- delay(1250, Input.Cast(SpellSlots.Trinket, FoundGrass)) end


							-- delay(500, Input.Cast(SpellSlots.Trinket, FoundGrass)) end

							
							break
							

						
						end	

						

				

					
				end
		end
	end
end
end
end


--------------------------------
-------- Kill Secure Q
--------------------------------
local function AutoQ()
if QKSonoff.Value then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")


	if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
				local buffCountBolts = countWStacks(hero) 
				
				if getQdmg(hero) > (hero.Health) then	
					Tumble()
				end
				
				if buffCountBolts == 2 and getKSQWdmg(hero) > (hero.Health) then	
					Tumble()					
				end
			end		
		end	
end 
end
--------------------------------
-------- Chanling
--------------------------------

local function AutoEchane()
if Einter.Value == "Allspells" then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")


	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
				local dist = myPos:Distance(hero.Position)	
				
				if dist <= 550 and hero.IsChanneling then
					Input.Cast(SpellSlots.E, hero) 
				elseif dist >= 630 and hero.IsChanneling and dist <= 750 and Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
					Tumble()
					Input.Cast(SpellSlots.E, hero)
				end

			end
		end
end
end

local function OnProcessSpell2(Source, spell)
if Einter.Value == "Sellected_spells" then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")

if Player:GetSpellState(SpellSlots.E) == SpellStates.Ready then
	if Source.IsEnemy then 
	
	
	
	
	local dist = myPos:Distance(Source.Position)	
		if isAChampToInterrupt[spell.Name] then
			if dist <= 550 then
					Input.Cast(SpellSlots.E, Source) 
				elseif dist >= 630 and dist <= 750 and Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
					Tumble()
					Input.Cast(SpellSlots.E, Source)
			end
		end
		
	end
end
end
end
--------------------------------
-------- GapCloser
--------------------------------
local function OnProcessSpell(Source, spell)
if Egap.Value == "SelectedSpellsWIP" then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")

	if Source.IsEnemy then 
	local dist = Player.Position:DistanceSqr(Source.Position)    
		
		if isAGapcloserUnitTarget[spell.Name] then
		if dist <= 715*715 then
			Input.Cast(SpellSlots.E, Source)
		end
		end
		
		
		if isAGapcloserUnitNoTarget[spell.Name] then
			local CastTime = winapi.getTickCount()
            local Range = isAGapcloserUnitNoTarget[spell.Name].range
            local Speed = isAGapcloserUnitNoTarget[spell.Name].projSpeed			

			    if (winapi.getTickCount() - CastTime) <= (Range/Speed) and Player:GetSpellState(SpellSlots.E) == SpellStates.Ready and dist <= 715*715 then

				Input.Cast(SpellSlots.E, Source)
		end
		end
		
	end
end
end


local function AutoE()
if Egap.Value == "AllDisSetX" then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")

	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
				local dist = myPos:Distance(hero.Position)	
				local dismenu = Egapdis.Value
				if dist <= dismenu then
					Input.Cast(SpellSlots.E, hero) 
				end
			end
		end
end
end
--------------------------------
--------BotRK
--------------------------------
local function UseItemsCombo()	
if RKonoff.Value then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")

	
					for i=SpellSlots.Item1, SpellSlots.Item6 do
						local _item = Player:GetSpell(i)
						if _item ~= nil and _item then
						
								for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
				local dist = myPos:Distance(hero.Position)	
						
							-- BOTRK + HEXTECH GUNBLADE + RANDUIN
							if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" then
								if Player:GetSpellState(i) == SpellStates.Ready then
								
										if ( DickVayne.Mode.Combo and RKmcom.Value ) or ( DickVayne.Mode.Harras and RKmhara.Value ) then
											if (hero.Health) >= ((hero.MaxHealth*(RKehp.Value / 100))) and (Player.Health) >= ((Player.MaxHealth*(RKphp.Value / 100))) then
												if dist <= _item.DisplayRange then
													Input.Cast(i, hero)
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
end
end

--------------------------------
--------OnTick
--------------------------------
local function OnTick()	

	local target = ts:GetTarget(1200, ts.Priority.LowestHealth)
	if target then 
	TumbleCombat()
	UseItemsCombo()	
	AutoQ()
	AutoE()
	AutoEchane()
	Condemn()
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell2)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
	end
	
	
	
end

	


--------------------------------
-------- OnLoad
--------------------------------
function OnLoad() 
	if Player.CharName ~= "Vayne" then return false end 
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)



	local Key = DickVayne.Setting.Key
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = false end end)	
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = false end end)	
	Game.PrintChat("----DickVayne::Loaded::GL&HF")


 
	



	return true
end			

