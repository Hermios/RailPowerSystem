locomotive={}
custom_prototypes[electric_locomotive]=locomotive

function locomotive:new(entity)
	return{
		entity=entity,
		burner=entity.burner,
		train=entity.train,
		ratio_fuel=game.item_prototypes[electricfuel].fuel_value,
		stack_size=game.item_prototypes[electricfuel].stack_size
	}
end

function locomotive:update()
	if not self.entity.valid  then
		return
	end
	if self.burner.heat <self.burner.heat_capacity*0.1 then
		local rail=global.custom_entities[(self.train.front_rail or self.train.back_rail).unit_number]
		if rail and rail.accu.energy>0 then
			local required_energy=self.burner.heat_capacity*0.99-self.burner.heat
			local power_transfer = math.min(rail.accu.energy,required_energy)
			self.burner.heat=self.burner.heat+power_transfer
			rail.accu.energy=rail.accu.energy-power_transfer
		end
	end
end