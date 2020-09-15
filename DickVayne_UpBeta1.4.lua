--[[



·▄▄▄▄  ▪   ▄▄· ▄ •▄  ▌ ▐· ▄▄▄·  ▄· ▄▌ ▐ ▄ ▄▄▄ .
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪▪█·█▌▐█ ▀█ ▐█▪██▌•█▌▐█▀▄.▀·
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·▐█▐█•▄█▀▀█ ▐█▌▐█▪▐█▐▐▌▐▀▀▪▄
██. ██ ▐█▌▐███▌▐█.█▌ ███ ▐█ ▪▐▌ ▐█▀·.██▐█▌▐█▄▄▌
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀. ▀   ▀  ▀   ▀ • ▀▀ █▪ ▀▀▀ 
by h1d31n455
Version 1.3.1


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
--mistake

1.2.3a
- --- im done IsVisible Dont work XD 
- You know I have no idea about what I'm doing so Now DickVayne should works not fucking every thing u have load too xD 
- upgrade Condemn Prediction it works better then my math before 
- drawing may be a little glitchy 

1.3.0
- Tumble Logic upgrade
	- Smart Mode
	- Agressive Mode
	- Mouse Mode
	- Save Q blow target hp deleted to make better flow on ulty
- QSS added to Working
- Change GapClose and Interrupt Logic


[dev:GetEnemisInRange,GetturretsisInRange,sReady,CircleCircleIntersection,IsFacing]

1.3.1
	- better ++ tumble logic
	- Can Use Q ?

--to do ? 
- Upgrade Condemn Prediction
- R Logic

]]--


------------------------
-------- REQUIEREMENTS
------------------------
require("common.log")
module("DickVayne", package.seeall, log.setup)

winapi = require("utils.winapi")
local col = require("lol/Modules/Common/Collision")


local UIMenu = require("lol/Modules/Common/Menu")
local DamageLib = require("lol/Modules/Common/DamageLib")

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
local Vector = _G.CoreEx.Geometry.Vector
local DistanceSqr = _G.CoreEx.Geometry.Vector.DistanceSqr
local LineDistance = _G.CoreEx.Geometry.Vector.LineDistance
local Geometry = _G.CoreEx.Geometry
local FireEvent = EventManager.FireEvent

local sqrt, min, max, cos, sin, pi, huge, ceil, floor, round, random, abs, deg, asin, acos, __enemyHeroList = math.sqrt,math.min, math.max, math.cos, math.sin, math.pi, math.huge, math.ceil, math.floor, math.round, math.random, math.abs, math.deg, math.asin, math.acos, {}

local insert, remove = table.insert, table.remove
local Cast = Input.Cast

local Pred = _G.Libs.Prediction
local HealthPred = _G.Libs.HealthPred
local DamageLib = _G.Libs.DamageLib
local Collision = _G.Libs.CollisionLib
local Orbwalker = _G.Libs.Orbwalker
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

--------------------------------
-------- Menu
--------------------------------

TS = _G.Libs.TargetSelector(Orbwalker.Menu)

-- "", 
 DVMenu = UIMenu:AddMenu("DVMenu","DickVayne")
