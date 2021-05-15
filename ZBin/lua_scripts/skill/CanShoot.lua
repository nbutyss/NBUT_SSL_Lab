-- function CanShoot(task)
-- 	local mcarFront = task.carFront or 95
-- 	local mlengthLimit = task.lengthLimit or 30
-- 	local mkickprecision = task.kickprecision or 180.0
-- 	local mkickpower = task.kickpower or 6500
-- 	local mrole   = task.srole or ""

-- 	matchPos = function()
-- 		return pos.ourGoal()
-- 	end

-- 	execute = function(runner)
-- 		if runner >=0 and runner < param.maxPlayer then
-- 			if mrole ~= "" then
-- 				CRegisterRole(runner, mrole)
-- 			end
-- 		else
-- 			print("Error runner in Goalie", runner)
-- 		end

-- 		return CCanShoot(runner,mcarFront,mlengthLimit,mkickprecision,mkickpower)
-- 	end

-- 	return execute, matchPos
-- end


-- gSkillTable.CreateSkill{
-- 	name = "CanShoot",
-- 	execute = function (self)
-- 		print("This is in skill"..self.name)
-- 	end
-- }
function CanShoot(task)
	local mcarFront = task.carFront or 80
	local mlengthLimit = task.lengthLimit or 30
	local mkickprecision = task.kickprecision or 180.0
	local mkickpower = task.kickpower or 500
	local mrole   = task.srole or ""
	local myflag = task.flag or flag.dribbling

	-- if p == "string" then
		-- mpos = player.pos(task.p)
	-- else
	-- 	mposx = task.p.x
	-- end

	matchPos = function(runner)
		return player.pos(runner)
	end

	execute = function(runner)
	
		if runner >=0 and runner < param.maxPlayer then
			if mrole ~= "" then
				CRegisterRole(runner, mrole)
			end
		else
			print("Error runner in Goalie", runner)
		end
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,0),task.p)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-4500,1000),player.posX(task.p))
	
	local mpos
	if task.p ~= nil then
		mpos = player.pos(task.p)
	else
		mpos = CGeoPoint:new_local(4500,0)
	end 

		return CCanShoot(runner,mcarFront,mlengthLimit,mkickprecision,mkickpower,mpos:x(),mpos:y(),myflag)
	end

	return execute, matchPos
end


gSkillTable.CreateSkill{
	name = "CanShoot",
	execute = function (self)
		print("This is in skill"..self.name)
	end
}