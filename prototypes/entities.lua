function create_rail_pictures(objecttype,original,newname,newdata)
  local railtable=createdata(objecttype,original,newname,newdata)
	for rail_position,_ in pairs(railtable.pictures) do
      if railtable.pictures[rail_position].backplates and string.find(railtable.pictures[rail_position].backplates.filename,original,1,true) then
        railtable.pictures[rail_position].backplates.filename=railtable.pictures[rail_position].backplates.filename:gsub(original,newname):gsub("__base__","__"..modname.."__")
        railtable.pictures[rail_position].backplates.hr_version.filename=railtable.pictures[rail_position].backplates.hr_version.filename:gsub(original:gsub("%-","%%-"),newname):gsub("__base__","__"..modname.."__")
      end
    end
  return railtable
end

data:extend(
{
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
})

--circuit's components
createdata("rail-signal","rail-signal",railpole_prototype,{
	fast_replaceable_group = nil,
	selection_box={{0, 0}, {0, 0}},
    drawing_box = {{-0.5, -2.6}, {0.5, 0.5}},
	corpse = "rail-signal-remnants",
    draw_copper_wires=false,
	draw_circuit_wires=false,
	animation ={
    filename="__"..modname.."__/graphics/entity/"..railpole..".png",
    priority = "high",
    width = 189,
    height = 160,
    frame_count = 1,
    direction_count = 8
  },
	green_light = {intensity = 0, size = 0.1, color={g=1}},
  orange_light = {intensity = 0, size = 0.1, color={r=1, g=0.5}},
  red_light = {intensity = 0, size = 0.1, color={r=1}},
	circuit_connector_sprites=nil
})

local connection_points={}
for i=1, 8 do
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
	icon = "__base__/graphics/icons/small-electric-pole.png",
    minable = {mining_time = 0.5, result = railpole_prototype},
	collision_box = {{0, 0}, {0, 0}},
	fast_replaceable_group = nil,
	corpse="small-electric-pole-remnants",
	flags = {"placeable-neutral", "player-creation","not-blueprintable","fast-replaceable-no-build-while-moving","placeable-off-grid","building-direction-8-way"},
	supply_area_distance = 1,
	pictures ={
		filename="__"..modname.."__/graphics/entity/"..railpole..".png",
		priority = "high",
		line_length = 1,
		width = 189,
		height = 160,
		direction_count = 8
    },
	track_coverage_during_build_by_moving = false,
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
create_rail_pictures("straight-rail","straight-rail",straight_rail_power,{
	minable = {mining_time = 0.6, result = electric_rail},
	corpse = "straight-rail-remnants",
})

create_rail_pictures("curved-rail","curved-rail",curved_rail_power,{
	icon = "__base__/graphics/icons/curved-rail.png",
  minable = {mining_time = 0.6, result = electric_rail, count=4},
	placeable_by = { item=electric_rail, count = 4},
	corpse = "curved-rail-remnants",
})