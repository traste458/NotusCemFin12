<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargueRadicadosPorArchivo.aspx.vb"
    Inherits="BPColSysOP.CargueRadicadosPorArchivo" %>

<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../../../Aplicaciones Logytech 2010/Nueva carpeta/VentasTelefonicasCEM/BPColSysOP/include/styleBACK.css"
        type="text/css" rel="stylesheet" />
    <script src="../../../../Aplicaciones Logytech 2010/Nueva carpeta/VentasTelefonicasCEM/BPColSysOP/include/jquery-1.js"
        type="text/javascript"></script>
    <script type="text/javascript">
        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }
        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }
        function UpdateUploadButtonbtProcesar() {
            if (btnUpload.ClientEnabled = true) {
                btProcesar.SetEnabled(true);
            } else {
                btProcesar.SetEnabled(false);
            }
        }
        function Uploader_OnFileUploadComplete(s, e) {
            document.getElementById('divpnlErrores').innerHTML = s.cprpLogErrores;
        }
        function Uploader_OnFilesUploadComplete(args) {
            UpdateUploadButton();
        }
        function Uploader_OnFilesUploadCompletebtProcesar(args) {
            UpdateUploadButtonbtProcesar();
        }
        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);
            }
        }

        function OpenFile(strFilePath) {
            var objExcel;
            //        Crear un objeto de EXCEL
            objExcel = new ActiveXObject("Excel.Application");
            objExcel.Visible = true;
            objExcel.Workbooks.Open(strFilePath, false, false);
        }
        function VerEjemplo(ctrl) {
            window.Response.WriteFile("../images/Cargue masivo de radicados.xlsx")
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px;
        width: 100%;">
        <dx:ASPxRoundPanel ID="rpAdicionPlan" runat="server" HeaderText="Cargue de archivos"
            Width="95%">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1" width="90%">
                        <tr>
                            <td>
                                <div>
                                    <dx:ASPxButton ID="ASPxButtonVerEjemplo" runat="server" AutoPostBack="False" Text="Ver archivo de ejemplo"
                                        ClientInstanceName="ButtonVerEjemplo">
                                    </dx:ASPxButton>
                                </div>
                                <dx:ASPxUploadControl ID="ucCargueArchivoRadicados" runat="server" ClientInstanceName="uploader"
                                    ShowProgressPanel="True" NullText="Haga clic aquí para buscar el archivos..."
                                    OnFileUploadComplete="CargarInformacion" Size="35">
                                    <ClientSideEvents FileUploadComplete="function(s, e)  { Uploader_OnFileUploadComplete(s, e); } "
                                        FilesUploadComplete="function(s, e) { Uploader_OnFilesUploadComplete(e); Uploader_OnFilesUploadCompletebtProcesar(e); } "
                                        FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }" TextChanged="function(s, e) { UpdateUploadButton(); }">
                                    </ClientSideEvents>
                                    <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".Xls,.Xlsx" GeneralErrorText="La carga de archivos ha fallado debido a un error externo"
                                        MaxFileSizeErrorText="Tamaño del archivo supera el tamaño máximo permitido, que es de {0} bytes"
                                        MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                    Estos archivos se han eliminado de la selección, por lo que no se cargarán.
                                                    {2}" NotAllowedFileExtensionErrorText="Esta extensión de archivo no está permitido">
                                    </ValidationSettings>
                                </dx:ASPxUploadControl>
                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                    <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Cargar archivo"
                                        ClientInstanceName="btnUpload" ClientEnabled="False">
                                        <ClientSideEvents Click="function(s, e) { uploader.Upload(); }  "></ClientSideEvents>
                                        <Image Url="../images/upload.png" />
                                    </dx:ASPxButton>
                                </div>
                                <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                    <fieldset>
                                        <div id="divFileContainer" style="width: auto">
                                        </div>
                                    </fieldset>
                                </div>
                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                    <dx:ASPxButton ID="btProcesar" runat="server" AutoPostBack="False" Text="Procesar"
                                        ClientEnabled="False" ClientInstanceName="btProcesar">
                                        <Image Url="../images/Running_process.png" />
                                        <ClientSideEvents Click="function(s, e) {
                                                                LoadingPanel.Show();
                                                            }"></ClientSideEvents>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                    <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos">
                                        <Image Url="../images/eraserminus.gif" />
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <div id="divpnlErrores">
                        <dx:ASPxGridViewExporter ID="gveExportador" runat="server" GridViewID="gvErrores">
                        </dx:ASPxGridViewExporter>
                        <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" Visible="false" Width="90%" ScrollBars="Auto"
                            HeaderText="Log de Errores">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel">
                                    </dx:ASPxButton>
                                    <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="False" Width="100%"
                                        GroupSummarySortInfo="False">
                                        <Columns>
                                            <dx:GridViewDataTextColumn Caption="Linea Archivo" FieldName="lineaArchivo" ShowInCustomizationForm="False"
                                                VisibleIndex="0">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Hoja" FieldName="Hoja" ShowInCustomizationForm="False"
                                                VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Radicado" FieldName="Radicado" ShowInCustomizationForm="False"
                                                VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Descripción" FieldName="descripcion" ShowInCustomizationForm="False"
                                                VisibleIndex="2">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager PageSize="20">
                                        </SettingsPager>
                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div id="divPanelResultado">
                        <dx:ASPxGridViewExporter ID="gveExportadorResultado" runat="server" GridViewID="gvRadidadoscargado">
                        </dx:ASPxGridViewExporter>
                        <dx:ASPxRoundPanel ID="rpResultado" runat="server" Visible="false" Width="60%" HeaderText="Registros Procesados ">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table width="98%" >
                                        <tr>
                                            <td align="left">
                                                Información General:
                                                <dx:ASPxLabel ID="lbInfogeneral" runat="server" Text="" Font-Size="10pt">
                                                </dx:ASPxLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left">
                                                Detalle de Mines:
                                                <dx:ASPxLabel ID="lbMines" runat="server" Text="" Font-Size="10pt">
                                                </dx:ASPxLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left">
                                                Detalle de Referencias Equipos:
                                                <dx:ASPxLabel ID="lbReferencias" runat="server" Text="0" Font-Size="10pt">
                                                </dx:ASPxLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th align="center">
                                                Radicados ya cargados
                                            </th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnExportarResul" runat="server" Text="Exportar Resultado a Excel">
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxGridView ID="gvRadidadoscargado" runat="server" AutoGenerateColumns="False"
                                                    Width="90%" GroupSummarySortInfo="False">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="Linea Archivo" FieldName="lineaArchivo" Visible="False"
                                                            ShowInCustomizationForm="False" VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Hoja" FieldName="Hoja" ShowInCustomizationForm="False"
                                                            VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Radicado" FieldName="Radicado" ShowInCustomizationForm="False"
                                                            VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Descripción" FieldName="descripcion" ShowInCustomizationForm="False"
                                                            VisibleIndex="2">
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
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="true">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
