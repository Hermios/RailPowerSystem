addRail=function(straightRailName,curvedRailName)
	current_prototypes[straightRailName]=railprototype
	current_prototypes[curvedRailName]=railprototype
end

addLocomotive=function(locomotiveName)
	current_prototypes[locomotiveName]=locomotive
end

function InitRemote()
	remote.add_interface
	(modname,
		{
			addRail=addRail,
			addLocomotive=addLocomotive
		}
	)
	if remote.interfaces.farl then
		remote.call("farl", "add_entity_to_trigger", straight_rail_power)
		remote.call("farl", "add_entity_to_trigger", curved_rail_power)
	end
end