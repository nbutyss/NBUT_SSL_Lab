-- 在进入每一个定位球时，需要在第一次进时进行保持
--need to modify
gNorPass2NorDefBallVel = 150
gMarkFront2Finish = 180
gMarkFront2Def = 160
gNorPass2NorDefCouter = 8
-- if ball.refPosX() < -0.3 * param.pitchLength then
-- 	-- dofile("./lua_scripts/play/Ref/CornerDef/CornerDef.lua")
-- 		gCurrentPlay = "jxy_jiaoqiu1"

-- if ball.refPosX() > 0 * param.pitchLength then
		gCurrentPlay = "Ref_def_yyn"
	-- dofile("./lua_scripts/play/Ref/FrontDef/FrontDef.lua")
-- elseif ball.refPosX() > 0 then
-- 		gCurrentPlay = "Ref_def_yyn"
	-- dofile("./lua_scripts/play/Ref/MiddleDef/MiddleDef.lua")
-- else
-- 		gCurrentPlay = "Ref_def_yyn"
	-- dofile("./lua_scripts/play/Ref/BackDef/BackDef.lua")
-- end
