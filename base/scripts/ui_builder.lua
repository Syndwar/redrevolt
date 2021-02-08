UIBuilder = {}

function UIBuilder.createImage(data)
    local img = nil
    if (data) then
        img = Image(data.id or "")
        if (data.rect) then
            img:setRect(unpack(data.rect))
        end
        if (data.sprite) then
            img:setSprite(data.sprite or "")
        end
    end
    return img
end

function UIBuilder.createButton(data)
    local btn = nil
    if (data) then
        btn = Button(data.id or "")
        btn:setText(data.text or "")
        btn:setFont(data.font or "")
        if (data.rect) then
            btn:setRect(unpack(data.rect))
        end
        if (data.text_align) then
            btn:setTextAlignment(data.text_align)
        end
        if (data.sprites) then
            btn:setSprites(unpack(data.sprites))
        end
        if (data.callback) then
            btn:addCallback(unpack(data.callback))
        end
        if (data.colour) then
            btn:setColour(data.colour)
        end
    end
    return btn
end

UIBuilder._build_tools = {
    ["Button"] = UIBuilder.createButton,
    ["Image"] = UIBuilder.createImage,
}

function UIBuilder.create(cnt, desc)
    for _, data in ipairs(desc) do
        local tool = UIBuilder._build_tools[data.widget]
        if (tool) then
            local widget = tool(data)
            if (widget) then
                if (data.ui) then
                    cnt._ui[data.ui] = widget
                end
                cnt:attach(widget)
            end
        end
    end
end

