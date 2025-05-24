Type VarVar
  Letter As String
  Num As Integer
  Bookmarks(26) As Variant
  Stored(26) As Variant
End Type

Function VarNameSplit (Name as String) As VarVar
  Dim V As New VarVar
  If Name <> "Variant ID" And Left(Name, 8) = "Variant " Then
    V.Letter = Right(Name, 1)
    V.Num = CInt(Mid(Name, 9, Len(Name)-9))
  End If
  VarNameSplit = V
End Function

Function LoadVariants As Variant
  Dim VarMax, VarMin As Integer
  VarMax = 0
  VarMin = 42

  Dim VN As VarVar

  For Each B In ThisComponent.Bookmarks
    VN = VarNameSplit(B.Name)
    If Len(VN.Letter) = 1 Then
'      MsgBox "Found section " & VN.Num & ", variant " & VN.Letter
      If VN.Num > VarMax Then
	VarMax = VN.Num
      End If
      If VN.Num < VarMin Then
	VarMin = VN.Num
      End If
    End If
  Next B

  Dim Vars(VarMax - VarMin) As VarVar
  For I = 0 To VarMax - VarMin
    Vars(I) = New VarVar
  Next I

  For Each B In ThisComponent.Bookmarks
    VN = VarNameSplit(B.Name)
    If Len(VN.Letter) = 1 Then
      Vars(VN.Num-VarMin).Num = VN.Num
      Vars(VN.Num-VarMin).Bookmarks(Len(Vars(VN.Num-VarMin).Letter)) = B
      Vars(VN.Num-VarMin).Letter = Vars(VN.Num-VarMin).Letter & VN.Letter
    End If
  Next B

'  For I = 0 To UBound(Vars)
'    MsgBox "Section " & Vars(I).Num & " has variants " & Vars(I).Letter
'  Next I

  LoadVariants = Vars
End Function

Sub Generate (Vars as Variant, Cur() as Integer, path as String)
  Dim Info as String
  Dim VN as Integer
  Dim Varmin as Integer
  Info = ""
  VN = UBound(Vars)
  VarMin = Vars(0).Num

  For I = 0 To VN
    Info = Info & Mid(Vars(I).Letter, Cur(I)+1, 1)
  Next I
  MsgBox "Generate " & Info

  Dim Undo
  Undo = ThisComponent.getUndoManager()
  Undo.enterUndoContext("Generate " & Info)
  For Each B in ThisComponent.Bookmarks
    Dim VNS as VarVar
    If B.Name = "Variant ID" Then
      C = ThisComponent.Text.createTextCursorByRange(B.Anchor)
      C.String = Info
    End If

    VNS = VarNameSplit(B.Name)
    If Len(VNS.Letter) = 1 Then
      Dim LocPos As Integer
      LocPos = VNS.Num - VarMin
      If Mid(Vars(LocPos).Letter, Cur(LocPos) + 1, 1) <> VNS.Letter Then
	C = ThisComponent.Text.createTextCursorByRange(B.Anchor)
	C.String = ""
      End If
    End If
  Next B
  Undo.leaveUndoContext()

  Dim Px as String
  If Right(path, 4) = ".odt" Then
    Px = Left(path, Len(path) - 4) & "-" & Info & ".odt"
  Else
    Px = path & "-" & Info & ".odt"
  End If

  Dim args()
  ThisComponent.storeToUrl(Px, args())
  Undo.undo()

'  Dim doc, args()
'  doc = StarDesktop.loadComponentFromURL("private:factory/swriter", "_blank", 0, args())
'  doc.Text = ThisComponent.Text
'  For Each B In doc.Bookmarks
'    B.String = "I"
'  Next B
'  doc.storeAsURL(Px, args())
'  doc.close(True)
End Sub

Sub ODT
  Dim Vars as Variant
  Vars = LoadVariants()

  Dim VN as Integer
  VN = UBound(Vars)

  Dim Cur(VN) as Integer
  For I = 0 To VN
    MsgBox "Section " & Vars(I).Num & " has variants " & Vars(I).Letter
    Cur(I) = 0
  Next I

  dlg_save = CreateUnoService("com.sun.star.ui.dialogs.FilePicker")
  With dlg_save
    .Initialize(Array(2))
    .AppendFilter("Text documents ODF (.odt)", "*.odt" )
  End With

  Dim path
  If dlg_save.Execute() Then
    path = dlg_save.getFiles()(0)
    MsgBox ConvertFromUrl(path)
  Else
    MsgBox "Failed!"
    Exit Sub
  End If

  Dim Carry as Boolean
  While Not Carry
    Generate(Vars, Cur, path)

    Carry = True
    For I = 0 To VN
      If Carry Then
	Cur(I) = Cur(I) + 1
	If Cur(I) = Len(Vars(I).Letter) Then
	  Cur(I) = 0
	Else
	  Carry = False
	End If
      End If
    Next I
  Wend

'      C = ThisComponent.Text.createTextCursorByRange(B.Anchor)
'      C.String = "B " & B.Name & " – " & " – EOB"
End Sub

Sub PDF
  MsgBox "PeekaBoo!"
End Sub
