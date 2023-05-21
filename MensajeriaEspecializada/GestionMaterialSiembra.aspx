<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionMaterialSiembra.aspx.vb" Inherits="BPColSysOP.GestionMaterialSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Gestión Materiales SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function VerEjemplo(ctrl) {
            if ($("#imagenEjemplo").css("display") == "none") {
                ctrl.html('(Ocultar imagen Ejemplo)');
            } else {
                ctrl.html('(Ver imagen Ejemplo)');
            }
            $("#imagenEjemplo").toggle('slow');
        }

        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            rpLog.SetVisible(false);
            btnUpload.SetEnabled(false);
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (s.cpMensajeError != null) {
                rpLog.SetVisible(true);
                gvLog.Refresh();
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);   
            }
        }

        function EliminarMaterial(ctrl, key) {
            if (confirm('¿Realmente desea eliminar el este material?')) {
                gvResultado.PerformCallback('eliminar|' + key);
            }
        }

        function FiltrarDevExpMaterial(s, e) {
            try {
                if (s.GetText().length >= 4 || cmbEquipo.GetItemCount() != 0) {
                    cpFiltroMaterial.PerformCallback(s.GetText());
                }
            }
            catch (e) { }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>

        <div style="float: left">
            <dx:ASPxRoundPanel ID="rpFiltroBusqueda" runat="server" Width="40%" 
                HeaderText="Filtro de Búsqueda">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxFormLayout ID="flBusqueda" runat="server">
                            <Items>
                                <dx:LayoutItem Caption="Material:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxTextBox ID="txtFiltroMaterial" runat="server" Width="170px" 
                                                MaxLength="255" NullText="Material a buscar...">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Referencia:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxTextBox ID="txtFiltroReferencia" runat="server" 
                                                NullText="Referencia a buscar..." Width="170px">
                                            </dx:ASPxTextBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:ASPxFormLayout>
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxButton ID="btnBuscar" runat="server" Text="Buscar" AutoPostBack="false"
                                        HorizontalAlign="Center">
                                        <ClientSideEvents Click="function(s, e) {
                                            gvResultado.PerformCallback('consulta');
                                        }" />
                                        <Image Url="~/images/find.gif">
                                        </Image>
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                        
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>    

            
            <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" HeaderText="Resultado de Búsqueda"
                style="margin-top: 10px;">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvResultado" runat="server" KeyFieldName="IdMaterial" 
                            ClientInstanceName="gvResultado" AutoGenerateColumns="False">
                            <ClientSideEvents EndCallback="function(s, e) {
                                if(s.cpMensaje) { 
                                    $('#divEncabezado').html(s.cpMensaje);
                                };

                                if (s.cpMensajeError) {
                                    rpLog.SetVisible(true);
                                    gvLog.Refresh();   
                                }
                            }" />
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="Id" FieldName="IdMaterial" 
                                    ShowInCustomizationForm="True" VisibleIndex="0">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Material" FieldName="Material" 
                                    ShowInCustomizationForm="True" VisibleIndex="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Descripción" FieldName="Referencia" 
                                    ShowInCustomizationForm="True" VisibleIndex="2">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="10">
                                    <DataItemTemplate>
                                        <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eliminar.gif" 
                                            Cursor="pointer" ToolTip="Eliminar Material" OnInit="Link_Init">
                                            <ClientSideEvents Click="function(s, e) { 
                                                EliminarMaterial(this, {0}); 
                                            }" />
                                        </dx:ASPxHyperLink>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                            </Columns>
                        </dx:ASPxGridView>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>

        <div style="float: left; margin-left: 100px;">
            <dx:ASPxRoundPanel id="rpAdicionMaterial" runat="server" HeaderText="Adición de Materiales">
                <PanelCollection>
                    <dx:PanelContent>
                        <blockquote>
                                    Por favor utilice un método para el cargue de los equipos<br />
                                    de los servicios tipo Siembra:</blockquote>
                        <dx:ASPxPageControl runat="server" ID="pcMateriales" ActiveTabIndex="0" EnableHierarchyRecreation="true"
                                Width="100%" ClientInstanceName="pcMateriales">
                                <TabPages>
                                    <dx:TabPage Text="Archivo">
                                        <TabImage Url="../images/Excel.gif">
                                        </TabImage>
                                        <ContentCollection>
                                            <dx:ContentControl>
                                                <a href="javascript:void(0);" id="VerEjemplo" onclick="javascript:VerEjemplo($(this));">
                                                    (Ver imagen Ejemplo)</a>
                                                <div id="imagenEjemplo" style="display: none; float: left; margin-top: 5px; margin-bottom: 5px;">
                                                    <img id="ventas" src="../images/EjemploMaterialesSiembra.png" name="ventas" alt="Ver imagen de ejemplo." />
                                                </div>
                                                <dx:ASPxUploadControl ID="ucCargueArchivoEquipos" runat="server" Width="100%" UploadMode="Advanced"
                                                    NullText="Seleccione un archivo..." ClientInstanceName="uploader" ShowProgressPanel="true">
                                                    <ClientSideEvents TextChanged="function(s, e) { UpdateUploadButton(); }" FileUploadComplete="function(s, e) { ProcesarCarga(s, e); }"
                                                        FilesUploadComplete="function(s, e) { if(e.errorText.length > 0) alert('No fue posible cargar el archivo, por favor verifique que el mismo no se encuentre abierto e intente nuevamente.'); }"
                                                        FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"></ClientSideEvents>
                                                    <ValidationSettings AllowedFileExtensions=".xls, .xlsx" MaxFileSize="10485760" MaxFileSizeErrorText="Tamaño de archivo no válido, el tamaño máximo es  {0} bytes"
                                                        NotAllowedFileExtensionErrorText="Extensión de archivo no permitida." GeneralErrorText="Carga de archivo no exitosa."
                                                        MultiSelectionErrorText="¡Atención! Los siguientes {0} archivos no son válidos porque superan el tamaño de archivo permitido ({1}) o sus extensiones no están permitidos. 
                                                                                    Estos archivos se han eliminado de la selección, por lo que no se cargarán. {2}"
                                                        ShowErrors="false">
                                                    </ValidationSettings>
                                                </dx:ASPxUploadControl>
                                                <div style="float: left; margin-top: 5px; margin-bottom: 5px;">
                                                    <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Cargar archivo"
                                                        ClientInstanceName="btnUpload" ClientEnabled="False">
                                                        <ClientSideEvents Click="function(s, e) { uploader.Upload(); }"></ClientSideEvents>
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
                                            </dx:ContentControl>
                                        </ContentCollection>
                                    </dx:TabPage>
                                    <dx:TabPage Text="Manual">
                                        <TabImage Url="../images/find.gif">
                                        </TabImage>
                                        <ContentCollection>
                                            <dx:ContentControl>
                                                <table width="100%">
                                                    <tr>
                                                        <td>
                                                            Equipo:
                                                        </td>
                                                        <td>
                                                            <div style="display: inline; float: left;">
                                                                <dx:ASPxTextBox ID="txtEquipoFiltro" runat="server" Width="80px" MaxLength="15">
                                                                    <ClientSideEvents KeyUp="function(s, e) { FiltrarDevExpMaterial(s, e) }"></ClientSideEvents>
                                                                </dx:ASPxTextBox>
                                                            </div>
                                                            <dx:ASPxCallbackPanel ID="cpFiltroMaterial" runat="server" RenderMode="Div" ClientInstanceName="cpFiltroMaterial">
                                                                <ClientSideEvents EndCallback="function(s, e) {}"></ClientSideEvents>
                                                                <PanelCollection>
                                                                    <dx:PanelContent>
                                                                        <div style="display: inline; float: left">
                                                                            <dx:ASPxComboBox ID="cmbEquipo" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                                                ClientInstanceName="cmbEquipo" DropDownStyle="DropDownList">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAdicionarEquipo">
                                                                                    <RequiredField IsRequired="True" ErrorText="Debe seleccionar un equipo para adicionar">
                                                                                    </RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </div>
                                                                        <div style="clear:both"></div>
                                                                        <div id="divResultadoMaterial">
                                                                            <dx:ASPxLabel ID="lblResultadoMaterial" runat="server" CssClass="comentario" Width="200px">
                                                                            </dx:ASPxLabel>
                                                                        </div>
                                                                    </dx:PanelContent>
                                                                </PanelCollection>
                                                            </dx:ASPxCallbackPanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <dx:ASPxCallbackPanel ID="cpAdicionEquipo" runat="server" ClientInstanceName="cpAdicionEquipo">
                                                    <PanelCollection>
                                                        <dx:PanelContent ID="pcDatosManual">
                                                            <table width="100%">
                                                                <tr>
                                                                    <td>
                                                                        <dx:ASPxButton ID="btnAdicionarEquipo" runat="server" 
                                                                            ValidationGroup="vgAdicionarEquipo" AutoPostBack="false" 
                                                                            Text="Adicionar Material" Width="200px">
                                                                            <ClientSideEvents Click="function(s, e) {
                                                                                    if(ASPxClientEdit.ValidateGroup(&#39;vgAdicionarEquipo&#39;)) {
                                                                                        if(!gvResultado.InCallback()) {
                                                                                            gvResultado.PerformCallback('adicionar|' + cmbEquipo.GetValue());
                                                                                        }
                                                                                    }
                                                                                }"></ClientSideEvents>
                                                                            <Image Url="../images/add.png">
                                                                            </Image>
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxCallbackPanel>
                                            </dx:ContentControl>
                                        </ContentCollection>
                                    </dx:TabPage>
                                </TabPages>
                            </dx:ASPxPageControl>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>

            <dx:ASPxRoundPanel ID="rpLog" runat="server" HeaderText="Log de Resultados" 
                ClientVisible="false" ClientInstanceName="rpLog" style="margin-top: 10px">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvLog" runat="server" ClientInstanceName="gvLog">
                        </dx:ASPxGridView>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
    </form>
</body>
</html>
