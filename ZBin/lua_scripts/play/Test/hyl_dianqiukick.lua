gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
		if bufcnt(true,90) then
			return "shemen"
		end
	end,
	a = task.go2Pos(task.auto_Pos(4300,0)),
	b = task.go2Pos(task.auto_Pos(-3000,-1500)),
	c = task.go2Pos(task.auto_Pos(-3000,-2000)),
	d = task.go2Pos(task.auto_Pos(-3000,1500)),
	e = task.go2Pos(task.auto_Pos(-3000,2000)),
	match = "{bcde}"
},

["naqiu"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<400,60) then
			return "huangren1"
		end
	end,
	a = task.getBall(CGeoPoint:new_local(4500,960)),
	b = task.go2Pos(task.auto_Pos(-3000,-1500)),
	c = task.go2Pos(task.auto_Pos(-3000,-2000)),
	d = task.go2Pos(task.auto_Pos(-3000,1500)),
	e = task.go2Pos(task.auto_Pos(-3000,2000)),
	match = "{bcde}"
},

["huangren1"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<400,40) and  cond.isGameOn()  then

			return "huangren2"
		end
	end,
	a = task.getBall(CGeoPoint:new_local(4500,960),200),
	b = task.go2Pos(task.auto_Pos(-3000,-1500)),
	c = task.go2Pos(task.auto_Pos(-3000,-2000)),
	d = task.go2Pos(task.auto_Pos(-3000,1500)),
	e = task.go2Pos(task.auto_Pos(-3000,2000)),
	match = "{bcde}"
},

["huangren2"] = {
	switch = function()
		if bufcnt(true,10) then
			return "shemen"
		end
	end,
	a = task.canShoot(_,_,10,0,_,flag.our_ball_placement),
	b = task.go2Pos(task.auto_Pos(-3000,-1500)),
	c = task.go2Pos(task.auto_Pos(-3000,-2000)),
	d = task.go2Pos(task.auto_Pos(-3000,1500)),
	e = task.go2Pos(task.auto_Pos(-3000,2000)),
	match = "{bcde}"
},

["shemen"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>300,15) then
			return "finish"
		end
	end,
	a = task.canShoot(_,_,10,_,_,flag.our_ball_placement),
	b = task.go2Pos(task.auto_Pos(-3000,-1500)),
	c = task.go2Pos(task.auto_Pos(-3000,-2000)),
	d = task.go2Pos(task.auto_Pos(-3000,1500)),
	e = task.go2Pos(task.auto_Pos(-3000,2000)),
	match = "{bcde}"
},


name = "hyl_dianqiukick",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
