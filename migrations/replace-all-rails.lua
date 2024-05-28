require "constants"
require "prototypes.rail-power"
require "__Hermios_Framework__.control-libs"
for _,entity in pairs(global.custom_entities or {}) do
    if entity.name==straight_rail_power or entity.name==curved_rail_power then
        local direction=entity.direction
        local force=entity.force
        local surface=entity.surface
        local position=entity.position
        local name=entity.name
        custom_prototype=custom_prototypes[entity.prototype_index]
        setmetatable(entity,custom_prototype)
        custom_prototype.__index=custom_prototype

        global.custom_entities[entity.unit_number].on_removed()
        global.custom_entities[entity.unit_number]=nil
        entity.destroy()
        local rail=surface.create_entity{name=name,force=force,position=position,direction=direction}
        on_built(rail)
    end
end