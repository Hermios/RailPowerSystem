function update_rail_pictures(oldname,newname)
  for orientation,pictures in pairs(data.raw[oldname][oldname]["pictures"]) do
    for k,v in pairs(pictures) do
      if k~="backplates" then
        data.raw[oldname][newname]["pictures"][orientation][k]=v
      end
    end
  end
  
end

data:extend({
  {
    type = "fuel-category",
    name = "electrical"
  }
})

--train
createdata("locomotive","locomotive",electric_locomotive,{
	corpse = "locomotive-remnants",
	color = { r = 100, g = 100, b = 200 },
  burner = {
    fuel_category = "electrical",
    effectivity = 1,
    fuel_inventory_size = 1,
    burnt_inventory_size = 1
  },
  minimap_representation=data.raw["locomotive"]["locomotive"].minimap_representation,
  pictures=data.raw["locomotive"]["locomotive"].pictures,
  selected_minimap_representation=data.raw["locomotive"]["locomotive"].selected_minimap_representation,
  water_reflection=data.raw["locomotive"]["locomotive"].water_reflection,
  wheels=data.raw["locomotive"]["locomotive"].wheels
})

--circuit's components
createdata("rail-signal","rail-signal",railpole_prototype,nil,true)

local connection_points={}
for i=1, 4 do
  connection_points[i] = {
    shadow ={
      copper = nil,
      green = nil,
      red = nil
    },
    wire ={
      copper = {0, -1.9},
      green = {0, -1.9},
      red = {0, -1.9}
    }
  }
end

createdata("electric-pole","small-electric-pole",railpole,{
	minable = {mining_time = 0.5, result = railpole_prototype},
	supply_area_distance = 1,
	pictures ={
		filename="__"..modname.."__/graphics/entity/rail-pole/"..railpole..".png",
		priority = "high",
		line_length = 1,
		width = 189,
		height = 160,
		direction_count = 4
    },
	connection_points = connection_points
})
createdata("electric-pole",railpole,electricnode,{
	minable= nil,
  draw_copper_wires=false,
	draw_circuit_wires=false,
	selectable_in_game=false,
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
	maximum_wire_distance =8,
	supply_area_distance =0.1
  },
  true
)

createdata("electric-energy-interface","electric-energy-interface",rail_electric_accu,{
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
	energy_production = "0W",
  energy_usage = "0W",
	electric_buffer_size="20KJ",
  energy_source =
    {
      type = "electric",
      buffer_capacity = "20KJ",
      input_flow_limit = "20KJ",
      drain = "0J",
      usage_priority = "primary-input",
	    output_flow_limit = "0J",
    },
	working_sound =
    {
      sound =
      {
        filename = "__base__/sound/accumulator-working.ogg",
        volume = 0
      },
      idle_sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0
      }
	}
},true)

--rail
createdata("straight-rail","straight-rail",straight_rail_power,{
	minable = {mining_time = 0.6, result = electric_rail},
})
update_rail_pictures("straight-rail",straight_rail_power)

createdata("curved-rail","curved-rail",curved_rail_power,{
	icon = "__base__/graphics/icons/curved-rail.png",
  minable = {mining_time = 0.6, result = electric_rail, count=4},
	placeable_by = { item=electric_rail, count = 4},
})
update_rail_pictures("curved-rail",curved_rail_power)