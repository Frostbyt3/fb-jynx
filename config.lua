Config = {

    DebugPoly = false,
    DebugCode = false,

    jobRequired = "jynx",

    -- set this to false if you want to use distance checks
    UseTarget = GetConvar('UseTarget', 'false') == 'true',

    DefaultTextLocation = "right", -- left, right, top

    Meter = {
        ["defaultPrice"] = 25.0, -- price per mile
        ["startingPrice"] = 0  -- static starting price
    },

    tipPercentage = 25, -- Tip Percentage (25% Default)
    recklessPercentage = 5, -- Tip Percentage (5% Default) when you've wrecked more than once during a ride.
    bonusTipChance = math.random(1, 5),
    
    NPCLocations = {
        PickupLocations = {
            [1] = vector4(257.61, -380.57, 44.71, 340.5),
            [2] = vector4(-48.58, -790.12, 410.02, 340.5),
            [3] = vector4(240.06, -862.77, 29.73, 341.5),
            [4] = vector4(826.0, -1885.26, 29.32, 81.5),
            [5] = vector4(350.84, -1974.13, 24.52, 318.5),
            [6] = vector4(-229.11, -2043.16, 27.75, 233.5),
            [7] = vector4(-1053.23, -2716.2, 13.75, 329.5),
            [8] = vector4(-774.04, -1277.25, 5.15, 171.5),
            [9] = vector4(-1184.3, -1304.16, 5.24, 293.5), -- Fix?
            [10] = vector4(-1321.28, -833.8, 16.95, 140.5),
            [11] = vector4(-1613.99, -1015.82, 13.12, 342.5),
            [12] = vector4(-1392.74, -584.91, 30.24, 32.5),
            [13] = vector4(-515.19, -260.29, 35.53, 201.5),
            [14] = vector4(-760.84, -34.35, 37.83, 208.5),
            [15] = vector4(-1284.06, 297.52, 64.93, 148.5),
            [16] = vector4(-808.29, 828.88, 202.89, 200.5),
            [17] = vector4(224.14, -857.25, 30.14, 343.9),  -- Legion Square N of Gas
            [18] = vector4(-561.94, 270.34, 83.02, 175.15), -- Tequi-La-La
            [19] = vector4(-2977.94, 391.63, 15.02, 89.49), -- Rob's Liquor
            [20] = vector4(-3032.68, 547.93, 7.51, 273.88), -- House (804)
            [21] = vector4(-781.69, 5540.62, 33.64, 4.79), -- Tramway
            [22] = vector4(-296.35, 6251.3, 31.45, 227.21), -- Hen House
            [23] = vector4(89.67, 6399.36, 31.4, 309.77), -- Cluckin' Bell Warehouse
            [24] = vector4(1592.19, 3641.37, 35.11, 124.16), -- Sandy Motel
            [25] = vector4(331.54, 2635.57, 44.45, 116.59), -- Other Sandy Motel
            [26] = vector4(1140.87, 2664.54, 38.16, 90.5), -- Route 68 Motel
            [27] = vector4(1851.24, 2585.89, 45.67, 270.1), -- Prison
        },

        DropLocations = {
            [1] = vector4(-1074.39, -266.64, 37.75, 117.5),
            [2] = vector4(-1412.07, -591.75, 30.38, 298.5),
            [3] = vector4(-679.9, -845.01, 23.98, 269.5),
            [4] = vector4(-158.05, -1565.3, 35.06, 139.5),
            [5] = vector4(442.09, -1684.33, 29.25, 320.5),
            [6] = vector4(1120.73, -957.31, 47.43, 289.5),
            [7] = vector4(1238.85, -377.73, 69.03, 70.5),
            [8] = vector4(922.24, -2224.03, 30.39, 354.5),
            [9] = vector4(1920.93, 3703.85, 32.63, 120.5),
            [10] = vector4(1662.55, 4876.71, 42.05, 185.5),
            [11] = vector4(-9.51, 6529.67, 31.37, 136.5),
            [12] = vector4(-3232.7, 1013.16, 12.09, 177.5),
            [13] = vector4(-1604.09, -401.66, 42.35, 321.5),
            [14] = vector4(-586.48, -255.96, 35.91, 210.5),
            [15] = vector4(23.66, -60.23, 63.62, 341.5),
            [16] = vector4(550.3, 172.55, 100.11, 339.5),
            [17] = vector4(-1048.55, -2540.58, 13.69, 148.5),
            [18] = vector4(-3.75, -553.12, 37.47, 268.53),
            [19] = vector4(-7.86, -258.22, 46.9, 68.5),
            [20] = vector4(-743.34, 817.81, 213.6, 219.5),
            [21] = vector4(218.34, 677.47, 189.26, 359.5),
            [22] = vector4(263.2, 1138.81, 221.75, 203.5),
            [23] = vector4(220.64, -1010.81, 29.22, 160.5),
            [24] = vector4(409.14, -998.76, 28.67, 356.59), -- MRPD
            [25] = vector4(200.04, -223.58, 53.38, 249.8), -- White Widow
            [26] = vector4(321.31, -268.55, 53.21, 253.73), -- Hawick Ave. Fleeca
            [27] = vector4(292.26, 176.92, 103.53, 68.53), -- Chinese Theater
            [28] = vector4(-565.81, 268.23, 82.32, 87.88), -- Tequi-La-La
            [29] = vector4(-2981.2, 389.8, 110.07, 355.34), -- Rob's Liquor
            [30] = vector4(-3031.93, 592.9, 7.1, 198.04), -- 24/7 (804)
            [31] = vector4(-2196.93, 4268.17, 47.89, 57.81), -- Hookies
            [32] = vector4(-780.64, 5561.16, 32.88, 2.23), -- Tramway
            [33] = vector4(-431.78, 6028.53, 30.75, 217.99), -- Paleto PD
            [34] = vector4(-292.98, 6250.54, 30.7, 136.97), -- Hen House
            [35] = vector4(-139.88, 6387.0, 30.8, 312.71), -- Mojito Inn
            [36] = vector4(-22.59, 6518.94, 30.72, 131.4), -- Willie's Supermarket
            [37] = vector4(92.29, 6401.41, 30.65, 221.5), -- Cluckin' Bell Warehouse
            [38] = vector4(1584.68, 6441.85, 24.44, 65.66), -- Pop's Diner
            [39] = vector4(1470.29, 6360.55, 23.14, 140.87), -- Homeless Camp (Paleto)
            [40] = vector4(1661.79, 4852.79, 41.31, 187.61), -- Grapeseed
            [41] = vector4(1799.12, 4585.58, 36.43, 6.05), -- Alamo Fruit Market
            [42] = vector4(2502.57, 4098.76, 37.63, 1510.0), -- Red Roses Bar
            [43] = vector4(1995.11, 3775.61, 31.59, 34.58), -- Sandy LTD
            [44] = vector4(1621.1, 3586.07, 34.55, 31.62), -- Sandy Motel
            [45] = vector4(1399.91, 3596.58, 34.3, 109.07), -- Liquor Ace Sandy
            [46] = vector4(341.9, 2630.62, 43.91, 292.84), -- Other Sandy Motel
            [47] = vector4(592.44, 2737.12, 41.44, 5.2), -- Dollar Pills Sandy
            [48] = vector4(1137.53, 2664.75, 37.42, 357.43), -- Route 68 Motel
            [49] = vector4(1854.76, 2585.9, 45.08, 177.39), -- Prison
        },
    },

    PZLocations = {

        PickupLocations = {
            [1] = {coord = vector3(258.98, -377.9, 44.7), height = 17.6, width = 15.0, heading = 69, minZ = 43.75, maxZ = 45.55},
            [2] = {coord = vector3(-50.06, -784.57, 44.16), height = 17.6, width = 15.0, heading = 62, minZ = 43.21, maxZ = 45.01},
            [3] = {coord = vector3(238.93, -858.91, 29.67), height = 17.6, width = 15.0, heading = 71, minZ = 28.72, maxZ = 30.52},
            [4] = {coord = vector3(823.4, -1882.96, 29.29), height = 17.6, width = 15.0, heading = 167, minZ = 28.34, maxZ = 30.14},
            [5] = {coord = vector3(354.05, -1971.57, 24.43), height = 17.6, width = 15.0, heading = 236, minZ = 23.48, maxZ = 25.28},
            [6] = {coord = vector3(-225.61, -2043.63, 27.62), height = 17.6, width = 15.0, heading = 143, minZ = 26.67, maxZ = 28.47},
            [7] = {coord = vector3(-1048.72, -2711.0, 13.76), height = 17.6, width = 15.0, heading = 240, minZ = 12.81, maxZ = 14.61},
            [8] = {coord = vector3(-776.15, -1280.37, 5.0), height = 17.6, width = 15.0, heading = 261, minZ = 4.05, maxZ = 5.85},
            [9] = {coord = vector3(-1181.66, -1303.52, 5.15), height = 17.6, width = 15.0, heading = 205, minZ = 3.5, maxZ = 6.0},
            [10] = {coord = vector3(-1326.52, -833.32, 16.85), height = 17.6, width = 15.0, heading = 225, minZ = 15.9, maxZ = 17.7},
            [11] = {coord = vector3(-1610.24, -1015.33, 13.07), height = 17.6, width = 15.0, heading = 227, minZ = 12.12, maxZ = 13.92},
            [12] = {coord = vector3(-1396.85, -583.72, 30.08), height = 17.6, width = 15.0, heading = 299, minZ = 29.13, maxZ = 30.93},
            [13] = {coord = vector3(-513.06, -263.2, 35.43), height = 17.6, width = 15.0, heading = 293, minZ = 34.48, maxZ = 36.28},
            [14] = {coord = vector3(-756.46, -35.84, 37.69), height = 17.6, width = 15.0, heading = 297, minZ = 36.74, maxZ = 38.54},
            [15] = {coord = vector3(-1285.33, 293.67, 64.83), height = 17.6, width = 15.0, heading = 241, minZ = 63.88, maxZ = 65.68},
            [16] = {coord = vector3(-806.68, 825.2, 202.81), height = 17.6, width = 15.0, heading = 276, minZ = 200.46, maxZ = 204.66},
            [17] = {coord = vector3(224.99, -854.59, 29.99), height = 17.6, width = 15.0, heading = 343, minZ = 29, maxZ = 32}, -- Legion Square
            [18] = {coord = vector3(-562.1, 267.35, 82.92), height = 17.6, width = 15.0, heading = 85.5, minZ = 81, maxZ = 85}, -- Tequi-La-La
            [19] = {coord = vector3(-2981.47, 392.0, 14.87), height = 17.6, width = 15.0, heading = 350, minZ = 14, maxZ = 17}, -- Rob's Liquor
            [20] = {coord = vector3(-3029.17, 547.91, 7.5), height = 17.6, width = 15.0, heading = 180.5, minZ = 6, maxZ = 9}, -- House (804)
            [21] = {coord = vector3(-782.78, 5542.65, 33.52), height = 17.6, width = 15.0, heading = 288, minZ = 32, maxZ = 35}, -- Tramway
            [22] = {coord = vector3(-294.37, 6249.28, 31.29), height = 17.6, width = 15.0, heading = 132, minZ = 30, maxZ = 33}, -- Hen House
            [23] = {coord = vector3(91.92, 6401.39, 31.24), height = 17.6, width = 15.0, heading = 219, minZ = 30, maxZ = 33}, -- Cluckin' Bell Warehouse
            [24] = {coord = vector3(1590.07, 3640.18, 35.0), height = 17.6, width = 15.0, heading = 27.6, minZ = 34, maxZ = 37}, -- Sandy Motel
            [25] = {coord = vector3(328.66, 2634.62, 44.56), height = 17.6, width = 15.0, heading = 204.5, minZ = 43, maxZ = 46}, -- Other Sandy Motel
            [26] = {coord = vector3(1137.73, 2664.94, 38.01), height = 17.6, width = 15.0, heading = 179, minZ = 37, maxZ = 40}, -- Route 68 Motel
            [27] = {coord = vector3(1854.41, 2586.04, 45.67), height = 17.6, width = 15.0, heading = 186.5, minZ = 44, maxZ = 47}, -- Prison
        },    

        DropLocations = {
            [1] = {coord = vector3(-1073.21, -265.35, 37.35), height = 21.2, width = 15.0, heading = 296, minZ = 35.0, maxZ = 39.2},
            [2] = {coord = vector3(-1411.45, -590.98, 29.99), height = 21.2, width = 15.0, heading = 299, minZ = 27.64, maxZ = 31.84},
            [3] = {coord = vector3(-678.68, -845.54, 23.53), height = 21.2, width = 15.0, heading = 269, minZ = 21.18, maxZ = 25.38},
            [4] = {coord = vector3(-159.11, -1565.46, 34.69), height = 21.2, width = 15.0, heading = 321, minZ = 32.34, maxZ = 36.54},
            [5] = {coord = vector3(442.12, -1685.31, 28.85), height = 21.2, width = 15.0, heading = 321, minZ = 26.5, maxZ = 30.7},
            [6] = {coord = vector3(1120.51, -958.97, 46.83), height = 21.2, width = 15.0, heading = 286, minZ = 44.48, maxZ = 48.68},
            [7] = {coord = vector3(1240.79, -377.77, 68.61), height = 21.2, width = 15.0, heading = 249, minZ = 66.26, maxZ = 70.46},
            [8] = {coord = vector3(923.66, -2226.07, 29.98), height = 21.2, width = 15.0, heading = 354, minZ = 27.63, maxZ = 31.83},
            [9] = {coord = vector3(1920.15, 3701.6, 32.26), height = 21.2, width = 15.0, heading = 299, minZ = 29.91, maxZ = 34.11},
            [10] = {coord = vector3(1661.91, 4875.87, 41.66), height = 21.2, width = 15.0, heading = 8, minZ = 39.31, maxZ = 43.51},
            [11] = {coord = vector3(-9.46, 6529.92, 30.95), height = 21.2, width = 15.0, heading = 314, minZ = 28.6, maxZ = 32.8},
            [12] = {coord = vector3(-3233.12, 1010.33, 11.72), height = 21.2, width = 15.0, heading = 357, minZ = 9.37, maxZ = 13.57},
            [13] = {coord = vector3(-1604.11, -401.71, 41.95), height = 21.2, width = 15.0, heading = 322, minZ = 39.6, maxZ = 43.8},
            [14] = {coord = vector3(-586.48, -255.96, 36.53), height = 21.2, width = 15.0, heading = 31, minZ = 34.68, maxZ = 37.48},
            [15] = {coord = vector3(23.51, -60.47, 63.2), height = 21.2, width = 15.0, heading = 156, minZ = 60.55, maxZ = 65.75},
            [16] = {coord = vector3(550.26, 172.54, 99.71), height = 21.2, width = 15.0, heading = 161, minZ = 98.51, maxZ = 100.91},
            [17] = {coord = vector3(-1048.62, -2540.53, 13.3), height = 21.2, width = 15.0, heading = 151, minZ = 12.9, maxZ = 14.9},
            [18] = {coord = vector3(-3.75, -553.12, 37.47), height = 21.2, width = 15.0, heading = 268.5, minZ = 36.28, maxZ = 39.88},
            [19] = {coord = vector3(-7.91, -258.19, 46.49), height = 21.2, width = 15.0, heading = 71, minZ = 45.29, maxZ = 47.69},
            [20] = {coord = vector3(-743.03, 818.9, 213.16), height = 21.2, width = 15.0, heading = 38, minZ = 211.96, maxZ = 214.36},
            [21] = {coord = vector3(218.25, 677.55, 188.87), height = 21.2, width = 15.0, heading = 163, minZ = 187.67, maxZ = 190.07},
            [22] = {coord = vector3(264.47, 1138.41, 221.36), height = 21.2, width = 15.0, heading = 203, minZ = 220.16, maxZ = 222.56},
            [23] = {coord = vector3(220.47, -1010.7, 28.82), height = 21.2, width = 15.0, heading = 158, minZ = 28.02, maxZ = 30.42},
            [24] = {coord = vector4(409.14, -998.76, 28.67, 356.59), height = 21.2, width = 15.0, heading = 356, minZ = 28, maxZ = 30},
            [25] = {coord = vector4(200.04, -223.58, 53.38, 249.8), height = 21.2, width = 15.0, heading = 249, minZ = 53, maxZ = 55},
            [26] = {coord = vector4(321.31, -268.55, 53.21, 253.73), height = 21.2, width = 15.0, heading = 253, minZ = 52.5, maxZ = 55},
            [27] = {coord = vector4(292.26, 176.92, 103.53, 68.53), height = 21.2, width = 15.0, heading = 68, minZ = 102.5, maxZ = 105},
            [28] = {coord = vector4(-565.81, 268.23, 82.32, 87.88), height = 21.2, width = 15.0, heading = 87, minZ = 81.5, maxZ = 84},
            [29] = {coord = vector4(-2981.2, 389.8, 110.07, 355.34), height = 21.2, width = 15.0, heading = 355, minZ = 13.5, maxZ = 16},
            [30] = {coord = vector4(-3031.93, 592.9, 7.1, 198.04), height = 21.2, width = 15.0, heading = 198, minZ = 6.5, maxZ = 9},
            [31] = {coord = vector4(-2196.93, 4268.17, 47.89, 57.81), height = 21.2, width = 15.0, heading = 57, minZ = 47, maxZ = 49},
            [32] = {coord = vector4(-780.64, 5561.16, 32.88, 2.23), height = 21.2, width = 15.0, heading = 2, minZ = 32, maxZ = 34},
            [33] = {coord = vector4(-431.78, 6028.53, 30.75, 217.99), height = 21.2, width = 15.0, heading = 217, minZ = 30, maxZ = 32},
            [34] = {coord = vector4(-292.98, 6250.54, 30.7, 136.97), height = 21.2, width = 15.0, heading = 136, minZ = 30, maxZ = 32},
            [35] = {coord = vector4(-139.88, 6387.0, 30.8, 312.71), height = 21.2, width = 15.0, heading = 312, minZ = 30, maxZ = 32},
            [36] = {coord = vector4(-22.59, 6518.94, 30.72, 131.4), height = 21.2, width = 15.0, heading = 131, minZ = 30, maxZ = 32},
            [37] = {coord = vector4(92.29, 6401.41, 30.65, 221.5), height = 21.2, width = 15.0, heading = 221, minZ = 30, maxZ = 32},
            [38] = {coord = vector4(1584.68, 6441.85, 24.44, 65.66), height = 21.2, width = 15.0, heading = 65, minZ = 24, maxZ = 26},
            [39] = {coord = vector4(1470.29, 6360.55, 23.14, 140.87), height = 21.2, width = 15.0, heading = 140, minZ = 22.5, maxZ = 25},
            [40] = {coord = vector4(1661.79, 4852.79, 41.31, 187.61), height = 21.2, width = 15.0, heading = 187, minZ = 40.5, maxZ = 43},
            [41] = {coord = vector4(1799.12, 4585.58, 36.43, 6.05), height = 21.2, width = 15.0, heading = 6, minZ = 35.5, maxZ = 38},
            [42] = {coord = vector4(2502.57, 4098.76, 37.63, 1510.0), height = 21.2, width = 15.0, heading = 154, minZ = 36.5, maxZ = 39},
            [43] = {coord = vector4(1995.11, 3775.61, 31.59, 34.58), height = 21.2, width = 15.0, heading = 34, minZ = 30.5, maxZ = 33},
            [44] = {coord = vector4(1621.1, 3586.07, 34.55, 31.62), height = 21.2, width = 15.0, heading = 31, minZ = 33.5, maxZ = 36},
            [45] = {coord = vector4(1399.91, 3596.58, 34.3, 109.07), height = 21.2, width = 15.0, heading = 109, minZ = 33.5, maxZ = 36},
            [46] = {coord = vector4(341.9, 2630.62, 43.91, 292.84), height = 21.2, width = 15.0, heading = 292, minZ = 43, maxZ = 45},
            [47] = {coord = vector4(592.44, 2737.12, 41.44, 5.2), height = 21.2, width = 15.0, heading = 5, minZ = 40.5, maxZ = 43},
            [48] = {coord = vector4(1137.53, 2664.75, 37.42, 357.43), height = 21.2, width = 15.0, heading = 357, minZ = 37, maxZ = 39},
            [49] = {coord = vector4(1854.76, 2585.9, 45.08, 177.39), height = 21.2, width = 15.0, heading = 177, minZ = 44.5, maxZ = 47},
        },
    },    

    NpcSkins = {
        [1] = {
            'a_f_m_skidrow_01',
            'a_f_m_soucentmc_01',
            'a_f_m_soucent_01',
            'a_f_m_soucent_02',
            'a_f_m_tourist_01',
            'a_f_m_trampbeac_01',
            'a_f_m_tramp_01',
            'a_f_o_genstreet_01',
            'a_f_o_indian_01',
            'a_f_o_ktown_01',
            'a_f_o_salton_01',
            'a_f_o_soucent_01',
            'a_f_o_soucent_02',
            'a_f_y_beach_01',
            'a_f_y_bevhills_01',
            'a_f_y_bevhills_02',
            'a_f_y_bevhills_03',
            'a_f_y_bevhills_04',
            'a_f_y_business_01',
            'a_f_y_business_02',
            'a_f_y_business_03',
            'a_f_y_business_04',
            'a_f_y_eastsa_01',
            'a_f_y_eastsa_02',
            'a_f_y_eastsa_03',
            'a_f_y_epsilon_01',
            'a_f_y_fitness_01',
            'a_f_y_fitness_02',
            'a_f_y_genhot_01',
            'a_f_y_golfer_01',
            'a_f_y_hiker_01',
            'a_f_y_hipster_01',
            'a_f_y_hipster_02',
            'a_f_y_hipster_03',
            'a_f_y_hipster_04',
            'a_f_y_indian_01',
            'a_f_y_juggalo_01',
            'a_f_y_runner_01',
            'a_f_y_rurmeth_01',
            'a_f_y_scdressy_01',
            'a_f_y_skater_01',
            'a_f_y_soucent_01',
            'a_f_y_soucent_02',
            'a_f_y_soucent_03',
            'a_f_y_tennis_01',
            'a_f_y_tourist_01',
            'a_f_y_tourist_02',
            'a_f_y_vinewood_01',
            'a_f_y_vinewood_02',
            'a_f_y_vinewood_03',
            'a_f_y_vinewood_04',
            'a_f_y_yoga_01',
            'g_f_y_ballas_01',
        },
        [2] = {
            'ig_barry',
            'ig_bestmen',
            'ig_beverly',
            'ig_car3guy1',
            'ig_car3guy2',
            'ig_casey',
            'ig_chef',
            'ig_chengsr',
            'ig_chrisformage',
            'ig_clay',
            'ig_claypain',
            'ig_cletus',
            'ig_dale',
            'ig_dreyfuss',
            'ig_fbisuit_01',
            'ig_floyd',
            'ig_groom',
            'ig_hao',
            'ig_hunter',
            'csb_prolsec',
            'ig_joeminuteman',
            'ig_josef',
            'ig_josh',
            'ig_lamardavis',
            'ig_lazlow',
            'ig_lestercrest',
            'ig_lifeinvad_01',
            'ig_lifeinvad_02',
            'ig_manuel',
            'ig_milton',
            'ig_mrk',
            'ig_nervousron',
            'ig_nigel',
            'ig_old_man1a',
            'ig_old_man2',
            'ig_oneil',
            'ig_orleans',
            'ig_ortega',
            'ig_paper',
            'ig_priest',
            'ig_prolsec_02',
            'ig_ramp_gang',
            'ig_ramp_hic',
            'ig_ramp_hipster',
            'ig_ramp_mex',
            'ig_roccopelosi',
            'ig_russiandrunk',
            'ig_siemonyetarian',
            'ig_solomon',
            'ig_stevehains',
            'ig_stretch',
            'ig_talina',
            'ig_taocheng',
            'ig_taostranslator',
            'ig_tenniscoach',
            'ig_terry',
            'ig_tomepsilon',
            'ig_tylerdix',
            'ig_wade',
            'ig_zimbor',
            's_m_m_paramedic_01',
            'a_m_m_afriamer_01',
            'a_m_m_beach_01',
            'a_m_m_beach_02',
            'a_m_m_bevhills_01',
            'a_m_m_bevhills_02',
            'a_m_m_business_01',
            'a_m_m_eastsa_01',
            'a_m_m_eastsa_02',
            'a_m_m_farmer_01',
            'a_m_m_fatlatin_01',
            'a_m_m_genfat_01',
            'a_m_m_genfat_02',
            'a_m_m_golfer_01',
            'a_m_m_hasjew_01',
            'a_m_m_hillbilly_01',
            'a_m_m_hillbilly_02',
            'a_m_m_indian_01',
            'a_m_m_ktown_01',
            'a_m_m_malibu_01',
            'a_m_m_mexcntry_01',
            'a_m_m_mexlabor_01',
            'a_m_m_og_boss_01',
            'a_m_m_paparazzi_01',
            'a_m_m_polynesian_01',
            'a_m_m_prolhost_01',
            'a_m_m_rurmeth_01',
        },
    },
}