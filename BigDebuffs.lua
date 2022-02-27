
-- BigDebuffs by Jordon 
-- Backported and general improvements by Konjunktur
-- Spell list and minor improvements by Apparent

BigDebuffs = LibStub("AceAddon-3.0"):NewAddon("BigDebuffs", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- Defaults
local defaults = {
	profile = {
		unitFrames = {
			enabled = true,
			cooldownCount = true,
			player = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			focus = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			target = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			pet = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			party = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			arena = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
			},
			cc = true,
			interrupts = true,
			immunities = true,
			immunities_spells = true,
			buffs_defensive = true,
			buffs_offensive = true,
			buffs_other = true,
			roots = true,
		},
		priority = {
			immunities = 90,
			immunities_spells = 80,
			cc = 70,
			interrupts = 60,
			buffs_defensive = 50,
			buffs_offensive = 40,
			buffs_other = 30,
			roots = 20,
		},
		spells = {},
	}
}

-- Show one of these when a big debuff is displayed
BigDebuffs.WarningDebuffs = {
	88611, -- Smoke Bomb
	81261, -- Solar Beam
	30108,	--[=[ Unstable Affliction
	233490, -- Unstable Affliction
	233496, -- Unstable Affliction
	233497, -- Unstable Affliction
	233498, -- Unstable Affliction
	233499, -- Unstable Affliction]=]
	34914, -- Vampiric Touch
}

