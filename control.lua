require "__Hermios_Gui_Framework__.control-libs"
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
    if entity.valid and entity.type=="electric-pole" then
        for _,pole in pairs(game.get_surface(1).find_entities_filtered{position=entity.position,radius=entity.prototype.max_wire_distance,type="electric-pole"}) do
            if pole.name==electricnode then
                entity.disconnect_neighbour(pole)
            else
                entity.connect_neighbour(pole)
            end
        end
    end
end)