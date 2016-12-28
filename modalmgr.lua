modalmgr = hs.hotkey.modal.new('alt', 'space', 'Modal supervisor')
function modalmgr:entered()
end
function modalmgr:exited()
    if hotkeytext then
        hotkeytext:delete()
        hotkeytext=nil
        hotkeybg:delete()
        hotkeybg=nil
    end
end

modalmgr:bind('alt', 'A', 'Enter Application Mode', function() appM:enter() end)
modalmgr:bind('alt', 'C', 'Enter Clipboard Mode', function() clipboardM:enter() end)
modalmgr:bind('alt', 'G', 'Launch Hammer Search', function() launchChooser() end)
modalmgr:bind('alt', 'T', 'Show Digital Clock', function() show_time() end)
modalmgr:bind('alt', 'Z', 'Open Hammerspoon Console', function() hs.toggleConsole() end)
modalmgr:bind('alt', 'tab', 'Show Windows Hint', function() hs.hints.windowHints() end)

if modalmgr then
    modalmgr:enter()
end
