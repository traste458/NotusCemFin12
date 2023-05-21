<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionPlanes.aspx.vb"
    Inherits="BPColSysOP.AdministracionPlanes" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administración de Planes de Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
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

        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);
            }
        }

        function VerEjemplo(ctrl) {
            if ($("#imagenEjemplo").css("display") == "none") {
                ctrl.html('(Ocultar imagen Ejemplo)');
            } else {
                ctrl.html('(Ver imagen Ejemplo)');
            }
            $("#imagenEjemplo").toggle('slow');
        }

        function FiltrarDevExpMaterial(s, e) {
            try {
                if (s.GetText().length >= 4 || cmbEquipo.GetItemCount() != 0) {
                    cpFiltroMaterial.PerformCallback(s.GetText());
                }
            }
            catch (e) { }
        }

        function Editar(element, key) {
            TamanioVentana();
            dialogoEditar.SetContentUrl("EditarPlanVenta.aspx?idPlan=" + key);
            dialogoEditar.SetSize(myWidth * 0.7, myHeight * 0.9);
            dialogoEditar.ShowWindow();
        }

        function OnInitVer(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    dialogoEditar.Hide();
            });
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('rpAdicionPlan');
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px;
        width: 38%;">
        <dx:ASPxRoundPanel ID="rpAdicionPlan" runat="server" HeaderText="Adición de Plan"
            Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1" width="100%">
                        <tr>
                            <td>
                                Nombre Plan:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombrePlan" runat="server" Width="300px" NullText="Ingrese el nombre del plan...">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgPlan">
                                        <RequiredField IsRequired="True" ErrorText="El nombre del plan es requerido"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Descripción:
                            </td>
                            <td>
                                <dx:ASPxMemo ID="memoDescripcionPlan" runat="server" Columns="25" Rows="3" Width="300px"
                                    NullText="Ingrese la descripción del plan...">
                                    <ValidationSettings ValidationGroup="vgPlan" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" ErrorText="La descripci&#243;n del plan es requerida">
                                        </RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Cargo Fijo Mensual (Sin IVA):
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtCargoFijoMensual" runat="server" Width="120px" NullText="Valor CFM...">
                                    <MaskSettings Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol">
                                    </MaskSettings>
                                    <ValidationSettings ValidationGroup="vgPlan" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" ErrorText="El cargo fijo mensual es requerido">
                                        </RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Tipo de Plan:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbTipoPlan" runat="server" IncrementalFilteringMode="Contains">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgPlan">
                                        <RequiredField IsRequired="True" ErrorText="El tipo de plan es requerido"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Activo:
                            </td>
                            <td>
                                <dx:ASPxCheckBox ID="chbActivo" runat="server" CheckState="Checked">
                                </dx:ASPxCheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <blockquote>
                                    Por favor utilice un método para el cargue de los equipos<br />
                                    asociados al plan:</blockquote>
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
                                                        <img id="ventas" src="../images/EjemploMaterialesPlanVenta.png" name="ventas" alt="Ver imagen de ejemplo." />
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
                                                                            Valor Equipo:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtValorEquipo" runat="server" Width="100px" NullText="Valor sin Iva...">
                                                                                <MaskSettings IncludeLiterals="DecimalSymbol" Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" />
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAdicionarEquipo">
                                                                                    <RequiredField ErrorText=" El valor del equipo es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            Valor Iva:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtValorIva" runat="server" Width="100px" NullText="Valor Iva...">
                                                                                <MaskSettings IncludeLiterals="DecimalSymbol" Mask="$&lt;0..9999999g&gt;.&lt;00..99&gt;" />
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAdicionarEquipo">
                                                                                    <RequiredField ErrorText="El valor del iva es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxButton ID="btnAdicionarEquipo" runat="server" ValidationGroup="vgAdicionarEquipo" AutoPostBack="false">
                                                                                <ClientSideEvents Click="function(s, e) {
                                                                                        if(ASPxClientEdit.ValidateGroup(&#39;vgAdicionarEquipo&#39;)) {
                                                                                            if(!grid.InCallback()) {
                                                                                                grid.PerformCallback();
                                                                                            }
                                                                                        }
                                                                                    }"></ClientSideEvents>
                                                                                <Image Url="../images/add.png">
                                                                                </Image>
                                                                            </dx:ASPxButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <dx:ASPxGridView ID="gvEquipos" runat="server" AutoGenerateColumns="False" ClientInstanceName="grid">
                                                                    <ClientSideEvents EndCallback="function(s, e) {
                                                                        $('#divEncabezado').html(s.cpMensaje);
                                                                        ASPxClientEdit.ClearEditorsInContainerById('cpAdicionEquipo','vgAdicionarEquipo');
                                                                    }" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Material" ShowInCustomizationForm="True" VisibleIndex="1"
                                                                            FieldName="material">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Descripción Material" ShowInCustomizationForm="True"
                                                                            VisibleIndex="2" FieldName="descripcion">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Precio Equipo" ShowInCustomizationForm="True"
                                                                            VisibleIndex="3" FieldName="precioEquipo">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:c}">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Iva Equipo" ShowInCustomizationForm="True" VisibleIndex="4"
                                                                            FieldName="precioIvaEquipo">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:c}">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxCallbackPanel>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:TabPage>
                                    </TabPages>
                                </dx:ASPxPageControl>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <div style="text-align: center; width: 100%">
                                    <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Crear Plan" Style="display: inline"
                                        ValidationGroup="vgPlan">
                                        <Image Url="../images/add.png">
                                        </Image>
                                        <ClientSideEvents Click="function(s, e) {
                                                if(ASPxClientEdit.ValidateGroup('vgPlan')) {
                                                    if($('#divFileContainer').is(':empty') && grid.GetVisibleRowsOnPage()==0) {
                                                        alert('Debe seleccionar un archivo o agregar equipos manualmente para poder continuar con la creación del plan.');
                                                            e.processOnServer = false;
                                                    } else {
                                                        Callback.PerformCallback();
                                                        LoadingPanel.Show();
                                                    }
                                                }
                                            }"></ClientSideEvents>
                                    </dx:ASPxButton>
                                    &nbsp;&nbsp;
                                    <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Style="display: inline"
                                        AutoPostBack="false">
                                        <Image Url="../images/eraserminus.gif">
                                        </Image>
                                        <ClientSideEvents Click="function(s, e) {
                                            LimpiaFormulario();
                                        }" />
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" Visible="false" HeaderText="Log de Errores">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="False">
                                                <Columns>
                                                    <dx:GridViewDataTextColumn Caption="Id" FieldName="Id" ShowInCustomizationForm="True"
                                                        VisibleIndex="0">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Valor" FieldName="Nombre" ShowInCustomizationForm="True"
                                                        VisibleIndex="1">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Descripción" FieldName="Descripcion" ShowInCustomizationForm="True"
                                                        VisibleIndex="2">
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                            </dx:ASPxGridView>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <div style="float: right; margin-top: 5px; width: 58%;">
        <dx:ASPxCallbackPanel runat="server" ID="cpBusquedaPlanes" ClientInstanceName="cpBusquedaPlanes"
           >
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin-bottom: 15px">
                        <dx:ASPxRoundPanel ID="rpFiltroPlanes" runat="server" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>
                                            <td>
                                                Nombre Plan:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNombrePlanFiltro" runat="server" Width="170px" NullText="Ingrese valor de búsqueda...">
                                                </dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Activo:
                                            </td>
                                            <td>
                                                <dx:ASPxCheckBox ID="chbEstadoFiltro" runat="server" CheckState="Checked">
                                                </dx:ASPxCheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" AutoPostBack="false">
                                                    <Image Url="../images/find.gif">
                                                    </Image>
                                                    <ClientSideEvents Click="function(s, e) {
                                                            LoadingPanel.Show();
                                                            cpBusquedaPlanes.PerformCallback();
                                                        }"></ClientSideEvents>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div style="margin-bottom: 5px;">
                        <dx:ASPxRoundPanel ID="rpResultadoPlanes" runat="server" Width="100%" HeaderText="Listado de Planes">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gvPlanes" runat="server" Width="100%" KeyFieldName="IdPlan">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="IdPlan" Caption="ID" ShowInCustomizationForm="True"
                                                VisibleIndex="0">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="NombrePlan" Caption="Plan" ShowInCustomizationForm="True"
                                                VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="NombreTipoPlan" Caption="Tipo de Plan" ShowInCustomizationForm="True"
                                                VisibleIndex="2">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="Descripcion" Caption="Descripción" ShowInCustomizationForm="True"
                                                VisibleIndex="3">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="CargoFijoMensual" Caption="CFM" ShowInCustomizationForm="True"
                                                VisibleIndex="4" Width="80px">
                                                <PropertiesTextEdit DisplayFormatString="{0:c}" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataColumn Caption="" VisibleIndex="10">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/Edit-User.png"
                                                        Cursor="pointer" ToolTip="Ver / Editar Plan" OnInit="Link_Init">
                                                        <ClientSideEvents Click="function(s, e) { Editar(this, {0}); }" />
                                                    </dx:ASPxHyperLink>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                        </Columns>
                                        <SettingsPager PageSize="10">
                                        </SettingsPager>
                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <dx:ASPxPopupControl ID="pcEdidarPlan" runat="server" ClientInstanceName="dialogoEditar"
        HeaderText="Modificación del Plan de Venta" AllowDragging="true" Width="310px"
        Height="160px" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
        <ClientSideEvents Init="OnInitVer"></ClientSideEvents>
        <ContentCollection>
            <dx:PopupControlContentControl ID="pccc" runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
