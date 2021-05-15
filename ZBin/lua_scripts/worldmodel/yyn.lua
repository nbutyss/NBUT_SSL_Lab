module(..., package.seeall)


local PI = 3.1415926535897932
local goal=CGeoPoint:new_local(-4500,0)

pMSG = {
	f1 = 0,
	f2 = 0,
	f3=0,
	f4=0,
	f5=0,
	f6=0,
	n1=10,
	n2=10
}
local k=4
local radius=300
function kickOff()
	if math.abs((ball.pos()-enemy.pos(nearest())):dir())<math.pi/2 then
		return true
	else
		return false
	end
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

	local idir=function(runner)
		local res
		res=(ball.pos()-player.pos(runner)):dir()
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
function judgeReceiveRobot()--判断谁接球
	if judgeIfKick() and (ball.pos()-enemy.pos(nearest())):mod()>200 then
		if toAngle(math.abs(ball.velDir()-(player.pos("a")-ball.pos()):dir()))<15 then
			return 0
		elseif toAngle(math.abs(ball.velDir()-(player.pos("b")-ball.pos()):dir()))<15 then
			return 1
		elseif toAngle(math.abs(ball.velDir()-(player.pos("c")-ball.pos()):dir()))<15 then
			return 2
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
		local ourGoal = CGeoPoint:new_local(-4500,0)
		local idir=(CGeoPoint(-4500,0)-enemy.pos(nearest())):dir()
		if countEnemyRobotNumber()~=3 then
			res=enemy.nearest()+Utils.Polar2Vector(300,idir)
		else
			if(ball.posY()>0) then 
	            t = (ourGoal-ball.pos()):dir()+(math.pi/10)*3
			    res = ball.pos() + Utils.Polar2Vector(2000,t)
			else
			    t = (ourGoal-ball.pos()):dir()-(math.pi/10)*3
			    res = ball.pos() + Utils.Polar2Vector(2000,t)
			end  
		end
		if math.abs(res:x())>4500 or math.abs(res:y())>3000 then
			res=ball.pos()+Utils.Polar2Vector(500,(ourgoal-ball.pos()):dir())
		end
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
function nearestToBall(n)--离球最近的敌方车辆
		local nearDist = 99999
		local secondNearDist = 99999
		local nearNum = 1
		local secondNearNum = 2
		local i=0
		for i=0,6 do
			local theDist = (enemy.pos(i)-ball.pos()):mod()
			if enemy.valid(i) and nearDist > theDist and i~=nearest() and i~=isGoalie() then
				nearDist = theDist
				nearNum = i
			end
		end
		for i=0,6 do
			local theDist = (enemy.pos(i)-ball.pos()):mod()
			if enemy.valid(i) and secondNearDist>theDist and theDist>nearDist and i~=nearest() and i~=isGoalie() then 
				secondNearDist=theDist
				secondNearNum=i
			end
		end
		if n==1 then
			return nearNum
		elseif n==2 then
			return secondNearNum
		end
end

function countEnemyRobotNumber()
	local enemyRobotNumber=0
	for i=0,15 do
		if enemy.valid(i) then
			enemyRobotNumber=enemyRobotNumber+1
		end
	end
	return enemyRobotNumber
end
function nearestToLastLine(n,direction)--离某一位置最近的敌方车辆
		local nearDist = 99999
		local secondNearDist = 99999
		local nearNum=1 
		local secondNearNum
		local i=0
		for i=0,15 do
			local theDist = enemy.posX(i)-direction
			if enemy.valid(i) and nearDist > theDist and i~=nearest() and i~=isGoalie() then
				nearDist = theDist
				nearNum = i
			end
		end
		for i=0,15 do
			local theDist = enemy.posX(i)-direction
			if enemy.valid(i) and secondNearDist>theDist and theDist>nearDist and i~=nearest() and i~=isGoalie() then 
				secondNearDist=theDist
				secondNearNum=i
			end
		end
		if countEnemyRobotNumber()==6 then
			if n==1 then
				return nearNum
			elseif n==2 then
				return secondNearNum
			end
		elseif countEnemyRobotNumber()==5 then
			if n==1 then
				return nearNum
			elseif n==2 then
				return 16
			end
		else
			if n==1 then
				return 16
			elseif n==2 then
				return 17
			end
		end
		return -1
