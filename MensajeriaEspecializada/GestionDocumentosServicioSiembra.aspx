<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionDocumentosServicioSiembra.aspx.vb"
    Inherits="BPColSysOP.GestionDocumentosServicioSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Gestión Documentos SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function BuscarRadicado(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgBuscar')) {
                cpDocumentos.PerformCallback('consultar|' + txtNumeroServicio.GetValue());
            }
        }

        function AdicionarDocumento(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgDocumento')) {
                uploader.Upload();
            }
        }

        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
                cpDocumentos.PerformCallback('recargarFormulario');
            }
        }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpDocumentos" runat="server" ClientInstanceName="cpDocumentos">
        <ClientSideEvents EndCallback="function(s, e) {
                if(s.cpMensaje){
                    $('#divEncabezado').html(s.cpMensaje);
                }
            }" />
        <PanelCollection>
            <dx:PanelContent>
                <div style="float: left;">
                    <dx:ASPxRoundPanel ID="rpInfoRadicado" runat="server" HeaderText="Número de Servicio">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNumeroServicio" runat="server" Width="170px" onkeypress="javascript:return ValidaNumero(event);"
                                                ClientInstanceName="txtNumeroServicio">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgBuscar">
                                                    <RequiredField ErrorText="El número de Servicio es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td>
                                            <dx:ASPxButton ID="btnBuscar" runat="server" Text="Filtrar" Width="100px" HorizontalAlign="Center"
                                                Style="display: inline" AutoPostBack="False" ValidationGroup="vgBuscar">
                                                <ClientSideEvents Click="function(s, e) {
                                                                BuscarRadicado(s, e);
                                                            }"></ClientSideEvents>
                                                <Image Url="../images/find.gif">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
                
                <div style="float: left; margin-left: 10px;">
                    <dx:ASPxRoundPanel ID="rpFormatos" runat="server" ClientVisible="false" HeaderText="Reimpresión de Formatos">
                        <PanelCollection>
                            <dx:PanelContent ID="PanelContent2" runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnImprimir" runat="server" Text="Formato de Préstamo" Width="200px" HorizontalAlign="Center"
                                                Style="display: inline" AutoPostBack="False" CausesValidation="False" Height="25px">
                                                <ClientSideEvents Click="function(s, e) {
	                                                    cpDocumentos.PerformCallback('reimprimir');
                                                    }" />
                                                <Image Url="../images/print.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>

                <div style="clear: both"></div>

                <div style="float: left; margin-top: 10px;">
                    <dx:ASPxRoundPanel ID="rpDocumentos" runat="server" ClientVisible="false" HeaderText="Documentos Asociados">
                        <PanelCollection>
                            <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                                <table>
                                    <tr>
                                        <td>
                                            Nombre Documento:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombreDocumento" runat="server" Width="300px">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgDocumento">
                                                    <RequiredField ErrorText="El nombre del documento es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Archivo:
                                        </td>
                                        <td>
                                            <dx:ASPxUploadControl ID="ucCargueArchivo" runat="server" Width="300px" UploadMode="Advanced"
                                                    NullText="Seleccione un archivo..." ClientInstanceName="uploader" 
                                                ShowProgressPanel="true" FileUploadMode="OnPageLoad">
                                                    <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                        FilesUploadComplete="function(s, e) { if(e.errorText.length > 0) alert('No fue posible cargar el archivo, por favor verifique lo siguiente e intente nuevamente:\n 1. Que el archivo no se encuentre abierto\n 2. El tamaño del archivo no sea superior a 10 MB.'); }"
                                                        FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                    <ValidationSettings AllowedFileExtensions=".pdf, .jpg, .tiff, .gif" MaxFileSize="20971520" MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                        NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                        MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                                    Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                        ShowErrors="true">
                                                    </ValidationSettings>
                                                </dx:ASPxUploadControl>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Cargar Documento"
                                                ClientInstanceName="btnUpload" ClientEnabled="False">
                                                <ClientSideEvents Click="function(s, e) { AdicionarDocumento(s, e); }"></ClientSideEvents>
                                                <Image Url="../images/upload.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                                <dx:ASPxGridView ID="gvDocumentos" runat="server" AutoGenerateColumns="False" KeyFieldName="IdDocumento">
                                    <Columns>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="IdDocumento"
                                            ReadOnly="True">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                            VisibleIndex="1" FieldName="NombreDocumento">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Nombre del Archivo" ShowInCustomizationForm="True"
                                            VisibleIndex="1" FieldName="NombreArchivo">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Fecha de Recepción" ShowInCustomizationForm="True"
                                            VisibleIndex="2" FieldName="FechaRecepcion">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="12" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink runat="server" ID="lnkVer" ImageUrl="~/images/pdf.png" Cursor="pointer"
                                                    ToolTip="Descargar Archivo" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e) { DescargarDocumento({0}) }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                </dx:ASPxGridView>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnLegalizar" runat="server" Text="Legalizar Servicio" Width="180px"
                                                HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                                <ClientSideEvents Click="function(s, e) {
                                                    cpDocumentos.PerformCallback('legalizar');    
                                                }"></ClientSideEvents>
                                                <Image Url="../images/save_all.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>

                <dx:ASPxPopupControl ID="pcDocumentoCierre" runat="server" HeaderText="Formato de Préstamo - SIEMBRA"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="True"
                        ClientInstanceName="dialogoDocumentos" ContentUrl="" Height="600px" Modal="True"
                        Width="800px" CloseAction="CloseButton" BackColor="White">
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
