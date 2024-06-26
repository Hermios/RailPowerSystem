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
local connection_points={}
local connection_sprites={}
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
  connection_sprites[i] =circuit_connector_definitions["rail-signal"].sprites[i]
end

createdata("rail-signal","rail-signal",railpole_prototype,{
  rail_piece=data.raw["rail-signal"]["rail-signal"].rail_piece,
  animation={
    layers={
      {
        filename = "__"..modname.."__/graphics/entity/"..railpole_prototype.."/"..railpole_prototype..".png",
        priority = "extra-high",
        width = 189,
        height = 160,
        direction_count = 4,
        hr_version =
        {
          filename = "__"..modname.."__/graphics/entity/"..railpole_prototype.."/hr-"..railpole_prototype..".png",
          priority = "extra-high",
          width = 189,
          height = 160,
          direction_count = 4
        }
      }
    }
  },
  circuit_wire_connection_points = connection_points,
  circuit_connector_sprites=connection_sprites
})

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
	maximum_wire_distance =8.5,
	supply_area_distance =0.1
  },
  true
)

createdata("electric-energy-interface","electric-energy-interface",rail_electric_accu,{
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
	energy_production = "0W",
  energy_usage = "0W",
	electric_buffer_size="1MJ",
  energy_source =
    {
      type = "electric",
      buffer_capacity = "1MJ",
      input_flow_limit = "1MJ",
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

data.raw["electric-energy-interface"][rail_electric_accu].icon="__"..modname.."__/graphics/icons/"..electric_rail..".png"

--rail
createdata("straight-rail","straight-rail",straight_rail_power,{
	minable = {mining_time = 0.6, result = electric_rail},
  fast_replaceable_group = "straight-rail"
})

update_rail_pictures("straight-rail",straight_rail_power)
data.raw["straight-rail"]["straight-rail"].fast_replaceable_group = "straight-rail"

createdata("curved-rail","curved-rail",curved_rail_power,{
	icon = "__base__/graphics/icons/curved-rail.png",
  minable = {mining_time = 0.6, result = electric_rail, count=4},
	placeable_by = { item=electric_rail, count = 4},
  fast_replaceable_group = "curved-rail"
})
update_rail_pictures("curved-rail",curved_rail_power)

data.raw["curved-rail"]["curved-rail"].fast_replaceable_group = "curved-rail"