end


function defendTheirs(n,direction,dist,tar)
	local ipos=function(runner)
		local idirection=direction 
		local itar=tar or ball.pos() 
		local idist=dist or 200
		local emy 
		local res 
		local ourGoal = CGeoPoint:new_local(-4500,0)
		if nearestToLastLine(n,idirection)>=0 and nearestToLastLine(n,idirection)<=15 then
			emy = enemy.pos(nearestToLastLine(n,idirection))
			
			res=emy+Utils.Polar2Vector(idist,(itar-emy):dir())
			debugEngine:gui_debug_msg(CGeoPoint(2000,0),"emy:x()")
			if res:x()>2500 then
				res=CGeoPoint(2500,res:y())
			end 
			-- res = ball.pos()
		elseif nearestToLastLine(n,idirection)>=16 then
			local m=nearestToLastLine(n,idirection)-15
			local t
			if(ball.posY()>0) then 
	            t = (ourGoal-ball.pos()):dir()+(math.pi/10)*m
			    res = ball.pos() + Utils.Polar2Vector(idist*10,t)
			else
			    t = (ourGoal-ball.pos()):dir()-(math.pi/10)*m
			    res = ball.pos() + Utils.Polar2Vector(idist*10,t)
			end  
		end
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

function dianqiujudge(runner)
	local tar=CGeoPoint(-4500,0)
	local ballDir = (ball.pos()-CGeoPoint(0,0)):dir()
	local ballVDir = ball.velDir()
	local angle=math.pi-math.abs(ballVDir)
	local l1=ball.posX()+4500
	local l2=math.tan(angle)*l1
	local p1=ball.posY()+l2*math.abs(ball.velDir())/ball.velDir()
	
	local ipos=function(runner)
		local res

		if ball.velMod()>3 then
			res=CGeoPoint:new_local(-4350,p1)
		elseif ball.posX()<-2500 then
			res=ball.pos()+Utils.Polar2Vector(300,(tar-ball.pos()):dir())
		else
			res=CGeoPoint:new_local(-4350,p1)
		end
		return res
	end

	local idir=function(runner)
		local res
				debugEngine:gui_debug_msg(CGeoPoint(1000,1000),ball.velMod())
		res=(ball.pos()-player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function pointToBall()
	local ipos=function(runner)
		local res
		res=player.pos(runner)
		return res
	end
	local idir=function(runner)
		local res
		res=(ball.pos()-player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.not_avoid_our_vehicle+flag.safe,rec = r,vel = v}
	return {mexe, mpos}
end

function robotGoOut()
	local ipos=function(runner)
		local res
		res=player.pos(runner)+Utils.Polar2Vector(200,(player.pos(runner)-ball.pos()):dir())
		return res
	end
	local idir=function(runner)
		local res
		res=(ball.pos()-player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.nothing,rec = r,vel = v}
	return {mexe, mpos}
end

function ballInPlace(tar)
	if (ball.pos()-tar):mod()<=150 then
		return true
	else
		return false
	end
end

function robotOutPlace(tar,r)
	if (player.pos(r)-tar):mod()>500 then
		return false
	else
		return true
	end
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

function passBall(tar,power,carFront,angleLimit,needChip,ckpower,f)
	local ipower = power and power or 6000
	local icarFront = carFront or 95
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
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>35 then
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

function goToPoint(p, d)
	local idir=function(runner)
		local res
		if d~=nil then
			if type(d)=="string" then
				res=(player.pos(d)-player.pos(runner)):dir()
			elseif type(d)=="function" then
				res=(d()-player.pos(runner)):dir()
			end
		else
				res=(ball.pos()-player.pos(runner)):dir()
		end
		return res
	end
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function getBall(tar,dist,f)
	local iflag = f or (flag.allow_dss+flag.dodge_ball)
	local idist = dist or 300
	local ipos=function(runner)
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
			res=ball.pos()+Utils.Polar2Vector(idist,(CGeoPoint(-4500,0)-ball.pos()):dir())
		end

		return res
	end

	local idir=function(runner)
		local res
			res=(ball.pos()-player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos}
end



function ac(r,b1,b2)--八字判断同步
	local a1
		a1=math.abs(toAngle(Utils.Normalize((((player.pos(b1)-player.pos(r)):dir()-(player.pos(b2)-player.pos(r)):dir())))))
	return a1
	
end
function angle(r,b1,b2)--八字绕圈判断角度
	local a1
		a1=toAngle(Utils.Normalize((((player.pos(b1)-player.pos(r)):dir()-(player.pos(b2)-player.pos(r)):dir()))))
	return a1
	
end

function AngleRangeU()
	local a
	local p=p or CGeoPoint(-4500,-1000)
	local p1=CGeoPoint(-4500,10)
		a=math.abs(toAngle(Utils.Normalize((((ball.pos()-p):dir()-(p1-p):dir())))))
	return a
end
function AngleRangeD()
	local a
	local p=p or CGeoPoint(-4500,1000)
	local p1=CGeoPoint(-4500,10)
		a=math.abs(toAngle(Utils.Normalize((((ball.pos()-p):dir()-(p1-p):dir())))))
	return a
end
local r1=550--八字直线的定点半径
function compare()
	local res
	res=ac(0,1,2)-ac(3,1,2)
	--0车的目的地点
	local tar1=player.pos(2)+Utils.Polar2Vector(r1,(player.pos(2)-player.pos(1)):dir()-math.pi/2)
	local tar2=player.pos(1)+Utils.Polar2Vector(r1,(player.pos(1)-player.pos(2)):dir()+math.pi/2)
	--3车的目的地点
	local tar3=player.pos(1)+Utils.Polar2Vector(r1,(player.pos(1)-player.pos(2)):dir()-math.pi/2)
	local tar4=player.pos(2)+Utils.Polar2Vector(r1,(player.pos(2)-player.pos(1)):dir()+math.pi/2)
	if pMSG.f5 == 2 and pMSG.f6 == 2 then
		if math.abs(res)>40 then
			if res>0 then
				if (player.pos(0)-tar1):mod()<(player.pos(1)-tar3):mod() then
					return 0
				else 
					return 3
				end
			elseif res<0 then
				if (player.pos(0)-tar1):mod()<(player.pos(1)-tar3):mod() then
					return 0
				else 
					return 3
				end
			end
		else 
			return 1
		end
	else
		return 1
	end
end

function Halt()
	local ipos = function(runner)
		local res
		res = player.pos(runner)
		return res
	end

	local idir = function(runner)
		local res
		res = (ball.pos()-player.pos(runner)):dir()
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.nothing,rec = r,vel = v}
	return {mexe, mpos}
