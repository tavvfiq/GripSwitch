;/ Decompiled by Champollion V1.0.1
Source   : GripSwitch.psc
Modified : 2021-09-21 18:54:23
Compiled : 2021-09-21 18:57:51
User     : donov
Computer : DESKTOP-RVF06O1
/;
scriptName GripSwitch extends ReferenceAlias

;-- Properties --------------------------------------
globalvariable property DamageChange auto
globalvariable property GripHotkey auto
globalvariable property GripHotkey_ModifierEnabled auto
sound property SwitchBackSound auto
sound property SwitchToSound auto
spell property DamageChange_Spell auto
globalvariable property GripHotkey_ModifierHotkey auto
globalvariable property GripHotkey_DoubleTapEnabled auto
globalvariable property SkillsMatch auto
gripswitchmcm property GripSwapMCM auto
actor property PlayerRef auto

;-- Variables ---------------------------------------
Bool ScriptON = false
Bool GripHotkey_DoubleTapReady = false
String WeaponSkill
Bool InMenu = false
weapon EquippedWeaponLeft
equipslot OneHandedSlot
Int WeaponTypeRight
weapon EquippedWeaponRight
Bool DelayOnObjectEquippedEvent = false
Float AttackControl_HoldTime = 0.000000
Bool GripHotkey_ModifierIsHeld = false
equipslot TwoHandedSlot
Bool NoEquipEvents = false
Bool AttackControl_IsHeld = false

;-- Functions ---------------------------------------

function OnControlUp(String control, Float HoldTime)

	if control == "Right Attack/Block"
		AttackControl_HoldTime = 0.000000
		AttackControl_IsHeld = false
	endIf
endFunction

function OnKeyDown(Int KeyCode)

	if KeyCode as Float == GripHotkey_ModifierHotkey.GetValue()
		GripHotkey_ModifierIsHeld = true
		return 
	endIf
	if utility.IsInMenuMode() || InMenu as Bool
		
	endIf
	if KeyCode == GripSwapMCM.BlockingHotkey
		debug.SendAnimationEvent(PlayerRef as objectreference, "blockStart")
		PlayerRef.SetAnimationVariableBool("bForceWantBlock", true)
	endIf
	if KeyCode as Float == GripHotkey.GetValue() && GripHotkey_DoubleTapEnabled.GetValue() == 1 as Float && !GripHotkey_DoubleTapReady
		GripHotkey_DoubleTapReady = true
		self.RegisterForSingleUpdate(0.200000)
		return 
	endIf
	if ScriptON
		return 
	endIf
	if EquippedWeaponRight as Bool && EquippedWeaponRight == PlayerRef.GetEquippedWeapon(false) && PlayerRef.IsWeaponDrawn()
		ScriptON = true
		if KeyCode as Float == GripHotkey.GetValue() && GripHotkey_ModifierEnabled.GetValue() == 0 as Float || KeyCode as Float == GripHotkey.GetValue() && GripHotkey_ModifierEnabled.GetValue() == 1 as Float && GripHotkey_ModifierIsHeld as Bool
			if PlayerRef.GetAnimationVariableBool("bSwitchGrips") == true
				PlayerRef.SetAnimationVariableBool("bSwitchGrips", false)
				
				; Store right hand weapon before unequipping left hand
				weapon rightHandWeapon = EquippedWeaponRight
				
				NoEquipEvents = true
				
				; Unequip left hand weapon when switching back to normal grip
				weapon leftWeapon = PlayerRef.GetEquippedWeapon(true)
				if leftWeapon
					PlayerRef.UnequipItem(leftWeapon as form, false, true)
					utility.waitmenumode(0.100000)
				endIf
				
				; Ensure right hand weapon stays equipped
				if PlayerRef.GetEquippedWeapon(false) != rightHandWeapon
					PlayerRef.EquipItem(rightHandWeapon as form, false, true)
					utility.waitmenumode(0.100000)
				endIf
				
				NoEquipEvents = false
				
				if WeaponTypeRight >= 1 && WeaponTypeRight <= 4
					
				elseIf WeaponTypeRight == 5 || WeaponTypeRight == 6
					
				endIf
				if SkillsMatch.GetValue() == 1 as Float || EquippedWeaponRight.GetSkill() != WeaponSkill
					EquippedWeaponRight.SetSkill(WeaponSkill)
				endIf
				self.DamageChangeMaintenance()
				if !(PlayerRef as objectreference).GetAnimationVariableBool("IsAttacking")
					SwitchBackSound.Play(PlayerRef as objectreference)
				endIf
			else
				PlayerRef.SetAnimationVariableBool("bSwitchGrips", true)
				
				; Store right hand weapon before unequipping left hand
				weapon rightHandWeapon = EquippedWeaponRight
				
				NoEquipEvents = true
				
				; Unequip left hand weapon when switching to two-handed grip
				weapon leftWeapon = PlayerRef.GetEquippedWeapon(true)
				if leftWeapon
					PlayerRef.UnequipItem(leftWeapon as form, false, true)
					utility.waitmenumode(0.100000)
				endIf
				
				; Ensure right hand weapon stays equipped
				if PlayerRef.GetEquippedWeapon(false) != rightHandWeapon
					PlayerRef.EquipItem(rightHandWeapon as form, false, true)
					utility.waitmenumode(0.100000)
				endIf
				
				NoEquipEvents = false
				
				if WeaponTypeRight >= 1 && WeaponTypeRight <= 4
					if SkillsMatch.GetValue() == 1 as Float
						EquippedWeaponRight.SetSkill("TwoHanded")
					endIf
				elseIf WeaponTypeRight == 5 || WeaponTypeRight == 6
					if SkillsMatch.GetValue() == 1 as Float
						EquippedWeaponRight.SetSkill("OneHanded")
					endIf
				endIf
				self.DamageChangeMaintenance()
			endIf
			if !(PlayerRef as objectreference).GetAnimationVariableBool("IsAttacking")
				SwitchToSound.Play(PlayerRef as objectreference)
			endIf
		endIf
	endIf
	ScriptON = false
