railpoleconnector_prototype={}
custom_prototypes[railpole_prototype]=railpoleconnector_prototype

function railpoleconnector_prototype:new(entity)
	if entity.valid==false then
		return
	end
	local rail_pole = game.surfaces[1].create_entity{name=railpole,position=entity.position,force=entity.force}
	if not rail_pole then
		return
	end
	local o={
		entity=rail_pole,
		rails={}
	}
	for _,rail in pairs(entity.get_connected_rails()) do
		table.insert(o.rails,global.custom_entities[rail.unit_number])
	end
	entity.destroy()
	return o
end

function railpoleconnector_prototype:on_buid()
	self:connect()
end

function railpoleconnector_prototype:connect()
	-- disconnect all
	for _,neighbour_table in pairs(self.entity.neighbours) do
		for _,neighbour in pairs(neighbour_table)do
			if neighbour.name==electricnode then
				self.entity.disconnect_neighbour(neighbour)
			end
		end
	end

	for _,rail in pairs(self.rails) do
		if rail.electricnode.valid then
			connect_all_wires(self.entity,rail.electricnode)
		end
	end

	for _,pole in pairs(game.get_surface(1).find_entities_filtered{position=self.entity.position,radius=self.entity.prototype.max_wire_distance,type="electric-pole"}) do
		if pole.type=="electric-pole"and pole.name~=electricnode then
			self.entity.connect_neighbour(pole)
		end
	end
end

function railpoleconnector_prototype:on_removed()
	for _,rail in pairs(self.rails or {}) do
		rail:connect()
	end
end