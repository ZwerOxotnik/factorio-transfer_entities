data:extend({
	{
		type = "bool-setting",
		name = "TE-only_online_force",
		setting_type = "runtime-global",
		default_value = false
	},
	{
		type = "int-setting",
		name = "TE-max_entities",
		setting_type = "runtime-global",
		default_value = 500,
		minimum_value = 1,
		maximum_value = 10000,
	},
	{
		type = "string-setting",
		name = "TE-to_whom",
		setting_type = "runtime-global",
		default_value = "ally",
		allowed_values = {"ally", "ally_and_neutral"}
	}
})
