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
    if string.find(entity.type,"pole") then
        for _,neighbour in pairs(entity.neighbours.copper) do
            if get_custom_prototype(neighbour) then
                entity.disconnect_neighbour(neighbour)
            end
        end
    end
end)