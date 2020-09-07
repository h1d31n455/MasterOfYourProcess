--[[



·▄▄▄▄  ▪   ▄▄· ▄ •▄  ▌ ▐· ▄▄▄·  ▄· ▄▌ ▐ ▄ ▄▄▄ .
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪▪█·█▌▐█ ▀█ ▐█▪██▌•█▌▐█▀▄.▀·
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·▐█▐█•▄█▀▀█ ▐█▌▐█▪▐█▐▐▌▐▀▀▪▄
██. ██ ▐█▌▐███▌▐█.█▌ ███ ▐█ ▪▐▌ ▐█▀·.██▐█▌▐█▄▄▌
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀. ▀   ▀  ▀   ▀ • ▀▀ █▪ ▀▀▀ 
by h1d31n455
Version 1.3.0x


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
1.3.0x
for those who are not using HUtils

[dev:GetEnemisInRange,GetturretsisInRange,sReady,CircleCircleIntersection,IsFacing]

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
local Orb = require("lol/Modules/Common/OGOrbWalker")
local ts = require("lol/Modules/Common/OGsimpleTS")

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
local Collision = _G.Libs.CollisionLib
local FireEvent = EventManager.FireEvent
local DamageLib = _G.Libs.DamageLib
local sqrt, min, max, cos, sin, pi, huge, ceil, floor, round, random, abs, deg, asin, acos, __enemyHeroList = math.sqrt,math.min, math.max, math.cos, math.sin, math.pi, math.huge, math.ceil, math.floor, math.round, math.random, math.abs, math.deg, math.asin, math.acos, {}
local insert, remove = table.insert, table.remove
local Cast = Input.Cast
local Prediction = _G.Libs.Prediction
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
				 QmMode = Qmmod:AddDropDown("Q MODE",{"Smart", "Agressive", "Mouse"})
				
		 Qksmod = Qmenu:AddMenu("Kill Secure Settings")
				 QKSinfo0 = Qksmod:AddLabel("Kill Secure Settings")
				 QKSonoff = Qksmod:AddBool("Kill Secure", true)

				
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
				 EmenuofT = Emenustu:AddBool("WardBrokenWIP", false) ---DontHideOnBush
				 Edis = Emenustu:AddSlider("PushDistance",350,450,10,400)
				 EDRAW = Emenustu:AddMenu("Drawing")
				 Edrawonstun = EDRAW:AddDropDown("Draw Predic?",{"Drawing_OFF", "Line"})
				 Edrawonstun2 = EDRAW:AddRGBAMenu("Color",0xFF0000FF)
				
				
				--  Etower = Emenu:AddLabel("Unter a Tower", false) WIP
				
		 Emenuint = Emenu:AddMenu("Interrupt Settings")
				 Einter0 = Emenuint:AddLabel("Interrupt Settings")
				 Einter = Emenuint:AddDropDown("Interrupt",{"Sellected_spells", "DontInterrupt"})
				
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
---QSS
	QSSmenu = dvmenu:AddMenu("[QSS]:")	
		QSSmmod0 = QSSmenu:AddLabel("[QSS]:")
						 QSSmmod01 = QSSmenu:AddBool("Taunt", true)
						 QSSmmod02 = QSSmenu:AddBool("Stun", true)
						 QSSmmod03 = QSSmenu:AddBool("Silence", true)
						 QSSmmod04 = QSSmenu:AddBool("Polymorph", true)
						 QSSmmod05 = QSSmenu:AddBool("Slow", false)
						 QSSmmod06 = QSSmenu:AddBool("Snare", false)
						 QSSmmod07 = QSSmenu:AddBool("AttackSpeedSlow", false)
						 QSSmmod08 = QSSmenu:AddBool("NearSight", false)
						 QSSmmod09 = QSSmenu:AddBool("Fear", true)
						 QSSmmod10 = QSSmenu:AddBool("Charm", true)
						 QSSmmod11 = QSSmenu:AddBool("Suppression", false)
						 QSSmmod11 = QSSmenu:AddBool("Blind", true)
						 QSSmmod13 = QSSmenu:AddBool("Asleep", false)
						 QSSmmod14 = QSSmenu:AddBool("Drowsy", true) 
						 QSSmmod15 = QSSmenu:AddBool("Knockback", true) 
						 QSSmmod16 = QSSmenu:AddBool("Flee", false) 
						 QSSmmod17 = QSSmenu:AddBool("Disarm", false) 
						 QSSmmod18 = QSSmenu:AddBool("Knockup", false) 
						 QSSmmod19 = QSSmenu:AddBool("Grounded", false) 
						 QSSmmod20 = QSSmenu:AddBool("Obscured", false) 
				 
						 
---Target Selector			
		TSmenu = dvmenu:AddMenu("[Target Selector]:")
				TSset = TSmenu:AddDropDown("TARGET",{"Closest","LowestMaxHealth","LowestArmor","LowestHealth","CloseToMouse","MostAD","MostAP"})

end

--------------------------------
-------- CoreDickVayne
--------------------------------
local DickVayne = {
        Key = {
            Combo = 32, -- Spacebar
            LastHit = 88, -- X			--- WIP
            Harras = 67, -- C			
            LaneClear = 86, -- V		--- WIP
            LaneFreeze = 89, -- Y		--- WIP
            Flee = 84, -- T				--- WIP
        },
		
    Mode = {
        Combo = false,
        LaneClear = false,				--- WIP
        Harras = false,					--- WIP
        LastHit = false,				--- WIP
        LaneFreeze = false,				--- WIP
    },
	
	LastQ = 0,
	LastAA = 0,
	Target = nil,
	LastReset = Game.GetTime(),

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
			for k, obj in pairs(ObjManager.Get("enemy", "turrets")) do 
				local turrets = obj.AsAI
				local pos = turrets.Position
				
				if pos:Distance(spellRadius) < radius then
				insert(res.Positions, turrets.Position)
				res.Result = true
				insert(res.Objects, turrets)
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
function QSS(Player, buffInst)
	for i=SpellSlots.Item1, SpellSlots.Item6 do
		local _item = Player:GetSpell(i)
		if _item ~= nil and _item then
		-- Auto QSS
			if _item.Name == "QuicksilverSash" or _item.Name == "ItemMercurial" then
				if Player:GetSpellState(i) == SpellStates.Ready then
					if (buffInst.BuffType == BuffTypes.Taunt and QSSmmod01.Value) or (buffInst.BuffType == BuffTypes.Stun and QSSmmod02.Value) or (buffInst.BuffType == BuffTypes.Silence and QSSmmod03.Value) or (buffInst.BuffType == BuffTypes.Polymorph and QSSmmod04.Value) or (buffInst.BuffType == BuffTypes.Slow and QSSmmod05.Value) or (buffInst.BuffType == BuffTypes.Snare and QSSmmod06.Value) or (buffInst.BuffType == BuffTypes.AttackSpeedSlow and QSSmmod07.Value) or (buffInst.BuffType == BuffTypes.NearSight and QSSmmod08.Value) or (buffInst.BuffType == BuffTypes.Fear and QSSmmod09.Value) or (buffInst.BuffType == BuffTypes.Charm and QSSmmod10.Value) or (buffInst.BuffType == BuffTypes.Suppression  and QSSmmod11.Value) or (buffInst.BuffType == BuffTypes.Blind  and QSSmmod12.Value) or (buffInst.BuffType == BuffTypes.Asleep  and QSSmmod13.Value) or (buffInst.BuffType == BuffTypes.Drowsy  and QSSmmod14.Value) or (buffInst.BuffType == BuffTypes.Knockback  and QSSmmod15.Value) or (buffInst.BuffType == BuffTypes.Flee  and QSSmmod16.Value) or (buffInst.BuffType == BuffTypes.Disarm  and QSSmmod17.Value) or (buffInst.BuffType == BuffTypes.Knockup  and QSSmmod18.Value) or (buffInst.BuffType == BuffTypes.Grounded  and QSSmmod19.Value) or (buffInst.BuffType == BuffTypes.Obscured  and QSSmmod20.Value) then
						delay(500, Input.Cast(i))
					end
				end
				break
			end
		end
	end
end
--------BotRK
function UseItemsCombo()	
	local target = DickVayne.Target
	if RKonoff.Value and target then
		local myPos = Player.Position
		local dist = myPos:Distance(target.Position)	
		for i=SpellSlots.Item1, SpellSlots.Item6 do
			local _item = Player:GetSpell(i)
			if _item ~= nil and _item then
				if _item.Name == "ItemSwordOfFeastAndFamine" or _item.Name == "BilgewaterCutlass" then
							if Player:GetSpellState(i) == SpellStates.Ready then
								if ( DickVayne.Mode.Combo and RKmcom.Value ) or ( DickVayne.Mode.Harras and RKmhara.Value ) then
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
function ResetAA()
        if Game.GetTime() > DickVayne.LastReset + 1 and Player:GetBuff("vaynetumblebonus") then
            -- ResetAutoAttack()
            DickVayne.LastReset = Game.GetTime()
        end
    end	
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
-------- DrawTumble Logic
-- local function DrawTumbleMode()
	-- local myPos = Player.Position
				-- local ModeChaker = TumbleMode(myPos, 1800)
				-- - TeamF
				-- if ModeChaker.TeamF == true then
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'TeamF', 0xFF000000)
				-- - LaneDuo
				-- elseif ModeChaker.LaneDuo == true then
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'LaneDuo', 0xFF008000)
				-- - GankE
				-- elseif ModeChaker.GankE == true then	
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'GankEnemy', 0xFFFF0000)
				-- - GankA
				-- elseif ModeChaker.GankA == true then	
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'GankAlly', 0xFF0000FF)
				-- - Solo
				-- elseif ModeChaker.Solo == true then	
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'Solo', 0xFF008000)
				-- - twoVSone
				-- elseif ModeChaker.twoVSone == true then					
				-- Renderer.DrawText(Player.HealthBarScreenPos-Vector(-50,-10,0), Vector(100,100,0), 'twoVSone', 0xFFFF0000)
				-- end 
				

				
	-- end
