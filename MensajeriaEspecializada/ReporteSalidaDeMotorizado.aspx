<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteSalidaDeMotorizado.aspx.vb" Inherits="BPColSysOP.ReporteSalidaDeMotirados" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte Salida De Motorizados</title>
        <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/animatedcollapse.js" type="text/javascript"></script>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script>

        function ValidacionDeRangoFechaAgenda(s, e) {
            deFechaInicialAgenda.SetIsValid(true);
            deFechaFinalAgenda.SetIsValid(true);
            let fechaInicio = deFechaInicialAgenda.date;
            let fechaFin = deFechaFinalAgenda.date;

            if (fechaInicio == null && fechaFin == null) {
                return true;
            } else if (fechaInicio != null && fechaFin == null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }
            else if (fechaInicio == null && fechaFin != null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }

            if (fechaInicio > fechaFin) { e.isValid = false; }

            var diff = Math.floor((fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24));

            if (diff > 61) {
                e.isValid = false;
                e.errorText = "Rango tiene que se menor o igual a 60 dias"
                return false;
            }
        }

        function ValidacionDeRangoFechaTransito(s, e) {
            txtFechaTransitoInicial.SetIsValid(true);
            txtFechaTransitoFinal.SetIsValid(true);
            let fechaInicio = txtFechaTransitoInicial.date;
            let fechaFin = txtFechaTransitoFinal.date;

            if (fechaInicio == null && fechaFin == null) {
                return true;
            } else if (fechaInicio != null && fechaFin == null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }
            else if (fechaInicio == null && fechaFin != null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }

            if (fechaInicio > fechaFin) { e.isValid = false; }

            var diff = Math.floor((fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24));

            if (diff > 61) {
                e.isValid = false;
                e.errorText = "Rango tiene que se menor o igual a 60 dias"
                return false;
            }
        }

        function ValidacionDeRangoFechaAsignado(s, e) {
            txtFechaAsignacionInicial.SetIsValid(true);
            txtFechaAsignacionFinal.SetIsValid(true);

            let fechaInicio = txtFechaAsignacionInicial.date;
            let fechaFin = txtFechaAsignacionFinal.date;

            if (fechaInicio == null && fechaFin == null) {
                return true;
            } else if (fechaInicio != null && fechaFin == null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }
            else if (fechaInicio == null && fechaFin != null) {
                e.isValid = false;
                e.errorText = "El Rango no es valido"
                return false;
            }

            if (fechaInicio > fechaFin) { e.isValid = false; }

            var diff = Math.floor((fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24));

            if (diff > 61) {
                e.isValid = false;
                e.errorText = "Rango tiene que se menor o igual a 60 dias"
                return false;
            }
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function MostarEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezadoPrincipal').html(s.cpMensaje);
            }
            if (s.cpNombreArchivo != null && s.cpNombreArchivo != '') {
                DescargarArchvo(s.cpNombreArchivo)
            }
        }

        function EjecutarCallback(Opcion, Valor) {
            cpPrincipal.PerformCallback(Opcion + ':' + Valor);
        }

        function EjecutarConsulta() {
            var container = cpPrincipal.GetMainElement();

            if (ASPxClientEdit.ValidateEditorsInContainer(container)) {

                if (deFechaInicialAgenda.GetValue() == null && deFechaFinalAgenda.GetValue() == null && txtFechaAsignacionInicial.GetValue() == null && txtFechaAsignacionFinal.GetValue() == null
                    && txtFechaTransitoInicial.GetValue() == null && txtFechaTransitoFinal.GetValue() == null && txtRadicado.GetValue() == null && txtDocResponsable.GetValue() == null
                    && cmbBodegas.GetValue() == 0 && ddlCiudad.GetValue() == 0) {

                    if (txtRadicado.GetValue() == null && txtDocResponsable.GetValue() == null) {
                        alert('Debe seleccionar por lo menos un filtro valido')
                    }

                    else {
                        alert('Debe seleccionar por lo menos una fecha Valida')
                    }

                } else {
                    EjecutarCallback('DescargarReporteMotorizados', '0')

                }
            }
        }

        function DescargarArchvo(archivo) {
            window.location.href = 'DescargarArchivoMotorizado.aspx?nombreArchivo=' + archivo;
        }
    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div>
            <dx:ASPxCallbackPanel ID="cpPrincipal" ClientInstanceName="cpPrincipal" Width="70%" runat="server">
                <ClientSideEvents EndCallback="function(s, e) { LoadingPanel.Hide();
                    MostarEncabezado(s,e);
                    }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="roundPanelFiltros" runat="server" ClientInstanceName="roundPanelFiltros" HeaderText="Filtros de Búsqueda" Width="100%" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table style="width: 100%">
                                        <tr>
                                            <td class="field">No. Radicado:</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtRadicado" runat="server" ClientInstanceName="txtRadicado" Theme="SoftOrange" TabIndex="0" Width="150px"></dx:ASPxTextBox>
                                            </td>
                                            <td class="field">No. Documento Resp. de Entrega:</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtDocResponsable" runat="server" ClientInstanceName="txtDocResponsable" Theme="SoftOrange" TabIndex="0" Width="150px"></dx:ASPxTextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field">Ciudad: </td>
                                            <td>
                                                <dx:ASPxComboBox ID="ddlCiudad" runat="server" ClientInstanceName="ddlCiudad"
                                                    AutoPostBack="false" Width="200px" Theme="SoftOrange" IncrementalFilteringMode="Contains"
                                                    ValueType="System.Int32" CallbackPageSize="25"
                                                    EnableCallbackMode="true" TabIndex="3">
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td class="field">Bodega:</td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbBodegas" runat="server" ClientInstanceName="cmbBodegas"
                                                    AutoPostBack="false" Width="200px" Theme="SoftOrange" IncrementalFilteringMode="Contains"
                                                    ValueType="System.Int32" CallbackPageSize="25"
                                                    EnableCallbackMode="true" TabIndex="3">
                                                </dx:ASPxComboBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field">Fecha Agenda Inicial:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaInicialAgenda" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="deFechaInicialAgenda" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Inicial Agenda" EnableClientSideAPI="true">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaAgenda" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                deFechaFinalAgenda.SetMinDate(deFechaInicialAgenda.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Fecha Agenda Final:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaFinalAgenda" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="deFechaFinalAgenda" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Final Agenda">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                deFechaInicialAgenda.SetMaxDate(deFechaFinalAgenda.GetDate());
                                                            }" />
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaAgenda" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="field">Fecha Transito Inicial:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaTransitoInicial" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaTransitoInicial" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Inicial Transito" EnableClientSideAPI="true">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaTransito" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaTransitoFinal.SetMinDate(txtFechaTransitoInicial.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Fecha Transito Final:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaTransitoFinal" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaTransitoFinal" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Final Transito">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaTransitoInicial.SetMaxDate(txtFechaTransitoFinal.GetDate());
                                                            }" />
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaTransito" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>


                                        <tr>
                                            <td class="field">Fecha Asignado a Ruta Inicial: </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaAsignacionInicial" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaAsignacionInicial" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Asignacon Inicial" EnableClientSideAPI="true">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaAsignado" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaAsignacionFinal.SetMinDate(txtFechaAsignacionInicial.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Fecha Asignado a Ruta Final:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaAsignacionFinal" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaAsignacionFinal" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Asignacion Final">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaAsignado" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaAsignacionInicial.SetMaxDate(txtFechaAsignacionFinal.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>&nbsp&nbsp&nbsp&nbsp&nbsp
                                                    <dx:ASPxImage ID="imgBuscar" runat="server" ImageUrl="../images/DxConfirm32.png" TabIndex="6"
                                                        ToolTip="Búsqueda" ValidationGroup="RptIndicador" ClientInstanceName="imgBuscar" Cursor="pointer">

                                                        <ClientSideEvents Click="function(s,e){
                                                            EjecutarConsulta();
                                                             }" />
                                                    </dx:ASPxImage>

                                            </td>

                                            <td>&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp
                                                    <dx:ASPxImage ID="imgCancela" runat="server" ImageUrl="../images/edit-clear.png" ToolTip="Limpiar "
                                                        Cursor="pointer" TabIndex="12">
                                                        <ClientSideEvents Click="function (s, e){
                                                            LimpiaFormulario();
                                                        }"></ClientSideEvents>
                                                    </dx:ASPxImage>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="True">
            </dx:ASPxLoadingPanel>
        </div>
    </form>
</body>
</html>
