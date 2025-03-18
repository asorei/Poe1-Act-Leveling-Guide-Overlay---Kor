DrawZone() {
  global

  Gui, Controls:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndControls
  Gui, Controls:Color, %backgroundColor%
  Gui, Controls:Font, s%points%, %font%
  Gui, Controls:Add, DropDownList, VCurrentZone GzoneSelectUI x0 y0 w%act_width% h300 , % GetDelimitedZoneListString(data.zones, CurrentAct)
  Gui, Controls:Add, DropDownList, VCurrentAct GactSelectUI x+%controlSpace% y0 w%nav_width% h200 , % GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
  Gui, Controls:Add, DropDownList, VCurrentPart GpartSelectUI x+%controlSpace% y0 w%part_width% h200 , % GetDelimitedPartListString(data.parts, CurrentPart)
  ;xPos := xPosLayoutParent + (maxImages * (images_width+controlSpace))
  control_width := nav_width + part_width + act_width + (controlSpace*2)
  xPos := Round( (A_ScreenWidth * guideXoffset) - control_width )
  yPos := controlSpace + (A_ScreenHeight * guideYoffset)
  Gui, Controls:Show, h%control_height% w%control_width% x%xPos% y%yPos% NA, Controls

  ;Gui, Gems:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGems
  ;Gui, Gems:Color, %backgroundColor%
  ;Gui, Gems:Font, s%points%, %font%
  ;Gui, Gems:Add, DropDownList, Sort VCurrentGem GgemSelectUI x0 y0 w%gems_width% h300 , % GetDelimitedPartListString(gemFiles, CurrentGem)
  ;Gui, Gems:Show, h%control_height% w%gems_width% x%xPosGems% y%yPosGems% NA, Gems

  Gui, Level:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndLevel
  Gui, Level:Color, %backgroundColor%
  Gui, Level:Font, s%points%, %font%
  Gui, Level:Add, Edit, x0 y0 h%control_height% w%level_width% r1 GlevelSelectUI, Level
  Gui, Level:Add, UpDown, x%controlSpace% vCurrentLevel GlevelSelectUI Range1-100, %CurrentLevel%
  Gui, Level:Show, h%control_height% w%level_width% x%xPosLevel% y%yPosLevel% NA, Level

  ;The names of the images have to be created now so that ShowAllWindows doesn't make empty ones that show up in the Alt Tab bar
  Loop, % maxImages {
    Gui, Image%A_index%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%newIndex%Window
  }
}

DrawAtlas() {
  global

}

DrawTree() {
  global

}

DrawExp(){
  global

  Gui, Exp:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndExp
  Gui, Exp:font, cFFFFFF s%points% w%boldness%, %font%
  Gui, Exp:Color, %backgroundColor%
  WinSet, Transparent, %opacity%

  calcExp := "Exp: 100.0%   Over: +10"

  CurrentExp = ""
  Gui, Exp:Add, Text, vCurrentExp x3 y3, % calcExp

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%control_height% NA, Gui Exp
}

GetDelimitedPartListString(data, part) {
  dList := ""
  For key, partItem in data {
    dList .= partItem . "|"
    If ( InStr(partItem,part) ) {
    ;If (partItem = part) {
      dList .= "|"
    }
  }
  Return dList
}

GetDelimitedActListString(data, act, part) {
  dList := ""
  If (numPart != 3) {
    For key, zoneGroup in data {
      If (zoneGroup.part = part) {
        dList .= zoneGroup.act . "|"
      }
      If (zoneGroup.act = act) {
        dList .= "|"
      }
    }
  } Else {
    
  }
  Return dList
}

GetDelimitedZoneListString(data, act) {
  dList := ""
  If (numPart != 3) {
    For key, zoneGroup in data {
      If (zoneGroup.act = act) {
        For k, val in zoneGroup.list {                  
          dList .= val . "|"
          If (val = CurrentZone) {
            dList .= "|"
          }
        }
        break
      }
    }
  } Else {
    For key, value in Maps {
      dList .= key . "|"
      If (key = CurrentZone) {
        dList .= "|"
      }
    }
  }
  Return dList
}

partSelectUI() {
  global
  Gui, Controls:Submit, NoHide

  If (CurrentPart = "Part 1") {
    CurrentAct := "Act 1"
    numPart := 1
  } Else If (CurrentPart = "Part 2") {
    CurrentAct := "Act 6"
    numPart := 2
  } Else {
    CurrentZone := "Academy Map"
    numPart := 3
  }

  GuiControl,,CurrentAct, % "|" test := GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
  Sleep 100

  If (numPart != 3) {
    CurrentZone := GetDefaultZone(data.zones, CurrentAct)
  }
  GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)
  Sleep 100
  If (numPart != 3) {
    SetGuide()
    SetNotes()
    If (zone_toggle = 1) {
      UpdateImages()
    }
  } Else {
    
  }
  SetExp()

  trigger := 1
  WinActivate, ahk_id %PoEWindowHwnd%

  SaveState()
}

