local playerNum = 0
local dist = 87
local carfront = 87
local angleLimit = 180

local debugMsg = function()
	debugEngine:gui_debug_msg(CGeoPoint(3300,0),enemy.posX(0))
	debugEngine:gui_debug_msg(CGeoPoint(3300,200),(player.pos(playerNum)-ball.pos()):mod())

end

local length = function()
	return (player.pos(playerNum)-ball.pos()):mod()-60

end
gPlayTable.CreatePlay{

firstState = "start",

["start"] = {
	switch = function()
		if bufcnt(true,10) then
			return "getBall"
		end
	end,
	Goalie = task.Halt(),
	match = ""
},

["getBall"] = {
	switch = function()
		debugMsg()
		if bufcnt(ball.toPlayerDist(playerNum)<500,60) then
			return "Pass"
		end
	end,
	Goalie = nhy.getBall(CGeoPoint(2000,-1500)),
	match = ""
},

["Pass"] = {
	switch = function()
		debugMsg()
		if  player.posX(playerNum) >-1100 then
			return "catch"
		end
 	end,
	Goalie = nhy.myShoot(CGeoPoint(2000,-1000),1400,carfront,carfront,4),
	match = ""
},

["catch"] = {
	switch = function()
		debugMsg()
		if ball.toPlayerDist(playerNum)>350 then
			return "catch"
		elseif (enemy.pos(0)-player.pos(0)):mod()<3000 or player.posX(playerNum)>0 then
			return "canShoot"
		end
	end,
	-- Goalie = task.myShoot(CGeoPoint(2000,-1500),160,carfront,carfront,1),
	Goalie = nhy.myShoot(CGeoPoint(2000,-1000),1300,carfront,carfront,1),
	match = ""
},

["canShoot"] = {
	switch = function()
		debugMsg()
		if bufcnt(ball.toPlayerDist(playerNum)<120,0)then
			return "canShoot"
		end
	end,
	Goalie = nhy.canShoot(80,20,_,6000),
	match = ""
},


name = "Ref_PenaltyKick_nhy",
applicable ={
	exp = "a",
	a = true
},

attribute = "attack",
timeout = 99999
}
