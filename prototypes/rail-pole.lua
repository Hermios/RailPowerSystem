railpoleconnector_prototype={}
custom_prototypes[railpole_prototype]=railpoleconnector_prototype
local searchDirection = {{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1},{0,-1},{1,-1}}

function railpoleconnector_prototype:new(entity)
	if entity.valid==false then
		return
	end
	local rail_pole = game.surfaces[1].create_entity{name=railpole,position=entity.position,force=entity.force}
	for _,neighbourTable in pairs(rail_pole.neighbours) do
		for _,neighbour in pairs(neighbourTable)do
			if neighbour.name==electricnode then
				rail_pole.disconnect_neighbour(neighbour)
			end
		end
	end

	local o =
	{
		entity=rail_pole,
		direction=entity.direction
	}
	entity.destroy()
	return o
end

function railpoleconnector_prototype:on_built()
	self:connect()
end

function railpoleconnector_prototype:connect()
	local x=self.entity.position.x+searchDirection[self.direction+1][1]
	local y=self.entity.position.y+searchDirection[self.direction+1][2]
	local rail= global.custom_entities[
		(game.get_surface(1).find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, type= "straight-rail"}[1]
		or game.get_surface(1).find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, type= "curved-rail"}[1]
		or {})
			.unit_number
			or ""]
	if rail then
		connect_all_wires(self.entity,rail.electricnode)
	end
end