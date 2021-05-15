local TestPos = {------------------------------------------------jiaoqiu
	CGeoPoint:new_local(3300,1200),--点1接球点
	CGeoPoint:new_local(3300,-1200),--a车去点2
	CGeoPoint:new_local(4500,1200),--b车起始点
	CGeoPoint:new_local(4500,-1200),--b车接球点
	CGeoPoint:new_local(3500,1000),--禁区左上角
	CGeoPoint:new_local(4500,0)
}

function follow()
	return function()

		local pos 
		if task.bMsg.f == 1 then
			pos = player.pos("c") + Utils.Polar2Vector(250,(player.pos("c") - TestPos[6]):dir() + 2*math.pi/7)
		else
			pos = player.pos("c") + Utils.Polar2Vector(250,(player.pos("c") - TestPos[6]):dir() - 2*math.pi/7)
		end
		
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),pos:x())
		return pos
	end
end
-- local pi = 3.1415926
-- local pos1 = TestPos[4] + Utils.Polar2Vector((200*1.414),math.acos((200*200+282.8*282.8-90*90)/(2*200*282.8)))--
-- local p = function(role)
-- 	return function(role)
-- 	local pos2
-- 		if player.posX(role) >3650 and player.posX(role) < 3750 then
-- 			pos2 = TestPos[5]
-- 		else
-- 			pos2 =  TestPos[4] + Utils.Polar2Vector((200*1.414),(TestPos[6] - player.pos(role)):dir())
-- 		end
-- 		return pos2
-- 	end
-- end

gPlayTable.CreatePlay{

firstState = "gotoball",

-- ["first"] = {
-- 	switch = function()

-- 		if bufcnt(true,5) then
-- 			return "gotoball"
-- 		end
-- 	end,
-- 	a = task.getBall(task.auto_Pos(3800,1200)),--a车拿球朝向点1
-- 	b = task.go2Pos(task.auto_Pos(3300,1200)),--b车先去一个点
-- 	c = task.goCmuRush(task.auto_Pos(2000,700)),--c go to one pos
-- 	d = task.ldef(),
-- 	e = task.rdef(),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

["gotoball"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		task.defineBallPos()
		if bufcnt(player.toBallDist("a")<350,40) then
			return "gotoball1"
		end
	end,
	a = task.getBall(task.auto_Pos(3800,1200)),--a车拿球朝向点1
	c = task.goCmuRush(task.auto_Pos(3150,800)),--b车去一个点
	b = task.goCmuRush(task.auto_Pos(2900,700)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},
["gotoball1"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
	-- task.defineBallPos()
		if bufcnt(player.toTargetDist("b")<70,5) then
			return "cball"
		end
	end,
	a = task.getBall(task.auto_Pos(3800,1200)),--a车拿球朝向点1
	b = task.goCmuRush(task.auto_Pos(3050,1300)),--b车zai去一个点
	c = task.goCmuRush(task.auto_Pos(3150,1350)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},
--auto_Pos
["cball"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(true,30) then
			return "passball2"
		end
	end,
	a = task.passBall(task.auto_Pos(3700,1200),0,89),--a车朝接球点吸球
	b = task.goCmuRush(task.auto_Pos(3050,1300)),--b车zai去一个点
	c = task.goCmuRush(task.auto_Pos(3150,1350)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["passball2"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(player.toBallDist("a")>300,0) then
			return "getball"
		end
	end,
	a = task.passBall(task.auto_Pos(3700,1300),600,75,1,true,1000),--a车朝接球点踢球
	b = task.goCmuRush(task.auto_Pos(3050,1300)),--b车去接球点
	c = task.goCmuRush(task.auto_Pos(3700,1300)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},


["getball"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		if bufcnt(player.toBallDist("c")<200,30) then
			return "shoot"
		end
	end,
	a = task.go2Pos(task.auto_Pos(2500,-600)),--a车去点2
	c = task.receive(),--b车接球
	b = task.goCmuRush(follow()),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["shoot"] = {
	switch = function()
	debugEngine:gui_debug_line(TestPos[1], TestPos[2],4)
	debugEngine:gui_debug_line(TestPos[1], TestPos[3],4)
	debugEngine:gui_debug_line(TestPos[4], TestPos[2],4)
		--if bufcnt(player.toBallDist("b")>350,100) then
		if bufcnt(player.toBallDist("c")>200,30) then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(2500,-600)),--a车去点2
	c = task.canShoot(),--b车射门
	b = task.goCmuRush(follow()),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},



name = "Ref_CornerKick_jxy",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}