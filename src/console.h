#ifndef CONSOLE_H
#define CONSOLE_H

#include "stren.h"

#include <list>

namespace redrevolt
{
    class Console : public stren::Dialog
    {
        std::list<stren::Label *> m_labels;
        int m_labelHeight;
        int m_labelsCount;
    public:
        Console(const std::string & id);

        virtual ~Console();

        void log(const char * msg);
    };
} // redrevolt
#endif // CONSOLE_H
