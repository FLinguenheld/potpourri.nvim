
--------------------------------------------------------------------------------------------------
-- Python stuff
--------------------------------------------------------------------------------------------------

local A = vim.api


--------------------------------------------------------------------------------------------------
PY = {}



--------------------------------------------------------------------------------------------------
-- Close the current line with parenthesis and colon
-- Line jump and insert mod if new_line == true
--------------------------------------------------------------------------------------------------
function PY.close_python_function(new_line)

    local line = A.nvim_get_current_line()
    A.nvim_set_current_line(line .. '():')

    if(new_line == true) then
        A.nvim_exec('normal o ', {})
    end
end


--------------------------------------------------------------------------------------------------
return PY