end


function defineState()
	pMSG.f = pMSG.f +1
end

function precision(x,y)
	if math.abs(toAngle(x)-toAngle(y))>-35 and math.abs(toAngle(x)-toAngle(y))<35 then
		return true
	end
end

function initialPos(r1,r2)--八字绕球的初始位置
	local ipos=function(runner)
		local res
		res=player.pos(r1)+Utils.Polar2Vector(radius,(player.pos(r1)-player.pos(r2)):dir())
		return res
	end

	local idir=function(runner)
		local res
		res=(player.pos(r1)-player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.not_avoid_our_vehicle+flag.safe,rec = r,vel = v}
	return {mexe, mpos}
end 
function ballAngle()--八字绕圈判断角度
	local a1
		a1=toAngle(Utils.Normalize((((player.pos(2)-player.pos(1)):dir()-(ball.pos()-player.pos(1)):dir()))))
	return a1
	
end

function point3() 

	local ipos=function(runner)

		local p1=player.pos(1)
		local p2=player.pos(2)
		local p=player.pos(runner)
		local d1=(p-p1):mod()
		local d2=(p-p2):mod()
		local tar1=p2+Utils.Polar2Vector(r1,(p2-p1):dir()-math.pi/2)
		local tar2=p1+Utils.Polar2Vector(r1,(p1-p2):dir()+math.pi/2)
		local res
		res=p
		local distance1=(p-tar1):mod()
		local distance2=(p-tar2):mod()
		debugEngine:gui_debug_msg(tar1,"X")
		if math.abs(angle(1,0,2))>40 and d1<d2 then
			pMSG.f3 = 1
		elseif math.abs(angle(1,0,2))<45 and (pMSG.f3 == 1 or pMSG.f3 == 2 ) then
			pMSG.f3 = 2
			pMSG.f5 = 2
		end
		if  math.abs(angle(2,0,1))>40 and d1>d2  then
			pMSG.f3 = 3
		elseif math.abs(angle(2,0,1))<45 and (pMSG.f3 == 3 or pMSG.f3 == 4 ) then
			pMSG.f3 = 4
			pMSG.f5 = 4
		end
		
		--判断是否同步
		if pMSG.f3 ==1  then
			res=p1+Utils.Polar2Vector(radius,(p-p1):dir()-math.pi/k)
		elseif pMSG.f3 ==2 then
			-- if compare(1)==0 then
			-- 	res=p
			-- else	
				res=tar1
			-- end
		elseif pMSG.f3 ==3 then
			res=p2+Utils.Polar2Vector(radius,(p-p2):dir()+math.pi/k)
		elseif pMSG.f3 ==4 then
			-- if compare(1)==0 then
			-- 	res=p
			-- else
				res=tar2
			-- end
		end
		return res
	end

	local idir= function(runner)
		local res
		res=player.velDir(runner)
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.not_avoid_our_vehicle+flag.safe,rec = r,vel = v}
	return {mexe, mpos}