actSelectUI() {
  global
  Gui, Controls:Submit, NoHide

  If (numPart != 3){
    CurrentZone := GetDefaultZone(data.zones, CurrentAct)
    GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)
    Sleep 100
    SetGuide()
    SetNotes()
    If (zone_toggle = 1) {
      UpdateImages()
    }
  } Else { ;This shouldn't happen for this version until we re-enable maps
    
  }
  SetExp()
  WinActivate, ahk_id %PoEWindowHwnd%
  SaveState()
}

zoneSelectUI() {
  global
  Gui, Controls:Submit, NoHide
  Sleep 100
  If (numPart != 3) {
    SetNotes()
    If (zone_toggle = 1) {
      UpdateImages()
    }
  } Else {
    
  }
  SetExp()
  WinActivate, ahk_id %PoEWindowHwnd%
  SaveState()
}

levelSelectUI() {
  global
  Gui, Level:Submit, NoHide
  SetExp()
  SaveState()
}

gemSelectUI() {
  global
}

GetDefaultZone(zones, act) {
  For key, zoneGroup in zones {
    If (zoneGroup.act = act) {
      Return zoneGroup.default
    }
  }
}

global kzone := {"황혼의 해안":"Twilight Strand","해안 지대":"The Coast","갯벌":"Mud Flats","물결 섬":"Tidal Island","악취 나는 웅덩이":"Fetid Pool","물에 잠긴 길":"Submerged Passage","바위 턱":"The Ledge","물에 잠긴 심연":"Flooded Depths","고개":"The Climb","수용소 하층":"Lower Prison","수용소 상층":"Upper Prison","죄수의 문":"Prisoner's Gate","배들의 묘지":"Ship Graveyard","진노의 암굴":"Cavern of Wrath","분노의 암굴":"Cavern of Anger","남쪽 숲":"Southern Forest","버려진 경작지":"Old Fields","굴":"The Den","갈림길":"The Crossroads","죄악의 방 1층":"Chamber of Sins Level 1","죄악의 방 2층":"Chamber of Sins Level 2","부서진 다리":"Broken Bridge","몰락한 성소 유적":"Fellshrine Ruins","지하실":"The Crypt","강변길":"The Riverways","서쪽 숲":"Western Forest","거미의 방":"Weaver's Chambers","습지대":"The Wetlands","바알 유적":"Vaal Ruins","북쪽 숲":"Northern Forest","공포의 잡목림":"Dread Thicket":"암굴":"The Caverns","고대 피라미드":"Ancient Pyramid","사안 시내":"City of Sarn","빈민가":"The Slums","화장터":"The Crematorium","하수도":"The Sewers","장터":"The Marketplace","지하 묘지":"The Catacombs","전쟁터":"The Battlefront","항구":"The Docks","솔라리스 사원 1층":"Solaris Temple Level 1","솔라리스 사원 2층":"Solaris Temple Level 2","칠흑의 군단 주둔지":"Ebony Barracks","루나리스 사원 1층":"Lunaris Temple Level 1","루나리스 사원 2층":"Lunaris Temple Level 2","황실 정원":"Imperial Gardens","도서관":"The Library","문서 보관소":"The Archives","신의 셉터":"Sceptre of God","신의 셉터 상층":"Upper Sceptre of God","수로":"The Aqueduct","말라붙은 호수":"Dried Lake","광산 1층":"Mines Level 1","광산 2층":"Mines Level 2","수정 광맥":"Crystal Veins","다레소의 꿈":"Daresso's Dream","대 투기장":"Grand Arena","카옴의 꿈":"Kaom's Dream","카옴의 요새":"Kaom's Stronghold","짐승의 소굴 1층":"Belly of the Beast Level 1","짐승의 소굴 2층":"Belly of the Beast Level 2","수확소":"The Harvest","오르막길":"The Ascent","노예 감호소":"Slave Pens","관리 구역":"Control Blocks","오리아스 광장":"Oriath Square","템플러의 법정":"Templar Courts","결백의 방":"Chamber of Innocence","타오르는 법정":"Torched Courts","멸망한 광장":"Ruined Square","납골당":"The Ossuary","성유물 보관실":"The Reliquary","대성당 옥상":"Cathedral Rooftop","카루이 요새":"Karui Fortress","산등성이":"The Ridge","샤브론의 탑":"Shavronne's Tower","등대":"The Beacon","염수왕의 암초":"Brine King's Reef","지하실 2층":"The Crypt 2","말리가로의 지성소":"Maligaro's Sanctum","잿빛 들판":"Ashen Fields","둑길":"The Causeway","바알 도시":"Vaal City","부패의 사원":"Temple of Decay","사안 성벽":"Sarn Ramparts","독성 도관":"Toxic Conduits","도이드리의 정화조":"Doedre's Cesspool","대 산책로":"Grand Promenade","목욕탕":"Bath House","고층 정원":"High Gardens","루나리스 중앙 광장":"Lunaris Concourse","부두":"The Quay","곡물의 문":"Grain Gate","황실 정원":"Imperial Fields","솔라리스  중앙 광장":"Solaris Concourse","항구 다리":"Harbour Bridge","피의 수로":"Blood Aqueduct","비탈":"The Descent","바스티리 사막":"Vastiri Desert","오아시스":"The Oasis","구릉":"The Foothills","끓어오르는 호수":"Boiling Lake","터널":"The Tunnel","채석장":"The Quarry","제련소":"The Refinery","짐승의 소굴":"Belly of the Beast","썩어가는 중심부":"Rotting Core","파괴된 광장":"Ravaged Square","무너진 방":"Desecrated Chambers","운하":"The Canals","먹이통":"Feeding Trough"}