endFunction

function OnPlayerLoadGame()

	self.Initialization()
	self.DamageChangeMaintenance()
endFunction

function SearchFor2HandedWeapons()

	Int i = PlayerRef.GetNumItems() - 1
	while i >= 0
		form Item = PlayerRef.GetNthForm(i)
		if (Item as weapon) as Bool && (Item as weapon).GetEquipType() == TwoHandedSlot && ((Item as weapon).GetWeaponType() == 5 || (Item as weapon).GetWeaponType() == 6)
			(Item as weapon).SetEquipType(OneHandedSlot)
		endIf
		i -= 1
	endWhile
endFunction

; Skipped compiler generated GetState

function OnKeyUp(Int KeyCode, Float HoldTime)

	if utility.IsInMenuMode() || InMenu as Bool
		utility.wait(0.100000)
	endIf
	if KeyCode == GripSwapMCM.BlockingHotkey
		debug.SendAnimationEvent(PlayerRef as objectreference, "blockStop")
		PlayerRef.SetAnimationVariableBool("bForceWantBlock", false)
	endIf
	if KeyCode as Float == GripHotkey_ModifierHotkey.GetValue() && GripHotkey_ModifierEnabled.GetValue() == 1 as Float
		GripHotkey_ModifierIsHeld = false
	endIf
endFunction

function OnObjectEquipped(form akBaseObject, objectreference akReference)

	utility.waitmenumode(0.100000)
	while ScriptON as Bool || DelayOnObjectEquippedEvent as Bool
		utility.waitmenumode(0.100000)
	endWhile
	
	; Check if something is being equipped in left hand
	utility.waitmenumode(0.100000)
	if akBaseObject == PlayerRef.GetEquippedObject(0)
		Bool shouldBlockLeftHand = false
			
		; Block left hand if 2H weapon in right hand with normal grip
		if EquippedWeaponRight && (WeaponTypeRight == 5 || WeaponTypeRight == 6) && !PlayerRef.GetAnimationVariableBool("bSwitchGrips")
			shouldBlockLeftHand = true
		endIf
			
		; Block left hand if 1H weapon in right hand with switched grip
		if EquippedWeaponRight && WeaponTypeRight >= 1 && WeaponTypeRight <= 4 && PlayerRef.GetAnimationVariableBool("bSwitchGrips")
			shouldBlockLeftHand = true
		endIf
			
		if shouldBlockLeftHand
			PlayerRef.UnequipItem(akBaseObject, false, true)
			debug.Notification("Switch grip first to use left hand")
		endIf
	endIf
	
	if akBaseObject as Bool && (akBaseObject as weapon) as Bool && akBaseObject as weapon == PlayerRef.GetEquippedWeapon(false)
		if !NoEquipEvents
			ScriptON = true
			weapon akWeapon = akBaseObject as weapon
			
			; Reset grip to normal
			PlayerRef.SetAnimationVariableBool("bSwitchGrips", false)
			
			if akWeapon.GetWeaponType() >= 1 && akWeapon.GetWeaponType() <= 6
				EquippedWeaponRight = akWeapon
				WeaponTypeRight = EquippedWeaponRight.GetWeaponType()
				WeaponSkill = EquippedWeaponRight.GetSkill()
			elseIf (WeaponTypeRight == 5 || WeaponTypeRight == 6) && EquippedWeaponRight.GetEquipType() != OneHandedSlot
				NoEquipEvents = true
				PlayerRef.UnequipItem(EquippedWeaponRight as form, false, true)
				EquippedWeaponRight.SetEquipType(OneHandedSlot)
				PlayerRef.EquipItem(EquippedWeaponRight as form, false, true)
				utility.waitmenumode(0.250000)
				NoEquipEvents = false
			endIf
			ScriptON = false
		endIf
	endIf
