module(..., package.seeall)


local PI = 3.1415926535897932
local goal=CGeoPoint:new_local(-4500,0)


function getBall(p,dist,f,a)
	local ipos = function(runner)
		local res
		local idist = dist or 300
		if p ~=nil then
			if type(p) == "string" then
				tar = (ball.pos()-player.pos(p)):dir()
				-- debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),player.posX(p))
			elseif type(p) == "function" then
				tar = (ball.pos()-p()):dir()
			else
				tar = (ball.pos()-p):dir()
			end
		else
			tar = (player.pos(runner) - ball.pos()):dir()
		end
		
		res = ball.pos() + Utils.Polar2Vector(idist,tar)

		if a~=nil then 
			tar = (a-player.pos(runner)):dir()
			res = player.pos(runner) + Utils.Polar2Vector(idist,tar)

		end
		return res
		-- return ball.pos()
		
	end
	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end

	if f ~= nil then
		iflag = f
	else
		iflag = flag.allow_dss + flag.dodge_ball
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}	
end

function drawBack(facing,dist)
	local ipos = function(runner)
		local res
		res = player.pos(runner)+Utils.Polar2Vector(dist,(player.pos(runner)-facing):dir())
		return res
	end

	local idir = function(runner)
		local res
		res = player.dir(runner)
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}	
end

function pushBall(p,dist,f)
	local ipos = function()
		local res
		res = ball.pos()+Utils.Polar2Vector(dist,(ball.pos()-p):dir())
		return res
	end

	local idir = function(runner)
		local res
		res = (p-player.pos(runner)):dir()
		return res
	end

	if f ~= nil then
		iflag = f
	else
		iflag = flag.dribbling
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}	
end




function toAngle(n)
	return n/(math.pi/180)
end

-- mdist = 

myradius1 = 300
myradius2 = 300
myk1 = 5
myk2 = 5


pMSG = {
	f = -1,
	f2 = -1,
	wait = 0,
	check = 1,

}



-- function switch(me,p2,p4,center)
-- 	if math.abs((me-p2):dir()-math.pi/2) < math.pi/10 and  me:x()<center:x() and me:y()>center:y() then
-- 		pMSG.f = 1
-- 		if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
-- 			pMSG.check=1
-- 		end
-- 	elseif math.abs((me-p4):dir()-math.pi/2) < math.pi/10 and me:x()>center:x() and me:y()>center:y() then
-- 		pMSG.f = -1
-- 		if pMSG.check == 1 then
-- 			pMSG.check=0
-- 		end
-- 	end
-- end
-- function switch2(me,p2,p4,center)
-- 	if math.abs((me-p2):dir()+math.pi/2) < math.pi/10 and me:x()<center:x() and me:y()<center:y() then
-- 		pMSG.f2 = -1
-- 		if pMSG.check == 1 then
-- 			pMSG.check=0
-- 		end
-- 	elseif math.abs((me-p4):dir()+math.pi/2) < math.pi/10 and me:x()>center:x() and me:y()<center:y() then
-- 		pMSG.f2 = 1
-- 		if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
-- 			pMSG.check=1
-- 		end
-- 	end
-- end
function myInBetwween(me,p1,p2,buffer)
    tar1 = p1 + Utils.Polar2Vector(500,(p1-p2):dir()+math.pi/10+buffer)
    tar2 = p1 + Utils.Polar2Vector(500,(p1-p2):dir()-math.pi/10+buffer)
    tarDir = (me-p1):dir() 
    tarDir1 = (tar1-p1):dir() 
    tarDir2 = (tar2-p1):dir() 
    -- debugEngine:gui_debug_line(p1,tar1,5)
    -- debugEngine:gui_debug_line(p1,tar2,5)
    -- debugEngine:gui_debug_arc(me,100,0,360,5)
    if Utils.AngleBetween(tarDir,tarDir1,tarDir2,0) then
    	-- debugEngine:gui_debug_msg(p1,"true")
    	return true
    end
    return false
end
function nhy(p2,p3,p4)
	local ipos= function(runner)
		local me = player.pos(runner)
		local center = player.pos(1)
		-- local center = CGeoPoint((p2:x()+p4:x())/2,(p2:y()+p4:y())/2)
		debugEngine:gui_debug_msg(center,pMSG.f)
		local c2_s = p2 + Utils.Polar2Vector(myradius1,(me-p2):dir()-math.pi/myk1)
		local c3_s = center + Utils.Polar2Vector(myradius2,(me-center):dir()-math.pi/myk2)
		local c3_n = center + Utils.Polar2Vector(myradius2,(me-center):dir()+math.pi/myk2)
		local c4_n = p4 + Utils.Polar2Vector(myradius1,(me-p4):dir()+math.pi/myk1)
		local ang = (me-center):dir()
		if myInBetwween(me,p2,p4,-math.pi/2) then
			pMSG.f = 1
			if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
				pMSG.check=1
			end
		elseif myInBetwween(me,p4,p2,math.pi/2) then
			pMSG.f = -1
			if pMSG.check == 1 then
				pMSG.check=0
			end
		end
		if pMSG.f == 1 then
			if (center-p4):mod()<(me-p4):mod() then
				res = c3_s
			else
				res = c4_n
			end
		else
			if (center-p2):mod()<(me-p2):mod() then
				res = c3_n
			else
				res = c2_s
			end
		end
		return res
	end
	local idir = function(runner)
		local res
		res = player.velDir(runner)
		debugEngine:gui_debug_msg(CGeoPoint(-1000,1000),res)
		return res
	end
	local mexe, mpos = SimpleGoto{pos = ipos, dir = idir, flag = flag.not_avoid_our_vehicle}
	return {mexe, mpos}
end


function nhy2(p2,p3,p4)
	local ipos= function(runner)
		local me = player.pos(runner)
		local center = player.pos(0)
		-- local center = CGeoPoint((p2:x()+p4:x())/2,(p2:y()+p4:y())/2)
		debugEngine:gui_debug_msg(center,pMSG.f2)
		local c2_n = p2 + Utils.Polar2Vector(myradius1,(me-p2):dir()+math.pi/myk1)
		local c3_s = center + Utils.Polar2Vector(myradius2,(me-center):dir()-math.pi/myk2)
		local c3_n = center + Utils.Polar2Vector(myradius2,(me-center):dir()+math.pi/myk2)
		local c4_s = p4 + Utils.Polar2Vector(myradius1,(me-p4):dir()-math.pi/myk1)
		local ang = (me-center):dir()
		if myInBetwween(me,p2,p4,math.pi/2) then
			pMSG.f2 = -1
			if pMSG.check == 1 then
				pMSG.check=0
			end
		elseif myInBetwween(me,p4,p2,-math.pi/2) then
			pMSG.f2 = 1
			if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
				pMSG.check=1
			end
		end
		if pMSG.f2 == 1 then
			if (center-p2):mod()<(me-p2):mod() then
				res = c3_s
			else
				res = c2_n
			end
		else
			if (center-p4):mod()<(me-p4):mod() then
				res = c3_n
			else
				res = c4_s
			end
		end
		return res
	end
	local idir = function(runner)
		local res
		res = player.velDir(runner)
		debugEngine:gui_debug_msg(CGeoPoint(-1000,800),res)
		return res
	end
	local mexe, mpos = SimpleGoto{pos = ipos, dir = idir, flag = flag.not_avoid_our_vehicle}
	return {mexe, mpos}
