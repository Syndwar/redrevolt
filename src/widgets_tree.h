#ifndef WIDGETS_TREE_H
#define WIDGETS_TREE_H

#include "stren.h"

#include <vector>
#include <string>

namespace redrevolt
{
class WidgetTreeBranch;

class WidgetsTree : public stren::ScrollContainer
{
private:
    int m_level;
    std::vector<WidgetTreeBranch *> m_branches;

public:
    WidgetsTree(const std::string & id);

    virtual ~WidgetsTree();

    void onOpening(stren::Widget * sender);

    void reset();

    void createBranch(stren::Widget * parent);

    void update();
};
} // redrevolt
#endif // WIDGETS_TREE_H 
