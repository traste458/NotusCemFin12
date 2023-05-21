<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolVerificacionMesaControl.aspx.vb" Inherits="BPColSysOP.PoolVerificacionMesaControl" ValidateRequest="false" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Pool de Servicios ::</title>
    <script type="text/javascript" src="../include/jquery-1.12.4.js"></script>
    <script type="text/javascript" src="../include/jquery-1.12.1-ui.js"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">


        function verServicio(idServicio, idTiposervicio) {

            PopUpSetContenUrl(pcGeneral, 'VerInformacionServicio.aspx?idServicio=' + idServicio, '0.9', '0.9');
            pcGeneral.SetHeaderText(" Información del Servicio");
            pcGeneral.RefreshContentUrl();
        }
        function CargarArchivos(idServicio, idTiposervicio) {
            PopUpSetContenUrl(pcGeneral, 'CargarDocumentosMesaControl.aspx?idServicio=' + idServicio, '0.9', '0.9');
            pcGeneral.SetHeaderText("Documentos mesa de contorl");
            pcGeneral.RefreshContentUrl();
        }


        function SetImageState(value) {
            var img = document.getElementById('imgButton');
            var imgSrc = value ? '../images/arrow_up2.gif' : '../images/DxView24.png';
            img.src = imgSrc;
        }

        function AbrirCancelarServicioMensajeria(opcion, idServicio) {
            EjecutarCallbackGeneral(LoadingPanel, cpGeneral, opcion, idServicio);
            //setTimeout('pcAbrirCancelarServicio.Hide()', 1000);
            pcAbrirCancelarServicio.Hide();
        }
        function ReactivarServicio(idServicio) {
            txtNuevoRadicado.SetText('');
            txtObservacionReactivacion.SetValue('');
            hfReactivarIdServicio.Set('idServicio', idServicio);
            pcReactivarServicio.Show();

        }
        function QuitarCheckReagenda(idServicio, idTiposervicio) {
            if (confirm('¿Realmente desea quitar el check de reagendamiento?')) {
                lblIdServicio.SetText(idServicio);
                pcReagenda.Show();
            } else {
                pcReagenda.Hide();
            }
        }
        function QuitarReagenda(s, e) {
            pcReagenda.Hide();
            gvDatos.PerformCallback('QuitarCheckReagenda' + ':' + lblIdServicio.GetValue());

        }

        function EjecutarCallback(s, e, opcion, idServicio, idTiposervicio) {
            gvDatos.PerformCallback(opcion + ':' + idServicio + ':' + idTiposervicio);
        }
        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                //cmbEquipo.SetSelectedIndex(0);
                //gvMatrialClaseSim.PerformCallback(null);
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }
        function GuardarNovedad(s, e) {
            EjecutarCallbackGeneral(LoadingPanel, cpPopEstado, 'GuardarNovedad', s);

            popEstadoMesaControl.Hide();
        }

        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
                LoadingPanel.Hide();
            }
            if (s.cpDescargarArchivo) {
                if (s.cpDescargarArchivo.length > 0) {
                    window.open(s.cpDescargarArchivo, 'Adendo', 'status=1, toolbar=0, location=0,menubar=1,directories=0,resizable=1,scrollbars=1');
                }
            }


        }
        function GetPopupControl() {
            return ASPxPopupClientControl;
        }


        function ValidaNumeros(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (((charCode == 8) || (charCode == 46) || (charCode == 13) ||
                (charCode >= 35 && charCode <= 40) ||
                (charCode >= 48 && charCode <= 57) ||
                (charCode >= 96 && charCode <= 105) ||
                (charCode == 9))) {
                return true;
            }
            else {
                alert('Este campo solo admite números', 'rojo');
                return false;
            }
        }


    </script>
