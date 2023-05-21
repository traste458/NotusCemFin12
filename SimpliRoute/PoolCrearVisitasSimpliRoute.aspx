<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolCrearVisitasSimpliRoute.aspx.vb" Inherits="BPColSysOP.PoolCrearVisitasSimpliRoute" %>


<%@ Register Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress" TagPrefix="uc3" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <link href="../include/styleDiv.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <title>Pool Crear Visitas Simpli Route</title>

    <script>
        function RealizarCallback(s, e, param) {
            cpGeneral.PerformCallback(param);
        }
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
            }
            if (s.cpArchivo) {
              var win = window.open(s.cpArchivo, '_blank');
              win.focus();
            }
        }

        function grid_SeleccionServiciosVisita() {
            ObtieneValoresServicioCallback();
        }
        function ObtieneValoresServicioCallback() {
            //var listaPedidos = new Array()
            //for (var i = 0; i < values.length; i++) {
            //    listaPedidos[i] = values[i]
            //}
            gvDatos.PerformCallback("1" + '|CrearVisitas');
        }

        function CloseGridLookup() {
            ddlBodega.ConfirmCurrentSelection();
            ddlBodega.HideDropDown();
        }

        function CloseGridLookupTipoServicio() {
            ddlTipoServicio.ConfirmCurrentSelection();
            ddlTipoServicio.HideDropDown();
        }

        function CargarNovedadesJS() {
            EjecutarCallbackGeneral(LoadingPanel, pcErrores, 'CargarNovedades', 0); //no aplica por que se requiere leer seriales. ya no se eliminan seriales leidos
        }

        function LimpiarCombosConCheck() {  
            ddlBodega.GetGridView().UnselectAllRowsOnPage();
            ddlTipoServicio.GetGridView().UnselectAllRowsOnPage();
        }

        function VerEjemploTxt(ctrl) {
            window.open('Plantillas/PlantillaConsultaMasivaRadicadoCreacionVisitas.xlsx', '_blank');
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptMngr" runat="server">
            </asp:ScriptManager>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" OnCallback="cpGeneral_Callback">
                <ClientSideEvents EndCallback="function(s,e){
                    LoadingPanel.Hide(); 
                    MostrarInfoEncabezado(s,e);
                        if (s.cpNovedadesCallBack=='MostrarNovedades'){        
                                pcErrores.Show();                                                        
                        } 
                        if (s.cpLimpiarFiltros) { LimpiarCombosConCheck(); }                                                        
                    }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxRoundPanel ID="rpGeneral" runat="server" ShowHeader="false">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxButton ID="btnFiltro" runat="server" AutoPostBack="false" ClientInstanceName="btnFiltro" ToolTip="Filtro" ClientIDMode="Static">
                                        <Image Url="../images/search.png"></Image>
                                        <ClientSideEvents Click="function(s,e)
                                            {
                                            popFiltro.SetPopupElementID(s.GetMainElement().id);
                                            popFiltro.Show();
                                            }
                                            " />
                                    </dx:ASPxButton>

                                      <dx:ASPxGridView ID="gvDatos" runat="server" Width="100%" AutoGenerateColumns="False"
                                            ClientInstanceName="gvDatos" KeyFieldName="idServicioMensajeria">
                                            <Settings ShowFooter="True" ShowHeaderFilterButton="true" />
                                            <SettingsDetail ShowDetailRow="false" />
                                            <ClientSideEvents EndCallback="function(s, e) {
                                                    $(&#39;#divEncabezado&#39;).html(s.cpMensaje);
                                                    if (s.cpNovedades=='MostrarNovedades'){   
                                                            RealizarCallback(s,e,'4|1');                                                               
                                                    } 
                                            }"></ClientSideEvents>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="idServicioMensajeria" Caption="Id." ShowInCustomizationForm="True"
                                                VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="3" Caption="N&uacute;mero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="17" Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="6" Caption="Jornada" FieldName="jornada" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="9" Caption="Jornada" FieldName="jornada" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Fecha Asignación" FieldName="fechaAsignacion" ShowInCustomizationForm="true">
                                                    <PropertiesTextEdit DisplayFormatString="{0:g}"></PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="14" Caption="Nombre de Cliente" FieldName="nombreCliente" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="15" Caption="Responsable de Entrega" FieldName="responsableEntrega" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="16" Caption="Tiene Novedad" FieldName="tieneNovedad" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="18" Caption="Barrio" FieldName="barrio" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn VisibleIndex="19" Caption="Tel&eacute;fono" FieldName="telefonoContacto" ShowInCustomizationForm="true">
                                                </dx:GridViewDataTextColumn>
                                             <dx:GridViewDataTextColumn VisibleIndex="4" Caption="Tipo de Servicio" FieldName="tipoServicio" ShowInCustomizationForm="true">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0">
                                                    <HeaderTemplate>
                                                        <dx:ASPxCheckBox ID="SelectAllCheckBox" runat="server" ToolTip="Seleccionar / Deseleccionar todas las filas"
                                                            ClientSideEvents-CheckedChanged="function(s, e) { gvDatos.SelectAllRowsOnPage(s.GetChecked()); }" />
                                                   <dx:ASPxButton ID="btnGenerarVisitas" runat="server" Text="Generar Visitas" 
                                                            ToolTip="Generar Visitas para Servicios seleccionados" AutoPostBack="false">
                                                            <ClientSideEvents Click="function(s, e) {
                                                                if(gvDatos.GetSelectedRowCount() &gt; 0){
                                                                    if(confirm('¿Realmente desea generar visitas para los [' + gvDatos.GetSelectedRowCount() + '] servicios seleccionados?')) {
                                                                        grid_SeleccionServiciosVisita();
                                                                    }
                                                                } else { alert('Debe seleccionar por lo menos un servicio para generar visita.'); }
                                                            }" />

                                                            
                                                        </dx:ASPxButton>

                                                    </HeaderTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewCommandColumn>

                                            </Columns>
                                            <SettingsPager PageSize="100" AlwaysShowPager="True">
                                                <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                            </SettingsPager>
                                            <Settings ShowHeaderFilterButton="True" ShowFooter="True"></Settings>
                                            <SettingsLoadingPanel Delay="150" />
                                            <SettingsDetail ShowDetailRow="false" ExportMode="All"></SettingsDetail>
                                           
                                        </dx:ASPxGridView>

                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>

                        <dx:ASPxPopupControl ID="popFiltro" runat="server" PopupElementID="btnFiltro"
                            ClientInstanceName="popFiltro" PopupVerticalAlign="Below" PopupHorizontalAlign="OutsideRight" PopupAction="LeftMouseClick"
                            EnableViewState="false" ShowHeader="false">
                            <ContentCollection>
                                <dx:PopupControlContentControl>
                                    <dx:ASPxRoundPanel ID="rpFiltro" runat="server" HeaderText="Filtro">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxFormLayout runat="server">
                                                    <Items>
                                                        <dx:LayoutGroup ColCount="2" ShowCaption="False">
                                                            <Items>
                                                                
                                                                <dx:LayoutItem Caption="Fecha inicial">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxDateEdit ID="deFechaInicial" runat="server" ClientInstanceName="deFechaInicial" CalendarProperties-ShowClearButton="false" AllowUserInput="false">
                                                                                
                                                                                <ValidationSettings ValidationGroup="filtro">
                                                                                    <RequiredField IsRequired="true" ErrorText="Debe proporcionar una fecha" />
                                                                                </ValidationSettings>
                                                                                <CalendarProperties ShowClearButton="False"></CalendarProperties>

                                                                                <ClientSideEvents DateChanged="function (s,e){
                                                                                     deFechaFinal.SetMinDate(deFechaInicial.GetDate());
                                                                                     deFechaFinal.SetDate(deFechaInicial.GetDate());
                                                                                 }" />
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Fecha final">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxDateEdit ID="deFechaFinal" runat="server" ClientInstanceName="deFechaFinal" CalendarProperties-ShowClearButton="false" AllowUserInput="false">
                                                                               
                                                                                <ValidationSettings ValidationGroup="filtro">
                                                                                    <RequiredField IsRequired="true" ErrorText="Debe proporcionar una fecha" />
                                                                                </ValidationSettings>
                                                                                <CalendarProperties ShowClearButton="False"></CalendarProperties>
                                                                                <ClientSideEvents DateChanged="function(s,e){                                                            
                                                                                     deFechaInicial.SetMaxDate(deFechaFinal.GetDate());
                                                                                    if(!deFechaInicial.GetDate()){ deFechaInicial.SetDate(deFechaFinal.GetDate());}
                                                                                    }" />
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Jornada">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxComboBox ID="cmbJornada" runat="server" ClientInstanceName="cmbJornada" Width="250px"
                                                                            DropDownStyle="DropDownList" ValueField="idJornada">
                                                                                <ValidationSettings ValidationGroup="filtro">
                                                                                    <RequiredField IsRequired="true" ErrorText="Debe seleccionar una jornada" />
                                                                                </ValidationSettings>
                                                                        </dx:ASPxComboBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Ciudad">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxComboBox ID="cmbCiudad" runat="server" ClientInstanceName="cmbCiudad" Width="250px"
                                                                            IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idCiudad"
                                                                            CallbackPageSize="25" EnableCallbackMode="true" FilterMinLength="3">
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                                                                        RealizarCallback(s,e,'2|1');
                                                                                          }"></ClientSideEvents>
                                                                        </dx:ASPxComboBox>                  
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Bodega">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxGridLookup ID="ddlBodega" runat="server" SelectionMode="Multiple" ClientInstanceName="ddlBodega"
                                                                            KeyFieldName="idbodega" Width="350px" TextFormatString="{0}" MultiTextSeparator=", ">
                                                                            <ClientSideEvents ButtonClick="function(s,e) {ddlBodega.GetGridView().UnselectAllRowsOnPage(); ddlBodega.HideDropDown(); }" />
                                                                            <Columns>
                                                                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                                                <dx:GridViewDataTextColumn FieldName="bodega" />
                                                                            </Columns>
                                                                            <GridViewProperties>
                                                                                <Templates>
                                                                                    <StatusBar>
                                                                                        <table style="float: right">
                                                                                            <tr>
                                                                                                <td onclick="return _aspxCancelBubble(event)">
                                                                                                    <dx:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </StatusBar>
                                                                                </Templates>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                                                <Settings ShowFilterRow="True" ShowStatusBar="Visible" />
                                                                                <Settings ShowFilterRow="True" ShowStatusBar="Visible"></Settings>
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Tipo de servicio">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxGridLookup ID="ddlTipoServicio" runat="server" SelectionMode="Multiple" ClientInstanceName="ddlTipoServicio"
                                                                            KeyFieldName="idTipoServicio" Width="350px" TextFormatString="{0}" MultiTextSeparator=", ">
                                                                            <ClientSideEvents ButtonClick="function(s,e) {ddlTipoServicio.GetGridView().UnselectAllRowsOnPage(); ddlBodega.HideDropDown(); }" />
                                                                            <Columns>
                                                                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                                                <dx:GridViewDataTextColumn FieldName="nombre" />
                                                                            </Columns>
                                                                            <GridViewProperties>
                                                                                <Templates>
                                                                                    <StatusBar>
                                                                                        <table style="float: right">
                                                                                            <tr>
                                                                                                <td onclick="return _aspxCancelBubble(event)">
                                                                                                    <dx:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookupTipoServicio" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </StatusBar>
                                                                                </Templates>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                                                <Settings ShowFilterRow="True" ShowStatusBar="Visible" />
                                                                                <Settings ShowFilterRow="True" ShowStatusBar="Visible"></Settings>
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Radicados">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <dx:ASPxMemo ID="meRadicados" runat="server" Height="71px" Width="270px" NullText="Ingrese uno o varios radicados..."
                                                                            ClientInstanceName="mePedidos" TabIndex="0">
                                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgFiltro">
                                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9\s\-]+\s*$" />
                                                                            </ValidationSettings>
                                                                        </dx:ASPxMemo>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                            <dx:LayoutItem Caption="Masivo Radicados">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer>
                                                                        <table style="width: 100%">
                                                                            <tr>
                                                                                <td>Archivo:
                                                                                </td>
                                                                                <td>
                                                                                    <asp:FileUpload ID="fuTags" runat="server" Width="370px" />
                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fuTags"
                                                                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;Debe escoger un archivo" ValidationGroup="CargueServicio">
                                                                                    </asp:RequiredFieldValidator>
                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic"
                                                                                        ErrorMessage="&lt;br /&gt;El archivo no tiene la extensión esperada" ValidationExpression=".*(\.([xX][lL][sS])([xX]?))"
                                                                                            ValidationGroup="CargueServicio" ControlToValidate="fuTags">
                                                                                    </asp:RegularExpressionValidator>
                                                                                    <br />
                                                                                    <a href="javascript:void(0);" id="VerEjemploTxt" onclick="javascript:VerEjemploTxt((this));"
                                                                                        class="style2"><span class="style3">(Ver Archivo de Ejemplo)</span></a>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2" align="center">
                                                                                    <div style="margin-top: 5px; margin-bottom: 5px;">
                                                                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" Text="Procesar archivo"
                                                                                            ClientInstanceName="btnUpload" Height="38px" ValidationGroup="CargueServicio">
                                                                                            <ClientSideEvents Click="function(s, e) { 
                                                                                                if(ASPxClientEdit.ValidateGroup('filtro')==true){
                                                                                                    if(ASPxClientEdit.ValidateGroup('CargueServicio')){                                                                        
                                                                                                        LoadingPanel.Show();
                                                                                                    }
                                                                                                }
                                                                                            }"></ClientSideEvents>
                                                                                            <Image Url="../images/DxFileUpload32.png">
                                                                                            </Image>
                                                                                        </dx:ASPxButton>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>

                                                                <dx:LayoutItem ShowCaption="False">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" AutoPostBack="false">
                                                                                <Image Url="../images/search.png"></Image>
                                                                                <ClientSideEvents Click="function(s,e){
                                                                                    if(ASPxClientEdit.ValidateGroup('filtro')){
                                                                                    RealizarCallback(s,e,'1|1');
                                                                                    }
                                                                                    }" />
                                                                            </dx:ASPxButton>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem ShowCaption="False">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxButton ID="btnBorrarFiltros" runat="server" Text="Limpiar" AutoPostBack="false">
                                                                                <Image Url="../images/cancelar.png"></Image>
                                                                                <ClientSideEvents Click="function(s,e){
                                                                                    RealizarCallback(s,e,'3|1');                                                                                    
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
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>



                        <dx:ASPxPopupControl ID="pcErrores" runat="server" 
                                ClientInstanceName="pcErrores" Modal="true" Width="430px" Height="600px" CloseAction="CloseButton"
                                HeaderText="Información de Errores" PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">

                                            <div id="divpnlErrores" style="float: left; margin-top: 5px; width: 50%; visibility: visible">
                                                <dx:ASPxCallbackPanel ID="cperrores" ClientInstanceName="cperrores" ClientVisible="true" runat="server">
                                                    <PanelCollection>
                                                        <dx:PanelContent>
                                                            <dx:ASPxGridViewExporter ID="gveExportadorErrores" runat="server" GridViewID="gvErrores">
                                                            </dx:ASPxGridViewExporter>
                                                    <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" HeaderText="Log de Errores" Width="350px">
                                                                <PanelCollection>
                                                                    <dx:PanelContent>
                                                                        <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel" Visible="False">
                                                                        </dx:ASPxButton>
                                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores" Width="300px">
                                                                             <Columns>
                                                                                <dx:GridViewDataTextColumn Caption="Mensaje" FieldName="Mensaje" ShowInCustomizationForm="True">
                                                                                </dx:GridViewDataTextColumn>                                                                
                                                                              </Columns>  
                                                                            <SettingsPager PageSize="20">
                                                                            </SettingsPager>
                                                                        </dx:ASPxGridView>
                                                                    </dx:PanelContent>
                                                                </PanelCollection>
                                                            </dx:ASPxRoundPanel>


                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxCallbackPanel>
                                            </div>


                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>


                        <dx:ASPxPopupControl ID="pcMasivoRadicado" runat="server" 
                                ClientInstanceName="pcMasivoRadicado" Modal="true" Width="430px" Height="600px" CloseAction="CloseButton"
                                HeaderText="Consulta masiva por Radicados" PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                        </dx:ASPxPopupControl>



                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
    </form>
</body>
</html>