BigDebuffs.Spells = {

	-- Interrupts

	[93985] = { type = "interrupts", duration = 4 }, -- Skull Bash
	-- [80964] = { type = "interrupts", duration = 4 }, -- Skull Bash (Bear Form)
	-- [80965] = { type = "interrupts", duration = 4 }, -- Skull Bash (Cat Form)
	-- [106839] = { type = "interrupts", duration = 4 }, -- Skull Bash (Feral)
	[102060] = { type = "interrupts", duration = 4 },-- Disrupting Shout
	[26679] = { type = "interrupts", duration = 6 }, -- Deadly Throw
	[24259] = { type = "interrupts", duration = 6 }, -- Spell Lock (Grimoire of Sacrifice)
	[115782] = { type = "interrupts", duration = 6 },-- Optical Blast (Observer)
	[97547]	= { type = "interrupts", duration = 5 }, -- Solar Beam
	[50479] = { type = "interrupts", duration = 2 }, -- Nether Shock (pet)
	[50318] = { type = "interrupts", duration = 4 }, -- Serenity Dust (pet)
	[26090] = { type = "interrupts", duration = 2 }, -- Pummel (pet)
	[34490] = { type = "interrupts", duration = 3 }, -- Silencing Shot (Hunter)
    [113288] = { type = "interrupts", duration = 4 }, -- Solar Beam (shaman)

	[1766] = { type = "interrupts", duration = 5 }, -- Kick (Rogue)
	[2139] = { type = "interrupts", duration = 6 }, -- Counterspell (Mage)
	[6552] = { type = "interrupts", duration = 4 }, -- Pummel (Warrior)
	[19647] = { type = "interrupts", duration = 6 }, -- Spell Lock (Warlock)
	[47528] = { type = "interrupts", duration = 3 }, -- Mind Freeze (Death Knight)
	[57994] = { type = "interrupts", duration = 3 }, -- Wind Shear (Shaman)
	[91802] = { type = "interrupts", duration = 2 }, -- Shambling Rush (Death Knight pet)
	[96231] = { type = "interrupts", duration = 4 }, -- Rebuke (Paladin)
	[115781] = { type = "interrupts", duration = 6 }, -- Optical Blast (Warlock)
	[116705] = { type = "interrupts", duration = 4 }, -- Spear Hand Strike (Monk)
	-- [116709] = { type = "interrupts", duration = 2 },-- Spear Hand Strike (silence effect)
	[132409] = { type = "interrupts", duration = 6 }, -- Spell Lock (Warlock)
	[147362] = { type = "interrupts", duration = 3 }, -- Counter Shot (Hunter)
	[31935] = { type = "interrupts", duration = 3 }, -- Avengers Shield (Paladin)

	-- Death Knight

	[47476] = { type = "cc" }, -- Strangulate 
	[48707] = { type = "immunities_spells" }, -- Anti-Magic Shell
	[115018] = { type = "immunities" }, -- Desecrated Ground
	[48792] = { type = "buffs_defensive" }, -- Icebound Fortitude
	[49028] = { type = "buffs_offensive" }, -- Dancing Rune Weapon
	[51271] = { type = "buffs_offensive" }, -- Pillar of Frost
	[55233] = { type = "buffs_defensive" }, -- Vampiric Blood
	[77606] = { type = "buffs_other" }, -- Dark Simulacrum
	[91797] = { type = "cc" }, -- Monstrous Blow
	[91800] = { type = "cc" }, -- Gnaw
	[49039]  = { type = "buffs_other" }, -- Lichborne
	[108194] = { type = "cc" }, -- Asphyxiate
	[53534] = { type = "roots" }, -- Chains of Ice
	[91807] = { type = "roots" }, -- Shambling Rush
	[96294] = { type = "roots" }, -- Chains of Ice (Chilblains)
	[81256] = { type = "buffs_offensive" }, -- Dancing Rune Weapon
	[49016] = { type = "buffs_offensive" }, -- Unholy Frenzy
	[49222] = { type = "buffs_defensive" }, -- Bone Shield
	[115001] = { type = "cc" }, -- Remorseless Winter
	[145629] = { type = "buffs_defensive" }, -- Anti-Magic Zone
	[73975] = { type = "buffs_other" }, -- Necrotic Wound
	[51271] = { type = "buffs_other" }, -- Pillar of Frost

	-- Druid

	[99] = { type = "cc" }, -- Disorienting Roar
	[2637] = { type = "cc" }, -- Hibernate
	[113801] = { type = "cc" },	-- Bash (Force of Nature - Feral Treants)
	[16689] = { type = "buffs_defensive" }, -- Nature's Grasp
		[19975] = { type = "roots" }, -- Entangling Roots (Nature's Grasp)
	[339] = { type = "roots" }, -- Entangling Roots
		[113770] = { type = "roots" }, -- Entangling Roots (trents)
		[102359] = { type = "roots" }, -- Mass Entanglement
	[1850] = { type = "buffs_other" }, -- Dash
	[5211] = { type = "cc" }, -- Mighty Bash
	[5217] = { type = "buffs_offensive" }, -- Tiger's Fury
	[22812] = { type = "buffs_defensive" }, -- Barkskin
	[22842] = { type = "buffs_defensive" }, -- Frenzied Regeneration
	[29166] = { type = "buffs_offensive" }, -- Innervate
	[33891] = { type = "buffs_offensive" }, -- Incarnation: Tree of Life
	[45334] = { type = "roots" }, -- Wild Charge
	[61336] = { type = "buffs_defensive" }, -- Survival Instincts
	[81261] = { type = "cc" }, -- Solar Beam
	[102342] = { type = "buffs_defensive" }, -- Ironbark
	[102543] = { type = "buffs_offensive" }, -- Incarnation: King of the Jungle
	[102558] = { type = "buffs_offensive" }, -- Incarnation: Guardian of Ursoc
	[102560] = { type = "buffs_offensive" }, -- Incarnation: Chosen of Elune
	[106951] = { type = "buffs_offensive" }, -- Berserk
	[106922] = { type = "buffs_defensive" }, -- Might of Ursoc
	[132402] = { type = "buffs_defensive" }, -- Savage Defense
	[108291] = { type = "buffs_defensive" }, -- Heart of the Wild
	[108292] = { type = "buffs_defensive" }, -- Heart of the Wild
	[108293] = { type = "buffs_defensive" }, -- Heart of the Wild
	[108294] = { type = "buffs_defensive" }, -- Heart of the Wild
	[132158] = { type = "buffs_defensive" }, -- Nature's Swiftness

	[113072] = { type = "buffs_defensive" }, -- Symbiosis: Might of Ursoc
	[113306] = { type = "buffs_defensive" }, -- Symbiosis: Survival Instincts
	[113075] = { type = "buffs_defensive" }, -- Symbiosis: Barkskin
	[113278] = { type = "buffs_defensive" }, -- Symbiosis: Tranquillity
	[113613] = { type = "buffs_defensive" }, -- Symbiosis: Growl
	[122286] = { type = "buffs_defensive" }, -- Symbiosis: Savage Defense
	[127361] = { type = "cc" }, -- Symbiosis: Bear Hug
	[113506] = { type = "cc" }, -- Symbiosis: Cyclone
	[113275] = { type = "roots" }, -- Symbiosis: Entangling roots

	[110570] = { type = "immunities_spells" }, -- Symbiosis: Anti-Magic shell
	[122285] = { type = "buffs_defensive" }, -- Symbiosis: Bone Shield
	[110575] = { type = "buffs_defensive" }, -- Symbiosis: Icebound Fortitude
	[110597] = { type = "buffs_defensive" }, -- Symbiosis: Feign Death
	[126456] = { type = "buffs_defensive" }, -- Symbiosis: Fortifying Brew
	[110717] = { type = "buffs_defensive" }, -- Symbiosis: Fear Ward
	[110791] = { type = "buffs_defensive" }, -- Symbiosis: Evasion
	[122291] = { type = "buffs_defensive" }, -- Symbiosis: Unending Resolve
	[122292] = { type = "buffs_defensive" }, -- Symbiosis: Intervene
	[110617] = { type = "immunities" }, -- Symbiosis: Deterrence
	[110693] = { type = "roots" }, -- Symbiosis: Frost Nova
	[110806] = { type = "buffs_other" }, -- Symbiosis: Spiritwalker's Grace
	[126458] = { type = "cc" }, -- Symbiosis: Grapple Weapon
	[110698] = { type = "cc" }, -- Symbiosis: Hammer of Justice
	[113004] = { type = "cc" }, -- Symbiosis: Intimidating Roar
	[113056] = { type = "cc" }, -- Intimidating Roar [Cowering in fear] (Warrior)
	[110696] = { type = "immunities" }, -- Symbiosis: Ice Block
	[110715] = { type = "immunities" }, -- Symbiosis: Dispersion
	[110788] = { type = "immunities_spells" }, -- Symbiosis: Cloak of Shadows
	[113002] = { type = "immunities_spells" }, -- Symbiosis: Spell Reflection
	[110700] = { type = "immunities" }, -- Symbiosis: Divine Shield

	[102355] = { type = "cc" }, -- Faerie Swarm (Slow/Disarm)
	[33786] = { type = "cc" }, -- Cyclone
	[22570] = { type = "cc" }, -- Maim
	[9005] = { type = "cc" }, -- Pounce
	[102546] = { type = "cc" },	-- Pounce (Incarnation)
	[102795] = { type = "cc" }, -- Bear Hug
	[114238] = { type = "cc" }, -- Fae Silence (Glyph of Fae Silence)

	-- Hunter

	[136] = { type = "buffs_defensive" }, -- Mend Pet
	[1513] = { type = "cc" }, -- Scare Beast
	[3045] = { type = "buffs_offensive" }, -- Rapid Fire
	[3355] = { type = "cc" }, -- Freezing Trap
	[5384] = { type = "buffs_defensive" }, -- Feign Death
	[19386] = { type = "cc" }, -- Wyvern Sting
	[19503] = { type = "cc" }, -- Scatter Shot
	[19185] = { type = "roots" }, -- Entrapment
	[64803] = { type = "roots" }, -- Entrapment
	[128405] = { type = "roots" }, -- Narrow Escape
	[19574] = { type = "buffs_offensive" }, -- Bestial Wrath
	[51755] = { type = "buffs_defensive" }, -- Camouflage
	[53480] = { type = "buffs_defensive" }, -- Roar of Sacrifice (Hunter Pet Skill)
	[54216] = { type = "buffs_defensive" }, --  Master's Call
	[62305] = { type = "buffs_defensive" }, --  Master's Call
	[117526] = { type = "cc" }, -- Binding Shot Stun
	[131894] = { type = "buffs_offensive" }, -- A Murder of Crows
	[148467] = { type = "immunities" }, -- Deterrence
	[19263] = { type = "immunities" }, -- Deterrence
	-- Pets	
	[19577] = { type = "cc" }, -- Intimidation
		[24394] = { type = "cc", parent = 19577 }, -- Intimidation
	[90337] = { type = "cc" }, -- Bad Manner (Monkey)
	[126246] = { type = "cc" },	-- Lullaby (Crane)
	[126355] = { type = "cc" },	-- Paralyzing Quill (Porcupine)
	[126423] = { type = "cc" }, -- Petrifying Gaze (Basilisk)
	[50519] = { type = "cc" }, -- Sonic Blast (Bat)
	[56626] = { type = "cc" }, -- Sting (Wasp)
	[96201] = { type = "cc" }, -- Web Wrap (Shale Spider)
	[50541] = { type = "cc" }, -- Clench (Scorpid)
	[91644] = { type = "cc" }, -- Snatch (Bird of Prey)
	[90327] = { type = "roots" }, -- Lock Jaw (Dog)
	[50245] = { type = "roots" }, -- Pin (Crab)
	[54706] = { type = "roots" }, -- Venom Web Spray (Silithid)
	[4167] = { type = "roots" }, -- Web (Spider)

	-- Mage

	[66] = { type = "buffs_offensive" }, -- Invisibility
		[110959] = { type = "buffs_offensive", parent = 66 }, -- Greater Invisibility
		[110960] = { type = "buffs_offensive", parent = 66 }, -- Greater Invisibility
		[113862] = { type = "buffs_defensive", parent = 66 }, -- Greater Invisibility -90%
	[118] = { type = "cc" }, -- Polymorph
		[28271] = { type = "cc", parent = 118 }, -- Polymorph Turtle
		[28272] = { type = "cc", parent = 118 }, -- Polymorph Pig
		[61025] = { type = "cc", parent = 118 }, -- Polymorph Serpent
		[61305] = { type = "cc", parent = 118 }, -- Polymorph Black Cat
		[61721] = { type = "cc", parent = 118 }, -- Polymorph Rabbit
		[61780] = { type = "cc", parent = 118 }, -- Polymorph Turkey
		[126819] = { type = "cc", parent = 118 }, -- Polymorph Porcupine
	[122] = { type = "roots" }, -- Frost Nova
		[33395] = { type = "roots", parent = 122 }, -- Freeze
		[111340] = { type = "roots", parent = 122 }, -- Ice Ward
	[11426] = { type = "buffs_defensive" }, -- Ice Barrier
	[12042] = { type = "buffs_offensive" }, -- Arcane Power
	[12043] = { type = "buffs_offensive" }, -- Presence of Mind
	[12051] = { type = "buffs_offensive" }, -- Evocation
	[12472] = { type = "buffs_offensive" }, -- Icy Veins
        [131078] = { type = "buffs_offensive", paren = 12472 }, -- Icy Veins glyphed
	[44572] = { type = "cc" }, -- Deep Freeze
	[31661] = { type = "cc" }, -- Dragon's Breath
	[102051] = { type = "cc" }, -- Frostjaw
	[55021] = { type = "cc" }, -- Silenced - Improved Counterspell
	[110909] = { type = "buffs_offensive", priority = true }, -- Alter Time
	[45438] = { type = "immunities" }, -- Ice Block
		[41425] = { type = "buffs_other" }, -- Hypothermia
		[115760] = { type = "immunities_spells", parent = 45438 }, -- Glyph of the Ice Block
	[80353] = { type = "buffs_offensive" }, -- Time Warp
	[82691] = { type = "cc" }, -- Ring of Frost
	[108839] = { type = "buffs_offensive" }, -- Ice Floes
	[118271] = { type = "buffs_offensive" }, -- Combustion stun
	[115610] = { type = "buffs_defensive" }, -- Temporal Shield

	-- Monk

	[115078] = { type = "cc" }, -- Paralysis
	[120954] = { type = "buffs_defensive" }, -- Fortifying Brew
	[116706] = { type = "roots" }, -- Disable
	[123407] = { type = "roots" }, -- Spinning Fire Blossom
	[116849] = { type = "buffs_defensive" }, -- Life Cocoon
	[119381] = { type = "cc" }, -- Leg Sweep
	[122278] = { type = "buffs_defensive" }, -- Dampen Harm
	[122470] = { type = "buffs_defensive" }, -- Touch of Karma
	[122783] = { type = "buffs_defensive" }, -- Diffuse Magic
	[115176] = { type = "buffs_defensive" }, -- Zen Meditation
	[115295] = { type = "buffs_defensive" }, -- Guard
	[115308] = { type = "buffs_defensive" }, -- Elusive Brew
	[137562] = { type = "buffs_defensive" }, -- Nimble Brew
	[126451] = { type = "cc" }, -- Clash
	[119392] = { type = "cc" }, -- Charging Ox Wave
	[120086] = { type = "cc" }, -- Fists of Fury
	[123393] = { type = "cc" }, -- Breath of Fire (Glyph of Breath of Fire)
	[117368] = { type = "cc" }, -- Grapple Weapon
	[140023] = { type = "buffs_defensive" },	-- Ring of Peace
	[137461] = { type = "cc" },	-- Disarmed (Ring of Peace)
	[137460] = { type = "cc" }, -- Silenced (Ring of Peace)
	[131523] = { type = "immunities_spells" }, -- Zen Meditation

	-- Paladin

	[498] = { type = "buffs_defensive" }, -- Divine Protection
	[642] = { type = "immunities" }, -- Divine Shield
	[853] = { type = "cc" }, -- Hammer of Justice
		[105593] = { type = "cc", parent = 853 }, -- Fist of Justice
	[1022] = { type = "buffs_defensive" }, -- Hand of Protection
	[498] = { type = "buffs_defensive" }, -- Divine Protection
	[1044] = { type = "buffs_defensive" }, -- Hand of Freedom
	[6940] = { type = "buffs_defensive" }, -- Hand of Sacrifice
	[20066] = { type = "cc" }, -- Repentance
	[31821] = { type = "buffs_defensive" }, -- Devotion Aura
	[31850] = { type = "buffs_defensive" }, -- Ardent Defender
	[31884] = { type = "buffs_offensive" }, -- Avenging Wrath
	[31842] = { type = "buffs_offensive" }, -- Divine Favor
	[31935] = { type = "cc" }, -- Avenger's Shield
	[10326] = { type = "cc" }, -- Turn Evil
	[145067]= { type = "cc" }, -- Turn Evil (Evil is a Point of View)
	[86659] = { type = "buffs_defensive" }, -- Guardian of Ancient Kings
	[105809] = { type = "buffs_offensive" }, -- Holy Avenger
	[115750] = { type = "cc" }, -- Blinding Light
		[105421] = { type = "cc", parent = 115750 }, -- Blinding Light
		[115752] = { type = "cc", parent = 115750 }, -- Blinding Light (Glyph of Blinding Light)
	[119072] = { type = "cc" },	-- Holy Wrath

	-- Priest

	[586] = { type = "buffs_defensive" }, -- Fade
	[605] = { type = "cc", priority = true }, -- Dominate Mind
	[6346] = { type = "buffs_defensive" }, -- Fear Ward
	[8122] = { type = "cc" }, -- Psychic Scream
	[64044] = { type = "cc" }, -- Psychic Horror
	[64058] = { type = "cc" }, -- Psychic Horror Disarm
	[113792]= { type = "cc" }, -- Psychic Terror (Psyfiend)
	[9484] = { type = "cc" }, -- Shackle Undead
	[10060] = { type = "buffs_offensive" }, -- Power Infusion
	[15487] = { type = "cc" }, -- Silence
	[27827] = { type = "buffs_defensive" }, -- Spirit of Redemption
	[33206] = { type = "buffs_defensive" }, -- Pain Suppression
	[47585] = { type = "buffs_defensive" }, -- Dispersion
	[47788] = { type = "buffs_defensive" }, -- Guardian Spirit
	[64843] = { type = "buffs_defensive" }, -- Divine Hymn
	[64901] = { type = "buffs_defensive" }, -- Hymn of Hope
	[81700] = { type = "buffs_defensive" }, -- Archangel
	[81782] = { type = "buffs_defensive" }, -- Power Word: Barrier
	[64904] = { type = "buffs_defensive" }, -- Hymn of Hope cast?
	[87204] = { type = "cc" }, -- Sin and Punishment
	[88625] = { type = "cc" }, -- Holy Word: Chastise
	[96267] = { type = "buffs_defensive" }, -- Inner Focus
	[114239] = { type = "immunities_spells" }, -- Phantasm
	[87194] = { type = "roots" }, -- Glyph of Mind Blast
	[114404] = { type = "roots" }, -- Void Tendril's Grasp

	-- Rogue

	[408] = { type = "cc" }, -- Kidney Shot
	[1330] = { type = "cc" }, -- Garrote - Silence
	[1776] = { type = "cc" }, -- Gouge
	[1833] = { type = "cc" }, -- Cheap Shot
	[1966] = { type = "buffs_defensive" }, -- Feint
	[2094] = { type = "cc" }, -- Blind
	[5277] = { type = "buffs_defensive" }, -- Evasion
	[6770] = { type = "cc" }, -- Sap
	[113953] = { type = "cc" }, -- Paralysis (Paralytic Poison)
	[13750] = { type = "buffs_offensive" }, -- Adrenaline Rush
	[31224] = { type = "immunities_spells" }, -- Cloak of Shadows
	[51690] = { type = "buffs_offensive" }, -- Killing Spree
	[51713] = { type = "buffs_other" }, -- Shadow Dance
	[51722] = { type = "cc" }, -- Dismantle
	[115197] = { type = "roots" }, -- Partial Paralysis
	[57933] = { type = "buffs_offensive" }, -- Tricks +15% dmg
	[74001] = { type = "buffs_defensive" }, -- Combat Readiness
	[79140] = { type = "buffs_offensive" }, -- Vendetta
	[88611] = { type = "cc" }, -- Smoke Bomb
	[121471] = { type = "buffs_offensive" }, -- Shadow Blades
	[114018] = { type = "buffs_defensive" }, -- Shroud of Concealment
	[45182] = { type = "buffs_defensive" },	-- Cheating Death

	-- Shaman

	[2825] = { type = "buffs_offensive" }, -- Bloodlust
		[32182] = { type = "buffs_offensive", parent = 2825 }, -- Heroism
	[51514] = { type = "cc" }, -- Hex
	[79206] = { type = "buffs_other" }, -- Spiritwalker's Grace 60 * OTHER
	[30823] = { type = "buffs_defensive" }, -- Shamanistic Rage
	[108281] = { type = "buffs_defensive" }, -- Ancestral Guidance
	[16166] = { type = "buffs_offensive" }, -- Elemental Mastery
	[120676] = { type = "buffs_offensive" }, -- Stormlash Totem Effect
	[64695] = { type = "roots" }, -- Earthgrab Totem
	[63685] = { type = "roots" }, -- Freeze (Frozen Power)
	[8178] = { type = "immunities_spells" }, -- Grounding Totem Effect
	[114896] = { type = "buffs_defensive" }, -- Windwalk totem Effect
	[76780] = { type = "cc" }, -- Bind Elemental
	[77505] = { type = "cc" }, -- Earthquake (Stun)
	[98007] = { type = "buffs_defensive" }, -- Spirit Link Totem
	[98008] = { type = "buffs_defensive" }, -- Spirit Link Totem
	[108271] = { type = "buffs_defensive" }, -- Astral Shift
	[114050] = { type = "buffs_defensive" }, -- Ascendance (Elemental)
		[114051] = { type = "buffs_offensive", parent = 114050 }, -- Ascendance (Enhancement)
		[114052] = { type = "buffs_defensive", parent = 114050 }, -- Ascendance (Restoration)
	[118345] = { type = "cc" }, -- Pulverize
	[118905] = { type = "cc" }, -- Static Charge
	[113287] = { type = "cc" }, -- Solar Beam (Symbiosis)
    [114893] = { type = "buffs_defensive" }, -- Stone Bulwark Totem
    [16188] = { type = "buffs_defensive" }, -- Ancestral Swiftness

	-- Warlock

	[710] = { type = "cc" }, -- Banish
	[5484] = { type = "cc" }, -- Howl of Terror
	[6358] = { type = "cc" }, -- Seduction
		[115268] = { type = "cc", parent = 6358 }, -- Mesmerize
		[132412] = { type = "cc", parent = 6358 }, -- Seduction (Grimoire of Sacrifice)
	[6789] = { type = "cc" }, -- Mortal Coil
    [111397] = { type = "buffs_defensive" }, -- Blood Horror (buff)
    [137143] = { type = "cc" }, -- Blood Horror (cc)
	[20707] = { type = "buffs_defensive" }, -- Soulstone
	[22703] = { type = "cc" }, -- Infernal Awakening
	[30283] = { type = "cc" }, -- Shadowfury
	[89751] = { type = "buffs_offensive" }, -- Felstorm
		[115831] = { type = "buffs_offensive", parent = 89751 }, -- Wrathstorm
	[89766] = { type = "cc" }, -- Axe Toss
	[118093] = { type = "cc" }, -- Disarm (Void)
	[54786] = { type = "cc" }, -- Demonic Leap (Metamorphosis)
	[104773] = { type = "buffs_defensive" }, -- Unending Resolve
	[110913] = { type = "buffs_defensive" }, -- Dark Bargain
	[108416] = { type = "buffs_defensive" }, -- Sacrificial Pact
	[5782] = { type = "cc" }, -- Fear
		[30002] = { type = "cc", parent = 5782 }, -- Fear cast?
	[104045] = { type = "cc" },	-- Sleep (Metamorphosis)
	[118699] = { type = "cc" }, -- Fear
		[130616] = { type = "cc", parent = 118699 }, -- Fear (Glyph of Fear)
	[31117] = { type = "cc" }, -- Unstable Affliction (Silence)

	-- Warrior

	[871] = { type = "buffs_defensive" }, -- Shield Wall
	[1719] = { type = "buffs_offensive" }, -- Recklessness
	[12292] = { type = "buffs_offensive" }, -- Bloodbath
	[114206] = { type = "buffs_offensive" }, -- Skull Banner
	[118895] = { type = "cc" }, -- Dragon Roar
	[5246] = { type = "cc" }, -- Intimidating Shout
	[20511] = { type = "cc" }, -- Intimidating Shout (targeted)
	[7922] = { type = "cc" }, -- Charge Stun
	[12975] = { type = "buffs_defensive" }, -- Last Stand
	[18499] = { type = "buffs_other" }, -- Berserker Rage
	[23920] = { type = "immunities_spells" }, -- Spell Reflection
		[114028] = { type = "immunities_spells", parent = 23920 }, -- Mass Spell Reflection
	[46968] = { type = "cc" }, -- Shockwave
	[132168] = { type = "cc" },	-- Shockwave
	[97462] = { type = "buffs_defensive" }, -- Rallying Cry
	[97463] = { type = "buffs_defensive" }, -- Rallying Cry
	[105771] = { type = "roots" }, -- Charge (Warrior)
	[107566] = { type = "roots" }, -- Staggering Shout
	[107574] = { type = "buffs_offensive" }, -- Avatar
	[118038] = { type = "buffs_defensive" }, -- Die by the Sword
	[107570] = { type = "cc" }, -- Storm Bolt
	[132169] = { type = "cc" }, -- Storm Bolt
	[55694]	= { type = "buffs_defensive" }, -- Enraged Regeneration
	[114029] = { type = "buffs_defensive" }, -- Safeguard
	[114030] = { type = "buffs_defensive" }, -- Vigilance
	[34784] = { type = "buffs_defensive" }, -- Intervene
	[147833] = { type = "buffs_defensive" }, -- Intervene
	[46924] = { type = "immunities" }, -- Bladestorm
	[676] = { type = "cc" }, -- Disarm
	[18498] = { type = "cc" }, -- Silenced - Gag Order (PvE only)

	-- Other

	[30217] = { type = "cc" }, -- Adamantite Grenade
	[89637] = { type = "cc" }, -- Big Daddy
	[30461] = { type = "cc" }, -- Bigger One
	[67769] = { type = "cc" }, -- Cobalt Frag Bomb
	[30216] = { type = "cc" }, -- Fel Iron Bomb
	[19784] = { type = "cc" }, -- Dark Iron Bomb
	[13327] = { type = "cc" }, -- Reckless Charge
	[19769] = { type = "cc" }, -- Thorium Grenade
	[19821] = { type = "cc" }, -- Arcane Bomb
	[12562] = { type = "cc" }, -- The Big One
	[39965] = { type = "roots" }, -- Frost Grenade
	[55536] = { type = "roots" }, -- Frostweave Net
	[75148] = { type = "roots" }, -- Embersilk Net
	[13099] = { type = "roots" }, -- Net-o-Matic
	[20549] = { type = "cc" }, -- War Stomp
	[107079] = { type = "cc" }, -- Quaking Palm
	[129597] = { type = "cc" }, -- Arcane Torrent
		[25046] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[28730] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[50613] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[69179] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[80483] = { type = "cc", parent = 129597 }, -- Arcane Torrent
	[104270] = { type = "buffs_other" }, -- Drink
		[104235] = { type = "buffs_other", parent = 104270 }, -- eat
		[118358] = { type = "buffs_other", parent = 104270 }, -- drink
		[104269] = { type = "buffs_other", parent = 104270 }, -- drink
		[149024] = { type = "buffs_other", parent = 104270 }, -- drink
		[148996] = { type = "buffs_other", parent = 104270 }, -- drink
		[149000] = { type = "buffs_other", parent = 104270 }, -- drink
		[148997] = { type = "buffs_other", parent = 104270 }, -- drink

	-- Special
	--[6788] = { type = "special", nounitFrames = true, noraidFrames = true }, -- Weakened Soul
	[11444] = { type = "cc" }, -- Shackle Undead
	[13704] = { type = "cc" }, -- Psychic Scream
	
}

local specDispel = {
	[65] = { -- Holy Paladin
		Magic = true,
		Poison = true,
		Disease = true,
	},
	[66] = { -- Protection Paladin
		Poison = true,
		Disease = true,
	},
	[70] = { -- Retribution Paladin
		Poison = true,
		Disease = true,
	},
	[102] = { -- Balance Druid
		Curse = true,
		Poison = true,
	},
	[103] = { -- Feral Druid
		Curse = true,
		Poison = true,
	},
	[104] = { -- Guardian Druid
		Curse = true,
		Poison = true,
	},
	[105] = { -- Restoration Druid
		Magic = true,
		Curse = true,
		Poison = true,
	},
	[256] = { -- Discipline Priest
		Magic = true,
		Disease = true,
	},
	[257] = { -- Holy Priest
		Magic = true,
		Disease = true,
	},
	[258] = { -- Shadow Priest
		Magic = true,
		Disease = true,
	},
	[262] = { -- Elemental Shaman
		Curse = true,
	},
	[263] = { -- Enhancement Shaman
		Curse = true,
	},
	[264] = { -- Restoration Shaman
		Magic = true,
		Curse = true,
	},
	[268] = { -- Brewmaster Monk
		Poison = true,
		Disease = true,
	},
	[269] = { -- Windwalker Monk
		Poison = true,
		Disease = true,
	},
	[270] = { -- Mistweaver Monk
		Magic = true,
		Poison = true,
		Disease = true,
	},
}

-- Make sure we always see these debuffs, but don't make them bigger
BigDebuffs.PriorityDebuffs = {
	34914, -- Vampiric Touch
	102355, -- Faerie Swarm
	117405, -- Binding Shot
	122470, -- Touch of Karma
	770, -- Faerie Fire
	130736, -- Soul Reaper (Unholy)
}

local units = {
	"player",
	"pet",
	"target",
	"focus",
	"party1",
	"party2",
	"party3",
	"party4",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
}

for i = 1, 40 do
	table.insert(unitsWithRaid, "raid" .. i)
end


local UnitDebuff, UnitBuff = UnitDebuff, UnitBuff

local GetAnchor = {
	ShadowedUnitFrames = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame.portrait and frame.portrait:IsShown() then
			return frame.portrait, frame
		else
			return frame, frame, true
		end
	end,
	ZPerl = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame:IsShown() then
			return frame, frame
		else
			frame = frame:GetParent()
			return frame, frame, true
		end
	end,
}

local anchors = {
	["ElvUI"] = {
		noPortrait = true,
		units = {
			player = "ElvUF_Player",
			pet = "ElvUF_Pet",
			target = "ElvUF_Target",
			focus = "ElvUF_Focus",
			party1 = "ElvUF_PartyGroup1UnitButton1",
			party2 = "ElvUF_PartyGroup1UnitButton2",
			party3 = "ElvUF_PartyGroup1UnitButton3",
			party4 = "ElvUF_PartyGroup1UnitButton4",
		},
	},
	["bUnitFrames"] = {
		noPortrait = true,
		alignLeft = true,
		units = {
			player = "bplayerUnitFrame",
			pet = "bpetUnitFrame",
			target = "btargetUnitFrame",
			focus = "bfocusUnitFrame",
			arena1 = "barena1UnitFrame",
			arena2 = "barena2UnitFrame",
			arena3 = "barena3UnitFrame",
			arena4 = "barena4UnitFrame",
		},
	},
	["Shadowed Unit Frames"] = {
		func = GetAnchor.ShadowedUnitFrames,
		units = {
			player = "SUFUnitplayer",
			pet = "SUFUnitpet",
			target = "SUFUnittarget",
			focus = "SUFUnitfocus",
			party1 = "SUFHeaderpartyUnitButton1",
			party2 = "SUFHeaderpartyUnitButton2",
			party3 = "SUFHeaderpartyUnitButton3",
			party4 = "SUFHeaderpartyUnitButton4",
		},
	},
	["ZPerl"] = {
		func = GetAnchor.ZPerl,
		units = {
			player = "XPerl_PlayerportraitFrame",
			pet = "XPerl_Player_PetportraitFrame",
			target = "XPerl_TargetportraitFrame",
			focus = "XPerl_FocusportraitFrame",
			party1 = "XPerl_party1portraitFrame",
			party2 = "XPerl_party2portraitFrame",
			party3 = "XPerl_party3portraitFrame",
			party4 = "XPerl_party4portraitFrame",
		},
	},
	["Blizzard"] = {
		units = {
			player = "PlayerPortrait",
			pet = "PetPortrait",
			target = "TargetFramePortrait",
			focus = "FocusFramePortrait",
			party1 = "PartyMemberFrame1Portrait",
			party2 = "PartyMemberFrame2Portrait",
			party3 = "PartyMemberFrame3Portrait",
			party4 = "PartyMemberFrame4Portrait",
			arena1 = "ArenaEnemyFrame1ClassPortrait",
			arena2 = "ArenaEnemyFrame2ClassPortrait",
			arena3 = "ArenaEnemyFrame3ClassPortrait",
			arena4 = "ArenaEnemyFrame4ClassPortrait",
			arena5 = "ArenaEnemyFrame5ClassPortrait",
		},
	},
}

function BigDebuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BigDebuffsDB", defaults, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.frames = {}
	self.UnitFrames = {}
	self:SetupOptions()
end

local function HideBigDebuffs(frame)
	if not frame.BigDebuffs then return end
	for i = 1, #frame.BigDebuffs do
		frame.BigDebuffs[i]:Hide()
	end
end

function BigDebuffs:Refresh()
	for frame, _ in pairs(self.frames) do
		if frame:IsVisible() then CompactUnitFrame_UpdateDebuffs(frame) end
		if frame and frame.BigDebuffs then self:AddBigDebuffs(frame) end
	end
	for unit, frame in pairs(self.UnitFrames) do
		frame:Hide()
		frame.current = nil
		frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
		self:AttachUnitFrame(unit)
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:AttachUnitFrame(unit)
	if InCombatLockdown() then 
		unitsToUpdate[unit] = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return 
	end

	local frame = self.UnitFrames[unit]
	local frameName = "BigDebuffs" .. unit .. "UnitFrame"

	if not frame then
		frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
		frame.icon = _G[frameName.."Icon"]
		frame.cooldownContainer = CreateFrame("Button", frameName.."CooldownContainer", frame)
		self.UnitFrames[unit] = frame
		frame.icon:SetDrawLayer("BORDER")
		frame.cooldownContainer:SetPoint("CENTER")
		frame.cooldown:SetParent(frame.cooldownContainer)
		frame.cooldown:SetAllPoints()
		frame.cooldown:SetAlpha(0.9)
		
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame.unit = unit
	end

	frame:EnableMouse(self.test)

	_G[frameName.."Name"]:SetText(self.test and not frame.anchor and unit)

	frame.anchor = nil
	frame.blizzard = nil

	local config = self.db.profile.unitFrames[unit:gsub("%d", "")]

	if config.anchor == "auto" then
		-- Find a frame to attach to
		for k,v in pairs(anchors) do
			local anchor, parent, noPortrait
			if v.units[unit] then
				if v.func then
					anchor, parent, noPortrait = v.func(v.units[unit])
				else
					anchor = _G[v.units[unit]]
				end

				if anchor then
					frame.anchor, frame.parent, frame.noPortrait = anchor, parent, noPortrait
					if v.noPortrait then frame.noPortrait = true end
					frame.alignLeft = v.alignLeft
					frame.blizzard = k == "Blizzard"
					if not frame.blizzard then break end
				end
			end		
		end
	end

	if frame.anchor then
		if frame.blizzard then
			-- Blizzard Frame
			frame:SetParent(frame.anchor:GetParent())
			frame:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.cooldownContainer:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel()-1)
			frame.cooldownContainer:SetSize(frame.anchor:GetWidth() - config.cdMod, frame.anchor:GetHeight() - config.cdMod)
			frame.anchor:SetDrawLayer("BACKGROUND")
		else
			frame:SetParent(frame.parent and frame.parent or frame.anchor)
			frame:SetFrameLevel(99)
			frame.cooldownContainer:SetSize(frame.anchor:GetWidth(), frame.anchor:GetHeight())
		end

		frame:ClearAllPoints()

		if frame.noPortrait then
			-- No portrait, so attach to the side
			if frame.alignLeft then
				frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
			else
				frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
			end
			local height = frame.anchor:GetHeight()
			frame:SetSize(height, height)
		else
			frame:SetAllPoints(frame.anchor)
		end
	else
		-- Manual
		frame:SetParent(UIParent)
		frame:ClearAllPoints()
		
		frame:SetSize(config.size, config.size)
		frame.cooldownContainer:SetSize(frame:GetWidth(), frame:GetHeight())
		
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel()+1)
		frame.cooldownContainer:SetFrameLevel(frame:GetParent():GetFrameLevel())
		frame.cooldownContainer:SetSize(frame:GetWidth(), frame:GetHeight())

		if not self.db.profile.unitFrames[unit] then self.db.profile.unitFrames[unit] = {} end

		if self.db.profile.unitFrames[unit].position then
			frame:SetPoint(unpack(self.db.profile.unitFrames[unit].position))
		else
			-- No saved position, anchor to the blizzard position
			LoadAddOn("Blizzard_ArenaUI")
			local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
			frame:SetPoint("CENTER", relativeFrame, "CENTER")
		end
		
	end

