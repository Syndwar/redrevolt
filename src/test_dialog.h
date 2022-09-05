#ifndef TEST_DIALOG_H
#define TEST_DIALOG_H

#include "stren.h"

namespace redrevolt
{
class TestDialog : public stren::Dialog
{
public:
    TestDialog(const std::string & id = stren::String::kEmpty);

    virtual ~TestDialog();
};
} // redrevolt
#endif // TEST_DIALOG_H
