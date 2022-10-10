#include "map_editor_battlefield.h"

#include "map_handler.h"

namespace redrevolt
{
MapEditorBattlefield::MapEditorBattlefield(const std::string & id)
    : Battlefield(id)
    , m_grid(nullptr)
    , m_cursor(nullptr)
    , m_map(nullptr)
{
    m_map = new MapHandler();
    createMapContent();
}

MapEditorBattlefield::~MapEditorBattlefield()
{
}

void MapEditorBattlefield::createMapContent()
{
    std::vector<stren::Point> points;
    createGridLines(points);
    m_grid = new stren::Primitive("fieldGrid");
    m_grid->setColour("green");
    m_grid->setOrder(1000);
    m_grid->createLines(points);
    attach(m_grid);

    //local cell_width, cell_height = self._map:getCellSize()

    m_cursor = new stren::Primitive("cursorRect");
    m_cursor->setOrder(1001);
    m_cursor->setColour("yellow");
    //m_cursor->createRects({{0, 0, cell_width, cell_height}}, false);
    m_cursor->instantView(false);
    attach(m_cursor);
}

void MapEditorBattlefield::createGridLines(std::vector<stren::Point> & points)
{
    points.clear();
    /*
    local cells_in_row, cells_in_col = self._map:getSize()
    local cell_width, cell_height = self._map:getCellSize()
    local map_width = cells_in_row * cell_width
    local map_height = cells_in_col * cell_height

    local row = 0
    local w = 0
    local down = true
    while (w <= map_width) do
        if (down) then
            table.insert(grid_lines, {w, 0})
            table.insert(grid_lines, {w, map_height})
        else
            table.insert(grid_lines, {w, map_height})
            table.insert(grid_lines, {w, 0})
        end
        row = row + 1
        w = row * cell_width
        down = not down
    end

    local column = 0
    local h = 0
    local left = false
    while (h <= map_height) do
        if (left) then
            table.insert(grid_lines, {0, h})
            table.insert(grid_lines, {map_width, h})
        else
            table.insert(grid_lines, {map_width, h})
            table.insert(grid_lines, {0, h})
        end
        column = column + 1
        h = column * cell_height
        left = not left
    end
*/
}

void MapEditorBattlefield::switchGrid()
{
    if (m_grid)
    {
        m_grid->view(!m_grid->isOpened());
    }
}

} // redrevolt
