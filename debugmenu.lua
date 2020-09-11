--[[



·▄▄▄▄  ▪   ▄▄· ▄ •▄  ▌ ▐· ▄▄▄·  ▄· ▄▌ ▐ ▄ ▄▄▄ .
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪▪█·█▌▐█ ▀█ ▐█▪██▌•█▌▐█▀▄.▀·
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·▐█▐█•▄█▀▀█ ▐█▌▐█▪▐█▐▐▌▐▀▀▪▄
██. ██ ▐█▌▐███▌▐█.█▌ ███ ▐█ ▪▐▌ ▐█▀·.██▐█▌▐█▄▄▌
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀. ▀   ▀  ▀   ▀ • ▀▀ █▪ ▀▀▀ 
by h1d31n455


]]--
--- api


require("common.log")
module("323 v2.0", package.seeall, log.setup)
winapi = require("utils.winapi")
require("lol/Modules/Common/Collision")
local ts = require("lol/Modules/Common/OGsimpleTS")

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
local Pred = _G.Libs.Prediction



local UIMenu = require("lol/Modules/Common/Menu")

local _Q = SpellSlots.Q
local _W = SpellSlots.W
local _E = SpellSlots.E
local _R = SpellSlots.R

local myPos, myRange = Player.Position, (Player.AttackRange + Player.BoundingRadius)
local enemies = ObjManager.Get("enemy", "heroes")
local allayys = ObjManager.Get("ally", "heroes")
local all = ObjManager.Get("all", "heroes")
local _sum1 = SpellSlots.Summoner1
local _sum2 = SpellSlots.Summoner2




---- Menu

DebugMenu = UIMenu:AddMenu("[Debug_Menu]:")
	DeSub0 = DebugMenu:AddMenu("[Cast_SpellNameNoTarget]:")
		SubOnSpeE = DeSub0:AddBool("IsEnemy", false)
		SubOnSpeA = DeSub0:AddBool("IsAlly", false)
		SubOnSpeMe = DeSub0:AddBool("IsMe", false)
	DeSub1 = DebugMenu:AddMenu("[Get_BuffName]:")
		SubMBE = DeSub1:AddBool("IsEnemy", false)
		SubMBA = DeSub1:AddBool("IsAlly", false)
		SubMBMe = DeSub1:AddBool("IsMe", false)
	DeSub2 = DebugMenu:AddMenu("[Cast_SpellName]:")
		SubMSE = DeSub2:AddBool("IsEnemy", false)
		SubMSA = DeSub2:AddBool("IsAlly", false)
		SubMSME = DeSub2:AddBool("IsMe", false)
	DeSub3 = DebugMenu:AddMenu("[SpellName]:")
		SpellNameE = DeSub3:AddMenu("[Enemy]:")
		SpellNameA = DeSub3:AddMenu("[Ally]:")
		SpellNameMe = DeSub3:AddMenu("[ME]:")
for i, obj in pairs(all) do
	local hero = obj.AsHero
		if hero.IsEnemy then
			TempMenuENameSpell = SpellNameE:AddMenu(hero.CharName)
					for s=_Q,_R do
						p = hero:GetSpell(s)
						n = p.Name		
							TempMenuSpellNameE = TempMenuENameSpell:AddLabel(n)
					end
		end	
		if hero.IsAlly and not hero.IsMe then
			TempMenuANameSpell = SpellNameA:AddMenu(hero.CharName)
					for t=_Q,_R do
						u = hero:GetSpell(t)
						y = u.Name	
				TempMenuSpellNameS = TempMenuANameSpell:AddLabel(u)
					end
		end
		if hero.IsMe then
			TempMenuMeNameSpell = SpellNameMe:AddMenu(Player.CharName)
					for m=_Q,_R do
						l = hero:GetSpell(m)
						k = l.Name	
				TempMenuSpellNameMe = TempMenuMeNameSpell:AddLabel(k)
					end
		end	
	end
-- end
	DeSub4 = DebugMenu:AddMenu("[PassivesName]:")
		PasiveNameE = DeSub4:AddMenu("[Enemy]:")
		PasiveNameA = DeSub4:AddMenu("[Ally]:")
		PasiveNameMe = DeSub4:AddMenu("[ME]:")	
