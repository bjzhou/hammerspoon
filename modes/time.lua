darkblue = {red=24/255,blue=195/255,green=145/255,alpha=1}
function show_time()
    if not time_draw then
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        local time_str = hs.styledtext.new(os.date("%H:%M"),{font={name="Impact",size=120},color=darkblue,paragraphStyle={alignment="center"}})
        local timeframe = hs.geometry.rect((mainRes.w-300)/2,(mainRes.h-200)/2,300,150)
        time_draw = hs.drawing.text(timeframe,time_str)
        time_draw:setLevel(hs.drawing.windowLevels.overlay)
        time_draw:show()
        ttimer = hs.timer.doAfter(4, function() time_draw:delete() time_draw=nil end)
    else
        time_draw:delete()
        time_draw=nil
    end
end