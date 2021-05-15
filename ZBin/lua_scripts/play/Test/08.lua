local goal = CGeoPoint:new_local(-4500,0)

local debugMSG = function()
    tadian,td = enemy.nearplayer()
    me = player.pos(0)
    l = (tadian-ball.pos()):mod()-600
    l = l>0 and l or 0
    -- p1 = tadian+Utils.Polar2Vector(l*0.14+130,(ball.pos()-tadian):dir()+math.pi/2)
    -- p2 = tadian+Utils.Polar2Vector(l*0.14+130,(ball.pos()-tadian):dir()-math.pi/2)
    p1 = me+Utils.Polar2Vector(l*0.2+90,player.dir(0)+math.pi/9)
    p2 = me+Utils.Polar2Vector(l*0.2+90,player.dir(0)-math.pi/9)
    
    pl1 = me+Utils.Polar2Vector(3000,(p1-me):dir())
    pl2 = me+Utils.Polar2Vector(3000,(p2-me):dir())
    debugEngine:gui_debug_line(me,pl1,5)
    debugEngine:gui_debug_line(me,pl2,5)
    debugEngine:gui_debug_arc(tadian,l*0.2+90,0,360,5)
    debugEngine:gui_debug_msg(p1,l)
    debugEngine:gui_debug_msg(tadian,math.abs(task.toangle((p1-ball.pos()):dir()-(p2-ball.pos()):dir())))
    if Utils.AngleBetween((me-tadian):dir(),(me-p1):dir(),(me-p2):dir(),0) and (me-tadian):mod()>500  then
        debugEngine:gui_debug_msg(ball.pos(),"true",5)
        return true
    end	
   
end

gPlayTable.CreatePlay{

firstState = "test1",

["start"] = {
	switch = function()
	debugMSG()
		-- task.defineBallPos()
		if bufcnt(true,60) then
			return "test"
		end
	end,
	a = task.Halt(),
	match = ""
},

["test"] = {
	switch = function()
	debugMSG()
		-- task.defineBallPos()
		if bufcnt(true,60) then
			return "test1"
		end
	end,
	a = task.moving(),
	match = ""
},

["test1"] = {
	switch = function()
	debugMSG()
		-- task.defineBallPos()
		if bufcnt(true,60) then
			return "test1"
		end
	end,
	a = task.getBall(_,150,flag.dribbling),
	match = ""
},
name = "08",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}