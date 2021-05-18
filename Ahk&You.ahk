#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
width  := a_screenwidth/3,height:= a_screenheight/3

Gui, +hwndhGui +AlwaysOnTop -caption
Gui, Color, 191919
Gui, Add, ActiveX, x5 y5 w%width% h%height% vWB, Shell.Explorer
Gui, Add, Picture, h5 w%width%, %A_ScriptDir%\Fotolar\IMG_1336.png
Gui, Add, Edit, w%width% h20 vMyEdit gMyEdit,
Gui, Add, Picture, h5 w%width%, %A_ScriptDir%\Fotolar\IMG_1336.png
Gui, Font, S11 CDefault Bold, Verdana
Gui, Add , Picture, x5 y315 w70 h30 vState1 icon1 gVol-, %A_ScriptDir%\Fotolar\button_vol.ico
Gui, Add , Picture, x5 y315 w70 h30 vState0 icon1 gVol-, %A_ScriptDir%\Fotolar\button_vol (1).ico
Gui, Add , Picture, x76 y315 w70 h30 vState2 icon1 gVol+, %A_ScriptDir%\Fotolar\button_vol (2).ico
Gui, Add , Picture, x76 y315 w70 h30 vState3 icon1 gVol+, %A_ScriptDir%\Fotolar\button_vol (3).ico
Gui, Add , Picture, x147 y315 w171 h30 vState4 icon1 gPlay, %A_ScriptDir%\Fotolar\button_play.ico
Gui, Add , Picture, x147 y315 w171 h30 vState5 icon1 gPlay, %A_ScriptDir%\Fotolar\button_play (1).ico
Gui, Add, Picture, x319 y315 w70 h30 vState6 icon1 gMin, %A_ScriptDir%\Fotolar\button.ico
Gui, Add, Picture, x319 y315 w70 h30 vState7 icon1 gMin, %A_ScriptDir%\Fotolar\button (1).ico
Gui, Add, Picture, x390 y315 w70 h30 vState8 icon1 gKapat, %A_ScriptDir%\Fotolar\button_x.ico
Gui, Add, Picture, x390 y315 w70 h30 vState9 icon1 gKapat, %A_ScriptDir%\Fotolar\button_x (1).ico
Gui, Add, Picture, x0 y0 h400 w3, %A_ScriptDir%\Fotolar\IMG_15098.png
Gui, Add, Picture, x461 y0 h400 w3, %A_ScriptDir%\Fotolar\IMG_15098.png
Gui, Add, Picture, x0 y0 h3 w465, %A_ScriptDir%\Fotolar\IMG_1510.png
Gui, Add, Picture, x0 y395 h5 w465, %A_ScriptDir%\Fotolar\IMG_1336.png
Gui, Show, xCenter yCenter h400 w465,
Return



Play:
GuiControl, Hide, State5
Sleep, 250
GuiControl, Show, State5
Sleep, 100

	Clipboard =
	varEnd =
	GuiControlGet, MyEdit
	Output := StrReplace(MyEdit, A_Tab, "https://www.youtube.com/embed/")
	Output := StrReplace(Output, "https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")
	Output := StrReplace(Output, "https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")
	Loop, Parse, Output, `n, `r
	{
		Trimmed := RTrim(A_LoopField, "/")
		varEnd .= Trimmed "`n"
	}

	Clipboard = %varEnd%

url = %Clipboard%?autoplay=1&feature=oembed&rel="0"&frameborder="0"&allowfullscreen
WB.Navigate(URL)
Return

MyEdit:
url1 := % Clipboard

Whr := ComObjCreate("Msxml2.XMLHTTP.6.0")
Whr.Open("GET", url1, false)
Whr.SetRequestHeader( "User-Agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36"
                    . " (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36 Edg/89.0.774.63" )
Whr.Send()
status := Whr.status
if (status != 200)
   throw "HttpRequest error, status: " . status

Arr := Whr.responseBody
pData := NumGet(ComObjValue(arr) + 8 + A_PtrSize)
length := arr.MaxIndex() + 1
html := StrGet(pData, length, "UTF-8")

Doc := ComObjCreate("htmlfile")
Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
Doc.write(html)
title := Doc.querySelector("title").innerText
Gui, Font, S9 Ccecfc8 Bold, Verdana
Gui, Add, Text, x10 y360 w455, %title%
Return

Vol-:
GuiControl, Hide, State0
Sleep, 250
GuiControl, Show, State0
Sleep, 100
SoundSet, -10
Return

Vol+:
GuiControl, Hide, State3
Sleep, 250
GuiControl, Show, State3
Sleep, 100
SoundSet, +10
Return

Min:
GuiControl, Hide, State7
Sleep, 250
GuiControl, Show, State7
Sleep, 100
WinMinimize
Return

Kapat:
GuiControl, Hide, State9
Sleep, 250
GuiControl, Show, State9
Sleep, 100
GuiClose:
ExitApp
Return


WM_LBUTTONDOWN(wParam, lParam, msg, hWnd)
{
    static init := OnMessage(0x0201, "WM_LBUTTONDOWN")
    global hGui
    if (hwnd = hGui)
        DllCall("user32.dll\PostMessage", "ptr", hGui, "uint", 0x00A1, "ptr", 2, "ptr", 0)
}