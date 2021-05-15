/************************************************************************/
/* Copyright (c) CSC-RL, Zhejiang University							*/
/* Team:			SSL-ZJUNlict										*/
/* HomePage: http://www.nlict.zju.edu.cn/ssl/WelcomePage.html			*/
/************************************************************************/
/* File:	DecisionModule.h											*/
/* Brief:	C++ Implementation: Decision	execution					*/
/* Func:	Provide a decision interface for Strategy, Play selecting	*/
/* Author:	cliffyin, 2012, 08											*/
/* Refer:	NONE														*/
/* E-mail:	cliffyin007@gmail.com										*/
/************************************************************************/
//#include "VisionModule.h"
#include "DecisionModule.h"
#include <skill/Factory.h>
#include <TaskMediator.h>
#include <PlayInterface.h>
#include <skill/BasicPlay.h>
#include "LuaModule.h"
#include "Semaphore.h"



extern Semaphore vision_to_decision;
Semaphore decision_to_action(0);
namespace {
	/// 是否状态化的策略库
    bool USE_LUA_SCRIPTS = true;
	/// 当前的配合策略
	CBasicPlay* play = NULL;
}

CDecisionModule::CDecisionModule(CVisionModule* pVision): _pVision(pVision){
    LuaModule::Instance()->RunScript("./lua_scripts/StartZeus.lua");
}

CDecisionModule::~CDecisionModule(void){
}

void CDecisionModule::DoDecision(const bool visualStop)
{
	vision_to_decision.Wait();
	/************************************************************************/
	/* 清空上一周期的历史任务                                               */
	/************************************************************************/
	TaskMediator::Instance()->cleanOldTasks();


    /************************************************************************/
    /* 截球点和截球时间计算   add by Wang in 2018/5/31                   */
    /************************************************************************/
    smartPlanner(_pVision);
//    nbut_suannumber(_pVision);


	/************************************************************************/
	/* 选取合适的Play，进行任务分配                                         */
	/************************************************************************/
    GenerateTasks(visualStop);	
	
	/************************************************************************/
	/* 进行任务的规划，逐次进行子任务的设定                                 */
	/* 每个队员都分配了skill,并对每个skill进行了规划						*/
	/* (除了GotoPosition里的命令计算还没执行,需要在execute时执行)			*/
	/************************************************************************/
	PlanTasks();

	decision_to_action.Signal();
	return ;
}

void CDecisionModule::GenerateTasks(const bool visualStop)
{
	// 图像停止 ： 收不到 或者 暂停接受
	if (visualStop) {
		// 每辆小车下发停止任务
		for (int vecNumber = 0; vecNumber < PARAM::Field::MAX_PLAYER; ++ vecNumber) {
			TaskMediator::Instance()->setPlayerTask(vecNumber, PlayerRole::makeItStop(vecNumber), LowestPriority);
		}
		return;
	}

	DoTeamMode();
   
	return ;
}

void CDecisionModule::DoTeamMode()
{
	// 当前策略重置
	play = NULL;

	// 两种策略库进行决策规划
	if (USE_LUA_SCRIPTS){
        LuaModule::Instance()->RunScript("./lua_scripts/SelectPlay.lua");
	} 
	else {
		cout << "NO PLAY!!!" << std::endl;
	}

	return ;
}

