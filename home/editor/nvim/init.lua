require("util.io")

require("config.base")
require("config.options")
require("config.ui")
-- require("config/foldings")
require("config.lazy")

if file_exists(vim.fn.stdpath("config") .. "secrets") then
	require("config.secrets")
end
require("config.secrets")
