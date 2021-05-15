
local x = function()
	return function()
		return enemy.pos(yyn.nearest())
		
	end
end

local nearestToBall = function(n)
	return function()
		return CGeoPoint(-500,enemy.posY(yyn.nearestToBall(n)))
	end 
end

local debugMSG = function()
	debugEngine:gui_debug_msg(CGeoPoint(0,400),enemy.posX(yyn.nearest()),5)
	debugEngine:gui_debug_msg(enemy.pos(yyn.nearest()),333,5)
	-- debugEngine:gui_debug_msg(CGeoPoint(4500,200),yyn.nearestToBall(2))
	return yyn.nearest()
end


gPlayTable.CreatePlay{

firstState="defendTheirAttackers",

["run1"] = {
	switch = function()
		if bufcnt(cond.isGameOn(),60) then
			return "kickOff"
		elseif bufcnt(yyn.judgeIfKick(),30) then
			return "defendTheirAttackers"
		end
	end,
	a = yyn.Halt(),
	b = yyn.Halt(),
	c = yyn.Halt(),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},
["kickOff"] = {
	switch = function()
	debugMSG()
		if bufcnt(yyn.kickOff()==false,120) then
			return "kickOff2"
		end
	end,
	a = yyn.goCmuRush(CGeoPoint(-700,0)),
	b = yyn.goCmuRush(CGeoPoint(-500,200)),
	c = yyn.goCmuRush(CGeoPoint(-500,-200)),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},
["kickOff2"] = {
	switch = function()
	debugMSG()
	nearestToBall(1)
		if bufcnt(yyn.kickOff(),30) then
			return "kickOff2"
		end
	end,
	a = yyn.goCmuRush(CGeoPoint(-500,0)),
	b = yyn.goCmuRush(nearestToBall(1)),
	c = yyn.goCmuRush(nearestToBall(2)),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},
["defendTheirAttackers"] = {
	switch = function()
		-- if yyn.judgeIfKick() then
		-- 	return "Receive" 
		-- end
		if (ball.pos()-player.pos("c")):mod()<200 then
			return "finish"
		elseif yyn.judgeReceiveRobot()==0 then
			return "aReceive"
		elseif yyn.judgeReceiveRobot()==1 then
			return "bReceive"
		elseif yyn.judgeReceiveRobot()==2 then
			return "Receive"
		end
	end,
	a = yyn.defendTheirs(1,0),
	b = yyn.defendTheirs(2,0),
	c = yyn.defendBallRobot(),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},
["Receive"] = {
	switch = function()
		if (ball.pos()-player.pos("c")):mod()<200 then
			return "finish"
		elseif not yyn.ifTheSameDirection("c") and bufcnt(yyn.judgeReceiveRobot()==0,120) then
			return "aReceive"
		elseif not yyn.ifTheSameDirection("c") and bufcnt(yyn.judgeReceiveRobot()==1,120) then
			return "bReceive"
		end
	end,
	a = yyn.defendTheirs(1,0),
	b = yyn.defendTheirs(2,0),
	c = yyn.receive(),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},
["aReceive"] = {
	switch = function()
		if (ball.pos()-player.pos("c")):mod()<200 then
			return "finish"
		elseif not yyn.ifTheSameDirection("a") and bufcnt(yyn.judgeReceiveRobot()==2,120) then
			return "Receive"
		elseif not yyn.ifTheSameDirection("a") and bufcnt(yyn.judgeReceiveRobot()==1,120) then
			return "bReceive"
		end
	end,
	a = yyn.receive(),
	b = yyn.yyn.defendTheirs(2,0),
	c = yyn.yyn.defendTheirs(1,0),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},

["bReceive"] = {
	switch = function()
		if (ball.pos()-player.pos("c")):mod()<200 then
			return "finish"
		elseif not yyn.ifTheSameDirection("b") and bufcnt(yyn.judgeReceiveRobot()==0,120) then
			return "aReceive"
		elseif not yyn.ifTheSameDirection("b") and bufcnt(yyn.judgeReceiveRobot()==2,120) then
			return "Receive"
		end
	end,
	b = yyn.receive(),
	a = yyn.yyn.defendTheirs(1,0),
	c = yyn.yyn.defendTheirs(2,0),
	d = yyn.behindDefend(1),
	e = yyn.behindDefend(2),
	Goalie = yyn.judge1(),
	match = "{abc}"
},

name="Ref_def_yyn",
applicable={
	exp="a", 
	a=ture
},
attribute="attack",
timeout=9999

}