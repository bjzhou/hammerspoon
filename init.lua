hs.hotkey.alertDuration=0
hs.window.animationDuration = 0

white = hs.drawing.color.white
black = hs.drawing.color.black
blue = hs.drawing.color.blue
osx_red = hs.drawing.color.osx_red
osx_green = hs.drawing.color.osx_green
osx_yellow = hs.drawing.color.osx_yellow
tomato = hs.drawing.color.x11.tomato
dodgerblue = hs.drawing.color.x11.dodgerblue
firebrick = hs.drawing.color.x11.firebrick
lawngreen = hs.drawing.color.x11.lawngreen
lightseagreen = hs.drawing.color.x11.lightseagreen
purple = hs.drawing.color.x11.purple
royalblue = hs.drawing.color.x11.royalblue
sandybrown = hs.drawing.color.x11.sandybrown
black50 = {red=0,blue=0,green=0,alpha=0.5}

hs.hotkey.bind({"alt", "shift"}, "R", "Reload Hammerspoon Configuration", function()
    hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()
    hs.reload()
end)

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

hs.hotkey.bind({"alt", "shift"}, "L", function() hs.caffeinate.lockScreen() end)

modal_list = {}

module_list = {
    "modes/showhotkey",
    "modes/clipshow",
    "modes/hsearch",
    "modes/time",
}

applist = {
    {shortcut = 'i',appname = 'iTerm'},
    {shortcut = 'l',appname = 'Sublime Text'},
    {shortcut = 'f',appname = 'Finder'},
    {shortcut = 's',appname = 'Safari'},
    {shortcut = 'y',appname = 'YoMail'},
    {shortcut = 't',appname = 'Telegram'},
    {shortcut = 'a',appname = 'Android Studio'},
    {shortcut = 'c',appname = 'IntelliJ IDEA CE'},
}

for i=1,#module_list do
    require(module_list[i])
end

if #modal_list > 0 then require("modalmgr") end
