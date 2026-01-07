scriptName GripSwitchMCM extends SKI_ConfigBase

;-- Properties --------------------------------------
globalvariable property GripHotkey_ModifierEnabled auto
globalvariable property GripHotkey auto
globalvariable property GripHotkey_ModifierHotkey auto
gripswitch property GripChange auto
globalvariable property OffHandUse2HGrip auto
actor property PlayerRef auto
Float property GSDamageChange = 20.0000 auto hidden
globalvariable property DamageChange auto
globalvariable property SkillsMatch auto
globalvariable property GripHotkey_DoubleTapEnabled auto

;-- Variables ---------------------------------------
Int HotkeyInputMethodIndex = 0
Int GSGripHotkey_ModifierHotkey = 0
String[] HotkeyInputMethods
Bool GSWSkillsMatch = true
Int GSGripHotkey = 0

;-- Functions ---------------------------------------

function OnConfigInit()

	HotkeyInputMethods = new String[3]
	HotkeyInputMethods[0] = "Hotkey (Tap)"
	HotkeyInputMethods[1] = "Hotkey (Double-Tap)"
	HotkeyInputMethods[2] = "Hotkey + Modifier"
endFunction

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

function OnPlayerLoadGame()

	self.OnConfigInit()
endFunction

function OnPageReset(String page)

	self.SetTitleText("Grip Switch")
	self.SetCursorFillMode(self.TOP_TO_BOTTOM)
	self.SetCursorPosition(0)
	if page == ""
		return 
	elseIf page == "Settings"
		self.UnloadCustomContent()
		self.SetTitleText("Settings")
		self.AddHeaderOption(" Unlocked Grip", 0)
		self.AddMenuOptionST("GRIP_HOTKEY_INPUT_TYPE_STATE", " Input Type", HotkeyInputMethods[HotkeyInputMethodIndex], 0)
		if HotkeyInputMethodIndex == 2
			self.AddKeyMapOptionST("GRIP_MODIFIER_STATE", " Modifier", GSGripHotkey_ModifierHotkey, self.OPTION_FLAG_WITH_UNMAP)
		endIf
		self.AddKeyMapOptionST("GRIP_HOTKEY_STATE", " Hotkey", GSGripHotkey, self.OPTION_FLAG_WITH_UNMAP)
		if HotkeyInputMethodIndex != 2
			self.AddEmptyOption()
		endIf
		self.AddToggleOptionST("SKILLS_MATCH_STATE", " Skill Matches Grip", GSWSkillsMatch, 0)
		self.AddSliderOptionST("DAMAGE_CHANGE_STATE", " Damage Change", GSDamageChange, "{0}%", 0)
	endIf
	self.SetCursorPosition(0)
endFunction

;-- State -------------------------------------------
state GRIP_HOTKEY_STATE

	function OnHighlightST()

		self.SetInfoText("Set hotkey used to switch grips. Esc means it's not set up yet.")
	endFunction

	function OnDefaultST()

		GripChange.UnregisterForKey(GSGripHotkey)
		GSGripHotkey = 0
		self.SetKeyMapOptionValueST(GSGripHotkey, false, "")
		GripHotkey.SetValue(GSGripHotkey as Float)
	endFunction

	function OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)

		GripChange.UnregisterForKey(GSGripHotkey)
		GSGripHotkey = newKeyCode
		self.SetKeyMapOptionValueST(GSGripHotkey, false, "")
		GripChange.RegisterForKey(GSGripHotkey)
		GripHotkey.SetValue(GSGripHotkey as Float)
	endFunction
endState

;-- State -------------------------------------------
state GRIP_MODIFIER_STATE

	function OnHighlightST()

		self.SetInfoText("Set a modifier key. Your hotkey will only function when this modifier key is pressed. Esc means it's not set up yet.")
	endFunction

	function OnDefaultST()

		GripChange.UnregisterForKey(GSGripHotkey_ModifierHotkey)
		GSGripHotkey_ModifierHotkey = 0
		self.SetKeyMapOptionValueST(GSGripHotkey_ModifierHotkey, false, "")
		GripHotkey_ModifierHotkey.SetValue(GSGripHotkey_ModifierHotkey as Float)
	endFunction

	function OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)

		GripChange.UnregisterForKey(GSGripHotkey_ModifierHotkey)
		GSGripHotkey_ModifierHotkey = newKeyCode
		self.SetKeyMapOptionValueST(GSGripHotkey_ModifierHotkey, false, "")
		GripChange.RegisterForKey(GSGripHotkey_ModifierHotkey)
		GripHotkey_ModifierHotkey.SetValue(GSGripHotkey_ModifierHotkey as Float)
	endFunction
endState

