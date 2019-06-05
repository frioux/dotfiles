-- @module sharetags
-- functions to share tags on multiple screens
local sharetags = {}

--{{{ Grab environment we need
local capi = { screen = screen, client = client }

local pairs = pairs
local ipairs = ipairs
local tag = require("awful.tag")
local awful = require("awful")

--}}}


--{{{ Functions

--{{{ create_tags: create a table of tags and bind them to screens
-- @param names : list to label the tags
-- @param layouts : list of layouts for the tags
-- @return table of tag objects
function sharetags.create_tags(names, layouts)
    local tags = {}
    local count = #names
    if capi.screen.count() >= #names then
        count = capi.screen.count() + 1
    end

    for tagnumber = 1, count do
        tags[tagnumber] = tag.add(names[tagnumber], {})
        tags[tagnumber].number = tagnumber

        awful.layout.set(layouts[tagnumber], tags[tagnumber])
     end
    return tags
end
--}}}

--{{{ sharetags.tag_move: move a tag to a screen
-- @param t : the tag object to move
-- @param screen_target : the screen object to move to
function sharetags.tag_move(t, screen_target)
    local ts = t or tag.selected()

    if not screen_target then return end

    local current_screen = ts.screen

    if current_screen and screen_target ~= current_screen then
        -- switch for tag
        local mynumber = ts.number

        -- sort tags
        local index = #screen_target.tags+1
        for i, screen_tag in pairs(screen_target.tags) do
            local number = screen_tag.number
            if number ~= nil and mynumber < number then
                index = i
                break
            end
        end

        -- save curren_screen tags
        local selected_tags = current_screen.selected_tags

        ts.screen = target_screen
        ts.index = index

        -- restore curren_screen tag
        tag.viewmore(selected_tags, current_screen)


        -- switch for all clients on tag
        if #ts:clients() > 0 then
            for _ , c in ipairs(ts:clients()) do
                if not c.sticky then
                    c.screen = screen_target
                    c:tags({ ts })

                    -- Fix maximized client if display sizes not equal
                    local is_maximized = c.maximized
                    if is_maximized then
                        c.maximized = false
                        c.maximized = true
                    end
                else
                    awful.client.toggletag(ts, c)
                end
            end
        end
    end
end
--}}}


-- Open tag on screen
function sharetags.select_tag(t, target_screen)
    local prev_focus = capi.client.focus;
    local tag_screen = t.screen
    local is_tag_select = t.selected;
    local is_tag_moved = target_screen ~= tag_screen


    if t.selected and target_screen ~= tag_screen and #tag_screen.selected_tags == 1 then
        sharetags.swap_screen(tag_screen, target_screen)
    else
        sharetags.tag_move(t, target_screen)
        t:view_only()
    end


    -- If there was a moving tag then the focus on the window is lost.  Checking
    -- if this is the same tag and thus restore focus on the window
    if is_tag_moved and is_tag_select and #t:clients() > 0 and prev_focus then
       capi.client.focus = prev_focus
    end
end

-- Toggle tag on screen
function sharetags.toggle_tag(t, screen)
    if t.screen ~= screen then
        sharetags.tag_move(t, screen)
        if not t.selected then
            tag.viewtoggle(t)
        end
    else
        tag.viewtoggle(t)
    end
end


-- Swap all tags between two screens
function sharetags.swap_screen(s1, s2)
    if #s1.selected_tags ~= 1 or #s2.selected_tags ~= 1 then
        print("can't swap multiple tags yet")
    end

    local t1 = s1.selected_tag
    local t2 = s2.selected_tag

    -- hide both tags in scratch space
    t1:swap(s1.scratch)
    t2:swap(s2.scratch)

    -- bring tabs back but to alternate screends
    t2:swap(s1.scratch)
    t1:swap(s2.scratch)
end

return sharetags
