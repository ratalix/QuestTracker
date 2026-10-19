-- Fin de quete (extraite de psostats-client, MIT : https://github.com/phelix-/psostats-client).
-- [numero de quete] = N : registre dont la valeur passe a > 0 quand la quete est terminee,
--                   ou { floor = F, switch = S } : interrupteur S de l'etage F active a la fin.
-- Utilise par QuestTracker en complement de la detection par texte (le texte reste en secours).
-- Les quetes gouvernementales et Simulator 2.0 n'ont pas de registre connu : texte uniquement.
return {
    [101] = 254, -- EP1 Mop-up Operation #1
    [102] = 254, -- EP1 Mop-up Operation #2
    [103] = 254, -- EP1 Mop-up Operation #3
    [104] = 254, -- EP1 Mop-up Operation #4
    [105] = 15, -- EP1 Lost HEAT SWORD
    [106] = 15, -- EP1 Lost ICE SPINNER
    [107] = 18, -- EP1 Lost SOUL BLADE
    [108] = 30, -- EP1 Endless Nightmare #1
    [109] = 30, -- EP1 Endless Nightmare #2
    [110] = 30, -- EP1 Endless Nightmare #3
    [111] = 30, -- EP1 Endless Nightmare #4
    [118] = 254, -- EP1 Towards the Future
    [120] = 110, -- EP1 Lost HELL PALLASCH
    [144] = { floor = 10, switch = 31 }, -- EP1 Maximum Attack 4 -1A-
    [145] = { floor = 10, switch = 32 }, -- EP1 Maximum Attack 4 -1B-
    [146] = 254, -- EP1 Maximum Attack 4 -1C-
    [161] = 101, -- EP1 Tyrell's Ego
    [231] = 98, -- EP2 Respective Tomorrow
    [233] = 254, -- EP2 Phantasmal World #1
    [234] = 111, -- EP2 Phantasmal World #2
    [235] = { floor = 11, switch = 180 }, -- EP2 Phantasmal World #3
    [236] = { floor = 16, switch = 120 }, -- EP2 Phantasmal World #4
    [238] = 123, -- EP2 MAXIMUM ATTACK 2 Ver2
    [241] = { floor = 11, switch = 29 }, -- EP2 Maximum Attack 4 -2A-
    [242] = { floor = 11, switch = 29 }, -- EP2 Maximum Attack 4 -2B-
    [243] = 254, -- EP2 Maximum Attack 4 -2C-
    [303] = { floor = 8, switch = 50 }, -- EP4 Maximum Attack 4 -4A-
    [304] = { floor = 8, switch = 20 }, -- EP4 Maximum Attack 4 -4B-
    [305] = { floor = 8, switch = 192 }, -- EP4 Maximum Attack 4 -4C-
    [313] = { floor = 8, switch = 80 }, -- EP4 Beyond the Horizon
    [811] = 254, -- EP4 War of Limits 1
    [812] = 254, -- EP4 War of Limits 2
    [813] = 254, -- EP4 War of Limits 3
    [814] = 254, -- EP4 War of Limits 4
    [815] = 254, -- EP4 War of Limits 5
    [816] = 157, -- EP4 New Mop-Up Operation #1
    [817] = 43, -- EP4 New Mop-Up Operation #2
    [818] = 254, -- EP4 New Mop-Up Operation #3
    [819] = 43, -- EP4 New Mop-Up Operation #4
    [820] = 43, -- EP4 New Mop-Up Operation #5
    [900] = { floor = 10, switch = 3 }, -- EP1 Christmas Fiasco Episode 1
    [901] = { floor = 11, switch = 3 }, -- EP2 Christmas Fiasco Episode 2
    [902] = { floor = 8, switch = 3 }, -- EP4 Christmas Fiasco Episode 4
    [907] = 99, -- EP1 Forsaken Friends
    [942] = 254, -- EP1 Maximum Attack E: Episode 1
    [943] = 254, -- EP2 Maximum Attack E: VR
    [944] = 254, -- EP2 Maximum Attack E: Gal Da Val
    [945] = 254, -- EP4 Maximum Attack E: Episode 4
    [1303] = 254, -- EP1 Random Attack Xrd Stage
    [1309] = 89, -- EP2 Gal Da Val's Darkness
    [1319] = 121, -- EP2 The Military Strikes Back
    [1321] = 12, -- A New Hope : mort d'Olga Flow (message "genetic sample from Olga Flow's body"). Fin des credits = registre 146
    [1666] = 0, -- EP1 Hollow Battlefield: Forest
    [1667] = 0, -- EP1 Hollow Battlefield: Cave
    [1668] = 0, -- EP1 Hollow Battlefield: Mine
    [1669] = 0, -- EP1 Hollow Battlefield: Ruins
    [1670] = 0, -- EP2 Hollow Reality: Temple
    [1671] = 0, -- EP2 Hollow Reality: Spaceship
    [1672] = 0, -- EP2 Hollow Phantasm: Jungle
    [1673] = 0, -- EP2 Hollow Phantasm: Seabed
    [1674] = 0, -- EP2 Hollow Phantasm: Tower
    [1675] = 0, -- EP4 Hollow Wasteland: Wilderness
    [1676] = 0, -- EP4 Hollow Wasteland: Desert
    [1700] = 254, -- EP2 CAL's Clock Challenge
    [1761] = 254, -- EP1 Sweep-up Operation #1
    [1762] = 254, -- EP1 Sweep-up Operation #2
    [1763] = 254, -- EP1 Sweep-up Operation #3
    [1764] = 254, -- EP1 Sweep-up Operation #4
    [1765] = 254, -- EP2 Sweep-up Operation #5
    [1766] = 254, -- EP2 Sweep-up Operation #6
    [1767] = 254, -- EP2 Sweep-up Operation #7
    [1770] = 254, -- EP4 Sweep-up Operation #10
    [1771] = 254, -- EP4 Sweep-up Operation #11
    [1772] = 254, -- EP4 Sweep-up Operation #12
    [1773] = 254, -- EP4 Sweep-up Operation #13
    [1774] = 254, -- EP4 Sweep-up Operation #14
    [1780] = 15, -- EP2 Lost SHOCK RIFLE
    [1781] = 15, -- EP2 Lost BIND ASSAULT
    [1782] = 15, -- EP2 Lost FILL CANNON
    [1783] = 15, -- EP2 Lost DEMON'S RAILGUN
    [1784] = 15, -- EP2 Lost CHARGE VULCAN
    [1786] = 241, -- EP1 December Disaster #1
    [1787] = 241, -- EP2 December Disaster #2
    [1790] = 15, -- EP4 Lost BERSERK BATON
    [1791] = 15, -- EP4 Lost SPIRIT STRIKER
    [1801] = 254, -- EP1 Random Attack Xrd REV 1
    [1802] = 254, -- EP2 Random Attack Xrd REV 2
    [1803] = 254, -- EP4 Random Attack Xrd REV 4
    [1810] = 254, -- EP1 Anomalous Ordeal #1
    [1811] = 254, -- EP1 Anomalous Ordeal #2
    [1812] = 254, -- EP1 Anomalous Ordeal #3
    [1813] = 254, -- EP1 Anomalous Ordeal #4
    [1814] = 254, -- EP1 Anomalous Ordeal #5
    [1820] = 254, -- EP2 Twilight Sanctuary
    [1821] = 254, -- EP2 Penumbral Surge #1
    [1822] = 254, -- EP2 Penumbral Surge #2
    [1823] = 254, -- EP2 Penumbral Surge #3
    [1824] = 254, -- EP2 Penumbral Surge #4
    [1825] = 254, -- EP2 Penumbral Surge #5
    [1826] = 254, -- EP2 Penumbral Surge #6
    [1827] = 254, -- EP1 Scarlet Realm #1
    [1828] = 254, -- EP1 Scarlet Realm #2
    [1829] = 254, -- EP1 Scarlet Realm #3
    [1830] = 254, -- EP1 Scarlet Realm #4
    [1850] = 248, -- EP1 Endless: Episode 1
    [1851] = 248, -- EP2 Endless: Episode 2
    [1865] = 50, -- EP1 Silent Afterimage #1
    [1866] = 50, -- EP1 Silent Afterimage #2
    [1867] = 50, -- EP1 Silent Afterimage #3
    [1868] = 50, -- EP1 Silent Afterimage #4
    [1869] = 50, -- EP1 Chronocide Trial #1
    [1870] = 50, -- EP1 Chronocide Trial #2
    [1871] = 50, -- EP1 Chronocide Trial #3
    [1872] = 50, -- EP1 Chronocide Trial #4
    [1873] = 50, -- EP1 Coetaneous Resolve
    [1960] = 254, -- EP1 Subterranean Patrol #1
    [11002] = 155, -- EP4 Sacred Groundz
}
