railprototype={}
custom_prototypes[straight_rail_power]=railprototype
custom_prototypes[curved_rail_power]=railprototype

function railprototype:new(entity)
	if entity.valid==false then
		return
	end

	local electric_node=game.surfaces[1].create_entity{name=electricnode,position=entity.position,force=entity.force}
	if not electric_node then
		return
	end
	electric_node.operable=false
	electric_node.minable=false
	electric_node.destructible=false
	local accu = game.surfaces[1].create_entity
		{
			name=rail_electric_accu,
			position=entity.position,
			force=entity.force
		}
	accu.operable = false
	accu.minable = false
	accu.destructible = false
	return
	{
		entity=entity,
		accu=accu,
		electricnode=electric_node
	}
end

function railprototype:on_built()
	self:connect()
end

function railprototype:connect()
	self.electricnode.disconnect_neighbour()
	--connect to other rails
	for _,rail in pairs(self:get_connected_powerrails()) do
		if rail.electricnode.valid then
			connect_all_wires(self.electricnode,rail.electricnode)
		end
	end

	--connect to poles
	for _,rail_pole in pairs(self:get_connected_poles()) do
			rail_pole:connect()
	end
end

function railprototype:get_connected_poles()
	local result={}
	for _,rail_pole in pairs(game.surfaces[1].find_entities_filtered{position=self.entity.position,radius=1, name=railpole}) do
		table.insert(result,global.custom_entities[rail_pole.unit_number])
	end
	return result
end

function railprototype:get_connected_powerrails()
	local result={}
	for rail_direction=0,1 do
		for rail_connection_direction=0,2 do
			local connectedRail= self.entity.get_connected_rail{rail_direction=rail_direction,rail_connection_direction=rail_connection_direction}
			if connectedRail and global.custom_entities[connectedRail.unit_number] then
				table.insert(result,global.custom_entities[connectedRail.unit_number])
			end
		end
	end
	return result
end

function railprototype:on_removed()
	self.accu.destroy()
	self.electricnode.destroy()
	for _,rail in pairs(self:get_connected_powerrails()) do
		rail:connect()
	end
	for _,rail_pole in pairs(self:get_connected_poles()) do
		rail_pole:connect()
	end
end