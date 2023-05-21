<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargueServiciosFinancierosPorArchivo.aspx.vb"
    Inherits="BPColSysOP.CargueServiciosFinancierosPorArchivo" %>

<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Registro Masivo de Servicios - Venta Web</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
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
            //Crear un objeto de EXCEL
            objExcel = new ActiveXObject("Excel.Application");
            objExcel.Visible = true;
            objExcel.Workbooks.Open(strFilePath, false, false);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
        </dx:ASPxCallback>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px; width: 100%;">
            <dx:ASPxRoundPanel ID="rpAdicionPlan" runat="server" HeaderText="Cargue de Archivo Ventas Web">
                <PanelCollection>
                    <dx:PanelContent>
                        <table cellpadding="1">
                            <tr>
                                <td>
                                    <dx:ASPxUploadControl ID="ucCargueArchivoRadicados" runat="server" ClientInstanceName="uploader"
                                        ShowProgressPanel="True" NullText="Haga clic aquí para buscar el archivos..."
                                        OnFileUploadComplete="CargarInformacion" Size="35">
                                        <ClientSideEvents FileUploadComplete="function(s, e)  { Uploader_OnFileUploadComplete(s, e); ProcesarCarga(s, e); } "
                                            FilesUploadComplete="function(s, e) { Uploader_OnFilesUploadComplete(e); Uploader_OnFilesUploadCompletebtProcesar(e); } "
                                            FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }" TextChanged="function(s, e) { UpdateUploadButton(); }"></ClientSideEvents>
                                        <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".Xls,.Xlsx" GeneralErrorText="La carga de archivos ha fallado debido a un error externo"
                                            MaxFileSizeErrorText="Tamaño del archivo supera el tamaño máximo permitido, que es de {0} bytes"
                                            MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                    Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                            NotAllowedFileExtensionErrorText="Esta extensión de archivo no está permitido">
                                        </ValidationSettings>
                                    </dx:ASPxUploadControl>
                                </td>
                                <td>
                                    <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Cargar archivo"
                                            ClientInstanceName="btnUpload" ClientEnabled="False">
                                            <ClientSideEvents Click="function(s, e) { uploader.Upload(); }  "></ClientSideEvents>
                                            <Image Url="../images/upload.png" />
                                        </dx:ASPxButton>
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
                                <td colspan="2">
                                    <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                        <fieldset>
                                            <div id="divFileContainer" style="width: auto">
                                            </div>
                                        </fieldset>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Width="150px">
                                        <Image Url="../images/eraserminus.gif" />
                                    </dx:ASPxButton>
                                </td>
                                <td align="center">
                                    <dx:ASPxButton ID="btnEjemplo" runat="server" AutoPostBack="False" Text="Ver archivo de ejemplo"
                                        ClientInstanceName="btnEjemplo" Width="200px">
                                        <Image Url="../images/Excel.gif">
                                        </Image>
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <div id="divpnlErrores" style="margin-top: 10px;">
                <dx:ASPxGridViewExporter ID="gveExportador" runat="server" GridViewID="gvErrores">
                </dx:ASPxGridViewExporter>
                <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" Visible="false" Width="90%" ScrollBars="Auto"
                    HeaderText="Log de Errores">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores" Width="200px">
                                <Image Url="../images/Excel.gif">
                                </Image>
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
                <dx:ASPxRoundPanel ID="rpResultado" runat="server" Visible="false" HeaderText="Registros Procesados ">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table width="100%">
                                <tr>
                                    <td align="left">Información General:
                                    <dx:ASPxLabel ID="lbInfogeneral" runat="server" Text="" Font-Size="10pt">
                                    </dx:ASPxLabel>
                                    </td>
                                    <td rowspan="2">
                                        <dx:ASPxButton ID="btnExportarResul" runat="server" Text="Exportar Resultado" Width="200px">
                                            <Image Url="../images/Excel.gif">
                                            </Image>
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">Detalle de Referencias Equipos:
                                    <dx:ASPxLabel ID="lbReferencias" runat="server" Text="0" Font-Size="10pt">
                                    </dx:ASPxLabel>
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxGridView ID="gvRadidadoscargado" runat="server" AutoGenerateColumns="False"
                                            Width="100%" GroupSummarySortInfo="False">
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="Linea Archivo" FieldName="lineaArchivo" Visible="False"
                                                    ShowInCustomizationForm="False" VisibleIndex="0">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Hoja" FieldName="Hoja" ShowInCustomizationForm="False"
                                                    VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Cedula" FieldName="Radicado" ShowInCustomizationForm="False"
                                                    VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Descripción" FieldName="descripcion" ShowInCustomizationForm="False"
                                                    VisibleIndex="3">
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
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
