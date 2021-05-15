local TestPos = {
	task.auto_Pos(-500,1300),
	task.auto_Pos(1700,1300),
	task.auto_Pos(4000,-2500),
	CGeoPoint:new_local(-500,-1300),
	CGeoPoint:new_local(1700,1000),
	CGeoPoint:new_local(1700,-1000),
	CGeoPoint:new_local(4500,0),
}
gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()

	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(true,5) then
			return "Kgetball"
		end
	end,
	a = task.go2Pos(task.auto_Pos(-2000,0)),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,-2000)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Kgetball"] = {

	switch = function()
		if bufcnt(player.toBallDist("a")<300,120) then
			return "Kcball"
		end
	end,
	a = task.getBall(task.auto_Pos(-500,1300),200),
	b = task.go2Pos(task.auto_Pos(-500,1300)),
	c = task.go2Pos(task.auto_Pos(0,-2000)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Kcball"] = {
	switch = function()
		if bufcnt(player.toTargetDist("b")<100,10) then
			return "KkickballR"
		elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end 
	end,
	a = task.passBall(task.auto_Pos(-500,1300),0,79),
	b = task.go2Pos(task.auto_Pos(-500,1300)),
	c = task.go2Pos(task.auto_Pos(0,-2000)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["KkickballR"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>200,10) then
			return "Rrball"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.passBall(task.auto_Pos(1700,1300),1500,79,_,true),
	b = task.go2Pos(task.auto_Pos(1700,1300)),
	c = task.go2Pos(task.auto_Pos(3000,-2500)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Rrball"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<150,10) then
			return "Rshoot"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(1000,1000)),
	b = task.receive(_,_,true),
	c = task.go2Pos(task.auto_Pos(3000,-2500)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Rshoot"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")>200,10) then
			return "Trball"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(800,1000)),
	b = task.canShoot(_,_,_,_,"a"),
	c = task.go2Pos(task.auto_Pos(3000,-2500)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Trball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<200,10) then
			return "finish"
		end
	end,
	a = task.receive(),
	b = task.go2Pos(task.auto_Pos(500,1000)),
	c = task.go2Pos(task.auto_Pos(500,-1000)),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},


name = "cjl_2",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}