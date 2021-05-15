module(..., package.seeall)

--~		Play中统一处理的参数（主要是开射门）
--~		1 ---> task, 2 ---> matchpos, 3---->kick, 4 ---->dir,
--~		5 ---->pre,  6 ---->kp,       7---->cp,   8 ---->flag
------------------------------------- 射门相关的skill ---------------------------------------
-- TODO
------------------------------------ 跑位相关的skill ---------------------------------------
--~ p为要走的点,d默认为射门朝向
function Attack_lzk(f,role1,tar)
	local power=function()
		local ipower = 0
		return function ()
		if type(tar) == "string" then
			if ball.toPlayerDist(role1)<=100 and ball.toPlayerDist(tar) >5000 then 
				ipower=1.2*ball.toPlayerDist(tar)*0.12--模拟需乘8实地去掉
			elseif  ball.toPlayerDist(role1)<=110 and ball.toPlayerDist(tar) >3000 then
				ipower=1.2*(ball.toPlayerDist(tar)*0.14+40)
			else 
				ipower=1.2*(ball.toPlayerDist(tar)*0.14+40)
			end
		else
			-- if ball.toPlayerDist(role1)<=100 and ball.toPointDist(tar) >5000 then 
			-- 	ipower=ball.toPointDist(tar)*0.18
			-- elseif ball.toPlayerDist(role1)<=110 and ball.toPointDist(tar)>3000 then
			-- 	ipower=(ball.toPointDist(tar)*0.12+40)
			-- else 
			-- 	ipower=(ball.toPointDist(tar)*0.14+40)
			-- end
			if ball.toPlayerDist(role1)<=110 then
			 	ipower=600
			else
			 	ipower=0
			end
		end
		--ipower=100+ball.toPlayerDist(tar)/11
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2500),ipower)
			return ipower
		end
	end
	local ipos=function(runner)
		local res

		--res=player.pos(runner)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,3000),power())
		if type(tar) == "string" then
			res= ball.pos()+Utils.Polar2Vector(-95,ball.toPlayerDir(tar))
		else
			res=ball.pos()+Utils.Polar2Vector(-95,(tar-ball.pos()):dir())
		end
		return res
	end
	local idir=function(runner)
		local res
			if type(tar) == "string" then
				res=ball.toPlayerDir(tar)
			else
				res=(tar-ball.pos()):dir()
			end
		return res
	end
	-- local shootpower=function()
	-- 	local res
	-- 		res=(ball.toPlayerDist(role2)+176.3)/7.70--math.ceil((Dist()+176.3)/7.70)
	-- 	return res
	-- end
	local ikick=kick.flat
	--local ipre =pre.specified(10)
	local ikp= power()
	local icp =cp.specified(0)
	local iflag=f or flag.dribbling
local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos,ikick,idir,pre.low,ikp,icp,iflag}
end
function TouchAndreceive_lzk(tar,dist,needchase,role1,role2)--用于touch进攻已经 接球或者转身进攻
	local p=CGeoPoint:new_local(4500,-200)
	local idist = dist or 95
	local f = flag.dribbling
	-- local canshootAngle=function()
	-- 	local ang1=(CGeoPoint:new_local(4500,400)-player.pos(role1)):dir()
	-- 	local ang2=(CGeoPoint:new_local(4500,-400)-player.pos(role1)):dir()
	-- 	local ang3=player.dir(role1)
		
	-- 	if ang3>ang2 and ang3<ang1 then 
	-- 		res=true
	-- 	else
	-- 		res=false
	-- 	end
	-- end
	-- local power=function()
	-- 	local ipower = 0
	-- 	return function ()
	-- 		if canshootAngle() and ball.toPlayerDist(role1)<=98 and ball.toPlayerDist(role2) >5000 then 
	-- 			ipower=ball.toPlayerDist(role2)*0.1140
	-- 		elseif  canshootAngle() and ball.toPlayerDist(role1)<=98 and ball.toPlayerDist(role2) >3000 then
	-- 			ipower=ball.toPlayerDist(role2)*0.1+40
	-- 		else 
	-- 			ipower=ball.toPlayerDist(role2)*0.13+40
	-- 		end
	-- 		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),ipower)

	-- 		return ipower
	-- 	end
	-- end
	
	local power=function()
		local ipower = 0
		return function ()
			local between = function(a,min,max)
				if a > min and a < max then
					return true
				end
				return false
			end
			local ang1=(CGeoPoint:new_local(4500,300)-player.pos(role1)):dir()
			local ang2=(CGeoPoint:new_local(4500,-300)-player.pos(role1)):dir()
			local ang3=player.dir(role1)
			if between(ang3,ang2,ang1) and ball.toPlayerDist(role1)<=700 then 
				ipower=600
				--debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2500),1)
			else 
				ipower=0
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),ipower)
			return ipower
		end
	end
	local ipos = function(runner)
		local res
		if player.toBallDist(runner)<100 and ball.velMod()<100 then --to target 
			if tar ~=nil then
				if type(tar) == "string" then
					itar = (ball.pos() - player.pos(tar)):dir()
					-- debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),"player.posX(tar)")
				elseif type(tar) == "function" then
					itar = (ball.pos() - tar()):dir()	
				else
					itar = (ball.pos() - tar):dir()
				end
			else
				itar = (player.pos(runner) - ball.pos()):dir()
			end
			res = ball.pos() + Utils.Polar2Vector(idist,itar)
			-- local l =player.toBallDist(tars)
			-- debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1000),idist .. "||||||||||" .. l)
		elseif needchase and ball.velMod()<3000 then --to getball early
			chaseLength = math.max(idist,player.toBallDist(runner)*80/100)
			res = ball.pos() + Utils.Polar2Vector(chaseLength,ball.velDir())
		else --receive ball
			if  math.abs(player.toPlayerDir(role2,role1))>=math.pi*5/12 then
				local ang1=math.abs((p-player.pos(runner)):dir())--player.toTargetDir(p,runner)
				local ang2=math.abs(math.pi-ball.velDir())
				local ang3=math.abs(ang2-ang1)
				local R=85
				local Chang=R*math.sin(ang3)/math.sin(math.pi-ang3-ang1)
				local Xm=player.posX(runner)+R*math.cos(ang1)
				local Ym=player.posY(runner)+R*math.sin(ang1)
				local Idist=(ball.pos()-CGeoPoint(Xm,Ym)):mod()
				local Dist=(player.pos(runner)-CGeoPoint(Xm,Ym)):mod()
				 debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,-1000),Dist)
				-- debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1000),Xm)
					res = CGeoPoint(ball.posX()-Chang,ball.posY()) + Utils.Polar2Vector(Idist,ball.vel():dir())
			else
					if ball.toPlayerDist(runner)>200 then 
						res=ball.pos() + Utils.Polar2Vector(ball.toPlayerDist(runner),ball.velDir())
					else
						res=ball.pos() + Utils.Polar2Vector(idist,ball.toPlayerDir(runner))
					end

			end
			--	res =ball.pos() + Utils.Polar2Vector(-95,ball.toTheirGoalDir())
			--end
		end
		return res
	end
	local idir = function(runner)
		local res
		if math.abs(player.toPlayerDir(role2,role1))<math.pi*5/12 then
			if ball.toPlayerDist(role1)>200 then 
				res=(ball.pos() - player.pos(role1)):dir()
			else
				res=(p-player.pos(runner)):dir()
			end
		else
		res=(p-player.pos(runner)):dir()
		end
		return res
	end
	local ikp=power()
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	-- return {mexe, mpos}	
	return {mexe, mpos, kick.flat, idir, pre.low, ikp, cp.specified(0), flag.dribbling}