for i, obj in pairs(all) do
	local hero = obj.AsHero
		if hero.IsEnemy then
			TempMenuENamePass = PasiveNameE:AddMenu(hero.CharName)

						for i = 0, hero.BuffCount do
							local buff = hero:GetBuff(i)
							if buff then
				TempMenuSPassiveNameE = TempMenuENamePass:AddLabel(buff.Name)
							end
						end
		end
		if hero.IsAlly and not hero.IsMe then
			TempMenuANamePass = PasiveNameA:AddMenu(hero.CharName)
						for irg = 0, hero.BuffCount do
							local buffirg = hero:GetBuff(iirg)
							if buffirg then
				TempMenuSPassiveNameA = TempMenuANamePass:AddLabel(buffirg.Name)
							end
						end
		end
		if hero.IsAlly and hero.IsMe then
			TempMenuMeNamePass = PasiveNameMe:AddMenu(Player.CharName)
						for ity = 0, hero.BuffCount do
							local buffity = hero:GetBuff(ity)
							if buffity then
				TempMenuSPassiveNameMe = TempMenuMeNamePass:AddLabel(buffity.Name)
							end
						end
		end	
	end

	DeSub6 = DebugMenu:AddMenu("[Positions]:")
		DePosMouse = DeSub6:AddBool("MousePos", false)
		DePosE = DeSub6:AddBool("IsEnemy", false)
		DePosA = DeSub6:AddBool("IsAlly", false)
		DePosMe = DeSub6:AddBool("IsMe", false)
		DePosF = DeSub6:AddBool("FlashTracerkOnlyEnemy", false)
	DeSub7 = DebugMenu:AddMenu("[?]:")



--- buffs
function getbuffname(obj, buffInst)
	if obj.IsHero then
	local time = Game.GetTime()
	local c = obj.CharName
	local d = buffInst.Name
	local e = buffInst.BuffType
	local f = buffInst.Count

	if obj.IsEnemy and SubMBE.Value then
