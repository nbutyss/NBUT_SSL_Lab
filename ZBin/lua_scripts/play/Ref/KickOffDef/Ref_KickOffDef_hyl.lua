-- gPlayTable.CreatePlay{

-- firstState = "0",

-- ["0"] = {
-- 	switch = function()
-- 	task.defineBallPos()
-- 		if bufcnt(true,40) then
-- 			return "kaiqiudef0"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(-3000,0)),
-- 	b = task.go2Pos(task.auto_Pos(-3000,-200)),
-- 	c = task.go2Pos(task.auto_Pos(-1000,-1000)),
-- 	d = task.go2Pos(task.auto_Pos(-1500,1000)),
-- 	e = task.go2Pos(task.auto_Pos(-2000,800)),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

-- ["kaiqiudef0"] = {
-- 	switch = function()
-- 		if bufcnt(true,30) then
-- 			return "kaiqiudef1"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(-3000,0)),
-- 	b = task.go2Pos(task.auto_Pos(-3000,-200)),
-- 	c = task.go2Pos(task.auto_Pos(-3000,-400)),
-- 	d = task.go2Pos(task.auto_Pos(-3000,200)),
-- 	e = task.go2Pos(task.auto_Pos(-3000,400)),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

-- ["kaiqiudef1"] = {
-- 	switch = function()
-- 		if bufcnt((ball.pos()-CGeoPoint(0,0)):mod()>400,60) then
-- 			return "kaiqiudef2"
-- 		elseif cond.isGameOn() then
-- 			return "run"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(-3000,0)),
-- 	b = task.go2Pos(task.auto_Pos(-3000,-200)),
-- 	c = task.go2Pos(task.auto_Pos(-3000,-400)),
-- 	d = task.go2Pos(task.auto_Pos(-3000,200)),
-- 	e = task.go2Pos(task.auto_Pos(-3000,400)),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

-- ["kaiqiudef2"] = {
-- 	switch = function()
-- 		if bufcnt(ball.posX()<-6000,60) then
-- 			return "run"
-- 		end
-- 	end,
-- 	a = task.go2Pos(task.auto_Pos(-3000,0)),
-- 	b = task.go2Pos(task.auto_Pos(-3000,-200)),
-- 	c = task.go2Pos(task.auto_Pos(-3000,-400)),
-- 	d = task.go2Pos(task.auto_Pos(-3000,200)),
-- 	e = task.go2Pos(task.auto_Pos(-3000,400)),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

-- ["run"] = {
-- 	switch = function()
-- 		if ball.velMod()>600 then
-- 			return "defAndGetBall"
-- 		end
-- 	end,
-- 	a = task.Yylmarking(1,_,2),
-- 	b = task.Yylmarking(1,2,0),
-- 	c = task.Yylmarking(1,3,0),
-- 	d = task.rdef(),
-- 	e = task.ldef(),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },
-- ["defAndGetBall"] = {
-- 	switch = function()
-- 		if bufcnt(ball.pos()<-4500,30) then
-- 			return "finish"
-- 		end
-- 	end,
-- 	a = task.Yylmarking(1,_,2),
-- 	b = task.Yylmarking(1,2,0),
-- 	c = task.Yylmarking(1,3,0),
-- 	d = task.rdef(),
-- 	e = task.ldef(),
-- 	Goalie = task.goalieDef(),
-- 	match = ""
-- },

-- name = "hyl_kaiqiudef",
-- applicable ={
-- 	exp = "a",
-- 	a = true
-- },
-- attribute = "attack",
-- timeout = 99999
-- }

local duimen = CGeoPoint:new_local(4500,0)

gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if ball.velMod()>800 then
			return "finish"
		end
	end,
	a = task.stop2(0),
	b = task.stop2(1,3000),
	c = task.stop2(2,2000),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = "[abc]"
},

-- ["run"] = {
-- 	switch = function()
-- 		if ball.velMod()>1500 then
-- 			return "defAndGetBall"
-- 		end
-- 	end,
-- 	a = task.Yylmarking(1,_,2),
-- 	b = task.Yylmarking(1,2,0),
-- 	c = task.Yylmarking(1,3,0),
-- 	d = task.rdef(),
-- 	e = task.ldef(),
-- 	Goalie = task.goalieDef(),
-- 	match = "[abc]"
-- },
-- ["defAndGetBall"] = {
-- 	switch = function()
-- 		if bufcnt(ball.toPlayerDist("a")<200 or ball.toPlayerDist("b")<200 or ball.toPlayerDist("c")<200 or ball.toPlayerDist("d")<200 or ball.toPlayerDist("e")<200,20) then
-- 			return "a"
-- 		end
-- 	end,
-- 	a = task.Yylmarking(1,_,2),
-- 	b = task.Yylmarking(1,2,0),
-- 	c = task.Yylmarking(1,3,0),
-- 	d = task.rdef(),
-- 	e = task.ldef(),
-- 	Goalie = task.goalieDef(),
-- 	match = "[abc]"
-- },


-- ["a"] = {
-- 	switch = function()
-- 		if bufcnt(ball.toPlayerDist("a")<200 or ball.toPlayerDist("b")<200 or ball.toPlayerDist("c")<200 or ball.toPlayerDist("d")<200 or ball.toPlayerDist("e")<200,45) then
-- 			return "finish"
-- 		end
-- 	end,
-- 	a = task.Yylmarking(1,_,2),
-- 	b = task.Yylmarking(1,2,0),
-- 	c = task.Yylmarking(1,3,0),
-- 	d = task.rdef(),
-- 	e = task.ldef(),
-- 	Goalie = task.goalieDef(),
-- 	match = "[abc]"
-- },

name = "Ref_KickOffDef_hyl",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}







    -- local l = (ball.pos()-enemy.pos(num)):mod()*0.5
    -- res=enemy.pos(num)+Utils.Polar2Verctor(l,(ball-enemy.pos(num)):dir())





--if (ballpos()-enmey.pos())