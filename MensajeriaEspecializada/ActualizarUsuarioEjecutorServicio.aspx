<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActualizarUsuarioEjecutorServicio.aspx.vb"
    Inherits="BPColSysOP.ActualizarUsuarioEjecutorServicio" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Actualizar Usuario Ejecutor</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
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
             gvErrores.PerformCallback(null);

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
            <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="cbPrincipal">
                <ClientSideEvents CallbackComplete="function(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide(); 
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
                            <dx:ASPxRoundPanel ID="rpCambioUsuarioEjecutor" runat="server" HeaderText="Cambio Cambio Usuario Ejecutor"
                                Width="60%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxFormLayout ID="Cplayout" runat="server" RequiredMarkDisplayMode="Auto" AlignItemCaptionsInAllGroups="true">
                                            <Items>
                                                <dx:LayoutGroup Caption="&nbsp;" ColCount="3" GroupBoxDecoration="None" SettingsItemCaptions-HorizontalAlign="Right">
                                                    <Items>
                                                        <dx:LayoutItem Caption="&nbsp;" ColSpan="3">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer>
                                                                    <dx:ASPxButton ID="ButtonVerEjemplo" runat="server" AutoPostBack="False" Text="Ver archivo de ejemplo"
                                                                        ClientInstanceName="ButtonVerEjemplo">
                                                                    </dx:ASPxButton>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                            <HelpTextSettings Position="Top"></HelpTextSettings>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="&nbsp;" ColSpan="3">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer>
                                                                    <dx:ASPxUploadControl ID="upArchivo" runat="server" ClientInstanceName="upArchivo"
                                                                        UploadMode="Advanced" ShowProgressPanel="True" NullText="Seleccione un archivo..."
                                                                        FileUploadMode="OnPageLoad">
                                                                        <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                                            FilesUploadComplete="function(s, e) { if(e.errorText.length > 0) { alert('No fue posible cargar el archivo, por favor verifique que el mismo no se encuentre abierto e intente nuevamente.'); LoadingPanel.Hide(); } }"
                                                                            FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                                        <ValidationSettings AllowedFileExtensions=".xls, .xlsx, .txt" MaxFileSize="10485760"
                                                                            MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                                            NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                                            MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                            Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                                            ShowErrors="false">
                                                                        </ValidationSettings>
                                                                    </dx:ASPxUploadControl>
                                                                    <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                        <fieldset>
                                                                            <div id="divFileContainer" style="width: auto">
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
                                                                    <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" ValidationGroup="Registro"
                                                                        Text="Procesar archivo" ClientInstanceName="btnUpload" ClientEnabled="False">
                                                                        <ClientSideEvents Click="function(s, e) { 
                                                            LoadingPanel.Show(); 
                                                            upArchivo.Upload();
                                                        }"></ClientSideEvents>
                                                                        <Image Url="../images/upload.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                            <HelpTextSettings Position="Top"></HelpTextSettings>
                                                        </dx:LayoutItem>
                                                        <dx:LayoutItem Caption="&nbsp;">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer>
                                                                    <dx:ASPxButton ID="btnLimpiar" ClientInstanceName="btnLimpiar" runat="server" Text="Limpiar Campos"
                                                                        AutoPostBack="False">
                                                                        <Image Url="../images/eraser_minus.png" />
                                                                        <ClientSideEvents Click="function(s, e) {
                                                                        if (confirm('¿Realmente desea limpiar los campos del formulario?')) {
                                                                            ASPxClientEdit.ClearEditorsInContainerById('form1');
                                                                            //ddlCentroOrigen.SetValue(-1);
                                                                            Limpiar();
                                                                        }
                                                                    }"></ClientSideEvents>
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

                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                            <br />
                            <br />
                            <div id="divpnlErrores" style="float: left; margin-top: 5px; width: 50%; visibility: hidden">
                                <dx:ASPxCallbackPanel ID="cperrores" ClientInstanceName="cperrores" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxGridViewExporter ID="gveExportadorErrores" runat="server" GridViewID="gvErrores">
                                            </dx:ASPxGridViewExporter>
                                            <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" Visible="false" HeaderText="Log de Errores">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel">
                                                        </dx:ASPxButton>
                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Fila" FieldName="Fila" ShowInCustomizationForm="False">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Radicado" FieldName="Radicado" ShowInCustomizationForm="False">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Mensaje" FieldName="Mensaje" ShowInCustomizationForm="False">
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
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="true">
            </dx:ASPxLoadingPanel>

        </div>
    </form>
</body>
</html>