end
function goCmuRush1(role1,role2,f)
	local ipos=function(runner)
		local res
			res=ball.pos()+Utils.Polar2Vector(-95,player.toPlayerDir(role1, role2))
		return res
	end
	local idir=function(runner)
		local res
			res=ball.toPlayerDir(role2)
		return res
	end
	local iflag=f or flag.nothing
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}
end
function Halt_lzk(tar)--车停在原地及其朝向
	local ipos=function(runner)
		local res=player.pos(runner)
		return res
	end
	local idir =function(runner)
		local res
		if tar ~=nil then
			if type(tar) == "string" then
				res = player.toPlayerDir(runner,tar)
				-- debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),player.posX(p))
				
			elseif type(tar) == "function" then
				res = (ball.pos()-tar()):dir()
			else
				res = (tar-player.pos(runner)):dir()
			end
		else
			res=player.toBallDir(runner)
		end
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end
function paoguoqu(dist)
	local ipos = function(runner)
		-- local xdian=CGeoPoint(ball.posX()-100,ball.posY())
		local res
		res = ball.pos()+Utils.Polar2Vector(dist,(player.pos(runner)-ball.pos()):dir())
		return res
	end	

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function sheguoqu(tar,dist)
	local power=function(runner)
		local ipower = 0
		return function (runner)
			x,y,f0,f1,f2 = Cnbut_pushNumber()
			local mypos = CGeoPoint:new_local(x,y)
			pos=mypos
			if ball.toPlayerDist(runner)<=98 and ball.toPointDist(pos) > 5000 then 
				ipower=ball.toPointDist(pos)*0.1140
			elseif  ball.toPlayerDist(runner)<=98 and ball.toPointDist(pos) > 3000 then
				ipower=ball.toPointDist(pos)*0.12+40
			else
				ipower=ball.toPointDist(pos)*0.16+40
			end
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),ipower)
			return 4000
		end
	end
	local icarFront = carFront or 75
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f and f or flag.dribbling

	local itar
	local ipos = function(runner)
		local res
		if type(tar) == "string" then
			itar = player.pos(tar)
			debugEngine:gui_debug_msg(itar,"X")
		elseif type(tar) == "function" then
			itar = tar()
			debugEngine:gui_debug_msg(itar,"X")
		else
			itar = tar
			debugEngine:gui_debug_msg(itar,"X")
		end
		res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - itar):dir())
		if player.toBallDist(runner)>200 then
			res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
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
		local pangdian = itar+Utils.Polar2Vector(dist,(ball.pos()-itar):dir()+math.pi/2)
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>20 then
			itar=ball.pos()
		end
		res = (pangdian-player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, kick.flat, idir, pre.high, power(), icp, iflag}
end

