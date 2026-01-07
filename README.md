# GripSwitch

A dynamic weapon grip switching system for Skyrim Special Edition and Enderal that allows you to seamlessly switch between one-handed and two-handed grips on your weapons.

Code base from mod  [Skysa Grip Switch](https://www.nexusmods.com/skyrimspecialedition/mods/54056?tab=posts) with some modification to decouple dependencies of SkySA itself. Please endorse the mod!

## Features

### Core Functionality
- **One-Handed → Two-Handed**: Grip one-handed weapons with both hands for a different combat style
- **Two-Handed → One-Handed**: Wield two-handed weapons in one hand for more versatility
- **Smart Left Hand Management**: Automatically unequips left hand weapons when switching to two-handed grip
- **Auto Grip Switching**: When equipping items in your left hand, the mod automatically switches your right hand weapon to the appropriate grip

### Customization Options
- **Multiple Hotkey Modes**:
  - Single Tap: Press once to toggle grip
  - Double Tap: Double-tap within 0.2 seconds to switch
  - Modifier Key: Hotkey only works when holding a modifier key
- **Skill Matching**: Optional setting to change weapon skill based on grip (e.g., one-handed sword uses Two-Handed skill when gripped with both hands)
- **Damage Compensation**: Configurable damage adjustment to balance one-handed weapons used two-handed (default: +50% damage)

### Smart Behavior
- Resets to normal grip when equipping a new weapon
- Preserves weapon modifications and enchantments
- Works with all melee weapon types (swords, axes, maces, greatswords, battleaxes, warhammers)
- Ignores bows and crossbows (ranged weapons)

## Requirements

- [SKSE64](https://skse.silverlock.org/) - Skyrim Script Extender
- [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604) - For MCM configuration menu
- [Behaviour Data Injector (BDI)](https://www.nexusmods.com/skyrimspecialedition/mods/78146) - Required for behaviour injection in runtime
- [Open Animation Replacer](https://www.nexusmods.com/skyrimspecialedition/mods/92109) - For animation switching
- [OAR Math Plugin](https://www.nexusmods.com/skyrimspecialedition/mods/92607) - Required for animation conditions

## Installation

1. Install all required mods listed above
2. Download and install GripSwitch using your mod manager
3. Load order: Place after SKSE, SkyUI, and Open Animation Replacer
4. Launch the game and configure settings via MCM menu

## Configuration

### MCM Settings

**Grip Switching**
- **Input Type**: Choose between Tap, Double-Tap, or Modifier+Hotkey
- **Hotkey**: Set the key to switch grips (default: unbound)
- **Modifier Key**: Set modifier key if using Modifier+Hotkey mode

**Gameplay**
- **Skill Matches Grip**: Toggle whether weapon skill changes with grip
  - Enabled: 1H weapons use Two-Handed skill when gripped two-handed
  - Disabled: Weapons always use their original skill
- **Damage Change**: Adjust damage compensation (default: 50%)
  - Positive values: 1H weapons deal more damage in two hands
  - Negative values: 1H weapons deal less damage in two hands

## How It Works

### Grip Switching
1. Equip a weapon in your right hand
2. Draw the weapon
3. Press your configured hotkey to switch grip
4. The animation changes and stats adjust accordingly

### Automatic Left Hand Management
- **Switching to Two-Handed Grip**: Automatically unequips your left hand weapon
- **Equipping Left Hand Items**: Automatically switches back to normal grip if you're using alternate grip

### Weapon Type Support
- **One-Handed**: Swords (1), Daggers (2), Axes (3), Maces (4)
- **Two-Handed**: Greatswords (5), Battleaxes/Warhammers (6)
- **Not Supported**: Bows (7), Staves (8), Crossbows (9)

## Technical Details

### Animation System
The mod uses the `bSwitchGrips` animation variable to control grip states:
- `false`: Normal grip (default)
- `true`: Alternate grip (1H as 2H, or 2H as 1H)

### Skill System
When "Skill Matches Grip" is enabled:
- 1H weapons (types 1-4) in alternate grip use **TwoHanded** skill
- 2H weapons (types 5-6) in alternate grip use **OneHanded** skill
- Original skill is restored when switching back to normal grip

### Damage Compensation
A spell-based system adjusts weapon damage based on the configured percentage. The spell is refreshed whenever grip changes to maintain proper damage values.

## Compatibility

### Known Compatible
- ✅ Enderal: Forgotten Stories (skill names are identical)
- ✅ Combat animation mods (uses OAR for proper animation blending)
- ✅ Weapon enchantments and modifications

### Potential Conflicts
- ⚠️ Mods that modify weapon equip/unequip behavior may interfere
- ⚠️ Animation mods that override the same animation priorities
- ⚠️ Mods that modify weapon skills or damage calculations

### Notes
- If you're disarmed or drop a weapon, grip state resets when re-equipping
- The mod does not persist grip state across save/load cycles (intentional design)
- Works best with clean weapon equip/unequip cycles

## Troubleshooting

**Hotkey not working:**
- Ensure SKSE is properly installed
- Check that the hotkey isn't conflicting with other mods
- Verify weapon is drawn before trying to switch grip

**Animation not changing:**
- Verify Open Animation Replacer is installed correctly
- Check that OAR Math Plugin is loaded
- Ensure animation priority isn't being overridden by another mod

**Damage not adjusting:**
- Check MCM damage compensation setting
- Verify the spell is properly applied (should happen automatically)
- Try adjusting the damage percentage in MCM

**Left hand not auto-switching:**
- This is working as intended for auto-grip-switching
- Only manual hotkey switches will unequip the left hand weapon

## Credits

- [PossiblyShiba](https://www.nexusmods.com/profile/PossiblyShiba?gameId=1704) for Original GripSwitch concept and implementation for SkySA
- SKSE Team - For Skyrim Script Extender
- SkyUI Team - For MCM framework
- [Ershin](https://www.nexusmods.com/profile/Ershin?gameId=1704) - For Open Animation Replacer

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## License

This mod is released under [your chosen license]. Please respect the terms when sharing or modifying.

## Support

For bug reports, feature requests, or questions:
- [Nexus Mods Page](your-nexus-link)
- [GitHub Issues](your-github-link)

---

**Enjoy your dynamic grip switching experience!**
