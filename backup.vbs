Option Explicit

Dim fso
Dim shell
Dim sourceFile, folder, historyFolder
Dim fileName, extension, stamp, destFile
Dim y, m, d, hh, nn, ss
Dim psCmd

If WScript.Arguments.Count = 0 Then
    WScript.Quit
End If

sourceFile = WScript.Arguments(0)

Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

If Not fso.FileExists(sourceFile) Then
    Call Toast("Backup failed", "File not found")
    WScript.Quit 1
End If

folder = fso.GetParentFolderName(sourceFile)
historyFolder = folder & "\.history"

If Not fso.FolderExists(historyFolder) Then
    fso.CreateFolder historyFolder
End If

fileName = fso.GetBaseName(sourceFile)

If InStrRev(sourceFile, ".") > InStrRev(sourceFile, "\") Then
    extension = "." & fso.GetExtensionName(sourceFile)
Else
    extension = ""
End If

' ===== timestamp YYMMDDHHmmss =====
y = Right(Year(Now), 2)
m = Right("0" & Month(Now), 2)
d = Right("0" & Day(Now), 2)
hh = Right("0" & Hour(Now), 2)
nn = Right("0" & Minute(Now), 2)
ss = Right("0" & Second(Now), 2)

stamp = y & m & d & hh & nn & ss

destFile = historyFolder & "\" & fileName & "_" & stamp & extension

On Error Resume Next
fso.CopyFile sourceFile, destFile, False

If Err.Number <> 0 Then
    Call Toast("Backup failed", Err.Description)
    WScript.Quit 1
End If

On Error GoTo 0

Call Toast("Backup completed", fso.GetFileName(destFile))

' =========================
' Toast function (Windows standard PowerShell)
' =========================
Sub Toast(title, message)

    psCmd = ""
    psCmd = psCmd & "powershell -NoProfile -ExecutionPolicy Bypass -Command "
    psCmd = psCmd & """"
    psCmd = psCmd & "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null;"
    psCmd = psCmd & "$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02;"
    psCmd = psCmd & "$xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template);"
    psCmd = psCmd & "$text = $xml.GetElementsByTagName('text');"
    psCmd = psCmd & "$text.Item(0).AppendChild($xml.CreateTextNode('" & title & "')) | Out-Null;"
    psCmd = psCmd & "$text.Item(1).AppendChild($xml.CreateTextNode('" & message & "')) | Out-Null;"
    psCmd = psCmd & "$toast = [Windows.UI.Notifications.ToastNotification]::new($xml);"
    psCmd = psCmd & "$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Backup Tool');"
    psCmd = psCmd & "$notifier.Show($toast)"
    psCmd = psCmd & """"

    shell.Run psCmd, 0, False

End Sub