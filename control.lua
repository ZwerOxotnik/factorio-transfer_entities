event_listner = require("__event-listener__/branch-1/stable-version")
local modules = {}
modules.transfer_entities = require("transfer_entities/control")

event_listner.add_events(modules)