---Tumble	
	 Qmenu = UIMenu.DVMenu:AddMenu("TumbleMneu","[Tumble]:")
		 Qmmod = UIMenu.DVMenu.TumbleMneu:AddLabel("QmmodMenu", "[Tumble]:")
		 Qmmodinfo = UIMenu.DVMenu.TumbleMneu:AddMenu("QmmodinfoMenu", "Mode Selector")		
				 Qmmodinfo = UIMenu.DVMenu.TumbleMneu.QmmodinfoMenu:AddLabel("Qmmodinfo", "Mode Selector")
				 Qmmodinfo = DVMenu.TumbleMneu.QmmodinfoMenu:AddLabel("Qmmodinfo2", "When to use Q")
				 Qmcom = UIMenu.DVMenu.TumbleMneu.QmmodinfoMenu:AddBool("Qmcom2", "FightMode", true)
				 Qmhara = UIMenu.DVMenu.TumbleMneu.QmmodinfoMenu:AddBool("Qmhara2", "HarassMode", false)
				 QmMode = UIMenu.DVMenu.TumbleMneu.QmmodinfoMenu:AddDropDown("QmMode2", "Q MODE",{"Smart", "Agressive", "Mouse"})
				 				
		 Qksmod = UIMenu.DVMenu.TumbleMneu:AddMenu("Qksmod2", "Kill Secure Settings")
				 QKSinfo0 = UIMenu.DVMenu.TumbleMneu.Qksmod2:AddLabel("QKSinfo02", "Kill Secure Settings")
				 QKSonoff = UIMenu.DVMenu.TumbleMneu.Qksmod2:AddBool("QKSonoff2", "Kill Secure", true)
				
		 Qmmp = DVMenu.TumbleMneu:AddMenu("Qmmp2", "MP Settings")
				 Qmmpinfo10 = UIMenu.DVMenu.TumbleMneu.Qmmp2:AddLabel("Qmmpinfo102", "MP Settings")
				 Qmmpinfo1 = UIMenu.DVMenu.TumbleMneu.Qmmp2:AddLabel("Qmmpinfo12", "MinMP to use Q in FightMode")
				 Qmpcom = UIMenu.DVMenu.TumbleMneu.Qmmp2:AddSlider("Qmpcom2", "%MP Fight",0,100,1,0)
				 Qmmpinfo2 = UIMenu.DVMenu.TumbleMneu.Qmmp2:AddLabel("Qmmpinfo22", "MinMP to use Q in HarassMode")
				 Qmphara = UIMenu.DVMenu.TumbleMneu.Qmmp2:AddSlider("Qmphara2", "%MP Harass",0,100,1,50)
				
---Condemn
	 Emenu = UIMenu.DVMenu:AddMenu("Emenu", "[Condemn]:")
		 Emenu12 = UIMenu.DVMenu.Emenu:AddLabel("Emenu122", "[Condemn]:")
		 Emenustu = UIMenu.DVMenu.Emenu:AddMenu("Emenustu2", "AutoStun Settings")
				 Emenuof = UIMenu.DVMenu.Emenu.Emenustu2:AddLabel("Emenuof2", "AutoStun Settings")
				 Emenuof = UIMenu.DVMenu.Emenu.Emenustu2:AddBool("Emenuof22", "TryStun?", true)

				 Edis = UIMenu.DVMenu.Emenu.Emenustu2:AddSlider("Edis2", "PushDistance",350,450,10,400)
				 EDRAW = UIMenu.DVMenu.Emenu.Emenustu2:AddMenu("EDRAW2", "Drawing")
				 Edrawonstun = UIMenu.DVMenu.Emenu.Emenustu2.EDRAW2:AddDropDown("Edrawonstun2", "Draw Predic?",{"Drawing_OFF", "Line"})
				 Edrawonstun2 = UIMenu.DVMenu.Emenu.Emenustu2.EDRAW2:AddRGBAMenu("Edrawonstun22", "Color",0xFF0000FF)
				
				
				--  Etower = Emenu:AddLabel("Unter a Tower", false) WIP
				
		 Emenuint = UIMenu.DVMenu.Emenu:AddMenu("Emenuint2", "Interrupt Settings")
				 Einter0 = UIMenu.DVMenu.Emenu.Emenuint2:AddLabel("Einter02", "Interrupt Settings")
				 Einter = UIMenu.DVMenu.Emenu.Emenuint2:AddDropDown("Einter2", "Interrupt",{"Sellected_spells", "DontInterrupt"})
				
		 EmenuGap = UIMenu.DVMenu.Emenu:AddMenu("EmenuGap2", "Unti-GapClose Settings")
				 Egap0 = UIMenu.DVMenu.Emenu.EmenuGap2:AddLabel("Egap02", "Unti-GapClose Settings")
				 Egap = UIMenu.DVMenu.Emenu.EmenuGap2:AddDropDown("Egap2", "DontTuchME",{"SelectedSpellsWIP", "AllDisSetX", "off"})
				 Egapdis = UIMenu.DVMenu.Emenu.EmenuGap2:AddSlider("Egapdis2", "x",0,550,10,200)
				
