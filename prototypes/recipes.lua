data:extend({
    {
        type = "recipe",
        name = electric_rail,
        enabled = false,
        ingredients = { { "copper-cable", 3 }, { "rail", 1 },{ "electronic-circuit", 2 } },
        result = electric_rail,
        result_count = 1,
    },
	{
        type = "recipe",
        name = railpole_prototype,
        enabled = false,
        ingredients = { { "iron-plate", 3 }, { "copper-cable", 1 },{ "electronic-circuit", 1 } },
        result = railpole_prototype,
        result_count = 1,
    },
	{
        type = "recipe",
        name = electric_locomotive,
        enabled = false,
        ingredients = { { "locomotive", 1 }, { "electric-engine-unit", 20 } },
        result = electric_locomotive,
        result_count = 1,
    },
})