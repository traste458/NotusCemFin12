<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionDeUsuarios.aspx.vb" Inherits="BPColSysOP.AdministracionDeUsuarios" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>::Administración De Usuarios::</title>
    <link rel="shortcut icon" href="../images/baloons_small.png" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script type="text/javascript">
        var ultimaBodega = null;
        function onSelectedBodegasChanged(cmbTipoBodega) {

            //Llena bodegas
            if (cmbBodegasDisp.InCallback()) {
                ultimaBodega = cmbTipoBodega.GetValue().toString();
            }
            else {
                cmbBodegasDisp.PerformCallback(cmbTipoBodega.GetValue().toString());
            }
        }


        function LimpiarFormulario() {
            if (confirm('Esta seguro que desea Limpiar El formulario?')) {
                window.location.href = 'AdministracionDeUsuarios.aspx';
            }
        }

        function VerEjemplo() {
            window.location.href = 'Plantillas/PlantillaMatriztrasporteOMS.xlsx';
        }

        function CrearUsuario(s, e) {
            var error = '';
            if ((cmbPerfilesEditar.GetValue() == 201 || cmbPerfilesEditar.GetValue() == 203) && (cmbSiteCall.GetValue() == 0 || cmbSiteCall.GetValue() == null)) {
                alert('Para este Perfil debe seleccionar un call y un site');
                error = 'yes'
            }
            if (error != 'yes') {
                if (ASPxClientEdit.ValidateGroup('Guardar')) {
                    if (confirm('Esta seguro que desea guardar la información?')) {
                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'Crear');
                    }
                }
            }
        }

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
                    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'CreacionMasiva');
                    $('#divpnlErrores').css('visibility', 'visible');
                } else {
                    LoadingPanel.Hide();
                }
                LoadingPanel.Hide();
            }
        }


        function actualizarTercero(s, e) {
            var error = '';
            if (cmbCiudadEditar.GetValue() == 0 || cmbCiudadEditar.GetValue() == null) {
                alert('Debe seleccionar una ciudad.');
                error = 'yes'
            }
            if (cmbPerfilesEditar.GetValue() == 0 || cmbPerfilesEditar.GetValue() == null) {
                alert('Debe seleccionar una perfil.');
                error = 'yes'
            }
            if ((cmbPerfilesEditar.GetValue() == 201 || cmbPerfilesEditar.GetValue() == 203) && (cmbSiteCall.GetValue() == 0 || cmbSiteCall.GetValue() == null)) {
                alert('Para este Perfil debe seleccionar un call y un site');
                error = 'yes'
            }
            if (error != 'yes') {
                if (ASPxClientEdit.ValidateGroup('Guardar')) {
                    if (confirm('Esta seguro que desea guardar la información?')) {
                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'modificar');
                        pcEditarTercero.Hide();
                    }
                }
            }
        }

        function consultarTerceros(s, e) {
            if (txtCedula.GetValue() == null & txtUsuario.GetValue() == null & txtNombreApellido.GetValue() == null & cmbCiudades.GetValue() == 0 & cmbPerfiles.GetValue() == 0) {
                alert("Se debe seleccionar al menos un filtro");
            }
            else
                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'ConsultarInformacion', 1);
        }

        function MostrarInfoEncabezadoPop(s, e) {
            if (s.cp) {
                $('#divEncabezadoPop').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") !== -1 || s.cpMensaje.indexOf("lblWarning") !== -1 || s.cpMensaje.indexOf("lblSuccess") !== -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezadoPop').offset().top }, 'slow');
                }
            }
        }

    </script>

    <style type="text/css">
        txtNombreEditar:active {
            border: 3px solid #000;
            background-color: #F0F8FF;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true">
                <ClientSideEvents EndCallback="function(s,e){
                    MostrarInfoEncabezadoPop(s, e);
                    }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="roundPanelLectura" runat="server" ClientInstanceName="roundPanelLectura" HeaderText="Consulta-Creacion" Width="100%">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <dx:ASPxRoundPanel ID="rpRegistro" runat="server" ShowHeader="true" HeaderText="Consulta Usuarios"
                                        Width="100%">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <div style="width: 90%; min-width: 500px">
                                                    <table>
                                                        <tr>
                                                            <td align="left">
                                                                <a style="color: Black; font-size: 10px; cursor: pointer;" id="aLecturas"
                                                                    onclick="toggle('divFiltros');">
                                                                    <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Filtros Búsqueda"
                                                                        Width="16px" />
                                                                    Ver/Ocultar Filtros Búsqueda</a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 90%;">
                                                    <dx:ASPxRoundPanel ID="rpFiltro" runat="server" ShowHeader="false" Width="100%">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <div>
                                                                    <dx:ASPxButton runat="server" ID="btnCrear" Text="Crear" AutoPostBack="False" Width="20%"
                                                                        ImageSpacing="10px" ClientInstanceName="btnCrear">
                                                                        <ClientSideEvents Click="function(s, e){
                                                                            CallbackvsShowPopup(pcEditarTercero,2,1,'0.3','0.3');
                                                                                        }" />
                                                                        <Image Url="~/images/add_user.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </div>
                                                                <br />
                                                                <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Width="40%">
                                                                    <Items>
                                                                        <dx:LayoutGroup Caption="Filtros de Busqueda" ColCount="2">
                                                                            <Items>
                                                                                <dx:LayoutItem Caption="Cedula:">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemCedula">
                                                                                            <dx:ASPxTextBox ID="txtCedula" ClientInstanceName="txtCedula" runat="server" NullText="Digite la cedula..." MaxLength="50" Width="250px">
                                                                                            </dx:ASPxTextBox>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem Caption="Usuario:">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemUsuario">
                                                                                            <dx:ASPxTextBox ID="txtUsuario" runat="server" ClientInstanceName="txtUsuario" NullText="Digite el usuario..." MaxLength="50" Width="250px">
                                                                                            </dx:ASPxTextBox>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem Caption="Nombres y/o Apellidos:">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNombres">
                                                                                            <dx:ASPxTextBox ID="txtNombreApellido" runat="server" ClientInstanceName="txtNombreApellido" NullText="Digite el nombre..." MaxLength="50" Width="250px">
                                                                                            </dx:ASPxTextBox>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem Caption="Perfil:">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                                            <dx:ASPxComboBox ID="cmbPerfiles" ClientInstanceName="cmbPerfiles" runat="server" Width="200px" ValueType="System.Int32">
                                                                                            </dx:ASPxComboBox>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                    <CaptionSettings Location="Left" VerticalAlign="Middle" />
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem Caption="Ciudades">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                                            <dx:ASPxComboBox ID="cmbCiudades" ClientInstanceName="cmbCiudades" runat="server" Width="200px" ValueType="System.Int32" EnableCallbackMode="true">
                                                                                            </dx:ASPxComboBox>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                    <CaptionSettings Location="Left" VerticalAlign="Middle" />
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem Caption="">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                                                            <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Limpiar Filtros Aplicados"
                                                                                                Cursor="pointer" TabIndex="10">
                                                                                                <ClientSideEvents Click="function (s,e){
                                                                                                LimpiarFormulario();
                                                                                                 }" />
                                                                                            </dx:ASPxImage>
                                                                                            <dx:ASPxImage ID="imgConsultarDetalle" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Búsqueda"
                                                                                                ClientInstanceName="imgConsultarDetalle" Cursor="pointer">
                                                                                                <ClientSideEvents Click="function (s,e){
                                                                                                consultarTerceros();
                                                                                                 }" />
                                                                                            </dx:ASPxImage>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                    <CaptionSettings Location="Left" VerticalAlign="Middle" />
                                                                                </dx:LayoutItem>
                                                                            </Items>
                                                                        </dx:LayoutGroup>
                                                                    </Items>
                                                                </dx:ASPxFormLayout>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxRoundPanel>
                                                </div>
                                                <br />
                                                <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="pcEditar" PopupHorizontalAlign="WindowCenter"
                                                    PopupVerticalAlign="WindowCenter" Modal="true" HeaderText="Edici&oacute;n de Estado de Usuario"
                                                    Width="500px" ScrollBars="Auto"
                                                    ShowMaximizeButton="True" ShowPageScrollbarWhenModal="True" CloseAction="CloseButton">
                                                    <ModalBackgroundStyle CssClass="modalBackground" />
                                                    <ContentCollection>
                                                        <dx:PopupControlContentControl>
                                                            <dx:ASPxFormLayout ID="flDatosVenta" runat="server" RequiredMarkDisplayMode="RequiredOnly"
                                                                EnableViewState="false" AlignItemCaptionsInAllGroups="True">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="Id Usuario" HelpText="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                                                <dx:ASPxTextBox ID="txtIdUsuario" runat="server" Width="250px" ClientInstanceName="txtIdUsuario" ReadOnly="true" ForeColor="Gray" BackColor="LightGray">
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="Nombre" HelpText="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                                                <dx:ASPxTextBox ID="txtNombre" runat="server" Width="250px" ClientInstanceName="txtNombre" ReadOnly="true" ForeColor="Gray" BackColor="LightGray">
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="Observaci&oacute;n" HelpText="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                                                <dx:ASPxMemo ID="txtObservacion" runat="server" Width="250px" Height="40px" ClientInstanceName="txtObservacion">
                                                                                    <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="Edicion"
                                                                                        ErrorTextPosition="Bottom">
                                                                                        <RequiredField IsRequired="true" ErrorText="Observación requerida" />
                                                                                        <RegularExpression ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑñÑ\-\#\[\]\(\)]+\s*$"
                                                                                            ErrorText="El texto contiene caracteres no permitidos" />
                                                                                    </ValidationSettings>
                                                                                </dx:ASPxMemo>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem ShowCaption="false" RequiredMarkDisplayMode="Hidden" HorizontalAlign="Center"
                                                                        Width="100">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                <br />
                                                                                <dx:ASPxButton runat="server" ID="btnAnular" Text="Desactivar" AutoPostBack="False"
                                                                                    ImageSpacing="5px" ValidationGroup="Edicion" ClientInstanceName="btnAnular" Enabled="false">
                                                                                    <ClientSideEvents Click="function(s, e){
                                                                                        if(ASPxClientEdit.ValidateGroup('crear')){
                                                                                        EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'desabilitar');
                                                                                        }
                                                                                        }" />
                                                                                    <Image Url="~/img/eliminar.gif">
                                                                                    </Image> 
                                                                                </dx:ASPxButton>
                                                                                <dx:ASPxButton runat="server" ID="btnReactivar" Text="Activar" AutoPostBack="False"
                                                                                    ImageSpacing="5px" ValidationGroup="Edicion" ClientInstanceName="btnReactivar" Enabled="false">
                                                                                    <ClientSideEvents Click="function(s, e){
                                                        if(ASPxClientEdit.ValidateGroup('crear')){
                                                             EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'habilitar');
                                                                                    }
                                                                                }" />

                                                                                    <Image Url="~/img/active.png">
                                                                                    </Image>
                                                                                </dx:ASPxButton>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                </Items>
                                                                <SettingsItemCaptions HorizontalAlign="Left" Location="Left" />
                                                                <SettingsItemHelpTexts Position="Bottom"></SettingsItemHelpTexts>
                                                            </dx:ASPxFormLayout>
                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>
                                                <br />

                                                <dx:ASPxRoundPanel ID="rpDatos" runat="server" ClientInstanceName="rpDatos"
                                                    ShowHeader="true" HeaderText="Detalle de la Información" Width="100%" ClientVisible="true">
                                                    <PanelCollection>
                                                        <dx:PanelContent ID="PanelContent1" runat="server">
                                                            <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                                                SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                                AutoPostBack="true" ClientInstanceName="cbFormatoExportar"
                                                                Width="250px">
                                                                <ClientSideEvents ButtonClick="function(s, e) {
	                                                        LoadingPanel.Show();
                                                        setTimeout('LoadingPanel.Hide();',2000);                                                                   
                                                        }" />
                                                                <Items>
                                                                    <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" Selected="true" />
                                                                </Items>
                                                                <Buttons>
                                                                    <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                                                        <Image Url="../images/upload.png">
                                                                        </Image>
                                                                    </dx:EditButton>
                                                                </Buttons>
                                                                <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                                                    Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                                                    <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                                                    <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                                                </ValidationSettings>
                                                            </dx:ASPxComboBox>
                                                            <dx:ASPxGridView ID="gvDetalle" runat="server" Visible="true" KeyFieldName="idtercero" ClientInstanceName="gvDetalle" Width="95%" AutoGenerateColumns="False">

                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn FieldName="idtercero" ReadOnly="true" Caption="IdUsuario"
                                                                        VisibleIndex="0">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="cedula" ShowInCustomizationForm="False" Caption="Identificacion"
                                                                        VisibleIndex="1">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="nombre" ShowInCustomizationForm="False" Caption="Nombre"
                                                                        VisibleIndex="2">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="usuario" ShowInCustomizationForm="False" Caption="Usuario"
                                                                        VisibleIndex="3">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="perfil" ShowInCustomizationForm="False" Caption="Perfil"
                                                                        VisibleIndex="4">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ciudad" ShowInCustomizationForm="False" Caption="Ciudad"
                                                                        VisibleIndex="5">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="estado" ShowInCustomizationForm="False" Caption="Estado"
                                                                        VisibleIndex="6">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="idEstado" ShowInCustomizationForm="False" Caption="Idestado" Visible="false"
                                                                        VisibleIndex="7">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="8" Width="40px">
                                                                        <DataItemTemplate>
                                                                            <dx:ASPxHyperLink ID="lbEliminar" runat="server" ImageUrl="~/images/cancelar_srv.png" Cursor="pointer" ClientVisible="true"
                                                                                ToolTip="Desactivar Usuario" OnInit="Link_Init_Eliminar" Visible="true">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                                         CallbackvsShowPopup(pcEditar,1,{0},'0.3','0.3');
                                                                                   }" />
                                                                            </dx:ASPxHyperLink>
                                                                            <dx:ASPxHyperLink ID="lbActivar" runat="server" ImageUrl="~/images/ok.png" Cursor="pointer" ClientVisible="true"
                                                                                ToolTip="Desactivar Usuario" OnInit="Link_Init_Activar" Visible="true">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                                 CallbackvsShowPopup(pcEditar,1,{0},'0.3','0.3');
                                                                                 }" />
                                                                            </dx:ASPxHyperLink>
                                                                            <dx:ASPxHyperLink ID="lbEditar" runat="server" ImageUrl="~/images/Edit-User.png" Cursor="pointer" ClientVisible="true"
                                                                                ToolTip="Editar Usuario" OnInit="Link_Init" Visible="true">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                                 CallbackvsShowPopup(pcEditarTercero,1,{0},'0.3','0.3');
                                                                                 }" />

                                                                                <%--    <ClientSideEvents Click="function(s, e){
                                                CallbackvsShowPopup(pcEditar,1,{0},'0.3','0.3');
                                            }" />--%>
                                                                            </dx:ASPxHyperLink>
                                                                        </DataItemTemplate>
                                                                    </dx:GridViewDataColumn>
                                                                </Columns>
                                                                <SettingsPager PageSize="20">
                                                                </SettingsPager>
                                                            </dx:ASPxGridView>
                                                            <dx:ASPxGridViewExporter ID="expgveDatos" runat="server" GridViewID="gvDatos"></dx:ASPxGridViewExporter>
                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxRoundPanel>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <dx:ASPxPopupControl ID="pcEditarTercero" runat="server" ClientInstanceName="pcEditarTercero" PopupHorizontalAlign="WindowCenter"
                            PopupVerticalAlign="WindowCenter" Modal="true" HeaderText=""
                            Width="500px"
                            ShowMaximizeButton="True" ShowPageScrollbarWhenModal="True" CloseAction="CloseButton">
                            <ContentCollection>

                                <dx:PopupControlContentControl>
                                    <dx:ASPxRoundPanel ID="rpCambioResponsable" runat="server" HeaderText="Actualizacion y Creacion de Usuarios" ClientInstanceName="rpCambioResponsable"
                                        Width="100%" Height="100%">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <br />
                                                <div id="divEncabezadoPop">
                                                    <uc1:EncabezadoPagina ID="EncabezadoPop" runat="server" />
                                                </div>
                                                <br />
                                                <table style="width: 100%">
                                                    <tr>

                                                        <td class="field">Nombre:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxTextBox ID="txtNombreEditar" runat="server" Width="250px" ClientInstanceName="txtNombreEditar">
                                                                <ValidationSettings ErrorTextPosition="Bottom" ErrorDisplayMode="Text" Display="Dynamic" RequiredField-IsRequired="true"
                                                                    SetFocusOnError="true" ValidationGroup="Guardar">
                                                                    <RegularExpression ErrorText="Nombre no valido" ValidationExpression="^[0-9\s._A-Za-z]*$"></RegularExpression>
                                                                    <RequiredField IsRequired="True" ErrorText="Ingrese un valor..."></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>

                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="field">Cedula:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxTextBox ID="txtCedulaEditar" runat="server" Width="250px" ClientInstanceName="txtCedulaEditar">
                                                                <ValidationSettings ErrorTextPosition="Bottom" ErrorDisplayMode="Text" Display="Dynamic"
                                                                    SetFocusOnError="true" ValidationGroup="Guardar">
                                                                    <RegularExpression ErrorText="El documento no es valida" ValidationExpression="[0-9\._]*"></RegularExpression>
                                                                    <RequiredField IsRequired="True" ErrorText="Ingrese un valor"></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td class="field">Usuario:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxTextBox ID="txtUsuarioEditar" runat="server" Width="250px" ClientInstanceName="txtUsuarioEditar">
                                                                <ValidationSettings ErrorTextPosition="Bottom" ErrorDisplayMode="Text" Display="Dynamic"
                                                                    SetFocusOnError="true" ValidationGroup="Guardar">
                                                                    <RegularExpression ErrorText="Usuario No valido" ValidationExpression="^[0-9\._A-Za-z]*$"></RegularExpression>
                                                                    <RequiredField IsRequired="True" ErrorText="Ingrese un valor"></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="field">Correo:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxTextBox ID="txtCorreo" runat="server" Width="250px" ClientInstanceName="txtCorreo">
                                                                <ValidationSettings ErrorDisplayMode="Text" Display="Dynamic" ErrorTextPosition="Bottom"
                                                                    SetFocusOnError="true" ValidationGroup="Guardar">
                                                                    <RegularExpression ErrorText="E-mail invalido" ValidationExpression="\w+([-+.&#39;]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></RegularExpression>
                                                                    <RequiredField IsRequired="True" ErrorText="Ingrese un valor"></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>

                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="field">Perfil:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbPerfilesEditar" runat="server" ClientInstanceName="cmbPerfilesEditar" IncrementalFilteringMode="Contains"
                                                                Width="250px" DropDownStyle="DropDownList" ValueType="System.Int32" NullText="Seleccione un valor...">
                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { cmbCallCenter.PerformCallback('cargarCall:'+ cmbPerfilesEditar.GetValue()); }"></ClientSideEvents>
                                                                <ValidationSettings EnableCustomValidation="true" ValidationGroup="Guardar" SetFocusOnError="True"
                                                                    ErrorText="Seleccione un valor...">
                                                                    <RequiredField IsRequired="True" ErrorText="Seleccione un valor..."></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>

                                                    <tr>
                                                        <td class="field">Ciudades:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbCiudadEditar" runat="server" ClientInstanceName="cmbCiudadEditar" IncrementalFilteringMode="Contains"
                                                                Width="250px" DropDownStyle="DropDownList" ValueType="System.Int32" NullText="Seleccione un valor...">
                                                                <ValidationSettings EnableCustomValidation="true" ValidationGroup="Guardar" SetFocusOnError="True"
                                                                    ErrorText="Seleccione un valor...">
                                                                    <RequiredField IsRequired="True" ErrorText="Seleccione un valor..."></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td class="field">Centro De Costo:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbCentroDeCosto" runat="server" ClientInstanceName="cmbCentroDeCosto" IncrementalFilteringMode="Contains"
                                                                Width="250px" DropDownStyle="DropDownList" ValueType="System.Int32" NullText="Seleccione un valor...">
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>

                                                    <tr>
                                                        <td class="field">Empresa Temporal:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbEmpresaTemporal" runat="server" ClientInstanceName="cmbEmpresaTemporal" IncrementalFilteringMode="Contains"
                                                                Width="250px" DropDownStyle="DropDownList" ValueType="System.Int32" NullText="Seleccione un valor...">
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>


                                                    <tr>
                                                        <td colspan="2" style="text-align: center">
                                                            <dx:ASPxButton ID="btnModificar" runat="server" HorizontalAlign="Center" ValidationGroup="Guardar"
                                                                AutoPostBack="false" Text="Guardar Cambios" Width="200px">
                                                                <ClientSideEvents Click="actualizarTercero" />
                                                                <Image Url="../images/save_all.png">
                                                                </Image>
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" style="text-align: center">
                                                            <dx:ASPxButton ID="btnCrearUsuario" runat="server" HorizontalAlign="Center" ValidationGroup="Guardar"
                                                                AutoPostBack="false" Text="Crear Usuario" Width="200px">
                                                                <ClientSideEvents Click="CrearUsuario" />
                                                                <Image Url="../images/userCreate.png">
                                                                </Image>
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="True">
            </dx:ASPxLoadingPanel>
        </div>
    </form>
</body>
</html>
