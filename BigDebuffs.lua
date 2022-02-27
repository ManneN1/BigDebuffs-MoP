local addonName = ...


BigDebuffs = LibStub("AceAddon-3.0"):NewAddon("BigDebuffs", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

-- Defaults
local defaults = {
	profile = {
		raidFrames = {
			maxDebuffs = 1,
			anchor = "INNER",
			enabled = true,
			cooldownCount = true,
			hideBliz = true,
			redirectBliz = false,
			increaseBuffs = false,
			cc = 50,
			dispellable = {
				cc = 60,
				roots = 50,
			},
			interrupts = 55,
			roots = 40,
			warning = 40,
			default = 30,
			special = 30,
			pve = 50,
			warningList = {
				[88611] = true, -- Smoke Bomb
				[81261] = true, -- Solar Beam
				[30108] = true, -- Unstable Affliction
				[34914] = true, -- Vampiric Touch
			},
		},
		unitFrames = {
			enabled = true,
			cooldownCount = true,
			tooltips = true,
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
			immunities = 80,
			immunities_spells = 70,
			cc = 60,
			interrupts = 55,
			buffs_defensive = 50,
			buffs_offensive = 40,
			buffs_other = 30,
			roots = 20,
			special = 19,
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

-- Store interrupt spellId and start time
BigDebuffs.units = {}

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

local unitsWithRaid = {
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
		noPortait = true,
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
		--frame.cooldown:SetHideCountdownNumbers(not self.db.profile.unitFrames.cooldownCount)
		frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
		self:AttachUnitFrame(unit)
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:AttachUnitFrame(unit)
	if InCombatLockdown() then return end

	local frame = self.UnitFrames[unit]
	local frameName = "BigDebuffs" .. unit .. "UnitFrame"

	if not frame then
		frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
		self.UnitFrames[unit] = frame
		frame:SetScript("OnEvent", function() self:UNIT_AURA(unit) end)
		frame.icon:SetDrawLayer("BORDER")
		frame:RegisterUnitEvent("UNIT_AURA", unit)
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
			frame.cooldownContainer:SetSize(frame.anchor:GetWidth() - config.cdMod, frame.anchor:GetHeight() - config.cdMod)
			frame.cooldown:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.anchor:SetDrawLayer("BACKGROUND")
            --frame.cooldown:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
			--frame.cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
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

		if not self.db.profile.unitFrames[unit] then self.db.profile.unitFrames[unit] = {} end

		if self.db.profile.unitFrames[unit].position then
			frame:SetPoint(unpack(self.db.profile.unitFrames[unit].position))
		else
			-- No saved position, anchor to the blizzard position
			LoadAddOn("Blizzard_ArenaUI")
			local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
			frame:SetPoint("CENTER", relativeFrame, "CENTER")
		end
		
		frame:SetSize(config.size, config.size)
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

local function InsertTestDebuff(spellID, dispelType)
	local texture = GetSpellTexture(spellID)
	table.insert(TestDebuffs, { spellID, texture, 0, dispelType })
end

local function UnitDebuffTest(unit, index)
	local debuff = TestDebuffs[index]
	if not debuff then return end
	return "Test", nil, debuff[2], 0, debuff[4], 0, 0, nil, nil, nil, debuff[1]
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
	if OmniCC and type(OmniCC) == 'table' and OmniCC.TriggerEffect then
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

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)

	-- SPELL_INTERRUPT doesn't fire for some channeled spells 
	if event ~= "SPELL_INTERRUPT" and event ~= "SPELL_CAST_SUCCESS" then return end

	local _,srcGUID,_,_,_, destGUID, _,_,_, spellId = ...
	local spell = self.Spells[spellId]

	if not spell or spell.type ~= "interrupts" then return end

	-- Find unit
	for i = 1, #unitsWithRaid do
		local unit = unitsWithRaid[i]
		if destGUID == UnitGUID(unit) and (event ~= "SPELL_CAST_SUCCESS" or select(8, UnitChannelInfo(unit)) == false) then
			local duration = spell.duration
			local _, class = UnitClass(unit)

			--[[
			if class == "PRIEST" or class == "SHAMAN" or class == "WARLOCK" then
				duration = duration * 0.7
			end

			if UnitBuff(unit, "Burning Determination") or UnitBuff(unit, "Calming Waters") or UnitBuff(unit, "Casting Circle") then
				duration = duration * 0.3
			end
]]
			self.units[destGUID] = self.units[destGUID] or {}
			self.units[destGUID].expires = GetTime() + duration
			self.units[destGUID].spellId = spellId

			-- Make sure we clear it after the duration
			--C_Timer.After(duration, function()
			LibStub("AceTimer-3.0"):ScheduleTimer(function() 
				if self.AttachedFrames[unit] then
                    self:ShowBigDebuffs(self.AttachedFrames[unit])
                end

                if not unit:match("^raid") then
                    self:UNIT_AURA(unit)
                end
			end, duration + 0.05) -- adding slight delay for checking expiring timer

			self:UNIT_AURA_ALL_UNITS()			

			return

		end
	end
end

function BigDebuffs:UNIT_AURA_ALL_UNITS()
	for i = 1, #unitsWithRaid do
		local unit = unitsWithRaid[i]

		if self.AttachedFrames[unit] then
			self:ShowBigDebuffs(self.AttachedFrames[unit])
		end

		if not unit:match("^raid") then
			self:UNIT_AURA(unit)
		end
	end
end

BigDebuffs.AttachedFrames = {}

local MAX_BUFFS = 6

function BigDebuffs:AddBigDebuffs(frame)
	if not frame or not frame.displayedUnit or not UnitIsPlayer(frame.displayedUnit) then return end
	local frameName = frame:GetName()
	if self.db.profile.raidFrames.increaseBuffs then
		for i = 4, MAX_BUFFS do
			local buffPrefix = frameName .. "Buff"
			local buffFrame = _G[buffPrefix .. i] or CreateFrame("Button", buffPrefix .. i, frame, "CompactBuffTemplate")
			buffFrame:ClearAllPoints()
			if math.fmod(i - 1, 3) == 0 then
				buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 3], "TOPRIGHT")
			else
				buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 1], "BOTTOMLEFT")
			end
		end
	end

	self.AttachedFrames[frame.displayedUnit] = frame

	frame.BigDebuffs = frame.BigDebuffs or {}
	local max = self.db.profile.raidFrames.maxDebuffs + 1 -- add a frame for warning debuffs
	for i = 1, max do
		local big = frame.BigDebuffs[i] or
			CreateFrame("Button", frameName .. "BigDebuffsRaid" .. i, frame, "CompactDebuffTemplate")
		big:ClearAllPoints()
		if i > 1 then
			if self.db.profile.raidFrames.anchor == "INNER" then
				big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "LEFT" then
				big:SetPoint("BOTTOMRIGHT", frame.BigDebuffs[i-1], "BOTTOMLEFT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "RIGHT" then
				big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
			end
		else
			if self.db.profile.raidFrames.anchor == "INNER" then
				big:SetPoint("BOTTOMLEFT", frame.debuffFrames[1], "BOTTOMLEFT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "LEFT" then
				big:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, 1)
			elseif self.db.profile.raidFrames.anchor == "RIGHT" then
				big:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 1)
			end
		end

		--local start, duration, enable, charges, maxCharges = GetActionCooldown(self.action);
		--CooldownFrame_SetTimer(self.cooldown, start, duration, enable, charges, maxCharges);
		--big.cooldown:SetHideCountdownNumbers(not self.db.profile.raidFrames.cooldownCount)
		big.cooldown.noCooldownCount = not self.db.profile.raidFrames.cooldownCount

		--big.cooldown:SetDrawEdge(false)
		frame.BigDebuffs[i] = big
		big:Hide()
		self.frames[frame] = true
		self:ShowBigDebuffs(frame)
	end
	return true
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


function BigDebuffs:PLAYER_TALENT_UPDATE()
	local specID = GetSpecializationInfo(GetSpecialization() or 1)
	self.specDispel = specID and specDispel[specID] and specDispel[specID]
end

local pending = {}

function BigDebuffs:PLAYER_REGEN_ENABLED()
	for frame,_ in pairs(pending) do
		BigDebuffs:AddBigDebuffs(frame)
		pending[frame] = nil
	end
end

local function IsPriorityDebuff(id)
	for i = 1, #BigDebuffs.PriorityDebuffs do
		if id == BigDebuffs.PriorityDebuffs[i] then
			return true
		end
	end
end

hooksecurefunc("CompactUnitFrame_HideAllDebuffs", HideBigDebuffs)

function BigDebuffs:IsDispellable(dispelType)
	if not dispelType or not self.specDispel then return end
	if type(self.specDispel[dispelType]) == "function" then return self.specDispel[dispelType]() end
	return self.specDispel[dispelType]
end

function BigDebuffs:GetDebuffSize(id, dispellable)
	if self.db.profile.raidFrames.pve > 0 then
		local _, instanceType = IsInInstance()
		if dispellable and instanceType and (instanceType == "raid" or instanceType == "party") then
			return self.db.profile.raidFrames.pve
		end
	end
	
	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID

	local category = self.Spells[id].type

	if not category or not self.db.profile.raidFrames[category] then return end

	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].raidFrames and self.db.profile.spells[id].raidFrames == 0 then return end
		if self.db.profile.spells[id].size then return self.db.profile.spells[id].size end
	end

	if self.Spells[id].noraidFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].raidFrames) then
		return
	end

	local dispellableSize = self.db.profile.raidFrames.dispellable[category]
	if dispellable and dispellableSize and dispellableSize > 0 then return dispellableSize end

	if self.db.profile.raidFrames[category] > 0 then
		return self.db.profile.raidFrames[category]
	end
