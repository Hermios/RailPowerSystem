railprototype={}
custom_prototypes[straight_rail_power]=railprototype
custom_prototypes[curved_rail_power]=railprototype

function railprototype:new(entity)
	if entity.valid==false then
		return
	end

	local electric_node=game.surfaces[1].create_entity{name=electricnode,position=entity.position,force=entity.force}
	electric_node.disconnect_neighbour()
	electric_node.operable=false
	electric_node.minable=false
	electric_node.destructible=false
	electric_node.disconnect_neighbour()
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
	--connect to other rails
	for rail_direction=0,1 do
		for rail_connection_direction=0,2 do
			local connectedRail= self.entity.get_connected_rail{rail_direction=rail_direction,rail_connection_direction=rail_connection_direction}
			if connectedRail and global.custom_entities[connectedRail.unit_number] then
				connect_all_wires(self.electricnode,global.custom_entities[connectedRail.unit_number].electricnode)
			end
		end
	end

	--connect to poles
	local x=self.entity.position.x
	local y=self.entity.position.y
	for _,railPole in pairs(game.surfaces[1].find_entities_filtered{area = {{x-1,y-1},{x+1,y+1}}, name=railpole}) do
		if global.custom_entities[railPole.unit_number] then
			global.custom_entities[railPole.unit_number]:connect()
		end
	end
end

function railprototype:on_removed()
	self.accu.destroy()
	self.electricnode.destroy()
end