---BotRK
	 RKmenu = UIMenu.DVMenu:AddMenu("RKmenu", "[BotRK]:")
	
		 RKmmod0 = UIMenu.DVMenu.RKmenu:AddLabel("RKmmod0", "[BotRK]:")
		 RKmmod = UIMenu.DVMenu.RKmenu:AddMenu("RKmmod", "Mode Selector")
				 RKmmodinfo0 = UIMenu.DVMenu.RKmenu.RKmmod:AddLabel("RKmmodinfo02", "Mode Selector")
				 RKmmodinfo = UIMenu.DVMenu.RKmenu.RKmmod:AddLabel("RKmmodinfo2", "When to use BotRK")
				 RKonoff = UIMenu.DVMenu.RKmenu.RKmmod:AddBool("RKonoff2", "on/off", true)
				 RKmcom = UIMenu.DVMenu.RKmenu.RKmmod:AddBool("RKmcom2", "FightMode", true)
				 RKmhara = UIMenu.DVMenu.RKmenu.RKmmod:AddBool("RKmhara2", "HarassMode", false)
				
		 RKmhp = UIMenu.DVMenu.RKmenu:AddMenu("RKmhp", "HP Settings")
				 RKinfo0 = UIMenu.DVMenu.RKmenu.RKmhp:AddLabel("RKinfo02", "HP Settings")
				 RKinfo = UIMenu.DVMenu.RKmenu.RKmhp:AddLabel("RKinfo2", "Setting to us BotRK")
				 RKphp = UIMenu.DVMenu.RKmenu.RKmhp:AddSlider("RKphp2", "Max Own HP",0,100,1,50)
				 RKehp = UIMenu.DVMenu.RKmenu.RKmhp:AddSlider("RKehp2", "Min Enamy HP",0,100,1,20)		

---QSS
	-- QSSmenu = dvmenu:AddMenu("[QSS]:")	
		-- QSSmmod0 = QSSmenu:AddLabel("[QSS]:")
		-- QSSonoff = QSSmenu:AddBool("UseQSS", true)
						 -- QSSmmod01 = QSSmenu:AddBool("Taunt", true)
						 -- QSSmmod02 = QSSmenu:AddBool("Stun", true)
						 -- QSSmmod03 = QSSmenu:AddBool("Silence", true)
						 -- QSSmmod04 = QSSmenu:AddBool("Polymorph", true)
						 -- QSSmmod05 = QSSmenu:AddBool("Slow", false)
						 -- QSSmmod06 = QSSmenu:AddBool("Snare", true)
						 -- QSSmmod07 = QSSmenu:AddBool("AttackSpeedSlow", false)
						 -- QSSmmod08 = QSSmenu:AddBool("NearSight", false)
						 -- QSSmmod09 = QSSmenu:AddBool("Fear", true)
						 -- QSSmmod10 = QSSmenu:AddBool("Charm", true)
						 -- QSSmmod11 = QSSmenu:AddBool("Suppression", false)
						 -- QSSmmod12 = QSSmenu:AddBool("Blind", true)
						 -- QSSmmod13 = QSSmenu:AddBool("Asleep", false)
						 -- QSSmmod14 = QSSmenu:AddBool("Drowsy", true) 
						 -- QSSmmod15 = QSSmenu:AddBool("Knockback", false) 
						 -- QSSmmod16 = QSSmenu:AddBool("Flee", false) 
						 -- QSSmmod17 = QSSmenu:AddBool("Disarm", false) 
						 -- QSSmmod18 = QSSmenu:AddBool("Knockup", false) 
						 -- QSSmmod19 = QSSmenu:AddBool("Grounded", false) 
						 -- QSSmmod20 = QSSmenu:AddBool("Obscured", false) 				 