end


function point4()

	local ipos=function(runner)

		local p1=player.pos(1)
		local p2=player.pos(2)
		local p=player.pos(runner)
		local d1=(p-p1):mod()
		local d2=(p-p2):mod()
		local tar1=p1+Utils.Polar2Vector(r1,(p1-p2):dir()-math.pi/2)
		local tar2=p2+Utils.Polar2Vector(r1,(p2-p1):dir()+math.pi/2)
		local res
		local distance1=(p-tar1):mod()
		local distance2=(p-tar2):mod()
		res=player.pos(runner)
		-- debugEngine:gui_debug_msg(tar1,"X")
		-- debugEngine:gui_debug_msg(tar2,"X")
		if math.abs(angle(2,3,1))>40 and d2<d1 then
			pMSG.f4 = 1
		elseif math.abs(angle(2,3,1))<45 and (pMSG.f4 == 1 or pMSG.f4 == 2 ) then
			pMSG.f4 = 2
			pMSG.f6 = 2
		end
		if math.abs(angle(1,3,2))>40 and d1<d2 then
			pMSG.f4 = 3
		elseif math.abs(angle(1,3,2))<45 and (pMSG.f4 == 3 or pMSG.f4 == 4 ) then
			pMSG.f4 = 4
			pMSG.f6 = 4
		end
		
		if pMSG.f4 ==1  then
			res=p2+Utils.Polar2Vector(radius,(p-p2):dir()-math.pi/k)
		elseif pMSG.f4 ==2 then
			if compare(-1)==3 then
				res=player.pos(runner)
			else 	
				res=tar1
			end
		elseif pMSG.f4 ==3 then
			res=p1+Utils.Polar2Vector(radius,(p-p1):dir()+math.pi/k)
		elseif pMSG.f4 ==4 then
			if compare(-1)==3 then
				res=player.pos(runner)
			else 
				res=tar2
			end
		end
		return res
	end

	local idir=function(runner)
		local res
		res=player.velDir(runner)
		return res
	end

	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.not_avoid_our_vehicle+flag.safe,rec = r,vel = v}
	return {mexe, mpos}
end

function toAngle(n)
	return n/(math.pi/180)
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