hylsmart = {
	x=0,
	y=0,
	f0=-1,
	f1=-1,
	f2=-1,
	best_player=-1
}
-- function smartFindPoint()
-- 	x,y,f0,f1,f2,best = Cnbut_pushNumber()
-- 	if not x and not y then
-- 		return false
-- 	end
-- 	local pos = CGeoPoint(x,y)
-- 	local k = y/math.abs(y)
-- 	local smartpos=CGeoPoint(0,0)
-- 	if waitForAttack(pos) then
-- 		smartpos = pos
-- 	elseif math.abs(y)>1000 then
-- 		smartpos = CGeoPoint(x,-y)
-- 	else
-- 		smartpos = CGeoPoint(x,-1000*k)
-- 	end
-- 	hylsmart.x=smartpos:x()
-- 	hylsmart.y=smartpos:y()
-- 	hylsmart.f0=f0
-- 	hylsmart.f1=f1
-- 	hylsmart.f2=f2
-- 	hylsmart.best_player=best
-- 	debugEngine:gui_debug_msg(CGeoPoint(3000,2200),best,4)
-- 	debugEngine:gui_debug_msg(CGeoPoint(3000,2400),player.posY(best)*ball.posY(),4)
-- 	debugEngine:gui_debug_msg(CGeoPoint(3000,2600),math.abs(player.posY(best)-ball.posY()),4)
-- 	if (y+1000*k)*ball.posY()<0 then
-- 		return false
-- 	end
-- 	return true
-- end
function stop2(n,dist)--0,1,2,3...
	local iflag = flag.nothing
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
	    local me = player.pos(runner)
	    local cn = ball.pos() + Utils.Polar2Vector(500+200*n,(player.pos(runner)-ball.pos()):dir()+math.pi/6)
	    local cs = ball.pos() + Utils.Polar2Vector(500+200*n,(player.pos(runner)-ball.pos()):dir()-math.pi/6)
	    local ang = Utils.Normalize((me-ball.pos()):dir()-(p-ball.pos()):dir())
	    -- debugEngine:gui_debug_msg(p,toAngle(ang))
	    local res
	    if ang >math.pi/2 then
	    	res = cs
	    elseif ang <-math.pi/2 then
	    	res =cn
	    else
	    	res = p
	    end
        return res
    end
    local idir =function(runner)
        local res 
        res = (ball.pos() - player.pos(runner)):dir()
		return res
    end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
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
function passBall_MJW(tar,power,dist,carFront,angleLimit,needChip,ckpower,f)
		local ipower = power and power or 6000
	local icarFront = carFront or 90
	local idist = dist or 105
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f or flag.dribbling
	local enemyID={}
	for i=1,param.maxPlayer-1 do
		if enemy.valid(i) then
			enemyID[i]=1
		end
	end
	
	local ipos = function(runner)
		local res
		if type(tar) == "string" then
			itar = (ball.pos() - player.pos(tar)):dir()
		else
			itar = (ball.pos() - tar):dir()
		end
		if player.toBallDist(runner)>200 then--车球之间距离超过30cm
			itar=(player.pos(runner)-ball.pos()):dir()-- 朝向球移动
		end
		res = ball.pos() + Utils.Polar2Vector(idist,itar)
		debugEngine:gui_debug_msg(CGeoPoint:new_local(player.posX("c"),player.posY("c")),player.posX("c") .."|".. player.posY("c"))
		return res
		
	end


	local idir = function(runner)
		local res
		if type(tar) == "string" then
			itar = player.pos(tar)
		else
			itar = tar
		end
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>40 then
			itar=ball.pos()
		end
		if (player.pos(runner)-ball.pos()):mod() > 130 then
			itar = ball.pos()
		end
		for i=1,param.maxPlayer-1 do
			if enemyID[i]==1 and ball.toEnemyDist(i)<ball.toPlayerDist(tar) and ball.toEnemyDir(i)<=-math.pi/2.0 and ball.toEnemyDir(i)>-math.pi/4.0*3 then
				res = (itar - player.pos(runner)):dir() - math.pi/11.0
			elseif enemyID[i]==1 and ball.toEnemyDist(i)<ball.toPlayerDist(tar) and ball.toEnemyDir(i)>-math.pi/2.0 and ball.toEnemyDir(i)<-math.pi/4.0 then
				res = (itar - player.pos(runner)):dir() + math.pi/11.0
			else res = (itar - player.pos(runner)):dir()
			end
		end
		return res 
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, flag.dribbling}
end
function behindDefend(n,dist)
	local ipos=function(runner)
		local res
		local dist=dist or 1500
		if n==1 then
			res=CGeoPoint(-4500,0)+Utils.Polar2Vector(dist,(ball.pos()-CGeoPoint(-4500,0)):dir()+math.pi/48)
		elseif n==2 then
			res=CGeoPoint(-4500,0)+Utils.Polar2Vector(dist,(ball.pos()-CGeoPoint(-4500,0)):dir()-math.pi/48)
		end
		return res
	end
	local ourgoal = CGeoPoint(-4500,0)
	local idir=function(runner)
		local res
		res=(ball.pos()-ourgoal):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.not_avoid_our_vehicle+flag.not_avoid_their_vehicle,rec = r,vel = v}
	return {mexe, mpos}
end
function ifTheSameDirection(r)--用速度方向判断接球是否完成
	if toAngle(ball.velDir())*toAngle((player.pos(r)-ball.pos()):dir())>0 then
		return true
	elseif toAngle(ball.velDir())*toAngle((player.pos(r)-ball.pos()):dir())<0 then
		return false
	end
end
function AngleRangeU()
	local a
	local p=p or CGeoPoint(-4500,-1000)
	local p1=CGeoPoint(-4500,10)
		a=math.abs(toAngle(Utils.Normalize((((ball.pos()-p):dir()-(p1-p):dir())))))
	return a
end
function toAngle(n)
	return n/(math.pi/180)
end
function AngleRangeD()
	local a
	local p=p or CGeoPoint(-4500,1000)
	local p1=CGeoPoint(-4500,10)
		a=math.abs(toAngle(Utils.Normalize((((ball.pos()-p):dir()-(p1-p):dir())))))
	return a
end