--------------------------------
-------- CoreDickVayne
--------------------------------
local DickVayne = {
        -- Key = {
            -- Combo = 32, -- Spacebar
            -- LastHit = 88, -- X			--- WIP
            -- Harras = 67, -- C			
            -- LaneClear = 86, -- V		--- WIP
            -- LaneFreeze = 89, -- Y		--- WIP
            -- Flee = 84, -- T				--- WIP
        -- },
		
    -- Mode = {
        -- Combo = false,
        -- LaneClear = false,				--- WIP
        -- Harras = false,					--- WIP
        -- LastHit = false,				--- WIP
        -- LaneFreeze = false,				--- WIP
    -- },
	Mode = Orbwalker.GetMode(),
	
	LastAA = 0,




}

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
local function getQdmg()
	local vayneQ = {0.6, 0.65, 0.7, 0.75, 0.8}
	local dmgQ = vayneQ[Player:GetSpell(SpellSlots.Q).Level]
	return (dmgQ * Player.TotalAD)
end
--- W DMG logic
local function getWdmg(obj)
		local VayneW = {0.04, 0.065, 0.09, 0.115, 0.14}
		local dmgW = VayneW[Player:GetSpell(SpellSlots.W).Level]
		return obj.MaxHealth * dmgW
end

--------------------------------
-------- Core 
--------------------------------
-------- Find Enemy in range
function GetEnemisInRange(startPos, radius, speed, delay, maxResults, allyOrEnemy)
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
function GetturretsisInRange(startPos, radius, speed, delay, maxResults)
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
-------- Spell_redy?
function sReady(spelltocheck)
	return Player:GetSpellState(spelltocheck) == SpellStates.Ready 
end
-------- GetQSS
-- function GetQSS()
    -- for slot = SpellSlots.Item1, SpellSlots.Item6, 1 do
      -- if Player:GetSpell(slot).Name and ((string.find(string.lower(Player:GetSpell(slot).Name), "quicksilver")) or (string.find(string.lower(Player:GetSpell(slot).Name), "mercurial"))) then
        -- return slot
      -- end
    -- end
    -- return nil
-- end

-- local function QSS(obj, buffInst)
	-- if obj.IsHero then
	-- local i = GetQSS()
	-- local c = obj.CharName
	-- local d = buffInst.Name
	-- local e = buffInst.BuffType
		-- if obj.IsMe then
			-- if not i and not sReady(i) then return end
				-- if (string.find(string.lower(d), "stun")) then 
						-- Cast(i)

				-- end
		-- end
	-- end
-- end



local function QSS(Player, buffInst)
	-- for i=SpellSlots.Item1, SpellSlots.Item6 do
		-- local _item = Player:GetSpell(i)
		-- if _item ~= nil and _item then

			-- if _item.Name == "QuicksilverSash" or _item.Name == "ItemMercurial" then
				-- if Player:GetSpellState(i) == SpellStates.Ready and QSSonoff.Value then
					-- if (buffInst.BuffType == BuffTypes.Taunt and QSSmmod01.Value) or (buffInst.BuffType == BuffTypes.Stun and QSSmmod02.Value) or (buffInst.BuffType == BuffTypes.Silence and QSSmmod03.Value) or (buffInst.BuffType == BuffTypes.Polymorph and QSSmmod04.Value) or (buffInst.BuffType == BuffTypes.Slow and QSSmmod05.Value) or (buffInst.BuffType == BuffTypes.Snare and QSSmmod06.Value) or (buffInst.BuffType == BuffTypes.AttackSpeedSlow and QSSmmod07.Value) or (buffInst.BuffType == BuffTypes.NearSight and QSSmmod08.Value) or (buffInst.BuffType == BuffTypes.Fear and QSSmmod09.Value) or (buffInst.BuffType == BuffTypes.Charm and QSSmmod10.Value) or (buffInst.BuffType == BuffTypes.Suppression  and QSSmmod11.Value) or (buffInst.BuffType == BuffTypes.Blind  and QSSmmod12.Value) or (buffInst.BuffType == BuffTypes.Asleep  and QSSmmod13.Value) or (buffInst.BuffType == BuffTypes.Drowsy  and QSSmmod14.Value) or (buffInst.BuffType == BuffTypes.Knockback  and QSSmmod15.Value) or (buffInst.BuffType == BuffTypes.Flee  and QSSmmod16.Value) or (buffInst.BuffType == BuffTypes.Disarm  and QSSmmod17.Value) or (buffInst.BuffType == BuffTypes.Knockup  and QSSmmod18.Value) or (buffInst.BuffType == BuffTypes.Grounded  and QSSmmod19.Value) or (buffInst.BuffType == BuffTypes.Obscured  and QSSmmod20.Value) then
						-- Input.Cast(i)
						-- Game.PrintChat('qqq,,,,,'..buffInst.Name)
					-- end
				-- end
				-- break
			-- end
		-- end
	-- end