;-- State -------------------------------------------
state GRIP_HOTKEY_INPUT_TYPE_STATE

	function OnMenuAcceptST(Int index)

		HotkeyInputMethodIndex = index
		if HotkeyInputMethodIndex == 0
			GripHotkey_DoubleTapEnabled.SetValue(0 as Float)
			GripHotkey_ModifierEnabled.SetValue(0 as Float)
			GripChange.UnregisterForKey(GSGripHotkey_ModifierHotkey)
		elseIf HotkeyInputMethodIndex == 1
			GripHotkey_DoubleTapEnabled.SetValue(1 as Float)
			GripHotkey_ModifierEnabled.SetValue(0 as Float)
			GripChange.UnregisterForKey(GSGripHotkey_ModifierHotkey)
		elseIf HotkeyInputMethodIndex == 2
			GripHotkey_DoubleTapEnabled.SetValue(0 as Float)
			GripHotkey_ModifierEnabled.SetValue(1 as Float)
			GripChange.RegisterForKey(GSGripHotkey_ModifierHotkey)
		endIf
		self.SetMenuOptionValueST(HotkeyInputMethods[HotkeyInputMethodIndex], false, "")
		self.ForcePageReset()
	endFunction

	function OnHighlightST()

		self.SetInfoText("Set the input type for the grip change hotkey." + "\n'Hotkey (Tap)' is a regular hotkey." + "\n'Hotkey (Double_Tap)' triggers on double taps within 0.2s" + "\n'Hotkey + Modifier' makes the hotkey active only when a modifier key is pressed.")
	endFunction

	function OnDefaultST()

		HotkeyInputMethodIndex = 0
		GripHotkey_DoubleTapEnabled.SetValue(0 as Float)
		GripHotkey_ModifierEnabled.SetValue(0 as Float)
		GripChange.UnregisterForKey(GSGripHotkey_ModifierHotkey)
		self.SetMenuOptionValueST(HotkeyInputMethods[HotkeyInputMethodIndex], false, "")
		self.ForcePageReset()
	endFunction

	function OnMenuOpenST()

		self.SetMenuDialogStartIndex(HotkeyInputMethodIndex)
		self.SetMenuDialogDefaultIndex(0)
		self.SetMenuDialogOptions(HotkeyInputMethods)
	endFunction
endState

;-- State -------------------------------------------
state DAMAGE_CHANGE_STATE

	function OnHighlightST()

		if GSDamageChange >= 0.000000
			self.SetInfoText("Your one-handed weapons do " + (GSDamageChange as Int) as String + "% more damage while in two hands.\nYour two-handed weapons do " + (GSDamageChange as Int) as String + "% less damage while in one hand.")
		elseIf GSDamageChange < 0.000000
			self.SetInfoText("Your one-handed weapons do " + (-1 * GSDamageChange as Int) as String + "% less damage while in two hands.\nYour two-handed weapons do " + (-1 * GSDamageChange as Int) as String + "% more damage while in one hand.")
		endIf
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(GSDamageChange)
		self.SetSliderDialogDefaultValue(20 as Float)
		self.SetSliderDialogRange(-50.0000, 50.0000)
		self.SetSliderDialogInterval(10.0000)
	endFunction

	function OnDefaultST()

		GSDamageChange = 20.0000
		self.SetSliderOptionValueST(GSDamageChange, "{0}", false, "")
		DamageChange.SetValue(0.0100000 * GSDamageChange)
		GripChange.DamageChangeMaintenance()
		self.ForcePageReset()
	endFunction

	function OnSliderAcceptST(Float value)

		GSDamageChange = value
		self.SetSliderOptionValueST(GSDamageChange, "{0}", false, "")
		DamageChange.SetValue(0.0100000 * GSDamageChange)
		GripChange.DamageChangeMaintenance()
		self.ForcePageReset()
	endFunction
endState

;-- State -------------------------------------------
state SKILLS_MATCH_STATE

	function OnHighlightST()

		self.SetInfoText("Each weapon has an associated skill that's used to calculate how much damage your weapon will do, and determine where xp goes on a successful attack." + "\nIf enabled, the skill associated with your weapon switches when you change grip." + "\nIf disabled, the skill of your weapon will not switch when changing grip." + "\nFor staffs, the default skill is the magic school (Destruction, Restoration, etc.)")
	endFunction

	function OnDefaultST()

		GSWSkillsMatch = true
		self.SetToggleOptionValueST(GSWSkillsMatch, false, "")
		SkillsMatch.SetValue((GSWSkillsMatch as Int) as Float)
	endFunction

	function OnSelectST()

		GSWSkillsMatch = !GSWSkillsMatch
		self.SetToggleOptionValueST(GSWSkillsMatch, false, "")
		SkillsMatch.SetValue((GSWSkillsMatch as Int) as Float)
	endFunction
endState