UpdateImages()
{
  global
  emptySpaces := 0
  Loop, % maxImages {
	  imageIndex := (maxImages - A_Index) + 1
    StringTrimLeft, ImageName, CurrentZone, 3
    ;MsgBox, % ImageName
    ImageName := kzone[ImageName]  
    filepath := "" A_ScriptDir "\images\" CurrentAct "\" ImageName "_Seed_" imageIndex ".jpg" ""

	  newIndex := A_index - emptySpaces
	  ;This shouldn't happen anymore but if this method gets called twice quickly newIndex goes below 0
	  If (newIndex < 1) {
	    newIndex := 1
	  }
    Gui, Image%newIndex%:Destroy ;I'm not sure this will work
    
    If (FileExist(filepath)) {
      ;xPos := xPosLayoutParent + ((maxImages - (newIndex + 0)) * (images_width+controlSpace))
      Gui, Image%newIndex%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%newIndex%Window
      Gui, Image%newIndex%:Add, Picture, x0 y0 w%images_width% h%images_height%, %filepath%
      If (xPosImages = 0) {
        If (hideNotes != "True") {
          xPos := xPosNotes - (newIndex * (images_width+controlSpace))
        } Else {
          If (hideGuide != "True"){
            xPos := xPosGuide - (newIndex * (images_width+controlSpace))
          } Else {
            xPos := Round( (A_ScreenWidth * guideXoffset)) - (newIndex * (images_width+controlSpace))
          }
        }
        yPosImages := yPosNotes
      } Else {
        xPos := xPosImages - (newIndex * (images_width+controlSpace))
      }
      Gui, Image%newIndex%:Show, w%images_width% h%images_height% x%xPos% y%yPosImages% NA, Image%newIndex%
      id := Image%newIndex%Window
      WinSet, Transparent, %opacity%, ahk_id %id%
      Gui, Image%newIndex%:Cancel
    }
    Else {
	    emptySpaces++
      ;Have to show the image to make it invisible (in case zone_toggle is off)
      Gui, Image%imageIndex%:Show, NA
      hideId := Image%imageIndex%Window
      WinSet, Transparent, 0, ahk_id %hideId%
      Gui, Image%imageIndex%:Cancel
    }
  }
}