end


	
--------BotRK
function UseItemsCombo()	
	local target = TS:GetTarget(850, true)
	if RKonoff.Value and target then
		local myPos = Player.Position
		local dist = myPos:Distance(target.Position)	
		for i=SpellSlots.Item1, SpellSlots.Item6 do
			local _item = Player:GetSpell(i)
			if _item ~= nil and _item then
				if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" then
							if Player:GetSpellState(i) == SpellStates.Ready then
								if ( Orbwalker.GetMode() == "Combo" and RKmcom.Value ) or ( Orbwalker.GetMode() == "Lasthit" and RKmhara.Value ) then
									if (target.Health) >= ((target.MaxHealth*(RKehp.Value / 100))) and (Player.Health) >= ((Player.MaxHealth*(RKphp.Value / 100))) then
										if dist <= _item.DisplayRange then
											Input.Cast(i, target)
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
--------ResetAA
------Q
-- local function LastQTime(Player, spell)
		-- if spell.Name == "VayneTumble" then
			-- DickVayne.CanQ = false
-- end
-- end	
-- local function LastAATime(Player,spell)
        -- if spell.IsBasicAttack then

        -- DickVayne.LastAA = winapi.getTickCount()
        -- end
		-- if winapi.getTickCount() < (DickVayne.LastAA + Player.AttackDelay) then
		-- DickVayne.CanQ = true
		-- end
-- end



	--VayneTumble.
--------CircleCircleIntersection
function CircleCircleIntersection(c1, c2, r1, r2)
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
function IsFacing(unit, p2)
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

--------------------------------
-------- Tumble
--------------------------------

--------BestTumblePos
function GetBestTumblePos(target)
	local myPos = Player.Position
        -- local logic = TumbleMode(myPos, 1800)
        local target = target or TS:GetTarget(1200, true)
        if not target then return end
			if QmMode.Value == "Smart" then
				return GetSmartTumblePos(target)
			end
			if QmMode.Value == "Agressive" then
				return GetAggressiveTumblePos(target)
			end	
			if QmMode.Value == "Mouse" then
				return GetKitingTumblePos(target)
			end
    end
--------GetSmartTumblePos						
function GetSmartTumblePos(target)
        if not sReady(_Q) then return end        
        local pP, range = Player.Position, 650^2
        local offset = pP + Vector(0, 0, 300)
		local rAngle = 360/16 * pi/180 
        --
        local result = {}          
        for i=1, 17 do 
            local pos = Vector.RotatedAroundPoint(offset, pP, rAngle * (i-1),rAngle * (i-1),rAngle * (i-1))
			local selfenemies = GetEnemisInRange(pP, 650, huge, huge, 5, "enemy")
            for j=1, #selfenemies do --Max 5
                local enemy = selfenemies[j]
                if Player.Position:DistanceSqr(enemy) <= range and CheckCondemn(enemy, pos) then
                    result[i] = pos  
                    break
                else 
                    result[i] = 1  
                end          
            end
        end 
        return GetBestPoint(result) or GetKitingTumblePos(target)    
    end	
--------GetKitingTumblePos
function GetKitingTumblePos(target)
		local mousePos = Renderer.GetMousePos()
        local hP, tP = Player.Position, target.Position       
        local posToKite  = hP:Extended(tP, -300)
        local posToMouse = hP:Extended(mousePos, 300) 
        local range = Orbwalker.GetTrueAutoAttackRange(Player, target)
        --
        if     not IsDangerousPosition(posToKite)  and tP:Distance(posToKite)  <= range then
            return posToKite 
        elseif not IsDangerousPosition(posToMouse) and tP:Distance(posToMouse) <= range then 
            return posToMouse         
        end
    end