void CDecisionModule::PlanTasks()
{
	/************************************************************************/
	/* 按照task的优先级执行:简单的冒泡排序法                                */
	/************************************************************************/
	// 结构定义
    typedef std::pair< int, int > TaskPair;
    typedef std::vector< TaskPair > TaskPairList;

	// 用于存储队员号及其任务的优先级
    TaskPairList taskPairList;	
	taskPairList.clear();

	// 根据获取到得小车任务，进行优先级排序
    for (int num = 0; num < PARAM::Field::MAX_PLAYER; ++ num) {
		// TODO 只有场上看得到且被赋予任务的小车才进行优先级排序，是否会存在问题
		
		if (/*_pVision->ourPlayer(num).Valid() && */TaskMediator::Instance()->getPlayerTask(num)) {
			// 存储所有已经设定好任务的队员,它的skill的priority,用来排序;
			// cout << "in decision module" << num  <<endl;
			taskPairList.push_back(TaskPair(num, TaskMediator::Instance()->getPlayerTaskPriority(num)));
		}
    }

    if (! taskPairList.empty()) {
		// 冒泡法排序,优先级高的在前
		for (int i = 0; i < taskPairList.size()-1; ++ i) {
			for (int j = i+1; j < taskPairList.size(); ++ j) {
				if (taskPairList[i].second < taskPairList[j].second){
					std::swap(taskPairList[i],taskPairList[j]); // 交换顺序
				}
			}
		}
		
		// 按照任务优先级排序的结果进行相对应的任务规划：主要是子任务的设置
		// 一个问题，针对上面由于图像丢车的情况，会如何处理，是否会不进行对应的任务规划
		for (int i = 0; i < taskPairList.size(); ++ i) {
			// 根据taskPairList中的优先级排序,执行各个skill的plan函数,得到各机器人下一周期的GotoPosition任务(任何skill最终都会归属到该基本skill来)
			// (该任务会在之后ActionModule的sendAction函数通过调用各skill的execute函数而得到执行,
			// 并最终计算出各机器人下一周期的x,y速度,是否控球射门等底层指令)
			TaskMediator::Instance()->getPlayerTask(taskPairList[i].first)->plan(_pVision);
		}
	}

	// TODO 对于没有任务的分配到情况予以打印提示，但先不予以处理
	// 最基本的作法是赋予急停处理的任务 MakeUpTask(num)

	return ;
}


bool iscanshoot(CGeoPoint self,const CVisionModule* pVision){
    double PI = 3.141592653589793238462643383;
    CVector left(4500,450),right(4500,-450),robot(self.x(),self.y());
    double dir, b2p_dir, left_dir = (left-robot).dir(), right_dir = (right-robot).dir(), b2p_length, r = 312.5, L,r1 = 312.5;
    CVector p;
    int i, k, maxl, index = -1;
    bool gate[91];
    for (i = 0; i < 91; i++){
        gate[i] = true;
    }
    for (i = 0; i < PARAM::Field::MAX_PLAYER; i++) {
        if (pVision->theirPlayer(i).Valid()){
            const PlayerVisionT& pos = pVision->theirPlayer(i);
            CVector theirpos(pos.X(),pos.Y());
            b2p_dir = (theirpos-robot).dir();

            b2p_length = (theirpos - robot).mod();
            if (abs(b2p_dir) > PI / 2)
                continue;
            if (b2p_length > r)
                dir = asin(r / b2p_length);
            else
            {
                return  false;
                continue;
            }


            if (Utils::Normalize(b2p_dir + dir) > left_dir  && Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                return false;
                continue;
            }
            else if (Utils::Normalize(b2p_dir + dir) > left_dir)
            {
                if (Utils::Normalize(b2p_dir - dir) < left_dir)
                {
                    left_dir = Utils::Normalize(b2p_dir - dir);
                    L = (4500 - robot.x()) / cos(left_dir);
                    p = robot + Utils::Polar2Vector(L, left_dir);
                    for (k = floor(p.y()/10 + 45); k < 91; k++)
                    {
                        gate[k] = false;
                    }
                }
            }
            else if (Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                if (Utils::Normalize(b2p_dir + dir)>right_dir)
                {
                    right_dir = Utils::Normalize(b2p_dir + dir);
                    for (k = 0; k <= floor(p.y()/10 + 45); k++)
                    {
                        gate[k] = false;
                    }
                }
            }
            else if (Utils::Normalize(b2p_dir + dir) < right_dir || Utils::Normalize(b2p_dir - dir)> left_dir){
                continue;
            }
            else
            {
                k = floor(p.y()/10 + 45);
                for (; k <= floor(p.y()/10 + 45); k++)
                {
                    gate[k] = false;
                }
            }
        }
    }

    for (i = 0; i < PARAM::Field::MAX_PLAYER; i++) {
        if (pVision->ourPlayer(i).Valid()){
            const PlayerVisionT& pos = pVision->ourPlayer(i);
            CVector ourpos(pos.X(),pos.Y());
            b2p_dir = (ourpos-robot).dir();
            b2p_length = (ourpos - robot).mod();
            if (abs(b2p_dir) > PI / 2)
            {
                continue;
             }
            if (b2p_length > r)
                dir = asin(r1 / b2p_length);
            else
            {
                return false;
                continue;
            }
            if (Utils::Normalize(b2p_dir + dir) > left_dir  && Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                return false;
                continue;
            }
            else if (Utils::Normalize(b2p_dir + dir) >left_dir)
            {
                if (Utils::Normalize(b2p_dir - dir) < left_dir)
                {
                    left_dir = Utils::Normalize(b2p_dir - dir);
                    L = (4500 - robot.x()) / cos(left_dir);
                    p = robot + Utils::Polar2Vector(L, left_dir);
                    for (k = floor(p.y()/10 + 45); k < 91; k++)
                    {
                        gate[k] = false;
                    }
                }
            }
            else if (Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                if (Utils::Normalize(b2p_dir + dir)>right_dir)
                {
                    right_dir = Utils::Normalize(b2p_dir + dir);
                    L = (4500 - robot.x()) / cos(right_dir);
                    p = robot + Utils::Polar2Vector(L, right_dir);
                    for (k = 0; k <= floor(p.y()/10 + 45); k++)
                    {
                        gate[k] = false;
                    }
                }
            }
            else if (Utils::Normalize(b2p_dir + dir)  < right_dir || Utils::Normalize(b2p_dir - dir)> left_dir)
                continue;
            else
            {
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir - dir));
                p = robot + Utils::Polar2Vector(L, Utils::Normalize(b2p_dir - dir));
                k = floor(p.y()/10 + 45);
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir + dir));
                p = robot +Utils::Polar2Vector(L, Utils::Normalize(b2p_dir + dir));
                for (; k <= floor(p.y()/10 + 45); k++)
                {
                    gate[k] = false;
                }
            }
        }
    }



    for (i = k = maxl = 0; i < 91; i++)
    {
        if (gate[i])
        {
            k++;
        }
        else
        {
            if (k>maxl)
            {
                maxl = k;
                index = i;
                k = 0;
            }
        }
    }
    if (k>maxl)
    {
        maxl = k;
        index = i;
        k = 0;
    }
    if (maxl < 2){
        return false;
    }
    return true;

}

