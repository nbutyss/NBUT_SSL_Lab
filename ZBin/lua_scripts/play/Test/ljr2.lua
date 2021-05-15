local TestPos = {-------------------------------------kaiqiu
	CGeoPoint:new_local(-1000,2000),
	CGeoPoint:new_local(-500,-2500),
	CGeoPoint:new_local(3000,-2000),
    CGeoPoint:new_local(4500,0),
    CGeoPoint:new_local(2000,1500),--踢的地方
    CGeoPoint:new_local(2000,1000),--踢之前的位置
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
	a = task.go2Pos(task.auto_Pos(-2000,0)),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,-2000)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["run_to_zero"] = {
	switch = function()
	    if bufcnt(player.toBallDist("c")<300,70) then
		    return "rball"
	    end
    end,
	a = task.go2Pos(TestPos[1]),
    b = task.go2Pos(TestPos[2]),
    c = task.getBall("a"),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["rball"] = {
	switch = function()
		if bufcnt(true,60) then	
			return "kickball"
		end
	end,
	a = task.go2Pos(TestPos[1]),
	b = task.go2Pos(TestPos[2]),
	c = task.passBall(TestPos[1],0,90,80,_,_,0),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["kickball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")>180,10) then	
			return "receiveball"
		end
	end,	
	a = task.go2Pos(TestPos[1]),
	b = task.go2Pos(TestPos[2]),
	c = task.passBall(TestPos[1],260),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["receiveball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<250,20) then
			return "holdball"
		end
	end,
	a = task.receive("c"),
	b = task.go2Pos(TestPos[3]),
	c = task.go2Pos(TestPos[6]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},
["holdball"] = {
	switch = function()
		if bufcnt(true,60) then
			return "kickball2"
		end
	end,
	a = task.passBall(TestPos[3],0,90,80,_,_,0),
	b = task.go2Pos(TestPos[3])	,
    c = task.goCmuRush(TestPos[6]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},
["kickball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>250,20) then
			return "receiveball2"
		end
	end,
	a = task.passBall(TestPos[3],300),
	b = task.go2Pos(TestPos[3])	,
    c = task.goCmuRush(TestPos[6]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},
["receiveball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<200,50) then
			return "kicktoc"
		end
	end,
	a = task.stop(),
	b = task.receive("a"),
	c = task.goCmuRush(TestPos[6]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["kicktoc"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")>180,30) then
			return "cget"	
		end
	end,
	a = task.stop(),
	b = task.passBall(TestPos[5],300),
	c = task.goCmuRush(TestPos[6]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},	

["cget"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")<500,80) then
			return "getBall2"
		end
	    if bufcnt(player.toBallDist("c")>500,80) then
            return  "finally"   
	    end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.receive2(1000),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["getBall2"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")<200,20) then
			return "shootgoal"
		end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.getBall(TestPos[4]),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["shootgoal"] = {
	switch = function()
		if  bufcnt(player.toBallDist("c")>200,20) then
			return "finally"
		end
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.passBall(TestPos[4],600),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},

["finally"] = {
	switch = function()
		if true then
			return "finally"
		end 
	end,
	a = task.stop(),
	b = task.stop(),
	c = task.stop(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "{abcde}"
},
name = "ljr2",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