Game.PrintChat('<font color="#87cd79">------------------------</font>'..time..'')
Game.PrintChat('<font color="#87cd79">_Active_Passive_Buff_For:<font color="#ff0000">'..c..'</font>')
Game.PrintChat('<font color="#87cd79">_BuffName:<font color="#ffffff">'..d..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffType:<font color="#9cfffe">'..e..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffCount:<font color="#00eaff">'..f..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')	

	end
	if obj.IsMe and SubMBMe.Value then
Game.PrintChat('<font color="#87cd79">------------------------</font>'..time..'')
Game.PrintChat('<font color="#87cd79">_Active_Passive_Buff_For:<font color="#fffc00">'..c..'</font>')
Game.PrintChat('<font color="#87cd79">_BuffName:<font color="#ffffff">'..d..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffType:<font color="#9cfffe">'..e..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffCount:<font color="#00eaff">'..f..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')	

	end
	if obj.IsAlly and not obj.IsMe and SubMBA.Value then
Game.PrintChat('<font color="#87cd79">------------------------</font>'..time..'')
Game.PrintChat('<font color="#87cd79">_Active_Passive_Buff_For:<font color="#00ff12">'..c..'</font>')
Game.PrintChat('<font color="#87cd79">_BuffName:<font color="#ffffff">'..d..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffType:<font color="#9cfffe">'..e..'</font>')
Game.PrintChat('<font color="#87cd79"> _BuffCount:<font color="#00eaff">'..f..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')
	end
end
end 
 
--- Target Spells
function OnSpellCast(obj, spell)
	if obj.AsHero and (SubMSE.Value or SubMSME.Value or SubMSA.Value) and obj and spell then
	local time = Game.GetTime()
	local a = obj.CharName
	local z = spell.Name
	local t = spell.MissileSpeed
	local rt = spell.EndPos
	local target = spell.Target.Name
	if obj.IsEnemy and SubMSE.Value then
Game.PrintChat('<font color="#87cd79">------------------------</font>'..time..'')
Game.PrintChat('<font color="#87cd79">_Spell_Casted_From:<font color="#ff0000">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_Name:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_MissileSpeed:<font color="#9cfffe">'..t..'</font>')
Game.PrintChat('<font color="#87cd79">_Target:<font color="#00eaff">'..target..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_EndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')

	end
	if obj.IsMe and SubMSME.Value then
Game.PrintChat('------------------------'..time..'')
Game.PrintChat('<font color="#87cd79">_Spell_Casted_From:<font color="#fffc00">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_Name:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_MissileSpeed:<font color="#9cfffe">'..t..'</font>')
Game.PrintChat('<font color="#87cd79">_Target:<font color="#00eaff">'..target..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_EndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')
	end
	if obj.IsAlly and not obj.IsMe and SubMSA.Value then
Game.PrintChat('------------------------'..time..'')
Game.PrintChat('<font color="#87cd79">_SpellCastedFrom:<font color="#00ff12">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_SpellName:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_MissileSpeed:<font color="#9cfffe">'..t..'</font>')
Game.PrintChat('<font color="#87cd79">_Target:<font color="#00eaff">'..target..'</font>')
Game.PrintChat('<font color="#87cd79">_SpellEndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')

	end
end

end
---------No target Spells
function OnProcessSpell(obj, spell)
	if obj.AsHero then
	local time = Game.GetTime()
	local a = obj.CharName
	local z = spell.Name
	local t = spell.AlternateName
	local rt = spell.EndPos

	
	if obj.IsEnemy and SubOnSpeE.Value then
Game.PrintChat('<font color="#87cd79">------------------------</font>'..time..'')
Game.PrintChat('<font color="#87cd79">_Spell_Casted_From:<font color="#ff0000">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_Name:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_Alternate_Name:<font color="#9cfffe">'..t..'</font>')

Game.PrintChat('<font color="#87cd79">_Spell_EndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')

	end
	if obj.IsMe and SubOnSpeMe.Value then
Game.PrintChat('------------------------'..time..'')
Game.PrintChat('<font color="#87cd79">_Spell_Casted_From:<font color="#fffc00">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_Spell_Name:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_Alternate_Name:<font color="#9cfffe">'..t..'</font>')
	
Game.PrintChat('<font color="#87cd79">_Spell_EndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')
	end
	if obj.IsAlly and not obj.IsMe and SubOnSpeA.Value then
Game.PrintChat('------------------------'..time..'')
Game.PrintChat('<font color="#87cd79">_SpellCastedFrom:<font color="#00ff12">'..a..'</font>')
Game.PrintChat('<font color="#87cd79">_SpellName:<font color="#ffffff">'..z..'</font>')
Game.PrintChat('<font color="#87cd79">_AlternateName:<font color="#9cfffe">'..t..'</font>')

Game.PrintChat('<font color="#87cd79">_SpellEndPos:<font color="#00eaff">'..rt.x..'::'..rt.y..'::'..rt.z..'</font>')
Game.PrintChat('<font color="#87cd79">------------------------</font>')

	end
end

end



local function OnDraw()
	local MyPos = Player.Position
	local MouPos = Renderer.GetMousePos()
	if DePosMe.Value then
	Renderer.DrawText(Vector.ToScreen(MyPos),Vector(100,5,0),"z:"..math.floor(MyPos.z),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(MyPos)-Vector(0,12,0),Vector(100,5,0),"y:"..math.floor(MyPos.y),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(MyPos)-Vector(0,24,0),Vector(100,5,0),"x:"..math.floor(MyPos.x),0xFFFFFFFF)
	end
	if DePosMouse.Value then
	Renderer.DrawText(Vector.ToScreen(MouPos)-Vector(0,20,0),Vector(100,5,0),"z:"..math.floor(MouPos.z),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(MouPos)-Vector(0,32,0),Vector(100,5,0),"y:"..math.floor(MouPos.y),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(MouPos)-Vector(0,44,0),Vector(100,5,0),"x:"..math.floor(MouPos.x),0xFFFFFFFF)
	end
	if DePosF.Value then
	local endpos = A.EndPos
	local stapos = A.StartPos
	Renderer.DrawLine3D(stapos, endpos, 1, 0xFFFF00FF)
	Renderer.DrawText(Vector.ToScreen(endpos),Vector(150,40,0),"!!Flashed Here!!",0xFF0000FF)
	end
	if DePosA.Value then
			for k, obj in pairs(allayys) do 
				local hero = obj.AsHero
				local posomygood = hero.Position
				if not hero.IsMe then
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,20,0),Vector(100,5,0),"z:"..math.floor(posomygood.z),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,32,0),Vector(100,5,0),"y:"..math.floor(posomygood.y),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,44,0),Vector(100,5,0),"x:"..math.floor(posomygood.x),0xFFFFFFFF)
				end
			end
	end
	if DePosE.Value then
			for k, obj in pairs(enemies) do 
				local hero = obj.AsHero
				local posomygood = hero.Position
				if not hero.IsMe then
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,20,0),Vector(100,5,0),"z:"..math.floor(posomygood.z),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,32,0),Vector(100,5,0),"y:"..math.floor(posomygood.y),0xFFFFFFFF)
	Renderer.DrawText(Vector.ToScreen(posomygood)-Vector(0,44,0),Vector(100,5,0),"x:"..math.floor(posomygood.x),0xFFFFFFFF)
				end
			end
	end
	
end
A={}
A.StartPos={}
A.EndPos={}
local function FlashTracerk(obj, spell)
	if obj.AsHero and not obj.IsMe then
	local z = spell.Name
	local t = spell.AlternateName
	local rt = spell.EndPos
	local et = spell.StartPos
	if z == "SummonerFlash" then
	A.EndPos = rt 
	A.StartPos = et
	end
end
end






function OnLoad() 
	EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, FlashTracerk)
	EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
	EventManager.RegisterCallback(Enums.Events.OnSpellCast, OnSpellCast)
	EventManager.RegisterCallback(Enums.Events.OnBuffGain, getbuffname)
	Game.PrintChat('<font color="#000000">DebugMenu</font>')
    
		return true
end			


