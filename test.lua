package.path = package.path
	.. ";"
	.. os.getenv("HOME")
	.. "/.local/share/nvim/lazy-rocks/image.nvim/share/lua/5.1/?/init.lua;"
package.path = package.path
	.. ";"
	.. os.getenv("HOME")
	.. "/.local/share/nvim/lazy-rocks/image.nvim/share/lua/5.1/?.lua;"
local magick = require("magick")
--
-- print(package.path)
