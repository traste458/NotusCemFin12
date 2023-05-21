<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AsignacionDeZonaAMotorizados.aspx.vb"
    Inherits="BPColSysOP.AsignacionDeZonaAMotorizados" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/UcShowmessages.ascx" TagName="ShowMessage"
    TagPrefix="sm" %>
<%@ Register TagPrefix="uc1" TagName="encabezadopagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>:: Administración de Zonas Para Motorizados  ::</title>
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
        function CargardatosUsuario(s, e) {
            cpPrincipal.PerformCallback('ConsultarUsuario' + ':' + cmbUsuario.GetValue());
        }
        function ActualizardatosUsuario(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgRegistrar')) {
            cpPrincipal.PerformCallback('ActualizarUsuario' + ':' + cmbUsuario.GetValue() + ':' + ddlCiudad.GetValue() + ':' + ddlZona.GetValue() + ':' + txtMsisdn.GetValue() + ':' + ddlTipoServicio.GetValue() + ':' + txtPlaca.GetValue());
            }
            }
        function finalizarCallBackMaterial(s, e) {

            ActualizarEncabezado(s, e);
        }


        function ActualizarEncabezado(s, e) {
            if (LoadingPanel) { LoadingPanel.Hide(); }
            if (s.cpMensaje) {
                if (document.getElementById('divEncabezado')) {
                    document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
                }
            }
            if (s.cpMensajePopUp && mensajePopUp) {
                if (s.cpTituloPopUp) { mensajePopUp.SetHeaderText(s.cpTituloPopUp); }
                if (document.getElementById(textoMensajePopUp.name)) {
                    document.getElementById(textoMensajePopUp.name).innerHTML = s.cpMensajePopUp;
                    mensajePopUp.Show();
                    s.cpMensajePopUp = null;
                    s.cpTituloPopUp = null;
                }
            }
            if (s.cpLimpiarFiltros) { LimpiarFiltros(); }
        }
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
        function OnGetSelectionButtonClick(s, e) {
            var grid = gridLookUp.GetGridView();
            grid.GetRowValues(grid.GetFocusedRowIndex(), 'ProductName;ProductID', OnGetRowValues);
        }
        function OnGetRowValues(values) {
            if (values[0] == null) return;
            alert('Product: ' + values[0]);
        }
        function OnGetSelectionButtonClick(s, e) {
            var grid = gridLookUp.GetGridView();
            grid.GetSelectedFieldValues('ProductName', OnGetSelectedFieldValues);
        }
        function OnGetSelectedFieldValues(selectedValues) {
            if (selectedValues.length == 0) return;
            s = "";
            for (i = 0; i < selectedValues.length; i++) {
                for (j = 0; j < selectedValues[i].length; j++) {
                    s = s + selectedValues[i][j];
                }
                s += "\n";
            }
            alert("Selected Products:\n" + s);
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:encabezadopagina ID="miEncabezado" runat="server" />
        </div>
        <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 60%;">
            <dx:ASPxRoundPanel ID="rpFiltroCampanias" runat="server" HeaderText="Asignación Zona por Usuario" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                            <ClientSideEvents EndCallback="function(s,e){  finalizarCallBackMaterial(s,e);}" />
                            <PanelCollection>
                                <dx:PanelContent ID="PanelContent1" runat="server">
                                    <table cellpadding="1">
                                        <tr>
                                            <td>Usuario</td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbUsuario" runat="server" valueType="System.String" ClientInstanceName="cmbUsuario" IncrementalFilteringMode="Contains"
                                                    TextFormatString="{0} ({1})" ValueField="Identificacion" Width="380px" CallbackPageSize="20" EnableCallbackMode="True" FilterMinLength="4" IncrementalFilteringDelay="0" 
                                                    OnItemRequestedByValue="cmbUsuario_OnItemRequestedByValue_SQL" OnItemsRequestedByFilterCondition="cmbUsuario_OnItemsRequestedByFilterCondition_SQL">
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { CargardatosUsuario(s, e); }" />
                                                    <Columns>
                                                        <dx:ListBoxColumn Caption="Identificacion" FieldName="Identificacion" Width="80px" />
                                                        <dx:ListBoxColumn Caption="Usuario" FieldName="Usuario" Width="300px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="Por favor seleccione un usuario para realizar la actualización" IsRequired="True" />
                                                        </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>Ciudad Usuario</td>
                                            <td>
                                                <dx:ASPxComboBox ID="ddlCiudad" runat="server" ClientInstanceName="ddlCiudad" IncrementalFilteringMode="Contains"
                                                    ValueType="System.Int32">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="Por favor seleccione un usuario para realizar la actualización" IsRequired="True" />
                                                        </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>Zona</td>
                                            <td>
                                                <dx:ASPxGridLookup ID="ddlZona" runat="server" SelectionMode="Multiple" ClientInstanceName="ddlZona" 
                                                    KeyFieldName="nombre" Width="380px" TextFormatString="{0}" MultiTextSeparator=", " >
                                                    <ClientSideEvents ButtonClick="function(s,e) {ddlZona.GetGridView().UnselectAllRowsOnPage(); ddlZona.HideDropDown(); }" />
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" Name="Estado" Caption="Estado"  />
                                                        <dx:GridViewDataTextColumn FieldName="nombre" />
                                                    </Columns>
                                                    <GridViewProperties>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                    </GridViewProperties>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="Por favor seleccione un usuario para realizar la actualización" IsRequired="True" />
                                                        </ValidationSettings>
                                                </dx:ASPxGridLookup>
                                            </td>
                                            <td>Telefono</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtMsisdn" runat="server" ClientInstanceName="txtMsisdn" Height="19px"
                                                    MaxLength="10" NullText="Telefono..." onkeypress="javascript:return ValidaNumero(event);"
                                                    Width="170px">
                                                </dx:ASPxTextBox>

                                            </td>

                                        </tr>
                                        <tr>
                                            <td>Tipo de Servicio</td>
                                            <td>
                                                <dx:ASPxGridLookup ID="ddlTipoServicio" runat="server" SelectionMode="Multiple" ClientInstanceName="ddlTipoServicio"
                                                    KeyFieldName="idTipoServicio" Width="380px" TextFormatString="{0}" MultiTextSeparator=", ">
                                                    <ClientSideEvents ButtonClick="function(s,e) {ddlTipoServicio.GetGridView().UnselectAllRowsOnPage(); ddlTipoServicio.HideDropDown(); }" />
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                        <dx:GridViewDataTextColumn FieldName="TipoServicio" />
                                                    </Columns>
                                                    <GridViewProperties>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>
                                                    </GridViewProperties>
                                                </dx:ASPxGridLookup>
                                            </td>
                                            <td>Placa</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtPlaca" runat="server" ClientInstanceName="txtPlaca" Height="19px"
                                                    MaxLength="10" Width="170px">
                                                </dx:ASPxTextBox>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="1">
                                                <dx:ASPxButton ID="btnImageAndText" runat="server"
                                                    Width="90px" Text="Actualizar" AutoPostBack="false" ValidationGroup="vgRegistrar">
                                                    <ClientSideEvents Click="function(s, e) { ActualizardatosUsuario(s, e); }" />
                                                    <Image Url="../images/Edit-32.png"></Image>
                                                </dx:ASPxButton>

                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                        
                    </dx:PanelContent>
                </PanelCollection>

            </dx:ASPxRoundPanel>

        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
        <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 60%;">
        <dx:ASPxRoundPanel ID="rpAsignacionZonaPorArchivo" runat="server" HeaderText="Asignación de Zonas por Archivo" Theme="SoftOrange">
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
            </div>
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
                                                                <dx:GridViewDataTextColumn Caption="Identificacion" FieldName="Identificacion" ShowInCustomizationForm="False">
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
