#NoTrayIcon
#SingleInstance Force
SetBatchLines, -1

; --- URL beolvasása parancssori argumentumból ---
url := ""
if (A_Args.Length() >= 1) {
    url := A_Args[1]
}

; Ha nincs argumentum, akkor kilép (opcionálisan logolhatnánk is)
if (url = "") {
    ExitApp
}

; --- Desktop útvonal ---
desktop := A_Desktop

; --- Dátum stamp (fájlnévhez biztonságos formátum) ---
FormatTime, stamp,, yyyy-MM-dd_HH-mm-ss

; --- Fájlnév ---
filePath := desktop . "\click_" . stamp . ".url"

; --- Ha valamiért már létezne ugyanilyen néven (ritka), kapjon sorszámot ---
if FileExist(filePath)
{
    i := 1
    Loop
    {
        filePath := desktop . "\click_" . stamp . "_" . i . ".url"
        if !FileExist(filePath)
            break
        i++
    }
}

; --- .url (Internet Shortcut) tartalom ---
; Ez egy Windows által ismert "link fájl", dupla kattintásra megnyitható.
content =
(
[InternetShortcut]
URL=%url%
)

; --- Fájl mentése UTF-8-ban ---
FileDelete, %filePath%
FileAppend, %content%, %filePath%, UTF-8

ExitApp
