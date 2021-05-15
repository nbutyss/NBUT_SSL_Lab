

gPlayTable.CreatePlay{

firstState = "wait",

["wait"] = {
	switch = function()
		if cond.isGameOn() then
			return "shoot"
		elseif bufcnt(true,60) then
			return "shoot"
		end
	end,
	a = task.getBall(CGeoPoint(4500,0),250),
	Goalie = task.goalieDef(_,true),

	-- a = task.goCmuRush(CGeoPoint(300,3000)),

	match = ""
},

["shoot"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>300,15) then
			return "out"
		end
	end,
	a = task.canShoot(81,_,1,_,_,flag.our_ball_placement),
	Goalie = task.goalieDef(_,true),

	-- a = task.goCmuRush(CGeoPoint(300,3000)),

	match = ""
},

["out"] = {
	switch = function()
		-- task.defineBallPos()
		--[[if bufcnt(player.toTargetDist("c")<50,120) then
			return "test1"
		end--]]
	end,
	a = task.canShoot(81,_,10),
	Goalie = task.goalieDef(_,true),

	-- a = task.goCmuRush(CGeoPoint(300,3000)),

	match = ""
},



name = "forplenty",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}