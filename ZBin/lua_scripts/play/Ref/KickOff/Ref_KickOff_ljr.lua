local TestPos = {
	CGeoPoint:new_local(-140,1500),
	CGeoPoint:new_local(-500,-2500),
	CGeoPoint:new_local(1600,-1750),--b
    CGeoPoint:new_local(2100,1300),--c
    CGeoPoint:new_local(2200,1200),
    CGeoPoint:new_local(4500,0),
    CGeoPoint:new_local(300,2000),
}

gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(true,30) then
			return "run_to_zero"
		end
	end,
	a = task.go2Pos(task.auto_Pos(-80,0)),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,-2000)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["run_to_zero"] = {
	switch = function()
	    if (cond.isGameOn() and player.toBallDist("c")<330) or bufcnt(true,300) then
		    return "rball"
	    end
    end,
	a = task.go2Pos(TestPos[1]),
    b = task.go2Pos(TestPos[2]),
    c = task.getBall("a"),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[c][ab]"
},

["rball"] = {
	switch = function()
		if cond.isGameOn() then	
			return "kickball"
		elseif bufcnt(true,300) then	
			return "kickball"
		end
	end,
	a = task.go2Pos(TestPos[1]),
	b = task.go2Pos(TestPos[2]),
	c = task.passBall(TestPos[1],0,95,10,_,0),--85
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[c][ab]"
},

["kickball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")>180,20) then	
			return "receiveball"
		end
	end,	
	a = task.go2Pos(TestPos[1]),
	b = task.go2Pos(TestPos[2]),
	c = task.passBall(TestPos[7],200,95,10),--80
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[c][ab]"
},

["receiveball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<250,20) then
			return "hold"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.receive("c",_,true),
	b = task.go2Pos(TestPos[3]),
	c = task.go2Pos(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},

["hold"] = {
	switch = function()
		if bufcnt(true,10) then
			return "kickball2"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.passBall(TestPos[3],0,80,_,_,0),--80
	b = task.go2Pos(TestPos[3]),
	c = task.go2Pos(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},

["kickball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>250,20) then
			return "receiveball2"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.canShoot(80,_,_,_,"b"),--80
	b = task.go2Pos(TestPos[3]),
    c = task.go2Pos(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},

["receiveball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<120,10) then
			return "kicktoc"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.go2Pos(CGeoPoint:new_local(500,2000)),
	b = task.receive("a"),
	c = task.go2Pos(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[b][ac]"
},

["kicktoc"] = {
	switch = function()
		debugEngine:gui_debug_msg(CGeoPoint:new_local(3500,2000),player.posX("c"))
		if bufcnt(player.toBallDist("b")>180,10) then
			return "cgetball"	
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,

	a = task.go2Pos(CGeoPoint:new_local(500,2000)),
	b = task.canShoot(80,_,_,_,"c"),
	c = task.go2Pos(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[b][ac]"
},	

["cgetball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")<120,10) then
			return "kicktob"	
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"
		end
	end,
	a = task.go2Pos(CGeoPoint:new_local(500,2000)),
	b = task.go2Pos(TestPos[3]),
	c = task.receive(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[c][ab]"
},	

["kicktob"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")>180,0) then
			return "agetball"
			elseif bufcnt(player.toBallDist("a")>500 and player.toBallDist("b") and player.toBallDist("c"),360) then
			return "finish"	
		end
	end,
	a = task.go2Pos(CGeoPoint:new_local(500,2000)),
	b = task.go2Pos(TestPos[3]),
	c = task.canShoot(80,_,_,_,"a"),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[c][ab]"
},

["agetball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<200,10) then
			return "finish"	
		end
	end,
	a = task.receive(),
	b = task.go2Pos(CGeoPoint:new_local(500,1000)),
	c = task.go2Pos(CGeoPoint:new_local(-500,1000)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},

name = "Ref_KickOff_ljr",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
