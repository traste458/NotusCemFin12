<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ModificacionDocumentosCEM.aspx.vb" Inherits="BPColSysOP.ModificacionDocumentosCEM" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Modificación Documentos ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

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

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        //** Eventos FileUpload Carga de Documentos *** //

        function UpdateUploadButton() {
            imgUpload.SetEnabled(uploader.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            imgUpload.SetEnabled(false);
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }
            if (e.callbackData != null) {
                $('#divFileContainer1').html(e.callbackData);
            }

            if (s.cpResultado != null) {
                if (s.cpResultado == 0) {
                    $('#divEncabezado').html(s.cpMensaje);
                    dialogoEditar.Hide();
                    cpGeneral.PerformCallback("CargueServicio");
                    LoadingPanel.Hide();
                }
            }
            LoadingPanel.Hide();
        }

        function CargaCompleta(e) {
            if (e.errorText.length > 0) {
                if (e.errorText.indexOf('Violation') >= 0) {
                    alert('No fue posible cargar el archivo, por favor verifique que el mismo no se encuentre abierto e intente nuevamente.');
                } else {
                    alert(e.errorText);
                }
                LoadingPanel.Hide();
            }
        }

        function LimpiaFormulario(s, e) {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }

        function EditarDocumento(element, key) {
            TamanioVentana();
            dialogoEditar.PerformCallback('Inicial:' + key)
            dialogoEditar.SetSize(myWidth * 0.6, myHeight * 0.4);
            dialogoEditar.ShowWindow();
        }

    </script>    
</head>
<body class ="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id ="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true"
             Width ="90%">
            <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpRegistro" runat="server" HeaderText="Búsqueda Servicio" Width="40%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td class ="field" align ="left">
                                            Número de servicio:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtServicio" runat="server" NullText="Número de Servicio..." ClientInstanceName ="txtServicio"
                                                Width="250px" TabIndex ="1" onkeypress="javascript:return ValidaNumero(event);">
                                                <ClientSideEvents KeyDown="function (s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgBuscar')){
                                                        if(e.htmlEvent.keyCode == 13) {
                                                            EjecutarCallbackGeneral(s,e,'BuscarServicio');
                                                        }
                                                    } 
                                                }" />
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgBuscar">
                                                    <RegularExpression ErrorText ="Los caracteres ingresados no son validos" ValidationExpression ="^\s*[0-9]+\s*$"/>
                                                    <RequiredField ErrorText="El teléfono fjo de la empresa es requerido" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan ="2" align="center">
                                            <dx:ASPxImage ID="imgRegistro" runat="server" ImageUrl="../images/DxAdd32.png"
                                                ToolTip="Buscar" ClientInstanceName="imgRegistro" Cursor="pointer" TabIndex="20">
                                                <ClientSideEvents Click="function(s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgBuscar')){
                                                        EjecutarCallbackGeneral(s,e,'BuscarServicio');
                                                        }        
                                                }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros"
                                                ClientInstanceName="imgBorrar" Cursor="pointer" TabIndex="10">
                                                <ClientSideEvents Click="function(s, e){
                                                    LimpiaFormulario(s, e);
                                                }" />
                                            </dx:ASPxImage>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection> 
                    </dx:ASPxRoundPanel> 
                    <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" Theme ="SoftOrange"
                        HeaderText="Resultado de Búsqueda" Width="100%" Style="margin-top: 10px">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                    ClientInstanceName="gvDatos" KeyFieldName="IdDocumento" Theme ="SoftOrange">
                                    <ClientSideEvents EndCallback="function(s,e){ 
                                        $('#divEncabezado').html(s.cpMensaje);
                                        LoadingPanel.Hide();
                                    }"></ClientSideEvents>
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
                                                <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/DxMarker.png"
                                                    Cursor="pointer" ToolTip="Editar Documento" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e) { EditarDocumento (this, {0}); }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center">
                                            </CellStyle>
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
                                    <SettingsText Title="B&#250;squeda General de Documentos" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                </dx:ASPxGridView> 
                            </dx:PanelContent>
                        </PanelCollection> 
                    </dx:ASPxRoundPanel> 
                    <dx:ASPxPopupControl ID="dialogoEditar" runat="server" ClientInstanceName="dialogoEditar"
                        HeaderText="Editar Documento Servicio Mensajeria" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        ScrollBars="Auto" CloseAction="CloseButton" Theme ="SoftOrange">
                        <ClientSideEvents EndCallback ="function (s, e){
                            $('#divEncabezado').html(s.cpMensaje);
                        }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="pccModificaDocumento">
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td class="field" align="left">
                                            Id Documento:
                                        </td> 
                                        <td>
                                            <dx:ASPxLabel ID="lblIdDocumento" runat="server" ClientInstanceName="lblIdDocumento"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Medium">
                                            </dx:ASPxLabel>
                                        </td>
                                        <td class="field" align="left">
                                            Nombre Documento:
                                        </td> 
                                        <td>
                                            <dx:ASPxLabel ID="lblNombreDocumento" runat="server" ClientInstanceName="lblNombreDocumento"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Small">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field" align="left">
                                            Nombre Archivo:
                                        </td> 
                                        <td colspan ="3">
                                            <dx:ASPxLabel ID="lblNombreArchivo" runat="server" ClientInstanceName="lblNombreArchivo"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Small">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field">
                                            Seleccione Archivo:
                                        </td>
                                        <td>
                                            <dx:ASPxUploadControl ID="ucCargueArchivo" runat="server" Width="250px" UploadMode="Advanced"
                                                NullText="Seleccione un archivo..." ClientInstanceName="uploader" 
                                                ShowProgressPanel="true" FileUploadMode="OnPageLoad" TabIndex ="3">
                                                <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                    FilesUploadComplete="function(s, e) { CargaCompleta(e); }"
                                                    FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                <ValidationSettings AllowedFileExtensions=".pdf, .msg" MaxFileSize="10485760" MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                    NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                    MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                                Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                    ShowErrors="false">
                                                </ValidationSettings>
                                            </dx:ASPxUploadControl>
                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                <fieldset>
                                                    <div id="divFileContainer1" style="width: auto">
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </td>
                                        <td>
                                            <dx:ASPxImage ID="imgUpload" runat="server" ImageUrl="../images/DxFileUpload32.png"
                                                Cursor="pointer" ImageAlign="left" ToolTip="Procesar Archivo" ClientEnabled="false"
                                                ClientInstanceName="imgUpload">
                                                <ClientSideEvents Click="function (s,e){
                                                    LoadingPanel.Show(); 
                                                    uploader.Upload();
                                                }" />
                                            </dx:ASPxImage>
                                            <div>
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Procesar Archivo."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                    </tr>
                                </table> 
                            </dx:PopupControlContentControl> 
                        </ContentCollection> 
                    </dx:ASPxPopupControl> 
                </dx:PanelContent>
            </PanelCollection> 
        </dx:ASPxCallbackPanel> 
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