-------- TumbleMode
-- function TumbleMode(pos, dis)
	-- local res = {TeamF = false, LaneDuo = false, GankE = false, Solo = false, GankA = false, twoVSone = false}
	-- local enemytumble = GetEnemisInRange(pos, dis, 200, 250, 5, "enemy")
	-- local allytumble = GetEnemisInRange(pos, dis, 200, 250, 5, "ally")
		-- if #enemytumble.Objects >= 3 and #allytumble.Objects >= 3 then
			-- res.TeamF = true
		-- elseif #enemytumble.Objects == 2 and #allytumble.Objects == 2 then
			-- res.LaneDuo = true
		-- elseif #enemytumble.Objects >= 2 and #allytumble.Objects < #enemytumble.Objects then
			-- res.GankE = true
		-- elseif #enemytumble.Objects >= 1 and #allytumble.Objects > #enemytumble.Objects then
			-- res.GankA = true	
		-- elseif #enemytumble.Objects == 1 and #allytumble.Objects == #enemytumble.Objects then
			-- res.Solo = true
		-- elseif #enemytumble.Objects == 1 and #allytumble.Objects > #enemytumble.Objects then
			-- res.twoVSone = true
		-- end
	-- return res
-- end
--------BestTumblePos
function GetBestTumblePos()
	local myPos = Player.Position
        -- local logic = TumbleMode(myPos, 1800)
        local target = DickVayne.Target
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
        local range = Player.AttackRange 
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
        local root1, root2 = CircleCircleIntersection(myPos, target.Position, Player.AttackRange, 500)
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
			-- segment = eP + (eP - pP):Normalized()*(ChecksD*i)
				if Edrawonstun.Value == "Line" then
					Renderer.DrawLine(Renderer.WorldToScreen(eP), Renderer.WorldToScreen(segment), 1.0, Edrawonstun2.Value)
				end

		end
			return Nav.IsWall(segment)
    end
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
        --   
        local heroList = GetEnemisInRange(myPos, 1200, huge, 250, 5, "enemy")
        for i=1, #heroList.Objects do --Max 5
            local enemy = heroList.Objects[i] 
            local range = enemy.AttackRange   
            if range < 500 and enemy:Distance(pos) < range then return true end      
        end        
    end	
