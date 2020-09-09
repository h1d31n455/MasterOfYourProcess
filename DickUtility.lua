--[[
·▄▄▄▄  ▪   ▄▄· ▄ •▄ ▄• ▄▌▄▄▄▄▄▪  ▄▄▌  ▪  ▄▄▄▄▄ ▄· ▄▌
██▪ ██ ██ ▐█ ▌▪█▌▄▌▪█▪██▌•██  ██ ██•  ██ •██  ▐█▪██▌
▐█· ▐█▌▐█·██ ▄▄▐▀▀▄·█▌▐█▌ ▐█.▪▐█·██▪  ▐█· ▐█.▪▐█▌▐█▪
██. ██ ▐█▌▐███▌▐█.█▌▐█▄█▌ ▐█▌·▐█▌▐█▌▐▌▐█▌ ▐█▌· ▐█▀·.
▀▀▀▀▀• ▀▀▀·▀▀▀ ·▀  ▀ ▀▀▀  ▀▀▀ ▀▀▀.▀▀▀ ▀▀▀ ▀▀▀   ▀ • 
by h1d31n455
Version 0.0.2

0.0.1
- creation

0.0.2
- Ward OnBush
- Move QSS from DV
- Move BOTRK
-

]]--

require("common.log")
module("DickUtility", package.seeall, log.setup)

winapi = require("utils.winapi")

local _SDK = _G.CoreEx
local Console, ObjManager, EventManager, Geometry, Input, Renderer, Enums, Game = _SDK.Console, _SDK.ObjectManager, _SDK.EventManager, _SDK.Geometry, _SDK.Input, _SDK.Renderer, _SDK.Enums, _SDK.Game
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Events = _SDK.Enums.Events
local Player = ObjManager.Player
local Cast = Input.Cast
local Trinket = SpellSlots.Trinket
local insert, remove = table.insert, table.remove
local Vector = _G.CoreEx.Geometry.Vector
local Nav = _G.CoreEx.Nav
local UIMenu = require("lol/Modules/Common/Menu")

local enemies = ObjManager.Get("enemy", "heroes")

--------------------------------
-------- Core
--------------------------------
lasttime={}
next_wardtime=0	
lastpos={}
--------sReady
function sReady(spelltocheck)
	return Player:GetSpellState(spelltocheck) == SpellStates.Ready 
end
--------------------------------
-------- Menu
--------------------------------
	
dumenu = UIMenu:AddMenu("DickUtility")
---DontHideInBush
				 trintimeinfo2= dumenu:AddBool("[DontHideOnBush]:", true)
					trintimeinfo0 = dumenu:AddLabel("Max Time to check Enemy in Bush")
					 trintime = dumenu:AddSlider("Time in  s",0,10,1,3)


--------------------------------
-------- DontHideOnBush
--------------------------------
--------WArdBush
function WardBush()
if trintimeinfo2.Value then
	for _,c in pairs(enemies) do		
		if c.IsVisible and c.AsHero then
			lastpos[c] = c.Position
			lasttime[c] = os.clock()
		elseif not c.IsDead and not c.IsVisible then

				local time=lasttime[c] --last seen time
				local pos=lastpos[c]   --last seen pos
				local clock=os.clock()
				if time and pos and clock-time<trintime.Value and clock>next_wardtime and Player.Position:DistanceSqr(pos)<1000*1000 then
					local FoundBush = FindBush(pos.x,pos.y,pos.z,100)
					if FoundBush and Player.Position:DistanceSqr(FoundBush)<600*600 then
						if sReady(Trinket) then
							Cast(Trinket,FoundBush)
							next_wardtime=clock+0.5
							return
						end
					end
				end
			end
		end
	end
end

--------FindBush
function FindBush(x0, y0, z0, maxRadius, precision) --returns the nearest non-wall-position of the given position(Credits to gReY)
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




	
function OnLoad()
	

	EventManager.RegisterCallback(Enums.Events.OnTick, WardBush)
	return true
end
