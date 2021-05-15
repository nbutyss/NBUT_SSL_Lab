local d1=function (  )
	return function ( )
	local res
	res=( CGeoPoint(2000,-2000) - player.pos("b")    ):dir()
	return	 res
	end
end

local c1=function (  )
	return function ( )
	local res
	res=(CGeoPoint(2000,-2000) - ball.pos()):dir()
	return	 res
	end
end
local a1=function ( )
	return function ( )
	local res
	res=ball.pos()+Utils.Polar2Vector(300,(ball.pos()-CGeoPoint(2000,-2000)):dir())
	return	 res
	end
end
local b1=function (  )
	return function ( )
	local res
	res=ball.pos()+Utils.Polar2Vector(30,(player.pos("b")- ball.pos()):dir())
	return	 res
	end
end

local debugMSG = function()
	-- debugEngine:gui_debug_msg(CGeoPoint(2000,-2000),1)
	debugEngine:gui_debug_arc(CGeoPoint(2000,-2000),150,0,360,1)
end

local a2=function (  )
	return function ( )
	local res
	res=ball.pos()+Utils.Polar2Vector(300,(ball.pos()-player.pos("b")):dir())
	return	 res
	end
end
local e1=function (  )
	return function ( )
	local res
	res=ball.pos()+Utils.Polar2Vector(500,(   ball.pos()-CGeoPoint(2000,-2000)):dir())
	return	 res
	end
end
local b2=function (  )
	return function ( )
	local res
	res=ball.pos()+Utils.Polar2Vector(75,(player.pos("b")-ball.pos()):dir())
	return	 res
	end
end
local d2=function (  )
	return function ( )
	local res
	res=( player.pos("b")-ball.pos()):dir()
	return	 res
	end
end
local c2=function (runner)
	return function ()
		local res 
		res=player.pos(runner)
		return res
	end
end
local  e2 =function (runner)
	return function ()
		local res
		res=(player.pos("a")-player.pos("b")):dir()
		return res
	end
end

gPlayTable.CreatePlay{
firstState = "run1",
["run1"] = {
	switch = function()
	if task.bufcnt(true,30) then
		return "run2"
	end
	end,
	a=task.goCmuRush(c2("a")),
	b=task.goCmuRush(c2("b")),
	match = "{ab}"
},
["run2"] = {
	switch = function()
	if bufcnt(player.toTargetDist("a")<100,30) then
		return "run3"
	end
	end,

	a =task.goCmuRush(a2(),d2(),_,flag.dodge_ball+flag.allow_dss),
	b =task.goCmuRush(c2("b"),e2()),
	match = "{ab}"
},
["run3"] = {
	switch = function()
	if bufcnt(player.toBallDist("a")<100,60) then
		return "run4"
	end
	end,

	a =task.goCmuRush(b2(),d2(),_,flag.dribbling),
	b =task.goCmuRush(c2("b"),e2()),
	match = "{ab}"
},
["run4"] = {
	switch = function()
	if bufcnt(player.toBallDist("b")<150,30) then
		return "run5"
	end
	end,

	a = task.shoot(c2("a"),d2(),_,6000),
	b = task.receive(),
	match = "{ab}"
},
-- ["run2"] = {
-- 	switch = function()
-- 	if  then

-- 	end
-- 	end,

-- 	a = 
-- 	b = 
-- 	match = "{ab}"
-- },
-- ["run3"] = {
-- 	switch = function()
-- 	if  then

-- 	end
-- 	end,

-- 	a = 
-- 	b = 
-- 	match = "{ab}"
-- },

-- ["run1"] = {

-- 	switch = function()
-- 		debugMSG()
-- 	if task.bufcnt(true,30) then
-- 		return "run2"
-- 	end
-- 	end,
-- 	a=player.pos("a"),
-- 	match = "{a}"
-- },
["run5"] = {
	
	switch = function()
	debugMSG()
	if bufcnt(player.toTargetDist("b")<150,30) then
		return "run6"
	end
	end,
	a=task.goCmuRush(c2("a")),
	b=task.goCmuRush(a1(),d1(),_,flag.dodge_ball+flag.allow_dss),
	match = "{ab}"
},
-- ["run3"] = {
	
-- 	switch = function()
-- 	debugMSG()
	
-- 	end,
-- 	a=task.goCmuRush(a(),d(),_,flag.dribbling),
-- 	match = "{a}"
-- },
--
-- ["run2"] = {
	
-- 	switch = function()
-- 	debugMSG()
-- 	if bufcnt(player.toTargetDist("a")<100,30) then
-- 		return "run3"
-- 	end
-- 	end,
-- 	a=task.fangqiu("a"),
-- 	match = "{a}"
-- },
["run6"] = {
	switch = function()
	debugMSG()

	-- if bufcnt((CGeoPoint(2000,-2000)-ball.pos()):mod()<150,30) then
	if (CGeoPoint(2000,-2000)-ball.pos()):mod()<150 then
		return "run7" 
	end
	end,
	a=task.goCmuRush(c2("a")),
	b=task.goCmuRush(b1(),c1(),_,flag.dribbling),
	match = "{ab}"
},
-- ["run7"] = {
-- 	switch = function()
-- 	debugMSG()

-- 	-- if player.toBallDist("a")>200 then
-- 	-- 	return "run2"
-- 	-- else
-- 	if bufcnt((CGeoPoint(2000,-2000)-ball.pos()):mod()<150,10)   then
-- 		return "run8"
-- 	end
-- 	end,
-- 	a=task.goCmuRush(c2("a")),
-- 	b=task.goCmuRush(b1(),c1(),_,flag.dribbling),
-- 	match = "{ab}"
-- },
["run7"] = {
	switch = function()
	debugMSG()
    if (CGeoPoint(2000,-2000)-ball.pos()):mod()>150 then
    return "run5"
    end
	end,
	a=task.goCmuRush(c2("a")),
	b=task.goCmuRush(e1(),c1()),
	match = "{ab}"
},

name = "FQTest",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
