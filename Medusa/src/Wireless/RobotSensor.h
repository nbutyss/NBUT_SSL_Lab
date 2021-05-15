#ifndef _ROBOT_FILTERED_INFO_H_
#define _ROBOT_FILTERED_INFO_H_

//#include <CommControl.h>
#include <singleton.h>
#include "staticparams.h"

/*
* 小车本体感知信息接收处理 created by qxz
*/

/// 预定义的一些常量宏
#define MAX_STORE_SIZE 5  // 保留最近5帧的信息
#define NO_KICK 0
#define IS_FLAT_KICK_ON 1
#define IS_CHIP_KICK_ON 2
#define LOWEST_ENERGY 0
#define LOW_ENERGY 1
#define NORMAL_ENERGY 2
#define HIGH_ENERGY 3
#define HIGHEST_ENERGY 4
#include <mutex>
#include "parammanager.h"
#include "GDebugEngine.h"
#include "VisionModule.h"

struct RobotMsg{
    std::mutex _mutex;
    bool infrared;
    int fraredOn;
    int fraredOff;
    unsigned char flat_kick;
    unsigned char chip_kick;
    CGeoPoint dribblePoint;
    RobotMsg():infrared(false),fraredOn(0),fraredOff(0),flat_kick(0),chip_kick(0){}
};

/// 机器人本体感知信息
class CRobotSensor{
public:
	// 构造函数
    CRobotSensor() {
        ZSS::ZParamManager::instance()->loadParam(DEBUG_DEVICE,"Debug/DeviceMsg",false);
    }
	// 析构函数
	~CRobotSensor() {}

    // 全局更新接口
    void Update(const CVisionModule* pVision);

	// 小车是否产生红外信号，一般表示球在嘴前方
    bool IsInfraredOn(int num)              { return robotMsg[num].infrared; }

    int fraredOn(int num) { return robotMsg[num].fraredOn; }

    int fraredOff(int num) { return robotMsg[num].fraredOff; }

    CGeoPoint dribblePoint(int num) { return robotMsg[num].dribblePoint; }

	// 小车有否启动平射或挑射的机构
    int IsKickerOn(int num) {
        if(robotMsg[num].chip_kick > 0)
            return IS_CHIP_KICK_ON;
        else if(robotMsg[num].flat_kick > 0)
            return IS_FLAT_KICK_ON;
        else
            return 0;
    }
	
	// 小车是否控制着球，要修改
    bool isBallControled(int num)			{ return robotMsg[num].infrared; }

    RobotMsg robotMsg[PARAM::Field::MAX_PLAYER];
    bool DEBUG_DEVICE;
};

typedef NormalSingleton< CRobotSensor > RobotSensor;			// 全局访问接口
#endif
