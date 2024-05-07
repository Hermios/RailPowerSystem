require "__Hermios_Framework__.control-libs"
require "constants"
require "prototypes.rail-pole"
require "prototypes.rail-power"
require "prototypes.locomotive"
require "methods.remote-builder"

table.insert(list_events.on_tick,function ()
	for _,entity in pairs(global.custom_entities) do
		if entity.update then
			entity:update()
		end
	end
end)

table.insert(list_events.on_built,function (entity)
    if entity.valid and entity.type=="entity-ghost" and entity.ghost_name==railpole then
        local connections=entity.circuit_connection_definitions
        local surface=entity.surface
        local position=entity.position
        local force=entity.force
        entity.destroy()
        local ghost=surface.create_entity{name="entity-ghost",inner_name=railpole_prototype,position=position,force=force}
        for _,connection in pairs(connections) do
            ghost.connect_neighbour(connection)
        end
    end
    if entity.valid and entity.type=="electric-pole" then
        for _,pole in pairs(entity.surface.find_entities_filtered{position=entity.position,radius=entity.prototype.max_wire_distance,type="electric-pole"}) do
            if pole.name==electricnode then
                entity.disconnect_neighbour(pole)
            else
                entity.connect_neighbour(pole)
            end
        end
    end
end)

table.insert(list_events.on_entity_destroyed,function(event)
    local destroyed_item_data=destroyed_railpoles[event.unit_number]
    local ghosts=destroyed_item_data.surface.find_entities_filtered{position=destroyed_item_data.position,name="entity-ghost",ghost_name=railpole}
	if #ghosts>0 then
		local old_ghost=ghosts[1]
		local new_ghost=destroyed_item_data.surface.create_entity{name="entity-ghost",inner_name=railpole_prototype,position=destroyed_item_data.position,force=old_ghost.force}
        for wire,targets in pairs(old_ghost.circuit_connected_entities) do
            for _,target in pairs(targets) do
                new_ghost.connect_neighbour{wire=defines.wire_type[wire],target_entity=target}
            end
        end
		old_ghost.destroy()
	end
    destroyed_railpoles[event.unit_number]=nil
end)