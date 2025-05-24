Sub Main
  Dim Bmk As Object
  Bmk = ThisComponent.Bookmarks
  For Each B in Bmk:
    C = ThisComponent.Text.createTextCursorByRange(B.Anchor)
    C.String = "B " & B.Name & " – " & C.String & " – EOB"
  Next B
End Sub