end

-- For raid frames
function BigDebuffs:GetDebuffPriority(id)
	if not self.Spells[id] then return 0 end
	id = self.Spells[id].parent or id -- Check for parent spellID
	
	return self.db.profile.spells[id] and self.db.profile.spells[id].priority or
		self.db.profile.priority[self.Spells[id].type] or 0
end

-- For unit frames
function BigDebuffs:GetAuraPriority(id)
	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID
	
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

function BigDebuffs:UpdateStance(guid, spellid)
	if self.stances[guid] == nil then
		self.stances[guid] = {}
-- Copy this function to check for testing mode
local function CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff, test)
	local UnitDebuff = test and UnitDebuffTest or UnitDebuff
	-- make sure you are using the correct index here!
	--isBossAura says make this look large.
	--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId;

	if index == -1 then
		-- it's an interrupt
		local spell = BigDebuffs.units[UnitGUID(unit)]
		spellId = spell.spellId
		icon = GetSpellTexture(spellId)
		count = 1
		duration = BigDebuffs.Spells[spellId].duration
		expirationTime = spell.expires
	else
		self:CancelTimer(self.stances[guid].timer)
		if (isBossBuff) then
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId = UnitBuff(unit, index, filter);
		else
			name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId = UnitDebuff(unit, index, filter);
		end
	end
	
	self.stances[guid].stance = spellid
	self.stances[guid].timer = self:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)

	local unit = self:GetUnitFromGUID(guid)
	if unit then
		self:UNIT_AURA(nil, unit)
	debuffFrame.filter = filter;
	debuffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 10 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame:SetID(index);
	if ( expirationTime and expirationTime ~= 0 ) then
		local startTime = expirationTime - duration;
		debuffFrame.cooldown:SetCooldown(startTime, duration);
		debuffFrame.cooldown:Show();
	else
		debuffFrame.cooldown:Hide();
	end

	local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

