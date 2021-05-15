#include "canshoot.h"
#include "skill/Factory.h"
#include "TaskMediator.h"
#include "WorldDefine.h"
#include "VisionModule.h"


#define PI 3.14159265358979323846
canshoot::canshoot(){}

void canshoot::plan(const CVisionModule* pVision){

    const int vecNumber = task().executor;
    const PlayerVisionT& self = pVision->ourPlayer(vecNumber);
    CVector notcanshoot(task().player.pos.x(),task().player.pos.y());
    double robotDir = pVision->ourPlayer(vecNumber).Dir();
    CVector left(4500,450),right(4500,-450),robot(self.X(),self.Y());
    double dir, b2p_dir, left_dir = (left-robot).dir(), right_dir = (right-robot).dir(), b2p_length, r = 112.5, L;
    CVector p;
    double LL=0;
    int i, k, maxl, index = -1;
    bool gate[91];
    for (i = 0; i < 91; i++){
        gate[i] = true;
    }
    bool canShoot = true;
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
                canShoot = false;
                continue;
            }
            if (Utils::Normalize(b2p_dir + dir) > left_dir  && Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                canShoot = false;
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
                 cout << "left1:" << floor(p.y()/10 + 45) << endl;
                 cout << "left1:--i" << i << endl;
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
                 cout << "right1:" << floor(p.y()/10 + 45) << endl;
                 cout << "right1:--i" << i << endl;
            }
            else if (Utils::Normalize(b2p_dir + dir)  < right_dir || Utils::Normalize(b2p_dir - dir)> left_dir)
                continue;
            else
            {
                cout<<"Utils::Normalize(b2p_dir + dir)"<<Utils::Normalize(b2p_dir + dir)<<endl;
                cout<<"right_dir)"<<right_dir<<endl;
                cout<<"Utils::Normalize(b2p_dir - dir)"<<Utils::Normalize(b2p_dir - dir)<<endl;
                cout<<"left_dir"<<left_dir<<endl;
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir - dir));
                p = robot + Utils::Polar2Vector(L, Utils::Normalize(b2p_dir - dir));
                cout << "right2:" << floor(p.y()/10 + 45) << endl;
                k = floor(p.y()/10 + 45);
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir + dir));
                LL=L;
                cout<<"k:"<<k<<endl;
                p = robot +Utils::Polar2Vector(L, Utils::Normalize(b2p_dir + dir));
                 cout << "left2:" << floor(p.y()/10 + 45) << endl;
                 cout<<"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"<<endl;

                for (; k <= floor(p.y()/10 + 45); k++)
                {
                    gate[k] = false;
                }
                 cout << "gate1:"<< i << endl;
            }
        }
    }

    for (i = 0; i < PARAM::Field::MAX_PLAYER; i++) {
        if (pVision->ourPlayer(i).Valid() && i!=vecNumber){
            const PlayerVisionT& pos = pVision->ourPlayer(i);
            CVector ourpos(pos.X(),pos.Y());
            b2p_dir = (ourpos-robot).dir();
            b2p_length = (ourpos - robot).mod();
            if (abs(b2p_dir) > PI / 2)
            {
                continue;
             }
            if (b2p_length > r)
                dir = asin(r / b2p_length);
            else
            {
                canShoot = false;
                continue;
            }
            if (Utils::Normalize(b2p_dir + dir) > left_dir  && Utils::Normalize(b2p_dir - dir) < right_dir)
            {
                canShoot = false;
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
                 cout << "left3" << floor(p.y()/10 + 45) << endl;
                 cout <<"left3--i" << i << endl;
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
                 cout << "right3" << floor(p.y()/10 + 45) << endl;
                 cout <<"right3--i" << i << endl;
            }
            else if (Utils::Normalize(b2p_dir + dir)  < right_dir || Utils::Normalize(b2p_dir - dir)> left_dir)
                continue;
            else
            {
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir - dir));
                p = robot + Utils::Polar2Vector(L, Utils::Normalize(b2p_dir - dir));
                 cout << "right4" << p.y()/10+45 << endl;
                k = floor(p.y()/10 + 45);
                L = (4500 - robot.x()) / cos(Utils::Normalize(b2p_dir + dir));
                p = robot +Utils::Polar2Vector(L, Utils::Normalize(b2p_dir + dir));
                 cout << "left4" << p.y()/10+45 << endl;
                for (; k <= floor(p.y()/10 + 45); k++)
                {
                    gate[k] = false;
                }
                 cout <<"gate2:"<< i << endl;
            }
        }
    }

    if (canShoot){
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
        if (maxl < 2)
            canShoot = false;
    }

    TaskT newTask(task());
    float carFront=task().player.carFront,lengthLimit=task().player.lengthLimit;
    CVector shootPoint(4500, (index - 1 - (maxl - 1) / 2.0 - 45)*10);
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 400), QString("index: %1").arg(index).toLatin1());
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 600), QString("maxl: %1").arg(maxl).toLatin1());
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 800), QString("shootPoint_y: %1").arg((index - 1 - (maxl - 1) / 2.0 - 45)*10).toLatin1());
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 1000), QString("x: %1  y: %2").arg(self.X()).arg(self.Y()).toLatin1());
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 1200), QString("dir: %1").arg(LL).toLatin1());
    GDebugEngine::Instance()->gui_debug_msg(self.Pos() + CVector(0, 1400), QString("target x: %1  y: %2").arg(notcanshoot.x()).arg(notcanshoot.y()).toLatin1());
    const MobileVisionT& ball = pVision->ball();
    CVector ballPos(ball.X(),ball.Y());
    DribbleStatus::Instance()->setDribbleCommand(vecNumber, 3);
    CGeoPoint resPos;
    if (!canShoot){
        GDebugEngine::Instance()->gui_debug_line(self.Pos(),CGeoPoint(shootPoint.x(),shootPoint.y()),3);
        shootPoint=notcanshoot;
    }
    else
        GDebugEngine::Instance()->gui_debug_line(self.Pos(),CGeoPoint(shootPoint.x(),shootPoint.y()),4);
    resPos=CGeoPoint(ball.X(),ball.Y()) + Utils::Polar2Vector(carFront,(ballPos - shootPoint).dir());
    if((ballPos-robot).mod()>200)
        resPos=CGeoPoint(ball.X(),ball.Y()) + Utils::Polar2Vector(carFront,(robot- ballPos).dir());
    newTask.player.pos = resPos;
    float resDir;
    CVector cF=robot+Utils::Polar2Vector(carFront,robotDir);
    resDir=(shootPoint-robot).dir();
    if((cF-ballPos).mod()>lengthLimit)
        resDir=(ballPos-robot).dir();
    newTask.player.angle =  resDir;
    newTask.player.flag = task().player.flag;
    setSubTask(TaskFactoryV2::Instance()->GotoPosition((newTask)));

    float pre=task().player.kickprecision;

     if(abs( robotDir-(shootPoint-ballPos).dir() )<PI/pre)
         if (!canShoot){
            WorldModel::Instance()->isCanshoot = false;
            KickStatus::Instance()->setKick(vecNumber,300);
         }
        else{
            WorldModel::Instance()->isCanshoot = true;
            KickStatus::Instance()->setKick(vecNumber,task().player.kickpower);
        }
     else
         KickStatus::Instance()->setKick(vecNumber,0);
    _lasttCycle = pVision->getCycle();
    CPlayerTask::plan(pVision);
}


