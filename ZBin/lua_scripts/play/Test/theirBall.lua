-- local ballplace = CGeoPoint:new_local(3000,2000)
local ballplace=ball.placementPos()
local receivePlace = function(p)
	-- return function()
		return ballplace+Utils.Polar2Vector(105,(ballplace-ball.pos()):dir())
	-- end
end

local backPlace = function()
	-- return function()
		return ball.pos()+Utils.Polar2Vector(300,(player.pos("b")-ball.pos()):dir())
	-- end
end

local stopPlace = function()
	-- return function()
		return ball.pos()+Utils.Polar2Vector(700,(player.pos("b")-ball.pos()):dir())
	-- end
end



local p = ball.placementPos()

local debugMsg = function()
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,1000),p:x())
	debugEngine:gui_debug_msg(ballplace,"_")

	debugEngine:gui_debug_arc(ballplace,100,0,360,1)

end

gPlayTable.CreatePlay{

firstState = "getBall",

["getBall"] = {

	switch = function()
		
	end,
	a = task.go2Pos(CGeoPoint(1200,2600),_,flag.avoid_their_ballplacement_area),
	b = task.go2Pos(CGeoPoint(1200,2800),_,flag.avoid_their_ballplacement_area),
	Goalie = task.go2Pos(CGeoPoint(1200,3000),_,flag.avoid_their_ballplacement_area),
	match = ""
},


name = "theirBall",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}