-- function shootToRobot(dist,dir,ff)
-- 	local idir
-- 	local f
-- 	if dir ~=nil then
-- 		idir = dir 
-- 	else
-- 		idir = 0
-- 	end
-- 	if ff ~=nil then
-- 		f = ff 
-- 	else
-- 		f = flag.dribbling
-- 	end
-- 	-- local idir=function(runner)
-- 	-- 	local res
-- 	-- 	if type(tar)=="string" then
-- 	-- 		res=(ball.pos()-player.pos(tar)):dir()
-- 	-- 	end
-- 	-- 	return res
-- 	-- end
-- 	local ipos = function(runner)
-- 		local res 
-- 		local robotpos=player.pos("b")
-- 		res = ball.pos()+ Utils.Polar2Vector(dist,(ball.pos()-robotpos):dir())
-- 		return res
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end




function tokick(a,b)
	local res
	if bufcnt(player.toTargetDist("a")<50,10) then
		res=palyer.pos("[a]")+Utils.Polar2Vector(100,player.vel("[b]"))
	end
end

function attack()
	local ipos=function()
		local res
		res=ball.pos()+Utils.Polar2Vector(-180,ball.toTheirGoalDir())
		return res
	end
	local idir=function(runner)
		local res
		local str='11'
		if ball.velMod()<500 then
			str='22'
			res=ball.toTheirGoalDir()
		else
			str='33'
			res=(ball.pos()-player.pos(runner)):dir()
		end
		return res
	end
	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function inter()
	local ipos=function()
		local res
		if ball.velMod()<500 then
			str='22'
			res=ball.pos()+Utils.Polar2Vector(100,ball.toTheirGoalDir())
		else
			str='33'
			res=ball.pos()+Utils.Polar2Vector(1000,ball.vel():dir())
		end
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,200),"debug!"..ball.velMOd())
		return res
	end
	local idir=function(runner)
		local res
		local str='11'
		if ball.velMod()<500 then
			str='22'
			res=ball.toTheirGoalDir()
		else
			str='33'
			res=(ball.pos()-player.pos(runner)):dir()
		end
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),"debug!"..ball.velMOd())
		return res
	end
	local mexe, mpos = GoCmuRush{pos =ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end


function serve()
	local ipos=function(runner)
		local res
		res = ball.pos() + Utils.Polar2Vector((ball.pos()-player.pos(runner)):mod(),ball.velDir())
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}	
end

-- function shoot1(tar)
-- 	local ipos=player.pos(tar)
-- 	local ipower = power and power or 4000
-- 	local idir
-- 		idir = (ball.pos() - player.pos(tar)):dir()

-- 	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.kick,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end

function receive(tar,dist,needchase)
	local idist = dist or 100
	local ipos = function(runner)
		local res
		res = ball.pos() + Utils.Polar2Vector((ball.pos()-player.pos(runner)):mod(),ball.velDir())
		if player.toBallDist(runner)<300 or ball.velMod()<500 then --to target
			if tar ~=nil then
				if type(tar) == "string" then
		 			itar = (ball.pos() - player.pos(tar)):dir()
		 			debugEngine:gui_debug_msg(CGeoPoint:new_local(2000,0),"player.posX(tar)")
		 			local l =player.toBallDist(tar)
		 			debugEngine:gui_debug_msg(CGeoPoint:new_local(1000,1000),idist .. "||||||||||" .. l)
		 		elseif type(tar) == "function" then
		 			itar = (ball.pos() - tar()):dir()	
		 		else
		 			itar = (ball.pos() - tar):dir()
		 		end
		 	else
		 		itar = (player.pos(runner) - ball.pos()):dir()
			end
			
		 	res = ball.pos() + Utils.Polar2Vector(idist,itar)
		 
		elseif needchase and ball.velMod()<3000 then --to getball early
			chaseLength = math.max(idist,player.toBallDist(runner)*80/100)
			res = ball.pos() + Utils.Polar2Vector(chaseLength,ball.velDir())
		else --receive ball
		 	res = ball.pos() + Utils.Polar2Vector(player.toBallDist(runner),ball.vel():dir())
		end

		-- res = ball.pos()

		return res
	end

	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end
	f = flag.dribbling
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.dribble,rec = r,vel = v}
	return {mexe, mpos}	