</head>
<body class="cuerpo2">

    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <script type="text/javascript">
            function EstadoMesaControl(s, e) {
                if (s != '') {
                    hdnIdNovedad.Set('idServicio', s);

                }
                hdnIdOrigen.Set('origen', 1);

                EjecutarCallbackGeneral(LoadingPanel, cpPopEstado, 'CargarCausal', 1);
                popEstadoMesaControl.Show();
            }
            function DevolucionMTI(s, e) {
                hdnIdNovedad.Set('idServicio', s);
                hdnIdOrigen.Set('origen', 2);
                EjecutarCallbackGeneral(LoadingPanel, cpPopEstado, 'CargarCausal', 2);
                popEstadoMesaControl.Show();
            }
        </script>


        <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />
        <dx:ASPxHiddenField runat="server" ID="hdnIdNovedad" ClientInstanceName="hdnIdNovedad"></dx:ASPxHiddenField>
        <dx:ASPxHiddenField runat="server" ID="hdnIdOrigen" ClientInstanceName="hdnIdOrigen"></dx:ASPxHiddenField>

        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" AutoPostBack="false">
            <ClientSideEvents EndCallback="function (s, e){
				 LoadingPanel.Hide();
				FinalizarCallbackGeneral(s, e, 'divEncabezado');
				MostrarInfoEncabezado(s,e);
			   
			}" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdServicio" runat="server" ClientInstanceName="hdIdServicio"></dx:ASPxHiddenField>
                    <dx:ASPxHiddenField ID="hfReactivarIdServicio" ClientInstanceName="hfReactivarIdServicio" runat="server"></dx:ASPxHiddenField>
                    <div style="float: left; width: 56%; margin-right: 2%">
                        <span runat="server" enableviewstate="False" id="Span1" style="cursor: pointer;">
                            <img id="imgButton" alt="" src="../images/DxView24.png" style="width: 28px; height: 28px;" />
                        </span>
                    </div>
                    <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 70%; height: 40%;">
                        <dx:ASPxPopupControl ClientInstanceName="ASPppfiltro" Width="530px" Height="250px"
                            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                            ShowFooter="false" PopupElementID="imgButton" HeaderText="Filtros de Búsqueda"
                            runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="ppFiltroBusqueda" runat="server">
                                    <dx:ASPxRoundPanel ID="rpFiltros" runat="server" Height="40%" ShowHeader="false">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxFormLayout ID="flFiltro" runat="server" ColCount="3" Height="60%">
                                                    <Items>
                                                        <dx:LayoutItem Caption="No. Radicado:" RequiredMarkDisplayMode="Required" ColSpan="3" Height="20%">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                    <div>
                                                                        <dx:ASPxRadioButtonList ID="rblTipoServicio" runat="server" RepeatDirection="Horizontal"
                                                                            ClientInstanceName="rblTipoServicio" Font-Size="XX-Small" Height="10px">
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Servicio" Value="0" />
                                                                                <dx:ListEditItem Text="Radicado" Value="1" Selected="true" />
                                                                            </Items>
                                                                            <Border BorderStyle="None"></Border>
                                                                        </dx:ASPxRadioButtonList>
                                                                    </div>
                                                                    <dx:ASPxMemo ID="mePedidos" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios servicios..."
                                                                        ClientInstanceName="mePedidos" TabIndex="0">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                                            <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9\s\-]+\s*$" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxMemo>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="Estado:" RequiredMarkDisplayMode="Required">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                    <dx:ASPxComboBox ID="cmbEstado" runat="server" ClientInstanceName="cmbEstado" Width="250px"
                                                                        IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idEstado">
                                                                        <Columns>
                                                                            <dx:ListBoxColumn FieldName="idEstado" Caption="Id" Width="20px" Visible="false" />
                                                                            <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="300px" />
                                                                        </Columns>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="Numero Identificaión:" ColSpan="2" RequiredMarkDisplayMode="Required">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                                    <dx:ASPxTextBox ID="TextBIdentificaion" ClientInstanceName="TextBIdentificaion" onkeypress="return CargarVentaMesaControl(event);" runat="server" Width="170px">
                                                                        <%--              <ClientSideEvents LostFocus="function(s, e) {
																				return CargarVentaMesaControl(event);
																				}" />--%>
                                                                    </dx:ASPxTextBox>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="Fecha verificacion Inicial:" RequiredMarkDisplayMode="Required">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                                    <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                                                        Width="100px" TabIndex="6">
                                                                        <ClientSideEvents ValueChanged="function(s, e){
																							dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
																						}" />
                                                                    </dx:ASPxDateEdit>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="Fecha verificacion Final:" RequiredMarkDisplayMode="Required">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                                    <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                                                        Width="100px" TabIndex="7">
                                                                        <ClientSideEvents ValueChanged="function(s, e){
																			dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
																			}" />
                                                                    </dx:ASPxDateEdit>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>


                                                        <dx:LayoutItem Caption="Eventos" ColSpan="3">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                                    <div style="float: left">
                                                                        <dx:ASPxImage ID="imgBuscar" runat="server" ImageUrl="../images/filtro.png" ToolTip="Búsqueda"
                                                                            ClientInstanceName="imgBuscar" Cursor="pointer">
                                                                            <ClientSideEvents Click="function(s, e){

																				if(ASPxClientEdit.ValidateGroup('vgFiltro')){
																						 if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() == null && mePedidos.GetValue() == null 
																								&& cmbEstado.GetValue() == null &&  TextBIdentificaion.GetValue() == null) {
																							alert('Debe seleccionar por lo menos un filtro de búsqueda.');
																						} else {
																							if (dateFechaInicio.GetValue() == null && dateFechaFin.GetValue() != null) {
																								alert('Debe digitar los dos rangos de fechas.');
																							} else {
																								if (dateFechaInicio.GetValue() != null && dateFechaFin.GetValue() == null) {
																									alert('Debe digitar los dos rangos de fechas.');
																								} else { EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 1);}
																							}
																						}
																					}
																				}" />
                                                                        </dx:ASPxImage>
                                                                        <div>
                                                                            <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="Filtrar" CssClass="comentario">
                                                                            </dx:ASPxLabel>
                                                                        </div>
                                                                    </div>
                                                                    <div style="float: left">
                                                                        <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/cancelar.png" ToolTip="Borrar Filtros"
                                                                            ClientInstanceName="imgBuscar" TabIndex="10" Cursor="pointer">
                                                                            <ClientSideEvents Click="function(s, e){
																						LimpiaFormulario('formPrincipal');
															   
																						cbFormatoExportar.SetSelectedIndex(0);
																
																					}" />
                                                                        </dx:ASPxImage>
                                                                        <div>
                                                                            <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                                            </dx:ASPxLabel>
                                                                        </div>
                                                                    </div>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                    </Items>
                                                </dx:ASPxFormLayout>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                            <ClientSideEvents CloseUp="function(s, e) { SetImageState(false); }" PopUp="function(s, e) { SetImageState(true); }" />
                        </dx:ASPxPopupControl>
                    </div>
                    <br />
                    <table>
                        <tr>
                            <td>
                                <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                    SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                    AutoPostBack="true" ClientInstanceName="cbFormatoExportar"
                                    Width="250px">
                                    <ClientSideEvents ButtonClick="function(s, e) {
																		LoadingPanel.Show();
																	setTimeout('LoadingPanel.Hide();',2000);                                                                   
																	}" />
                                    <Items>
                                        <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" Selected="true" />
                                    </Items>
                                    <Buttons>
                                        <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                            <Image Url="../images/upload.png">
                                            </Image>
                                        </dx:EditButton>
                                    </Buttons>
                                    <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                        Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                        <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                        <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                    KeyFieldName="idServicioMensajeria" Width="100%">
                                    <ClientSideEvents EndCallback="function(s, e) {                                           
										 LoadingPanel.Hide();
										}"></ClientSideEvents>
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="1" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID="lbVer" runat="server" ImageUrl="~/images/view.png" Cursor="pointer" ClientVisible="true"
                                                    ToolTip="Ver Información del Servicio" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e){
														  verServicio({0},{1}) ;
													
												}" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="lnkCargarArchivo" ClientInstanceName="lnkCargarArchivo" runat="server" ImageUrl="~/images/upload.png" Cursor="pointer" ClientVisible="false"
                                                    ToolTip="Cargar Documentos" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
														  CargarArchivos({0},{1}) ;                                                    
												}" />
                                                </dx:ASPxHyperLink>

                                                <dx:ASPxHyperLink ID="lnkConfirma" runat="server" ImageUrl="~/images/confirmation.png" Cursor="pointer" ClientVisible="false"
                                                    ToolTip="Confirmar Servicio" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
														  ConfirmarServicio({0},{1}) ;                                                    
												}" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="lnkDespacho" runat="server" ImageUrl="~/images/trans_small.png" Cursor="pointer" ClientVisible="false"
                                                    ToolTip="Despachar Pedido" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
														  DespachoServicio({0},{1}) ;                                                    
												}" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="lnkEstados" runat="server" ImageUrl="~/images/element.png" Cursor="pointer" ClientVisible="false"
                                                    ToolTip="Estado Mesa de Control" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
															EstadoMesaControl({0},{1});}" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="lnkDevoluconMTI" runat="server" ImageUrl="~/images/restart.png" Cursor="pointer" ClientVisible="false"
                                                    ToolTip="Devolucion" OnInit="LinkDatos_Init">
                                                    <ClientSideEvents Click="function(s, e){
															DevolucionMTI({0},{1});}" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxCheckBox ID="ChckeEnviarabanco" ClientInstanceName="ChckeEnviarabanco" AutoPostBack="false" runat="server" HeaderText="reagenda" ClientVisible="false" OnInit="LinkDatosCheck_Init"
                                                    ToolTip="Enviar servicios al banco">
                                                    <ClientSideEvents CheckedChanged="function(s,e){QuitarCheckReagenda({0},{1}); }" />
                                                </dx:ASPxCheckBox>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="Id Servicio" FieldName="idServicioMensajeria" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="N&uacute;mero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="4" Caption="Tipo de Servicio" FieldName="tipoServicio" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="5" Caption="Fecha Recepcion Mesa de Control" FieldName="fechaRecepcionMesaControl" ShowInCustomizationForm="true">
                                            <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="9" Caption="Jornada" FieldName="jornada" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Estado" FieldName="estado" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="14" Caption="Nombre de Cliente" FieldName="nombreCliente" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="15" Caption="Persona de Contacto" FieldName="personaContacto" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="16" Caption="Ciudad Cliente" FieldName="ciudadCliente" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="17" Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex="19" Caption="Tel&eacute;fono" FieldName="telefonoContacto" ShowInCustomizationForm="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn VisibleIndex="22" Caption="">
                                            <DataItemTemplate>
                                                </td> </tr>
												<tr>
                                                    <td class="field">Observaci&oacute;n
                                                    </td>
                                                    <td colspan="16" style="text-align: left">
                                                        <asp:Literal runat="server" ID="ltObservacion" Text='<%# Bind("Observacion") %>'></asp:Literal>
                                                    </td>
                                                </tr>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                    <SettingsBehavior AllowSelectByRowClick="true" />
                                    <Settings ShowHeaderFilterButton="false"></Settings>
                                    <SettingsPager PageSize="20">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                    </SettingsPager>
                                    <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                    <SettingsText Title="Resultado B&#250;squeda"
                                        EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                </dx:ASPxGridView>
                                <dx:ASPxGridViewExporter ID="expgveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                            </td>
                        </tr>
                    </table>


                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

        <div>

            <dx:ASPxPopupControl ID="pcGeneral" runat="server" EnableViewState="False" AutoPostBack="false"
                ClientInstanceName="pcGeneral" Modal="True" CloseAction="CloseButton"
                HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True" RefreshButtonStyle-Wrap="True" ShowRefreshButton="True">

                <RefreshButtonStyle Wrap="True"></RefreshButtonStyle>
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True"></dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </div>

        <dx:ASPxPopupControl ID="pcReagenda" runat="server"
            ClientInstanceName="pcReagenda" Modal="true" Width="430px" Height="250px" CloseAction="CloseButton"
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="ContentControl1" runat="server">
                    <table align="center">
                        <tr>
                            <td class="field">Id. Servicio:
                            </td>
                            <td>

                                <dx:ASPxLabel ID="lblIdServicio" runat="server" ClientInstanceName="lblIdServicio"></dx:ASPxLabel>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Tipo de Novedad:</td>
                            <td>
                                <asp:DropDownList ID="ddlNovedadReagenda" runat="server" />
                                <asp:RequiredFieldValidator ID="rfvAgenda" runat="server" ValidationGroup="vgReagenda" InitialValue="0"
                                    ControlToValidate="ddlNovedadReagenda" ErrorMessage="Seleccione un tipo de novedad." Display="Dynamic" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Observación:</td>
                            <td>
                                <asp:TextBox ID="txtObservacionReagenda" runat="server" Rows="5" Columns="30" TextMode="MultiLine" />
                                <asp:RequiredFieldValidator ID="rfvObservacionAgenda" runat="server" ValidationGroup="vgReagenda" Display="Dynamic"
                                    ControlToValidate="txtObservacionReagenda" ErrorMessage="Ingrese una observación." />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <dx:ASPxButton ID="btnReagenda1" AutoPostBack="false" ClientInstanceName="btnReagenda" runat="server" Text="Check Reagenda" ValidationGroup="vgReagenda">
                                    <ClientSideEvents Click="function(s, e) {
											pcReagenda.Hide();
										 EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'QuitarCheckReagenda', lblIdServicio.GetValue() );
										}" />
                                </dx:ASPxButton>

                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="pcReactivarServicio" runat="server"
            ClientInstanceName="pcReactivarServicio" Modal="true" Width="430px" Height="250px" CloseAction="CloseButton"
            HeaderText="Reactivar Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                    <table align="center" class="tabla">
                        <tr>
                            <td class="field">¿Con cambio de Radicado?
                            </td>
                            <td>
                                <dx:ASPxRadioButtonList ID="rbReactivacion" AutoPostBack="false" runat="server" ClientInstanceName="rbReactivacion" ValueType="System.Int32" ValidationGroup="cambioRadicado" RepeatDirection="Horizontal">
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
												ActivarRadicado();
											}" />
                                    <Items>
                                        <dx:ListEditItem Value="0" Text="No" />
                                        <dx:ListEditItem Value="1" Text="Si" />
                                    </Items>
                                </dx:ASPxRadioButtonList>
                                <dx:ASPxLabel ID="lbNuevoRadicado" ClientInstanceName="lbNuevoRadicado" ClientVisible="false" runat="server" Text="&nbsp;Nuevo radicado:"></dx:ASPxLabel>
                                <dx:ASPxTextBox ID="txtNuevoRadicado" ClientInstanceName="txtNuevoRadicado" ClientVisible="false" runat="server" Width="170px">
                                    <ClientSideEvents LostFocus="function(s, e) {
											ValidarNumeroRadicado();
										}" />
                                </dx:ASPxTextBox>
                                <dx:ASPxImage ID="imgError" ClientInstanceName="imgError" runat="server" ImageUrl="~/images/close.gif" ClientVisible="false"
                                    ToolTip="El número de radicado digitado ya existe.">
                                </dx:ASPxImage>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Observación:
                            </td>
                            <td>
                                <dx:ASPxMemo ID="txtObservacionReactivacion" ClientInstanceName="txtObservacionReactivacion" runat="server" Height="71px" Width="300px"></dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <br />
                                <br />
                                <dx:ASPxButton ID="lbReactivar" AutoPostBack="false" ClientInstanceName="lbReactivar" runat="server" ToolTip="&nbsp;Reactivar Servicio" ValidationGroup="reactivarServicio">
                                    <ClientSideEvents Click="function(s, e) {
											validaSeleccionReactivacion();
											}" />
                                    <Image Url="~/images/Open.png">
                                    </Image>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="pcAbrirCancelarServicio" runat="server"
            ClientInstanceName="pcAbrirCancelarServicio" Modal="true" Width="630px" Height="250px" CloseAction="CloseButton"
            HeaderText="Abrir O Cancelar Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server">
                    <table align="center" class="tabla">
                        <asp:Panel ID="pnlMensajeRestriccionNovedad" Visible="false" runat="server">
                            <tr>
                                <td colspan="2">
                                    <blockquote>
                                        <p>No es posible cerrar el radicado, por favor verifique que exista una novedad creada para el proceso actual y fecha de hoy.</p>
                                    </blockquote>
                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td class="field">Observacion:
                            </td>
                            <td>
                                <asp:TextBox ID="txtObservacionModificacion" runat="server" Rows="6" Width="400px"
                                    TextMode="MultiLine"></asp:TextBox>
                                <div>
                                    <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Se requiere una observaci&oacute;n para continuar con el proceso"
                                        Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="txtObservacionModificacion"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <asp:Panel ID="pnlEstadoReapertura" Visible="false" runat="server">
                            <tr>
                                <td class="field">Estado de reapertura:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlEstadoReapertura" Visible="false" runat="server" />
                                    <div>
                                        <asp:RequiredFieldValidator ID="rfvddlEstadoReapertura" runat="server" ErrorMessage="El estado de reapertura es requerido."
                                            Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="ddlEstadoReapertura"
                                            InitialValue="0" />
                                    </div>
                                </td>
                            </tr>
                        </asp:Panel>

                        <tr>
                            <td colspan="2" align="center">
                                <dx:ASPxButton ID="lbAbrirServicio" ClientInstanceName="lbAbrirServicio" runat="server" Text="&nbsp;Abrir Servicio" ValidationGroup="modificacionServicio" SpriteCssFilePath="~/images/unlock.png">
                                    <ClientSideEvents Click="function(s, e){
															AbrirCancelarServicioMensajeria('AbrirServicio', hfReactivarIdServicio.Get('idServicio'));
														
												}" />
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="lbCancelarServicio" AutoPostBack="false" ClientInstanceName="lbCancelarServicio" runat="server" Text="Cancelar Servicio" ValidationGroup="modificacionServicio" SpriteCssFilePath="~/images/package.png">
                                    <ClientSideEvents Click="function(s, e){
											 AbrirCancelarServicioMensajeria('cancelarServicio', hfReactivarIdServicio.Get('idServicio'));                                                         
												}" />
                                </dx:ASPxButton>

                                <dx:ASPxHyperLink ID="lbAbortarModificacion" AutoPostBack="false" runat="server" ImageUrl="~/images/cancelar.png" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                    <ClientSideEvents Click="function(s, e){
														 pcAbrirCancelarServicio.Hide();
												}" />
                                </dx:ASPxHyperLink>
                                <asp:HiddenField ID="hfIdServicio" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popEstadoMesaControl" ClientInstanceName="popEstadoMesaControl" runat="server" Modal="true" Width="630px" Height="250px" CloseAction="CloseButton"
            HeaderText="Cambiar Estado Mesa de Control" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <dx:ASPxCallbackPanel ID="cpPopEstado" runat="server" ClientInstanceName="cpPopEstado" EnableAnimation="true" AutoPostBack="false">
                        <ClientSideEvents EndCallback="function(s,e){
                            
                            if (s.cpMensaje) {
                                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'consultar', 2);
                            }
                             MostrarInfoEncabezado(s, e);
                            }" />
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxFormLayout runat="server" Width="100%">
                                    <Items>
                                        <dx:LayoutGroup Caption="Cambiar estado">
                                            <Items>
                                                <dx:LayoutItem Caption="Causal:">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxGridLookup runat="server" ID="causales" SelectionMode="Multiple" ClientInstanceName="causales" KeyFieldName="idCausal">
                                                                <ValidationSettings ValidationGroup="popControl">
                                                                    <RequiredField IsRequired="true" ErrorText="seleccione al menos una causal" />
                                                                </ValidationSettings>
                                                                <ClientSideEvents ButtonClick="function(s,e) {causales.GetGridView().UnselectAllRowsOnPage(); causales.HideDropDown(); }" />
                                                                <Buttons>
                                                                    <dx:EditButton Text="X">
                                                                    </dx:EditButton>
                                                                </Buttons>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" Width="50px" />
                                                                    <dx:GridViewDataTextColumn FieldName="causal" Width="350px" />
                                                                    <dx:GridViewDataTextColumn FieldName="idCausal" Visible="false" />
                                                                </Columns>
                                                                <GridViewProperties>

                                                                    <Settings VerticalScrollBarMode="Visible" />
                                                                    <SettingsBehavior AllowDragDrop="False" EnableRowHotTrack="True" />
                                                                    <SettingsPager NumericButtonCount="5" PageSize="20" />
                                                                </GridViewProperties>

                                                            </dx:ASPxGridLookup>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Observacion:">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxMemo ID="mNovedadEs" runat="server" Width="100%">
                                                                <ValidationSettings ValidationGroup="popControl">
                                                                    <RequiredField ErrorText="la oservacion es obligatoria" IsRequired="true" />
                                                                </ValidationSettings>
                                                            </dx:ASPxMemo>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem ShowCaption="False">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxButton ID="btnVerificarNovedad" runat="server" ClientInstanceName="btnVerificarNovedad" Text="Guardar novedad" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(s,e){
                                                        if(ASPxClientEdit.ValidateGroup('popControl'))
                                                        {
                                                            GuardarNovedad(s,e);
                                                        }													 
													}" />
                                                            </dx:ASPxButton>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible; position: absolute; top: -500px"
            name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142"></iframe>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
        <%--<script src="../include/jquery-1.min.js" type="text/javascript"></script>--%>
    </form>
</body>
</html>

