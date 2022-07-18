UIBuilder = {}

local function __createWidget(data)
    local widget = nil
    local widget_class = _G[data.widget]
    assert(widget_class)
    if (data) then
        -- create widget
        widget = widget_class(data.id or "")
        -- set rect if possible
        if (data.rect and widget.setRect) then
            widget:setRect(unpack(data.rect))
        end
        -- set widget alignment if possible
        if (data.alignment and widget.setAlignment) then
            widget:setAlignment(unpack(data.alignment))
        end
        -- set sprite if possible
        if (data.sprite and widget.setSprite) then
            widget:setSprite(data.sprite)
        end
        -- set angle if possible
        if (data.angle and widget.setAngle) then
            widget:setAngle(data.angle)
        end
        -- set widget center if possible
        if (data.center and widget.setCenter) then
            widget:setCenter(unpack(data.center))
        end
        -- set rect if possible
        if (data.rect and widget.setRect) then
            widget:setRect(unpack(data.rect))
        end
        -- change widget scrolling speed if possible
        if (data.scroll_speed and widget.setScrollSpeed) then
            widget:setScrollSpeed(data.scroll_speed or 1)
        end
        -- set widget callback if possible
        if (data.callback and widget.addCallback) then
            widget:addCallback(unpack(data.callback))
        end
        -- set widget callbacks if possible
        if (data.callbacks and widget.addCallback) then
            for _, callback in ipairs(data.callbacks) do
                widget:addCallback(unpack(callback))
            end
        end
        -- set widget text if possible
        if (data.text and widget.setText) then
            widget:setText(data.text or "")
        end
        -- set widget font if possible
        if (data.font and widget.setFont) then
            widget:setFont(data.font or "")
        end
        -- set text alignment in widget if possible
        if (data.text_align and widget.setTextAlignment) then
            widget:setTextAlignment(data.text_align)
        end
        -- set text colour in widget if possible
        if (data.colour and widget.setColour) then
            widget:setColour(data.colour)
        end
        -- set widget sprites if possible
        if (data.sprites and widget.setSprites) then
            widget:setSprites(unpack(data.sprites))
        end
        -- set widget visibility status
        if (nil ~= data.view and widget.instantView) then
            widget:instantView(data.view)
        end
        -- attach other widgets if possible
        if (data.attached) then
            UIBuilder.create(widget, data.attached)
        end
    end
    return widget
end

function UIBuilder.create(cnt, desc)
    for _, data in ipairs(desc) do
        local widget = __createWidget(data)
        if (widget) then
            if (data.ui) then
                cnt:setUI(data.ui, widget)
            end
            cnt:attach(widget)
        end
    end
end

