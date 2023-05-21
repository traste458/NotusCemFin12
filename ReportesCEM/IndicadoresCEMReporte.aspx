<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="IndicadoresCEMReporte.aspx.vb" Inherits="BPColSysOP.IndicadoresCEMReporte1" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
 <script src="../include/jquery-1.js" type="text/javascript"></script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script>
        


function ValidacionDeRangoFechaCreacion(s, e) {
    txtFechaCreacionInicial.SetIsValid(true);
    txtFechaCreacionFinal.SetIsValid(true);
    let fechaInicio = txtFechaCreacionInicial.date;
    let fechaFin = txtFechaCreacionFinal.date;
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

    if (diff > 31) {
        e.isValid = false;
        e.errorText = "Rango tiene que se menor o igual a 30 dias"
        return false;
    }
}

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

    if (diff > 31) {
        e.isValid = false;
        e.errorText = "Rango tiene que se menor o igual a 30 dias"
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
        $('#divEncabezado').html(s.cpMensaje);
    }
    if (s.cpNombreArchivo != null && s.cpNombreArchivo != '') {
        DescargarArchvo(s.cpNombreArchivo)
    }
}
function DescargarArchvo(archivo) {
    window.location.href = 'DescargarArchivoReportesCEM.aspx?nombreArchivo=' + archivo;
}
function EjecutarCallback(Opcion, Valor) {
    cpPrincipal.PerformCallback(Opcion + ':' + Valor);
}
function EjecutarConsulta() {
    var container = cpPrincipal.GetMainElement();
    if (ASPxClientEdit.ValidateEditorsInContainer(container)) {

        if (deFechaInicialAgenda.GetValue() == null && deFechaFinalAgenda.GetValue() == null && txtFechaCreacionInicial.GetValue() == null && txtFechaCreacionFinal.GetValue() == null && txtMsisdn.GetValue() == null && txtRadicado.GetValue() == null) {
            if (txtMsisdn.GetValue() == null && txtRadicado.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro valido')
            }
            else {
                alert('Debe seleccionar por lo menos una fecha Valida')
            }

        }
        else {
            EjecutarCallback('DescargarReporteIndicadoresCEM', '0')

        }
    }
}
    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div>
            <dx:ASPxCallbackPanel ID="cpPrincipal" ClientInstanceName="cpPrincipal" Width="40%" runat="server">
                <ClientSideEvents EndCallback="function(s, e) { LoadingPanel.Hide();
                    MostarEncabezado(s,e);
                    }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezado">
                            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="roundPanelFiltros" runat="server" ClientInstanceName="roundPanelFiltros" HeaderText="Filtros de Búsqueda" Width="70%" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table style="width: 100%">
                                        <tr>
                                            <td class="field">No. Radicado:</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtRadicado" runat="server" ClientInstanceName="txtRadicado" Theme="SoftOrange" TabIndex="0" Width="200px"></dx:ASPxTextBox>
                                            </td>
                                            <td class="field">MSISDN:</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtMsisdn" runat="server" ClientInstanceName="txtMsisdn" Theme="SoftOrange" TabIndex="0" Width="200px"></dx:ASPxTextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field">Tipo Servicio: </td>
                                            <td>
                                                <dx:ASPxComboBox ID="ddlTipoServicio" runat="server" ClientInstanceName="ddlTipoServicio"
                                                    AutoPostBack="false" Width="200px" Theme="SoftOrange" IncrementalFilteringMode="Contains"
                                                    ValueType="System.Int32" CallbackPageSize="25"
                                                    EnableCallbackMode="true" TabIndex="3">
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td class="field">Estado:</td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbEstado" runat="server" ClientInstanceName="cmbEstado"
                                                    AutoPostBack="false" Width="200px" Theme="SoftOrange" IncrementalFilteringMode="Contains"
                                                    ValueType="System.Int32" CallbackPageSize="25"
                                                    EnableCallbackMode="true" TabIndex="3">
                                                </dx:ASPxComboBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field">Fecha Agenda de:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaInicialAgenda" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="deFechaInicialAgenda" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Inicial" EnableClientSideAPI="true">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaAgenda" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                deFechaFinalAgenda.SetMinDate(deFechaInicialAgenda.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Hasta:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaFinalAgenda" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="deFechaFinalAgenda" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Lectura Final">
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
                                            <td class="field">Fecha Creación de: </td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaCreacionInicial" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaCreacionInicial" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Inicial" EnableClientSideAPI="true">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaCreacion" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaCreacionFinal.SetMinDate(txtFechaCreacionInicial.GetDate());
                                                            }" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Hasta:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="txtFechaCreacionFinal" runat="server" ValidationGroup="RptIndicador" ClientInstanceName="txtFechaCreacionFinal" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Lectura Final">
                                                    <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inv&aacute;lido. Fecha inicial menor que Fecha final. Rango menor que 30 d&iacute;as"
                                                        ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                    </ValidationSettings>
                                                    <ClientSideEvents Validation="ValidacionDeRangoFechaCreacion" />
                                                    <ClientSideEvents ValueChanged="function(s, e){
                                                                txtFechaCreacionInicial.SetMaxDate(txtFechaCreacionFinal.GetDate());
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
        <%--<script src="js/ReporteIndicadoresCEM.js"></script>--%>
    </form>
</body>
</html>