end

hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
	if frame:IsForbidden() then return end
	local name = frame:GetName()
	if not name or not name:match("^Compact") then return end
	if InCombatLockdown() and not frame.BigDebuffs then
		if not pending[frame] then pending[frame] = true end
	else
		BigDebuffs:AddBigDebuffs(frame)
	end
end)

local pending = {}

function BigDebuffs:PLAYER_REGEN_ENABLED()
	for frame,_ in pairs(pending) do
		BigDebuffs:AddBigDebuffs(frame)
		pending[frame] = nil
	end
end

function BigDebuffs:SaveUnitFramePosition(frame)
	self.db.profile.unitFrames[frame.unit].position = { frame:GetPoint() }
end

function BigDebuffs:Test()
	self.test = not self.test
	self:Refresh()
end

local TestDebuffs = {}

function BigDebuffs:InsertTestDebuff(spellID)
	local texture = select(3, GetSpellInfo(spellID))
	table.insert(TestDebuffs, {spellID, texture})
end

local function UnitDebuffTest(unit, index)
	local debuff = TestDebuffs[index]
	if not debuff then return end
	return GetSpellInfo(debuff[1]), nil, debuff[2], 0, "Magic", 50, GetTime()+50, nil, nil, nil, debuff[1]
end

function BigDebuffs:OnEnable()
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:PLAYER_TALENT_UPDATE()

	-- Prevent OmniCC finish animations
	if OmniCC then
		self:RawHook(OmniCC, "TriggerEffect", function(object, cooldown)
			local name = cooldown:GetName()
			if name and name:find("BigDebuffs") then return end
			self.hooks[OmniCC].TriggerEffect(object, cooldown)
		end, true)
	end

	InsertTestDebuff(8122, "Magic") -- Psychic Scream
	InsertTestDebuff(408, nil) -- Kidney Shot
	InsertTestDebuff(339, "Magic") -- Entangling Roots
	InsertTestDebuff(114404, nil) -- Void Tendrils
	InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
	InsertTestDebuff(772, nil) -- Rend
