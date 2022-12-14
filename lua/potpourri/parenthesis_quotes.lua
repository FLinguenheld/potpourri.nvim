--------------------------------------------------------------------------------------------------
-- Replace
--------------------------------------------------------------------------------------------------

local A = vim.api


--------------------------------------------------------------------------------------------------
PQ = {}


--------------------------------------------------------------------------------------------------
-- Search the pattern before the cursor
-- If found, jump to the closing pattern (with vim command)
-- If ok, erase the text and set the insert mod
-- --------------------------------------------------------------------------------------------------
function PQ.search_and_action(name, action)


    local cursor = A.nvim_win_get_cursor(0)
    local lines = A.nvim_buf_get_lines(0, 0, cursor[1], {})

    local cursor_start = nil
    local cursor_end = nil

    local txt = ""
    local pattern = ""

    -- Find the opening part on the cursor's left
    for i = #lines, 1, -1 do

        local init = nil
        if i == #lines then
            init = #lines[i] - cursor[2]
        end

        -- Search
        if name == "parenthesis" then
            pattern = "[%(%[%{]"
        else
            pattern = "[%'%\"]"
        end

        local s, _ = string.find(lines[i]:reverse(), pattern, init)

        -- Left part found
        if s ~= nil then

            local real_pos = #lines[i] - s
            A.nvim_win_set_cursor(0, {i, real_pos})
            cursor_start = A.nvim_win_get_cursor(0)

            txt = A.nvim_buf_get_text(0, cursor_start[1] - 1, cursor_start[2],
                                         cursor_start[1] - 1, cursor_start[2] + 1,
                                         {})

            -- Jump to the closing part
            if name == "parenthesis" then
                A.nvim_exec('normal %', {})
            else
                A.nvim_exec('normal f' .. txt[1], {})
            end

            cursor_end = A.nvim_win_get_cursor(0)
            break
        end
    end

    if cursor_start == nil then
        print("No " .. name .. " found")

    elseif (cursor_start[1] ~= cursor_end[1] or cursor_start[2] ~= cursor_end[2]) then

        if action == "replace" then

            A.nvim_buf_set_text(0, cursor_start[1] - 1, cursor_start[2] + 1, cursor_end[1] - 1, cursor_end[2], {})
            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_start[2] + 1})
            A.nvim_exec('startinsert', {})

        elseif action == "delete" then

            A.nvim_buf_set_text(0, cursor_start[1] - 1, cursor_start[2] + 1, cursor_end[1] - 1, cursor_end[2], {})
            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_start[2]})

        elseif action == "DELETE" then

            A.nvim_buf_set_text(0, cursor_start[1] - 1, cursor_start[2], cursor_end[1] - 1, cursor_end[2] + 1, {})
            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_start[2]})

        elseif action == "insert_start" then

            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_start[2] + 1})
            A.nvim_exec('startinsert', {})

        elseif action == "INSERT_START" then

            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_start[2]})
            A.nvim_exec('startinsert', {})

        elseif action == "insert_end" then

            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_end[2]})
            A.nvim_exec('startinsert', {})

        elseif action == "INSERT_END" then

            A.nvim_win_set_cursor(0, {cursor_start[1], cursor_end[2] + 1})
            A.nvim_exec('startinsert', {})
        end


    else -- cursor_start == cursor_end

        print("The " .. name .. " '" .. txt[1] .. "' (" .. cursor_start[1] .. ","
                     .. cursor_end[2] + 1 .. ") is not closed")

        A.nvim_win_set_cursor(0, cursor)
    end
end

--------------------------------------------------------------------------------------------------
return PQ