end





function waitForAttack()
	local checkAttacker=function(runner)
		for i=0,param.maxPlayer-1 do
			local dis=(ball.pos()-player.pos(i)):mod()
			if player.valid(i) and dis<1000 and i~=runner then
				debugEngine:gui_debug_msg(CGeoPoint:new_local(0,i*200),i..(player.valid(i) and ' T ' or ' F ')..dis)
				return i
			end
		end
		return -1
	end
	local ipos=function(runner)
		local num = checkAttacker(runner)
		local x=player.posX(num)
		local y=player.posY(num)
		local length=param.pitchLength/2
		return CGeoPoint:new_local(length-x,-y)
	end
	local idir=function(runner)
		return player.toTheirGoalDir(runner)
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end



function hylniubiAttcak_alpha(carFront,angleLimit,f)
	local power=function(runner)
		local ipower = 0
		return function (runner)
			x,y = Cnbut_pushNumber()
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
			return ipower
		end
	end
	local icarFront = carFront or 95
	local ipre = angleLimit and pre.specified(angleLimit) or pre.high
	local ikick = needChip and kick.chip or kick.flat
	local icp = ckpower and kp.specified(ckpower) or cp.full
	local iflag = f and f or flag.dribbling

	local itar
	local ipos = function(runner)
		x,y,f0,f1,f2 = Cnbut_pushNumber()
		local pos = CGeoPoint:new_local(x,y)
		itar=pos
		local res
		res = ball.pos() + Utils.Polar2Vector(icarFront,(ball.pos() - itar):dir())
		if player.toBallDist(runner)>200 then
			res=ball.pos() + Utils.Polar2Vector(icarFront,(player.pos(runner)-ball.pos()):dir())
		end

		return res
		
	end
	local idir = function(runner)
		x,y,f0,f1,f2 = Cnbut_pushNumber()
		local pos = CGeoPoint:new_local(x,y)
		itar=pos
		local res
		local cF = player.pos(runner)+Utils.Polar2Vector(icarFront,player.dir(runner))
		if (cF-ball.pos()):mod()>35 then
			itar=ball.pos()
		end

		res = (itar - player.pos(runner)):dir()
		return res 
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = iflag,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, ipre, power(), icp, iflag}
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


-- function Halt()
-- 	local ipos= function(runner)
-- 		local res
-- 		res = player.pos(runner)
-- 		return res
-- 	end
-- 	local idir = function(runner)
-- 		local res
-- 		res = player.dir(runner)
-- 		return res
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = flag.nothing,rec = r,vel = v}
-- 	return {mexe, mpos}
-- end


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

function switch(me,p2,p4,center)
	if math.abs((me-p2):dir()-math.pi/2) < math.pi/10 and  me:x()<center:x() and me:y()>center:y() then
		pMSG.f = 1
		if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
			pMSG.check=1
		end
	elseif math.abs((me-p4):dir()-math.pi/2) < math.pi/10 and me:x()>center:x() and me:y()>center:y() then
		pMSG.f = -1
		if pMSG.check == 1 then
			pMSG.check=0
		end
	end
end
function switch2(me,p2,p4,center)
	if math.abs((me-p2):dir()+math.pi/2) < math.pi/10 and me:x()<center:x() and me:y()<center:y() then
		pMSG.f2 = -1
		if pMSG.check == 1 then
			pMSG.check=0
		end
	elseif math.abs((me-p4):dir()+math.pi/2) < math.pi/10 and me:x()>center:x() and me:y()<center:y() then
		pMSG.f2 = 1
		if pMSG.check == 0 and pMSG.f ~=pMSG.f2 then
			pMSG.check=1
		end
	end
end

