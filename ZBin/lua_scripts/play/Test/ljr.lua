local TestPos = {
	CGeoPoint:new_local(1000,1000),
	CGeoPoint:new_local(500,-1000),
	CGeoPoint:new_local(2500,-1000),
    CGeoPoint:new_local(4500,0),
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
	match = "{abc}"
},

["run_to_zero"] = {
	switch = function()
	    if bufcnt(player.toBallDist("c")<300,50) then
		    return "kickball"
	    end
    end,
	a = task.go2Pos(TestPos[1]),
    b = task.go2Pos(TestPos[2]),
    c = task.getBall("a",120),
	match = "{abc}"
},

["kickball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")>200,10) then	
			return "receiveball"
		end
	end,
	a = task.go2Pos(TestPos[1]),
	b = task.go2Pos(TestPos[2]),
	c = task.myShoot(TestPos[1],200,95),
	match = "{abc}"
},
["receiveball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<250,60) then
			return "kickball2"
		end
	end,
	a = task.receive("c"),
	b = task.go2Pos(TestPos[3]),
	c = task.stop(),
	match = "{abc}"
},
["kickball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>250,20) then
			return "receiveball2"
		end
	end,
	a = task.myShoot(TestPos[3],_,105,90,_,true),
	b = task.go2Pos(TestPos[3]),
    c = task.stop(),
	match = "{abc}"
},
["receiveball2"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<300,60) then
			return "kicktogoal"
		end
	end,
	a = task.stop(),
	b = task.receive("a"),
	c = task.stop(),
	match = "{abc}"
},

["kicktogoal"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")>250,60) then
			return "finally"	
		end
	end,
	a = task.stop(),
	b = task.myShoot(TestPos[4],500,95),
	c = task.stop(),
	match = "{abc}"
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
	match = "{abc}"
},
name = "ljr",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
