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
	local required_fuel=self.stack_size-self.entity.get_item_count()
	if required_fuel>0 then
		local rail=global.custom_entities[(self.train.front_rail or self.train.back_rail).unit_number]
		if rail and rail.accu.energy>=self.ratio_fuel then
			local required_energy=required_fuel*self.ratio_fuel
			local power_transfer = math.min(rail.accu.energy,required_energy)
			local power_fuel=math.floor(power_transfer/self.ratio_fuel)
			self.entity.get_fuel_inventory().insert({name=electricfuel, count=power_fuel})
			rail.accu.energy=rail.accu.energy-power_fuel*self.ratio_fuel
		end
	end
end