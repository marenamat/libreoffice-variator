Type VarVar
  Letter As String
  Num As Integer
End Type

Function VarNameSplit (Name as String) As VarVar
  Dim V As New VarVar
  If Left(Name, 8) = "Variant " Then
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
      MsgBox "Found section " & VN.Num & ", variant " & VN.Letter
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
      Vars(VN.Num-VarMin).Letter = Vars(VN.Num-VarMin).Letter & VN.Letter
    End If
  Next B

  For I = 0 To UBound(Vars)
    MsgBox "Section " & Vars(I).Num & " has variants " & Vars(I).Letter
  Next I

  LoadVariants = Vars
End Function

Sub Main
  Dim Vars as Variant
  Vars = LoadVariants()

  For I = 0 To UBound(Vars)
    MsgBox "Section " & Vars(I).Num & " has variants " & Vars(I).Letter
  Next I

'      C = ThisComponent.Text.createTextCursorByRange(B.Anchor)
'      C.String = "B " & B.Name & " – " & " – EOB"
End Sub
