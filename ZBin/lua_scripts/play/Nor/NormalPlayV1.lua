local standPos =  {
        CGeoPoint:new_local(1000,1000),
        CGeoPoint:new_local(4500,0),
        CGeoPoint:new_local(-1000,1000),
        CGeoPoint:new_local(-1000,-1000),
        CGeoPoint:new_local(1000,-1000)
}
local iscanshoot = function(role)
        if true then
                return false
        else
                return true
        end
end
local PI = 3.1415926535897932
local shootGen = function(dist)
        return function()
                local goalPos = CGeoPoint(4500,0)
                local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
                return pos
        end
end



local DSS_FLAG = flag.allow_dss + flag.dodge_ball

local JUDGE = {
        BallInField = function()
                local x = ball.posX()
                local y = ball.posY()
                local mx = param.pitchLength
                local my = param.pitchWidth
                if not ball.valid() then
                        return false
                end
                if x > mx or x < -mx or y > my or y < -my then
                        return false
                end
                if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
                        return false
                end
                return true
        end,
}


local debugMSG = function(role)
    tadian,td = enemy.nearplayer(role)
    me = player.pos(role)
    l = (tadian-ball.pos()):mod()-600
    l = l>0 and l or 0
    -- p1 = tadian+Utils.Polar2Vector(l*0.14+130,(ball.pos()-tadian):dir()+math.pi/2)
    -- p2 = tadian+Utils.Polar2Vector(l*0.14+130,(ball.pos()-tadian):dir()-math.pi/2)
    p1 = me+Utils.Polar2Vector(l*0.2+90,player.dir(role)+math.pi/9)
    p2 = me+Utils.Polar2Vector(l*0.2+90,player.dir(role)-math.pi/9)
    pl1 = me+Utils.Polar2Vector(3000,(p1-me):dir())
    pl2 = me+Utils.Polar2Vector(3000,(p2-me):dir())
    debugEngine:gui_debug_line(me,pl1,5)
    debugEngine:gui_debug_line(me,pl2,5)
    debugEngine:gui_debug_arc(tadian,l*0.2+90,0,360,5)
    debugEngine:gui_debug_msg(p1,l)
    debugEngine:gui_debug_msg(tadian,math.abs(task.toangle((p1-ball.pos()):dir()-(p2-ball.pos()):dir())))
    if Utils.AngleBetween((me-tadian):dir(),(me-p1):dir(),(me-p2):dir(),0) and (me-tadian):mod()>450  then
        debugEngine:gui_debug_msg(ball.pos(),"block",5)
        return true
    end 
end