end



function stop2(n,dist)--0,1,2,3...
	local iflag = flag.allow_dss + flag.dodge_ball
	local ourGoal = CGeoPoint:new_local(-4500,0)
    local ipos = function(runner)
    	local idist = dist or 650 
        if(ball.posY()>0) then 
            tar = (ourGoal-ball.pos()):dir()+(math.pi/10)*n
		    p = ball.pos() + Utils.Polar2Vector(idist,tar)
		else
		   tar = (ourGoal-ball.pos()):dir()-(math.pi/10)*n
		    p = ball.pos() + Utils.Polar2Vector(idist,tar)
		end  
		if p:y()<-2800 then
		    p=CGeoPoint:new_local(p:x(),-2800)
		end
		if p:y()> 2800 then
			p=CGeoPoint:new_local(p:x(),2800)
	    end
		if p:x()> 3200 then
			p=CGeoPoint:new_local(3200,p:y())
	    end
	    if p:x()< -4400 then
			p=CGeoPoint:new_local(-4400,p:y())
	    end
        return p
    end
    local idir =function(runner)
        local res 
        res = (ball.pos() - player.pos(runner)):dir()
		return res
    end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
end
box={}

Iflag={
	a=0,
	b=0
}

function theShort(xmin,xmax,ymin,ymax)
	local between = function(a,min,max)
			if a > min and a < max then
				return true
			end
			return false
	end
    local num =-1
    local j = 0
    for i=0,param.maxPlayer-1 do
		if enemy.valid(i) and between(enemy.posX(i),xmin,xmax) and between(enemy.posY(i),ymin,ymax) then
			if(j==0) then
				box[1]=i
				j=j+1
			elseif(j==1) then
			    box[2]=i
			    j=j+1
			elseif(j==2) then
			    box[3]=i
			    j=j+1
			elseif(j==3) then
			    box[4]=i
			    j=j+1
			elseif(j==4) then 
				box[5]=i
				j=j+1
			else
			    box[6]=i
			    j=j+1	
			end    
		end
	end
	local mid
	for i=1,j do
	    for z=1 ,j-i do
	        if (enemy.pos(box[z])-ball.pos()):mod()>(enemy.pos(box[z+1])-ball.pos()):mod() then
                mid=box[z]
                box[z]=box[z+1]	
                box[z+1]=mid
            end
        end
    end
end

function lorR()
	if ball.posY()>0 then 
		Iflag.b=1
	else
		Iflag.b=0
	end	
		return true
end	

function zero()
	Iflag.a=0
end

function defCorner(n,dist)--0,1,2,3...
	local ourGoal = CGeoPoint(-4500,0)
	local between = function(a,min,max)
			if a > min and a < max then
				return true
			end
			return false
	end
	local idist = dist or 700 
	local p =ball.pos()
	-- local iflag = flag.allow_dss + flag.dodge_ball
	local j=0
    local ipos =function(runner)
    	if ball.velMod()>650 then
    		Iflag.a=1
    	end	
    	if Iflag.a==0 and n==5 then
    		if Iflag.b==1 then
    		   p=CGeoPoint:new_local(-2800,1700)
    		else 
    		   p=CGeoPoint:new_local(-2800,-1700)
            end
            return p
        end
    	j=0
        for i=0,param.maxPlayer-1 do
		    if enemy.valid(i) and between(enemy.posX(i),-4500,0) and between(enemy.posY(i),-3000,3000) then
	            j=j+1
		    end
	    end 
	    if (j==0 or j==1) then
	    	p = ourGoal +Utils.Polar2Vector(2500,(ball.pos()-ourGoal):dir()-math.pi*n/20)
	    else
		    if n==5 then
		    	num=box[2]
		    end	
		    --debugEngine:gui_debug_msg(CGeoPoint(-2000,n*200),j .. "|||" .. n)
		    if j==2 and n~=5 then
	            if Iflag.b==1 and n==4 then
	            	p = CGeoPoint:new_local(-3400,0)
	            	--debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!33") 
	            else
	   	            p = CGeoPoint:new_local(-4100+(n-3)*220,1150)
	   	            --debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!44") 
	   	        end 
	   	    end
	   	    if n==4 then 
	   	        num=box[3] 	                  
	            p=ourGoal+Utils.Polar2Vector(350,(enemy.pos(box[3])-ourGoal):dir())
	            if p:x()~=0 then
	  	            p=CGeoPoint:new_local(-3400,p:y())
	  	        end
            end
	   	    if (j==3 or j==4 or j==5)and n==3 then
	            num=box[3]       
	   	        if Iflag.b==1 then
	        	    if(enemy.posY(num)<-1100 and enemy.posX(num)<-3500) then
	                    local x=((1100+ball.posY())*(enemy.posX(num)-ball.posX()))/(-enemy.posY(num)+ball.posY())
	                    p=CGeoPoint:new_local(x+ball.posX(),-1150)
	                    if p:x()<-4300 then
	                    p =  CGeoPoint:new_local(-4300,-1150)
	                    end
	                    if(enemy.posX(num)<ball.posX()) then
	  	                    p=CGeoPoint:new_local(-4000,-1100)
	  	                    if p:y()~=0 then
	  	                       p=CGeoPoint:new_local(p:x(),-1100)
	  	                    end
	                    end	
	                    debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!77")     
	                else
	                    p = CGeoPoint:new_local(-4100+(n-3)*220,-1150)
	                    debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!88")     	
	                end 
	            elseif	Iflag.b==0 then
	        	    if(enemy.posY(num)>1100 and enemy.posX(num)<-3500) then
	        	        local x=((1100-ball.posY())*(enemy.posX(num)-ball.posX()))/(enemy.posY(num)-ball.posY())
	                    p=CGeoPoint:new_local(x+ball.posX(),1150)
	                    if p:x()<-4300 then
	                    p =  CGeoPoint:new_local(-4300,1150)
	                    end
	                    if(enemy.posX(num)<ball.posX()) then
	                    	p=ourGoal+Utils.Polar2Vector(350,(enemy.pos(box[3])-ourGoal):dir())
	                    	if p:y()~=0 then
	  	                       p=CGeoPoint:new_local(p:x(),1100)
	  	                    end
	                    end	
	                    debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!22") 
	                else
	                    p = CGeoPoint:new_local(-4100+(n-3)*220,1150) 
	                    debugEngine:gui_debug_msg(CGeoPoint(0,n*200),"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11")    	
	                end  	
	            end
	        end        
	    	if Iflag.b==1 and n==5 then
		        if(enemy.pos(num)-ball.pos()):mod()>600 and enemy.posX(num)<0 then
	                if( enemy.posX(num)>-3500 and enemy.posX(num)<-3700)then
	                	p = CGeoPoint:new_local(enemy.posX(num),enemy.posY(num)+200)
	                else
	                    tar = (ball.pos()-enemy.pos(num)):dir()
			            p = enemy.pos(num)+Utils.Polar2Vector(300,tar)	
			        end
			    else
			    	tar = (ourGoal-ball.pos()):dir()+(math.pi/5)*n
			        p = ball.pos() + Utils.Polar2Vector(idist,tar)
			    end	   
			elseif Iflag.b==0 and n==5  then
			    if(enemy.pos(num)-ball.pos()):mod()>600 and enemy.posX(num)<0 then
	                if( enemy.posX(num)>-3500 and enemy.posX(num)<-3700)then
	                	p = CGeoPoint:new_local(enemy.posX(num),enemy.posY(num)-200)
	                else    
	                	tar = (ball.pos()-enemy.pos(num)):dir()
			            p = enemy.pos(num) + Utils.Polar2Vector(300,tar)
			        end    
			    else
			    	tar = (ourGoal-ball.pos()):dir()-(math.pi/5)*n
			        p = ball.pos() + Utils.Polar2Vector(idist,tar)
			    end       	  
	        end
	    end
        return p 
    end
    local idir =function(runner)
        local res 
        res = (ball.pos() - player.pos(runner)):dir()
		return res
    end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
