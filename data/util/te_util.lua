local util = require("util")

util.path = function(str)
  return "__transfer_entities__/" .. str
end

return util