function judge1()--守门员
	function robotInValid(x,y)
		
		if player.posX(0)>-4500 and player.posX(0)<-3500 then
			if player.posY(0)>-1000 and player.posY(0)<1000 then
				return true
			end
		end
	end

	local ikick = chip and kick.chip or kick.flat
	local ipower = 8000


	local ipos = function(runner)
		local res
		local ballDir = (ball.pos()-CGeoPoint(0,0)):dir()
		local ballVDir = ball.velDir()
		local angle=math.pi-math.abs(ballVDir)
		local l1=ball.posX()+4500
		local l2=math.tan(angle)*l1
		local p1= ball.posY()+l2*math.abs(ball.velDir())/ball.velDir()
		if player.toBallDist(runner)>150 then
			
			if ball.velMod()==0 and Utils.InOurPenaltyArea(ball.pos(),0) then
				return ball.pos()
			end
			
			if Utils.InOurPenaltyArea(player.pos(0),0) then
				if AngleRangeU()<45 then
					res=CGeoPoint(-4700,-500)+Utils.Polar2Vector(1000,(ball.pos()-CGeoPoint(-4700,-500)):dir())
					debugEngine:gui_debug_msg(CGeoPoint(0,0),1)
					
					-- if nearest() then
					-- 	res=CGeoPoint(-4500,p1)+Utils.Polar2Vector(300,math.pi+ball.vel())
					-- end
				elseif AngleRangeD()<45 then
					res=CGeoPoint(-4700,500)+Utils.Polar2Vector(1000,(ball.pos()-CGeoPoint(-4700,500)):dir())
					debugEngine:gui_debug_msg(res,2)

				else
					debugEngine:gui_debug_msg(CGeoPoint(0,0),3)
					res=CGeoPoint(-5000,0)+Utils.Polar2Vector(800,(ball.pos()-CGeoPoint(-5000,0)):dir())
				end
				debugEngine:gui_debug_msg(CGeoPoint(1000,0),p1)

				if p1<=1000 and p1>=-1000 then
					res=CGeoPoint:new_local(-4350,p1)
				end
				if p1<=1000 and p1>=-1000 and ball.velMod()>2000 and math.abs(ball.velDir())>math.pi/2 then
				-- res=ball.pos()+Utils.Polar2Vector(200,(player.pos(runner) - ball.pos()):dir())
					local chaseLength = math.max(200,player.toBallDist(runner)*80/100)
					res = ball.pos() + Utils.Polar2Vector(chaseLength,ball.velDir())
					debugEngine:gui_debug_msg(CGeoPoint(0,0),"receive")

				end
			else
				res=CGeoPoint(-4500,0)
			end
		else
			return ball.pos()
		end
		-- 	-- if ball.velMod()<2000 then
		-- 	-- 	return CGeoPoint:new_local(-4350,0)
		-- 	-- end --球速几乎为0
		-- 	-- 

		-- 	if (math.abs(ball.velDir())-math.pi/2)<55  then
		-- 		res=CGeoPoint(-4500,p1)+Utils.Polar2Vector(250,(ball.pos()-CGeoPoint(-4500,p1)):dir())
		-- 		--角球挡球
		-- 		res=CGeoPoint(-4700,0)+Utils.Polar2Vector(800,(ball.pos()-CGeoPoint(-5000,0)):dir())
		-- 		--角球挡球
		-- 	end
		-- 	if p1<=1000 and p1>=-1000 then
		-- 		res=CGeoPoint:new_local(-4350,p1)--直射挡球
		-- 	else
		-- 		res = CGeoPoint:new_local(-4350,0)
		-- 	end
		-- else
		-- 	res=player.pos(runner)
		-- end
		return res
	end


	local idir=function(runner)
		local res
		local goalPos = CGeoPoint(4500,0)
		if player.toBallDist(runner)>150 then
			res = (ball.pos()-player.pos(runner)):dir()
		else
			res = (goalPos-ball.pos()):dir()
		end
		return res
	end

	-- function dist(runner)
	-- 	local d
	-- 	d=player.toBallDist(runner)
	-- 	return d
	-- end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.nothing}
end
function judgeReceiveRobot()--判断谁接球
	if judgeIfKick() and (ball.pos()-enemy.pos(nearest())):mod()>200 then
		if toAngle(math.abs(ball.velDir()-(player.pos("a")-ball.pos()):dir()))<15 then
			return 0
		elseif toAngle(math.abs(ball.velDir()-(player.pos("b")-ball.pos()):dir()))<15 then
			return 1
		else
			return false
		end
	else
		return false
	end
end
function judgeIfKick()--判断敌方是否踢球
	
		if ball.velMod()>2000 then 
			return true
		else
			return false
		end	
end
function defendBallRobot()--防拿球车
	local ipos=function()
		local res
		local idir=(CGeoPoint(-4500,0)-enemy.pos(nearest())):dir()
		res=enemy.nearest()+Utils.Polar2Vector(300,idir)
		return res
	end 

	local idir=function()
		local res
		res=(enemy.pos(nearest())-CGeoPoint(-4500,0)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end
function isGoalie()--敌方守门员
	local nearNum = 1
	for i=1,6 do
		if enemy.isGoalie(i) then
			return i 
		end
	end
end
function nearest()--离球最近的敌方车辆
	local nearDist = 99999
	local nearNum = 1
	for i=1,6 do
		local theDist = enemy.pos(i):dist(ball.pos())
		if enemy.valid(i) and nearDist > theDist then
			nearDist = theDist
			nearNum = i
		end
	end
	debugEngine:gui_debug_msg(CGeoPoint(0,200),nearNum)
	return nearNum
end
function nearestToLastLine(n,direction)--离某一位置最近的敌方车辆
		local nearDist = 99999
		local secondNearDist = 99999
		local nearNum = 1
		local secondNearNum = 2
		local i=0
		for i=0,6 do
			local theDist = enemy.posX(i)-direction
			if enemy.valid(i) and nearDist > theDist and i~=nearest()  then
				nearDist = theDist
				nearNum = i
			end
		end
		for i=0,6 do
			local theDist = enemy.posX(i)-direction
			if enemy.valid(i) and secondNearDist>theDist and theDist>nearDist and i~=nearest() and i~=isGoalie() then 
				secondNearDist=theDist
				secondNearNum=i
			end
		end
		if n==1 then
			debugEngine:gui_debug_msg(CGeoPoint(0,0),nearNum)
			return nearNum
		elseif n==2 then
			debugEngine:gui_debug_msg(CGeoPoint(200,0),secondNearNum)
			return secondNearNum
		end
end
function defendTheirs(n,direction,dist,tar)
	local ipos=function(runner)
	local idirection=direction
		local itar=tar or ball.pos() 
		local idist=dist or 200
		local emy = enemy.pos(nearestToLastLine(n,idirection))
		local res
		res=emy+Utils.Polar2Vector(idist,(itar-emy):dir())
		debugEngine:gui_debug_msg(CGeoPoint(1000,1000),ball.velMod())
			-- debugEngine:gui_debug_msg(CGeoPoint(1000,0),judgeIfKick())
		return res 
	end

	local idir=function(runner)
		local res
		local itar=tar or ball.pos() 
		local idirection=direction
		res=(itar-enemy.pos(nearestToLastLine(n,idirection))):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.nothing,rec = r,vel = v}
	return {mexe, mpos}
