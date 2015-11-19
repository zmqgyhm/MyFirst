local BubbleButton = {}

function BubbleButton.new(params)
    local listener = params.listener
    local button

    params.listener = function(sender)
        -- if params.prepare then
        --     params.prepare()
        -- end

        local function zoom1(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = cc.size(193, 81)
            local scaleX = button:getScaleX() * (size.width + offset) / size.width
            local scaleY = button:getScaleY() * (size.height - offset) / size.height

            transition.moveTo(button, {y = y - offset, time = time})
            transition.scaleTo(button, {
                scaleX     = scaleX,
                scaleY     = scaleY,
                time       = time,
                onComplete = onComplete,
            })
        end

        local function zoom2(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = cc.size(193, 81)

            transition.moveTo(button, {y = y + offset, time = time / 2})
            transition.scaleTo(button, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = onComplete,
            })
        end


        zoom1(20, 0.08, function()
            zoom2(20, 0.09, function()
                zoom1(10, 0.10, function()
                    zoom2(10, 0.11, function()
                        local tag=button:getTag()
                        listener(tag)
                    end)
                end)
            end)
        end)
    end

    button = cc.ui.UIPushButton:new();
    button:setButtonImage(cc.ui.UIPushButton.NORMAL,params.image,false);
    button:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event) 
        if event.name == "ended" then
            params.listener()
        end
        return true;
    end)
    return button
end

return BubbleButton