end

function rchangego2Pos(x,y)
	local place =CGeoPoint(x,y)
	local ipos = place + Utils.Polar2Vector(200,(ball.pos() - place):dir()+math.pi/6)
		--[[local res
		res = place + Utils.Polar2Vector(200,(ball.pos() - place):dir()+math.pi/6)
		return res
	end--]]
	local idir = (ball.pos() - place):dir()-math.pi/6
		--[[local res
		res = (ball.pos() - player.pos(runner)):dir()-math.pi/6
		return res
	end--]]

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir}
	return {mexe, mpos}
end

function lchangego2Pos(x,y)
	local place =CGeoPoint(x,y)
	local ipos = place + Utils.Polar2Vector(200,(ball.pos() - place):dir()-math.pi/6)
		--[[local res
		res = place + Utils.Polar2Vector(200,(ball.pos() - place):dir()-math.pi/6)
		return res
	end--]]
	local idir = (ball.pos() - place):dir()+math.pi/6
		--[[local res
		res = (ball.pos() - player.pos(runner)):dir()+math.pi/6
		return res
	end--]]

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir}
	return {mexe, mpos}
end
--参数说明
-- 不可缺省参数： p 拿球的所朝的目标
-- 可缺省参数：dist 拿球时车和球之间的距离 默认200 这个值因为底层因素不能低于180
--f 控制小车动作的一个标记，通常不填
function go2Pos(p, dir, f)
	local ipos = function(runner)
		local res
		if type(p) == "function" then
			res = p()
		else
			res=p
		end
		return res
	end	

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()

		if dir ~= nil then
			res = dir
		end
		return res
	end

	local iflag
	if f ~= nil then
		iflag = f
	else
		iflag = flag.allow_dss+flag.dodge_ball
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}	
end



--射门函数 cf 吸球嘴到小车几何中心的距离， ll 球到车吸球嘴的距离限制， kp 平射力度
--pre 射门精度 0～720 值越大精度越高 
function canShoot(cf,ll,pre,kp,pos,f)

	local mexe, mpos = CanShoot{carFront=cf,lengthLimit=ll,kickprecision=pre,kickpower=kp,flag=f}
	return {mexe, mpos}
end
function waitForAttack()
	local checkAttacker = function(runner)
		for i=0,param.maxPlayer-1 do
			local dis = (ball.pos()-player.pos(i)):mod()
			if player.valid(i) and dis <1000 and i ~=runner then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(0,i*200),i .. (player.valid(i) and '   T   ' or '   F   ') .. dis)
				return i
			end
		end
		return -1
	end

	local ipos = function(runner)
		local num = checkAttacker(runner)
		local x = 2000
		local y = 500*player.posY(num)/(player.posX(num)-4500) 
		if y>2500 then
			y = 2500
		elseif y<-2500 then
			y= -2500
		end  
		if ball.posX()<1000 then
			Yylmarking(1,2,0)
		end
		return CGeoPoint:new_local(x,y)
	end

	local idir = function(runner)
		return player.toTheirGoalDir(runner)
	end
	if ball.posX()<1000 then
		return Yylmarking(1,2,0)
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}	
end

function midPos(x,y)
	return function()
		if ball.posX() > 0 then
			local mx = 3000
			local my = -1000*y/(x-4500)
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,1000),my)
			return CGeoPoint:new_local(mx,my)
		else 
			return ball.pos() + Utils.Polar2Vector(80,(goal - ball.pos()):dir())
		end
	end
