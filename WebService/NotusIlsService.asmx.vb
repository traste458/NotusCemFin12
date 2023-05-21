Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports ILSBusinessLayer
Imports ILSBusinessLayer.MensajeriaEspecializada
Imports ILSBusinessLayer.Estructuras
Imports ILSBusinessLayer.WMS
Imports System.Collections.Generic

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://www.logytechmobile.com/NotusIlsWebService/", Description:="WebService que provee los procedimientos y funciones necesarios para llevar a cabo la sincronización de información de BancaSegurosCEM", name:="NotusIlsService")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class NotusIlsService
    Inherits System.Web.Services.WebService

#Region "Atributos (Campos)"

    Private _idUsuario As Integer

#End Region

#Region "Propiedades"

    Public Property IdUsuario As Integer
        Get
            Return _idUsuario
        End Get
        Set(value As Integer)
            _idUsuario = value
        End Set
    End Property

#End Region

#Region "Métodos Públicos"

    <WebMethod(Description:="Función que permite consultar una Campaña, según los filtros establecidos")> _
    Public Function ConsultarCampaniasCEM(ByVal infoFiltros As WsFiltroCampania, ByRef dsReporte As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCampania(infoFiltros, dsReporte)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite registrar un servicio (CEM), para productos financieros")> _
    Public Function RegistrarServicioWS(ByVal infoServicio As WsRegistroServicioMensajeria, ByRef idServicio As Long) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = RegistrarServicio(infoServicio, idServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite actualizar un servicio (CEM), para productos financieros")> _
    Public Function ActualizarServicioWS(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ActualizarServicio(infoServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite actualizar un servicio (CEM), para productos financieros")>
    Public Function ActualizarServicioWSeMergia(ByVal infoServicio As WsRegistroServicioMensajeriaEmergia) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ActualizarServicioEmergia(infoServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite agregar referencias a un servicio (CEM), para productos financieros")> _
    Public Function AgregarReferencias(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = AgregarReferenciasWS(infoServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite eliminar referencias a un servicio (CEM), para productos financieros")> _
    Public Function EliminarReferencias(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = EliminarReferenciasWS(infoServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar las capacidades de entrega, para agendamiento")> _
    Public Function ConsultarCapacidadEntrega(ByVal infoCapacidad As WsInfoCapacidadEntrega, ByRef dsCantidad As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCapacidad(infoCapacidad, dsCantidad)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar la disponibilidad de inventario de documentos para servicio financiero")> _
    Public Function ConsultarDisponibilidadDocumentos(ByVal infoDisponibilidad As WsInfoDisponibilidad, ByRef dsDisponibilidad As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultarDisponibilidad(infoDisponibilidad, dsDisponibilidad)
        Return resultado
    End Function

    <WebMethod(Description:="Función que validar un registro (CEM), para productos financieros")> _
    Public Function ValidaRegistrosServicioWS(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ValidarServicio(infoServicio)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los clientes finales.")>
    Public Function ConsultarClientesExternos(ByRef dsReporte As DataSet, ByRef estado As Boolean, ByRef idEmpresa As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaClienteExterno(dsReporte, estado, idEmpresa)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar las bodegas.")> _
    Public Function ConsultarBodegas(ByRef dsDatos As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaBodegas(dsDatos)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los productos.")> _
    Public Function ConsultarProductos(ByRef dsDatos As DataSet, ByVal pListIdClienteExterno As List(Of Integer)) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaProductos(dsDatos, pListIdClienteExterno)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los tipos de campañas.")> _
    Public Function ConsultarTipoCampanias(ByRef dsReporte As DataSet, ByRef estado As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaTipoCampanias(dsReporte, estado)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los tipos de servicios.")> _
    Public Function ConsultarServicios(ByRef dsReporte As DataSet, ByRef _esFinanciero As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaTipoServicios(dsReporte, _esFinanciero)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los documentos(Productos Financieros).")> _
    Public Function ConsultarDocumentos(ByRef dsReporte As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaDocumentos(dsReporte)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar las bodegas ligadas a una campania.")> _
    Public Function ConsultarCampaniaBodega(ByRef dsDatos As DataSet, ByRef idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCampaniaBodegas(dsDatos, idCampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los productos ligados a una campania.")> _
    Public Function ConsultarCampaniaProducto(ByRef dsDatos As DataSet, ByRef idCampania As Integer, ByRef tipoProducto As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCampaniaProductos(dsDatos, idCampania, tipoProducto)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los documentos ligados a una campania.")> _
    Public Function ConsultarCampaniaDocumento(ByRef dsDatos As DataSet, ByRef idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCampaniaDocumentos(dsDatos, idCampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite registrar una campania")> _
    Public Function RegistrarCampaniaWS(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = RegistrarCampania(infoCampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite actualizar una campania")> _
    Public Function ActualizarCampaniaWS(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ActualizarCampania(infoCampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar los clientes finales.")> _
    Public Function CargarInformacionTipoServicio(ByRef dsReporte As DataSet, ByRef estado As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaClienteFinal(dsReporte, estado)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite guardar un código de estrategia.")> _
    Public Function GuardarCodigoEstrategiaWs(ByVal infocampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = GuardarCodigoEstrategia(infocampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite actualizar un código de estrategia.")> _
    Public Function ActualizarCodigoEstrategiaWs(ByVal infocampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ActualizarCodigoEstrategia(infocampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite Eliminar un código de estrategia.")> _
    Public Function EliminarCodigoEstrategiaWs(ByVal infocampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = EliminarCodigoEstrategia(infocampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite Asociar un código de estrategia a una campania.")> _
    Public Function AsociarCodigoEstrategiaWs(ByVal infocampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = AsociarCodigoEstrategia(infocampania)
        Return resultado
    End Function

    <WebMethod(Description:="Función que permite consultar las ciudades por campaña.")> _
    Public Function ConsultarCiudadesCampania(ByRef dsDatos As DataSet, ByVal idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        resultado = ConsultaCiudades(dsDatos, idCampania)
        Return resultado
    End Function
#End Region

#Region "Métodos Privados"

    Private Function ConsultaCampania(ByVal infoFiltros As WsFiltroCampania, ByRef dsReporte As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miCampania As New CampaniaColeccion
        Dim dtDatos As New DataTable
        With miCampania
            If infoFiltros.IdCampania > 0 Then .IdCampania = infoFiltros.IdCampania
            If Not String.IsNullOrEmpty(infoFiltros.NombreCampania) Then .NombreCampania = infoFiltros.NombreCampania
            If infoFiltros.Activo IsNot Nothing Then .Activo = infoFiltros.Activo
            If infoFiltros.ListaTipoServicio IsNot Nothing AndAlso infoFiltros.ListaTipoServicio.Count > 0 Then
                .ListaTipoServicio = infoFiltros.ListaTipoServicio
                .Activo = True
            End If
            If infoFiltros.IdClienteExterno > 0 Then
                .IdClienteExterno = infoFiltros.IdClienteExterno
            End If
            If infoFiltros.IdEmpresa > 0 Then
                .IdEmpresa = infoFiltros.IdEmpresa
            End If
            dtDatos = .GenerarDataTable
            If dtDatos.Rows.Count <> 0 Then
                resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
            Else
                resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
            End If
            dsReporte.Tables.Add(dtDatos)
        End With
        Return resultado
    End Function

    Private Function RegistrarServicio(ByVal infoServicio As WsRegistroServicioMensajeria, ByRef idServicio As Long) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .FechaAgenda = infoServicio.FechaAgenda
            .IdJornada = infoServicio.IdJornada
            .IdEmpresa = infoServicio.IdEmpresa
            .IdEstado = infoServicio.IdEstado
            .NombreCliente = infoServicio.Nombre
            .IdentificacionCliente = infoServicio.Identicacion
            .NombresCompleto = infoServicio.NombresCompleto
            .PrimerApellido = infoServicio.PrimerApellido
            .SegundoApellido = infoServicio.SegundoApellido
            .CodigoEstrategiaComercial = infoServicio.CodigoEstrategiaComercial
            .Sexo = infoServicio.Sexo
            .Celular = infoServicio.Celular
            .TelefonoAdicional = infoServicio.TelefonoAdicional
            .Correo = infoServicio.Correo

            .IdCiudad = infoServicio.IdCiudad
            .Direccion = infoServicio.Direccion
            .TelefonoContacto = infoServicio.Telefono
            .IdTipoServicio = infoServicio.IdTipoServicio
            .IdCampania = infoServicio.IdCampania
            .ListProductos = infoServicio.ListProductos
            .ListTipoServicio = infoServicio.ListTipoServicio
            .ListCupoProducto = infoServicio.ListCupoProducto
            .ActividadLaboral = infoServicio.ActividadLaboral
            .CodOficinaCliene = infoServicio.CodOficinaCliente
            .CodigoAgenteVendedor = infoServicio.CodigoAgenteVendedor
            .Observacion = infoServicio.Observacion
            resultado = .RegistrarServicioWS()
            If resultado.Valor = 0 Then
                idServicio = .IdServicioMensajeria
            End If
        End With
        Return resultado
    End Function

    Private Function ActualizarServicio(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .FechaAgenda = infoServicio.FechaAgenda
            .IdJornada = infoServicio.IdJornada
            .IdEstado = infoServicio.IdEstado
            .NombreCliente = infoServicio.Nombre
            .IdentificacionCliente = infoServicio.Identicacion
            .IdCiudad = infoServicio.IdCiudad
            .Direccion = infoServicio.Direccion
            .TelefonoContacto = infoServicio.Telefono
            .IdTipoServicio = infoServicio.IdTipoServicio
            .IdCampania = infoServicio.IdCampania
            resultado = .ActualizarServicioWS()
        End With
        Return resultado
    End Function

    Private Function ActualizarServicioEmergia(ByVal infoServicio As WsRegistroServicioMensajeriaEmergia) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .FechaAgenda = infoServicio.FechaAgenda
            .IdJornada = infoServicio.IdJornada
            .IdCiudad = infoServicio.IdCiudad
            .Direccion = infoServicio.Direccion
            .Observacion = infoServicio.Observacion
            .TelefonoContacto = infoServicio.Telefono
            .TelefonoFijo = infoServicio.TelefonoFijo
            resultado = .ActualizarServicioWSEmergia()
        End With
        Return resultado
    End Function

    Private Function AgregarReferenciasWS(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .ListProductos = infoServicio.ListProductos
            .ListTipoServicio = infoServicio.ListTipoServicio
            resultado = .AgregarReferenciaWS()
        End With
        Return resultado
    End Function

    Private Function EliminarReferenciasWS(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .IdServicioMensajeria = infoServicio.IdServicioMensajeria
            .ListProductos = infoServicio.ListProductos
            .ListTipoServicio = infoServicio.ListTipoServicio
            resultado = .EliminarReferenciaWS()
        End With
        Return resultado
    End Function

    Private Function ConsultaCapacidad(ByVal infoCapacidad As WsInfoCapacidadEntrega, ByRef dsCantidad As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtCapacidad As New DataTable
        Dim miCapacidad As New InfoCapacidadEntregaServicioMensajeriaColeccion
        With miCapacidad
            If infoCapacidad.IdEmpresa > 0 Then .IdEmpresa = infoCapacidad.IdEmpresa
            If infoCapacidad.IdRegistro > 0 Then .IdRegistro = infoCapacidad.IdRegistro
            If infoCapacidad.IdBodega > 0 Then .IdBodega = infoCapacidad.IdBodega
            If infoCapacidad.IdCiudad > 0 Then .IdCiudad = infoCapacidad.IdCiudad
            If infoCapacidad.FechaInicial > Date.MinValue Then .FechaInicial = infoCapacidad.FechaInicial
            If infoCapacidad.FechaFinal > Date.MinValue Then .FechaFinal = infoCapacidad.FechaFinal
            If infoCapacidad.IdJornada > 0 Then .IdJornada = infoCapacidad.IdJornada
            If infoCapacidad.IdAgrupacion > 0 Then .IdAgrupacion = infoCapacidad.IdAgrupacion
            If infoCapacidad.IdCampania > 0 Then .IdCampania = infoCapacidad.IdCampania
            dtCapacidad = .GenerarDataTable()
        End With
        If dtCapacidad.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(1, "No se encontraron registros")
        End If
        dsCantidad.Tables.Add(dtCapacidad)
        Return resultado
    End Function

    Private Function ConsultarDisponibilidad(ByVal infoDisponibilidad As WsInfoDisponibilidad, ByRef dsDisponibilidad As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDisponibilidad As New DataTable
        Dim miInventario As New Inventario.ItemBodegaSatelite
        With miInventario
            .ListProductos = infoDisponibilidad.ListProductos
            dtDisponibilidad = .InventarioDisponibleServicioFinanciero(infoDisponibilidad.IdCiudad, infoDisponibilidad.IdCampania, infoDisponibilidad.CodigoDocumento)
        End With
        If dtDisponibilidad.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(1, "No se encontraron registros")
        End If
        dsDisponibilidad.Tables.Add(dtDisponibilidad)
        Return resultado
    End Function

    Private Function ValidarServicio(ByVal infoServicio As WsRegistroServicioMensajeria) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miRegistro As New MensajeriaEspecializada.ServicioMensajeriaFinanciero
        With miRegistro
            .IdCiudad = infoServicio.IdCiudad
            .IdCampania = infoServicio.IdCampania
            .ListProductos = infoServicio.ListProductos
            resultado = .ValidarServicio()
        End With
        Return resultado
    End Function

    Private Function ConsultaClienteFinal(ByRef dsReporte As DataSet, ByRef estado As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim filtro As New FiltroClienteExterno
        filtro.EsFinanciero = estado
        dtDatos = Comunes.ClienteExterno.ObtenerListado(filtro)
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaClienteExterno(ByRef dsReporte As DataSet, ByRef estado As Boolean, ByRef idEmpresa As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim filtro As New FiltroClienteExterno
        filtro.EsFinanciero = estado
        filtro.IdClienteExterno = idEmpresa
        dtDatos = Comunes.ClienteExterno.ObtenerListado(filtro)
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaTipoServicios(ByRef dsReporte As DataSet, ByRef _esFinanciero As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim objTipoServicio As New TipoServicioColeccion
        With objTipoServicio
            .EsFinanciero = _esFinanciero
            dtDatos = .GenerarDataTable
        End With

        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaDocumentos(ByRef dsReporte As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        dtDatos = New ProductoDocumentoFinancieroColeccion().GenerarDataTable
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaBodegas(ByRef dsReporte As DataSet) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ConsultarBodega()
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaProductos(ByRef dsReporte As DataSet, Optional ByVal pListIdClienteExterno As List(Of Integer) = Nothing) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim objProducto As New ProductoComercialColeccion
        With objProducto
            If pListIdClienteExterno IsNot Nothing And pListIdClienteExterno.Count > 0 Then
                .ListIdClienteExterno = pListIdClienteExterno
            Else
                .ListIdClienteExterno.Add(Enumerados.ClienteExterno.DAVIVIENDA)
                .ListIdClienteExterno.Add(Enumerados.ClienteExterno.DAVIVIENDAEXTERNO)
            End If
            dtDatos = .GenerarDataTable
        End With
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaTipoCampanias(ByRef dsReporte As DataSet, ByRef estado As Boolean) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ObtenerTipoCampanias(estado)
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaCampaniaBodegas(ByRef dsReporte As DataSet, ByRef _idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim objServicioBodega As New BodegaColeccion()
        objServicioBodega.IdCampania = _idCampania
        dtDatos = objServicioBodega.GenerarDataTable
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaCampaniaProductos(ByRef dsReporte As DataSet, ByRef _idCampania As Integer, Optional tipoProducto As Boolean = False) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim objServicioProducto As New ProductoComercialColeccion()
        objServicioProducto.IdCampania = _idCampania
        If tipoProducto <> Nothing And tipoProducto <> False Then
            objServicioProducto.TipoProducto = tipoProducto
        End If
        dtDatos = objServicioProducto.GenerarDataTable
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function ConsultaCampaniaDocumentos(ByRef dsReporte As DataSet, ByRef _idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        Dim objServicioDocumento As New ProductoDocumentoFinancieroColeccion()
        objServicioDocumento.IdCampania = _idCampania
        dtDatos = objServicioDocumento.GenerarDataTable
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

    Private Function RegistrarCampania(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miCampania As New CampaniaFinanciero
        With miCampania
            .Nombre = infoCampania.Nombre
            .FechaInicio = infoCampania.FechaInicio
            .IdEmpresa = infoCampania.IdEmpresa
            .FechaFin = infoCampania.FechaFinGestionCal
            .FechaFinGestionCem = infoCampania.FechaFinGestionCem
            .FechaFinRadicado = infoCampania.FechaFinRadicado
            .Activo = infoCampania.Activo
            .MetaCliente = infoCampania.MetaCliente
            .MetaCallcenter = infoCampania.MetaCallcenter
            .FechaLlegada = infoCampania.FechaLlegada
            .ListTiposDeServicio = infoCampania.ListTiposDeServicio
            .ListBodegas = infoCampania.ListBodegas
            .ListProductoExterno = infoCampania.ListProductoExterno
            .ListDocumentoFinanciero = infoCampania.ListDocumentoFinanciero
            .IdClienteExterno = infoCampania.IdClienteExterno
            .IdTipoCampania = infoCampania.IdTipoCampania
            .IdSistema = infoCampania.IdSistema
            resultado = .RegistrarFinanciero()
        End With
        Return resultado
    End Function

    Private Function ActualizarCampania(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim miCampania As New CampaniaFinanciero
        With miCampania
            .IdCampania = infoCampania.IdCampania
            .Nombre = infoCampania.Nombre
            .FechaInicio = infoCampania.FechaInicio
            .FechaFin = infoCampania.FechaFinGestionCal
            .FechaFinGestionCem = infoCampania.FechaFinGestionCem
            .FechaFinRadicado = infoCampania.FechaFinRadicado
            .Activo = infoCampania.Activo
            .MetaCliente = infoCampania.MetaCliente
            .MetaCallcenter = infoCampania.MetaCallcenter
            .FechaLlegada = infoCampania.FechaLlegada
            .ListTiposDeServicio = infoCampania.ListTiposDeServicio
            .ListBodegas = infoCampania.ListBodegas
            .ListProductoExterno = infoCampania.ListProductoExterno
            .ListDocumentoFinanciero = infoCampania.ListDocumentoFinanciero
            .IdClienteExterno = infoCampania.IdClienteExterno
            .IdEmpresa = infoCampania.IdEmpresa
            .IdTipoCampania = infoCampania.IdTipoCampania
            .IdSistema = infoCampania.IdSistema
            resultado = .ActualizarFinanciero()
        End With
        Return resultado
    End Function

    Private Function GuardarCodigoEstrategia(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim objCodEstrategia As New CampaniaFinanciero
        With objCodEstrategia
            .CodEstrategia = infoCampania.CodEstrategia
            resultado = .GuardarCodEstrategia()
        End With
        Return resultado
    End Function

    Private Function ActualizarCodigoEstrategia(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim objCodEstrategia As New CampaniaFinanciero
        With objCodEstrategia
            .CodEstrategia = infoCampania.CodEstrategia
            .CodigoEstrategiaActualizar = infoCampania.CodigoEstrategiaActualizar
            resultado = .ActualizarCodEstrategia()
        End With
        Return resultado
    End Function

    Private Function EliminarCodigoEstrategia(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim objCodEstrategia As New CampaniaFinanciero
        With objCodEstrategia
            .CodEstrategia = infoCampania.CodEstrategia
            resultado = .EliminarCodEstrategia()
        End With
        Return resultado
    End Function

    Private Function AsociarCodigoEstrategia(ByVal infoCampania As WsRegistroCampania) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim objCodEstrategia As New CampaniaFinanciero
        With objCodEstrategia
            .IdCampania = infoCampania.IdCampania
            .CodEstrategia = infoCampania.CodEstrategia
            resultado = .AsociarCodEstrategiaCampania()
        End With
        Return resultado
    End Function

    Private Function ConsultaCiudades(ByRef dsReporte As DataSet, ByVal idCampania As Integer) As ILSBusinessLayer.ResultadoProceso
        Dim resultado As New ILSBusinessLayer.ResultadoProceso
        Dim dtDatos As New DataTable
        dtDatos = HerramientasMensajeria.ConsultarCiudadCampania(idCampania)
        If dtDatos.Rows.Count <> 0 Then
            resultado.EstablecerMensajeYValor(0, "Registros Encontrados")
        Else
            resultado.EstablecerMensajeYValor(0, "No se encontraron registros")
        End If
        dsReporte.Tables.Add(dtDatos)
        Return resultado
    End Function

#End Region

End Class