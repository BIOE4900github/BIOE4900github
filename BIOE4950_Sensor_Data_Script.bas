Attribute VB_Name = "Sensor_Data_Graph"
Sub Sensor_Data()

Dim WB As Workbook
Dim i As Integer
Dim mChart As Object
Dim tChart As Object
Dim rChart As Object
Dim ser As SeriesCollection
Set WB = ThisWorkbook

' Can't use Sheets() unless it's the active sheet
WB.Sheets.Add(After:=Sheets(Sheets.Count)).Name = "Raw Data Input"
Sheets(2).Activate

HeaderArray2 = Array("Time Stamp", "Time (Hours)", "Sensor 1 MC", "Sensor 2 MC", "Sensor 3 MC", "Sensor 4 MC", "Sensor 5 MC", "Sensor 6 MC", "Sensor 7 MC", "Sensor 8 MC", "Sensor 9 MC", "Sensor 10 MC", "Sensor 11 MC", "Sensor 12 MC", "Sensor 13 MC", "Sensor 14 MC", "Sensor 15 MC")

ActiveSheet.Range("A2:Q2") = HeaderArray2

Sheets(1).Activate
lastrow = Range("A" & Rows.Count).End(xlUp).Row             ' As integer number for row number
Worksheets(2).Range("A3:A" & CStr(lastrow + 1)).Value = Worksheets(1).Range("C2:C" & lastrow).Value

Sheets(2).Activate
lastrow = Range("A" & Rows.Count).End(xlUp).Row

Worksheets(2).Range("B3").Value = 0
Worksheets(2).Range("B4:B" & CStr(lastrow + 1)).Value = "=B3+TIME(0,1,0)"

Columns(2).Select
Selection.NumberFormat = "hh:mm"

i = 0
For Each Cell In Range("C3:Q3")
    Cell.Value = "=IF(" & "'" & Sheets(1).Name & "'!" & Worksheets(1).Cells(2, 1 + i).Address(False, False) & "<9.5,(" & "'" & Sheets(1).Name & "'!" & Worksheets(1).Cells(2, 2 + i).Address(False, False) & "+24.8956)/4.70073,(" & "'" & Sheets(1).Name & "'!" & Worksheets(1).Cells(2, 2 + i).Address(False, False) & "+15.7737)/4.8346)"
    i = i + 3
Next
lastrow = Sheets(2).Range("A" & Rows.Count).End(xlUp).Row
i = 0
For Each Cell In Range("C3:Q3")
    Cell.Select
    Selection.AutoFill Destination:=Range(ActiveCell.Address(False, False) & ":" & Left(ActiveCell.Address(False, False), CStr(Len(ActiveCell.Address(False, False)) - 1)) & lastrow), Type:=xlFillDefault
Next

Set mChart = ActiveSheet.Shapes.AddChart

    With mChart
        .Chart.ChartType = xlXYScatter
        .Name = "Moisture Chart"
        'chart name
        .Chart.HasTitle = True
        .Chart.ChartTitle.Characters.Text = "MC vs Time"
        'X axis name
        .Chart.Axes(xlCategory, xlPrimary).HasTitle = True
        .Chart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "Time (Hours)"
        'y-axis name
        .Chart.Axes(xlValue, xlPrimary).HasTitle = True
        .Chart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "MC (%)"
        
        
        '' Remove any series created with the chart
        Do Until .Chart.SeriesCollection.Count = 0
                .Chart.SeriesCollection(1).Delete
        Loop
        
        For Each Cell In Range("C2:Q2")
            With .Chart.SeriesCollection.NewSeries
                .XValues = ActiveSheet.Range("B3:B" & lastrow)
                .Name = Cell.Value
                Cell.Activate
                .Values = ActiveSheet.Range(ActiveCell.Offset(1, 0).Range("A1").Address(False, False) & ":" & Left(ActiveCell.Address(False, False), CStr(Len(ActiveCell.Address(False, False)) - 1)) & lastrow)
            End With
        Next
        .Chart.SeriesCollection(8).Delete ' Removes sensor 8
    End With
    
Sheets(2).Activate

Set tChart = ActiveSheet.Shapes.AddChart

    With tChart
        .Chart.ChartType = xlXYScatter
        .Name = "Temperature Chart"
                'chart name
        .Chart.HasTitle = True
        .Chart.ChartTitle.Characters.Text = "Temperature vs Time"
        'X axis name
        .Chart.Axes(xlCategory, xlPrimary).HasTitle = True
        .Chart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "Time (Hours)"
        'y-axis name
        .Chart.Axes(xlValue, xlPrimary).HasTitle = True
        .Chart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "Temperature (DegC)"
        
        '' Remove any series created with the chart
        Do Until .Chart.SeriesCollection.Count = 0
                .Chart.SeriesCollection(1).Delete
        Loop
        
        For Each Cell In Worksheets(1).Range("A1:AS1")
            caseArray = Array(1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43)
            For Each element In caseArray
                If Cell.Column = element Then
                    With .Chart.SeriesCollection.NewSeries
                        .XValues = Worksheets(2).Range("B3:B" & lastrow)
                        .Name = Cell.Value
                        Sheets(1).Activate
                        Cell.Activate
                        .Values = ActiveSheet.Range(ActiveCell.Offset(1, 0).Range("A1").Address(False, False) & ":" & Left(ActiveCell.Address(False, False), CStr(Len(ActiveCell.Address(False, False)) - 1)) & lastrow)
                    End With
                End If
            Next
        Next
        .Chart.SeriesCollection(8).Delete ' Removes sensor 8
    End With
    
Sheets(2).Activate

Set rChart = ActiveSheet.Shapes.AddChart

    With rChart
        .Chart.ChartType = xlXYScatter
        .Name = "RH Chart"
                'chart name
        .Chart.HasTitle = True
        .Chart.ChartTitle.Characters.Text = "RH vs Time"
        'X axis name
        .Chart.Axes(xlCategory, xlPrimary).HasTitle = True
        .Chart.Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "Time (Hours)"
        'y-axis name
        .Chart.Axes(xlValue, xlPrimary).HasTitle = True
        .Chart.Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "RH (%)"
        
        '' Remove any series created with the chart
        Do Until .Chart.SeriesCollection.Count = 0
                .Chart.SeriesCollection(1).Delete
        Loop
        
        For Each Cell In Worksheets(1).Range("A1:AS1")
            caseArray = Array(2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44)
            For Each element In caseArray
                If Cell.Column = element Then
                    With .Chart.SeriesCollection.NewSeries
                        .XValues = Worksheets(2).Range("B3:B" & lastrow)
                        .Name = Cell.Value
                        Sheets(1).Activate
                        Cell.Activate
                        .Values = ActiveSheet.Range(ActiveCell.Offset(1, 0).Range("A1").Address(False, False) & ":" & Left(ActiveCell.Address(False, False), CStr(Len(ActiveCell.Address(False, False)) - 1)) & lastrow)
                    End With
                End If
            Next
        Next
        .Chart.SeriesCollection(8).Delete ' Removes sensor 8
    End With

End Sub