end
function kickBall() 
	if enemy.valid(nearest()) and enemy.posX(0)<-500 and (enemy.pos(0)-ball.pos()):mod()>120 then
		return true

	end
end

function grabBall()
	if (player.pos(0)-ball.pos()):mod()<(enemy.gEnemyMsg.goaliePos-ball.pos()):mod() then
		return true
	else
		return false
	end
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
		-- ret urn ball.pos() + Utils.Polar2Vector(ball.vel():mod(),ball.vel():dir())
	end

	local idir = function(runner)
		local res
		res = (theirGoal - player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, iflag}	
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
function smartFindPoint()
	x,y,f0,f1,f2,best,isCanshoot = Cnbut_pushNumber()

	local k = y/math.abs(y)

	if y*ball.posY()>0 and (math.abs(ball.posY())>1000 or math.abs(y)>1000) then
		y=-y
	end

	hylsmart.x=x
	hylsmart.y=y

	hylsmart.f0=f0
	hylsmart.f1=f1
	hylsmart.f2=f2
	hylsmart.best_player=best
	return true
end

function ifShootLine()
	x,y,f0,f1,f2,best,isCanshoot = Cnbut_pushNumber()
	if isCanshoot then
		debugEngine:gui_debug_msg(CGeoPoint(3000,2800),"true")
	else
		debugEngine:gui_debug_msg(CGeoPoint(3000,2800),"false")
	end
	debugEngine:gui_debug_msg(CGeoPoint(3000,2600),x)
	if not isCanshoot then
		return true
	else
		return false
	end
end

function hylniubiAttcak_alpha(carFront,angleLimit,f)
	local power=function()
		local ipower = 0
		return function ()
			return ((CGeoPoint(hylsmart.x,hylsmart.y)-ball.pos()):mod()/12+90)
			-- return 0
			-- local mypos = CGeoPoint:new_local(hylsmart.x,hylsmart.y)
			-- pos=mypos
			-- if ball.toPlayerDist(runner)<=98 and ball.toPointDist(pos) > 5000 then 
			-- 	ipower=ball.toPointDist(pos)*0.1140
			-- elseif  ball.toPlayerDist(runner)<=98 and ball.toPointDist(pos) > 3000 then
			-- 	ipower=ball.toPointDist(pos)*0.12+40
			-- else 
			-- 	ipower=ball.toPointDist(pos)*0.16+40
			-- end
			-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),ipower)
			-- return ipower
		end
	end
	local icarFront = carFront or 95
	local ipre = angleLimit and pre.specified(angleLimit) or pre.middle
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f and f or flag.dribbling

	local itar
	local ipos = function(runner)

		local pos = CGeoPoint:new_local(hylsmart.x,hylsmart.y)
			debugEngine:gui_debug_msg(pos,"O")
		itar=pos
		local res
		res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - itar):dir())
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>50 then
			res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
		end

		return res
		
	end
	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res 
	end

	local targetdir = function(runner)
		local res

		local pos = CGeoPoint:new_local(hylsmart.x,hylsmart.y)
			debugEngine:gui_debug_msg(pos,"O")
		res = ball.pos() + Utils.Polar2Vector(icarFront,
			(ball.pos() - pos):dir())
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>40 then
			res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
		end
		local t = CGeoPoint:new_local(hylsmart.x,hylsmart.y)
		res = (t - player.pos(runner)):dir()
		return res 
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, targetdir, ipre, power(), icp, iflag}
end

