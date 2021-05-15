local duimen = CGeoPoint:new_local(3000,0)
gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
		if bufcnt(true,120) then
			return "goalie1"
		end
	end,
	a = task.Halt(),
    b = task.paoguoqu(4000),
	match = "[b][a]"
},

["goalie1"] = {
	switch = function()
		if ball.toPlayerDist("a")>200 then
			return "goalie2"
		end
	end,
	a = task.sheguoqu("b",50),
    b = task.paoguoqu(4000),
	match = "[ba]"
},

["goalie2"] = {
	switch = function()
		if bufcnt(true,120) then
			return "goalie1"
		end
	end,
	a = task.Halt(),
    b = task.receive(),
	match = "[b][a]"
},

name = "hyltest",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
