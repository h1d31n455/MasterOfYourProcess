--[[



·▄▄▄▄  ▪   ▄▄· ▄ •▄  ▌ ▐· ▄▄▄·  ▄· ▄▌ ▐ ▄ ▄▄▄ .
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪▪█·█▌▐█ ▀█ ▐█▪██▌•█▌▐█▀▄.▀·
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·▐█▐█•▄█▀▀█ ▐█▌▐█▪▐█▐▐▌▐▀▀▪▄
██. ██ ▐█▌▐███▌▐█.█▌ ███ ▐█ ▪▐▌ ▐█▀·.██▐█▌▐█▄▄▌
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀. ▀   ▀  ▀   ▀ • ▀▀ █▪ ▀▀▀ 
by h1d31n455
Version 1.1b

]]--
------------------------
-------- REQUIEREMENTS
------------------------
require("common.log")
module("DickVayne", package.seeall, log.setup)

local Orb = require("lol/Modules/Common/OGOrbWalker")
local ts = require("lol/Modules/Common/OGsimpleTS")
local UIMenu = require("lol/Modules/Common/Menu")
------------------------
-------- API
------------------------
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
------------------------
-------- Spells
------------------------
local _Q = SpellSlots.Q
local _W = SpellSlots.W
local _E = SpellSlots.E
local _R = SpellSlots.R

local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
local enemies = ObjManager.Get("enemy", "heroes")



--------------------------------
-------- Spell Table
--------------------------------
 
isAGapcloserUnitTarget = {
        ['AkaliR']					= {true, Champ = 'Akali', 		spellKey = 'R'},
        ['Headbutt']     			= {true, Champ = 'Alistar', 	spellKey = 'W'},
        ['DianaTeleport']       	= {true, Champ = 'Diana', 		spellKey = 'R'},
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

local dvmenu = UIMenu:AddMenu("DickVayne")
---Condemn
	local Emenu = dvmenu:AddMenu("[Condemn]:")
		local Emenu12 = Emenu:AddLabel("[Condemn]:")
		local Emenustu = Emenu:AddMenu("AutoStun Settings")
				local Emenuof = Emenustu:AddLabel("AutoStun Settings")
				local Emenuof = Emenustu:AddBool("TryStun?", true)
				local Edis = Emenustu:AddSlider("PushDistance",350,450,10,400)
				-- local Etower = Emenu:AddLabel("Unter a Tower", false) WIP
				
		local Emenuint = Emenu:AddMenu("Interrupt Settings")
				local Einter0 = Emenuint:AddLabel("Interrupt Settings")
				local Einter = Emenuint:AddBool("Interrupt?", true)
				
		local EmenuGap = Emenu:AddMenu("Unti-GapClose Settings")
				local Egap0 = EmenuGap:AddLabel("Unti-GapClose Settings")
				local Egap = EmenuGap:AddDropDown("DontTuchME",{"AllDisSetX", "SelectedSpellsWIP", "off"})
				local Egapdis = EmenuGap:AddSlider("x",0,550,10,200)

---Tumble	
	local Qmenu = dvmenu:AddMenu("[Tumble]:")
	
		local Qmmod = Qmenu:AddLabel("[Tumble]:")
		local Qmmod = Qmenu:AddMenu("Mode Selector")
				local Qmmodinfo = Qmmod:AddLabel("Mode Selector")
				local Qmmodinfo = Qmmod:AddLabel("When to use Q")
				local Qmcom = Qmmod:AddBool("FightMode", true)
				local Qmhara = Qmmod:AddBool("HarassMode", false)
				
		local Qksmod = Qmenu:AddMenu("Kill Secure Settings")
				local QKSinfo0 = Qksmod:AddLabel("Kill Secure Settings")
				local QKSonoff = Qksmod:AddBool("Kill Secure", true)
				local QKSet = Qksmod:AddDropDown("Save Q",{"TurnOff", "SaveBelowTargetHP"})
				local QKShp = Qksmod:AddSlider("%hp",0,100,1,20)
				local QKSinfo99 = Qksmod:AddLabel("info: just dont set ")
				local QKSinfo98 = Qksmod:AddLabel("killsecure to off and ")
				local QKSinfo97 = Qksmod:AddLabel("Save Q to SaveBelowTarget")
				local QKSinfo96 = Qksmod:AddLabel("    #care")
				
		local Qmmp = Qmenu:AddMenu("MP Settings")
				local Qmmpinfo10 = Qmmp:AddLabel("MP Settings")
				local Qmmpinfo1 = Qmmp:AddLabel("MinMP to use Q in FightMode")
				local Qmpcom = Qmmp:AddSlider("%MP",0,100,1,0)
				local Qmmpinfo2 = Qmmp:AddLabel("MinMP to use Q in HarassMode")
				local Qmphara = Qmmp:AddSlider("%MP",0,100,1,50)
---BotRK
	local RKmenu = dvmenu:AddMenu("[BotRK]:")
	
		local RKmmod0 = RKmenu:AddLabel("[BotRK]:")
		local RKmmod = RKmenu:AddMenu("Mode Selector")
				local RKmmodinfo0 = RKmmod:AddLabel("Mode Selector")
				local RKmmodinfo = RKmmod:AddLabel("When to use BotRK")
				local RKonoff = RKmmod:AddBool("on/off", true)
				local RKmcom = RKmmod:AddBool("FightMode", true)
				local RKmhara = RKmmod:AddBool("HarassMode", false)
				
		local RKmhp = RKmenu:AddMenu("HP Settings")
				local RKinfo0 = RKmhp:AddLabel("HP Settings")
				local RKinfo = RKmhp:AddLabel("Setting to us BotRK")
				local RKphp = RKmhp:AddSlider("Max Own HP",0,100,1,50)
				local RKehp = RKmhp:AddSlider("Min Enamy HP",0,100,1,20)
---Target Selector			
local TSmenu = dvmenu:AddMenu("[Target Selector]:")
local TSset = TSmenu:AddLabel("nothing here leave")
local TSset = TSmenu:AddDropDown("WIP",{"WIP","told you","to leave","why ppl","never","listen","to me","fuck you!"})
-- local TSset = TSmenu:AddDropDown("WIP",{"LowestHealth","LowestMaxHealth","LowestArmor","Closest","CloseToMouse","MostAD","MostAP"})

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
function getWdmg(obj)
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
		
			
			


	if Qmcom.Value or Qmhara.Value then
			if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
			local enemies = ObjManager.Get("enemy", "heroes")
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
	
-------------- dont save Q
		if QKSet.Value == "TurnOff" then
			if DickVayne.Mode.Combo and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) then 
					Tumble()
				end
			if DickVayne.Mode.Harras and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) then 
					Tumble()
				end
			
		end