endFunction

function Initialization()

	self.RegisterForAllMenus()
	self.SearchFor2HandedWeapons()
endFunction

function OnControlDown(String control)

	if control == "Right Attack/Block" && !utility.IsInMenuMode() && !(PlayerRef as objectreference).GetAnimationVariableBool("Isblocking") && !(PlayerRef as objectreference).GetAnimationVariableBool("IsBashing")
		AttackControl_HoldTime = 0.000000
		AttackControl_IsHeld = true
		utility.wait(0.100000)
		if AttackControl_IsHeld
			self.RegisterForSingleUpdate(0.200000)
		endIf
	endIf
endFunction

function OnObjectUnequipped(form akBaseObject, objectreference akReference)

	if NoEquipEvents
		return 
	endIf
	if akBaseObject == EquippedWeaponRight as form && (akBaseObject as weapon).GetSkill() != WeaponSkill
		(akBaseObject as weapon).SetSkill(WeaponSkill)
	endIf
endFunction

function OnItemAdded(form akBaseItem, Int aiItemCount, objectreference akItemReference, objectreference akSourceContainer)

	if (akBaseItem as weapon) as Bool && (akBaseItem as weapon).GetEquipType() == TwoHandedSlot && ((akBaseItem as weapon).GetWeaponType() == 5 || (akBaseItem as weapon).GetWeaponType() == 6)
		(akBaseItem as weapon).SetEquipType(OneHandedSlot)
	endIf
endFunction

function DamageChangeMaintenance()

	DamageChange_Spell.SetNthEffectMagnitude(0, DamageChange.GetValue())
	DamageChange_Spell.SetNthEffectMagnitude(1, DamageChange.GetValue())
	DamageChange_Spell.SetNthEffectMagnitude(2, DamageChange.GetValue())
	PlayerRef.RemoveSpell(DamageChange_Spell)
	utility.waitmenumode(0.250000)
	PlayerRef.AddSpell(DamageChange_Spell, false)
endFunction

function RegisterForAllMenus()

	self.RegisterForMenu("BarterMenu")
	self.RegisterForMenu("Book Menu")
	self.RegisterForMenu("Console")
	self.RegisterForMenu("Console Native UI Menu")
	self.RegisterForMenu("ContainerMenu")
	self.RegisterForMenu("Crafting Menu")
	self.RegisterForMenu("Credits Menu")
	self.RegisterForMenu("Cursor Menu")
	self.RegisterForMenu("Debug Text Menu")
	self.RegisterForMenu("Dialogue Menu")
	self.RegisterForMenu("Fader Menu")
	self.RegisterForMenu("FavoritesMenu")
	self.RegisterForMenu("GiftMenu")
	self.RegisterForMenu("HUD Menu")
	self.RegisterForMenu("InventoryMenu")
	self.RegisterForMenu("Journal Menu")
	self.RegisterForMenu("Kinect Menu")
	self.RegisterForMenu("LevelUp Menu")
	self.RegisterForMenu("Loading Menu")
	self.RegisterForMenu("Lockpicking Menu")
	self.RegisterForMenu("MagicMenu")
	self.RegisterForMenu("Main Menu")
	self.RegisterForMenu("MapMenu")
	self.RegisterForMenu("MessageBoxMenu")
	self.RegisterForMenu("Mist Menu")
	self.RegisterForMenu("Overlay Interaction Menu")
	self.RegisterForMenu("Overlay Menu")
	self.RegisterForMenu("Quantity Menu")
	self.RegisterForMenu("RaceSex Menu")
	self.RegisterForMenu("Sleep/Wait Menu")
	self.RegisterForMenu("StatsMenu")
	self.RegisterForMenu("TitleSequence Menu")
	self.RegisterForMenu("Top Menu")
	self.RegisterForMenu("Training Menu")
	self.RegisterForMenu("Tutorial Menu")
	self.RegisterForMenu("TweenMenu")
endFunction

function OnInit()

	utility.wait(2 as Float)
	OneHandedSlot = game.GetForm(81730) as equipslot
	TwoHandedSlot = game.GetForm(81733) as equipslot
	self.RegisterForAllMenus()
	if PlayerRef.GetEquippedObject(1) as Bool && (PlayerRef.GetEquippedObject(1) as weapon) as Bool
		weapon InitWeapon = PlayerRef.GetEquippedObject(1) as weapon
		PlayerRef.UnequipItem(InitWeapon as form, false, true)
		utility.wait(0.250000)
		PlayerRef.EquipItem(InitWeapon as form, false, true)
	endIf
	self.SearchFor2HandedWeapons()
	debug.Notification("Grip Switch installed!")
endFunction

; Skipped compiler generated GotoState

function OnMenuClose(String MenuName)

	utility.wait(0.700000)
	InMenu = false
endFunction

function OnMenuOpen(String MenuName)

	InMenu = true
endFunction