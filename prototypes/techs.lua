data:extend(
{
  {
    type = "technology",
    name = "rail-power-system",
    icon = "__"..modname.."__/graphics/tech/tech.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = electric_locomotive
      },
      {
        type = "unlock-recipe",
        recipe = railpole_prototype
      },
      {
        type = "unlock-recipe",
        recipe = electric_rail
      }
    },
	icon_size=128,
    prerequisites = {"circuit-network","railway"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})