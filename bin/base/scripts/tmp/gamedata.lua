ItemsSettings = {
    ["lawn_mover"] = {
        name = "Lawn Mover",
        capacity_cur = 50,
        capacity_max = 50,
        damage = 10,
    },
    ["coffee_token"] = {
        name = "Coffee Token",
        capacity_cur = 1,
        capacity_max = 1,
        damage = 0,
    },
    ["medi_probe"] = {
        name = "Medi-Probe",
        capacity_cur = 1,
        capacity_max = 1,
        damage = 1,
    },
    ["laser_pistol"] = {
        name = "Laser Pistol",
        accuracy = 40,
        capacity_cur = 6,
        capacity_max = 6,
        damage = 2,
    },
    ["laser_gun"] = {
        name = "Laser Gun",
        accuracy = 40,
        capacity_cur = 6,
        capacity_max = 6,
        damage = 2,
    },
    ["photon"] = {
        name = "Photon",
        accuracy = 6,
        capacity_cur = 18,
        capacity_max = 18,
        damage = 1,
    },
    ["laser_pack_1"] = {
        name = "Laser Pack-1",
        capacity_cur = 6,
        capacity_max = 6,
    },
    ["light_sabre"] = {
        name = "Light Sabre",
        accuracy = 100,
        capacity_cur = 0,
        capacity_max = 0,
        damage = 3,
    },
    ["blast_torch"] = {
        name = "Blast Torch",
        accuracy = 85,
        capacity_cur = 4,
        capacity_max = 4,
        damage = 5,
    },
}

