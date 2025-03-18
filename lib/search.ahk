RotateAct(direction, acts, current) {
  global
  newAct := ""
  indexShift := direction = "next" ? 1 : -1
  first := ""
  last := ""

  Loop, % acts.Length()
  {
    If (A_Index = 1) {
      first := acts[A_Index]
    }
    If (A_Index = acts.MaxIndex()) {
      last := acts[A_Index]
    }

    If (acts[A_Index] = current) {
      newAct := acts[A_Index + indexShift]
    }
  }

  If (not StrLen(newAct)) {
    newAct := direction = "next" ? first : last
  }

  Return newAct
}

RotateZone(direction, zones, act, current) {
    newZone := ""
    indexShift := direction = "next" ? 1 : -1
    first := ""
    last := ""

    For key, zone in zones {
        If (zone.act = act) {
            Loop, % zone["list"].Length()
            {
                If (A_Index = 1) {
                    first := zone.list[A_Index]
                }
                If (A_Index = zone.list.MaxIndex()) {
                    last := zone.list[A_Index]
                }

                If (zone.list[A_Index] = current) {
                    newZone := zone.list[A_Index + indexShift]
                }
            }
            break
        }
	}

    If (not StrLen(newZone)) {
        newZone := direction = "next" ? first : last
    }

    Return newZone
}

; global checkZone := {"부두":"오리아스 부두"}

SearchLog() {
  global
  ;Only bother checking if the newLogLines has changed or someone manually changed Part
  newLogLines := client_txt_file.Read()
  If (trigger) {
    trigger := 0
    newLogLines := LastLogLines
  }
  If (newLogLines) {
    levelUp := charName ;check character name is present first
    IfInString, newLogLines, %levelUp%
    {
      ;levelUp := "is now level"
      levelUp := "레벨이"

      IfInString, newLogLines, %levelUp%
      {
        levelPos := InStr(newLogLines, levelUp, false)
        newLevel := Trim(SubStr(newLogLines, levelPos-2, 2))
        newLevel += 0 ; force the string to be an int, clearing any space
        nextLevel := newLevel + 1
        ;So levels stay in order
        If (newLevel < 10)
        {
          newLevel := "0" . newLevel
        }
        If (nextLevel < 10)
        {
          nextLevel := "0" . nextLevel
        }
        GuiControl,Level:,CurrentLevel, %newLevel%
        Sleep, 100
        gemFiles := []
        Loop %A_ScriptDir%\builds\%overlayFolder%\gems\*.ini
        {
          tempFileName = %A_LoopFileName%
          StringTrimRight, tempFileName, tempFileName, 4
          If (tempFileName != "meta" and tempFileName != "class") 
          {
            gemFiles.Push(tempFileName)
          }
        }
        For index, someLevel in gemFiles
        {
          If ( InStr(someLevel,newLevel) || InStr(someLevel,nextLevel) ) 
          {
            GuiControl,Gems:,CurrentGem, % "|" test := GetDelimitedPartListString(gemFiles, someLevel)
            Sleep, 100
            Gui, Gems:Submit, NoHide
            If (gems_toggle) 
            {
              SetGems()
            }
            break
          }
        }
        SaveState()
      }
      ;beenSlain := "has been slain"
      beenSlain := "사망했"
      IfInString, newLogLines, %beenSlain%
      {
        Sleep, 5000
        Send, %KeyOnDeath%
      }
    } ;end level up logic

    ;travel := "You have entered" ; deprecated by the following line but leaving in for a league to make sure it doesn't break for people
    travel := "에 진입"

    ;travel := "Generating level" ;  (Delete this line if zones are not auto updating) Generating level now shows more detail than you have entered
    generated := "Generating level"
    If ( InStr(newLogLines,travel) || InStr(newLogLines,generated) ) ;remove the travel search if no one complains
    {
      If ( autoToggleZoneImages = "True" )
      {
        zone_toggle := 1
        ;places_disabled_zones :=  ["Hideout","Rogue Harbour", "Oriath", "Lioneye's Watch", "The Forest Encampment", "The Sarn Encampment", "Highgate", "Overseer's Tower", "The Bridge Encampment", "Oriath Docks"]
        places_disabled_zones :=  ["은신처","도둑 항구", "오리아스", "라이온아이 초소", "숲 야영지", "사안 야영지", "하이게이트", "감시탑", "다리 야영지", "오리아스 부두"]
        For _, zone in places_disabled_zones
          IfInString, newLogLines, %zone% 
          {
            zone_toggle := 0
            break
          }
      }
      activeCount := 0
      active_toggle := 1

      If(InStr(newLogLines,generated)){
        generatedHappened := 1
        levelPos := InStr(newLogLines, generated, false)
        lastMonsterLevel := monsterLevel
        monsterLevel := SubStr(newLogLines, levelPos+17, 2)
      } Else {
        If(generatedHappened != 1){
          monsterLevel := -1
        }
        generatedHappened := 0
        ;If(InStr(newLogLines,"Hideout")) ;reset exp if traveling to hideout
        If(InStr(newLogLines,"은신처")) ;reset exp if traveling to hideout
        {
          monsterLevel := lastMonsterLevel
        }
      }

      ;newPartTest := "Lioneye's Watch"
      newPartTest := "라이온아이 초소"
      IfInString, newLogLines, %newPartTest%
      {
        act5LastZone := "45 대성당 옥상"
        If (CurrentZone = act5LastZone)
        {
          numPart := 2
          CurrentPart := "Part 2"
          GuiControl, Controls:Choose, CurrentPart, % "|" CurrentPart
        }
      }

      ;newPartTest := "Aspirants' Plaza"
      newPartTest := "지망자의 광장"
      IfInString, newLogLines, %newPartTest%
      {
        CurrentZone := "00 지망자의 광장"
        ; GuiControl, Controls:Choose, CurrentZone, % "|" CurrentZone
        SetNotes()
        return
      }

      newAct := CurrentAct
      If (numPart != 3) 
      {
        ;loop through all of the acts in the current part
        Loop, 6 
        {
          For key, zoneGroup in data.zones 
          {
            If (zoneGroup.act = newAct) 
            {
              For k, newZone in zoneGroup.list 
              {
                StringTrimLeft, zoneSearch, newZone, 3                              
                IfInString, newLogLines, %zoneSearch%
                {
		  If (zoneSearch = "부두")
                  {
                    IfInString, newLogLines, "오리아스 부두"
                      break
                  }
                  If (newAct != CurrentAct) 
                  {
                    GuiControl, Controls:Choose, CurrentAct, % "|" newAct
                    CurrentAct := newAct
                    Sleep 100
                  }
                  LastLogLines := StrReplace(newLogLines, "`r`n")
                  GuiControl, Controls:Choose, CurrentZone, % "|" newZone
                  CurrentZone := newZone
                  Sleep 100
                  UpdateImages()
                  break 3
                }
              }
              If (numPart = 1)
              {
                actData := data.p1acts
              } Else If (numPart = 2) 
              {
                actData := data.p2acts
              }
              newAct := RotateAct("next", actData, newAct)
              break
            }
          }
        }
      } Else ;This can stay for now but maps will be disabled in this version for now
      {
        
      }
    } ;end travel logic

    If (level_toggle) 
    {
      SetExp()
    }
  }
}