end

function BigDebuffs:PLAYER_ENTERING_WORLD()
	for i = 1, #units do
		self:AttachUnitFrame(units[i])
	end
	self.stances = {}
end

-- For unit frames
function BigDebuffs:GetAuraPriority(name, id)
	if not self.Spells[id] and not self.Spells[name] then return end
	
	id = self.Spells[id] and id or name
	
	-- Make sure category is enabled
	if not self.db.profile.unitFrames[self.Spells[id].type] then return end

	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].unitFrames and self.db.profile.spells[id].unitFrames == 0 then return end
		if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
	end

	if self.Spells[id].nounitFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].unitFrames) then
		return
	end

	return self.db.profile.priority[self.Spells[id].type] or 0
end

function BigDebuffs:GetUnitFromGUID(guid)
	for _,unit in pairs(units) do
		if UnitGUID(unit) == guid then
			return unit
		end
	end
	return nil
end

function BigDebuffs:UNIT_SPELLCAST_FAILED(_,unit, _, _, spellid)
	local guid = UnitGUID(unit)
	if self.interrupts[guid] == nil then
		self.interrupts[guid] = {}
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, self, guid)
	end
	self.interrupts[guid].failed = GetTime()
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, subEvent, sourceGUID, _, _, destGUID, destName, _, spellid, name = ...

	if subEvent == "SPELL_CAST_SUCCESS" and self.Spells[spellid] then
		if spellid == 2457 or spellid == 2458 or spellid == 71 then
			self:UpdateStance(sourceGUID, spellid)
		end
	end

	if subEvent ~= "SPELL_CAST_SUCCESS" and subEvent ~= "SPELL_INTERRUPT" then
		return
	end
		
	-- UnitChannelingInfo and event orders are not the same in WotLK as later expansions, UnitChannelingInfo will always return
	-- nil @ the time of this event (independent of whether something was kicked or not).
	-- We have to track UNIT_SPELLCAST_FAILED for spell failure of the target at the (approx.) same time as we interrupted
	-- this "could" be wrong if the interrupt misses with a <0.01 sec failure window (which depending on server tickrate might
	-- not even be possible)
	if subEvent == "SPELL_CAST_SUCCESS" and not (self.interrupts[destGUID] and 
			self.interrupts[destGUID].failed and GetTime() - self.interrupts[destGUID].failed < 0.01) then
		return
	end
	
	local spelldata = self.Spells[name] and self.Spells[name] or self.Spells[spellid]
	if spelldata == nil or spelldata.type ~= "interrupts" then return end
	local duration = spelldata.interruptduration
   	if not duration then return end
	
	self:UpdateInterrupt(nil, destGUID, spellid, duration)
