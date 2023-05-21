<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NotificacionesCEMReporte.aspx.vb" 
Inherits="BPColSysOP.NotificacionesCEMReporte" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte Notificaciones CEM</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function FiltrarDevExpCiudad(s, e) {
            try {
                if (s.GetText().length >= 4 || cmbCiudad.GetItemCount() != 0) {
                    cpFiltroCiudad.PerformCallback(s.GetText());
                } else {
                if (cmbCiudad.GetItemCount() == 0) {
                    cmbCiudad.ClearItems();
                    //cpFiltros.PerformCallback("cargar");
                }
                    }
            }
            catch (e) { }
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                gvDatos.PerformCallback("limpiar");
                cpFiltros.PerformCallback("cargar");
            }
        }

        function EvaluarClicFiltro() {
            if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && meRadicado.GetValue() == null && cmbCiudad.GetValue() == null
                && cmbBodega.GetValue() == null && cmbTipo.GetValue() == null && cmbEstado.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
            } else {
                if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null) {
                    alert('Debe digitar los dos rangos de fechas.');
                } else {
                    if (dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) {
                        alert('Debe digitar los dos rangos de fechas.');
                    } else { gvDatos.PerformCallback("reporte"); }
                }
            }
        }

        function ValidarEnter(flag) {
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                if (flag == 1) {
                    btnRegistro.DoClick();
                } 
            }
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) {
                $('#divEncabezado').html(s.cpMensaje);
            }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="width: 90%; min-width: 500px">
        <table>
            <tr>
                <td align="left">
                    <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="aLecturas"
                        onclick="toggle('divFiltros');">
                        <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Filtros Búsqueda"
                            Width="16px" /></a>
                </td>
            </tr>
        </table>
    </div>
    <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 65%;">
        <dx:ASPxCallbackPanel ID="cpFiltros" runat="server" ClientInstanceName="cpFiltros">
            <ClientSideEvents EndCallback="function(s, e) { 
                    $('#divEncabezado').html(s.cpMensaje);
                }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de Búsqueda"
                        Width="100%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%" onkeydown ="ValidarEnter(1);">
                                    <tr>
                                        <td class ="field" align ="left" rowspan ="2">
                                            Radicado(s):
                                        </td>
                                        <td rowspan="2">
                                            <dx:ASPxMemo ID="meRadicado" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios Radicados..."
                                                ClientInstanceName="meRadicado" TabIndex="1">
                                                <ClientSideEvents KeyDown ="function(s, e){
                                                    ValidarEnter(2);
                                                }" />
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                    <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                </ValidationSettings>
                                            </dx:ASPxMemo>
                                            <div>
                                                <dx:ASPxLabel ID="lblComentario" runat="server" Text="Listado de radicados, separados por salto de línea (Enter)."
                                                    CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                        <td class ="field" align ="left">
                                            Ciudad:
                                        </td>
                                        <td>
                                            <div style="display: inline; float: left;">
                                                <dx:ASPxTextBox ID="txtCiudadFiltro" runat="server" Width="50px" MaxLength="15" TabIndex="2">
                                                    <ClientSideEvents KeyUp="function(s, e) { 
                                                        FiltrarDevExpCiudad(s, e) 
                                                    }"></ClientSideEvents>
                                                </dx:ASPxTextBox>
                                            </div>
                                            <dx:ASPxCallbackPanel ID="cpFiltroCiudad" runat="server" RenderMode="Div" ClientInstanceName="cpFiltroCiudad">
                                                <ClientSideEvents EndCallback="function(s, e) {}"></ClientSideEvents>
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <div style="display: inline; float: left">
                                                            <dx:ASPxComboBox ID="cmbCiudad" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                                                ClientInstanceName="cmbCiudad" DropDownStyle="DropDownList" ValueField="idCiudad"
                                                                TabIndex="3">
                                                                <Columns>
                                                                    <dx:ListBoxColumn FieldName="nombre" Width="170px" Caption="Nombre" />
                                                                    <dx:ListBoxColumn FieldName="departamento" Width="170px" Caption="Departamento" />
                                                                </Columns>
                                                                <ClientSideEvents SelectedIndexChanged ="function (s, e){
                                                                    //cpFiltros.PerformCallback(cmbCiudad.GetValue());
                                                                }" />
                                                            </dx:ASPxComboBox>
                                                        </div>
                                                        <div id="divResultadoCiudad">
                                                            <dx:ASPxLabel ID="lblResultadoCiudad" runat="server" CssClass="comentario" Width="200px">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </td>
                                        <td class ="field" align ="left">
                                            Bodega
                                        </td>
                                        <td>
                                            <div style="float: left; width: 200px">
                                                <dx:ASPxComboBox ID="cmbBodega" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                                    ClientInstanceName="cmbBodega" DropDownStyle="DropDownList" TabIndex="4" ValueField="idBodega"
                                                    ValueType="System.String" TextFormatString="{0} ({1})" >
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="idbodega" Width="50px" Caption="Id." />
                                                        <dx:ListBoxColumn FieldName="bodega" Width="300px" Caption="Bodega" />
                                                    </Columns>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" align ="left">
                                            Tipo Notificación:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipo" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbTipo" DropDownStyle="DropDownList" TabIndex="5">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idAsuntoNotificacion" Width="50px" Caption="Id." />
                                                    <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Notificación" />
                                                </Columns>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td class ="field" align ="left">
                                            Estado Radicado
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbEstado" runat="server" Width="200px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbEstado" DropDownStyle="DropDownList" TabIndex="5">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idEstado" Width="50px" Caption="Id." />
                                                    <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Estado" />
                                                </Columns>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field" align="left">
                                            Fecha Inicial:
                                        </td>
                                        <td>
                                            <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                Width="90px" TabIndex ="7">
                                                <ClientSideEvents ValueChanged="function(s, e){
                                                    dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                }" />
                                            </dx:ASPxDateEdit>
                                        </td>
                                        <td class="field" align="left">
                                            Fecha Final:
                                        </td>
                                        <td>
                                            <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                Width="90px" TabIndex ="8">
                                                <ClientSideEvents ValueChanged="function(s, e){
                                                        if (dateFechaInicio.GetDate()==null){
                                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                        }
                                                    }" />
                                            </dx:ASPxDateEdit>
                                        </td>
                                        
                                    </tr>
                                    <tr>
                                        <td colspan ="3" align ="right">
                                            <dx:ASPxImage ID="imgFiltrar" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Filtrar" ClientInstanceName="imgFiltrar" Cursor="pointer" TabIndex ="9">
                                                <ClientSideEvents Click="function(s, e){
                                                        if(ASPxClientEdit.ValidateGroup('vgFiltro')){
                                                            btnRegistro.DoClick();
                                                            }        
                                                    }" />
                                            </dx:ASPxImage>
                                            <div>
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Filtrar" CssClass="comentario">
                                                </dx:ASPxLabel>
                                            </div>
                                            <dx:ASPxButton ID="btnRegistro" runat ="server" ClientInstanceName ="btnRegistro" AutoPostBack ="false" ClientVisible ="false">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgFiltro')){
                                                        EvaluarClicFiltro();
                                                        }        
                                                }" />
                                            </dx:ASPxButton>
                                        </td>
                                        <td colspan ="2" align ="left">
                                            <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros"
                                                    ClientInstanceName="imgBorrar" Cursor="pointer" TabIndex ="10">
                                                <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                            </dx:ASPxImage>
                                            <div>
                                                <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                        <td>
                                            <dx:ASPxImage ID="imgExcel" runat="server" ImageUrl="../images/MSExcel.png" ToolTip="Descargar Reporte"
                                                    ClientInstanceName="imgExcel" Cursor="pointer" ClientVisible ="false">
                                                <ClientSideEvents Click="function(s, e){
                                                        btnDescarga.DoClick();
                                                    }" />
                                            </dx:ASPxImage>
                                            <div>
                                                <dx:ASPxLabel ID="lblDescarga" runat="server" Text="Descargar Reporte" CssClass="comentario" 
                                                    ClientInstanceName ="lblDescarga" ClientVisible ="false">
                                                </dx:ASPxLabel>
                                            </div>
                                            <dx:ASPxButton id="btnDescarga" runat ="server" ClientInstanceName ="btnDescarga" ClientVisible ="false"></dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel> 
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel> 
    </div>
    <div style="clear: both"></div>
    <div id ="divResultado" style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px; width:60%; visibility:hidden">
        <dx:ASPxRoundPanel ID="rpResultado" runat="server" HeaderText="Resultados de Búsqueda"
            Width="150%" Theme ="SoftOrange">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gvDatos" runat="server" Width="100%" AutoGenerateColumns="False"
                        ClientInstanceName="gvDatos" KeyFieldName="NumeroRadicado" Theme ="SoftOrange">
                        <ClientSideEvents EndCallback="function(s, e) {
                            $('#divEncabezado').html(s.cpMensaje);
                            if (s.cpDatos==1){
                                $('#divResultado').css('visibility', 'visible');
                                imgExcel.SetVisible(true);
                                lblDescarga.SetVisible(true);
                            } else {
                                    $('#divResultado').css('visibility', 'hidden')
                                    imgExcel.SetVisible(false);
                                    lblDescarga.SetVisible(false);
                                   }
                        }"></ClientSideEvents>
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="NumeroRadicado" Caption="Número Radicado" ShowInCustomizationForm="True"
                                VisibleIndex="0">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Bodega" Caption="Bodega" ShowInCustomizationForm="True"
                                VisibleIndex="1">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="UsuarioRegistro" Caption="Usuario Registro" ShowInCustomizationForm="True"
                                VisibleIndex="2">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" ShowInCustomizationForm="True"
                                VisibleIndex="3">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Novedad" Caption="Novedad" ShowInCustomizationForm="True"
                                VisibleIndex="4" Width ="200px">
                            </dx:GridViewDataTextColumn>
                        </Columns> 
                        <SettingsPager PageSize="50">
			                <PageSizeItemSettings Visible="true" ShowAllItem="true" />
		                </SettingsPager>
                        <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                        <SettingsDetail ShowDetailRow="True"></SettingsDetail>
                        <Templates>
                            <DetailRow>
                                <dx:ASPxGridView ID="gvDetalle" ClientInstanceName="gvDetalle" runat="server" AutoGenerateColumns="false"
                                    Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect" Theme ="SoftOrange">
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="Material" Caption="Material" ShowInCustomizationForm="True"
                                            VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Descripcion" Caption="Descripción"
                                            ShowInCustomizationForm="True" VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Cantidad" Caption="Cantidad" ShowInCustomizationForm="True"
                                            VisibleIndex="2">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="FechaReporteNoDisponibilidad" Caption="Fecha Reporte Sin Disponibilidad" ShowInCustomizationForm="True"
                                            VisibleIndex="3">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <Settings ShowFooter="false" />
                                </dx:ASPxGridView>
                            </DetailRow>
                        </Templates> 
                    </dx:ASPxGridView>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel> 
    </div> 
    </form>
</body>
</html>
