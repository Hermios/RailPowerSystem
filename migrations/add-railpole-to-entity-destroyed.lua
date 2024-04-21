for _,custom_entity in pairs(global.custom_entities) do
    if custom_entity.entity.name==railpole then
        script.register_on_entity_destroyed(custom_entity.entity)
    end
end