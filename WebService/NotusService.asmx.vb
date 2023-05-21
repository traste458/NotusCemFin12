Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports ILSBusinessLayer
Imports ILSBusinessLayer.Comunes
Imports LMWebServiceSyncMonitorBusinessLayer
Imports System.Drawing
Imports System.IO
Imports System.Drawing.Imaging
Imports System.Collections.Generic

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://notusservice.logytechmobile.com/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class NotusService
    Inherits System.Web.Services.WebService

#Region "Métodos Públicos"

    <WebMethod()> _
    Private Function SincronizarPedidos(ByVal arrCentro As ArrayList, ByVal arrPedidos As ArrayList) As ClasesComunes.ResultadoProceso
        Dim resultado As New ClasesComunes.ResultadoProceso
        Try
            Dim sincronizadorPool As New SincronizadorPoolPedido
            With sincronizadorPool
                If arrCentro.Count > 0 Then .ListaPuestosExpedicion = New Puestos.PuestosColeccion(arrCentro)
                If arrPedidos.Count > 0 Then .ListaPedido = arrPedidos

                If .ListaPuestosExpedicion.Count < arrCentro.Count Then
                    resultado.EstablecerValorYMensaje(1, "Uno o más centros no existen, por favor veririque.")
                Else
                    resultado = .Sincronizar()
                End If
            End With
        Catch ex As Exception
            resultado.EstablecerValorYMensaje(100, "Error al tratar de sincronizar Pedidos. " & ex.Message)
        End Try
        Return resultado
    End Function

    <WebMethod()> _
    Public Function RegistrarNovedadDeProduccion(ByVal infoNovedad As ILSBusinessLayer.NovedadProduccion) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Registro no creado")
        Dim sop As SoporteNovedadProduccionColeccion = infoNovedad.Soportes
        If infoNovedad.IdNovedad = 0 AndAlso Not EsNuloOVacio(infoNovedad.Descripcion) AndAlso infoNovedad.IdUsuarioRegistra > 0 _
            AndAlso sop IsNot Nothing AndAlso sop.Count > 0 Then
            For Each s As SoporteNovedadProduccion In sop
                If s.IdTipoSoporte = 1 Then
                    Dim nombre As String = s.NombreOriginal.Split(".").GetValue(0) & "_" & System.Guid.NewGuid().ToString & Path.GetExtension(s.NombreOriginal)
                    Dim rutaCompleta As String = Server.MapPath("~/infoOperaciones/SoportesOperacion/Novedades/") & nombre
                    Using objFS As New FileStream(rutaCompleta, FileMode.Create)
                        objFS.Write(s.DatosBinarios, 0, s.DatosBinarios.Length - 1)
                        objFS.Flush()
                        objFS.Close()
                    End Using
                    s.NombreOriginal = nombre
                    Array.Clear(s.DatosBinarios, 0, s.DatosBinarios.Length)
                End If
            Next
            resultado = infoNovedad.Registrar()
        Else
            resultado.EstablecerMensajeYValor(300, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)

    End Function

    <WebMethod(Description:="Confirmar Recepción de pedido en Servicio Tecnico")> _
    Public Function ConfirmarRecepcionPedido(ByVal idPedido As Integer, ByVal usuario As String, ByVal observacion As String, ByVal remision As String) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Recepción no confirmada")
        If idPedido > 0 And usuario <> "" And remision <> "" Then
            Dim objConfirmacion As New Pedidos.PedidoServicioTecnico
            With objConfirmacion
                .IdPedido = idPedido
                .UsuarioServicioTecnico = usuario
                If observacion <> "" Then
                    .Observaciones = observacion
                Else
                    .Observaciones = ""
                End If
                .Remision = remision
                resultado = .ConfirmarPedidoServicioTecnico
            End With
        Else
            resultado.EstablecerMensajeYValor(3, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique.")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)
    End Function

    <WebMethod(Description:="Rechazar Recepción de pedido en Servicio Tecnico")> _
    Public Function RechazarRecepcionPedido(ByVal idPedido As Integer, ByVal usuario As String, ByVal observacion As String, ByVal remision As String) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Recepción rechazada")
        If idPedido > 0 And usuario <> "" And remision <> "" Then
            Dim objRechazo As New Pedidos.PedidoServicioTecnico
            With objRechazo
                .IdPedido = idPedido
                .UsuarioServicioTecnico = usuario
                If observacion <> "" Then
                    .Observaciones = observacion
                Else
                    .Observaciones = ""
                End If
                .Remision = remision
                resultado = .RechazarPedidoServicioTecnico
            End With
        Else
            resultado.EstablecerMensajeYValor(3, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique.")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)
    End Function

    <WebMethod(Description:="Crear Devolución Servicio Tecnico")> _
    Public Function CrearDevolucionServicioTecnico(ByVal infoDevolucion As ILSBusinessLayer.wsDevolucion) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Devolución no creada")
        If infoDevolucion.IdDevolucionServicioTecnico > 0 And infoDevolucion.Usuario <> "" And infoDevolucion.ObjDatos.Count > 0 Then
            Dim objDevolucion As New ILSBusinessLayer.DevolucionServicioTecnico
            With objDevolucion
                resultado = .CrearDevolucion(infoDevolucion)
            End With
        Else
            resultado.EstablecerMensajeYValor(-1, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique.")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)
    End Function

    <WebMethod(Description:="Anulación de devolución de servicio tecnico")> _
    Public Function AnularDevolucion(ByVal idDevolucionServicioTecnico As Integer, ByVal usuario As String, ByVal observacion As String) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Devolución no anulada")
        If idDevolucionServicioTecnico > 0 And usuario <> "" Then
            Dim objDevolucion As New ILSBusinessLayer.DevolucionServicioTecnico
            With objDevolucion
                resultado = .AnularDevolucion(idDevolucionServicioTecnico, usuario, observacion)
            End With
        Else
            resultado.EstablecerMensajeYValor(-1, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique.")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)
    End Function

    <WebMethod(Description:="Creación cobro a fabricante servicio tecnico")> _
    Public Function CrearCobroFabricante(ByVal infoCobro As ILSBusinessLayer.wsCobroFabricante) As ClasesComunes.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso(-1, "Cobro a fabricante no creado")
        If infoCobro.IdCobro > 0 And infoCobro.fabricante <> "" And infoCobro.usuario <> "" And infoCobro.ObjDatos.Count > 0 Then
            Dim objCobroFabricante As New ILSBusinessLayer.CobroFabricante
            With objCobroFabricante
                resultado = .RegistrarCobroFabricante(infoCobro)
            End With
        Else
            resultado.EstablecerMensajeYValor(-1, "No se han proporcionado los valores de todos los parámetros obligatorios. Por favor verifique.")
        End If
        Return New ClasesComunes.ResultadoProceso(resultado.Valor, resultado.Mensaje)
    End Function

    <WebMethod(Description:="Obtiene el historial de un serial")> _
    Public Function ObtenerHistoricoDeSeriales(ByVal filtro As wsHistoricoServicioTecnico) As DetalleHistoricoServicioTecnicoColeccion
        Dim detalle As New DetalleHistoricoServicioTecnicoColeccion
        With detalle
            If filtro.ListaSeriales IsNot Nothing AndAlso filtro.ListaSeriales.Count > 0 Then .ListaSeriales.AddRange(filtro.ListaSeriales)
            .CargarDatos()
        End With
        Return detalle
    End Function

#End Region

End Class
