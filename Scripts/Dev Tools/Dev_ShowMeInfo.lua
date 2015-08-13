--<<Shows the most of needed info needed for developers. Authored by MaZaiPC.>>

require("libs.Utils")
require("libs.ScriptConfig")

local config = ScriptConfig.new()
config:SetParameter("importKey", "P", config.TYPE_HOTKEY)
config:SetParameter("changeType", "T", config.TYPE_HOTKEY)
config:SetParameter("Active", 221, config.TYPE_HOTKEY)
config:SetParameter("PositionX", 20)
config:SetParameter("PositionY", 50)
config:SetParameter("Size", 15)
config:Load()

local version = 0.892

x = config.PositionX
y = config.PositionY
size = config.Size

local XYZ = false
local DST = false
local X, Y, Z = nil
local D = nil

local
TYPE_DOUBLE,
TYPE_INTEGER = "double","integer"

local color = {
0xFF9900FF,	--1 Orange
0xFFFF00AA,	--2 Yellow
0x66FF33FF,	--3 Green
0xABCDEFAA,	--4 Blue Glass
0xABCDEFAA, --5 Neutral Blue
0xFFCD00FF 	--6 Lemon
}

local Font = drawMgr:CreateFont("Font","Tahoma",size,550)
local Info,Text = nil, {}
local msgState = false
local mode = TYPE_DOUBLE

function Key(msg,code)
	if client.paused then return end
	local me = entityList:GetMyHero()
	if not me then return end
	if msg == KEY_DOWN then
		if code == config.importKey then
			local file = io.open(SCRIPT_PATH.."/cordsOutput.txt",'a')
			local v = me.position
			file:write(ctype(v.x)..", "..ctype(v.y)..", "..ctype(v.z).."\n")
			file:flush()
			file:close()
			msgState = true
		elseif code == config.changeType then
			if mode == TYPE_DOUBLE then
				mode = TYPE_INTEGER
			else
				mode = TYPE_DOUBLE
			end
		end
	end
end

function ShowInfo(tick)
	if client.paused then return end
	local me = entityList:GetMyHero()
	if not me then return end
	local v = me.position
	if X and Y and Z then
		XYZ = X.visible and Y.visible and Z.visible
	end
	if D then
		DST = D.visible
	end
	
	if not Text[2] then
		Text[2] = drawMgr:CreateText(x,y+100,color[4],"",Font) Text[2].visible = false
	end
	
	if msgState and Text[2] and SleepCheck("send") then
		Text[2].visible = true
		Text[2].text = "Copied to file: "..ctype(v.x)..", "..ctype(v.y)..", "..ctype(v.z)
		msgState = false
		Sleep(2000,"send")
	end
	
	if not Info then
		Info = drawMgr:CreateText(x,y,color[1],"Show me Info v"..version.." (Tools for Lua Developer)",Font) Info.visible = true
	end
	
	if not XYZ then
		X = drawMgr:CreateText(x,y+20,color[2],"X: "..ctype(v.x),Font) X.visible = true
		Y = drawMgr:CreateText(x,y+40,color[2],"Y: "..ctype(v.y),Font) Y.visible = true
		Z = drawMgr:CreateText(x,y+60,color[2],"Z: "..ctype(v.z),Font) Z.visible = true
	else
		X.text = "X: "..ctype(v.x)
		Y.text = "Y: "..ctype(v.y)
		Z.text = "Z: "..ctype(v.z)
	end
	
	if not Text[1] then
		Text[1] = drawMgr:CreateText(x,y+80,color[3],"To Copy in file press ''"..string.char(config.importKey).."'' key.",Font) Text[1].visible = true
	end
	if not DST then
		D = drawMgr:CreateText(x,y+130,color[2],"Distance (me,mouse): "..ctype(me:GetDistance2D(client.mousePosition)).." DTm",Font) D.visible = true
	elseif tostring(me:GetDistance2D(client.mousePosition)) == "4.8123190965235e+038" then
		D.text = "Calculation is impossible, please move mouse out of HUD."
		D.color = color[6]
	else
		D.text = "Distance (me,mouse): "..ctype(me:GetDistance2D(client.mousePosition)).." DTm"
		D.color = color[2]
	end
	
	if not Text[3] then
		Text[3] = drawMgr:CreateText(x,y+580,color[5],"Now displayed info type is ''"..mode.."''. To change type press ''"..string.char(config.changeType).."'' key.",Font) Text[3].visible = true
	else
		Text[3].text = "Now displayed info type is ''"..mode.."''. To change type press ''"..string.char(config.changeType).."'' key."
	end
end

function ctype(value)
	if mode == TYPE_DOUBLE then
		return value
	else
		return math.floor(value)
	end
end

function Close()
	if Info then
		Info.visible = false
	end
	if XYZ then
		X.visible = false
		Y.visible = false
		Z.visible = false
	end
	if Text[1] then
		Text[1].visible = false
	end
	if Text[2] then
		Text[2].visible = false
	end
	if Text[3] then
		Text[3].visible = false
	end
	if DST then
		D.visible = false
	end
end

script:RegisterEvent(EVENT_KEY, Key)
script:RegisterEvent(EVENT_TICK, ShowInfo)
script:RegisterEvent(EVENT_CLOSE, Close)