function hylgo2Pos(dir, f)
	local ipos = function(runner)
		local res
		res = CGeoPoint:new_local(hylsmart.x,hylsmart.y)
			debugEngine:gui_debug_msg(res,"O")

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

	if f ~= nil then
		iflag = f
	else
		iflag = flag.allow_dss+flag.dodge_ball
	end

	local mexe, mpos = SimpleGoto{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
end

function moving()
	local idir
	local ipos =  function(runner)
		local pos
		local epos,edir = enemy.nearest();	
		if math.abs((ball.pos()-player.pos(runner)):dir()-player.dir(runner))>0.6
			and math.abs((ball.pos()-player.pos(runner)):dir()-player.dir(runner))<6 then
			pos = ball.pos() + Utils.Polar2Vector(95,(player.pos(runner)-ball.pos()):dir())
			debugEngine:gui_debug_msg(CGeoPoint(0,500),"不在脸上")
		elseif (epos - player.pos(runner)):mod() > 500 then
			debugEngine:gui_debug_msg(CGeoPoint(0,500),"大于500")
			pos = ball.pos() + Utils.Polar2Vector(70,(player.pos(runner)-ball.pos()):dir())
		else
			debugEngine:gui_debug_msg(CGeoPoint(0,500),"拉球")
			pos = ball.pos()
		end
		return pos
	end
	local idir = function(runner)
		local dr
		local epos,edir = enemy.nearest();	
		if math.abs((ball.pos()-player.pos(runner)):dir()-player.dir(runner))>0.6
			and math.abs((ball.pos()-player.pos(runner)):dir()-player.dir(runner))<6 then
			dr = (ball.pos()-player.pos(runner)):dir()
			debugEngine:gui_debug_msg(CGeoPoint(0,1000),"不在脸上")
		elseif (epos - player.pos(runner)):mod() > 500 and (ball.pos()-player.pos(runner)):mod()<90 then
			debugEngine:gui_debug_msg(CGeoPoint(0,1000),"大于500门")
			dr = 0
		elseif (epos - player.pos(runner)):mod() > 500 and (ball.pos()-player.pos(runner)):mod()>90 then
			debugEngine:gui_debug_msg(CGeoPoint(0,1000),"大于500球")
			dr = (ball.pos()-player.pos(runner)):dir()
		else
			debugEngine:gui_debug_msg(CGeoPoint(0,1000),"拉球")
			if bMsg.f == 1 then
				dr = -edir - 3*math.pi/7
			else
				dr = -edir + 3*math.pi/7
			end
		end
		return dr
	end
	
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dribbling,rec = r,vel = v}
	return {mexe, mpos}
end

AreaInField= {
	M = 0,
	U = 0,
	D = 0,
}
function ClearArea()
	AreaInField.M = 0
	AreaInField.U = 0
	AreaInField.D = 0
end 



function waitForAttack(smartpos)
	local p1 = CGeoPoint(0,3000)
	local p2 = CGeoPoint(0,-3000)
	local p3 = CGeoPoint(3000,0)
	local p4 = CGeoPoint(4500,3000)
	local p5 = CGeoPoint(4500,-3000)
	local x = -9999
	local y = -9999
	ClearArea()
	for i=3,5 do
		-- if (player.pos(runner) - player.pos(i)):mod()>50 then
			
		-- end
		if player.valid(i)then
			x = player.pos(i):x()
			y = player.pos(i):y()
			-- if x>-1000 and x<3000 and y<(3000-x) and y>(x-3000) and (player.pos(runner) - player.pos(i)):mod()>50 then
			-- 	AreaInField.M = AreaInField.M + 1
			-- 	debugEngine:gui_debug_msg(CGeoPoint(player.pos(runner):x(),player.pos(runner):y()+150),i.." M"..AreaInField.M)		
			-- else
			if y>0 and x> -1000 then
				AreaInField.U = AreaInField.U + 1
			elseif y<0 and x> -1000 then
				AreaInField.D = AreaInField.D + 1
			else
				debugEngine:gui_debug_msg(CGeoPoint(3000,110),"no")
			end
		end
	end
		-- if AreaInField.M == 0 then
	-- 	return roundEnemy(CGeoPoint(2000,0),runner)
	-- else
	if AreaInField.U == 0 or AreaInField.D == 0 then
		return false
	else
		return true
	end
	-- if AreaInField.U == 0 then
	-- 	return roundEnemy(CGeoPoint(3000,2000),runner)
	-- elseif AreaInField.D == 0 then
	-- 	return roundEnemy(CGeoPoint(3000,-2000),runner)
	-- else
	-- 	return roundEnemy(CGeoPoint(0,0))
	-- end


end

function roundEnemy(pos,role)
	local goal = CGeoPoint(4500,0)
	local p
	local epos,edir = enemy.nearplyer(role);	
	debugEngine:gui_debug_msg(epos,"epos")
	if (epos - pos):mod()<300 then
		p = epos + Utils.Polar2Vector(250,(goal-epos):dir())
	else
		p = pos
	end
	return p
end

function Halt()
	local ipos = function(runner)
		local res
		res = player.pos(runner)
		return res
	end
	
	local idir = function(runner)
		local res
		res= player.dir(runner)
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dribbling,rec = r,vel = v}
	return {mexe, mpos}
end

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







function toangle(angle)
	return angle/(math.pi/180)
end

function raoquanshun()
	local f = flag.not_avoid_our_vehicle+flag.not_avoid_their_vehicle
	local ipos = function(runner)
		local p1=player.pos(1)
		local p2=player.pos(2)
		debugEngine:gui_debug_msg(CGeoPoint(0,1000),(p1-p2):mod())
		local shun=p1+Utils.Polar2Vector(300,(player.pos(runner)-p1):dir()-math.pi/6)
		local ni=p2+Utils.Polar2Vector(300,(player.pos(runner)-p2):dir()+math.pi/6)
		local res
		res=shun
		return res
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function raoquanni()
	local f = flag.not_avoid_our_vehicle+flag.not_avoid_their_vehicle
	local ipos = function(runner)
		local p1=player.pos(1)
		local p2=player.pos(2)
		local p3x=(player.posX(1)+player.posX(2))/2
		local p3y=(player.posY(1)+player.posY(2))/2
		local p3=CGeoPoint(p3x,p3y)
    	debugEngine:gui_debug_msg(p3,"p3")
   		debugEngine:gui_debug_msg(CGeoPoint(0,1000),(p1-p2):mod())
		local shun=p1+Utils.Polar2Vector(300,(player.pos(runner)-p1):dir()-math.pi/6)
		local ni=p2+Utils.Polar2Vector(300,(player.pos(runner)-p2):dir()+math.pi/6)
		local res
			if player.posX(runner)>((player.posX(2)+p3x)/2) then
				res = ni
			else
				res = p3+Utils.Polar2Vector(600,(player.pos(runner)-p3):dir()+math.pi/6)
			end
	-- res = ball.pos()+Utils.Polar2Vector(400,(player.pos(runner)-ball.pos()):dir()-math.pi/6)
		return res
	end
	
	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end










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

	if f ~= nil then
		iflag = f
	else
		iflag = flag.allow_dss+flag.dodge_ball
	end

	local mexe, mpos = SimpleGoto{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
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
			res = (oppgoal - ourgoal):dir()
		else
			res = (ball.pos() - ourgoal):dir()
		end
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, kp.specified(ipower), icp, iflag}
end

