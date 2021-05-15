local TestPos = {---------------------------------houchang
	task.auto_Pos(-1000,-1000),
	task.auto_Pos(3000,-1000),
	task.auto_Pos(3000,1500),
	task.auto_Pos(4500,100),
	task.auto_Pos(3000,0),
}
local p = ball.pos()
gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()

	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(true,30) then
			return "Kgetball"
		end
	end,
	a = task.go2Pos(task.auto_Pos(-2000,0)),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,1500)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Kgetball"] = {
	switch = function()
		if bufcnt(player.toTargetDist("a")<200,60) then
			return "Kcball"
		end
	end,
	a = task.getBall("b",200),
	b = task.go2Pos(TestPos[1]),
	c = task.go2Pos(TestPos[3]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Kcball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<100,60) then
			return "Kkickball"
		end
	end,
	a = task.passBall("b",0,80),
	b = task.go2Pos(TestPos[1]),
	c = task.go2Pos(TestPos[3]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Kkickball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>200,30) then
			return "Rrball"
		end
	end,
	a = task.passBall("b",6500,80,_,true,6500),
	-- a = task.passBall("b",6500,90,_,true,6500),
	b = task.stop(),
	c = task.stop(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Rrball"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<100,10) then
			return "RtoT"
		end
	end,
	a = task.stop(),
	b = task.receive("c"),
	c = task.stop(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},
-- 
["RtoT"] = {
	switch = function()
		if bufcnt(math.abs(player.dir("b")-(player.pos("c")-ball.pos()):dir())<0.5,20) then
			return "RKickball"
		end
	end,
	a = task.stop(),
	b = task.getBall("c",95),
	c = task.stop(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["RKickball"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")>200,10) then
			return "Trball"
		end
	end,
	a = task.stop(),
	b = task.passBall("c",1000),
	c = task.stop(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Trball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")<150,20) then
			return "TtoG"
		end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.receive(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["TtoG"] = {
	switch = function()
		if bufcnt(player.toTargetDist("c")<150,20) then
			return "Tshoot"
		end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.getBall(TestPos[4],95),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["Tshoot"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")>200,30) then
			return "finish"
		end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.canShoot(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

name = "cjl",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}