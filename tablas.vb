Public Class tablas
    Function tabla(ByVal dtTabla As DataTable, ByVal titulo As String, _
    Optional ByVal conHyperlink As Boolean = False, Optional ByVal quitarColumna As String = "") As Table

        Dim principal As Table, dgReporte As New DataGrid
        Dim ColumndgReporte As BoundColumn, vinculo As HyperLinkColumn
        Try

            With dgReporte
                .AutoGenerateColumns = False
                .BorderColor = ColorTranslator.FromHtml("#E7E7FF")
                .CssClass = "Tabla"
                .ShowFooter = True
                .CellPadding = 3
                .BorderWidth = Unit.Pixel(1)
            End With
            With dgReporte.HeaderStyle
                .BackColor = ColorTranslator.FromHtml("#000084")
                .Font.Bold = True
                .ForeColor = ColorTranslator.FromHtml("#FFFFFF")
                .HorizontalAlign = HorizontalAlign.Center
            End With
            '*****FooterStyle*****'
            With dgReporte.FooterStyle
                .BackColor = ColorTranslator.FromHtml("#CCCCCC")
                .Font.Bold = True
                .Font.Size = FontUnit.Point(12)
                .ForeColor = Color.Black
                .HorizontalAlign = HorizontalAlign.Center
            End With
            With dgReporte.ItemStyle
                .BackColor = ColorTranslator.FromHtml("#EEEEEE")
                .ForeColor = ColorTranslator.FromHtml("#000000")
            End With
            With dgReporte.SelectedItemStyle
                .BackColor = ColorTranslator.FromHtml("#738A9C")
                .ForeColor = ColorTranslator.FromHtml("#F7F7F7")
            End With
            With dgReporte.AlternatingItemStyle
                .BackColor = ColorTranslator.FromHtml("#DCDCDC")
            End With

            If conHyperlink Then
                vinculo = New HyperLinkColumn
                With vinculo
                    .HeaderText = dtTabla.Columns(0).ColumnName
                    .DataTextField = dtTabla.Columns(0).ColumnName

                    '.Text = "<font color=blue><b>" & dtTabla.Columns(0).ColumnName & "</b></font>"
                    .DataNavigateUrlField = "url"
                    .ItemStyle.ForeColor = Color.Blue
                End With
                dgReporte.Columns.Add(vinculo)
                For i As Integer = 1 To dtTabla.Columns.Count - 1
                    ColumndgReporte = New BoundColumn
                    If dtTabla.Columns(i).ColumnName.ToUpper <> "URL" And _
                    dtTabla.Columns(i).ColumnName.ToUpper <> quitarColumna.ToUpper Then
                        With ColumndgReporte
                            .HeaderText = dtTabla.Columns(i).ColumnName
                            .DataField = dtTabla.Columns(i).ColumnName
                        End With
                        dgReporte.Columns.Add(ColumndgReporte)
                    End If
                Next

            Else
                For i As Integer = 0 To dtTabla.Columns.Count - 1
                    ColumndgReporte = New BoundColumn
                    If dtTabla.Columns(i).ColumnName.ToUpper <> "URL" And _
                    dtTabla.Columns(i).ColumnName.ToUpper <> quitarColumna Then
                        With ColumndgReporte
                            .HeaderText = dtTabla.Columns(i).ColumnName
                            .DataField = dtTabla.Columns(i).ColumnName
                        End With
                        dgReporte.Columns.Add(ColumndgReporte)
                    End If
                Next


            End If



            AddHandler dgReporte.ItemDataBound, AddressOf dgReporte_ItemDataBound
            dgReporte.DataSource = dtTabla
            dgReporte.Columns(0).FooterText = dtTabla.Rows.Count.ToString & " Registro(s)"
            dgReporte.DataBind()

            principal = New Table
            principal.CssClass = "tabla"
            principal.Width = Unit.Percentage(80)

            principal.Rows.Add(New TableRow)

            With principal.Rows(0)
                .Cells.Add(New TableCell)
                .Cells(0).Text = "<font size = 3 color = blue><b>" & _
                titulo.ToUpper & "</b></font>"
            End With


            principal.Rows.Add(New TableRow)
            With principal.Rows(1)
                .Width = Unit.Percentage(100)
                .Cells.Add(New TableCell)
                .Cells(0).Width = Unit.Percentage(100)
                .Cells(0).Controls.Add(dgReporte)
            End With

            Return principal
        Catch ex As Exception
             Throw New ArgumentNullException(ex.Message)
        End Try
    End Function
    Private Sub dgReporte_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)


        If e.Item.ItemType = ListItemType.Footer Then
            For index As Integer = 1 To e.Item.Cells.Count - 1
                e.Item.Cells(index).Visible = False
            Next
            e.Item.Cells(0).ColumnSpan = e.Item.Cells.Count
        End If
        If e.Item.ItemType = ListItemType.Item Or _
        e.Item.ItemType = ListItemType.AlternatingItem Then
            CType(e.Item.Cells(0).Controls(0), HyperLink).ForeColor = Color.Blue
        End If
    End Sub
End Class