function nhy(p2,p3,p4)
	local ipos= function(runner)
		local me = player.pos(runner)
		-- local p2 = player.pos(2)
		-- local p4 = player.pos(4)
		-- local p3 = player.pos(1)
		local center = player.pos(1)
		-- local center = CGeoPoint((p2:x()+p4:x())/2,(p2:y()+p4:y())/2)

		debugEngine:gui_debug_msg(center,pMSG.f)
		local c2_s = p2 + Utils.Polar2Vector(myradius1,(me-p2):dir()-math.pi/myk1)
		local c3_s = center + Utils.Polar2Vector(myradius2,(me-center):dir()-math.pi/myk2)
		local c3_n = center + Utils.Polar2Vector(myradius2,(me-center):dir()+math.pi/myk2)
		local c4_n = p4 + Utils.Polar2Vector(myradius1,(me-p4):dir()+math.pi/myk1)
		local ang = (me-center):dir()
		switch(me,p2,p4,center)
		if pMSG.f == 1 then
			if me:x()<center:x() then
				res = c3_s
			else
				res = c4_n
			end
		else
			if me:x()>center:x() then
				res = c3_n
			else
				res = c2_s
			end
			
		end
		return res
		-- return player.pos(runner)
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
		-- local p2 = player.pos(2)
		-- local p4 = player.pos(4)
		-- local p3 = player.pos(0)
		local center = player.pos(0)
		-- local center = CGeoPoint((p2:x()+p4:x())/2,(p2:y()+p4:y())/2)
		debugEngine:gui_debug_msg(center,pMSG.f2)
		local c2_n = p2 + Utils.Polar2Vector(myradius1,(me-p2):dir()+math.pi/myk1)
		local c3_s = center + Utils.Polar2Vector(myradius2,(me-center):dir()-math.pi/myk2)
		local c3_n = center + Utils.Polar2Vector(myradius2,(me-center):dir()+math.pi/myk2)
		local c4_s = p4 + Utils.Polar2Vector(myradius1,(me-p4):dir()-math.pi/myk1)
		local ang = (me-center):dir()
		switch2(me,p2,p4,center)
		if pMSG.f2 == 1 then
			if me:x()>center:x() then
				res = c3_s
			else
				res = c2_n
			end
		else
			if me:x()<center:x() then
				res = c3_n
			else
				res = c4_s
			end
		end
		return res
		-- return player.pos(runner)
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
-- function waitForAttack()
-- 	local checkAttacker = function(runner)
-- 		for i=0,param.maxPlayer-1 do
-- 			local dis = (ball.pos()-player.pos(i)):mod()
-- 			if player.valid(i) and dis <1000 and i ~=runner then
-- 				debugEngine:gui_debug_msg(CGeoPoint:new_local(0,i*200),i .. (player.valid(i) and '   T   ' or '   F   ') .. dis)
-- 				return i
-- 			end
-- 		end
-- 		return -1
-- 	end

-- 	local ipos = function(runner)
-- 		local num = checkAttacker(runner)
-- 		local x = 2000
-- 		local y = 500*player.posY(num)/(player.posX(num)-4500) 
-- 		if y>2500 then
-- 			y = 2500
-- 		elseif y<-2500 then
-- 			y= -2500
-- 		end  
-- 		if ball.posX()<1000 then
-- 			Yylmarking(1,2,0)
-- 		end
-- 		return CGeoPoint:new_local(x,y)
-- 	end

-- 	local idir = function(runner)
-- 		return player.toTheirGoalDir(runner)
-- 	end
-- 	if ball.posX()<1000 then
-- 		return Yylmarking(1,2,0)
-- 	end
-- 	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
-- 	return {mexe, mpos}	
-- end

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

function mygetBall(p,dist,f,a)
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


--参数说明
-- 不可缺省参数： tar 传球的目标点
-- 可缺省参数：power 平射力度，carFront 小车吸球嘴到小车几何中心的距离，angleimit 允许的精度误差范围在0～180，
	--needChip是否允许跳球，ckpower 挑球力度，f 控制小车动作的一个标记，通常不填




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
		drawDebug()
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