function BigDebuffs:ClearStanceGUID(guid)
	local unit = self:GetUnitFromGUID(guid)
	if unit == nil then
		self.stances[guid] = nil
	debuffFrame.isBossBuff = isBossBuff;
	if ( isBossAura ) then
		debuffFrame:SetSize(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE);
	else
		self.stances[guid].timer = BigDebuffs:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)
		debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize);
	end

	debuffFrame:Show();
end

function BigDebuffs:ShowBigDebuffs(frame)

	if not self.db.profile.raidFrames.enabled or not frame.debuffFrames or not frame.BigDebuffs then return end

	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end	

	local UnitDebuff = self.test and UnitDebuffTest or UnitDebuff

	HideBigDebuffs(frame)

	local debuffs = {}
	local big
	local now = GetTime()
	local warning, warningId

	for i = 1, 40 do
		local _,_,_,_, dispelType, _, time, caster, _,_, id = UnitDebuff(frame.displayedUnit, i)
		if id then
			local reaction = caster and UnitReaction("player", caster) or 0
			local friendlySmokeBomb = id == 88611 and reaction > 4
			local size = self:GetDebuffSize(id, self:IsDispellable(dispelType))
			if size and not friendlySmokeBomb then
				big = true
				local duration = time and time - now or 0
				tinsert(debuffs, { i, size, duration, self:GetDebuffPriority(id) })
			elseif self.db.profile.raidFrames.redirectBliz or
			(self.db.profile.raidFrames.anchor == "INNER" and not self.db.profile.raidFrames.hideBliz) then
				if not frame.optionTable.displayOnlyDispellableDebuffs or self:IsDispellable(dispelType) then
					tinsert(debuffs, { i, self.db.profile.raidFrames.default, 0, 0 }) -- duration 0 to preserve Blizzard order
				end
			end

			-- Set warning debuff
			local k
			for j = 1, #self.WarningDebuffs do
				if id == self.WarningDebuffs[j] and
				self.db.profile.raidFrames.warningList[id] and
				not friendlySmokeBomb and
				(not k or j < k) then
					k = j
					warning = i
					warningId = id
				end
			end
		end
	end

	-- check for interrupts
	local guid = UnitGUID(frame.displayedUnit)
	if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
		local spellId = self.units[guid].spellId
		local size = self:GetDebuffSize(spellId, false)
		if size then
			big = true
			tinsert(debuffs, { -1, size, 0, self:GetDebuffPriority(id) })
		end
	end

	if #debuffs > 0 then
		-- insert the warning debuff if it exists and we have a big debuff
		if big and warning then
			local size = self.db.profile.raidFrames.warning
			-- remove duplicate
			for k,v in pairs(debuffs) do
				if v[1] == warning then
					if self.Spells[warningId] then size = v[2] end -- preserve the size
					table.remove(debuffs, k)
					break
				end
			end
			tinsert(debuffs, { warning, size, 0, 0, true })
		else
			warning = nil
		end

		-- sort by priority > size > duration > index
		table.sort(debuffs, function(a, b)
			if a[4] == b[4] then
				if a[2] == b[2] then
					if a[3] < b[3] then return true end
					if a[3] == b[3] then return a[1] < b[1] end
				end
				return a[2] > b[2]
			end
			return a[4] > b[4]
		end)

		local index = 1

		if self.db.profile.raidFrames.hideBliz or
		self.db.profile.raidFrames.anchor == "INNER" or
		self.db.profile.raidFrames.redirectBliz then
			CompactUnitFrame_HideAllDebuffs(frame)
		end

		for i = 1, #debuffs do			
			if index <= self.db.profile.raidFrames.maxDebuffs or debuffs[i][1] == warning then
				if not frame.BigDebuffs[index] then break end
				frame.BigDebuffs[index].baseSize = frame:GetHeight() * debuffs[i][2] * 0.01
				CompactUnitFrame_UtilSetDebuff(frame.BigDebuffs[index], frame.displayedUnit, debuffs[i][1], nil, false, false, self.test)
				--frame.BigDebuffs[index].cooldown:SetSwipeColor(0, 0, 0, 0.7)
				index = index + 1
			end
		end

	end