struct myPoint{
    CGeoPoint position;
    double value = 3;
};

bool myJuge(CGeoPoint point){//判断车是否有效
    if(!Utils::IsInFieldV2(point)||point.dist(CGeoPoint(4500,0))<2000)
        return false;
    return true;
}

bool pdjiao(float radiu,CGeoPoint mydian,CGeoPoint tadian,CGeoPoint me,const CVisionModule* pVision){
    double PI = 3.141592653589793238462643383;
    CGeoPoint p1,p2,ball=pVision->ball().Pos();//车对球上下90°的点
    p1 = tadian+Utils::Polar2Vector(radiu,(ball-tadian).dir()+PI/2);//下的点
    p2 = tadian+Utils::Polar2Vector(radiu,(ball-tadian).dir()-PI/2);//上的点
    if (Utils::AngleBetween((mydian-ball).dir(),(p1-ball).dir(),(p2-ball).dir(),0) && (mydian-ball).mod()>((ball - tadian).mod()-radiu))
        return false;
    else if (Utils::AngleBetween((mydian-me).dir(),(p1-me).dir(),(p2-me).dir(),0) && (tadian -mydian).mod()<1000)
        return false;
    return true;

//    if(abs((p1-pVision->ball().Pos()).dir()-(p2-pVision->ball().Pos()).dir())<PI){//判断是否过x轴的负半轴，若不过
//        if((mydian-pVision->ball().Pos()).dir()<(p2-pVision->ball().Pos()).dir()&&(mydian-pVision->ball().Pos()).dir()>(p1-pVision->ball().Pos()).dir()){//点在敌方车的角度内
//            if ((mydian-pVision->ball().Pos()).mod()>((pVision->ball().Pos() - tadian).mod()-radiu)){//敌方车半径300（最好改成可变量）内的点降级
//                return false;
//            }
//        }
//    }
//    else {
//        if(((mydian-pVision->ball().Pos()).dir()<PI&&(mydian-pVision->ball().Pos()).dir()>(p1-pVision->ball().Pos()).dir())
//                ||((mydian-pVision->ball().Pos()).dir()>-PI&&(mydian-pVision->ball().Pos()).dir()<(p2-pVision->ball().Pos()).dir())){//判断过x负半轴点在对方车的角度内的情况
//            if ((mydian-pVision->ball().Pos()).mod()>((pVision->ball().Pos() - tadian).mod()-radiu)){//敌方车半径300（最好改成可变量）内的点降级
//                return false;
//            }
//        }
//    }
//    return true;
}

