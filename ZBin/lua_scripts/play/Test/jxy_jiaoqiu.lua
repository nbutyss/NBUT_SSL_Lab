local TestPos = {
	CGeoPoint:new_local(3800,1200),
	CGeoPoint:new_local(2500,-600),
	CGeoPoint:new_local(2000,1200)
}
-- local d =function(role)
-- 	-- body
-- 	return function()
-- 		return dir.playerToBall(role)
-- 	end
-- end 
-- local toball = function(dist,role)
-- 	return function()
-- 		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - player.pos(role)):dir())
-- 		return pos
-- 	end
-- end

-- local pos = function(x,y)
-- 	return function()
-- 	if ball.posY()<0 then
-- 		local p = CGeoPoint:new_local(4000,1200)
-- 	else
-- 		local p = CGeoPoint:new_local(4000,-1200)
-- 	end
-- 	return p
-- end
gPlayTable.CreatePlay{

firstState = "first",

["first"] = {
	switch = function()
task.defineBallPos()
		-- angle = angle + math.pi*2/60*speed
		--if bufcnt(player.toTargetDist('a')<10,10) then
		if player.toBallDist("a")<350 then
			return "gotoball"
		end
	end,
	--a = task.goCmuRush(toball(20,"a"), d("b")),
	a = task.getBall(TestPos[1]),--a车拿球朝向点1
	b = task.go2Pos(task.auto_Pos(3500,1200)),--b车去点1
	--b = task.go2Pos(pos(4000,1200)),
	match = "{ab}"
},

["gotoball"] = {
	switch = function()
	task.defineBallPos()
		-- angle = angle + math.pi*2/60*speed
		--if bufcnt(player.toTargetDist('a')<10,10) then
		if bufcnt(player.toBallDist("a")<250,60) then
			return "passball"
		end
	end,
	--a = task.goCmuRush(toball(20,"a"), d("b")),
	a = task.getBall(TestPos[1]),--a车拿球朝向点1
	b = task.go2Pos(task.auto_Pos(3500,1200)),--b车去点1
	--b = task.go2Pos(pos(4000,1200)),
	match = "{ab}"
},
--auto_Pos
["passball"] = {
	switch = function()
		if bufcnt(player.toBallDist("a")>300,0) then
			return "getball"
		end
	end,
	a = task.myShoot(TestPos[1],300,90),--a车朝向点1踢球
	b = task.go2Pos(task.auto_Pos(3500,1200)),--b车去点1
	--b = task.go2Pos(pos(4000,1200)),
	match = "{ab}"
},

["getball"] = {
	switch = function()
		if bufcnt(player.toBallDist("b")<350,30) then
			return "shoot"
		end
	end,
	a = task.go2Pos(TestPos[2]),--a车去点2
	b = task.receive(),--b车接球
	match = "{ab}"
},

["shoot"] = {
	switch = function()
		--if bufcnt(player.toBallDist("b")>350,100) then
		if bufcnt(true,600) then
			return "gotoball"
		end
	end,
	a = task.go2Pos(TestPos[2]),--a车去点2
	b = task.myShoot(CGeoPoint:new_local(4500,0)),--b车射门
	match = "{ab}"
},



name = "jxy_jiaoqiu",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}