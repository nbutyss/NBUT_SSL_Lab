
local debugmsg = function()
	debugEngine:gui_debug_msg(CGeoPoint(0,-3200),(player.pos(3)-ball.pos()):mod())
	return (player.pos(3)-ball.pos()):mod()
end

gPlayTable.CreatePlay{

firstState = "try_keep",
["try_keep"] = {
        switch = function()
        task.defineBallPos()
        if bufcnt(true,30) then
            return "try_keep"
        end
            debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"踢球车到球的距离："..player.toBallDist("a"))
        end,
        a = task.moving(),
        -- a = task.Halt(),
        b = task.waitForAttack(),
        c = task.waitForAttack(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[a][bc]"
},
["Halt"] = {
        switch = function()
        task.defineBallPos()
        if bufcnt(true,30) then
            return "try_keep"
        end
            debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"踢球车到球的距离："..player.toBallDist("a"))
        end,
        a = task.Halt(),
        -- a = task.Halt(),
        b = task.Halt(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[a][bc]"
},
-- ["goalie1"] = {
-- 	switch = function()
-- 	debugmsg()
-- 		if true and player.posX(0)<0 then
-- 			return "goalie1"
-- 		end
-- 	end,
-- 	Goalie=task.passBall(CGeoPoint(4500,0),0,85,1),
-- 	match = "{}"
-- },

-- ["goalie2"] = {
-- 	switch = function()
-- 		if player.posX(0)<player.posX(2) and player.posY(0)>player.posY(2)+100 and player.posX(0)>0 then
-- 			return "goalie1"
-- 		end
-- 	end,
-- 	Goalie=task.Halt(),
-- 	-- Goalie=task.raoquanni(),
-- 	-- Receiver=task.raoquanshun(),
-- 	match = "{}"
-- },

name = "hyl008",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
