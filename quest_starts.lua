-- Debut de quete (extrait de psostats-client, MIT : https://github.com/phelix-/psostats-client).
-- [numero de quete] = N : le chrono demarre quand le registre N passe a > 0 ;
--                   { floor = F, switch = S } : quand l'interrupteur S de l'etage F s'active ;
--                   "warp" : quand le joueur arrive sur le terrain (quitte Pioneer 2 / etage 0).
-- Les quetes absentes de ce fichier gardent le comportement habituel : le chrono demarre
-- des que la quete est prise au comptoir.
return {
    [101] = 0, -- EP1 Mop-up Operation #1
    [102] = 0, -- EP1 Mop-up Operation #2
    [103] = 0, -- EP1 Mop-up Operation #3
    [104] = 0, -- EP1 Mop-up Operation #4
    [1761] = 210, -- EP1 Sweep-up Operation #1
    [1762] = 210, -- EP1 Sweep-up Operation #2
    [1763] = 210, -- EP1 Sweep-up Operation #3
    [1764] = 210, -- EP1 Sweep-up Operation #4
    [108] = "warp", -- EP1 Endless Nightmare #1
    [109] = "warp", -- EP1 Endless Nightmare #2
    [110] = "warp", -- EP1 Endless Nightmare #3
    [111] = "warp", -- EP1 Endless Nightmare #4
    [1865] = 210, -- EP1 Silent Afterimage #1
    [1866] = 210, -- EP1 Silent Afterimage #2
    [1867] = 210, -- EP1 Silent Afterimage #3
    [1868] = 210, -- EP1 Silent Afterimage #4
    [1869] = 210, -- EP1 Chronocide Trial #1
    [1870] = 210, -- EP1 Chronocide Trial #2
    [1871] = 210, -- EP1 Chronocide Trial #3
    [1872] = 210, -- EP1 Chronocide Trial #4
    [1810] = 82, -- EP1 Anomalous Ordeal #1
    [1811] = 82, -- EP1 Anomalous Ordeal #2
    [1812] = 82, -- EP1 Anomalous Ordeal #3
    [1813] = 82, -- EP1 Anomalous Ordeal #4
    [1814] = 82, -- EP1 Anomalous Ordeal #5
    [1827] = 5, -- EP1 Scarlet Realm #1
    [1828] = 7, -- EP1 Scarlet Realm #2
    [1829] = 25, -- EP1 Scarlet Realm #3
    [1830] = 4, -- EP1 Scarlet Realm #4
    [105] = "warp", -- EP1 Lost HEAT SWORD
    [106] = "warp", -- EP1 Lost ICE SPINNER
    [107] = "warp", -- EP1 Lost SOUL BLADE
    [120] = "warp", -- EP1 Lost HELL PALLASCH
    [907] = "warp", -- EP1 Forsaken Friends
    [960] = { floor = 7, switch = 1 }, -- EP1 August Atrocity #1
    [900] = { floor = 4, switch = 100 }, -- EP1 Christmas Fiasco Episode 1
    [1786] = { floor = 2, switch = 1 }, -- EP1 December Disaster #1
    [930] = { floor = 2, switch = 0 }, -- EP1 Maximum Attack E: Forest
    [931] = { floor = 4, switch = 0 }, -- EP1 Maximum Attack E: Caves
    [961] = { floor = 4, switch = 0 }, -- EP1 Maximum Attack E: Caves -MM-
    [932] = { floor = 6, switch = 0 }, -- EP1 Maximum Attack E: Mines
    [962] = { floor = 6, switch = 0 }, -- EP1 Maximum Attack E: Mines -MM-
    [933] = { floor = 10, switch = 0 }, -- EP1 Maximum Attack E: Ruins
    [963] = { floor = 10, switch = 0 }, -- EP1 Maximum Attack E: Ruins -MM-
    [144] = { floor = 4, switch = 99 }, -- EP1 Maximum Attack 4 -1A-
    [145] = { floor = 4, switch = 99 }, -- EP1 Maximum Attack 4 -1B-
    [146] = { floor = 4, switch = 99 }, -- EP1 Maximum Attack 4 -1C-
    [147] = { floor = 10, switch = 99 }, -- EP1 C1AM
    [942] = { floor = 2, switch = 0 }, -- EP1 Maximum Attack E: Episode 1
    [1303] = "warp", -- EP1 Random Attack Xrd Stage
    [1801] = "warp", -- EP1 Random Attack Xrd REV 1
    [118] = 12, -- EP1 Towards the Future
    [161] = 4, -- EP1 Tyrell's Ego
    [1873] = 210, -- EP1 Coetaneous Resolve
    [1960] = 1, -- EP1 Subterranean Patrol #1
    [1850] = 50, -- EP1 Endless: Episode 1
    [1666] = "warp", -- EP1 Hollow Battlefield: Forest
    [1667] = "warp", -- EP1 Hollow Battlefield: Cave
    [1668] = "warp", -- EP1 Hollow Battlefield: Mine
    [1669] = "warp", -- EP1 Hollow Battlefield: Ruins
    [901] = { floor = 4, switch = 100 }, -- EP2 Christmas Fiasco Episode 2
    [1787] = { floor = 7, switch = 200 }, -- EP2 December Disaster #2
    [934] = { floor = 1, switch = 0 }, -- EP2 Maximum Attack E: Temple
    [935] = { floor = 3, switch = 0 }, -- EP2 Maximum Attack E: Space
    [936] = { floor = 5, switch = 0 }, -- EP2 Maximum Attack E: CCA
    [937] = { floor = 10, switch = 0 }, -- EP2 Maximum Attack E: Seabed
    [938] = { floor = 17, switch = 0 }, -- EP2 Maximum Attack E: Tower
    [1821] = 50, -- EP2 Penumbral Surge #1
    [1822] = 15, -- EP2 Penumbral Surge #2
    [1823] = 90, -- EP2 Penumbral Surge #3
    [1824] = 51, -- EP2 Penumbral Surge #4
    [1825] = 15, -- EP2 Penumbral Surge #5
    [1826] = 15, -- EP2 Penumbral Surge #6
    [233] = "warp", -- EP2 Phantasmal World #1
    [234] = "warp", -- EP2 Phantasmal World #2
    [235] = "warp", -- EP2 Phantasmal World #3
    [236] = "warp", -- EP2 Phantasmal World #4
    [1765] = 210, -- EP2 Sweep-up Operation #5
    [1766] = 210, -- EP2 Sweep-up Operation #6
    [1767] = 210, -- EP2 Sweep-up Operation #7
    [1768] = 210, -- EP2 Sweep-up Operation #8
    [1769] = 210, -- EP2 Sweep-up Operation #9
    [1309] = { floor = 3, switch = 20 }, -- EP2 Gal Da Val's Darkness
    [1700] = { floor = 1, switch = 40 }, -- EP2 CAL's Clock Challenge
    [1780] = "warp", -- EP2 Lost SHOCK RIFLE
    [1781] = "warp", -- EP2 Lost BIND ASSAULT
    [1782] = "warp", -- EP2 Lost FILL CANNON
    [1783] = "warp", -- EP2 Lost DEMON'S RAILGUN
    [1784] = "warp", -- EP2 Lost CHARGE VULCAN
    [238] = { floor = 2, switch = 12 }, -- EP2 MAXIMUM ATTACK 2 Ver2
    [241] = { floor = 5, switch = 99 }, -- EP2 Maximum Attack 4 -2A-
    [242] = { floor = 5, switch = 99 }, -- EP2 Maximum Attack 4 -2B-
    [243] = { floor = 5, switch = 99 }, -- EP2 Maximum Attack 4 -2C-
    [943] = { floor = 1, switch = 0 }, -- EP2 Maximum Attack E: VR
    [944] = { floor = 5, switch = 0 }, -- EP2 Maximum Attack E: GDV
    [1802] = "warp", -- EP2 Random Attack Xrd REV 2
    [1319] = "warp", -- EP2 The Military Strikes Back
    [1820] = 50, -- EP2 Twilight Sanctuary
    [231] = 84, -- EP2 Respective Tomorrow
    [1670] = "warp", -- EP2 Hollow Reality: Temple
    [1671] = "warp", -- EP2 Hollow Reality: Spaceship
    [1672] = "warp", -- EP2 Hollow Phantasm: Jungle
    [1673] = "warp", -- EP2 Hollow Phantasm: Seabed
    [1674] = "warp", -- EP2 Hollow Phantasm: Tower
    [1851] = 50, -- EP2 Endless: Episode 2
    [811] = "warp", -- EP4 War of Limits 1
    [812] = "warp", -- EP4 War of Limits 2
    [813] = "warp", -- EP4 War of Limits 3
    [814] = "warp", -- EP4 War of Limits 4
    [815] = "warp", -- EP4 War of Limits 5
    [816] = 205, -- EP4 New Mop-Up Operation #1
    [817] = 86, -- EP4 New Mop-Up Operation #2
    [818] = 205, -- EP4 New Mop-Up Operation #3
    [819] = 110, -- EP4 New Mop-Up Operation #4
    [820] = 86, -- EP4 New Mop-Up Operation #5
    [1770] = 210, -- EP4 Sweep-up Operation #10
    [1771] = 210, -- EP4 Sweep-up Operation #11
    [1772] = 210, -- EP4 Sweep-up Operation #12
    [1773] = 210, -- EP4 Sweep-up Operation #13
    [1774] = 210, -- EP4 Sweep-up Operation #14
    [1790] = "warp", -- EP4 Lost BERSERK BATON
    [1791] = "warp", -- EP4 Lost SPIRIT STRIKER
    [902] = { floor = 1, switch = 100 }, -- EP4 Christmas Fiasco Episode 4
    [939] = { floor = 2, switch = 0 }, -- EP4 Maximum Attack E: Crater
    [940] = { floor = 8, switch = 0 }, -- EP4 Maximum Attack E: Desert
    [303] = { floor = 5, switch = 66 }, -- EP4 Maximum Attack 4 -4A-
    [304] = { floor = 5, switch = 66 }, -- EP4 Maximum Attack 4 -4B-
    [305] = { floor = 5, switch = 66 }, -- EP4 Maximum Attack 4 -4C-
    [945] = { floor = 2, switch = 0 }, -- EP4 Maximum Attack E: Episode 4
    [1803] = "warp", -- EP4 Random Attack Xrd REV 4
    [313] = { floor = 1, switch = 20 }, -- EP4 Beyond the Horizon
    [11002] = 110, -- EP4 Sacred Groundz
    [1675] = "warp", -- EP4 Hollow Wasteland: Wilderness
    [1676] = "warp", -- EP4 Hollow Wasteland: Desert
}
