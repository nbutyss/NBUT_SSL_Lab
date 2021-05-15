
local debugMsg = function()
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,1000),task.Iflag.b)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,1200),task.bMsg.f)

	
end

gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
	task.theShort(-4500,4500,-3000,3000)
	task.lorR()
	task.zero()
	-- task.returnNum()
		debugMsg()
		if bufcnt(true,20) then
			return "run_to_zero"
		end
	end,
	a = task.defCorner(5),
	b = task.defCorner(4),
	c = task.defCorner(3),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["run_to_zero"] = {
	switch = function()
	debugMsg()
        if bufcnt(player.toBallDist("a")<300,600) then
			return "agetball"
		end
		if bufcnt(player.toBallDist("b")<300,600) then
			return "bgetball"
		end
		if bufcnt(player.toBallDist("c")<300,600) then
			return "cgetball"
		end
	end,
	a = task.defCorner(5),
	b = task.defCorner(4),
	c = task.defCorner(3),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["agetball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")<150,60) then
			return "finish"
		end
	end,
	a = task.receive(),
	b = task.defCorner(4),
	c = task.defCorner(3),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["bgetball"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<150,60) then
			return "finish"
		end
	end,
	a = task.defCorner(5),
	b = task.receive(),
	c = task.defCorner(3),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["cgetball"] = {
	switch = function()
		if bufcnt(player.toBallDist("c")<150,60) then
			return "finish"
		end
	end,
	a = task.defCorner(5),
	b = task.defCorner(4),
	c = task.receive(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},


name = "cornerdef",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
