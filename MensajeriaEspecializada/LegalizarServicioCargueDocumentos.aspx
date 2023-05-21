<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalizarServicioCargueDocumentos.aspx.vb"
    Inherits="BPColSysOP.LegalizarServicioCargueDocumentos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>.:: Legalizar Servicios Ventas WEB ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function BuscarRadicado(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgBuscar')) {
                cpDocumentos.PerformCallback('consultar|' + txtNumeroServicio.GetValue() + '|' + rblTipoServicio.GetValue());
            }
        }

        function ConsultarRadicado(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgConsultar')) {
                cpDocumentos.PerformCallback('ConsultarDocumentos|' + txtServicioConsulta.GetValue());
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
                //cpDocumentos.PerformCallback('recargarFormulario');
            }
        }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }

        function DescargarDocumentoConsulta(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }

    </script>

    <style type="text/css">
        .auto-style1 {
            width: 597px;
        }
    </style>

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
                if(s.cpPosicion != 'arriba'){
                    $('html,body').animate({ scrollTop: $('#divDetalle').offset().top }, 'slow');
                } else {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
                if (rblTipoServicio.GetValue()==99) {
                    cpDocumentos_pcOpciones_rpInfoRadicado_trDescripcion.style.display = 'table-row';
                } else {
                    cpDocumentos_pcOpciones_rpInfoRadicado_trDescripcion.style.display = 'none';                                                        
                }
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxPageControl ID="pcOpciones" runat="server" ActiveTabIndex="0" ClientInstanceName="pcOpciones"
                        EnableTheming="True" Height="90%" Theme="Default" Width="100%" ClientVisible="true" Visible="true">
                        <TabPages>
                            <dx:TabPage Text="Legalización de Servicios" Name="tbLegalizacion">
                                <TabImage Url="../images/Attach.gif">
                                </TabImage>
                                <ContentCollection>
                                    <dx:ContentControl ID="ContentControl2" runat="server">
                                        <div style="float: left;">
                                            <dx:ASPxRoundPanel ID="rpInfoRadicado" runat="server" HeaderText="Número de Radicado" ClientInstanceName="rpInfoRadicado">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table>
                                                            <tr valign="middle">
                                                                <td>Tipo de Servicio:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxRadioButtonList ID="rblTipoServicio" runat="server" ClientInstanceName="rblTipoServicio">
                                                                        <Items>
                                                                            <dx:ListEditItem Value="8" Text="Siembra" />
                                                                            <dx:ListEditItem Value="9" Text="Venta Web" />
                                                                            <dx:ListEditItem Value="12" Text="Venta Corporativa" />
                                                                            <dx:ListEditItem Value="13" Text="Campaña Claro Fijo" />
                                                                            <dx:ListEditItem Value="99" Text="Servicios Financieros" />
                                                                        </Items>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgBuscar">
                                                                            <RequiredField ErrorText="Por favor seleccione un tipo de servicio" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                        <ClientSideEvents SelectedIndexChanged="function(s,e){
                                                                            if (rblTipoServicio.GetValue()==99) {
                                                                                cpDocumentos_pcOpciones_rpInfoRadicado_trDescripcion.style.display = 'table-row';
                                                                            } else {
                                                                                cpDocumentos_pcOpciones_rpInfoRadicado_trDescripcion.style.display = 'none';                                                        
                                                                            }
                                                                        }" />
                                                                    </dx:ASPxRadioButtonList>
                                                                </td>
                                                            </tr>
                                                            <tr id="trDescripcion" runat="server" style="display: none">
                                                                <td>Descripcion Servicio:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxComboBox ID="cmbDescripcion" runat="server" ClientInstanceName="cmbDescripcion" Width="220px">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgBuscar">
                                                                            <RequiredField ErrorText="Tipo de servicio requerido" IsRequired="True" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Número de Servicio:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtNumeroServicio" runat="server" Width="220px" onkeypress="javascript:return ValidaNumero(event);"
                                                                        ClientInstanceName="txtNumeroServicio">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgBuscar">
                                                                            <RequiredField ErrorText="El número de Radicado es requerido" IsRequired="True" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    <dx:ASPxButton ID="btnBuscar" runat="server" Text="Filtrar" Width="100px" HorizontalAlign="right"
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
                                        <div style="clear: both">
                                        </div>
                                        <div id="divDetalle" style="float: left; margin-top: 10px;">
                                            <table style="width: 100%">
                                                <tr>
                                                    <td style="vertical-align: top; width: 100%">
                                                        <dx:ASPxRoundPanel ID="rpDocumentosRequeridos" runat="server" ClientVisible="false" HeaderText="Documentos Requeridos"
                                                            ClientInstanceName="rpDocumentosRequeridos" Width="600px">
                                                            <PanelCollection>
                                                                <dx:PanelContent ID="PanelContent2" runat="server" SupportsDisabledAttribute="True">
                                                                    <dx:ASPxGridView ID="gvDocumentosRequeridos" runat="server" AutoGenerateColumns="False" KeyFieldName="idProducto" Width="550px">
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="idProducto"
                                                                                ReadOnly="True" Visible="false">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                                                                VisibleIndex="1" FieldName="nombre">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Cantidad Requerida" ShowInCustomizationForm="True"
                                                                                VisibleIndex="1" FieldName="cantidadRequerida">
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Cantidad Leida" ShowInCustomizationForm="True"
                                                                                VisibleIndex="2" FieldName="cantidadLeida">
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxRoundPanel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxRoundPanel ID="rpDocumentos" runat="server" ClientVisible="false" HeaderText="Documentos Asociados"
                                                            ClientInstanceName="rpDocumentos" Width="1300px">
                                                            <PanelCollection>
                                                                <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                                                                    <table>
                                                                        <tr>
                                                                            <td>Archivo:
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxUploadControl ID="ucCargueArchivo" runat="server" Width="400px" UploadMode="Advanced"
                                                                                    NullText="Seleccione un archivo..." ClientInstanceName="uploader" ShowProgressPanel="true"
                                                                                    FileUploadMode="OnPageLoad" Enabled="true">
                                                                                    <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                                                        FilesUploadComplete="function(s, e) { 
                                                                                            if(e.errorText.length > 0){
                                                                                                alert('No fue posible cargar el archivo, por favor verifique lo siguiente e intente nuevamente:\n 1. Que el archivo no se encuentre abierto\n 2. El tamaño del archivo no sea superior a 10 MB.'); 
                                                                                            } else {
                                                                                                //alert('Jorge Contreras');
                                                                                                cpDocumentos.PerformCallback('recargarFormulario');
                                                                                            }
                                                                                        }"
                                                                                        FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                                                    <ValidationSettings AllowedFileExtensions=".pdf, .jpg, .tiff, .gif" MaxFileSize="10485760"
                                                                                        MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                                                        NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                                                        MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                                    Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                                                        ShowErrors="true">
                                                                                    </ValidationSettings>
                                                                                    <AdvancedModeSettings EnableMultiSelect="True"></AdvancedModeSettings>
                                                                                </dx:ASPxUploadControl>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="2" align="center">
                                                                                <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Cargar Documento"
                                                                                    ClientInstanceName="btnUpload" ClientEnabled="true" Width="200px">
                                                                                    <ClientSideEvents Click="function(s, e) { AdicionarDocumento(s, e); }"></ClientSideEvents>
                                                                                    <Image Url="../images/upload.png">
                                                                                    </Image>
                                                                                </dx:ASPxButton>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <dx:ASPxGridView ID="gvDocumentos" runat="server" AutoGenerateColumns="False" KeyFieldName="IdDocumento" Width="100%">
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="IdDocumento"
                                                                                ReadOnly="True" Width="30px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Nombre del Archivo" ShowInCustomizationForm="True"
                                                                                VisibleIndex="1" FieldName="NombreArchivo" Width="300px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                                                                VisibleIndex="2" Width="300px">
                                                                                <DataItemTemplate>
                                                                                    <dx:ASPxTextBox ID="txtNombreDocumento" runat="server" ClientInstanceName="txtNombreDocumento" NullText="Digite Nombre de Documento"
                                                                                        Width="100%">
                                                                                    </dx:ASPxTextBox>
                                                                                </DataItemTemplate>
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataColumn Name="TipoProducto" Caption="Tipo Producto" VisibleIndex="3" Width="300px" ShowInCustomizationForm="True">
                                                                                <DataItemTemplate>
                                                                                    <dx:ASPxComboBox ID="cmbTipoProd" runat="server" ClientInstanceName="cmbTipoProd" Width="100%"
                                                                                        OnInit="cbProduct_Init" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDown">
                                                                                        <ClientSideEvents SelectedIndexChanged="function(s,e){
                                                                        cpDocumentos.PerformCallback('ActualizarDocumentos');    
                                                                     }" />
                                                                                    </dx:ASPxComboBox>
                                                                                </DataItemTemplate>
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Fecha de Recepción" ShowInCustomizationForm="True"
                                                                                VisibleIndex="4" FieldName="FechaRecepcion" Width="50px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="5" Width="40px">
                                                                                <DataItemTemplate>
                                                                                    <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eliminar.gif" OnInit="Link_Init_Eliminar"
                                                                                        Cursor="pointer" ToolTip="Eliminar Documento">
                                                                                        <ClientSideEvents Click="function(s, e) {
                                                                        if (confirm('Esta seguro de eliminar el documento seleccionado?')) {
                                                                            cpDocumentos.PerformCallback('Eliminar|' + {0});
                                                                            //EjecutarCallbackGeneral(s,e,'Eliminar',{0});
                                                                        }
                                                                    }" />
                                                                                    </dx:ASPxHyperLink>
                                                                                    <dx:ASPxHyperLink runat="server" ID="lnkVer" ImageUrl="~/images/pdf.png" Cursor="pointer"
                                                                                        ToolTip="Descargar Archivo" OnInit="Link_Init">
                                                                                        <ClientSideEvents Click="function(s, e) { DescargarDocumento({0}) }" />
                                                                                    </dx:ASPxHyperLink>
                                                                                </DataItemTemplate>
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataColumn>
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                    <table>
                                                                        <tr>
                                                                            <td id="tdCambioEstado" runat="server" visible="true">
                                                                                <dx:ASPxButton ID="btnRecuperacion" runat="server" Text="Cambiar Estado a Recuperacion Mesa Control" Width="180px"
                                                                                    HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                                                                    <ClientSideEvents Click="function(s, e) {
                                                                    cpDocumentos.PerformCallback('MesaControl');    
                                                                }"></ClientSideEvents>
                                                                                    <Image Url="../images/DxConfirm16.png">
                                                                                    </Image>
                                                                                </dx:ASPxButton>
                                                                            </td>
                                                                            <td id="tdLegalizar" runat="server" visible="true">
                                                                                <dx:ASPxButton ID="btnLegalizar" runat="server" Text="Legalizar Servicio" Width="180px"
                                                                                    HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False" Height="50px">
                                                                                    <ClientSideEvents Click="function(s, e) {
                                                                    cpDocumentos.PerformCallback('legalizar');    
                                                                }"></ClientSideEvents>
                                                                                    <Image Url="../images/disco.gif">
                                                                                    </Image>
                                                                                </dx:ASPxButton>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxRoundPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="Consulta Servicios Legalizados" Name="tbConsulta">
                                <TabImage Url="../images/VerImagen.jpg">
                                </TabImage>
                                <ContentCollection>
                                    <dx:ContentControl ID="ContentControl1" runat="server">
                                        <div style="float: left;">
                                            <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" HeaderText="Número de Radicado" ClientInstanceName="rpInfoRadicado">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    Número de Servicio:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtServicioConsulta" runat="server" ClientInstanceName="txtServicioConsulta"
                                                                         Width="200px" NullText="Número de servicio a consultar"></dx:ASPxTextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                              <td colspan="2" align="center">
                                                                  <br />
                                                                    <dx:ASPxButton ID="btnConsultarServicio" runat="server" Text="Consultar Servicio" Width="150px" HorizontalAlign="Justify"
                                                                        Style="display: inline" AutoPostBack="False" ValidationGroup="vgConsultar" Font-Bold="True" Font-Size="X-Small">
                                                                        <ClientSideEvents Click="function(s, e) {
                                                                            ConsultarRadicado(s, e);
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
                                        <div id="divDetalleConsulta" style="float: left; margin-top: 10px;">
                                            <table style="width: 100%">
                                                <tr>
                                                    <td>
                                                        <dx:ASPxRoundPanel ID="rpDocumentosConsulta" runat="server" ClientVisible="false" HeaderText="Documentos Asociados"
                                                            ClientInstanceName="rpDocumentos" Width="1300px">
                                                            <PanelCollection>
                                                                <dx:PanelContent ID="PanelContent4" runat="server" SupportsDisabledAttribute="True">
                                                                    <dx:ASPxGridView ID="gvDocumentosConsulta" runat="server" AutoGenerateColumns="False" KeyFieldName="IdDocumento" Width="100%">
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="IdDocumento"
                                                                                ReadOnly="True" Width="30px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Nombre del Archivo" ShowInCustomizationForm="True"
                                                                                VisibleIndex="1" FieldName="NombreArchivo" Width="300px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                                                                VisibleIndex="2" FieldName="NombreDocumento" Width="300px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataColumn Caption="Tipo Producto" ShowInCustomizationForm="True"
                                                                                VisibleIndex="3" FieldName="TipoProducto" Width="300px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Fecha de Recepción" ShowInCustomizationForm="True"
                                                                                VisibleIndex="4" FieldName="FechaRecepcion" Width="50px">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="5" Width="40px">
                                                                                <DataItemTemplate>
                                                                                    <dx:ASPxHyperLink runat="server" ID="lnkVerConsulta" ImageUrl="~/images/pdf.png" Cursor="pointer"
                                                                                        ToolTip="Descargar Archivo" OnInit="Link_Init_Consulta">
                                                                                        <ClientSideEvents Click="function(s, e) { DescargarDocumentoConsulta({0}) }" />
                                                                                    </dx:ASPxHyperLink>
                                                                                </DataItemTemplate>
                                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                            </dx:GridViewDataColumn>
                                                                        </Columns>
                                                                    </dx:ASPxGridView>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxRoundPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                        </TabPages>
                    </dx:ASPxPageControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
