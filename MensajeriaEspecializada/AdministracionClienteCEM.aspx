<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionClienteCEM.aspx.vb" Inherits="BPColSysOP.AdministracionClienteCEM" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Administración Clientes CEM ::: </title>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat ="server" ClientInstanceName="cpGeneral" EnabledAnimation ="true" 
            >
            <ClientSideEvents EndCallback ="function (s, e){
                LoadingPanel.Hide();
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpFiltros" runat ="server" HeaderText ="Filtros de Búsqueda" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td class ="field" style="text-align:left">
                                            Nombre:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID ="txtNombre" runat ="server" ClientInstanceName ="txtNombre" Nulltext ="Digite parte del nombre..."
                                                Width ="250px" Maxlength ="50" TabIndex ="1">
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:left">
                                            Centro:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID ="txtCentro" runat ="server" ClientInstanceName ="txtCentro" Nulltext ="Centro..."
                                                Width ="100px" Maxlength ="10" TabIndex ="2">
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:left">
                                            Almacén:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID ="txtAlmacen" runat ="server" ClientInstanceName ="txtAlmacen" Nulltext ="Almacén..."
                                                Width ="100px" Maxlength ="10" TabIndex ="3">
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" style="text-align:left">
                                            Activo:
                                        </td>
                                        <td>
                                            <dx:ASPxCheckBox ID="cbFiltro" runat="server" Checked ="true" TabIndex ="4"></dx:ASPxCheckBox>
                                            <div>
                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Activo S/N."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                        <td colspan ="4" style="text-align:center">
                                            <dx:ASPxImage ID ="imgBuscar" runat ="server" ToolTip ="Buscar" Cursor ="pointer" ImageUrl="~/images/DxConfirm32.png"  >
                                                <ClientSideEvents Click ="function (s, e){
                                                    EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'busquedaClientes',1);
                                                }" /> 
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="imgCancela" runat ="server" ToolTip ="Borrar Filtros" Cursor ="pointer"  ImageUrl ="~/images/DxCancel32.png">
                                                <ClientSideEvents Click ="function(s, e){
                                                    LimpiaFormulario('formPrincipal');
                                                }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="imgNuevo" runat ="server" ToolTip ="Crear Cliente" Cursor ="pointer"  ImageUrl ="~/images/DxAdd32.png">
                                                <ClientSideEvents Click ="function(s, e){
                                                    CallbackvsShowPopup(pcCrear,1,'crearCliente','0.6','0.3');
                                                }" />
                                            </dx:ASPxImage>
                                        </td>
                                    </tr>
                                </table> 
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel> 
                    <br/>
                    <table>
                        <tr>
                            <td style="text-align:center">
                                <dx:ASPxGridView ID ="gvDatos" runat ="server" ClientInstanceName ="gvDatos" AutoGenerateColumns ="false" 
                                    KeyFieldName ="IdAlmacenBodega" Theme ="SoftOrange" Width ="100%">
                                    <Columns>
                                        <dx:GridViewDataTextColumn VisibleIndex ="1" Caption ="Nombre" FieldName ="Descripcion" ShowInCustomizationForm ="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex ="2" Caption ="Centro" FieldName ="Centro" ShowInCustomizationForm ="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn VisibleIndex ="3" Caption ="Almacén" FieldName ="Almacen" ShowInCustomizationForm ="true">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataCheckColumn VisibleIndex="4" Caption="Activo" FieldName="Activo" ShowInCustomizationForm="true">
                                        </dx:GridViewDataCheckColumn>
                                        <dx:GridViewDataColumn VisibleIndex ="5" Caption ="Opciones">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID ="lnkEditar" runat ="server" ImageUrl="~/images/DxEdit.png" Cursor ="pointer"
                                                    ToolTip ="Editar" OnInit ="Link_Init">
                                                    <ClientSideEvents Click ="function(s, e){
                                                        CallbackvsShowPopup(pcModificaCliente,{0},'verCliente','0.5','0.3');
                                                    }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns> 
                                    <Settings ShowHeaderFilterButton="True"></Settings>
                                    <SettingsPager PageSize="20">
			                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
		                            </SettingsPager>
                                    <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                    <SettingsText Title="B&#250;squeda General" 
                                        EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda">
                                    </SettingsText>
                                </dx:ASPxGridView>
                            </td>
                        </tr>
                    </table>
                    <dx:ASPxPopupControl ID="pcModificaCliente" runat="server" ClientInstanceName="pcModificaCliente" CloseAction ="CloseButton"
                        HeaderText="Modificar Cliente" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td class ="field" style="text-align:left">
                                            Nombre:
                                            <dx:ASPxLabel ID ="lblIdCliente" runat ="server" ClientInstanceName ="lblIdCliente" ClientVisible ="false" ></dx:ASPxLabel>
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID ="txtEditNombre" runat ="server" ClientInstanceName ="txtEditNombre" With ="250px"
                                                MaxLength ="100">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:center">
                                            Centro:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtEditCentro" runat ="server" ClientInstanceName ="txtEditCentro" Width="50px"  MaxLength ="10">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[0-9]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:right">
                                            Almacén:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtEditAlmacen" runat ="server" ClientInstanceName ="txtEditAlmacen" Width="50px" MaxLength ="10">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[0-9]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" style="text-align:left" >
                                            Estado:
                                        </td>
                                        <td>
                                            <dx:ASPxCheckBox ID="cbEdit" runat="server" Checked ="true" ></dx:ASPxCheckBox>
                                            <div>
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Activo S/N."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                        <td colspan ="4" style ="text-align:left">
                                            <dx:ASPxImage ID="imgEdit" runat ="server" ToolTip ="Editar" Cursor ="pointer" ImageUrl ="~/images/DxConfirm32.png">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup(&#39;vgEdita&#39;)){
                                                        pcModificaCliente.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'editarClientes',lblIdCliente.GetText());
                                                        //cpGeneral.PerformCallback('editarClientes' + ':' + lblIdCliente.GetText());
                                                    } 
                                                }" /> 
                                            </dx:ASPxImage>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl> 
                    <dx:ASPxPopupControl ID="pcCrear" runat="server" ClientInstanceName="pcCrear" CloseAction ="CloseButton"
                        HeaderText="Crear Cliente" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td class ="field" style="text-align:left">
                                            Seleccione Bodega:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID ="cmbBodega" runat ="server" ClientInstanceName ="cmbBodega" Width ="250px" 
                                                IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="IdBodega">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName ="IdBodega" Caption ="Id" Width ="10px" />
                                                    <dx:ListBoxColumn FieldName ="Nombre" Caption ="Nombre" Width ="300px" />
                                                </Columns>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td class ="field" style="text-align:left" >
                                            Seleccione Cliente:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID ="cmbCliente" runat ="server" ClientInstanceName ="cmbCliente" Width ="250px" 
                                                IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="IdClienteCem">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName ="IdClienteCem" Caption ="Id" Width ="10px" />
                                                    <dx:ListBoxColumn FieldName ="Nombre" Caption ="Nombre" Width ="250px" />
                                                </Columns>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" style="text-align:left">
                                            Centro:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtCreaCentro" runat ="server" ClientInstanceName ="txtCreaCentro" Width ="150px" NullText ="Ingrese Centro.." MaxLength ="10">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[0-9]+\s*$"/>
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class ="field" style="text-align:left">
                                            Almacén:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtCreaAlmacen" runat ="server" ClientInstanceName ="txtCreaAlmacen" Width ="150px" NullText ="Ingrese Almacén.." MaxLength ="10">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[0-9]+\s*$"/>
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class ="field" style ="text-align:left">
                                            Nombre:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtCreaNombre" runat ="server" ClientInstanceName ="txtCreaNombre" Width ="250px" NullText ="Ingrese Descripción.." MaxLength ="100">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td colspan ="2" style ="text-align:center">
                                            <dx:ASPxImage ID ="imgCrear" runat ="server" ToolTip ="Crear" Cursor ="pointer" ImageUrl="~/images/DxConfirm32.png">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup(&#39;vgCrea&#39;)){
                                                        pcCrear.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'crearClientes',1);
                                                    } 
                                                }" /> 
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="imgCancelar" runat ="server" ToolTip ="Cancelar" Cursor ="pointer"  ImageUrl ="~/images/DxCancel32.png">
                                                <ClientSideEvents Click ="function(s, e){
                                                    pcCrear.Hide();
                                                }" />
                                            </dx:ASPxImage>
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
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet"/>
    <script src="../include/jquery-1.min.js" type="text/javascript"></script> 
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script> 
</body>
</html>
