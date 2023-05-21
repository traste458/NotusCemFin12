<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionGerenciasSiembra.aspx.vb"
    Inherits="BPColSysOP.AdministracionGerenciasSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Administración Gerencias SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var myWidth, myHeight;

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

        function RegistrarGerencia() {
            if (ASPxClientEdit.ValidateGroup('vgCrear')) {
                cpRegistro.PerformCallback('registrar|0');
            }
        }

        function ActualizarGerencia(idGerencia) {
            if (ASPxClientEdit.ValidateGroup('vgActualizar')) {
                pcEdicionGerencia.PerformCallback('actualizar|' + idGerencia);
                pcEdicionGerencia.SetVisible(false);
            }
        }

        function ActualizarCoordinacion(idCoordinador, idGerencia) {
            if (ASPxClientEdit.ValidateGroup('vgActualizarCoordinador')) {
                //cpRegistro.PerformCallback('actualizarCoordinacion|' + idCoordinador + ',' + idGerencia);
                pcEdicionCoordinacion.PerformCallback('actualizarCoordinacion|' + idCoordinador + ',' + idGerencia);
                pcEdicionGerencia.SetVisible(false);

            }
        }

        function AbrirModificar(s, idGerencia) {
            TamanioVentana();
            pcEdicionGerencia.SetSize(myWidth * 0.4, myHeight * 0.4);
            pcEdicionGerencia.ShowWindow();
            pcEdicionGerencia.PerformCallback('abrir|' + idGerencia);
        }

        function AbrirModificarCoordinador(s, idCoordinador, idGerencia) {
            TamanioVentana();
            pcEdicionCoordinacion.SetSize(myWidth * 0.4, myHeight * 0.4);
            pcEdicionCoordinacion.ShowWindow();
            pcEdicionCoordinacion.PerformCallback('abrirCoordinador|' + idCoordinador + ',' + idGerencia);
        }

        function DesvincularCoordinador(s, key) {
            if (confirm('¿Realmente desea desvincular el Coordinador de la Gerencia actual?')) {
                cpRegistro.PerformCallback('desvincular|' + key);
            }
        }

        function DesvincularConsultor(s, key) {
            if (confirm('¿Realmente desea desvincular el Consultor de la Coordinación actual?')) {
                cpRegistro.PerformCallback('desvincularConsultor|' + key);
            }
        }
        function CreacionGerencia() {
            TamanioVentana();
            pcCreacionGerencia.SetSize(myWidth * 0.4, myHeight * 0.4);
            pcCreacionGerencia.PerformCallback();
            pcCreacionGerencia.Show();


        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="cpRegistro"
            ScrollBars="Auto">
            <ClientSideEvents EndCallback="function(s, e) { 
                if(s.cpMensajeRegistro) { $('#divEncabezado').html(s.cpMensajeRegistro); }
                //cblEjecutivos.GetItemCount();
                gvResultado.PerformCallback();
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <div style="float: left">
                        <dx:ASPxRoundPanel ID="rpFiltroBusqueda" runat="server" Width="40%" HeaderText="Filtro de Búsqueda">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxFormLayout ID="flBusqueda" runat="server">
                                        <Items>
                                            <dx:LayoutItem Caption="Nombre Gerencia:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtFiltroNombreGerencia" runat="server" Width="170px" MaxLength="255"
                                                            NullText="Nombre a buscar...">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activo:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="cbFiltroActivo" runat="server" CheckState="Checked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                    <table>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnBuscar" runat="server" Text="Buscar" AutoPostBack="false" HorizontalAlign="Center">
                                                    <ClientSideEvents Click="function(s, e) {
                                                        gvResultado.PerformCallback();
                                                    }" />
                                                    <Image Url="~/images/find.gif">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnCrearGerencia" runat="server" Text="Crear Gerencias" ClientInstanceName="btnCrearGerencia" ToolTip="Permite Crear Gerencias" AutoPostBack="false" HorizontalAlign="Center">
                                                    <ClientSideEvents Click="function(s, e) {
                                                        CreacionGerencia();
                                                    }" />
                                                    <Image Url="~/images/editCerrado.gif">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <dx:ASPxRoundPanel ID="rpResultadoBusqueda" runat="server" HeaderText="Resultado de Búsqueda"
                            Style="margin-top: 10px;">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <div id="Div1" style="height:300px;width:500px;overflow:auto;">
                                        <dx:ASPxGridView ID="gvResultado" runat="server" KeyFieldName="IdGerencia" ClientInstanceName="gvResultado"
                                            AutoGenerateColumns="False">
                                            <ClientSideEvents EndCallback="function(s, e) {
                                            if(s.cpMensajeConsulta) { $('#divEncabezado').html(s.cpMensajeConsulta) };
                                        }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="Id" FieldName="IdGerencia" ShowInCustomizationForm="True"
                                                    VisibleIndex="0">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Nombre de la Gerencia" FieldName="Nombre" ShowInCustomizationForm="True"
                                                    VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataCheckColumn Caption="Activo" FieldName="Activo" ShowInCustomizationForm="True"
                                                    VisibleIndex="2">
                                                </dx:GridViewDataCheckColumn>
                                                <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="10">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink runat="server" ID="lnkModificar" ImageUrl="../images/edit.gif"
                                                            Cursor="pointer" ToolTip="Modificar Gerencia" OnInit="Link_Init">
                                                            <ClientSideEvents Click="function(s, e) { AbrirModificar(this, {0}); }" />
                                                        </dx:ASPxHyperLink>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsDetail ShowDetailRow="True" ExportMode="All"></SettingsDetail>
                                            <Templates>
                                                <DetailRow>
                                                    <dx:ASPxGridView ID="gvDetalleGerencia" runat="server" ClientInstanceName="gvDetalleGerencia"
                                                        KeyFieldName="IdPersonaGerencia" Width="100%" OnBeforePerformDataSelect="gvDetalleGerencia_DataSelect"
                                                        AutoGenerateColumns="false">
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="IdPersona" Caption="Id." ShowInCustomizationForm="True"
                                                                VisibleIndex="0">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Persona" Caption="Nombre Coordinador" ShowInCustomizationForm="True"
                                                                VisibleIndex="1">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="IdentificacionPersona" Caption="Identificación Coordinador"
                                                                ShowInCustomizationForm="True" VisibleIndex="2">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="10">
                                                                <DataItemTemplate>
                                                                    <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eliminar.gif"
                                                                        Cursor="pointer" ToolTip="Desvincular Coordinador" OnInit="LinkDetalle_Init">
                                                                        <ClientSideEvents Click="function(s, e) { DesvincularCoordinador(this, {0}); }" />
                                                                    </dx:ASPxHyperLink>
                                                                    <dx:ASPxHyperLink runat="server" ID="lnkAdicionarConsultor" ImageUrl="../images/Edit-User.png"
                                                                        Cursor="pointer" ToolTip="Adicionar Consultores">
                                                                        <ClientSideEvents Click="function(s, e) { AbrirModificarCoordinador(this, {0}, {1}); }" />
                                                                    </dx:ASPxHyperLink>
                                                                </DataItemTemplate>
                                                            </dx:GridViewDataColumn>
                                                        </Columns>
                                                        <Settings ShowFooter="false" />
                                                        <SettingsDetail ShowDetailRow="True" ExportMode="All"></SettingsDetail>
                                                        <Templates>
                                                            <DetailRow>
                                                                <dx:ASPxGridView ID="gvDetalleCoordinacion" runat="server" ClientInstanceName="gvDetalleCoordinacion"
                                                                    KeyFieldName="IdPersonaGerencia" Width="100%" OnBeforePerformDataSelect="gvDetalleCoordinacion_DataSelect"
                                                                    AutoGenerateColumns="false">
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="IdPersona" Caption="Id." ShowInCustomizationForm="True"
                                                                            VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Persona" Caption="Nombre Consultor" ShowInCustomizationForm="True"
                                                                            VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="IdentificacionPersona" Caption="Identificación Consultor"
                                                                            ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="10">
                                                                            <DataItemTemplate>
                                                                                <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eliminar.gif"
                                                                                    Cursor="pointer" ToolTip="Desvincular Consultor" OnInit="LinkDetalleCoordinacion_Init">
                                                                                    <ClientSideEvents Click="function(s, e) { DesvincularConsultor(this, {0}); }" />
                                                                                </dx:ASPxHyperLink>
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </DetailRow>
                                                        </Templates>
                                                    </dx:ASPxGridView>
                                                </DetailRow>
                                            </Templates>
                                        </dx:ASPxGridView>
                                    </div>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </div>
                    <div style="float: left; margin-left: 100px;">

                        <dx:ASPxPopupControl ID="pcCreacionGerencia" runat="server" ClientInstanceName="pcCreacionGerencia"
                            HeaderText="Creación de Gerencias" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                            AllowDragging="True" Modal="True" CloseAction="CloseButton">
                            <ClientSideEvents EndCallback="function(s, e) {
                             $('#divEncabezado').html(s.cpMensajeEdicion); 
                               }" />
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server" SupportsDisabledAttribute="True">
                                    <dx:ASPxFormLayout ID="flCreacionGerencia" runat="server">
                                        <Items>
                                            <dx:LayoutItem Caption="Nombre Gerencia:" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtNombreGerencia" runat="server" Width="250px" MaxLength="255"
                                                            NullText="Nombre gerencia...">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="" ValidationGroup="vgCrear">
                                                                <RequiredField ErrorText="El nombre de la gerencia es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activo:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer>
                                                        <dx:ASPxCheckBox ID="cbActivo" runat="server" CheckState="Checked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Gerente:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer>
                                                        <dx:ASPxComboBox ID="cmbGerente" runat="server" ClientInstanceName="cmbGerente" DropDownWidth="300px"
                                                            IncrementalFilteringMode="Contains" ValueField="IdTercero" ValueType="System.Int32"
                                                            Width="300px">
                                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                                ValidationGroup="vgCrear">
                                                                <RequiredField ErrorText="El Gerente de la Gerencia es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Coordinadores" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBoxList ID="cblCoordiandores" runat="server" ClientInstanceName="cblCoordiandores">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrear">
                                                                <RequiredField ErrorText="Se debe seleccionar al menos un Coordiandor" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxCheckBoxList>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                    <table>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnAdicionarGerencia" runat="server" Text="Adicionar" HorizontalAlign="Center"
                                                    ValidationGroup="vgCrear" AutoPostBack="false">
                                                    <Image Url="~/images/add.png">
                                                    </Image>
                                                    <ClientSideEvents Click="function(s, e) { RegistrarGerencia(); } " />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </div>
                    <dx:ASPxPopupControl ID="pcEdicionGerencia" runat="server" ClientInstanceName="pcEdicionGerencia"
                        HeaderText="Edición de Gerencia" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        AllowDragging="True" Modal="True" CloseAction="CloseButton">
                        <ClientSideEvents EndCallback="function(s, e) {
                            if(s.cpMensajeEdicion) { $('#divEncabezado').html(s.cpMensajeEdicion); }
                            cpRegistro.PerformCallback();
                        }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxFormLayout ID="flEdicionGerencia" runat="server">
                                    <Items>
                                        <dx:LayoutItem Caption="Id:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="txtEdicionIdGerencia" runat="server" ClientInstanceName="txtIdGerencia"
                                                        Width="50px" ClientEnabled="false">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre Gerencia:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="txtEdicionNombreGerencia" runat="server" Width="250px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgActualizar">
                                                            <RequiredField ErrorText="El nombre de la gerencia es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Activo:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxCheckBox ID="cbEdicionActivo" runat="server" CheckState="Unchecked">
                                                    </dx:ASPxCheckBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Adicionar Coordinadores:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <%--<dx:ASPxCheckBoxList ID="cblEdicionCoordinadores" runat="server" ClientInstanceName="cblEdicionCoordinadores">
                                                    </dx:ASPxCheckBoxList>--%>
                                                     <dx:ASPxGridLookup ID="cblEdicionCoordinadores" runat="server" KeyFieldName="idtercero" fie SelectionMode="Multiple"
                                                        IncrementalFilteringMode="StartsWith" TextFormatString="{0}" ClientInstanceName="cblEdicionCoordinadores"
                                                        MultiTextSeparator=", " AllowUserInput="false" Width="400px">
                                                        <ClientSideEvents ButtonClick="function(s,e) {cblEdicionCoordinadores.GetGridView().UnselectAllRowsOnPage(); cblEdicionCoordinadores.HideDropDown(); }" />
                                                        <Buttons>
                                                            <dx:EditButton Text="X">
                                                            </dx:EditButton>
                                                        </Buttons>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" Width="50px" />
                                                            <dx:GridViewDataTextColumn FieldName="tercero" Width="350px" />
                                                            <dx:GridViewDataTextColumn FieldName="idtercero" Visible="false" />
                                                        </Columns>
                                                        <GridViewProperties>
                                                            <SettingsBehavior AllowDragDrop="False" EnableRowHotTrack="True" />
                                                            <SettingsPager NumericButtonCount="5" PageSize="5" />
                                                        </GridViewProperties>
                                                    </dx:ASPxGridLookup>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnActualizar" runat="server" Text="Actualizar" HorizontalAlign="Center"
                                                ValidationGroup="vgActualizar" AutoPostBack="false">
                                                <Image Url="~/images/save_all.png">
                                                </Image>
                                                <ClientSideEvents Click="function(s, e) { ActualizarGerencia(txtIdGerencia.GetText()); } " />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <dx:ASPxPopupControl ID="pcEdicionCoordinacion" runat="server" ClientInstanceName="pcEdicionCoordinacion"
                        HeaderText="Edición de Coordinación" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        AllowDragging="True" Modal="True" CloseAction="CloseButton">
                        <ClientSideEvents EndCallback="function(s, e) {
                            if(s.cpMensajeEdicion) { $('#divEncabezado').html(s.cpMensajeEdicion); }
                            cpRegistro.PerformCallback();
                        }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxFormLayout ID="flEdicionCoordinacion" runat="server">
                                    <Items>
                                        <dx:LayoutItem Caption="Id:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                    <dx:ASPxTextBox ID="txtEdicionIdGerenciaCoordinador" runat="server" ClientInstanceName="txtEdicionIdGerenciaCoordinador"
                                                        Width="50px" ClientEnabled="false">
                                                    </dx:ASPxTextBox>
                                                    <dx:ASPxTextBox ID="txtEdicionIdCoordinador" runat="server" ClientInstanceName="txtEdicionIdCoordinador"
                                                        Width="50px" ClientEnabled="false">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Adicionar Consultores:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                    <dx:ASPxGridLookup ID="gluEdicionConsultores" runat="server" KeyFieldName="idtercero" SelectionMode="Multiple"
                                                        IncrementalFilteringMode="StartsWith" TextFormatString="{0}" ClientInstanceName="gluEdicionConsultores"
                                                        MultiTextSeparator=", " AllowUserInput="false" Width="400px">
                                                        <ClientSideEvents ButtonClick="function(s,e) {gluEdicionConsultores.GetGridView().UnselectAllRowsOnPage(); gluEdicionConsultores.HideDropDown(); }" />
                                                        <Buttons>
                                                            <dx:EditButton Text="X">
                                                            </dx:EditButton>
                                                        </Buttons>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" Width="50px" />
                                                            <dx:GridViewDataTextColumn FieldName="tercero" Width="350px" />
                                                            <dx:GridViewDataTextColumn FieldName="idtercero" Visible="false" />
                                                        </Columns>
                                                        <GridViewProperties>
                                                            <SettingsBehavior AllowDragDrop="False" EnableRowHotTrack="True" />
                                                            <SettingsPager NumericButtonCount="5" PageSize="5" />
                                                        </GridViewProperties>
                                                    </dx:ASPxGridLookup>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxButton ID="btnActualizaCoordinador" runat="server" Text="Actualizar" HorizontalAlign="Center"
                                                ValidationGroup="vgActualizarCoordinador" AutoPostBack="false">
                                                <Image Url="~/images/save_all.png">
                                                </Image>
                                                <ClientSideEvents Click="function(s, e) { ActualizarCoordinacion(txtEdicionIdCoordinador.GetText(), txtEdicionIdGerenciaCoordinador.GetText()); } " />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
