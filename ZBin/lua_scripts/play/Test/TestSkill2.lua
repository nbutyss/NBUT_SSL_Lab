------------------------------------------------qianchang
gPlayTable.CreatePlay{
firstState="0",
["0"] = {
	switch = function()
	task.defineBallPos()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(true,10) then
			return "GetBall"
		end
	end,
	a = task.waitForAttack(),
	b = task.go2Pos(task.auto_Pos(2000,1500)),
	c = task.go2Pos(task.auto_Pos(2000,-2000)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},





["GetBall"]={
	switch=function()
	if  bufcnt(player.toTargetDist("a")<300,60) then
		return "CB"
	end
	end,
	a=task.getBall("b"),
	b=task.go2Pos(task.auto_Pos(0,2700)),
	c=task.go2Pos(task.auto_Pos(0,0)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"
},
["CB"]={
	switch=function()
	if  bufcnt(player.toTargetDist("b")<1500,30) then
		return "PassBallTob"
	end
	end,
	a=task.passBall_MJW("b",0,85),
	b=task.go2Pos(task.auto_Pos(2700,2500)),
	c=task.go2Pos(task.auto_Pos(0,0)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"
},
["PassBallTob"]={
	switch=function()
	if  player.toTargetDist("b")<600 then
		return "ReceiveBall"
	-- else
	end
	end,
	a=task.passBall_MJW("b",6500,85,_,40,true,3700),--,true,4000),
	-- a=task.passBall_MJW("b",4000,80,_,40),
	b=task.go2Pos(task.auto_Pos(2700,2500)),
	c=task.waitForAttack(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"


},


["ReceiveBall"]={
	switch=function()
	debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,0),ball.posX())
		if  bufcnt(player.toBallDist("b")<120,10) then
			return "Shoot"
		elseif ball.posX()<1000	then
			return "finish"
		elseif bufcnt(ball.velMod()<100,360) then
			return "finish"
		end
	end,
	a=task.go2Pos(task.auto_Pos(0,-2700)),
	b=task.receive(task.auto_Pos(4500,0),_,true),
	c=task.waitForAttack(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"


},
["Shoot"]={
	switch=function()
		if  bufcnt(ball.toTheirGoalDist()>200 and  ball.toPlayerDist("b")>200,60) then
			return "cReceive"
		elseif ball.posX()<1000 then
			return "finish"
		elseif bufcnt(ball.velMod()<100,360) then
			return "finish"
		end
	end,
	a=task.go2Pos(task.auto_Pos(0,-2700)),
	b=task.canShoot(),
	c=task.waitForAttack(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"


},
["cReceive"]={
	switch=function()
	if  bufcnt((ball.pos()-player.pos("c")):mod()<1200,120) then
		return "cShoot"
	elseif ball.posX()< 1000 then
		return "finish"
	elseif bufcnt(ball.velMod()<100,360) then
		return "finish"
	end
	end,
	a=task.go2Pos(task.auto_Pos(0,-2700)),
	b=task.go2Pos(task.auto_Pos(0,2700)),
	c=task.receive(task.auto_Pos(4500,0)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"


},
["cShoot"]={
	switch=function()
		if(ball.posX()<1000) then
			return "finish"
		-- else
		-- 	bufcnt(true,30)
		-- 	return "finish"
		end
	end,
	a=task.go2Pos(task.auto_Pos(0,-2700)),
	b=task.go2Pos(task.auto_Pos(0,2700)),
	c=task.canShoot(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match="[abc]"


},
name="TestSkill2",
applicable={
	exp="a",
	a=true

},
attribute="attack",
timeout=99999
}