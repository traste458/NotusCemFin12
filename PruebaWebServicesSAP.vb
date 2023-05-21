Imports BPColSysOP
Imports ILSBusinessLayer
Imports LMWebServiceSyncMonitorBusinessLayer

Public Class PruebaWebServicesSAP

    Private Sub ValidarPoolPedidos()
        Dim pool As New SAPPoolPedidos.WS_PEDIDOS_LG
        Dim resultado As New SAPPoolPedidos.OutputLg

        resultado = pool.executeZmmLgPoolPedidosEntregas("", Nothing, "", Nothing, Nothing, "7727726624")

        Dim hayError As Boolean = False
        For index As Integer = 0 To resultado.oMensajes.Length
            If resultado.oMensajes(0).type.ToUpper.Equals("E") Or resultado.oMensajes(0).type.ToUpper.Equals("A") Then hayError = True
            'Adiciona los mensajes a un datatable
        Next
        If Not hayError Then
            With resultado
                If .rPedidosC.Length = 1 Then
                    'Validaciones resultaro OK, se procede a la creación de Entregas.
                    'Mostrar información para selección de Posiciones a Generar Entrega


                    'Ejecutar Proceso de Cargue
                    Dim centros(0) As SAPPoolPedidos.ZmmIntVstel
                    Dim cabPedido(0) As SAPPoolPedidos.ZmmLgPedidosC
                    Dim detPedido(2) As SAPPoolPedidos.ZmmLgPedidosD
                    cabPedido(0) = New SAPPoolPedidos.ZmmLgPedidosC
                    cabPedido(0).pedido = "7727726624"
                    detPedido(0) = New SAPPoolPedidos.ZmmLgPedidosD
                    detPedido(0).material = ""
                    detPedido(0).posicion = ""
                    detPedido(0).cantidad = ""
                    detPedido(0).unidadVenta = ""
                    detPedido(0).centroDest = ""
                    detPedido(0).almacenDest = ""
                    detPedido(0).pedido = "7727726624"


                    resultado = pool.executeZmmLgPoolPedidosEntregas("", Nothing, "X", cabPedido, detPedido, "7727726624")
                    'Evaluar resultado - 
                    'Si el resultado es satiscatorio, entonces la información de las entregas generada viene en los campos:
                    'MESSAGE_V1, MESSAGE_V2 y  MESSAGE_V3, almacenando el Pedido, la Entrega y la Posición respectivamente
                    resultado.oMensajes(0).type = "S"
                    resultado.oMensajes(0).messageV1 = "Pedido"
                    resultado.oMensajes(0).messageV2 = "Entrega"
                    resultado.oMensajes(0).messageV3 = "Posicion"

                Else
                    If .rPedidosC.Length > 1 Then
                        'El sistema retornó más de un pedido y sólo se consultó 1
                    Else
                        'No se encontró el pedido
                    End If
                End If
            End With
        Else
            'Error al tratar de consultar pedidos
        End If

    End Sub

    Private Sub CargueDeSeriales() 'Contabilización de Despachos
        Dim zmmCapser As New SAPZmmCapser.WS_CAPSER_LG
        Dim resultado As New SAPZmmCapser.OutputLgCapSer
        Dim infoEntrega() As SAPZmmCapser.ZmmLmEntregas
        Dim infoSeriales() As SAPZmmCapser.ZmmLmSeriales
        Dim dtMaterial As New DataTable 'Consultar materiales del Pedido
        Dim dtSerial As New DataTable 'Consultar seriales del Despacho
        Dim numMateriales As Integer = dtMaterial.Rows.Count
        Dim numSeriales As Integer = dtSerial.Rows.Count

        ReDim infoEntrega(numMateriales - 1)
        ReDim infoSeriales(numSeriales - 1)

        Dim index As Integer = 0
        Dim indexSerial As Integer = 0
        For Each drMaterial As DataRow In dtMaterial.Rows
            infoEntrega(index) = New SAPZmmCapser.ZmmLmEntregas
            With infoEntrega(index)
                .vbeln = "NumEntrega"
                .matnr = drMaterial("material")
                .posnr = drMaterial("posicion")
            End With
            Dim drSerial() As DataRow = dtSerial.Select("material='" & drMaterial("material") & "'")
            For indice As Integer = 0 To drSerial.Length - 1
                infoSeriales(indexSerial) = New SAPZmmCapser.ZmmLmSeriales
                With infoSeriales(indexSerial)
                    .sernr = drSerial(indice).Item("serial")
                    .posnr = drMaterial("posicion")
                End With
                indexSerial += 1
            Next
            index += 1
        Next

        resultado = zmmCapser.executeZmmLgCapser("NumEntrega", "Peso", "Guía", "X", infoEntrega, infoSeriales)
        If resultado IsNot Nothing Then
            If resultado.oReturn.Length > 0 Then
                Dim hayError As Boolean = False
                Dim numDocumento As String
                For indx As Integer = 0 To resultado.oReturn.Length - 1
                    If resultado.oReturn(indx).type = "E" Or resultado.oReturn(indx).type = "A" Then
                        hayError = True
                    ElseIf resultado.oReturn(indx).type = "S" Then
                        numDocumento = resultado.oReturn(indx).messageV1
                        '*****Condicional opcional
                        'Else
                        '    If resultado.oReturn(indx).messageV2 = "NumEntrega" Then
                        '        numDocumento = resultado.oReturn(indx).messageV1
                        '   End If
                    End If
                Next

            Else
                'Error
            End If
        Else
            'Error
        End If

    End Sub

    Private Sub ConsultarOCEntradaDeMercancia()
        Dim cont As SAPContabilizacionEntrada.WS_ENTRADAS_LG
        Dim infoOC As New SAPContabilizacionEntrada.ZmmLgEntradasCab
        Dim resultado As SAPContabilizacionEntrada.OutputContabLg

        With infoOC
            .entregaFactura = "REMISION"
            .textoCab = "PROVEEDOR"
            .noOrden = "12312312312"
        End With

        resultado = cont.executeZmmLgContabEntradas("O", "101", infoOC, "X", Nothing, Nothing)
        If resultado IsNot Nothing Then
            If resultado.oMensajes IsNot Nothing Then
                Dim hayError As Boolean = False
                For index As Integer = 0 To resultado.oMensajes.Length - 1
                    If (resultado.oMensajes(index).type = "E" Or resultado.oMensajes(index).type = "A") Then
                        'Hubo un error y debo parar el proceso y notificarle al usuario
                        'Conveniente: guardar los errores en un datatable para mostrarlos al usuario
                        hayError = True
                    End If
                Next
                If Not hayError Then
                    'Guardar en datatable los valores que vienen en el arrego rMateriales y corresponden
                    ' a los centros asociados a la Orden de Recepción
                    For index As Integer = 0 To resultado.rMateriales.Length - 1
                        'resultado.rMateriales(0).
                    Next
                End If
            Else
                'Error: No hubo respuesta
            End If
        Else
            'Error: No hubo respuesta
        End If

    End Sub

    Private Sub CargarOCEntradaMercancia()
        Dim cont As SAPContabilizacionEntrada.WS_ENTRADAS_LG
        Dim infoOC As New SAPContabilizacionEntrada.ZmmLgEntradasCab
        Dim resultado As SAPContabilizacionEntrada.OutputContabLg

        With infoOC
            .entregaFactura = "REMISION"
            .textoCab = "PROVEEDOR"
            .noOrden = "12312312312"
        End With

        Dim detMat() As SAPContabilizacionEntrada.ZmmLgMateriales 'Depende de la selección en pantalla

        detMat(0) = New SAPContabilizacionEntrada.ZmmLgMateriales
        With detMat(0)
            .posContable = 10
            .material = "1111"
            .cantidad = 10
            .centro = "1002"
            .almacen = "1003"
        End With


        resultado = cont.executeZmmLgContabEntradas("O", "101", infoOC, Nothing, detMat, Nothing)
        Dim hayError As Boolean = False
        For index As Integer = 0 To resultado.oMensajes.Length - 1
            If (resultado.oMensajes(index).type = "E" Or resultado.oMensajes(index).type = "A") Then
                'Hubo un error y debo parar el proceso y notificarle al usuario
                'Conveniente: guardar los errores en un datatable para mostrarlos al usuario
                hayError = True
            End If
        Next
        If Not hayError Then
            'Imprimir documento y volver a consultar (depende de si se acabó la Orden de Recepción)
            Dim doc As SAPImpresionDocumentos.WS_PDF_LG
        End If

    End Sub

End Class