end

-- We need to copy the entire function to avoid taint
hooksecurefunc("CompactUnitFrame_UpdateDebuffs", function(frame)
	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end	

	if ( not frame.optionTable.displayDebuffs ) then
		CompactUnitFrame_HideAllDebuffs(frame);
		return;
	end
	local test = BigDebuffs.test
	local UnitDebuff = test and UnitDebuffTest or UnitDebuff
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	local maxDebuffs = frame.maxDebuffs;
	--Show both Boss buffs & debuffs in the debuff location
	--First, we go through all the debuffs looking for any boss flagged ones.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) ) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false, test);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	--Then we go through all the buffs looking for any boss flagged ones.
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitBuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true, test);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	
	--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName, _,_,_,_,_,_,_,_,_, id = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) or IsPriorityDebuff(id)) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false, test);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	
	if ( frame.optionTable.displayOnlyDispellableDebuffs ) then
		filter = "RAID";
	end
	
	index = 1;
	--Now, we display all normal debuffs.
	if ( frame.optionTable.displayNonBossDebuffs ) then
	while ( frameNum <= maxDebuffs ) do
		local debuffName, _,_,_,_,_,_,_,_,_, id = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if BigDebuffs.test or (( CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and
				not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) and not IsPriorityDebuff(id))) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false, test);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	end
	
	for i=frameNum, frame.maxDebuffs do
		local debuffFrame = frame.debuffFrames[i];
		debuffFrame:Hide();
	end

	BigDebuffs:ShowBigDebuffs(frame)