function goalieDef(carFront,f)
	local plentyKick = f and f or false
	local dist = 80
	local ourGoal = CGeoPoint:new_local(-4500,-100)
	local icarFront = carFront or 80
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
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.vel():dir())),"_")
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

		drawDebug()
		-- local defPos = CGeoPoint:new_local(-4500,ball.posY()-(ball.posX() +4500)*math.tan(ball.vel():dir()))
		local between = function(a,min,max)
			if a > min and a < max then
				return true
			end
			return false
		end

		

		
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,1500),"hitpos:" .. ball.posY()-(ball.posX() +4500)*math.tan(ball.vel():dir()))
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
		-- if((player.pos(runner)-ball.pos()):mod()+1000<(ball.pos()-enemy.pos(enemynum)):mod()) then
		-- 	res = ball.pos()
		-- else
		if BallInField() and between(ball.posY()-(ball.posX() +4500)*math.tan(ball.vel():dir()),-550,550) and ball.velX() < 0 and ball.velMod() > 2000 then
			debugEngine:gui_debug_msg(CGeoPoint:new_local(-2000,2000),1)
			res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.vel():dir())
		elseif inArea() and ball.velMod()<2000 then
			res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - CGeoPoint:new_local(4500,0)):dir())
			if player.toBallDist(runner)>200 then
				res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
			end

			-- res = ball.pos() + Utils.Polar2Vector(dist,(player.pos(runner)-ball.pos()):dir())
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
		-- return ball.pos()
	end

	

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()

		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()<25 and inArea() then
			res = (CGeoPoint:new_local(4500,0) - ball.pos()):dir()
		end
		

		return res
		-- return 0
	end
	-- ikick = kick.none
	-- if ball.posX() < (-4400+80) then
	-- 	ikick=kick.flat
	-- 	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"kick")
	-- end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc =a , flag = flag.dribbling,rec = r ,vel = vel}
	return {mexe, mpos, kick.chip, idir, pre.high, kp.specified(300), cp.full, flag.dribbling}
end

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

function passBall(tar,power,carFront,angleLimit,needChip,ckpower,f)
	local ipower = power and power or 6000
	local icarFront = carFront or 95
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f and f or flag.dribbling
	local itar
	local power=function()
		local ipower = 0
		return function ()
			return ((CGeoPoint(hylsmart.x,hylsmart.y)-ball.pos()):mod()/12+90)
		end
	end
	local ipos = function(runner)
		local res
		if type(tar) == "string" then
			itar = player.pos(tar)
			debugEngine:gui_debug_msg(itar,"X")
		elseif type(tar) == "function" then
			itar = tar()
			debugEngine:gui_debug_msg(itar,"X")
		else
			itar = tar
			-- debugEngine:gui_debug_msg(itar,"X")
		end

		res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - itar):dir())
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>40 then
			res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
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
		-- local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		-- if (cF-ball.pos()):mod()>15 then
			itar=ball.pos()
		-- end
		-- if (player.pos(runner)-ball.pos()):mod() > 130 then
		-- 	itar = ball.pos()
		-- end
		res = (itar - player.pos(runner)):dir()
		return res 
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, power(), icp, iflag}
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
		res = (ball.pos() - ourgoal):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.iflag,rec = r,vel = v}
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

function receive(tar,dist,needchase)
	local idist = dist or 95
	local ipos = function(runner)
		local res
		if player.toBallDist(runner)<300 or ball.velMod()<500 then --to target
			if tar ~=nil then
				if type(tar) == "string" then
					itar = (ball.pos() - player.pos(tar)):dir()
					-- debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),"player.posX(tar)")
				elseif type(tar) == "function" then
					itar = (ball.pos() - tar()):dir()	
				else
					itar = (ball.pos() - tar):dir()
				end
			else
				itar = (player.pos(runner) - ball.pos()):dir()
			end
			res = ball.pos() + Utils.Polar2Vector(idist,itar)
			-- local l =player.toBallDist(tars)
			-- debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1000),idist .. "||||||||||" .. l)
		elseif needchase and ball.velMod()<3000 then --to getball early
			chaseLength = math.max(idist,player.toBallDist(runner)*80/100)
			res = ball.pos() + Utils.Polar2Vector(chaseLength,ball.velDir())
		else --receive ball
			res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.vel():dir())
		end
		return res
		-- ret urn ball.pos() + Utils.Polar2Vector(ball.vel():mod(),ball.vel():dir())
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

function canShoot(cf,ll,pre,kp,pos,f)
	--cf,ll,pre,kp,pos,f
	-- local ipos = function(runner)
	-- 	local res
	-- 	if type(p) == "function" then
	-- 		res = p()
	-- 	else
	-- 		res=p
	-- 	end
	-- 	return res
	-- end	

	-- local idir = function(runner)
	-- 	local res
	-- 	res = (ball.pos() - player.pos(runner)):dir()

	-- 	if dir ~= nil then
	-- 		res = dir
	-- 	end
	-- 	return res
	-- end

	-- if f ~= nil then
	-- 	iflag = f
	-- else
	-- 	iflag = flag.allow_dss+flag.dodge_ball
	-- end

	local mexe, mpos = CanShoot{carFront=cf,lengthLimit=ll,kickprecision=pre,kickpower=kp,p=pos,flag=f}
	return {mexe, mpos}
	--local mexe, mpos = CanShoot{carFront=cf,lengthLimit=ll,kickprecision=pre,kickpower=kp,p=pos,flag=f}
	--return {mexe, mpos}
