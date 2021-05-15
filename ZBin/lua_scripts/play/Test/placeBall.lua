-- local ballplace = CGeoPoint(0,0)
local ballplace = ball.placementPos()
local myReceivePlace = function(p)
	return ballplace + Utils.Polar2Vector(105,(ballplace-ball.pos()):dir())
end

local dd = function(role)
	return function ()
		return (ballplace-player.pos(role)):dir()
	end
end



local ahead = function(role)
	return function ()
		return player.pos(role)+Utils.Polar2Vector(20,(ballplace-player.pos(role)):dir())
	end
end

local backPlace = function()
	return function()
		return ball.pos()+Utils.Polar2Vector(300,(player.pos("b")-ball.pos()):dir())
	end
end

local finalPlace = 1

ballX = 0

-- local p = ball.placementPos()
local debugMsg = function()
	debugEngine:gui_debug_msg(ballplace,"_")
	debugEngine:gui_debug_arc(ballplace,150,0,360,1)
	debugEngine:gui_debug_msg(CGeoPoint(0,0),player.toBallDist("b"))
	tt = player.pos("b")+Utils.Polar2Vector(80,player.dir("b"))
	-- debugEngine:gui_debug_msg(CGeoPoint(-3000,1000),p:x())
	debugEngine:gui_debug_msg(CGeoPoint(0,-200),"car:"..player.posX("b"))
	debugEngine:gui_debug_msg(CGeoPoint(0,-400),"carFront:"..(tt-ball.pos()):mod())
	debugEngine:gui_debug_msg(CGeoPoint(0,-600),"vball:"..ball.velMod())


	if ((tt-ball.pos()):mod()<40) then
		debugEngine:gui_debug_arc(tt,25,0,360,3)
		return false
	else
		return true
	end


end

gPlayTable.CreatePlay{

firstState = "start",

["start"] = {
	switch = function()
		debugMsg()
		if bufcnt(true,10) then
			return "getBall"
		end
	end,
	a = task.Halt(),
	b = task.Halt(),
	match = "[ab]"
},

["getBall"] = {

	switch = function()
		debugMsg()
		if player.toTargetDist("b")<50 and player.toTargetDist("a")<50 then
			return "pass"
		end
	end,
	a = task.getBall(ballplace),
	b = task.go2Pos(myReceivePlace),
	match = "{ab}"
},

["pass"] = {
	switch = function()
		debugMsg()
		if ball.toPlayerDist("a")>400 then
			return "myReceive"
		end
	end,
	a = task.passBall(ballplace,4000,85),
	b = task.go2Pos(myReceivePlace()),
	match = "{ab}"
},

["myReceive"] = {
	switch = function()
		debugMsg()
		if bufcnt(ball.toPlayerDist("b")<450,30) then
			return "drawback"
		end
	end,
	a = task.stop(),
	b = task.receive(),
	match = "{ab}"
},

["drawback"] = {
	switch = function()
		debugMsg()
		if ball.toPlayerDist("b")>200 then --如果已经远离球 转 judge
			return "judge"
		end
	end,
	a = task.stop(),
	b = task.go2Pos(backPlace()),  --后退远离球
	match = "{ab}"
},

["judge"] = {
	switch = function()
		debugMsg()
		if (ball.pos()-ballplace):mod()<140 then --如果抵达目标点（目标范围） 转stop
			return "stop"
		elseif bufcnt(player.toTargetDist("b")<50,60) then --否则认为车没有到达目标点，当车成功getball 进入推球状态
			return "push"
		end
	end,
	a = task.stop(),
	b = task.getBall(ballplace),  --调整位置 getball拿球
	match = "{ab}"
},

["push"] = {
	switch = function()
		debugMsg()
		if (ball.pos()-ballplace):mod()<100 then --如果抵达目标点（较小范围） 后退 转drawback
			return "drawback"
		elseif bufcnt(player.toBallDist("b")<65 or debugMsg(),30) then --如果丢失图像，且车球
			return "pushforward"
		end
	end,
	a = task.stop(),
	b = task.pushBall(ballplace,60,flag.dribbling),
	match = "{ab}"
},

["pushforward"] = {
	switch = function()
		debugMsg()
		if  bufcnt(player.toBallDist("b")>75,30) then  --如果球的视觉信号正常 或者已经推球行进一段距离 停下并停止吸球
			return "stop"
		end
	end,
	a = task.stop(),
	b = task.goCmuRush(ahead("b"),dd("b"),_,flag.dribbling),
	match = "{ab}"
},

["drawbackforlost"] = {
	switch = function()
		debugMsg()
		if ball.toPlayerDist("b")>200 then --如果已经远离球 转 judge
			return "judge"
		end
	end,
	a = task.stop(),
	b = task.drawBack(ballplace,60),  --后退远离球
	match = "{ab}"
},

["stop"] = {
	switch = function()
		debugMsg()
		if bufcnt((ball.pos()-ballplace):mod()<150,60) then
			return "finalPlace"
		elseif bufcnt(true,60) then
			return "drawbackforlost"
		end
	end,
	a = task.Halt(),
	b = task.Halt(),
	match = "{ab}"
},

["finalPlace"] = {
	switch = function()
		debugMsg()
		if ball.toPlayerDist("b")>500 and ball.toPlayerDist("a")>500 then --如果已经远离球 转 judge
			return "stop"
		end
	end,
	a = task.drawBack(ballplace,20),
	b = task.getBall("a",600),  --后退远离球
	match = "{ab}"
},


name = "placeBall",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}