gPlayTable.CreatePlay{

firstState = "run_to_zero",

["run_to_zero"] = {
        switch = function()
        -- debugMSG()
        task.defineBallPos()
            if bufcnt(JUDGE.BallInField(),10) then
                return "prepare"
            end
        end,
        -- a = task.hylniubiAttcak_alpha(75),
        a = task.Halt(),
        b = task.Halt(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[abc]"
}, 


["prepare"] = {
        switch = function()
        task.defineBallPos()
                -- if bufcnt(true,20) then
                if task.smartFindPoint() then
                        return "try_getBall"
                end
        end,
        -- a = task.hylniubiAttcak_alpha(75),
        a = task.Halt(),
        b = task.hylgo2Pos(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[abc]"
},


["try_getBall"] = {
        switch = function()
            task.ifShootLine()
            if debugMSG("a") then
                return "try_keep" 
            elseif ball.toPlayerDist("a")<350 and player.toTargetDist("b")<300 then
                 return "try_kick" 
            end
            debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"踢球车到球的距离："..player.toBallDist("a"))
        end,
        a = task.getBall("b",120),
        -- a = task.Halt(),
        b = task.hylgo2Pos(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[abc]"
},


["try_kick"] = {
        switch = function()
                    task.ifShootLine()
        task.defineBallPos()
            if debugMSG("a") then
                return "try_keep" 
            elseif ball.toPlayerDist("a")>350 then
                return "try_receive" 
            end
            debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"踢球车到球的距离："..player.toBallDist("a"))
        end,
        a = task.hylniubiAttcak_alpha(87),
        b = task.hylgo2Pos(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[abc]"
},

["try_keep"] = {
        switch = function()
        task.ifShootLine()
        if bufcnt(true,60) then
            return "prepare"
        end
            debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"踢球车到球的距离："..player.toBallDist("a"))
        end,
        a = task.moving(),
        b = task.Halt(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[a][bc]"
},

["try_receive"] = {
        switch = function()
                    task.ifShootLine()
                if bufcnt(player.toBallDist("b")<160,30) then
                        return "try_she"
                end
                debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3200),"接球车到球的距离："..player.toBallDist("b"))
        end,
        a = task.Halt(),
        b = task.receive(),
        c = task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "[abc]"
},

["try_she"] = {
        switch = function()
            task.ifShootLine()
            if bufcnt(task.ifShootLine(),10) then
                return "try_keep"
            end
        end,
        a = task.task.Halt(),
        b = task.canShoot(87,20),
        c = task.task.Halt(),
        d = task.ldef(),
        e = task.rdef(),
        Goalie = task.goalieDef(),
        match = "{abc}"
},

-- ["try_keep"] = {
--      switch = function()
--      task.defineBallPos()
--         if bufcnt(player.toBallDist("a")<300,30) then
--             return "try_kick"
--         elseif bufcnt(true,40) then
--             return "run_to_ball"
--         end
--      end,

--      a = task.moving("a",2000,task.mdir(),flag.dribbling),
--      b = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--      c = task.waitForAttack(),
--      d = task.ldef(),
--      e = task.rdef(),
--      Goalie = task.goalieDef(),
--      match = ""
-- },

-- ["try_kick"] = {
--         switch = function()
--         task.defineBallPos()
--                 -- if bufcnt(not JUDGE.BallInField(),5) then
--                 --      return "run_to_zero"
--                 -- end
--                 if bufcnt(player.toBallDist('a')>400,10) then
--                         return "try_receive"
--                 end
--         end,
--         a = task.canShoot(_,_,_,_,"b"),
--         b = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },
-- -------------------------------------------------------------noshootline!------------------------------------------------------------------
-- ["try_receive"] = {
--         switch = function()
--                 if bufcnt(player.toBallDist('b')<150,10) then
--                         return "run_to_ball"
--                 end
--                 -- if bufcnt(not JUDGE.BallInField(),30) then
--                 --      return "run_to_zero"
--                 -- end
--         end,
--         a = task.goCmuRush(standPos[1], _, _, DSS_FLAG),
--         b = task.receive(standPos[2], _, true),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },
-- ["run_to_ball1"] = {
--         switch = function()
--         task.defineBallPos()
--                 if bufcnt(player.toTargetDist("b")<100,5) then
--                         return "try_dribble1"
--                 elseif bufcnt(true,180) then
--                     return "try_dribble1"
--                 end
--                 -- if bufcnt(not JUDGE.BallInField(),5) then
--                 --      return "run_to_zero"
--                 -- end
--         debugEngine:gui_debug_msg(CGeoPoint:new_local(3000,1000),player.toTargetDist("a"))
--         end,
--         a = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--         b = task.goCmuRush(shootGen(80), _, _,DSS_FLAG),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },

-- ["try_dribble1"] = {
--         switch = function()
--         task.defineBallPos()
--                 if bufcnt(player.toBallDist("b")<300,10) then
--                         return "try_keep1"
--                 elseif bufcnt(true,360) then
--                     return "try_kick1"
--                 end

--                 -- if bufcnt(not JUDGE.BallInField(),5) then
--                 --      return "run_to_zero"
--                 -- end
--         end,
--         a = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--         b = task.goCmuRush(shootGen(58),_,_,flag.dribbling),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },

-- ["try_keep1"] = {
--      switch = function()
--      task.defineBallPos()
--         if bufcnt(player.toBallDist("a")<300,30) then
--             return "try_kick1"
--         elseif bufcnt(true,40) then
--             return "run_to_ball1"
--         end
--              -- if bufcnt(not JUDGE.BallInField(),5) then
--              --      return "run_to_zero"
--              -- end
--      end,

--      a = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--      b = task.moving("b",2000,task.mdir(),flag.dribbling),
--      c = task.waitForAttack(),
--      d = task.ldef(),
--      e = task.rdef(),
--      Goalie = task.goalieDef(),
--      match = ""
-- },

-- ["try_kick1"] = {
--         switch = function()
--         task.defineBallPos()
--                 -- if bufcnt(not JUDGE.BallInField(),5) then
--                 --      return "run_to_zero"
--                 -- end
--                 if bufcnt(player.toBallDist('b')>400,10) then
--                         return "try_receive1"
--                 end
--         end,
--         a = task.goCmuRush(task.auto_Pos(2000,2000), _, _, DSS_FLAG),
--         b = task.canShoot(_,_,_,_,"a"),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },
-- -------------------------------------------------------------noshootline!------------------------------------------------------------------
-- ["try_receive1"] = {
--         switch = function()
--                 if bufcnt(player.toBallDist('a')<150,10) then
--                         return "try_dribble"
--                 end
--                 -- if bufcnt(not JUDGE.BallInField(),30) then
--                 --      return "run_to_zero"
--                 -- end
--         end,
--         a = task.receive(standPos[2], _, true),
--         b = task.goCmuRush(standPos[1], _, _, DSS_FLAG),
--         c = task.waitForAttack(),
--         d = task.ldef(),
--         e = task.rdef(),
--         Goalie = task.goalieDef(),
--         match = ""
-- },
name = "NormalPlayV1",
applicable ={
        exp = "a",
        a = true
},
attribute = "attack",
timeout = 99999
}