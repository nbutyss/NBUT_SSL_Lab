local debugMsg = function()
	debugEngine:gui_debug_arc(CGeoPoint(-4700,500),1000,0,360,1)
	debugEngine:gui_debug_arc(CGeoPoint(-4700,-500),1000,0,360,2)
	debugEngine:gui_debug_msg(CGeoPoint(0,0),enemy.posX(0))
end
local testPos  = {
	CGeoPoint:new_local(0,0),
	CGeoPoint:new_local(-4500,0),
	CGeoPoint:new_local(-4500,-1000)
}
gPlayTable.CreatePlay{

firstState="goalieDefend",


["goalieDefend"] = {
	switch = function()
		if task.kickBall() then
			return "GrabBall"
		end
	end,
	

	Goalie = task.judge1(),
	match = "{G}"
},
--点球状态进行抢球
["GrabBall"] = {
	switch = function()
		if (player.pos(0)-ball.pos()):mod()<120 then
			return "shoot"
		end
	end,
	Goalie = task.getBall(enemy.pos(0),150,flag.not_avoid_their_vehicle+flag.dribbling),
	match = "{G}"
},
["shoot"] = {
	switch = function()
		
	end,
	Goalie = task.myPassBall(),
	match = "{G}"
},

name="Ref_PenaltyDef_yyn",
applicable={
	exp="a",
	a=ture
},
attribute="attack",
timeout=9999

}