end

function auto_Pos(x,y)
	return function()
debugEngine:gui_debug_msg(CGeoPoint(x,y*bMsg.f),"X")
		return CGeoPoint:new_local(x,y*bMsg.f)
	end
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


function qujiao(runner1,runner2)
	local jiao1
	jiao1=(enemy.pos(runner1)-ball.pos()):dir()
	local jiao2
	jiao2=(enemy.pos(runner2)-ball.pos()):dir()
	local Hjiao
	Hjiao=math.abs(jiao2-jiao1)
	debugEngine:gui_debug_msg(CGeoPoint(0,0),"jiaodu:".." "..Hjiao)
	return Hjiao
end

function qujiao1(runner)
	local qiupd=CGeoPoint((param.pitchLength/2-ball.posX())/2,ball.posY())
	debugEngine:gui_debug_msg(CGeoPoint(0,200),"dian:".." "..((param.pitchLength/2-ball.posX())/2).." "..ball.posY())
	local jiao1=(enemy.pos(runner)-ball.pos()):dir()
	local jiao2=(qiupd-ball.pos()):dir()
	local Hjiao=math.abs(jiao2-jiao1)
	debugEngine:gui_debug_msg(CGeoPoint(0,400),"qiujiao:".." "..Hjiao)
end

function stopForPlacement(n,dist)
	local iflag = flag.avoid_their_ballplacement_area
	local ourGoal = CGeoPoint:new_local(-4500,0)
    local ipos = function(runner)
    	local theirballPlace = ball.placementPos()
    	local idist = dist or 650 
        if(theirballPlace:y()>0) then 
            tar = (ourGoal-theirballPlace):dir()+(math.pi/10)*n
		    p = theirballPlace + Utils.Polar2Vector(idist,tar)
		else
		   tar = (ourGoal-ball.pos()):dir()-(math.pi/10)*n
		    p = theirballPlace + Utils.Polar2Vector(idist,tar)
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
	    local me = player.pos(runner)
	    local cn = ball.pos() + Utils.Polar2Vector(500+200*n,(player.pos(runner)-ball.pos()):dir()+math.pi/6)
	    local cs = ball.pos() + Utils.Polar2Vector(500+200*n,(player.pos(runner)-ball.pos()):dir()-math.pi/6)
	    local ang = Utils.Normalize((me-ball.pos()):dir()-(p-ball.pos()):dir())
	    local res
	    --cond.theirBallPlace()

	    local placeL = theirballPlace + Utils.Polar2Vector(500,(ball.pos()-theirballPlace):dir()+math.pi/2)
	    local placeR = theirballPlace + Utils.Polar2Vector(500,(ball.pos()-theirballPlace):dir()-math.pi/2)
	   	local ballL = ball.pos() + Utils.Polar2Vector(500,(theirballPlace-ball.pos()):dir()-math.pi/2)
	    local ballR = ball.pos() + Utils.Polar2Vector(500,(theirballPlace-ball.pos()):dir()+math.pi/2)
	    debugEngine:gui_debug_line(placeL,placeR)
	    debugEngine:gui_debug_line(placeL,ballL)
	    debugEngine:gui_debug_line(ballL,ballR)
	    debugEngine:gui_debug_line(ballR,placeR)
	    --local ang1 = Utils.Normalize((p-theirballPlace):dir()-(ball.pos()-theirballPlace):dir())
	    if ang >math.pi/2 then
	    	res = cs
	    elseif ang <-math.pi/2 then
	    	res =cn
	    else
	    	res = p
	    end
        local pp = makeOutOfRectangle(res,theirballPlace,ball.pos(),500)
        return pp
    end
    local idir =function(runner)
        local res 
        res = (ball.pos() - player.pos(runner)):dir()
		return res
    end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, flag = iflag}
	return {mexe, mpos}
end


function myPassBall(tar,dist,power,chip)
	local ikick = chip and kick.chip or kick.flat
	local idist = dist or 100
	local ipower = power and power or 6000

	local ipos = function(runner)
		local res
		if tar~=nil then
			if type(tar)=="string" then
				res=ball.pos()+Utils.Polar2Vector(idist,(ball.pos()-player.pos(tar)):dir())
			elseif type(tar)=="function" then
				res=ball.pos()+Utils.Polar2Vector(idist,(ball.pos()-tar()):dir())
			else
				res=ball.pos()+Utils.Polar2Vector(idist,(ball.pos()-tar):dir())
			end
		else
			res=ball.pos()+Utils.Polar2Vector(idist,(ball.pos()-CGeoPoint(4500,0)):dir())
		end
		return res
	end

	local idir=function(runner)
		local res
		res=(ball.pos()-player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dribbling,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.dribbling}

end

function makeOutOfRectangle(tar,p1,p2,width)

	local ang = Utils.Normalize((p2-p1):dir() - (tar-p1):dir())

	local dist = (p1 - tar):mod() * math.cos(ang)

	local midP = p1 + Utils.Polar2Vector(dist,(p2-p1):dir())

	debugEngine:gui_debug_msg(midP,dist)

	debugEngine:gui_debug_msg(tar,"X")
	if (midP - tar):mod() < width then
		return midP + Utils.Polar2Vector(width,(tar-midP):dir())
	else
		return tar
	end
end