end
 function ldef()
	local ipower = power and power or 6000
	local icarFront = carFront or 80
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = kick.chip
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = flag.allow_dss
	local ourgoal = CGeoPoint:new_local(-4500,0)
	local oppgoal = CGeoPoint:new_local(4500,0)
	local goalright = CGeoPoint:new_local(-4500,-500)
	local goalleft = CGeoPoint:new_local(-4500,500)
	local jinleft = CGeoPoint:new_local(-3500,1000)
	local jinright = CGeoPoint:new_local(-3500,-1000)
	local ydist = (ourgoal - jinleft):mod()+100
	local inArea = function ()
		local x = ball.posX()
		local y = ball.posY()
		

		if x > -3550 or x < -4500 or y > 1050 or y < -1050 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"not in!")
			return false
		end
		return true
	end

	local ipos = function(runner)
		local res 
		
		--判断球是否在禁区（在）
		if inArea() then
			local ang = (ball.pos()-ourgoal):dir()
			res = ourgoal + Utils.Polar2Vector(ydist,ang+math.pi/53)
			
		--判断球是否在禁区（不在）
		else
			--判断球是否在靠近禁区的站位（在）
			if ball.posX()<=-2700  and math.abs(ball.posY())<=1500 then
				local nearestpost,enemydir = enemy.nearest()
				--enemy get ball（yes）
				if (ball.pos() - nearestpost):mod()<200 then
				-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),ball.velMod())

					
					--fuck oppcar
					local ang = (ourgoal - ball.pos()):dir()
					res = ball.pos()+ Utils.Polar2Vector(120,ang-math.pi/10)
				--enemy get ball（no）
				else 
					--back ourgoal
					--[[debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),ball.velMod())
					local ang = (ball.pos()-ourgoal):dir()
					res = ourgoal + Utils.Polar2Vector(ydist,ang+math.pi/53)--]]


					--getball
					local ang = (player.pos(runner)-oppgoal):dir()
					res = ball.pos()+Utils.Polar2Vector(60,ang)
				end
			--断球是否在禁区（不在）
			else 
				--回防站位
				local ang = (ball.pos()-ourgoal):dir()
				res = ourgoal + Utils.Polar2Vector(ydist,ang+math.pi/53)
			
			end
		end
		return res
	end

	local idir = function(runner)
		local epos , edir = enemy.nearest()
		local res
		if (player.pos(runner)-ball.pos()):mod()<200 and (ball.pos()-epos):mod()>200 then
			res = (oppgoal - player.pos(runner)):dir()
		else
			res = (ball.pos() - player.pos(runner)):dir()
		end
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, iflag}
end

 function rdef()
	local iflag = flag.nothing
	local ourgoal = CGeoPoint:new_local(-4500,0)
	local goalright = CGeoPoint:new_local(-4500,-500)
	local goalleft = CGeoPoint:new_local(-4500,500)
	local jinleft = CGeoPoint:new_local(-3500,1000)
	local jinright = CGeoPoint:new_local(-3500,-1000)
	local ydist = (ourgoal - jinleft):mod()+100
	local inArea = function ()
		local x = ball.posX()
		local y = ball.posY()
		

		if x > -3550 or x < -4500 or y > 1050 or y < -1050 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"not in!")
			return false
		end
		return true
	end
	local ipos = function(runner)
		local res 
		
		--判断球是否在禁区（在）
		if inArea() then
			local ang = (ball.pos()-ourgoal):dir()
			res = ourgoal + Utils.Polar2Vector(ydist,ang-math.pi/53)
			
		--判断球是否在禁区（不在）
		else
			--判断球是否在靠近禁区的站位（在）
			if ball.posX()<=-2700  and math.abs(ball.posY())<=1700 then
				local nearestpost,enemydir = enemy.nearest()
				--enemy get ball（yes）
				if (ball.pos()-nearestpost):mod()<200  then
				-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),ball.velMod())

					
					--抢球踢出
					local ang = (ourgoal - ball.pos()):dir()
					res = ball.pos()+ Utils.Polar2Vector(120,ang+math.pi/10)
				--enemy get ball（no）
				else 
					--back ourgoal
					debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),ball.velMod())

					local ang = (ball.pos()-ourgoal):dir()
					res = ourgoal + Utils.Polar2Vector(ydist,ang-math.pi/53)
				end
			--断球是否在禁区（不在）
			else 
				--回防站位
				local ang = (ball.pos()-ourgoal):dir()
				res = ourgoal + Utils.Polar2Vector(ydist,ang-math.pi/53)
			
			end
		end
		return res
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.iflag,rec = r,vel = v}
	return {mexe, mpos}
end


function moving(runner, dist, d, f)
	local idir
	local ipos =  function()
		local pos
		local mdist = dist or 200
		local spos,sdir = enemy.nearest();

		
		if (spos - player.pos(runner)):mod() > 500 then
			pos = player.pos(runner)
		else
			if task.bMsg.f == 1 then
				pos = player.pos(runner) + Utils.Polar2Vector(mdist,sdir - 3*PI/7)
			else
				pos = player.pos(runner) + Utils.Polar2Vector(mdist,sdir + 3*PI/7)
			end
		end

		return pos
	end
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dribbling,rec = r,vel = v}
	return {mexe, mpos}
end

function mdir()
	return function(runner)
		local goal = CGeoPoint:new_local(4500,0)
		local spos,sdir = enemy.nearest();
		if sdir < -PI/2 and sdir > PI/2 then
			return PI
		end
		sdir = sdir + PI
		if sdir > PI then
			sdir = sdir - PI * 2
		end
		local dir
		if task.bMsg.f == 1 then
			dir = sdir + PI/4
			debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,0),dir)
		else
			dir = sdir - PI/4
			debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,0),dir)
		end
		if (spos-player.pos(runner)):mod() > 1000 then
			dir = (goal - ball.pos()):dir()
		end
		return dir
	end
end




--参数说明
-- 不可缺省参数： tar 传球的目标点
-- 可缺省参数：power 平射力度，carFront 小车吸球嘴到小车几何中心的距离，angleimit 允许的精度误差范围在0～180，
	--needChip是否允许跳球，ckpower 挑球力度，f 控制小车动作的一个标记，通常不填






function myShoot(tar,power,dist,carFront,angleLimit,needChip,ckpower,f)
	local ipower = power and power or 6000
	local idist = dist or 105
	local icarFront = carFront or 105
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f or flag.dribbling
	local itar
	debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,2000),ipower)
	local ipos = function(runner)
		local res
		if type(tar) == "string" then 
			itar = player.pos(tar)
		elseif type(tar) == "function" then
			itar = tar()
		else
			itar = tar
		end

		res = ball.pos() + Utils.Polar2Vector(idist,(ball.pos() - itar):dir())
		if player.toBallDist(runner)>200 then
			res=ball.pos() + Utils.Polar2Vector(idist,(player.pos(runner)-ball.pos()):dir())
		end

		return res
		
	end


	local idir = function(runner)
		local res
		if type(tar) == "string" then
			itar = player.pos(tar)
		elseif type(tar) == "function" then
			itar = tar()
		else
			itar = tar
		end
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>20 then
			itar=ball.pos()
		end
		-- if (player.pos(runner)-ball.pos()):mod() > 130 then
		-- 	itar = ball.pos()
		-- end
		res = (itar - player.pos(runner)):dir()
		return res 
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, iflag}
end



-- 接球
--可缺省参数 p接球后朝向 dist 车球距离
function myReceive(tar,dist,needchase)
	local idist = dist or 95
	local ipos = function(runner)
		local res
		
		if player.toBallDist(runner)<300 or ball.velMod()<500 then --to target
			if tar ~=nil then
				if type(tar) == "string" then
					itar = (ball.pos() - player.pos(tar)):dir()
				elseif type(tar) == "function" then
					itar = (ball.pos() - tar()):dir()	
				else
					itar = (ball.pos() - tar):dir()
				end
			else
				itar = (player.pos(runner) - ball.pos()):dir()
			end
			res = ball.pos() + Utils.Polar2Vector(idist,itar)
			chaseLength = math.max(idist,player.toBallDist(runner)*80/100)
			res = ball.pos() + Utils.Polar2Vector(chaseLength,ball.velDir())
		else 
			res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.velDir())
		end
		return res
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end
	f = flag.dribbling
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}	
end


