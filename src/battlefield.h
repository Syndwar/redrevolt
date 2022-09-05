#ifndef BATTLEFIELD_H
#define BATTLEFIELD_H

#include "stren.h"

namespace redrevolt
{
class Battlefield : public stren::ScrollContainer
{
public:
    Battlefield(const std::string & id = stren::String::kEmpty);

    virtual ~Battlefield();
};
} // redrevolt
#endif // BATTLEFIELD_H
