railpoleconnector_prototype={}
destroyed_railpoles={}
custom_prototypes[railpole_prototype]=railpoleconnector_prototype

function railpoleconnector_prototype:new(entity)
	if entity.valid==false then
		return
	end
	local rail_pole = entity.surface.create_entity{name=railpole,position=entity.position,force=entity.force,direction=entity.direction}
	if not rail_pole then
		return
	end
	for wire,targets in pairs(entity.circuit_connected_entities) do
		for _,target in pairs(targets) do
			rail_pole.connect_neighbour{wire=defines.wire_type[wire],target_entity=target}
		end
	end
	local o={
		entity=rail_pole,
		rails={}
	}
	script.register_on_entity_destroyed(rail_pole)
	local connected_rails={}
	for _,rail in pairs(entity.get_connected_rails()) do
		if string.ends(rail.name,"power") then
			table.insert(connected_rails,rail)
		end
	end
	if #connected_rails==0 then
		connected_rails=entity.surface.find_entities_filtered{name=straight_rail_power,position=entity.position,radius=2}
	end
	if #connected_rails==0 then
		connected_rails=entity.surface.find_entities_filtered{name=curved_rail_power,position=entity.position,radius=2}
	end
	if #connected_rails>0 then
		table.insert(o.rails,global.custom_entities[connected_rails[1].unit_number])
	end
	entity.destroy()
	return o
end

function railpoleconnector_prototype:on_built()
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
	destroyed_railpoles[self.entity.unit_number]={
		position=self.entity.position,
		surface=self.entity.surface
	}
end