-------------- save Q
		if QKSet.Value == "SaveBelowTargetHP" then
				if DickVayne.Mode.Combo and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) and (hero.Health) > (hero.MaxHealth) * (QKShp.Value/100) then 
						Tumble()
				end
				if DickVayne.Mode.Harras and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) and (hero.Health) > (hero.MaxHealth) * (QKShp.Value/100) then 
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
function Condemn()
if Emenuof.Value then
local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
local enemies = ObjManager.Get("enemy", "heroes")

	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
			
	for handle, obj in pairs(enemies) do  
		local hero = obj.AsHero   
		
		if hero and hero.IsTargetable and myPos:Distance(hero.Position) <= 630 and myPos:Distance(hero.Position) > 0 then
			local PushDistance = Edis.Value
				if hero.IsMoving then	
					local ezPredict = hero:FastPrediction(450)
					local PushPositionM = ezPredict + (ezPredict - Player.Position):Normalized()*(PushDistance)
					local WallPointM = Vector.IsWall(PushPositionM) 
					
						if WallPointM then
							Input.Cast(SpellSlots.E, hero)
						end	

						
				else
				
					local PushPosition = hero.Position + (hero.Position - Player.Position):Normalized()*(PushDistance)
					local WallPoint = Vector.IsWall(PushPosition) 
					
						if WallPoint then
							Input.Cast(SpellSlots.E, hero)
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
if Einter.Value then
	local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
	local enemies = ObjManager.Get("enemy", "heroes")


	if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
		for handle, obj in pairs(enemies) do        
			local hero = obj.AsHero        
			if hero and hero.IsTargetable then
				local dist = myPos:Distance(hero.Position)	
				
				if dist <= 550 and hero.IsChanneling then
					Input.Cast(SpellSlots.E, hero) 
				elseif dist > 630 and hero.IsChanneling and dist < 750 and Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
					Tumble()
					Input.Cast(SpellSlots.E, hero)
				end

			end
		end
end
end
--------------------------------
-------- GapCloser
--------------------------------
function OnProcessSpell(Source, spell)
if Egap.Value == "SelectedSpellsWIP" then

	if Source.IsEnemy then 
		local dist = Player.Position:Distance(Source.Position)    
			if dist <= 800 then
			
				if isAGapcloserUnitTarget[spell.Name] then
					Input.Cast(SpellSlots.E, Source)
				end
				
			end
		
			if dist <= isAGapcloserUnitTarget[range] then
				if isAGapcloserUnitNoTarget[spell.Name] then
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
	end
	
	AutoQ()
	AutoE()
	AutoEchane()
	Condemn()
	
end

	


--------------------------------
-------- OnLoad
--------------------------------
function OnLoad() 
	if Player.CharName ~= "Vayne" then return false end 
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)

	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
Orb.Initialize()
	local Key = DickVayne.Setting.Key
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = false end end)	
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = false end end)	
	Game.PrintChat("----DickVayne Loaded ! ")
	Game.PrintChat("----DickVayne:GL&HF")
	return true
end			

