IS_TEST_MODE = false
IS_SIMULATION = CGetIsSimulation()
USE_SWITCH = false
USE_AUTO_REFEREE = false
OPPONENT_NAME = "Other"
SAO_ACTION = CGetSettings("Alert/SaoAction","Int")
IS_YELLOW = CGetSettings("ZAlert/IsYellow","Bool")
IS_RIGHT = CGetSettings("ZAlert/IsRight", "Bool")
DEBUG_MATCH = CGetSettings("Debug/RoleMatch","Bool")

gStateFileNameString = string.format(os.date("%Y%m%d%H%M"))
 
gTestPlay = "NormalPlayV1"

gRoleFixNum = {
        -- ["Kicker"]   = {},
        ["Goalie"]   = {0},
        -- ["Tier"]     = {},

        -- ["a"] = {0},
        -- ["b"] = {},
        -- ["c"] = {},
        ["d"] = {1},
        ["e"] = {2}
}

-- 用来进行定位球的保持
-- 在考虑智能性时用table来进行配置，用于OurIndirectKick
gOurIndirectTable = {
        -- 在OurIndirectKick控制脚本中可以进行改变的值
        -- 上一次定位球的Cycle
        lastRefCycle = 0
}

gSkill = {
        "SmartGoto",
        "SimpleGoto",
        "RunMultiPos",
        "Stop",
        "Goalie",
        "Touch",
        "CanShoot",
        "OpenSpeed",
        "Speed",
        "GotoMatchPos",
        "GoCmuRush",
        "NoneZeroRush",
        "SpeedInRobot"
}

gRefPlayTable = {
        "Ref/Ref_HaltV1",
        "Ref/Ref_OurTimeoutV1",
        "Ref/GameStop/Ref_Stop",
        "Ref/Ref_def_yyn",
-- BallPlacement
        "Ref/BallPlacement/Ref_BallPlace_nhy",
        "Ref/BallPlacement/Ref_BallPlace2Stop",
-- Penalty
        "Ref/PenaltyDef/Ref_PenaltyDef_yyn",
        "Ref/PenaltyKick/Ref_PenaltyKickV1",
        "Ref/PenaltyKick/Ref_PenaltyKick_nhy",
-- KickOff
        "Ref/KickOffDef/Ref_KickOffDef_hyl",
        "Ref/KickOff/Ref_KickOff_ljr",
-- FreeKickDef
        "Ref/CornerDef/Ref_CornerDefV1",
        "Ref/FrontDef/Ref_FrontDefV1",
        "Ref/MiddleDef/Ref_MiddleDefV1",
        "Ref/BackDef/Ref_BackDefV1",
-- FreeKick
        "Ref/CornerKick/Ref_CornerKick_lzk",
        "Ref/CornerKick/Ref_CornerKick_jxy",
        "Ref/FrontKick/Ref_FrontKickV1",
        "Ref/MiddleKick/Ref_MiddleKick_hyl",
        "Ref/BackKick/Ref_BackKick_cjl",
}

gBayesPlayTable = {
        "Nor/NormalPlayV1",
}

gTestPlayTable = {

        "Test/theirBall",
        "Test/TestRun",
        "Test/TestSkill",
        "Test/TestDribbleAndKick",
        "Test/RunMilitaryBoxing",
        "Test/08",
        "Test/forplenty",
        "Test/cornerdef",
        "Test/placeBall",
        "Test/hyl_dianqiukick",
        "Test/yyl",
        -- "Test/TestRun",
        -- "Test/TestSkill",
        "Test/TestSkill2",
        "Test/TestDef",
        -- "Test/TestDribbleAndKick",
        -- "Test/RunMilitaryBoxing",
        "Test/FQTest",
        "Test/defendMiddle"
}


-- IS_TEST_MODE = true
-- IS_SIMULATION = CGetIsSimulation()
-- USE_SWITCH = false
-- USE_AUTO_REFEREE = false
-- OPPONENT_NAME = "Other"
-- SAO_ACTION = CGetSettings("Alert/SaoAction","Int")
-- IS_YELLOW = CGetSettings("ZAlert/IsYellow","Bool")
-- IS_RIGHT = CGetSettings("ZAlert/IsRight", "Bool")
-- DEBUG_MATCH = CGetSettings("Debug/RoleMatch","Bool")

-- gStateFileNameString = string.format(os.date("%Y%m%d%H%M"))

-- gTestPlay = "NormalPlayV1"

-- gRoleFixNum = {
--         ["Goalie"]   = {0},
--         -- ["Kicker"]   = {1},
--         -- ["Tier"]     = {2},
--         -- ["Receiver"] = {3},
--         -- ["a"] = {},
--         -- ["b"] = {},
--         -- ["c"] = {},
--         ["d"] = {2},
--         ["e"] = {1}
-- }

-- -- 用来进行定位球的保持
-- -- 在考虑智能性时用table来进行配置，用于OurIndirectKick
-- gOurIndirectTable = {
--         -- 在OurIndirectKick控制脚本中可以进行改变的值
--         -- 上一次定位球的Cycle
--         lastRefCycle = 0
-- }

-- gSkill = {
--         "SmartGoto",
--         "SimpleGoto",
--         "RunMultiPos",
--         "Stop",
--         "Goalie",
--         "Touch",
--         "OpenSpeed",
--         "Speed",
--         "GotoMatchPos",
--         "GoCmuRush",
--         "NoneZeroRush",
--         "SpeedInRobot",
--         "CanShoot"
-- }

-- gRefPlayTable = {
--         "Ref/Ref_HaltV1",
--         "Ref/Ref_OurTimeoutV1",
--         "Ref/GameStop/Ref_StopV1",
--         "Ref/GameStop/Ref_StopV2",
-- -- BallPlacement
--         -- "Ref/BallPlacement/Ref_BallPlace2Stop",
-- -- Penalty
--         "Ref/PenaltyDef/Ref_PenaltyDefV1",
--         "Ref/PenaltyKick/Ref_PenaltyKickV1",
-- -- KickOff
--         "Ref/KickOffDef/Ref_KickOffDefV1",
--         "Ref/KickOff/Ref_KickOffV1",
-- -- FreeKickDef
--         "Ref/CornerDef/Ref_CornerDefV1",
--         "Ref/FrontDef/Ref_FrontDefV1",
--         "Ref/MiddleDef/Ref_MiddleDefV1",
--         "Ref/BackDef/Ref_BackDefV1",
-- -- FreeKick
--         "Ref/CornerKick/Ref_CornerKickV0",
--         "Ref/CornerKick/Ref_CornerKickV1",
--         "Ref/CornerKick/Ref_CornerKickV2",
--         "Ref/CenterKick/Ref_CenterKickV1",
--         "Ref/FrontKick/Ref_FrontKickV1",
--         "Ref/MiddleKick/Ref_MiddleKickV1",
--         "Ref/BackKick/Ref_BackKickV1"
-- }

-- gBayesPlayTable = {
--         "Nor/NormalPlayV1"
-- }

-- gTestPlayTable = {
--         "Nor/NormalPlayV1",
--         "Test/TestRun",
--         "Test/TestSkill",
--         "Test/TestDribbleAndKick",
--         "Test/RunMilitaryBoxing",
--         "Test/hyltest",
--         "Test/hyl008",
--         "Test/hyl"
-- }
