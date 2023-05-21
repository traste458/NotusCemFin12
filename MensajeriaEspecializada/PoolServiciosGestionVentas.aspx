<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolServiciosGestionVentas.aspx.vb" Inherits="BPColSysOP.PoolServiciosGestionVentas" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register Src="~/ControlesDeUsuario/UcShowmessages.ascx" TagName="ShowMessage" TagPrefix="sm" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pool Servicios Gestión de Ventas</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var myWidth = 0, myHeight = 0;

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                rblTipoIdentificador.SetSelectedIndex(0);
                cbFormatoExportar.SetSelectedIndex(0);
            }
        }

        function OnExpandCollapseButtonClick(s, e) {
            var isVisible = pnlDatos.GetVisible();
            s.SetText(isVisible ? "+" : "-");
            pnlDatos.SetVisible(!isVisible);
        }

        function EvaluarClicFiltro(flag) {
            if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && datePreventaInicio.GetValue() == null && datePreventaFin.GetValue() == null
                && dateAnulaInicio.GetValue() == null && dateAnulaFin.GetValue() == null && meIdentificador.GetValue() == null
                    && txtIdentificacionCliente.GetValue() == null && txtIdentificacionCliente.GetValue() == null && txtNombreCliente.GetValue() == null
                && cmbCiudadEntrega.GetValue() == null && cmbEstado.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
            } else {
                if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null) {
                    alert('Debe digitar los dos rangos de fechas.');
                } else {
                    if (dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) {
                        alert('Debe digitar los dos rangos de fechas.');
                    } else {
                        if (datePreventaInicio.GetValue() == null && datePreventaFin.GetValue() != null) {
                            alert('Debe digitar los dos rangos de fechas.');
                        } else {
                            if (datePreventaInicio.GetValue() != null && datePreventaFin.GetValue() == null) {
                                alert('Debe digitar los dos rangos de fechas.');
                            } else {
                                if (dateAnulaInicio.GetValue() == null && dateAnulaFin.GetValue() != null) {
                                    alert('Debe digitar los dos rangos de fechas.');
                                } else {
                                    if (dateAnulaInicio.GetValue() != null && dateAnulaFin.GetValue() == null) {
                                        alert('Debe digitar los dos rangos de fechas.');
                                    } else {
                                        if (flag == 1) {
                                            cpGeneral.PerformCallback('BusquedaGeneral');
                                        } else { cpGeneral.PerformCallback('BusquedaDetallada'); }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        function grid_Init(s, e) {

        }

        function grid_BeginCallback(s, e) {

        }

        function grid_EndCallback(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
        }

        function TamanioVentana() {
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }
        }

        function VerDetalle(element, key) {
            TamanioVentana();
            dialogoVer.SetContentUrl("VerInformacionServicioTipoVenta.aspx?idServicio=" + key);
            dialogoVer.SetSize(myWidth * 0.8, myHeight * 0.8);
            dialogoVer.ShowWindow();
        }

        function Editar(element, key) {
            TamanioVentana();
            dialogoEditar.SetContentUrl("EditarServicioTipoVenta.aspx?idServicio=" + key);
            dialogoEditar.SetSize(myWidth * 0.9, myHeight * 0.95);
            dialogoEditar.ShowWindow();
        }

        function Anular(element, key) {
            var ctrlServicio = $("#" + idServicioAnular);
            ctrlServicio.val(key);
            memoObservacionAnular.SetText("");
            dialogoAnular.ShowWindow();
        }

        function Novedad(element, key) {
            var ctrlServicio = $("#" + idServicioNovedad);
            ctrlServicio.val(key);
            memoObservacionNovedad.SetText("");
            dialogoNovedad.ShowWindow();
        }

        function OnInitVer(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    dialogoVer.Hide();
                dialogoEditar.Hide();
            });
        }

        function DescargarReporte() {
            window.location.href = 'DescargaDeDocumentos.aspx?id=2';
        }

        function EvaluarFecha(flag) {
            if (flag == 1) {
                if (datePreventaInicio.GetDate() > datePreventaFin.GetDate()) {
                    alert("La fecha final debe ser mayor o igual a la fecha inicial");
                    datePreventaFin.SetDate(null);
                }
            } else {
                if (dateAnulaInicio.GetDate() > dateAnulaFin.GetDate()) {
                    alert("La fecha final debe ser mayor o igual a la fecha inicial");
                    dateAnulaFin.SetDate(null);
                }
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents EndCallback="function(s, e) { 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide(); }" />
        </dx:ASPxCallback>

        <script type="text/javascript">
            var idServicioAnular = "<%= hfIdServicioAnular.ClientID %>";
            var idServicioNovedad = "<%= hfIdServicioNovedad.ClientID %>";
        </script>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" Width="90%" ClientInstanceName="cpGeneral"
            EnableAnimation="true" >
            <ClientSideEvents EndCallback="function(s, e){
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpResultado == 0){
                    DescargarReporte();
                }
                LoadingPanel.Hide(); 
            }" />
            <PanelCollection>
                <dx:PanelContent ID="panelContenidoGeneral" runat="server">
                    <dx:ASPxRoundPanel ID="rpFiltro" runat="server"
                        HeaderText="Filtro de Búsqueda de Servicios">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="white-space: nowrap;" align="left">B&uacute;queda de servicios 
                                    </td>
                                    <td style="width: 1%; padding-left: 5px;">
                                        <dx:ASPxButton ID="btnExpandCollapse" runat="server" Text="-" AllowFocus="False"
                                            AutoPostBack="False" Width="20px">
                                            <Paddings Padding="1px" />
                                            <FocusRectPaddings Padding="0" />
                                            <ClientSideEvents Click="OnExpandCollapseButtonClick" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxPanel ID="pnlDatos" runat="server" Width="100%" ClientInstanceName="pnlDatos">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table cellpadding="1">
                                                <tr>
                                                    <td rowspan="2" class ="field">Identificador </td>
                                                    <td rowspan="2" colspan ="2">
                                                        <dx:ASPxMemo ID="meIdentificador" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios identificadores..."
                                                            ClientInstanceName="meIdentificador" TabIndex="1">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9]+\s*$" />
                                                            </ValidationSettings>
                                                        </dx:ASPxMemo>
                                                        <div>
                                                            <dx:ASPxRadioButtonList ID="rblTipoIdentificador" runat="server" RepeatDirection="Horizontal"
                                                                ClientInstanceName="rblTipoIdentificador" Font-Size="XX-Small" Height="10px">
                                                                <Items>
                                                                    <dx:ListEditItem Text="Servicio" Value="0" Selected="true" />
                                                                    <dx:ListEditItem Text="Teléfono Móvil" Value="1" />
                                                                </Items>
                                                                <Border BorderStyle="None"></Border>
                                                            </dx:ASPxRadioButtonList>
                                                        </div>
                                                        <div>
                                                            <dx:ASPxLabel ID="lblComentario" runat="server" Text="Listado de identificadores, por salto de línea (Enter)."
                                                                CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                        <%--<dx:ASPxTextBox ID="txtIdentificadorServicio" runat="server" Width="100px"
                                                            onkeypress="javascript:return ValidaNumero(event);" MaxLength="15">
                                                        </dx:ASPxTextBox>--%>
                                                    </td>
                                                    <td class ="field">Identificación del Cliente:</td>
                                                    <td colspan ="2">
                                                        <dx:ASPxTextBox ID="txtIdentificacionCliente" runat="server" Width="250px" ClientInstanceName ="txtIdentificacionCliente"
                                                            onkeypress="javascript:return ValidaNumero(event);" MaxLength="20" TabIndex ="2">
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                    <td class ="field">Nombres Cliente:</td>
                                                    <td>
                                                        <dx:ASPxTextBox ID="txtNombreCliente" runat="server" Width="250px" TabIndex ="3" ClientInstanceName ="txtNombreCliente">
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class ="field">Ciudad de entrega:</td>
                                                    <td colspan ="2">
                                                        <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" ValueType="System.Int32" Width ="250px" ClientInstanceName ="cmbCiudadEntrega"
                                                            IncrementalFilteringMode="Contains" TabIndex ="4">
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                    <td class ="field">Estado:</td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cmbEstado" runat="server" Width="250px" TabIndex ="5" IncrementalFilteringMode ="Contains"
                                                            ClientInstanceName ="cmbEstado">
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class ="field">Fecha Registro Inicio:</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" Width="200px" ClientInstanceName="dateFechaInicio" TabIndex ="6">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                            dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                        }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class ="field">Fecha Registro Fin:</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaFin" runat="server" Width="200px" ClientInstanceName="dateFechaFin" TabIndex ="7">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                            dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                        }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class ="field"> Fecha Aprobación Inicio</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="datePreventaInicio" runat="server" Width="200px" ClientInstanceName="datePreventaInicio" 
                                                             EditFormat ="Custom" TabIndex ="8" DisplayFormatString="dd-MMM-yyyy HH:mm">
                                                            <TimeSectionProperties Visible ="true">
                                                            </TimeSectionProperties>
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                //datePreventaFin.SetMinDate(datePreventaInicio.GetDate());
                                                        }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class ="field"> Fecha Aprobación Fin</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="datePreventaFin" runat="server" Width="200px" ClientInstanceName="datePreventaFin" 
                                                            EditFormat ="Custom" TabIndex ="9" DisplayFormatString="dd-MMM-yyyy HH:mm">
                                                            <TimeSectionProperties Visible ="true">
                                                                <TimeEditProperties EditFormatString ="hh:mm tt"></TimeEditProperties>
                                                            </TimeSectionProperties>
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                datePreventaInicio.SetMaxDate(datePreventaFin.GetDate());
                                                                EvaluarFecha(1);
                                                            }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class ="field"> Fecha Anulación Inicio</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateAnulaInicio" runat="server" Width="200px" ClientInstanceName="dateAnulaInicio" 
                                                             EditFormat ="Custom" TabIndex ="10" DisplayFormatString="dd-MMM-yyyy HH:mm">
                                                            <TimeSectionProperties Visible ="true">
                                                                <TimeEditProperties EditFormatString ="hh:mm tt"></TimeEditProperties>
                                                            </TimeSectionProperties>
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                //dateAnulaFin.SetMinDate(dateAnulaInicio.GetDate());
                                                        }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td class ="field"> Fecha Anulación Fin</td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateAnulaFin" runat="server" Width="200px" ClientInstanceName="dateAnulaFin" 
                                                            EditFormat ="Custom" TabIndex ="11" DisplayFormatString="dd-MMM-yyyy HH:mm">
                                                            <TimeSectionProperties Visible ="true">
                                                                <TimeEditProperties EditFormatString ="hh:mm tt"></TimeEditProperties>
                                                            </TimeSectionProperties>
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                dateAnulaInicio.SetMaxDate(dateAnulaFin.GetDate());
                                                                EvaluarFecha(2);
                                                            }" />
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td colspan="4" align="center">
                                                        <div style="text-align: center">
                                                            <dx:ASPxButton ID="btnBuscar" runat="server" Text="Buscar" Theme="Aqua"
                                                                Width="150px" Style="display: inline" AutoPostBack="false" TabIndex ="12">
                                                                <Image Url="../images/find.gif"></Image>
                                                                <ClientSideEvents Click="function(s, e) {
                                                                EvaluarClicFiltro(1);
                                                            }" />
                                                            </dx:ASPxButton>
                                                            &nbsp;&nbsp;
                                                        <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Theme="Aqua"
                                                            Width="150px" Style="display: inline" TabIndex ="13">
                                                            <Image Url="../images/eraserminus.gif"></Image>
                                                            <ClientSideEvents Click="function(s, e) {
                                                                LimpiaFormulario();
                                                            }" />
                                                        </dx:ASPxButton>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxPanel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>

                    <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server"
                        HeaderText="Resultado de Búsqueda" Width="100%" Style="margin-top: 10px">
                        <PanelCollection>
                            <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">

                                <dx:ASPxCallbackPanel ID="cpDatos" runat="server" Width="100%" ClientInstanceName="cpDatos">
                                    <PanelCollection>
                                        <dx:PanelContent ID="pcGrilla" runat="server">

                                            <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                                ClientInstanceName="gvDatos" KeyFieldName="idServicioMensajeria">
                                                <ClientSideEvents BeginCallback="grid_BeginCallback"
                                                    EndCallback="grid_EndCallback"
                                                    Init="grid_Init"></ClientSideEvents>
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="idServicioMensajeria"
                                                        ShowInCustomizationForm="True" VisibleIndex="0" Caption="ID">
                                                    </dx:GridViewDataTextColumn>

                                                    <dx:GridViewDataTextColumn FieldName="fecha"
                                                        ShowInCustomizationForm="True" VisibleIndex="1" Caption="Fecha Registro">
                                                        <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="nombreJornada" ShowInCustomizationForm="True"
                                                        VisibleIndex="2" Caption="Jornada Agenda">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="fechaAgenda"
                                                        ShowInCustomizationForm="True" VisibleIndex="3" Caption="Fecha Agenda">
                                                        <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="nombreEstado" ShowInCustomizationForm="True"
                                                        VisibleIndex="4" Caption="Estado">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="nombreCiudad" ShowInCustomizationForm="true"
                                                        VisibleIndex="5" Caption="Ciudad">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="nombreCliente"
                                                        ShowInCustomizationForm="True" VisibleIndex="6" Caption="Nombre Cliente">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Identificación" VisibleIndex="7"
                                                        FieldName="identificacionCliente">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="barrio" ShowInCustomizationForm="True"
                                                        VisibleIndex="8" Caption="Barrio">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="direccion" ShowInCustomizationForm="True"
                                                        VisibleIndex="9" Caption="Dirección">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="fechaAprobacion"
                                                        ShowInCustomizationForm="True" VisibleIndex="10" Caption="Ultima Fecha Aprobación">
                                                        <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="fechaAnulacion"
                                                        ShowInCustomizationForm="True" VisibleIndex="11" Caption="Ultima Fecha Anulación">
                                                        <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="12">
                                                        <DataItemTemplate>
                                                            <dx:ASPxHyperLink runat="server" ID="lnkVerDetalle" OnInit="Link_Init"
                                                                ImageUrl="../images/view.png" ToolTip="Ver detalle" Cursor="pointer">
                                                                <ClientSideEvents Click="function(s, e) { VerDetalle(this, {0}); }" />
                                                            </dx:ASPxHyperLink>

                                                            <dx:ASPxHyperLink runat="server" ID="lnkAutorizarPreventa" ImageUrl="../images/note-accept.png" Cursor="pointer"
                                                                ToolTip="Autorizar Preventa">
                                                                <ClientSideEvents Click="function(s, e) {
                                                                        if(confirm('¿Realmente desea confirmar la preventa?')) {
                                                                            gvDatos.PerformCallback('{0}'+':confirmar'); 
                                                                        }
                                                                    }" />
                                                            </dx:ASPxHyperLink>

                                                            <dx:ASPxHyperLink runat="server" ID="lnkAnular" ImageUrl="../images/cross.png" Cursor="pointer"
                                                                ToolTip="Anular Preventa">
                                                                <ClientSideEvents Click="function(s, e) { Anular(this, {0}); }" />
                                                            </dx:ASPxHyperLink>

                                                            <dx:ASPxHyperLink runat="server" ID="lnkNovedad" ImageUrl="../images/comment_add.png" Cursor="pointer"
                                                                ToolTip="Adicionar Novedad">
                                                                <ClientSideEvents Click="function(s, e) { Novedad(this, {0}); }" />
                                                            </dx:ASPxHyperLink>

                                                            <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/Edit-User.png" Cursor="pointer"
                                                                ToolTip="Editar Servicio">
                                                                <ClientSideEvents Click="function(s, e) { Editar(this, {0}); }" />
                                                            </dx:ASPxHyperLink>

                                                        </DataItemTemplate>
                                                    </dx:GridViewDataColumn>
                                                </Columns>
                                                <SettingsBehavior AutoExpandAllGroups="True" EnableCustomizationWindow="True"></SettingsBehavior>
                                                <Settings VerticalScrollableHeight="300" />
                                                <SettingsPager PageSize="50">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                </SettingsPager>
                                                <Settings ShowGroupPanel="false"></Settings>
                                                <Settings ShowHeaderFilterButton="True"></Settings>
                                                <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                                <SettingsText Title="B&#250;squeda General de Ventas" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                            </dx:ASPxGridView>
                                            <dx:ASPxGridViewExporter ID="gveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </dx:PanelContent>

                        </PanelCollection>
                    </dx:ASPxRoundPanel>

                    <dx:ASPxPopupControl ID="pcVer" runat="server" ClientInstanceName="dialogoVer"
                        HeaderText="Información de Venta" AllowDragging="true"
                        Width="310px" Height="160px" Modal="true"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                        <ClientSideEvents Init="OnInitVer"></ClientSideEvents>
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server"></dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                    <dx:ASPxPopupControl ID="pcEdidar" runat="server" ClientInstanceName="dialogoEditar"
                        HeaderText="Modificación de la Venta" AllowDragging="true"
                        Width="310px" Height="160px" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                        <ClientSideEvents Init="OnInitVer" CloseUp="function (s, e){ cpGeneral.PerformCallback('BusquedaGeneral'); }"></ClientSideEvents>
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server"></dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                    <dx:ASPxPopupControl ID="pcAnular" runat="server" ClientInstanceName="dialogoAnular"
                        HeaderText="Anular Preventa" AllowDragging="true" Width="310px" Height="160px"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        Modal="True">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table cellpadding="1">
                                    <tr>
                                        <td>Tipo de Novedad:</td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipoNovedadAnular" runat="server" ValueType="System.Int32" ClientInstanceName="cmbTipoNovedadAnular">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgAnular">
                                                    <RequiredField ErrorText="Debe seleccionar un tipo de novedad"
                                                        IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                            <asp:HiddenField ID="hfIdServicioAnular" runat="server" Value="0" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Observación:</td>
                                        <td>
                                            <dx:ASPxMemo ID="memoObservacionAnular" runat="server" Height="71px" Width="170px" ClientInstanceName="memoObservacionAnular">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgAnular">
                                                    <RequiredField ErrorText="Debe ingresar una observación" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxMemo>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <div style="text-align: center; width: 100%">
                                                <dx:ASPxButton ID="btnAnular" runat="server" Text="Anular" Width="110px"
                                                    Style="display: inline" ValidationGroup="vgAnular">
                                                </dx:ASPxButton>
                                                &nbsp;&nbsp;
                                                    <dx:ASPxButton ID="btnCancelar" runat="server" Text="Cancelar" Style="display: inline"
                                                        AutoPostBack="false" Width="110px">
                                                        <ClientSideEvents Click="function(s, e){
                                                            dialogoAnular.Hide();
                                                        }" />
                                                    </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                    <dx:ASPxPopupControl ID="pcNovedad" runat="server" ClientInstanceName="dialogoNovedad"
                        HeaderText="Adicionar Novedad" AllowDragging="true" Width="310px" Height="160px"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        Modal="true">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table cellspacing="1">
                                    <tr>
                                        <td>Tipo de Novedad:</td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipoNovedadNovedad" runat="server" ValueType="System.Int32" ClientInstanceName="cmbTipoNovedadNovedad">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgNovedad">
                                                    <RequiredField ErrorText="Debe sereccionar una tipo de novedad"
                                                        IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                            <asp:HiddenField ID="hfIdServicioNovedad" runat="server" Value="0" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Observación:</td>
                                        <td>
                                            <dx:ASPxMemo ID="memoObservacionNovedad" runat="server" Height="71px" Width="170px" ClientInstanceName="memoObservacionNovedad">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgNovedad">
                                                    <RequiredField ErrorText="Debe ingresar una observación" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxMemo>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <div style="text-align: center; width: 100%">
                                                <dx:ASPxButton ID="btnAdicionarNovedad" runat="server" Text="Adicionar" Width="110px"
                                                    Style="display: inline" ValidationGroup="vgNovedad">
                                                </dx:ASPxButton>
                                                &nbsp;&nbsp;
                                                    <dx:ASPxButton ID="btnCancelarNovedad" runat="server" Text="Cancelar" Style="display: inline"
                                                        AutoPostBack="false" Width="110px">
                                                        <ClientSideEvents Click="function(s, e){
                                                            dialogoNovedad.Hide();
                                                        }" />
                                                    </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                        Modal="true">
                    </dx:ASPxLoadingPanel>

                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <sm:ShowMessage ID="smPrincipal" runat="server" />
        <div id="bluebar" class="menuFlotante">
            <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4">
            </b></b>
            <table style="width: 99%;">
                <tr>
                    <td>
                        <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                            SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                            AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                            Width="250px">
                            <Items>
                                <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                    Selected="true" />
                                <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                            </Items>
                            <Buttons>
                                <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                    <Image Url="../images/upload.png">
                                    </Image>
                                </dx:EditButton>
                            </Buttons>
                            <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular">
                                </RegularExpression>
                                <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                            </ValidationSettings>
                        </dx:ASPxComboBox>
                    </td>
                    <td align="right">
                        <dx:ASPxImage ID="imgExtendido" runat="server" ImageUrl="../images/MSExcel.png" ToolTip="Reporte Extendido"
                            Cursor="pointer" Height ="30%" Width ="30%">
                            <ClientSideEvents Click ="function (s, e){
                                EvaluarClicFiltro(2);
                            }" />
                        </dx:ASPxImage> 
                    </td>
                    <td>
                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Descargar Reporte Extendido." ForeColor ="White"
                            CssClass="comentario" Width="170px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                        </dx:ASPxLabel>
                    </td>
                </tr>
            </table> 
        </div> 
        <div id="div1" style="float: right; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 2%; position: fixed; overflow: hidden; display: block; bottom: 0px">
        <table>
            <tr>
                <td align="right">
                    <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="a1"
                        onclick="toggle('bluebar');">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/structure.png" ToolTip="Ocultar/Mostrar, Menú "
                            Width="16px" /></a>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
