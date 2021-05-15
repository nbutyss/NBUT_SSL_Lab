local TestPos = {------------------------------------------------jiaoqiu
	CGeoPoint:new_local(3300,1200),--点1接球点
	CGeoPoint:new_local(3300,-1200),--a车去点2
	CGeoPoint:new_local(4500,1200),--b车起始点
	CGeoPoint:new_local(4500,-1200),--b车接球点
	CGeoPoint:new_local(3500,1000),--禁区左上角
	--CGeoPoint:new_local(4500,0)
}
function POS(x,y)
	local res
	if ball.posY()>0 then
		res=CGeoPoint(x,-y)
	else
		res=CGeoPoint(x,y)
	end
	return res
end
function between(a,min,max)
		if a > min and a < max then
			return true
		end
		return false
	end

local goal=CGeoPoint:new_local(4500,0)
local f = flag.dribbling 

function mycanshoot(role1,tar)
	local angToOurplayer
	if type(tar) == "string" then 
		 angToOurplayer=player.toPlayerDir(role1,tar)
	-- else
	-- 	 angToOurplayer=player.toTheirGoalDir(role1)
	end
		--local num = -1
		local judge=1
		for i=0,param.maxPlayer-1 do
			if enemy.valid(i) then
				local angToenemy=(enemy.pos(i)-player.pos(role1)):dir()
				local distToenemy=(enemy.pos(i)-player.pos(role1)):mod()
				local Dist=player.toPlayerDist(role1,tar)
				local ang=math.atan(90/distToenemy)
				if angToOurplayer>angToenemy-ang-math.pi/11 and angToOurplayer<angToenemy+ang+math.pi/11 and distToenemy<Dist then
					judge=0
					break
				end
			end
		end
	if judge==1 then 
		return true
	else
		return false
	end
end


gPlayTable.CreatePlay{

firstState = "gotoball",

["gotoball"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		lzk.defineBallPos()
		if bufcnt(player.toBallDist("a")<350 and (player.pos("b")-POS(3450,1350)):mod()<150,40) then
			return "gotoball1"
		end
	end,
	a = lzk.getBall(lzk.auto_Pos(3800,1200)),
	b = lzk.goCmuRush(lzk.auto_Pos(3450,1350)),
	c = lzk.goCmuRush(lzk.auto_Pos(2400,800)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[abcde]"
},
["gotoball1"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
	-- lzk.defineBallPos()
		-- if bufcnt(mycanshoot("a",goal),5) then
		-- 	return "directShoot"--直接射门
		-- end
		if bufcnt((player.pos("b")-POS(2050,700)):mod()<800,0) then
			return "gotoball2"
		end
	end,
	a = lzk.goCmuRush1("a","c",f),--迷惑对手
	b = lzk.goCmuRush(lzk.auto_Pos(2050,700)),
	c = lzk.goCmuRush(lzk.auto_Pos(3650,1350)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[ade]{bc}"
},
["gotoball2"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
	
	-- lzk.defineBallPos()
		-- if bufcnt(mycanshoot("a",goal),5) then
		-- 	return "directShoot"--直接射门
		-- end
		if bufcnt((player.pos("b")-POS(2450,700)):mod()<150,0) then
			return "cball"
		end
	end,
	a = lzk.goCmuRush1("a","c",f),--迷惑对手
	b = lzk.goCmuRush(lzk.auto_Pos(2450,700)),
	c = lzk.goCmuRush(lzk.auto_Pos(3650,1350)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[ade]{bc}"
},
["cball"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(mycanshoot("a","b"),20)then
			return "StartShoot2"
		end
		if bufcnt(player.toBallDist("a")<200,20) then
				return "StartShoot"
		end
	end,
	a = lzk.goCmuRush1("a","b",f),
	b = lzk.Halt_lzk("a"),
	c = lzk.goCmuRush(lzk.auto_Pos(3850,1350)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[ade]{bc}"
},

["StartShoot"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(player.toBallDist("a")>200,10) then
			return "touchShoot"
		end
	end,
	a = lzk.passBall(lzk.auto_Pos(2450,700),500,75,1,true,790),--Attack_lzk(f,"a","b"),--passBall(lzk.auto_Pos(3700,1300),600,75,1,true,1000),--a车朝接球点踢球
	b = lzk.Halt_lzk(goal),--b车去接球点
	c = lzk.goCmuRush(lzk.auto_Pos(4250,1350)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[abcde]"
},
["StartShoot2"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(player.toBallDist("a")>200,0) then
			return "touchShoot"
		end
	end,
	a = lzk.Attack_lzk(f,"a","b"),--Attack_lzk(f,"a","b"),--passBall(lzk.auto_Pos(3700,1300),600,75,1,true,1000),--a车朝接球点踢球
	b = lzk.Halt_lzk(goal),--b车去接球点
	c = lzk.goCmuRush(lzk.auto_Pos(4250,1350)),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[abcde]"
},

["touchShoot"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(ball.posX()>4490,0) then
			return "finish"
		end
		if bufcnt(ball.velMod()<500 and not between(ball.posX(),3500,4500) and not between(ball.posY(),-1000,1000),5) then
			return "AgainShoot"
		end
	end,
	a = lzk.Halt_lzk("b"),--a车去点2
	b = lzk.TouchAndreceive_lzk(goal,95,false,"b","a"),--b车接球
	c = lzk.goCmuRush(lzk.auto_Pos(3650,1350)),--(follow()),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[ade]{bc}"
},
--补射
["AgainShoot"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(player.toBallDist("b")<120,60) then
			return "finish"
		end
	end,
	a = lzk.goCmuRush(lzk.auto_Pos(3700,-1100),player.toTheirGoalDir("a")),--a车去点2
	b = lzk.canShoot(),--b车接球
	c = lzk.goCmuRush(lzk.auto_Pos(3200,1200)),--(follow()),
	d = lzk.ldef(),
	e = lzk.rdef(),
	Goalie = lzk.goalieDef(),
	match = "[ade]{bc}"
},
name = "Ref_CornerKick_lzk",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}