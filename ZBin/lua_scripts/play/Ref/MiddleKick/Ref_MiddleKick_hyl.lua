local duimen = CGeoPoint:new_local(3000,0)-------------------------zhongchang

gPlayTable.CreatePlay{

firstState = "0",

-- 初始定车
["0"] = {
	switch = function()
	task.defineBallPos()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(true,5) then
			return "AchaoB"
		end
	end,
	a = task.goCmuRush(CGeoPoint(-1250,0)),
	b = task.go2Pos(task.auto_Pos(-300,1000)),
	c = task.go2Pos(task.auto_Pos(-666,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["AchaoB"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toTargetDist("b")<100 and player.toBallDist("a")<400, 120)then
			return "AchuanB1"
		end
	end,
	a = task.getBall("b"),
	b = task.go2Pos(task.auto_Pos(-300,1000)),
	c = task.go2Pos(task.auto_Pos(-666,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},



["AchuanB1"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toTargetDist("b")<600,0) then
			return "AchuanB3"
		end
	end,
	a = task.passBall(task.auto_Pos(1250,1000),0,88,_,true,0),
	b = task.go2Pos(task.auto_Pos(1250,1000)),
	c = task.go2Pos(task.auto_Pos(-666,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},


["AchuanB3"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toBallDist("a")>300 and player.toTargetDist("b")<500,10) then
			return "Bjie"
		end
	end,
	a = task.passBall(task.auto_Pos(1250,1000),600,87,_,true,6500),
	b = task.go2Pos(task.auto_Pos(1250,1000)),
	c = task.go2Pos(task.auto_Pos(1250,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[a][bc]"
},

["Bjie"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toBallDist("b")<300 and player.toTargetDist("c")<80,30) then
			return "BchuanC3"
		elseif bufcnt(ball.posX()<0,60) then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(0,0)),
	b = task.receive(_,_,true),
	c = task.go2Pos(task.auto_Pos(666,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[b][ac]"
},


["BchuanC2"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toTargetDist("c")<200,0) then
			return "BchuanC3"
		end
	end,
	a = task.go2Pos(task.auto_Pos(0,0)),
	b = task.passBall(task.auto_Pos(2000,-1250),0,85,_,true,0),
	c = task.go2Pos(task.auto_Pos(2000,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},


["BchuanC3"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toBallDist("b")>250 and player.toTargetDist("c")<400,10) then
			return "Cjie"
		elseif bufcnt(true,360) then
			return "finish"	
		end
	end,
	a = task.go2Pos(task.auto_Pos(0,0)),
	b = task.canShoot(87),
	c = task.go2Pos(task.auto_Pos(2000,-1250)),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

["Cjie"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if bufcnt(player.toBallDist("c")<300,40) then
			return "Cshemen2"
		elseif bufcnt(ball.posX()<1000,45) then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(0,0)),
	b = task.go2Pos(task.auto_Pos(666,666)),
	d = task.ldef(),
	e = task.rdef(),
	c = task.receive(duimen,_,true),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

-- ["Cshemen1"] = {
-- 	switch = function()
-- 	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
-- 		if bufcnt(true,30) then
-- 			return "Cshemen2"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(0,0)),
-- 	b = task.go2Pos(task.auto_Pos(1000,1000)),
-- 	c = task.passBall(duimen,_,85,85,0.5),
-- 	d = task.ldef(),
-- 	e = task.rdef(),
-- 	match = ""
-- },

["Cshemen2"] = {
	switch = function()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if player.toBallDist("c")>300 or ball.posX()<1500 then
			return "finish"
		end
	end,
	a = task.go2Pos(task.auto_Pos(0,0)),
	b = task.go2Pos(task.auto_Pos(666,666)),
	c = task.canShoot(),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

-- ["Abushe"] = {
-- 	switch = function()
-- 	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
-- 		if bufcnt(player.toBallDist("c")<300,35) then
-- 			return "Cshemen"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(0,0)),
-- 	b = task.go2Pos(task.auto_Pos(1000,1000)),
-- 	c = task.receive(duimen),
-- 	match = "{abc}"
-- },

name = "Ref_MiddleKick_hyl",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
