if youdaokeyfrom == nil then youdaokeyfrom = 'bjzhouHS' end
if youdaoapikey == nil then youdaoapikey = '2119912473' end

function youdaoInstantTrans(querystr)
    local youdao_baseurl = 'http://fanyi.youdao.com/openapi.do?keyfrom='..youdaokeyfrom..'&key='..youdaoapikey..'&type=data&doctype=json&version=1.1&q='
    if string.len(querystr) > 0 then
         local encoded_query = hs.http.encodeForQuery(querystr)
         local query_url = youdao_baseurl..encoded_query

        hs.http.asyncGet(query_url,nil,function(status,data)
            if status < 0 then
                return
            else
                local decoded_data = hs.json.decode(data)
                if decoded_data.translation then
                    translation = decoded_data.translation
                end
                if decoded_data.basic then
                    basictrans = decoded_data.basic.explains
                end
                if decoded_data.web then
                     webtrans = hs.fnutils.imap(decoded_data.web,function(item) return item.key..' '..table.concat(item.value,',') end)
                end
                chooser_data = hs.fnutils.imap(hs.fnutils.concat(translation,basictrans,webtrans), function(item)
                    return {text = item}
                end)
                search_chooser:choices(chooser_data)
            end
        end)
    else
       chooser_data={}
       return chooser_data
    end
end

function launchChooser()
    chooser_data = {}
    suggeststr = ''
    currentsource = 1
    choosersourcetable = {}
    querystr = ''
    search_chooser = hs.chooser.new(function(chosen)
        if chosen ~= nil then
            if outputtype == "safari" then
                local defaultbrowser = hs.urlevent.getDefaultHandler('http')
                hs.urlevent.openURLWithBundle(chosen.subText,defaultbrowser)
            elseif outputtype == "pasteboard" then
                hs.pasteboard.setContents(chosen.text)
            end
        end
    end)
    search_chooser:queryChangedCallback(function()
        if querystr ~= search_chooser:query() then
            querystr = search_chooser:query()
            youdaoInstantTrans(querystr)
        end
       search_chooser:choices(chooser_data)
    end)
    outputtype = 'pasteboard'
    search_chooser:rows(9)
    search_chooser:searchSubText(true)
    search_chooser:show()
end
