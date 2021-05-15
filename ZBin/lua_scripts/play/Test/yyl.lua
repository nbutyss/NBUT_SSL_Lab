local duimen = CGeoPoint:new_local(4500,0)

gPlayTable.CreatePlay{

firstState = "0",

["0"] = {
	switch = function()
	task.defineBallPos()
	-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-param.pitchLength*2/5, param.pitchWidth/2-1000),gdir)
		if ball.velMod()>800 then
			return "run"
		end
	end,
	c = task.stop2(0),
	b = task.stop2(1,3000),
	a = task.stop2(2,2000),
	d = task.ldef(),
	e = task.rdef(),
	Goalie = task.goalieDef(),
	match = ""
},

["run"] = {
	switch = function()
		if ball.velMod()>1500 then
			return "defAndGetBall"
		end
	end,
	c = task.Yylmarking(1,_,1),
	b = task.Yylmarking(1,2,0),
	a = task.Yylmarking(1,3,0),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = ""
},
["defAndGetBall"] = {
	switch = function()
		if bufcnt(ball.toPlayerDist("a")<200 or ball.toPlayerDist("b")<200 or ball.toPlayerDist("c")<200 or ball.toPlayerDist("d")<200 or ball.toPlayerDist("e")<200,20) then
			return "a"
		end
	end,
	c = task.Yylmarking(1,_,1),
	b = task.Yylmarking(1,2,0),
	a = task.Yylmarking(1,3,2),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = ""
},


["a"] = {
	switch = function()
		if bufcnt(ball.toPlayerDist("a")<200 or ball.toPlayerDist("b")<200 or ball.toPlayerDist("c")<200 or ball.toPlayerDist("d")<200 or ball.toPlayerDist("e")<200,45) then
			return "finish"
		end
	end,
	c = task.Yylmarking(1,_,1),
	b = task.Yylmarking(1,2,0),
	a = task.Yylmarking(1,3,2),
	d = task.rdef(),
	e = task.ldef(),
	Goalie = task.goalieDef(),
	match = ""
},

name = "yyl",
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