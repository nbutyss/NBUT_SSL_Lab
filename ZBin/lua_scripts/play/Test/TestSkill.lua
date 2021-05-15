local f = flag.dribbling
local p = CGeoPoint:new_local(4500,0)
gPlayTable.CreatePlay{

firstState = "t",
["t"] = {
	switch = function()
	end,
	Leader = task.touchKick(p,false),
	match = "[L]"
},
["t1"] = {
	switch = function()
		if bufcnt(true,90) then
			return "t2"
		end
	end,
	Kicker = task.speed(80,0,0),
	match = ""
},
["t2"] = {
	switch = function()
		if bufcnt(true,90) then
			return "t3"
		end
	end,
	Kicker = task.speed(-80,0,0,f),
	match = ""
},
["t3"] = {
	switch = function()
		if bufcnt(true,90) then
			return "t1"
		end
	end,
	Kicker = task.speed(0,80,0,f),
	match = ""
},


name = "TestSkill",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