--------TumbleCombat
local function TumbleCombat()	
	local target = DickVayne.Target
	local tPos = GetBestTumblePos() 
	if Qmcom.Value or Qmhara.Value then
		if not sReady(_Q) then return end


						if DickVayne.Mode.Combo and Qmcom.Value and (Player.Mana) > (Player.MaxMana * (Qmpcom.Value / 100)) then 
							Cast(_Q, tPos)
						end
						if DickVayne.Mode.Harras and Qmhara.Value and (Player.Mana) > (Player.MaxMana * (Qmphara.Value / 100)) then 
							Cast(_Q, tPos)
						end
	end			
end			
--------QKillSecure
local function QKS()
	if QKSonoff.Value then
		local myPos = Player.Position
		local enemies = ObjManager.Get("enemy", "heroes")
		if Player:GetSpellState(SpellSlots.Q) ~= SpellStates.Ready then return end
			for handle, obj in pairs(enemies) do        
				local hero = obj.AsHero        
				if hero and hero.IsTargetable then
						local tPos = GetAggressiveTumblePos(hero) 
					local buffCountBolts = countWStacks(hero) 
						-- if getQdmg(hero) > (hero.Health) then
						if (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())) > (hero.Health) then
							Cast(_Q, tPos)	
						end
						if buffCountBolts == 2 and (DamageLib.GetAutoAttackDamage(Player,hero)+DamageLib.CalculatePhysicalDamage(Player,hero,getQdmg())+getWdmg(hero)) > (hero.Health) then	
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
-------- Ward


