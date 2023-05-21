<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteParaDescargueSerialesEntregadoCem.aspx.vb"
    Inherits="BPColSysOP.ReporteParaDescargueSerialesEntregadoCem" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Completar VL06G</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
        function UpdateUploadButton() {
            btnUpload.SetEnabled(upArchivo.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            $('#divpnlErrores').css('visibility', 'hidden');
            $('#divPanelResultado').css('visibility', 'hidden');
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
                    cpPopUp.PerformCallback();
                    $('#divPanelResultado').css('visibility', 'visible');
                }
                LoadingPanel.Hide();
            }
        }

      
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide(); 
        }" />
        </dx:ASPxCallback>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px;
            width: 100%;">
            <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="cpRegistro">
                <ClientSideEvents EndCallback="function(s, e) { 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide(); }" />
                <ClientSideEvents EndCallback="function(s, e) { 
                $(&#39;#divEncabezado&#39;).html(s.cpMensaje);
                LoadingPanel.Hide(); }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxRoundPanel ID="rpVl06g" runat="server" HeaderText="Completar Reporte VL06G"
                            Width="50%">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1" width="90%">
                                        <tr>
                                            <td>
                                                <div>
                                                    <dx:ASPxButton ID="ButtonVerEjemplo" runat="server" AutoPostBack="False" Text="Ver archivo de ejemplo"
                                                        ClientInstanceName="ButtonVerEjemplo">
                                                    </dx:ASPxButton>
                                                </div>
                                                <dx:ASPxUploadControl ID="upArchivo" runat="server" Width="100%" ClientInstanceName="upArchivo"
                                                    UploadMode="Advanced" ShowProgressPanel="True" NullText="Seleccione un archivo...">
                                                    <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                        FilesUploadComplete="function(s, e) { if(e.errorText.length > 0) { alert('No fue posible cargar el archivo, por favor verifique que el mismo no se encuentre abierto e intente nuevamente.'); LoadingPanel.Hide(); } }"
                                                        FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                    <ValidationSettings AllowedFileExtensions=".xls, .xlsx" MaxFileSize="10485760" MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                        NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                        MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                            Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                        ShowErrors="false">
                                                    </ValidationSettings>
                                                </dx:ASPxUploadControl>
                                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                    <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" Text="Procesar archivo"
                                                        ClientInstanceName="btnUpload" ClientEnabled="false">
                                                        <ClientSideEvents Click="function(s, e) { 
                                                            LoadingPanel.Show(); 
                                                            upArchivo.Upload();
                                                        }"></ClientSideEvents>
                                                        <Image Url="../images/upload.png">
                                                        </Image>
                                                    </dx:ASPxButton>
                                                </div>
                                                <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                    <fieldset>
                                                        <div id="divFileContainer" style="width: auto">
                                                        </div>
                                                    </fieldset>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                    <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos">
                                                        <Image Url="../images/eraser_minus.png" />
                                                       </dx:ASPxButton>
                                                </div>
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
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </div>
    <div id="divPanelResultado" style="float: left; margin-top: 5px; width: 50%; visibility: hidden">
        <dx:ASPxCallbackPanel ID="cpPopUp" runat="server">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridViewExporter ID="gveExportadorResultado" runat="server" GridViewID="gvVL06Gcargado">
                    </dx:ASPxGridViewExporter>
                    <dx:ASPxRoundPanel ID="rpResultado" runat="server" Visible="false" Width="60%" HeaderText="Resultado VL06G">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table width="98%">
                                    <tr>
                                        <th align="center">
                                            Reporte VL06G
                                        </th>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnExportarResul" runat="server" Text="Exportar Reporte a Excel">
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dx:ASPxGridView ID="gvVL06Gcargado" runat="server" AutoGenerateColumns="False" GroupSummarySortInfo="False">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn Caption="Entrega" FieldName="Entrega" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Material" FieldName="Material" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Denominacion" FieldName="Denominacion" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Doccompra" FieldName="Doccompra" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Salmcias" FieldName="Salmcias" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Cantidad entrega" FieldName="Cantidadentrega" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Serial" FieldName="Serial" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Radicado" FieldName="Radicado" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Estado Radicado" FieldName="Estadoradicado" ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Fecha Agendamiento" FieldName="Fechaagendamiento"
                                                        ShowInCustomizationForm="False">
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <SettingsPager PageSize="20">
                                                </SettingsPager>
                                            </dx:ASPxGridView>
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
    <div id="divpnlErrores" style="float: left; margin-top: 5px; width: 50%; visibility: hidden">
        <dx:ASPxCallbackPanel ID="cperrores" runat="server">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridViewExporter ID="gveExportadorErrores" runat="server" GridViewID="gvErrores">
                    </dx:ASPxGridViewExporter>
                    <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" Visible="false" Width="90%" HeaderText="Log de Errores">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel">
                                </dx:ASPxButton>
                                <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores">
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="Fila" FieldName="Fila" ShowInCustomizationForm="False">
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
    </form>
</body>
</html>