UnitsSettings = {
    ["un_human"] = {
        faction = "",
        name = "Human",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_combat_droid"] = {
        faction = "",
        name = "Combat Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_master_droid"] = {
        faction = "",
        name = "Master Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_android_medium"] = {
        faction = "",
        name = "Android",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_android_light"] = {
        faction = "",
        name = "Android",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_sentry_droid_heavy"] = {
        faction = "",
        name = "Sentry Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_sentry_droid_medium"] = {
        faction = "",
        name = "Sentry Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_sentry_droid_light"] = {
        faction = "",
        name = "Sentry Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_patrol_droid_medium"] = {
        faction = "",
        name = "Patrol Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
    ["un_patrol_droid_light"] = {
        faction = "",
        name = "Patrol Droid",
        morale_cur = 255,
        morale_max = 255,
        stamina_cur = 190,
        stamina_max = 190,
        health_cur = 90,
        health_max = 90,
        armour = 12,
        action_points_cur = 20,
        action_points_max = 20,
        weapon_skill = 0,
    },
}

ObjectsSettings = {
}

TerrainSettings = {
}

GameData = {}

Items = {
    {id = "lawn_mover",   type = EntityType.ItemUseThem,  sprite = "it_lawn_mover_spr",     size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "coffee_token", type = EntityType.ItemUseSelf,  sprite = "it_coffee_token_spr",   size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "medi_probe",   type = EntityType.ItemUseThem,  sprite = "it_medi_probe_spr",     size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "laser_pistol", type = EntityType.WeaponRanged, sprite = "it_laser_pistol_spr",   size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "laser_gun",    type = EntityType.WeaponRanged, sprite = "it_laser_gun_spr",      size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "photon",       type = EntityType.WeaponRanged, sprite = "it_photon_spr",         size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "laser_pack_1", type = EntityType.ItemAmmo,     sprite = "it_laser_pack_1_spr",   size = {32, 32}, layer = 2, geometry = {{1}}},
    {id = "light_sabre",  type = EntityType.WeaponMelee,  sprite = "it_light_sabre_spr",    size = {32, 32}, layer = 2, geometry = {{1}}},
}

Units = {
    {id = "un_human",               type = EntityType.Unit,  desc = nil, sprite = "un_human_idle_spr",           size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_combat_droid",        type = EntityType.Unit,  desc = nil, sprite = "un_combat_droid_idle_spr",    size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_master_droid",        type = EntityType.Unit,  desc = nil, sprite = "un_master_droid_spr",         size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_android_medium",      type = EntityType.Unit,  desc = nil, sprite = "un_android_v1_idle_spr",      size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_android_light",       type = EntityType.Unit,  desc = nil, sprite = "un_android_v2_idle_spr",      size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_sentry_droid_heavy",  type = EntityType.Unit,  desc = nil, sprite = "un_sentry_droid_v1_idle_spr", size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_sentry_droid_medium", type = EntityType.Unit,  desc = nil, sprite = "un_sentry_droid_v2_idle_spr", size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_sentry_droid_light",  type = EntityType.Unit,  desc = nil, sprite = "un_sentry_droid_v3_idle_spr", size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_patrol_droid_medium", type = EntityType.Unit,  desc = nil, sprite = "un_patrol_droid_v1_idle_spr", size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
    {id = "un_patrol_droid_light",  type = EntityType.Unit,  desc = nil, sprite = "un_patrol_droid_v2_idle_spr", size = {32, 32}, layer = 3, geometry = {{1}}, has_inventory = true},
}

Objects = {
    {id = "mo_access_way",            type = nil, sprite = "mo_access_way_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_airlock_door",          type = nil, sprite = "mo_airlock_door_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_analyser",              type = nil, sprite = "mo_analyser_spr",                  size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_bath",                  type = nil, sprite = "mo_bath_spr",                      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_bed",                   type = nil, sprite = "mo_bed_spr",                       size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_bush",                  type = nil, sprite = "mo_bush_spr",                      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_chair",                 type = nil, sprite = "mo_chair_spr",                     size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_chairs",                type = nil, sprite = "mo_chairs_spr",                    size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_coffee_machine",        type = nil, sprite = "mo_coffee_machine_spr",            size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_control_system",        type = nil, sprite = "mo_control_system_spr",            size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_control_system_board",  type = nil, sprite = "mo_control_system_board_spr",      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_control_system_part",   type = nil, sprite = "mo_control_system_part_spr",       size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_control_system_tube",   type = nil, sprite = "mo_control_system_tube_spr",       size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_conveyor_belt",         type = nil, sprite = "mo_conveyor_belt_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_conveyor_belt_end",     type = nil, sprite = "mo_conveyor_belt_end_spr",         size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_crater_small",          type = nil, sprite = "mo_crater_small_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_cupboard",              type = nil, sprite = "mo_cupboard_spr",                  size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_defence_laser",         type = nil, sprite = "mo_defence_laser_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_desk",                  type = nil, sprite = "mo_desk_spr",                      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_droid_bay",             type = nil, sprite = "mo_droid_bay_spr",                 size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_droid_mend",            type = nil, sprite = "mo_droid_mend_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_extract_machine",       type = nil, sprite = "mo_extract_machine_spr",           size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_flower_red",            type = nil, sprite = "mo_flower_red_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_flower_white",          type = nil, sprite = "mo_flower_white_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_flower_yellow",         type = nil, sprite = "mo_flower_yellow_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_food_machine",          type = nil, sprite = "mo_food_machine_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_fountain",              type = nil, sprite = "mo_fountain_spr",                  size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_fuel_drums",            type = nil, sprite = "mo_fuel_drums_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_gas_cannisters",        type = nil, sprite = "mo_gas_cannisters_spr",            size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_generator_left",        type = nil, sprite = "mo_generator_left_spr",            size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_generator_right",       type = nil, sprite = "mo_generator_right_spr",           size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_grass",                 type = nil, sprite = "mo_grass_spr",                     size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_isaac_comp",            type = nil, sprite = "mo_isaac_comp_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_life_monitors",         type = nil, sprite = "mo_life_monitors_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_lockers",               type = nil, sprite = "mo_lockers_spr",                   size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_medibed",               type = nil, sprite = "mo_medibed_spr",                   size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_pile_rubble",           type = nil, sprite = "mo_pile_rubble_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_pillar",                type = nil, sprite = "mo_pillar_spr",                    size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_process_reducer",       type = nil, sprite = "mo_process_reducer_spr",           size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_process_reducer_cover", type = nil, sprite = "mo_process_reducer_cover_spr",     size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_process_reducer_part",  type = nil, sprite = "mo_process_reducer_part_spr",      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_process_reducer_wall",  type = nil, sprite = "mo_process_reducer_wall_spr",      size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_reactor",               type = nil, sprite = "mo_reactor_spr",                   size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_security_door",         type = nil, sprite = "mo_security_door_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_shower",                type = nil, sprite = "mo_shower_spr",                    size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_sliding_door",          type = nil, sprite = "mo_sliding_door_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_spare_engine",          type = nil, sprite = "mo_spare_engine_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_spare_tyres",           type = nil, sprite = "mo_spare_tyres_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_suit_rack",             type = nil, sprite = "mo_suit_rack_spr",                 size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_table",                 type = nil, sprite = "mo_table_spr",                     size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_vidscreen",             type = nil, sprite = "mo_vidscreen_spr",                 size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_cs",           type = nil, sprite = "mo_wall_big_cs_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_i",            type = nil, sprite = "mo_wall_big_i_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_r",            type = nil, sprite = "mo_wall_big_r_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_t",            type = nil, sprite = "mo_wall_big_t_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_tt",           type = nil, sprite = "mo_wall_big_tt_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_big_ts",           type = nil, sprite = "mo_wall_big_ts_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_controls",         type = nil, sprite = "mo_wall_controls_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_controls_2",       type = nil, sprite = "mo_wall_controls_2_spr",           size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_controls_fuse",    type = nil, sprite = "mo_wall_controls_fuse_spr",        size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_controls_set",     type = nil, sprite = "mo_wall_controls_set_spr",         size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_holder",           type = nil, sprite = "mo_wall_holder_spr",               size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_small_c",          type = nil, sprite = "mo_wall_small_c_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_small_i",          type = nil, sprite = "mo_wall_small_i_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_small_t",          type = nil, sprite = "mo_wall_small_t_spr",              size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_wall_small_cr",         type = nil, sprite = "mo_wall_small_cr_spr",             size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_water_pump",            type = nil, sprite = "mo_water_pump_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_window",                type = nil, sprite = "mo_window_spr",                    size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_work_bench",            type = nil, sprite = "mo_work_bench_spr",                size = {32, 32}, layer = 1, geometry = {{1}}},
    {id = "mo_water_tank",            type = nil, sprite = "mo_water_tank_spr",                size = {96, 96}, layer = 1, geometry = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}}},
    {id = "mo_moon_rover",            type = nil, sprite = "mo_moon_rover_spr",                size = {64, 64}, layer = 1, geometry = {{1, 1}, {1, 1}}},
    {id = "mo_crater_big",            type = nil, sprite = "mo_crater_big_spr",                size = {64, 64}, layer = 1, geometry = {{1, 1}, {1, 1}}},
    {id = "mo_tree",                  type = nil, sprite = "mo_tree_spr",                      size = {64, 64}, layer = 1, geometry = {{1, 1}, {1, 1}}},
    {id = "mo_algae_tank",            type = nil, sprite = "mo_algae_tank_spr",                size = {96, 32}, layer = 1, geometry = {{1, 1, 1}}},
}

Terrain = {
}

Entities = {}

local function __cacheEntities(tbl)
    for _, data in ipairs(tbl) do
        local id = data.id
        assert(not Entities[id], string.format("Duplicate entity is found: %s", id))
        Entities[id] = data
    end
end

__cacheEntities(Items)
__cacheEntities(Units)
__cacheEntities(Objects)
__cacheEntities(Terrain)

function GameData.getDefaultDesc(id)
    return Entities[id]
end

function GameData.getDefaultSettings(id)
    if (ItemsSettings[id]) then
        return ItemsSettings[id]
    elseif (UnitsSettings[id]) then
        return UnitsSettings[id]
    elseif (ObjectsSettings[id]) then
        return ObjectsSettings[id]
    elseif (TerrainSettings[id]) then
        return TerrainSettings[id]
    end
    return nil
end