--------GetAggressiveTumblePos
function GetAggressiveTumblePos(target)
	local mousePos = Renderer.GetMousePos()
	local myPos = Player.Position
        local root1, root2 = CircleCircleIntersection(myPos, target.Position, Orbwalker.GetTrueAutoAttackRange(Player, target), 500)
        if root1 and root2 then
            local closest = root1:Distance(mousePos) < root2:Distance(mousePos) and root1 or root2            
            return myPos:Extended(closest, 300)
        end     
    end
--------CheckCondemn		



function CheckCondemn(enemy, pos)
		local myPos = Player.Position
        local eP, pP, pD = enemy.Position, pos, Edis.Value
		local checks = 30
		local ChecksD = math.ceil(pD / checks)
		for i = 1, checks do
			segment = Vector(eP) + Vector(Vector(eP) - Vector(pP)):Normalized()*(ChecksD*i)
				if Edrawonstun.Value == "Line" then
					Renderer.DrawLine(Renderer.WorldToScreen(eP), Renderer.WorldToScreen(segment), 1.0, Edrawonstun2.Value)
				end
		end
			return Nav.IsWall(segment)
    end
	
-- function CheckCondemn(enemy, pos)

		-- local espell = {Range = 630,Radius=80,Speed=1200,Delay=0.25, Type="Linear"}
		-- local sPredict = Pred.GetPredictedPosition(enemy, espell, Player.Position)
		-- local eP = sPredict.TargetPosition
		-- local pP = pos
		-- local pD = Edis.Value
		
		-- local checks = 30
		-- local ChecksD = math.ceil(pD / checks)
		-- for i = 1, checks do
			-- segment = Vector(eP) + Vector(Vector(eP) - Vector(pP)):Normalized()*(ChecksD*i)

				-- if Edrawonstun.Value == "Line" then
					-- Renderer.DrawLine(Renderer.WorldToScreen(eP), Renderer.WorldToScreen(segment), 1.0, Edrawonstun2.Value)
				-- end

		-- end
			-- return Nav.IsWall(segment)
    -- end

--------GetBestPoint
function GetBestPoint(t)
	local myPos = Player.Position
	local mousePos = Renderer.GetMousePos()
        local dist, best = 10000, nil    
        for i=1, #t do
            local point = t[i]
            if point and point ~= 1 then
                local dist2 = point:GetDistance(mousePos)
                if dist2 <= dist and not IsDangerousPosition(point) then
                    best = point 
                    dist = dist2
                end
            end
        end
        return best
    end		
--------IsDangerousPosition
function IsDangerousPosition(pos)   
	local myPos = Player.Position  
        local turretList = GetturretsisInRange(myPos, 1200, huge, 250, 2) 
        for i=1, #turretList.Objects do --Max 2 (on nexus)
            local turret = turretList.Objects[i]
            if turret:Distance(pos) < 900 then return true end 
        end       
          
        local heroList = GetEnemisInRange(myPos, 1200, huge, 250, 5, "enemy")
        for i=1, #heroList.Objects do --Max 5
            local enemy = heroList.Objects[i] 
			
            local range = Orbwalker.GetTrueAutoAttackRange(enemy, Player)
            if range < 500 and enemy:Distance(pos) < range then return true end      
        end        
    end	
--------TumbleCombat
-- local function TumbleCombat()	
	-- local target = TS:GetTarget(850, true)
	-- local tPos = GetBestTumblePos() 
	
		-- if not sReady(_Q) then return end


						-- if Orbwalker.GetMode() == "Combo" and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) and DickVayne.CanQ then 
							-- Cast(_Q, tPos)
						-- end
						-- if Orbwalker.GetMode() == "Lasthit" and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) and DickVayne.CanQ then 
							-- Cast(_Q, tPos)
						-- end
			
-- end		
local function TumbleCombat()	
	local target = TS:GetTarget(850, true)
	local tPos = GetBestTumblePos() 
	
		if not sReady(_Q) then return end


						if Orbwalker.GetMode() == "Combo" and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) and not Orbwalker.IsWindingUp() then 
							Cast(_Q, tPos)
							Orbwalker
						end
						if Orbwalker.GetMode() == "Harass" and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) and Orbwalker.IsWindingUp() then 
							Cast(_Q, tPos)
						end
			
