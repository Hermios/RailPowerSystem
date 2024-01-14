require "constants"

data:extend({
    {
        type = "int-setting",
        name = modname.."_check_delay",
        setting_type = "runtime-per-user",
        default_value = 60,
        order = "a"
    },
})
