-- 在进入每一个定位球时，需要在第一次进时进行保持
--need to modify
if math.abs(ball.refPosY()) < 1/3 * param.pitchWidth then
	-- dofile("./lua_scripts/play/Ref/CenterKick/CenterKick.lua")
	gCurrentPlay = "Ref_MiddleKick_hyl"

else
	if ball.refPosX() > 3500 then
		-- dofile("./lua_scripts/play/Ref/CornerKick/CornerKick.lua")
		gCurrentPlay = "Ref_CornerKick_lzk"
	elseif ball.refPosX() > 2000 and ball.refPosX() <= 3500 then
		-- dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
		gCurrentPlay = "Ref_MiddleKick_hyl"
	elseif ball.refPosX() > -2000 and ball.refPosX() <= 2000 then
		-- dofile("./lua_scripts/play/Ref/MiddleKick/MiddleKick.lua")
		gCurrentPlay = "Ref_MiddleKick_hyl"
	else
		-- dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
		gCurrentPlay = "Ref_BackKick_cjl"
	end
end

-- gCurrentPlay = "TestFreeKick"

gOurIndirectTable.lastRefCycle = vision:getCycle()