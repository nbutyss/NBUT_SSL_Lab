
local x = function()
	return function()
		return enemy.pos(task.nearest())
		
	end
end

local debugMSG = function()
	debugEngine:gui_debug_msg(CGeoPoint(0,400),enemy.posX(task.nearest()),5)
	debugEngine:gui_debug_msg(enemy.pos(task.nearest()),333,5)
	return task.nearest()
end


gPlayTable.CreatePlay{

firstState="run1",

["run1"] = {
	switch = function()
	debugMSG()
		if bufcnt(task.judgeIfKick(),30) then
			return "defendTheirAttackers"
		end
	end,
	a = task.defendTheirs(1,0),
	b = task.defendTheirs(2,0),
	c = task.getBall(x(),600),
	d = task.behindDefend(1),
	e = task.behindDefend(2),
	Goalie = task.judge1(),
	match = "[abc]"
},
["defendTheirAttackers"] = {
	switch = function()
		-- if task.judgeIfKick() then
		-- 	return "Receive" 
		-- end
		if not task.ifTheSameDirection("c") and task.judgeReceiveRobot()==0 then
			return "aReceive"
		elseif not task.ifTheSameDirection("c") and task.judgeReceiveRobot()==1 then
			return "bReceive"
		end
	end,
	a = task.defendTheirs(1,0),
	b = task.defendTheirs(2,0),
	c = task.defendBallRobot(),
	d = task.behindDefend(1),
	e = task.behindDefend(2),
	Goalie = task.judge1(),
	match = "[abc]"
},
["Receive"] = {
	switch = function()
		if not task.ifTheSameDirection("c") and bufcnt(task.judgeReceiveRobot()==0,120) then
			return "aReceive"
		elseif not task.ifTheSameDirection("c") and bufcnt(task.judgeReceiveRobot()==1,120) then
			return "bReceive"
		end
	end,
	a = task.defendTheirs(1,0),
	b = task.defendTheirs(2,0),
	c = task.receive(),
	d = task.behindDefend(1),
	e = task.behindDefend(2),
	Goalie = task.judge1(),
	match = "[abc]"
},
["aReceive"] = {
	switch = function()
		
	end,
	a = task.receive(),
	b = task.defendTheirs(2,0),
	c = task.defendTheirs(1,0),
	d = task.behindDefend(1),
	e = task.behindDefend(2),
	Goalie = task.judge1(),
	match = "[abc]"
},

["bReceive"] = {
	switch = function()
		
	end,
	b = task.receive(),
	a = task.defendTheirs(1,0),
	c = task.defendTheirs(2,0),
	d = task.behindDefend(1),
	e = task.behindDefend(2),
	Goalie = task.judge1(),
	match = "[abc]"
},

name="defendMiddle",
applicable={
	exp="a", 
	a=ture
},
attribute="attack",
timeout=9999

}