function receive2(power)--zhijieti..yaogaijindu
	local theirGoal = CGeoPoint:new_local(4500,-400)
	local ipower = power and power or 6000
	local ipre =  pre.high
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local ikick = kick.flat
	local iflag =  flag.dribbling
	local ipos = function(runner)
		res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),(ball.vel()):dir()+math.pi/30)
		return res
		-- ret urn ball.pos() + Utils.Polar2Vector(ball.vel():mod(),ball.velDir())
	end

	local idir = function(runner)
		local res
		res = (theirGoal - player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, iflag}	
end

function receiveBallV2(dist)---接球缓冲

	local ipos = function(runner)

		if ball.velMod() > 1500 and ball.toPlayerDist(runner) < 50 then
			return ball.pos() + Utils.Polar2Vector(1000,(player.pos(runner) - ball.pos()):dir())
		end
		if ball.velMod() < 1500 then
			return ball.pos() + Utils.Polar2Vector(dist,(player.pos(runner) - ball.pos()):dir())
		end
		return ball.pos() + Utils.Polar2Vector((player.pos(runner) - ball.pos()):mod(),ball.velDir())
	end
	local idir = function(runner)
		if ball.velMod() < 500 then
			return (ball.pos() - player.pos(runner)):dir()
		end
		return (ball.pos() - player.pos(runner)):dir()
	end
	local mexe,mpos=GoCmuRush{pos = ipos,dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe,mpos}
end

function goalieDef(carFront,f)
	local plentyKick = f and f or false
	local dist = 80
	local ourGoal = CGeoPoint:new_local(-4500,-100)
	local icarFront = carFront or 92
	local drawDebug = function()
		local turn = ball.velDir()>0 and 1 or -1
		local p1 = CGeoPoint:new_local(-4500,-520)
		local p2 = CGeoPoint:new_local(-4500,520)
		local p3 = CGeoPoint:new_local(-4500,1050)
		local p4 = CGeoPoint:new_local(-3450,1050)
		local p5 = CGeoPoint:new_local(-3450,-1050)
		local p6 = CGeoPoint:new_local(-4500,-1050)
		debugEngine:gui_debug_line(p3,p4,4)
		debugEngine:gui_debug_line(p4,p5,4)
		debugEngine:gui_debug_line(p5,p6,4)
		debugEngine:gui_debug_line(p6,p3,4)
		debugEngine:gui_debug_line(p1,p2,3)
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir())),"_")
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,0),turn)
	end

	local checkNum = function()
		local num = -1
		for i=0,param.maxPlayer-1 do
			if enemy.valid(i)then
				num=i
			end
		end
		return num
	end

	local num = 0
	local GetballNum =function()
		local min = 9999
	    for j=0,param.maxPlayer-1 do 
	        if enemy.valid(j) then
				if (enemy.pos(j)-ball.pos()):mod()<min  then
					min=(enemy.pos(j)-ball.pos()):mod()
					num=j
				end
			end    
		end
	end

	local inArea = function ()
		local x = ball.posX()
		local y = ball.posY()
		if x > -3550 or x < -4500 or y > 1050 or y < -1050 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"not in!")
			return false
		end
		return true
	end

	local ipos = function(runner)
		-- drawDebug()
		local between = function(a,min,max)
			if a > min and a < max then
				return true
			end
			return false
		end
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,1500),"hitpos:" .. ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir()))
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),"velMod:" .. ball.velMod())
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2500),"velY:" .. ball.velX())

		local BallInField = function()
			GetballNum()
			local x = ball.posX()
			local y = ball.posY()
			local mx = param.pitchLength/2
			local my = param.pitchWidth/2
			if x > mx or x < -mx or y > my or y < -my then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),"false")
				return false
			end
			if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),"false")
				return false
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0,-2000),"true "..x.."|"..y.."|"..mx.."|"..my)
			return true
		end

		local enemynum = checkNum()
		BallInField()

		if BallInField() and between(ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir()),-5500,5500) and ball.velX() < 0 and ball.velMod() > 2000 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,2000),1)
			res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.velDir())
		elseif inArea() and ball.velMod()<2000 then
			res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - CGeoPoint:new_local(4500,0)):dir())
			if player.toBallDist(runner)>200 then
				res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,0),0)
		elseif ball.velMod()<2000 and between(ball.posY()-(ball.posX() +4500)*math.tan(enemy.dir(num)),-400,400)then
			res = CGeoPoint:new_local(-4300,ball.posY()-(ball.posX() +4500)*math.tan(enemy.dir(num))) 
		elseif BallInField() then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,-2000),2)
			res = ball.pos() + Utils.Polar2Vector((ball.pos()-ourGoal):mod()-450,(ourGoal-ball.pos()):dir())
		else
			res = CGeoPoint:new_local(-4300,0)
		end
		
		if plentyKick then
			if res:x()>-4410 then
				res= CGeoPoint:new_local(-4450,res:y())
			end
		else
			if res:x()<-4450 then
				res= CGeoPoint:new_local(-4400,res:y())
			end
		end
		return res 
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()

		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()<25 and inArea() then
			res = (CGeoPoint:new_local(4500,0) - ball.pos()):dir()
		end
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc =a , flag = flag.dribbling,rec = r ,vel = vel}
	return {mexe, mpos, kick.flat, idir, pre.high, kp.specified(8000), cp.full, flag.dribbling}
end

