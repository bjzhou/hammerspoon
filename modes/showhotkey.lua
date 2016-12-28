function showavailableHotkey()
    if not hotkeytext then
        local hotkey_list=hs.hotkey.getHotkeys()
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        local hkbgrect = hs.geometry.rect(mainRes.w/5,mainRes.h/5,mainRes.w/5*3,mainRes.h/5*3)
        hotkeybg = hs.drawing.rectangle(hkbgrect)
        -- hotkeybg:setStroke(false)
        hotkeybg:setFillColor({red=0,blue=0,green=0,alpha=0.8})
        hotkeybg:setRoundedRectRadii(10,10)
        hotkeybg:setLevel(hs.drawing.windowLevels.modalPanel)
        local hktextrect = hs.geometry.rect(hkbgrect.x+40,hkbgrect.y+30,hkbgrect.w-80,hkbgrect.h-60)
        hotkeytext = hs.drawing.text(hktextrect,"")
        hotkeytext:setLevel(hs.drawing.windowLevels.modalPanel)
        hotkeytext:setClickCallback(nil,function() hotkeytext:delete() hotkeytext=nil hotkeybg:delete() hotkeybg=nil end)
        hotkey_filtered = {}
        for i=1,#hotkey_list do
            if hotkey_list[i].idx ~= hotkey_list[i].msg then
                table.insert(hotkey_filtered,hotkey_list[i])
            end
        end
        local availablelen = 80
        local availableHeight = 15
        local hkstr = ''
        local maxLen = 0
        local maxLenLeft = 0
        for i=2,#hotkey_filtered,2 do
            local tmpstr = hotkey_filtered[i-1].msg .. hotkey_filtered[i].msg
            local strLen = string.len(tmpstr)
            if strLen < availablelen then
                maxLen = (strLen > maxLen) and strLen or maxLen
                local strLenLeft = string.len(hotkey_filtered[i-1].msg)
                maxLenLeft = (strLenLeft > maxLenLeft) and strLenLeft or maxLenLeft
            end
        end
        local lineCount = 0
        local rightStart = maxLenLeft + (availablelen - maxLen)
        for i=2,#hotkey_filtered,2 do
            if (i-1) == (#applist + 1) then
                hkstr = hkstr .. "\n"
                lineCount = lineCount + 1
            end
            if i == (#applist + 1) then
                hkstr = hkstr .. hotkey_filtered[i-1].msg .. "\n\n" .. hotkey_filtered[i].msg .. "\n"
                lineCount = lineCount + 3
            else
                local tmpstr = hotkey_filtered[i-1].msg .. hotkey_filtered[i].msg
                local strLen = string.len(tmpstr)
                if strLen < availablelen then
                    local strLenLeft = string.len(hotkey_filtered[i-1].msg)
                    hkstr = hkstr .. hotkey_filtered[i-1].msg .. string.format("%"..(rightStart-strLenLeft).."s","") .. hotkey_filtered[i].msg .. "\n"
                    lineCount = lineCount + 1
                else
                    hkstr = hkstr .. hotkey_filtered[i-1].msg .. "\n" .. hotkey_filtered[i].msg
                    lineCount = lineCount + 2
                end
            end
        end
        for i=1,(availableHeight-lineCount)/2 do
            hkstr = "\n" .. hkstr
        end
        local hkstr_styled = hs.styledtext.new(hkstr, {font={name="Courier-Bold",size=16}, color=white, paragraphStyle={lineSpacing=12.0,lineBreak='truncateMiddle'}})
        hotkeytext:setStyledText(hkstr_styled)
        hotkeybg:show()
        hotkeytext:show()
    else
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end

appM = hs.hotkey.modal.new({'cmd','alt','ctrl'}, 'm')
table.insert(modal_list, appM)
function appM:entered()
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
    showavailableHotkey()
end
function appM:exited()
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end
appM:bind('', 'Q', function() appM:exit() end)
appM:bind('alt', 'A', function() appM:exit() end)
appM:bind('', 'escape', function() appM:exit() end)

for i = 1, #applist do
    appM:bind('', applist[i].shortcut, applist[i].appname, function()
        hs.application.launchOrFocus(applist[i].appname)
        appM:exit()
        if hotkeytext then
            hotkeytext:delete()
            hotkeytext=nil
            hotkeybg:delete()
            hotkeybg=nil
        end
    end)
end