end

function BigDebuffs:UpdateStance(guid, spellid)
	if self.stances[guid] == nil then
		self.stances[guid] = {}
	else
		self:CancelTimer(self.stances[guid].timer)
	end
	
	self.stances[guid].stance = spellid
	self.stances[guid].timer = self:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)

	local unit = self:GetUnitFromGUID(guid)
	if unit then
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:ClearStanceGUID(guid)
	local unit = self:GetUnitFromGUID(guid)
	if unit == nil then
		self.stances[guid] = nil
	else
		self.stances[guid].timer = BigDebuffs:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)
	end
end

function BigDebuffs:UpdateInterrupt(unit, guid, spellid, duration)
	local t = GetTime()
	-- new interrupt
	if spellid and duration ~= nil then
		if self.interrupts[guid] == nil then self.interrupts[guid] = {} end
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, self, guid)
		self.interrupts[guid][spellid] = {started = t, duration = duration}
	-- old interrupt expiring
	elseif spellid and duration == nil then
		if self.interrupts[guid] and self.interrupts[guid][spellid] and
				t > self.interrupts[guid][spellid].started + self.interrupts[guid][spellid].duration then
			self.interrupts[guid][spellid] = nil
		end
	end
	
	if unit == nil then
		unit = self:GetUnitFromGUID(guid)
	end
	
	if unit then	
		self:UNIT_AURA(nil, unit)
	end
	-- clears the interrupt after end of duration
	if duration then
		BigDebuffs:ScheduleTimer(self.UpdateInterrupt, duration+0.1, self, unit, guid, spellid)
	end
