Hotkey, IfWinActive, ahk_group PoEWindowGrp

If (KeySettings != "") {
  Hotkey % KeySettings, LaunchSettings
}

If (KeyHideLayout != "") {
  Hotkey % KeyHideLayout, ToggleLevelingGuide
}

ToggleLevelingGuide()
{
  if (LG_toggle = 0 or active_toggle = 0)
  {
    LG_toggle = 1
    activeCount := 0
    active_toggle := 1
    Gui, Controls:Show, NA
    Gui, Guide:Show, NA
    If (numPart = 3) {
      Gui, Atlas:Show, NoActivate
    } Else {
      Gui, Atlas:Cancel
    }
    Gui, Notes:Show, NA
    GoSub, ShowAllWindows
  } else {
    Gui, Controls:Cancel
    Gui, Notes:Cancel
    Gui, Atlas:Cancel
    Gui, Guide:Cancel
    LG_toggle = 0
  }
}

If (KeyHideZones != "") {
  Hotkey % KeyHideZones, ToggleZones
}

ToggleZones() {
  global
  if (zone_toggle = 0)
  {
    UpdateImages()
    zone_toggle := 1
  }
  else
  {
    ;These lines aren't needed but make it look faster
    Loop, % maxImages {
      Gui, Image%A_Index%:Hide
    }
    zone_toggle := 0
  }
  SaveState()
}

If (KeyCycleZones != "") {
  Hotkey % KeyCycleZones, CycleZones
}

CycleZones() {
  global
  Gui, Controls:Submit, NoHide
  newZone := RotateZone("next", data.zones, CurrentAct, CurrentZone)
  GuiControl, Controls:Choose, CurrentZone, % "|" newZone

  UpdateImages()
return
}

If (KeyHideExp != "") {
  Hotkey % KeyHideExp, ToggleExp
}

ToggleExp() {
  if (level_toggle = 0)
  {
    Gui, Level:Show, NA
    Gui, Exp:Show, NA
    level_toggle := 1
  }
  else
  {
    Gui, Level:Cancel
    Gui, Exp:Cancel
    level_toggle := 0
  }
  SaveState()
}

If (KeyHideTree != "") {
  Hotkey % KeyHideTree, ToggleTree
}

ToggleTree() {
  if (tree_toggle = 0)
  {
    DrawTree()
    Gui, Tree:Show, NA
    tree_toggle := 1
    atlas_toggle := 0
  }
  else
  {
    Gui, Tree:Cancel
    tree_toggle := 0
    atlas_toggle := 0
  }
  Send %KeyHideTree%
}

If (KeyHideout != "") {
  Hotkey % KeyHideout, PasteHideout
}

If (KeyExit != "") {
  Hotkey % KeyExit, PasteExit
}

If (Key3Link!= "") {
  Hotkey % Key3Link, Paste3Link
}

If (Key4Link!= "") {
  Hotkey % Key4Link, Paste4Link
}

PasteHideout() {
  A_Clipboard := "/hideout"
;  SendInput, {enter}^v{enter}
}

PasteExit() {
  A_Clipboard := "/exit"
;  SendInput, {enter}^v{enter}
}

Paste3Link() {
  A_Clipboard := "-\w-|이동"
;  SendInput, ^f^v{enter}
}

Paste4Link() {
  A_Clipboard := "-\w-.-"
;  SendInput, ^f^v{enter}
}

If (KeyHideAtlas != "") {
  Hotkey % KeyHideAtlas, ToggleAtlas
}

ToggleAtlas() {
  if (atlas_toggle = 0)
  {
    DrawAtlas()
    Gui, Tree:Show, NA
    atlas_toggle := 1
    tree_toggle := 0
  }
  else
  {
    Gui, Tree:Cancel
    atlas_toggle := 0
    tree_toggle := 0
  }
  Send %KeyHideTree%
}

If (KeyHideGems != "") {
  Hotkey % KeyHideGems, ToggleGems
}

ToggleGems() {

}

If (KeyShowSyndicate != "") {
  Hotkey % KeyShowSyndicate, ToggleSyndicate
}

ToggleSyndicate() {

}

If (KeyShowTemple != "") {
  Hotkey % KeyShowTemple, ToggleTemple
}

ToggleTemple() {

}

If (KeyShowHeist != "") {
  Hotkey % KeyShowHeist, ToggleHeist
}

ToggleHeist() {
 
}
