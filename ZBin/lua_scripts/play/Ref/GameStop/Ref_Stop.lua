gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
		if bufcnt(true,30) then
			return "stop"
		end
	end,
	a = task.go2Pos(task.auto_Pos(-2000,0)),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,-2000)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["stop"] = {
	switch = function()
		-- if bufcnt(true,30) then
		-- 	return "stop"
		-- else
		if cond.isGameOn() then
			return "finish"
		end
	end,
	a = task.stop2(0),
	b = task.stop2(1,3000),
	c = task.stop2(2,2000),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

name = "Ref_Stop",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