end

function BigDebuffs:ClearInterruptGUID(guid)
	self.interrupts[guid] = nil
end

function BigDebuffs:GetInterruptFor(unit)
	local guid = UnitGUID(unit)
	interrupts = self.interrupts[guid]
	if interrupts == nil then return end
	
	local name, spellid, icon, duration, endsAt
	
	-- iterate over all interrupt spellids to find the one of highest duration
	for ispellid, intdata in pairs(interrupts) do
		if type(ispellid) == "number" then
			local tmpstartedAt = intdata.started
			local dur = intdata.duration
			local tmpendsAt = tmpstartedAt + dur
			if GetTime() > tmpendsAt then
				self.interrupts[guid][ispellid] = nil
			elseif endsAt == nil or tmpendsAt > endsAt then
				endsAt = tmpendsAt
				duration = dur
				name, _, icon = GetSpellInfo(ispellid)
				spellid = ispellid
			end
		end
	end
	
	if name then
		return name, spellid, icon, duration, endsAt
	end
end

function BigDebuffs:UNIT_AURA(event, unit)
	if not self.db.profile.unitFrames[unit:gsub("%d", "")] or 
			not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled then 
		return 
	end
	--self:AttachUnitFrame(unit)
	
	local frame = self.UnitFrames[unit]
	if not frame then return end
	
	local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff
	
	local now = GetTime()
	local left, priority, duration, expires, icon, isAura, interrupt = 0, 0
	
	for i = 1, 40 do
		-- Check debuffs
		local n,_, ico, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
		
		if id then
			if self.Spells[n] or self.Spells[id] then
				local p = self:GetAuraPriority(n, id)
				if p and (p > priority or (p == prio and expires and e < expires)) then
					left = e - now
					duration = d
					isAura = true
					priority = p
					expires = e
					icon = ico
				end
			end
		else
			break
		end
	end
	
	for i = 1, 40 do
		-- Check buffs
		local n,_, ico, _,_, d, e, _,_,_, id = UnitBuff(unit, i)
		if id then
			if self.Spells[id] then
				local p = self:GetAuraPriority(n, id)
				if p and p >= priority then
					if p and (p > priority or (p == prio and expires and e < expires)) then
						left = e - now
						duration = d
						isAura = true
						priority = p
						expires = e
						icon = ico
					end
				end
			end
		else
			break
		end
	end
	
	local n, id, ico, d, e = self:GetInterruptFor(unit)
	if n then
		local p = self:GetAuraPriority(n, id)
		if p and (p > priority or (p == prio and expires and e < expires)) then
			left = e - now
			duration = d
			isAura = true
			priority = p
			expires = e
			icon = ico
		end
	end

	-- need to always look for a stance (if we only look for it once a player
	-- changes stance we will never get back to it again once other auras fade)
	local guid = UnitGUID(unit)
	if self.stances[guid] then 
		local stanceId = self.stances[guid].stance
		if stanceId and self.Spells[stanceId] then
			n, _, ico = GetSpellInfo(stanceId)
			local p = self:GetAuraPriority(n, stanceId)
			if p and p >= priority then
				left = 0
				duration = 0
				isAura = true
				priority = p
				expires = 0
				icon = ico
			end
		end
	end
	
	if isAura then
		if frame.current ~= icon then
			if frame.blizzard then
				-- Blizzard Frame
				SetPortraitToTexture(frame.icon, icon)
				-- Adapt
				if frame.anchor and Adapt and Adapt.portraits[frame.anchor] then
					Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("BACKGROUND")
				end
			else
				frame.icon:SetTexture(icon)
			end
		end
		
		if duration >= 1 then
			frame.cooldown:SetCooldown(expires - duration, duration)
			frame.cooldownContainer:Show()
		else 
			frame.cooldown:SetCooldown(0, 0)
			frame.cooldownContainer:Hide()
		end

		frame:Show()
		frame.current = icon
	else
		-- Adapt
		if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
			Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
		else
			frame:Hide()
			frame.current = nil
		end
	end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA(nil, "focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function BigDebuffs:UNIT_PET()
	self:UNIT_AURA(nil, "pet")
end

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
	LibStub("AceConfigDialog-3.0"):Open("BigDebuffs")
end