function goalieDef_test(carFront,f)
	local plentyKick = f or false
	local ourGoal = CGeoPoint:new_local(-4500,-100)
	local icarFront = carFront or 105
	local drawDebug = function()
		local turn = ball.velDir()>0 and 1 or -1
		local p1 = CGeoPoint:new_local(-4500,-520)
		local p2 = CGeoPoint:new_local(-4500,520)
		local p3 = CGeoPoint:new_local(-4500,1050)
		local p4 = CGeoPoint:new_local(-3450,1050)
		local p5 = CGeoPoint:new_local(-3450,-1050)
		local p6 = CGeoPoint:new_local(-4500,-1050)
		debugEngine:gui_debug_line(p3,p4,4)
		debugEngine:gui_debug_line(p4,p5,4)
		debugEngine:gui_debug_line(p5,p6,4)
		debugEngine:gui_debug_line(p6,p3,4)
		debugEngine:gui_debug_line(p1,p2,3)
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir())),"_")
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-3000,0),turn)
	end

	local checkNum = function()
		local num = -1
		for i=0,param.maxPlayer-1 do
			if enemy.valid(i)then
				num=i
			end
		end
		return num
	end

	local num = 0
	local GetballNum =function()
		local min = 9999
	    for j=0,param.maxPlayer-1 do 
	        if enemy.valid(j) then
				if (enemy.pos(j)-ball.pos()):mod()<min  then
					min=(enemy.pos(j)-ball.pos()):mod()
					num=j
				end
			end    
		end
	end

	local inArea = function ()
		local x = ball.posX()
		local y = ball.posY()
		if x > -3550 or x < -4500 or y > 1050 or y < -1050 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"球不在禁区内")
			return false
		end
		-- if x >0 then
		-- 	debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"球不在禁区内")
		-- 	return false
		-- end
		return true
	end

	local ipos = function(runner)
		local res
		drawDebug()

		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1500),"hitpos:" .. ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir()))
		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,2000),"velMod:" .. ball.velMod())
		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,2500),"velY:" .. ball.velX())

		local hitposY = ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir())
		local receivePos = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.velDir())
		local receivePosY_test = ball.posY()-(ball.posX() +math.abs(player.posX(runner)))*math.tan(ball.velDir())
		

		local BallInField = function()
			GetballNum()
			local x = ball.posX()
			local y = ball.posY()
			local mx = param.pitchLength/2
			local my = param.pitchWidth/2
			if x > mx or x < -mx or y > my or y < -my then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,400),"球不在场内")
				return false
			end
			if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,400),"球在对方禁区内")
				return false
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0,-2000),"球在场内 "..x.."|"..y.."|"..mx.."|"..my)
			return true
		end

		local enemynum = checkNum()
		BallInField()


		if BallInField() and between(hitposY,-550,550) and ball.velX() < 0 and ball.velMod() > 2000 then
			--球在场内 / 球的预测落点位于禁区内 / 模速度大于2000
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),"当球在场内 / 球的预测落点位于禁区内 / 模速度大于2000")
			res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.velDir())
			if res:x()<-4430 then
				res= CGeoPoint:new_local(-4400,res:y())
			end
			local receivePos = ball.posY()-(ball.posX() +math.abs(res:x()))*math.tan(ball.velDir())
			res = CGeoPoint(res:x(),receivePos)
		elseif inArea() and ball.velMod()<2500 then
			--球在禁区内 / 模速度小于2000
			res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - CGeoPoint:new_local(4500,0)):dir())
			if player.toBallDist(runner)>200 and ball.velMod()>500 then
				res=ball.pos() + Utils.Polar2Vector(0.8*player.toBallDist(runner),ball.velDir())
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"球在禁区内 / 模速度小于2000")
		elseif ball.velMod()<2000 and between(ball.posY()-(ball.posX() +4500)*math.tan(enemy.dir(num)),-400,400) and (enemy.pos(num)-ball.pos()):mod()<300 then
			--球模速度小于2000 / 敌对机器人面向球门 
			res = CGeoPoint:new_local(-4300,ball.posY()-(ball.posX() +4500)*math.tan(enemy.dir(num))) 
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,-200),"球模速度小于2000 / 敌对机器人面向球门 ")
		elseif BallInField() then
			--球在场内
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,400),"球在场内")
			res = ball.pos() + Utils.Polar2Vector((ball.pos()-ourGoal):mod()-500,(ourGoal-ball.pos()):dir())
			if res:x()>-4200 then
				res= CGeoPoint:new_local(-4200,res:y())
			end
		else
			--球不在场内
			res = CGeoPoint:new_local(-4300,0)
		end
		
		if plentyKick then
			if res:x()>-4410 then
				res= CGeoPoint:new_local(-4450,res:y())
			end
		else
			if res:x()<-4430 then
				res= CGeoPoint:new_local(-4400,res:y())
			end
		end
		return res 
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()

		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()<25 and inArea() then
			res = (CGeoPoint:new_local(4500,0) - ball.pos()):dir()
		end
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc =a , flag = flag.dribbling,rec = r ,vel = vel}
	return {mexe, mpos, kick.flat, idir, pre.specified(0.5), kp.specified(6500), cp.full, flag.dribbling}
end