end			
--------QKillSecure
-- local function QKS()
	-- if QKSonoff.Value then
		-- local myPos = Player.Position
		-- local enemies = ObjManager.Get("enemy", "heroes")
		-- if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
			-- for handle, obj in pairs(enemies) do        
				-- local hero = obj.AsHero        
				-- if hero and hero.IsTargetable then
						-- local tPos = GetBestTumblePos(hero)
					-- local buffCountBolts = countWStacks(hero) 
						-- if getQdmg(hero) > (hero.Health) then
						-- if (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())) > (hero.Health)  and DickVayne.CanQ then
							-- Cast(_Q, tPos)	
						-- end
						-- if buffCountBolts == 2 and (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())+getWdmg(hero)) > (hero.Health)  and DickVayne.CanQ then	
							-- Cast(_Q, tPos)						
						-- end
				-- end		
			-- end	
	-- end 
-- end

local function QKS()
	if QKSonoff.Value then
		local myPos = Player.Position
		local enemies = ObjManager.Get("enemy", "heroes")
		if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
			for handle, obj in pairs(enemies) do        
				local hero = obj.AsHero        
				if hero and hero.IsTargetable then
						local tPos = GetBestTumblePos(hero)
					local buffCountBolts = countWStacks(hero) 

						if (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())) > HealthPred.GetHealthPrediction(hero, 100, true) and DickVayne.CanQ then
							Cast(_Q, tPos)	
						end
						if buffCountBolts == 2 and (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())+getWdmg(hero)) > HealthPred.GetHealthPrediction(hero, 100, true)  and DickVayne.CanQ then	
							Cast(_Q, tPos)						
						end
				end		
			end	
	end 
end
--------Condemn
local function Condemn()
	if Emenuof.Value then
		local myPos = Player.Position
		local enemies = ObjManager.Get("enemy", "heroes")
			if Player:GetSpellState(SpellSlots.E) ~= SpellStates.Ready then return end
				for handle, obj in pairs(enemies) do  
					local hero = obj.AsHero 
					if hero and hero.IsTargetable and myPos:Distance(hero.Position) <= 630 and myPos:Distance(hero.Position) > 0 and CheckCondemn(hero, myPos) then
						Cast(_E, hero)
					break
					end
					
				end
			
	end
end
-------- GapCloser
local function OnDash(unit, spell)  
        if not Egap.Value == "SelectedSpellsWIP" or not sReady(_E) then return end  
		local unitPosTo = unit.Pathing.EndPos
        if Player.Position:Distance(unitPosTo) < 500 and unit.IsEnemy and IsFacing(unit, Player) and (isAGapcloserUnitNoTarget[spell.Name] or isAGapcloserUnitTarget[spell.Name]) then 
            Cast(_E, unit)                   
        end
    end 
-------- OnInterruptable
local function OnInterruptable(unit, spell)
        if not Einter.Value == "Sellected_spells" or not sReady(_E) then return end         
        if unit.IsEnemy and isAChampToInterrupt[spell.Name] then 
            Cast(_E, unit)         
        end        
    end   	
-------- GapCloserToALL
local function AutoE()
	if Egap.Value == "AllDisSetX" then
		local myPos = Player.Position
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
--------OnTick
--------------------------------
local function OnTick()	

	AutoE()
	QKS()
	UseItemsCombo()
	Condemn()

	
end	

local function processpell(obj, spell)


		OnDash(obj, spell)
		OnInterruptable(obj, spell)
end
--------------------------------
-------- OnLoad
--------------------------------



function OnLoad() 

	if Player.CharName ~= "Vayne" then return false end 
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, processpell)

	EventManager.RegisterCallback(Enums.Events.OnBuffGain, QSS)
	EventManager.RegisterCallback(Enums.Events.OnPostAttack, TumbleCombat)


	Game.PrintChat("----DickVayne::Loaded::GL&HF")

	return true
end		