bool pointBehind(CGeoPoint mydian,CGeoPoint me,const CVisionModule* pVision){
    double PI = 3.141592653589793238462643383;
    CGeoPoint p1,p2,ball=pVision->ball().Pos();
    p1 = me+Utils::Polar2Vector(300,(mydian-me).dir()+PI/8);
    p2 = me+Utils::Polar2Vector(300,(mydian-me).dir()-PI/8);
    if (Utils::AngleBetween((mydian-ball).dir(),(p1-ball).dir(),(p2-ball).dir(),0) && (mydian-ball).mod()>(ball - me).mod()&&(ball - me).mod()>350)
        return true;
    return false;
}

void CDecisionModule::smartPlanner(const CVisionModule* pVision){
    // TODO
    double PI = 3.141592653589793238462643383;
    CGeoPoint self = pVision->ourPlayer(0).Pos();

    int a = 6;//圈数-1
    int b = 20;//圈上点数
    int dist = 1000;//每边上点的间距///////////////////////////////////////////////
    myPoint p[6][20];
//    for(int i = 1;i < a;i++){
//        for(int j = 0;j < b;j++){
//            p[i][j] = pVision->ourPlayer(0).Pos() + Utils::Polar2Vector(dist/a*(i) ,(-PI) + j * (2 * PI) / b );
//        }
//    }
//    GDebugEngine::Instance()->gui_debug_msg(CGeoPoint(1000,-1000),QString("%1 || %2").arg(p[2][2].x()).arg(p[2][2].y()).toLatin1());
//    for(int i=1;i<a;i++){
//        for (int j = 0;j < b;j++){
//            if (myJuge(p[i][j])){
//                GDebugEngine::Instance()->gui_debug_msg(p[i][j],QString("%1").arg("X").toLatin1());
//            }
//        }
//    }
    int c=PARAM::Field::MAX_PLAYER;//车数
    int mycar[PARAM::Field::MAX_PLAYER];
    int theircar[PARAM::Field::MAX_PLAYER];
    int h=0;
    int g=0;
    for(int e=0;e<c;e++){//取出当前我方和敌方有效车
        if(pVision->ourPlayer(e).Valid()){
            mycar[g]=e;
            g++;
        }
        if(pVision->theirPlayer(e).Valid()){
            theircar[h]=e;
            h++;
        }
    }
//    CGeoPoint dfcd[2];

    bool isGreen = false;
    int flag[3] ={0};
    int flag2[3] ={0};
    CGeoPoint best_pos[3];
    CGeoPoint goal (4500,0);
    CGeoPoint plentyArea(3700,0);
    for(int i =0;i<3;i++){
        best_pos[i].setX(0);
        best_pos[i].setY(0);
    }

    for(int n=3;n<g;n++){//己方车辆
        if(pVision->ourPlayer(mycar[n]).Valid()){
            GDebugEngine::Instance()->gui_debug_msg(plentyArea,QString("%1").arg("O").toLatin1(),3);
            for(int i = 1;i < a;i++){
                for(int j = 0;j < b;j++){//遍历点
                    p[i][j].position = pVision->ourPlayer(mycar[n]).Pos() + Utils::Polar2Vector(dist/a*(i) ,(-PI) + j * (2 * PI) / b );
                    if (myJuge(p[i][j].position)){//是否在合法区域
                          for(int dn=0;dn<h;dn++){//敌方车辆
                              CGeoPoint tadian = pVision->theirPlayer(theircar[dn]).Pos();
                              float l = (tadian-pVision->ball().Pos()).mod()-600;
                              l = l>0? l : 0;
                              float radiu = l*0.14+90;
                              if(!(pdjiao(radiu,p[i][j].position,tadian,pVision->ourPlayer(mycar[n]).Pos(),pVision))||(p[i][j].position - tadian).mod()<radiu){
                                    //是否挡住
                                  p[i][j].value = p[i][j].value-4;
                                    //GDebugEngine::Instance()->gui_debug_msg(p[i][j].position,QString("%1").arg(".").toLatin1(),3);//标记
                              }
                              else{
                                  for(int k=3;k<g;k++){
                                    if ( pointBehind(p[i][j].position,pVision->ourPlayer(mycar[k]).Pos(),pVision))
                                        p[i][j].value = p[i][j].value-4;
                                  }
                              }
                          }
                          if (p[i][j].position.dist(pVision->ball().Pos())>6000)
                          {
                             p[i][j].value = p[i][j].value-4;
                          }
                          else if(iscanshoot(p[i][j].position,pVision) && p[i][j].value == 3
                                  && p[i][j].position.dist(pVision->ball().Pos())<4000 &&
                                  (p[i][j].position-plentyArea).mod()>(pVision->ball().Pos()-plentyArea).mod()-1000 && abs(p[i][j].position.y())<2500){
                             p[i][j].value = p[i][j].value+1;

                          }
                    }
                    else{
                        p[i][j].position=CGeoPoint(-5000,-5000);
                    }


                    if(p[i][j].value<2){
                        GDebugEngine::Instance()->gui_debug_msg(p[i][j].position,QString("%1").arg(".").toLatin1());
                    }
                    else if (p[i][j].value==3){
                        flag2[n-3]++;
                        if ((best_pos[n-3]-plentyArea).mod()>(p[i][j].position-plentyArea).mod()){
                            best_pos[n-3] = p[i][j].position;
                        }
                        GDebugEngine::Instance()->gui_debug_msg(p[i][j].position,QString("%1").arg(".").toLatin1(),3);
                    }else {
                        flag[n-3]++;
                        GDebugEngine::Instance()->gui_debug_msg(p[i][j].position,QString("%1").arg(".").toLatin1(),4);
                        //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
                        //if (p[i][j].value>100 && (best_pos[n-3]-goal).mod()>(p[i][j].position-goal).mod()){
                            if (p[i][j].value==4 && (best_pos[n-3]-plentyArea).mod()>(p[i][j].position-plentyArea).mod()){
                            best_pos[n-3] = p[i][j].position;
                            isGreen = true;
                        }
                    }
                    p[i][j].value=3;
                }
            }
        }

        GDebugEngine::Instance()->gui_debug_msg(CGeoPoint(-500,-500*n),QString("%1").arg(flag[n-3]).toLatin1());
    }
    int maxG = 0;
    int maxY = 0;
    int best_player = -16;
    for (int i=0;i<3;i++){
        WorldModel::Instance()->f[i] = flag[i];
        if (flag[i]>maxG&&(pVision->ball().Pos()-pVision->ourPlayer(i+3).Pos()).mod()>800){
            maxG = flag[i];
            best_player = i;
        }
    }



    if(best_player==-16){
        for (int i=0;i<3;i++){
            WorldModel::Instance()->f[i] = flag2[i];
            if (flag2[i]>maxY&&maxG==0&&(pVision->ball().Pos()-pVision->ourPlayer(i+3).Pos()).mod()>800){
                maxY = flag2[i];
                best_player = i;
            }
        }
        WorldModel::Instance()->isCanshoot = false;
    }
    WorldModel::Instance()->x = best_pos[best_player].x();
    WorldModel::Instance()->y = best_pos[best_player].y();
    WorldModel::Instance()->best=best_player+3;
    GDebugEngine::Instance()->gui_debug_msg(best_pos[best_player],QString("%1").arg("X").toLatin1(),5);

    WorldModel::Instance()->best = 4;
}


//void CDecisionModule::nbut_suannumber(const CVisionModule* pVision){
//    double mypower=0;
//    mypower=(((pVision->ourPlayer(1).Pos()-pVision->ball().Pos()).mod()+176.3)/7.70);
//    WorldModel::Instance()->c = mypower;
//}