function Yylmarking(k1,k2,t)
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
	local oppGoal = CGeoPoint:new_local(param.pitchLength/2.0,0)
    local num={-1}
	local GetballNum =function()
		local min1 = 9998
		local min2 = 9999
	    for j=0,param.maxPlayer-1 do 
	        if enemy.valid(j) then
				if (enemy.pos(j)-ball.pos()):mod()<200  then
					num[1]=j
				elseif j~=num[1] then
					if enemy.posX(j)<min1 then
						num[3]=num[2]
						num[2]=j
						min2 = num[3]~=nil and enemy.posX(num[3]) or 9999
						min1 = enemy.posX(j)
					elseif enemy.posX(j)<min2 then
						num[3]=j
						min2=enemy.posX(j)
					end

				end
			end    
		end
		debugEngine:gui_debug_msg(CGeoPoint(2000,800),num[1])
		debugEngine:gui_debug_msg(CGeoPoint(2000,600),num[2])
		debugEngine:gui_debug_msg(CGeoPoint(2000,400),num[3])
	end
    local inArea = function ()
		local x = ball.posX()
		local y = ball.posY()
		if x > -3450 or x < -4500 or y > 1050 or y < -1050 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,200),"not in!")
			return false
		end
		return true
	end
    local ipos = function(runner)
    	local res
    	local l
		GetballNum()
		if inArea() and t~=0 then
			res = ourGoal + Utils.Polar2Vector(2000,(ball.pos()-ourGoal):dir()+math.pi/10)
		elseif t==0 then--chuancha
			l = 200
		    res=enemy.pos(num[k2])+Utils.Polar2Vector(l,(ball.pos()-enemy.pos(num[k2])):dir())
		    if (player.pos(runner)-ball.pos()):mod() > (enemy.pos(num[k2])-ball.pos()):mod() then
		    	res=ball.pos()+Utils.Polar2Vector(80,(ball.pos()-ourGoal):dir())
		    end
	   	elseif t==1 then--menhenaqiude che
			l = ((enemy.pos(num[2])-ourGoal):mod())*0.8
			l = (l<1400) and 1500 or l
			res=ourGoal+Utils.Polar2Vector(l,(enemy.pos(num[2])-ourGoal):dir())  
		elseif t==2 then 
			debugEngine:gui_debug_msg(CGeoPoint(2000,200),"in")
			res = ball.pos()+Utils.Polar2Vector(90,(ball.pos()-oppGoal):dir())

			if ball.posX()<-2000 then
				res = ball.pos()+Utils.Polar2Vector(195,(ball.pos()-oppGoal):dir())
			end
		-- elseif t==2 then--qiangqiu
		-- 	if enemy.posX(num[k1])>-3000 then
		-- 		res=ball.pos()+Utils.Polar2Vector(120,(ball.pos()-enemy.pos(num[k1])):dir())
		-- 	else
		-- 		res=ball.pos()+Utils.Polar2Vector(((ball.pos()-ourGoal):mod())*0.5,(ball.pos()-enemy.pos(num[k1])):dir())
		-- 	end
		else --chushiweizhi
			
		    l = (ball.pos()-enemy.pos(num[k1])):mod()*0.5
		    if l>1000 then
		    	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"l")
		    	res=ball.pos()+Utils.Polar2Vector(l,(enemy.pos(num[k1])-ball.pos()):dir())  	
		    elseif l<=500 then
		    	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"700")
		    	res=ball.pos()+Utils.Polar2Vector(800,(enemy.pos(num[k1])-ball.pos()):dir())
		    else
		    	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"600")
		    	res=ball.pos()+Utils.Polar2Vector(800,(enemy.pos(num[k1])-ball.pos()):dir())
		    end 
		end
		if res:x()>3000 then
			res=CGeoPoint:new_local(3000,res:y())
		end
    	return res
    end

    local idir = function(runner)
    	local res
	   	if t==0 then--chuancha
			res = (enemy.pos(num[k1]) - enemy.pos(num[k2])):dir()
	   	elseif t==1 then--menhenaqiude che
			res = (enemy.pos(num[2]) - ourGoal):dir()        --		res = (ball.pos() - ourGoal):dir()
		elseif t==2 then--qiangqiu
			res = (ball.pos()-player.pos(runner)):dir()
		else --chushiweizhi
			res = (ball.pos()-enemy.pos(num[k1])):dir()
	   	end
    	return res
    end


 --   	if t==0 then--chuancha
	-- 	ipos = function(runner)
	-- 		GetballNum()
	-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1000),num[1])
	-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,800),num[2])
	-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,600),num[3])

	-- 		local res
	--         local l = (enemy.pos(num[k2])-enemy.pos(num[k1])):mod()*0.7
	--         res=enemy.pos(num[k1])+Utils.Polar2Vector(l,(enemy.pos(num[k2])-enemy.pos(num[k1])):dir())
	-- 	    return res
	-- 	end

	-- 	idir = function(runner)
	-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,1000),123)
	-- 	    local res
	-- 		res = (enemy.pos(num[k1]) - enemy.pos(num[k2])):dir()
	-- 		return res
	-- 	end

 --   	elseif t==1 then--menhenaqiude che

	-- 	ipos = function(runner)
	-- 		GetballNum()

		
	-- 		local res
	--         local l = ((ball.pos()-ourGoal):mod())*0.5
	--         res=ball.pos()+Utils.Polar2Vector(l,(ourGoal-ball.pos()):dir())   --  res=enemy.pos(num1)+Utils.Polar2Vector(l,(enemy.pos(num1)-enemy.pos(num2)):dir())
	--         return res 
	-- 		-- return ball.pos()
	-- 	end
		

	-- 	idir = function(runner)
	-- 		-- local  num1= GetballNum()
	-- 		-- local  num2= GetballNum()
			
	-- 		 debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,1000),123)

	-- 	    local res
	-- 		res = (ball.pos() - ourGoal):dir()        --		res = (ball.pos() - ourGoal):dir()
	-- 		return res
	-- 		-- return 0
	-- 	end
	-- elseif t==2 then--qiangqiu
	-- 	if enemy.posX(num[k1])>-3000 then
	-- 	ipos = function(runner)
	-- 		GetballNum()
	-- 		local res
	-- 		res=ball.pos()+Utils.Polar2Vector(120,(ball.pos()-enemy.pos(num[k1])):dir())
	-- 		return res
	-- 	end
	-- 	idir=function(runner)
	-- 		local res
	-- 		res = (enemy.pos(num[k1])-ball.pos()):dir()        --		res = (ball.pos() - ourGoal):dir()
	-- 		return res
	-- 	end
	-- 	else
	-- 	ipos = function(runner)
	-- 		GetballNum()
	-- 		local res
	-- 		res=ball.pos()+Utils.Polar2Vector(((ball.pos()-ourGoal):mod())*0.5,(ball.pos()-enemy.pos(num[k1])):dir())
	-- 		return res
	-- 	end
	-- 	idir=function(runner)
	-- 		local res
	-- 		res = (ball.pos() - ourGoal):dir()         --		res = (ball.pos() - ourGoal):dir()
	-- 		return res
	-- 	end
	-- 	end
	-- else --chushiweizhi
	-- 	ipos = function(runner)
	-- 		GetballNum()
	-- 		local res
	--         local l = (ball.pos()-enemy.pos(num[k1])):mod()*0.5
	--     	if l>1000 then
	--     		res=ball.pos()+Utils.Polar2Vector(l,(enemy.pos(num[k1])-ball.pos()):dir())  	
	--     	elseif l<=500 then
	--     		res=ball.pos()+Utils.Polar2Vector(600,(enemy.pos(num[k1])-ball.pos()):dir())
	--     	else
	--     		res=ball.pos()+Utils.Polar2Vector(500,(enemy.pos(num[k1])-ball.pos()):dir())
	--         end 

	--         return res 
	-- 	end
		
	-- 	idir = function(runner)

			
	-- 		 debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,1000),123)

	-- 	    local res
	-- 		res = (ball.pos()-enemy.pos(num[k1])):dir()
	-- 		return res
	-- 	end
 --   	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dodge_ball,rec = r,vel = v}
	return {mexe, mpos}
end








-- function Yylmarking3(xmin,xmax,ymin,ymax)
-- 	local num = 0
-- 	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
-- 	local drawDebug = function()
-- 		local p1 = CGeoPoint:new_local(xmin,ymin)
-- 		local p2 = CGeoPoint:new_local(xmin,ymax)
-- 		local p3 = CGeoPoint:new_local(xmax,ymin)
-- 		local p4 = CGeoPoint:new_local(xmax,ymax)
-- 		debugEngine:gui_debug_line(p1,p2,4)
-- 		debugEngine:gui_debug_line(p2,p4,4)
-- 		debugEngine:gui_debug_line(p3,p4,4)
-- 		debugEngine:gui_debug_line(p3,p1,4)


-- 		-- local turn = ball.velDir()>0 and 1 or -1
-- 		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir())),0)
-- 		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,2000),turn)
-- 	end

	

-- 	-- local checkNum = function()
-- 	-- 	local between = function(a,min,max)
-- 	-- 		if a > min and a < max then
-- 	-- 			return true
-- 	-- 		end
-- 	-- 		return false
-- 	-- 	end
-- 	-- 	-- drawDebug()
        
--  --        local aaa=-1
-- 	-- 	local i =-1
-- 	-- 	for i=0,param.maxPlayer-1 do
-- 	-- 		if enemy.valid(i) then
-- 	-- 			aaa=i
-- 	-- 		    Numarray[i]=aaa
-- 	-- 		end
-- 	-- 	end
-- 	-- 	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,1000),Numarray[2])
--  --    end
	
