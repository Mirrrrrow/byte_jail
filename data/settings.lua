return {
    developmentMode = true,
    time = {
        min = 1,
        max = 15
    },
    commands = {
        jailtime = {
            use = true,
            name = 'jailtime'
        }
    },
    locales = {
        ['press_e_to_jail'] = 'Press **E** to jail the person in',
        ['notify_title'] = 'State Prison',
        ['no_player_nearby'] = 'No player nearby',
        ['jail_input_title'] = 'State Prison | Jail',
        ['time_input_field_title'] = 'Jailtime (%sm - %sm)',
        ['time_input_field_desc'] = 'Please select how long the person should stay into prison',
        ['case_number_input_field_title'] = 'Case number',
        ['case_number_input_field_desc'] = 'Please enter the number of the case',
        ['jail_canceled'] = 'Jail canceled!',
        ['player_not_found'] = 'The player could not be found!',
        ['player_got_jailed'] = '%s is now in prison!',
        ['jail_info'] = 'You have to stay for %sm.',
        ['jail_finished'] = 'You got out!',
        ['press_e_to_manage'] = 'Press **E** to manage the prisoners',
        ['no_players'] = 'There are no players in prison.',
        ['free_player'] = 'Free player',
        ['add_time'] = 'Add time',
        ['remove_time'] = 'Remove time',
        ['view_more'] = 'Enter to see options',
        ['player_in_jail'] = 'The player is already in prison',
        ['current_jail_time'] = 'You have to stay for %sm.',
        ['not_in_jail'] = 'You are not in prison!',
        ['free_confirm'] = 'Do you really want to free **%s**?',
        ['change_canceled'] = 'Change canceled!',
        ['add_time_input_title'] = 'How much time do you want to add?',
        ['add_time_input_desc'] = 'Time in minutes',
        ['del_time_input_title']  = 'How much time do you want to remove?',
        ['del_time_input_desc']  = 'Time in minutes',
        ['time_edited'] = 'Jailtime changed!'
    },
    clothes = {
        male = {
            ['tshirt_1'] = 20, ['tshirt_2'] = 15,
            ['torso_1'] = 5, ['torso_2'] = 0,
            ['arms'] = 5,
            ['pants_1'] = 5, ['pants_2'] = 7,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
        },
        female = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 2, ['torso_2'] = 6,
            ['arms'] = 2,
            ['pants_1'] = 2, ['pants_2'] = 0,
            ['shoes_1'] = 35, ['shoes_2'] = 0,
        }
    },
    allowedJobs = { 'police' },
    positions = {
        jailIn = vector3(1690.9285, 2591.1086, 45.9144),
        insideJail = vector3(1691.5653, 2563.7590, 44.5649),
        outsideJail = vector3(1851.2189, 2585.0459, 44.8226),
        managePlayers = vector3(1677.8887, 2593.6729, 45.5649),
    }
}