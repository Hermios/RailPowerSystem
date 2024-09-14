--electrical fuel
createdata("item","solid-fuel",electricfuel,{
	fuel_category="electrical",
	fuel_value="40MJ",
	stack_size=1,
	icon="__"..modname.."__/graphics/icons/"..electricfuel..".png"
},true)

--train
createdata("item-with-entity-data","locomotive",electric_locomotive)

--circuit's components
createdata("item","rail-signal",railpole_prototype)

createdata("item","small-electric-pole",railpole,nil,true)

createdata("item",railpole,electricnode,nil,true)

createdata("item",railpole,rail_electric_accu)

--rail
createdata("rail-planner","rail",electric_rail,{
	subgroup = "transport",
	place_result = straight_rail_power,
	straight_rail = straight_rail_power,
	curved_rail = curved_rail_power
})