--     local num1 =-1
--     local num2
--     local num3
-- 	local GetballNum =function()
--     local j = 1
-- 	    for j=0,param.maxPlayer-1 do 
-- 	        if enemy.valid(j) then
-- 				if (enemy.pos(j)-ball.pos()):mod()<200  then
-- 					num1=j
-- 				elseif j~=num1 then
-- 					num2=j
-- 				elseif j~=num1 and j~=num2 then
-- 					num3=j
-- 				end
-- 			end    
-- 		end
-- 	end
    

-- 	local ipos = function(runner)
-- 		drawDebug()
-- 		GetballNum()
-- 		-- -- checkNum()
-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(400,1000),num2)
-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(600,1000),num1)
	
-- 		local res
--         local l = ((ball.pos()-ourGoal):mod())*0.5
--         res=ball.pos()+Utils.Polar2Vector(l,(ourGoal-ball.pos()):dir())   --  res=enemy.pos(num1)+Utils.Polar2Vector(l,(enemy.pos(num1)-enemy.pos(num2)):dir())
--         return res 
-- 		-- return ball.pos()
-- 	end
	

-- 	local idir = function(runner)
-- 		-- local  num1= GetballNum()
-- 		-- local  num2= GetballNum()
		
-- 		 debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,1000),123)

-- 	    local res
-- 		res = (ball.pos() - ourGoal):dir()        --		res = (ball.pos() - ourGoal):dir()
-- 		return res
-- 		-- return 0
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end




function marking(xmin,xmax,ymin,ymax)
	local num = 0
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0,0)
	local drawDebug = function()
		local p1 = CGeoPoint:new_local(xmin,ymin)
		local p2 = CGeoPoint:new_local(xmin,ymax)
		local p3 = CGeoPoint:new_local(xmax,ymin)
		local p4 = CGeoPoint:new_local(xmax,ymax)
		debugEngine:gui_debug_line(p1,p2,4)
		debugEngine:gui_debug_line(p2,p4,4)
		debugEngine:gui_debug_line(p3,p4,4)
		debugEngine:gui_debug_line(p3,p1,4)


		local turn = ball.velDir()>0 and 1 or -1
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.velDir())),0)
		debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,2000),turn)

	end

	


	local checkNum = function()
		local between = function(a,min,max)
			if a > min and a < max then
				return true
			end
			return false
		end
		drawDebug()
		local num = -1

		for i=0,param.maxPlayer-1 do
			if enemy.valid(i) and between(enemy.posX(i),xmin,xmax) and between(enemy.posY(i),ymin,ymax) then
				num=i
			end
		end
		return num
	end

	local ipos = function(runner)
		local  num = checkNum()
		debugEngine:gui_debug_msg(CGeoPoint:new_local(3000,1000),num)
		local enemyPos = enemy.pos(num)
		if num < 0 then
			enemyPos = CGeoPoint:new_local((xmin+xmax)/2.0,(ymin+ymax)/2.0)
		end


		local res
		local l = (ourGoal-enemyPos):mod()*0.3
		res = enemyPos + Utils.Polar2Vector(l,(ourGoal - enemyPos):dir())
		return res
		-- return ball.pos()
	end
	local idir = function(runner)
		local  num = checkNum()
		local enemyPos = enemy.pos(num)
		if num < 0 then
			enemyPos = CGeoPoint:new_local((xmin+xmax)/2.0,(ymin+ymax)/2.0)
		end
	debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,1000),123)

		local res
		res = (ball.pos() - ourGoal):dir()
		return res
		-- return 0
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

bMsg = {
	f = 1
}

function defineBallPos()
	if ball.posY()<0 then
		bMsg.f=1
	else
		bMsg.f=-1
	end
	debugEngine:gui_debug_msg(CGeoPoint(2000,0),bMsg.f)

	return true
end

function auto_Pos(x,y)
	return function()
	debugEngine:gui_debug_msg(CGeoPoint(x,y*bMsg.f),"X")
		return CGeoPoint:new_local(x,y*bMsg.f)
	end
end

function between(a,min,max)
	if a > min and a < max then
		return true
	end
	return false
end		


--~		Play中统一处理的参数（主要是开射门）
--~		1 ---> task, 2 ---> matchpos, 3---->kick, 4 ---->dir,
--~		5 ---->pre,  6 ---->kp,       7---->cp,   8 ---->flag
------------------------------------- 射门相关的skill ---------------------------------------
-- TODO
------------------------------------ 跑位相关的skill ---------------------------------------
--~ p为要走的点,d默认为射门朝向
function goalie()
	local mexe, mpos = Goalie()
	return {mexe, mpos}
end
function touch()
	local ipos = pos.ourGoal()
	local mexe, mpos = Touch{pos = ipos}
	return {mexe, mpos}
end
function touchKick(p,ifInter)
	local ipos = p or pos.theirGoal()
	local idir = function(runner)
		return (ipos - player.pos(runner)):dir()
	end
	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
	return {mexe, mpos, kick.flat, idir, pre.low, cp.full, cp.full, flag.nothing}
end
function goSpeciPos(p, d, f, a) -- 2014-03-26 增加a(加速度参数)
	local idir
	local iflag
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SmartGoto{pos = p, dir = idir, flag = iflag, acc = a}
	return {mexe, mpos}
end

function goSimplePos(p, d, f)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SimpleGoto{pos = p, dir = idir, flag = iflag}
	return {mexe, mpos}
end

function runMultiPos(p, c, d, idir, a)
	if c == nil then
		c = false
	end

	if d == nil then
		d = 20
	end

	if idir == nil then
		idir = dir.shoot()
	end

	local mexe, mpos = RunMultiPos{ pos = p, close = c, dir = idir, flag = flag.not_avoid_our_vehicle, dist = d, acc = a}
	return {mexe, mpos}
end

--~ p为要走的点,d默认为射门朝向
function goCmuRush(p, d, a, f, r, v)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function forcekick(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.forcekick}
end

function shoot(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.nothing}
end
------------------------------------ 防守相关的skill ---------------------------------------
-- TODO
----------------------------------------- 其他动作 --------------------------------------------

-- p为朝向，如果p传的是pos的话，不需要根据ball.antiY()进行反算
function goBackBall(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = flag.dodge_ball}
	return {mexe, mpos}
end

-- 带避车和避球
function goBackBallV2(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = bit:_or(flag.allow_dss,flag.dodge_ball)}
	return {mexe, mpos}
end

function stop()
	local mexe, mpos = Stop{}
	return {mexe, mpos}
end

function continue()
	return {["name"] = "continue"}
end

------------------------------------ 测试相关的skill ---------------------------------------

function openSpeed(vx, vy, vdir)
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = OpenSpeed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos}
end

function speed(vx, vy, vdir)
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = Speed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos}
end
