#ifndef _WORLD_DEFINE_H_
#define _WORLD_DEFINE_H_
#include <geometry.h>
/************************************************************************/
/*                       ObjectPoseT                                    */
/************************************************************************/
class ObjectPoseT {
  public:
    ObjectPoseT() : _valid(false), _pos(CGeoPoint(-9999, -9999)) { }
    const CGeoPoint& Pos() const {
        return _pos;
    }
    void SetPos(double x, double y) {
        _pos = CGeoPoint(x, y);
    }
    void SetPos(const CGeoPoint& pos) {
        _pos = pos;
    }
    double X() const {
        return _pos.x();
    }
    double Y() const {
        return _pos.y();
    }
    void SetVel(double x, double y) {
        _vel = CVector(x, y);
    }
    void SetVel(const CVector& vel) {
        _vel = vel;
    }
    void SetRawVel(double x, double y) {
        _rawVel = CVector(x, y);
    }
    void SetRawVel(const CVector& vel) {
        _rawVel = vel;
    }
    void SetAcc(double x, double y) {
        _acc = CVector(x, y);
    }
    void SetAcc(const CVector& acc) {
        _acc = acc;
    }
    const CVector& Vel() const {
        return _vel;
    }
    const CVector& RawVel() const {
        return _rawVel;
    }
    const CVector& Acc() const {
        return _acc;
    }
    double VelX() const {
        return _vel.x();
    }
    double VelY() const {
        return _vel.y();
    }
    double AccX() const {
        return _acc.x();
    }
    double AccY() const {
        return _acc.y();
    }
    void SetValid(bool v) {
        _valid = v;
    }
    bool Valid() const {
        return _valid;
    }
  private:
    CGeoPoint _pos;
    CVector _vel;
    CVector _rawVel;
    CVector _acc;
    bool _valid;
};
/************************************************************************/
/*                      VisionObjectT                                   */
/************************************************************************/
class VisionObjectT {
  public:
    VisionObjectT() : _rawPos(CGeoPoint(-9999, -9999)) { }
    const CGeoPoint& RawPos() const {
        return _rawPos;
    }
    const CGeoPoint& ChipPredictPos() const {
        return _chipPredict;
    }
    double RawDir() const {
        return _rawDir;
    }
    void SetChipPredict(const CGeoPoint& chipPos) {
        _chipPredict = chipPos;
    }
    void SetChipPredict(double x, double y) {
        _chipPredict =  CGeoPoint(x, y);
    }
    void SetRawPos(double x, double y) {
        _rawPos = CGeoPoint(x, y);
    }
    void SetRawPos(const CGeoPoint& pos) {
        _rawPos = pos;
    }
    void SetRawDir(double rawdir) {
        _rawDir = rawdir;
    }
  private:
    CGeoPoint _rawPos; // ??????????????????????????????????????????
    CGeoPoint _chipPredict; //????????????
    double _rawDir;
};
/************************************************************************/
/*                       MobileVisionT                                  */
/************************************************************************/
class MobileVisionT : public ObjectPoseT, public VisionObjectT {

};
/************************************************************************/
/*                        ???????????????????????????                               */
/************************************************************************/
struct PlayerPoseT : public ObjectPoseT { // ????????????
  public:
    PlayerPoseT() : _dir(0), _rotVel(0) { }
    double Dir() const {
        return _dir;
    }
    void SetDir(double d) {
        _dir = d;
    }
    double RotVel() const {
        return _rotVel;
    }
    void SetRotVel(double d) {
        _rotVel = d;
    }
    double RawRotVel() const {
        return _rawRotVel;
    }
    void SetRawRotVel(double d) {
        _rawRotVel = d;
    }
  private:
    double _dir; // ??????
    double _rotVel; // ????????????
    double _rawRotVel;
};
/************************************************************************/
/*                      PlayerTypeT                                     */
/************************************************************************/
class PlayerTypeT {
  public:
    PlayerTypeT(): _type(0) {}
    void SetType(int t) {
        _type = t;
    }
    int Type() const {
        return _type;
    }
  private:
    int _type;
};
/************************************************************************/
/*                       PlayerVisionT                                  */
/************************************************************************/
class PlayerVisionT : public PlayerPoseT, public VisionObjectT, public PlayerTypeT {

};

/************************************************************************/
/*                        ???????????????????????????                               */
/************************************************************************/
struct PlayerCapabilityT {
    PlayerCapabilityT(): maxAccel(0), maxSpeed(0), maxAngularAccel(0), maxAngularSpeed(0), maxDec(0), maxAngularDec(0) {}
    double maxAccel; // ???????????????
    double maxSpeed; // ????????????
    double maxAngularAccel; // ??????????????????
    double maxAngularSpeed; // ???????????????
    double maxDec;          // ???????????????
    double maxAngularDec;   // ??????????????????
};
#endif // _WORLD_DEFINE_H_
