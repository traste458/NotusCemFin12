<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministrarCapacidadesDeEntregaMasivo.aspx.vb" Inherits="BPColSysOP.AdministrarCapacidadesDeEntregaMasivo" %>

<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cargar Capacidades de Entrega Masivo</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
                LoadingPanel.Hide();
            }

        }

        function UpdateUploadButton() {
            btnUpload.SetEnabled(upArchivo.GetText(0) != "");
        }


        function Uploader_OnUploadStart() {
            $('#divpnlErrores').css('visibility', 'hidden');
            btnUpload.SetEnabled(false);
        }

        function ProcesarCarga(s, e) {

            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);
            }

            if (s.cpResultadoProceso != null) {

                if (s.cpResultadoProceso == 0) {
                    cperrores.PerformCallback();
                    $('#divpnlErrores').css('visibility', 'visible');
                } else {
                    // cbPrincipal.PerformCallback();
                    $('#divEncabezado').css('visibility', 'visible');
                }
                LoadingPanel.Hide();
            }
        }
        function OnInit(s, e) {
            UpdateItemsVisibility(s);
        }
        function OnUserTypeChanged(s, e) {
            UpdateItemsVisibility(s);
        }

        function UpdateItemsVisibility(radioButtonList) {

        }

        function Limpiar() {
            cperrores.SetClientVisible(false);

        }
        function ValidarArchivoTipo(s, e) {
            var validator = document.getElementById('validacion');
            var val = Page_ClientValidate("validacion")
            if (Page_ClientValidate("validacion")) {
                LoadingPanel.Show();
            }
            else {
                LoadingPanel.Hide();
            }

        }

        function agregarBase(idBase) {

            EjecutarCallbackGeneral(LoadingPanel, pcAgregarRegistrosBase, "GuardaMemoriaBaseSeleccionada", idBase);


            //pcAgregarRegistrosBase.Show();
            pcAgregarRegistrosBase.ShowWindow();
            //pcGeneral.RefreshContentUrl();
        }
          function DescargarDocumento(archivo) {
            window.location.href = 'DescargarDocumentoCem.aspx?nombreArchivo=' + archivo + '&rutaArchivo=/archivos_planos/';
        }

    </script>
    <style type="text/css">
        .style1
        {
            width: 164px;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallback ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                <ClientSideEvents CallbackComplete="function(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide(); 
                     if (s.cpOrigen=='exportar'){
                    toggle('divFiltros');
                       DescargarDocumento(s.cpNombreArchivo)
                }
        }" EndCallback="function(s, e) {
	MostrarInfoEncabezado(s,e);
}" />
            </dx:ASPxCallback>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>
            <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px; width: 100%;">
                <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="cpRegistro"
                    Width="100%">
                    <ClientSideEvents EndCallback="function(s, e) { 
                        $(&#39;#divEncabezado&#39;).html(s.cpMensaje);
                        LoadingPanel.Hide(); }"></ClientSideEvents>
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxRoundPanel ID="rpCargueBaseCliente" runat="server" HeaderText="Cargue Capacidad Entrega"
                                Width="60%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table width="95%">
                                            <tr>
                                                <td>
                                                    <dx:ASPxFormLayout ID="cplCargaArchivo" runat="server" RequiredMarkDisplayMode="Auto" AlignItemCaptionsInAllGroups="true">
                                                    <Items>
                                                        <dx:LayoutGroup Caption="&nbsp;" ColCount="3" GroupBoxDecoration="None" SettingsItemCaptions-HorizontalAlign="Right">
                                                            <Items>

                                                                <dx:LayoutItem Caption="&nbsp;" ColSpan="3">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxButton ID="ButtonVerEjemplo" runat="server" AutoPostBack="False" Text="Ver archivo plantilla"
                                                                                ClientInstanceName="ButtonVerEjemplo">
                                                                                <ClientSideEvents Click="function(s, e) {
                                                                                LoadingPanel.Show();
                                                                                setTimeout ('LoadingPanel.Hide();', 500); 
                                                                            }"></ClientSideEvents>
                                                                            </dx:ASPxButton>
                                                                    
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <HelpTextSettings Position="Top"></HelpTextSettings>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="&nbsp;" ColSpan="3">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <div id="cargarArchivo">
                                                                        
                                                                        <asp:FileUpload ID="fuArchivo" runat="server" />
                                                                        <asp:Label ID="lblObligatorio" runat="server" ForeColor="Red" Text="*" Width="50px" />
                                                                        <div>
                                                                            <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                                                                CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo" Display="Dynamic"
                                                                                ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.xls|.xlsx|.XLSX|.XLS|.Xlsx|.Xls)$" ValidationGroup="validacion"></asp:RegularExpressionValidator>
                                                                            <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                                                                ControlToValidate="fuArchivo" Display="Dynamic" ValidationGroup="validacion" />
                                                                        </div>
                                                                        <div class="comentario" style="font-size: small">Cargar archivos con extensión (xls o xlsx)</div>
                                                                
                                                                            </div>
                                                                            <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <fieldset>
                                                                                    <div id="divFileContainer"  style="width: auto">
                                                                                    </div>
                                                                                </fieldset>
                                                                            </div>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <HelpTextSettings Position="Top"></HelpTextSettings>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="&nbsp;" ColSpan="1">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer>
                                                                            <dx:ASPxButton ID="btnUpload" AutoPostBack="false" runat="server" ValidationGroup="validacion" ClientInstanceName="btnUpload" CssClass="submit"
                                                                                Text="Procesar Archivo." Theme="SoftOrange" Width="30px" Height="10px">
                                                                                <ClientSideEvents Click="function (s, e){  ValidarArchivoTipo(s, e);}" />
                                                                               <Image Url="../images/upload.png"></Image>
                                                                            </dx:ASPxButton>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                    <HelpTextSettings Position="Top"></HelpTextSettings>
                                                                </dx:LayoutItem>
  
                                                            </Items>
                                                            <SettingsItemCaptions HorizontalAlign="Right"></SettingsItemCaptions>
                                                        </dx:LayoutGroup>
                                                    </Items>
                                                </dx:ASPxFormLayout>
                                                </td>

                                            </tr>
                                        </table>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>

                            <br />
                            <br />
                            
                            <br />









        <dx:ASPxPopupControl ID="pcErrores" runat="server" 
            ClientInstanceName="pcErrores" Modal="true" Width="430px" Height="600px" CloseAction="CloseButton"
            HeaderText="Información de Errores" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">

                            <div id="divpnlErrores" style="float: left; margin-top: 5px; width: 50%; visibility: visible">
                                <dx:ASPxCallbackPanel ID="cperrores" ClientInstanceName="cperrores" ClientVisible="false" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxGridViewExporter ID="gveExportadorErrores" runat="server" GridViewID="gvErrores">
                                            </dx:ASPxGridViewExporter>
                                            <dx:ASPxRoundPanel ID="rpLogErrores" runat="server"  HeaderText="Log de Errores" Width="350px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel" Visible="False">
                                                        </dx:ASPxButton>
                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores" Width="300px">

                                                            <EditFormLayoutProperties ColCount="1"></EditFormLayoutProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="lineaArchivo" FieldName="Fila" ShowInCustomizationForm="False">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Descripcion" FieldName="Mensaje" ShowInCustomizationForm="False">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>

                                                            <SettingsAdaptivity>
                                                            <AdaptiveDetailLayoutProperties ColCount="1"></AdaptiveDetailLayoutProperties>
                                                            </SettingsAdaptivity>

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



                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="true">
            </dx:ASPxLoadingPanel>
            <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        </div>
    </form>
</body>
</html>