end)

function BigDebuffs:IsPriorityBigDebuff(id)
	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID
	return self.Spells[id].priority
end

function BigDebuffs:UNIT_AURA(unit)
	if not self.db.profile.unitFrames.enabled or not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled then return end

	self:AttachUnitFrame(unit)

	local frame = self.UnitFrames[unit]
	if not frame then return end

	local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff

	local now = GetTime()
	local left, priority, duration, expires, icon, debuff, buff, interrupt = 0, 0

	for i = 1, 40 do
		-- Check debuffs
		local _,_, n, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
		if id then
			if self.Spells[id] then
				local reaction = caster and UnitReaction("player", caster) or 0
				local friendlySmokeBomb = id == 88611 and reaction > 4
				local p = self:GetAuraPriority(id)
				if p and p >= priority and not friendlySmokeBomb then
					if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
						left = e - now
						duration = d
						debuff = i
						priority = p
						expires = e
						icon = id == 137143 and"Interface\\AddOns\\".. addonName .."\\bloodhorror2"or n
					end
				end
			end
		end

		-- Check buffs
		local _,_, n, _,_, d, e, _,_,_, id = UnitBuff(unit, i)
		if id then
			if self.Spells[id] then
				local p = self:GetAuraPriority(id)
				if p and p >= priority then
					if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
						left = e - now
						duration = d
						debuff = i
						priority = p
						expires = e
						icon = n
						buff = true
					end
				end
			end
		end
	end

	-- need to always look for a stance (if we only look for it once a player
	-- changes stance we will never get back to it again once other auras fade)
	-- Check for interrupt
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
	if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
		local spell = self.units[guid]
		local spellId = spell.spellId
		local p = self:GetAuraPriority(spellId)
		if p and p >= priority and self.Spells[spellId] then
			left = spell.expires - now
			duration = self.Spells[spellId].duration
			debuff = spellId
			expires = spell.expires
			icon = spellId == 137143 and"Interface\\AddOns\\".. addonName .."\\bloodhorror2"or GetSpellTexture(spellId)
			interrupt = spellId
		end		
	end
	

	if debuff then
		if duration < 1 then duration = 1 end -- auras like Solar Beam don't have a duration

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
		
		frame.cooldown:SetCooldown(expires - duration, duration)
		frame:Show()
		--frame.cooldown:SetSwipeColor(0, 0, 0, 0.6)

		-- set for tooltips
		frame:SetID(debuff)
		frame.buff = buff
		frame.interrupt = interrupt
		frame.current = icon
	else
		-- Adapt
		if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
			Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
		end

		frame:Hide()
		frame.current = nil
	end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA("focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA("target")
end

function BigDebuffs:UNIT_PET()
	self:UNIT_AURA("pet")
end

-- Show extra buffs
-- Setting frame.maxBuffs causes taint, so we need to copy entire function (FrameXML/CompactUnitFrame.lua)
hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(frame)

	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end	
	
	if not BigDebuffs.db.profile.raidFrames.increaseBuffs then return end

	if ( not frame.optionTable.displayBuffs ) then
		CompactUnitFrame_HideAllBuffs(frame);
		return;
	end
	
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	while ( frameNum <= MAX_BUFFS ) do
		local buffName = UnitBuff(frame.displayedUnit, index, filter);
		if ( buffName ) then
			if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
				local buffFrame = frame.buffFrames[frameNum];
				CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	for i=frameNum, MAX_BUFFS do
		local buffFrame = frame.buffFrames[i];
		if buffFrame then buffFrame:Hide() end
	end
end)

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
	LibStub("AceConfigDialog-3.0"):Open("BigDebuffs")
end