--------------------------------
--------OnTick
--------------------------------
local function OnTick()	
	local target = ts:GetTarget(1200, ts.Priority[TSset.Value])
	if target then 
	DickVayne.Target = target

	end
end	
	
--------------------------------
-------- OnLoad
--------------------------------
function OnLoad() 
	
	if Player.CharName ~= "Vayne" then return false end 
	-- EventManager.RegisterCallback(Enums.Events.OnTick, AutoWardBush)
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnTick, AutoE)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnDash)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnInterruptable)
	EventManager.RegisterCallback(Enums.Events.OnTick, QKS)
	EventManager.RegisterCallback(Enums.Events.OnBuffGain, QSS)
	EventManager.RegisterCallback(Enums.Events.OnTick, UseItemsCombo)
	EventManager.RegisterCallback(Enums.Events.OnPostAttack, TumbleCombat)
	-- EventManager.RegisterCallback(Enums.Events.OnDraw, DrawTumbleMode)
	EventManager.RegisterCallback(Enums.Events.OnTick, Condemn)	

	local Key = DickVayne.Key
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Combo then DickVayne.Mode.Combo = false end end)	
    EventManager.RegisterCallback(Events.OnKeyDown, function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = true  end end)
    EventManager.RegisterCallback(Events.OnKeyUp,   function(keycode, _, _) if keycode == Key.Harras then DickVayne.Mode.Harras = false end end)	
	Game.PrintChat("----DickVayne::Loaded::GL&HF")
	Orb.Initialize()
	return true
end		