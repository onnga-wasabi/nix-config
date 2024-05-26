-- https://xn--pckzexbx21r8q9b.net/lua_tips/?Lua+implements_func_io
function file_exists(path)
    local fh = io.open(path, "rb")
    if fh then fh:close() end
    return fh ~= nil
end

