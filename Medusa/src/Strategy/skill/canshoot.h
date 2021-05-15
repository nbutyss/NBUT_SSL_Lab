#ifndef CANSHOOT_H
#define CANSHOOT_H
#include <geometry.h>
#include <skill/PlayerTask.h>
class canshoot : public CPlayerTask{
public:
    canshoot();
    virtual bool isEmpty() const { return false; }
    virtual void toStream(std::ostream& os) const { os << "canshoot"; }
    virtual void plan(const CVisionModule* pVision);
private:
    int _lasttCycle;
};

#endif // CANSHOOT_H

