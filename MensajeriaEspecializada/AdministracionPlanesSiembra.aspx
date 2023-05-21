<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionPlanesSiembra.aspx.vb" Inherits="BPColSysOP.AdministracionPlanesSiembra" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Administración Planes Siembra ::: </title>
</head>
<body class ="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
        <dx:ASPxCallbackPanel ID ="cpGeneral" runat ="server" ClientInstanceName ="cpGeneral" EnableAnimation="true"  
            >
            <ClientSideEvents EndCallback ="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
           <PanelCollection>
               <dx:PanelContent>
                   <dx:ASPxPageControl id="pcAdministracion" runat ="server" ActiveTabIndex ="0" Width ="70%">
                       <TabPages>
                           <dx:TabPage Text ="Planes">
                               <TabImage Url="../images/structure.png"></TabImage>
                               <ContentCollection>
                                   <dx:ContentControl runat ="server">
                                       <dx:ASPxRoundPanel ID="rpPlanes" runat ="server" HeaderText ="Administración Planes" Theme ="SoftOrange">
                                           <PanelCollection>
                                               <dx:PanelContent>
                                                    <table>
                                                       <tr>
                                                           <td class ="field" style="text-align:left">
                                                               Nombre Plan:
                                                           </td>
                                                           <td>
                                                               <dx:ASPxTextBox ID ="txtNombre" runat ="server" ClientInstanceName ="txtNombre" NullText ="Digite Nombre ..." 
                                                                    Width ="250px" TabIndex ="1">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                                        <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                        <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                                    </ValidationSettings> 
                                                                </dx:ASPxTextBox>
                                                           </td>
                                                           <td class ="field" style="text-align:left">
                                                               Tipo Plan:
                                                           </td>
                                                           <td>
                                                               <dx:ASPxComboBox ID="cmbTipoPlan" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                                    ClientInstanceName="cmbTipoPlan" DropDownStyle="DropDownList" ValueField="IdTipo"
                                                                    TabIndex="2">
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="idTipo" Width="50px" Caption="Id" />
                                                                        <dx:ListBoxColumn FieldName="nombre" Width="170px" Caption="Nombre" />
                                                                    </Columns>
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                                        <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                                    </ValidationSettings> 
                                                                </dx:ASPxComboBox>
                                                           </td>
                                                       </tr>
                                                       <tr>
                                                           <td class ="field" style="text-align:left">
                                                               Descripción:
                                                           </td>
                                                           <td>
                                                               <dx:ASPxMemo ID="meDescripcion" runat="server" Width="250px" NullText="Observación..."
                                                                    ClientInstanceName="mePedidos" Rows ="2" TabIndex="3">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistro">
                                                                        <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxMemo>
                                                           </td>
                                                           <td>
                                                               <dx:ASPxCheckBox ID="cbFiltroPlan" runat="server" Checked ="true">
                                                                   <ClientSideEvents CheckedChanged ="function(s,e){
                                                                       EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'buscarPlan',1);
                                                                       }" />
                                                                </dx:ASPxCheckBox>
                                                                <div>
                                                                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Búsqueda Activo S/N."
                                                                        CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                        Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                    </dx:ASPxLabel>
                                                                </div>
                                                           </td>
                                                           <td style="text-align:center">
                                                               <dx:ASPxImage ID="imgRegistra" runat ="server" Cursor ="pointer" ImageUrl ="~/images/DxAdd32.png" 
                                                                   TabIndex ="4" ToolTip ="Crear Plan">
                                                                   <ClientSideEvents Click ="function (s, e) {
                                                                       if(ASPxClientEdit.ValidateGroup(&#39;vgRegistro&#39;)){
                                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'registrarPlan',1);
                                                                       }
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
                                               <td style ="text-align:center">
                                                   <dx:ASPxGridView ID ="gvPlanes" runat ="server" ClientInstanceName ="gvPlanes" AutoGenerateColumns ="false"
                                                       Theme ="SoftOrange" KeyFieldName ="IdPlan" Width ="100%">
                                                       <Columns>
                                                            <dx:GridViewDataTextColumn VisibleIndex ="1" Caption ="Id" FieldName ="IdPlan" ShowInCustomizationForm ="true">
                                                               </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataTextColumn VisibleIndex ="2" Caption ="Nombre" FieldName ="NombrePlan" ShowInCustomizationForm ="true">
                                                               </dx:GridViewDataTextColumn> 
                                                               <dx:GridViewDataTextColumn VisibleIndex ="3" Caption ="Tipo De Plan" FieldName ="NombreTipoPlan" ShowInCustomizationForm ="true">
                                                               </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn VisibleIndex ="4" Caption ="Descripción" FieldName ="Descripcion" ShowInCustomizationForm ="true">
                                                               </dx:GridViewDataTextColumn>
                                                               <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="5">
                                                                   <DataItemTemplate>
                                                                       <dx:ASPxHyperLink ID ="lnkEditar" runat ="server" ImageUrl="~/images/DxEdit.png" Cursor ="pointer"
                                                                            ToolTip ="Editar" OnInit ="Link_Init">
                                                                            <ClientSideEvents Click ="function(s, e){
                                                                                CallbackvsShowPopup(pcModificaPlan,{0},'plan','0.6','0.3');
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
                                                        <SettingsText Title="B&#250;squeda General Planes" 
                                                            EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda">
                                                        </SettingsText>
                                                   </dx:ASPxGridView>
                                               </td>
                                           </tr>
                                       </table>
                                   </dx:ContentControl>
                               </ContentCollection>
                           </dx:TabPage>
                           <dx:TabPage Text ="Paquetes">
                               <TabImage Url="../images/documents_stack.png"></TabImage>
                               <ContentCollection>
                                   <dx:ContentControl>
                                        <dx:ASPxRoundPanel ID="rpPaquetes" runat ="server" HeaderText ="Administración Paquetes" Theme ="SoftOrange">
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <table>
                                                        <tr>
                                                            <td class ="field" style="text-align:left">
                                                                Nombre Paquete:
                                                            </td>
                                                            <td>
                                                                <dx:ASPxTextBox ID ="txtPaquete" runat ="server" ClientInstanceName ="txtPaquete" NullText ="Nombre Paquete..."
                                                                    Width ="250px">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistroPaq">
                                                                        <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                        <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                                    </ValidationSettings> 
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                            <td class ="field" style="text-align:left">
                                                               Descripción:
                                                           </td>
                                                           <td>
                                                               <dx:ASPxMemo ID="mePaquete" runat="server" Width="250px" NullText="Observación..."
                                                                    ClientInstanceName="mePaquete" Rows ="2" TabIndex="3">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistroPaq">
                                                                        <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxMemo>
                                                           </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="cbFiltroPaquete" runat="server" Checked ="true">
                                                                   <ClientSideEvents CheckedChanged ="function(s,e){
                                                                       EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'buscarPaquete',1);
                                                                       }" />
                                                                </dx:ASPxCheckBox>
                                                                <div>
                                                                    <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="Búsqueda Activo S/N."
                                                                        CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                        Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                    </dx:ASPxLabel>
                                                                </div>
                                                            </td>
                                                            <td colspan ="3" style="text-align:center">
                                                                <dx:ASPxImage ID ="imgAgrega" runat ="server" Cursor ="pointer" ImageUrl ="~/images/DxAdd32.png">
                                                                    <ClientSideEvents Click ="function (s, e){
                                                                        if(ASPxClientEdit.ValidateGroup(&#39;vgRegistroPaq&#39;)){
                                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'registrarPaquete',1);
                                                                       }
                                                                    }" />
                                                                </dx:ASPxImage>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table>
                                                        <tr>
                                                           <td style ="text-align:center" colspan ="4">
                                                               <dx:ASPxGridView ID ="gvPaquetes" runat ="server" ClientInstanceName ="gvPaquetes" AutoGenerateColumns ="false"
                                                                   Theme ="SoftOrange" KeyFieldName ="IdPaquete" Width ="100%">
                                                                   <Columns>
                                                                        <dx:GridViewDataTextColumn VisibleIndex ="1" Caption ="Id" FieldName ="IdPaquete" ShowInCustomizationForm ="true">
                                                                           </dx:GridViewDataTextColumn>
                                                                           <dx:GridViewDataTextColumn VisibleIndex ="2" Caption ="Nombre" FieldName ="Nombre" ShowInCustomizationForm ="true">
                                                                           </dx:GridViewDataTextColumn> 
                                                                           <dx:GridViewDataTextColumn VisibleIndex ="3" Caption ="Observacion" FieldName ="Observacion" ShowInCustomizationForm ="true">
                                                                           </dx:GridViewDataTextColumn>
                                                                           <dx:GridViewDataColumn Caption ="Opciones" VisibleIndex ="4">
                                                                               <DataItemTemplate>
                                                                                   <dx:ASPxHyperLink ID ="lnkEditar" runat ="server" ImageUrl="~/images/DxEdit.png" Cursor ="pointer"
                                                                                        ToolTip ="Editar" OnInit ="Link_Init">
                                                                                        <ClientSideEvents Click ="function(s, e){
                                                                                            CallbackvsShowPopup(pcModificaPaquete,{0},'paquete','0.6','0.3');
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
                                                                    <SettingsText Title="B&#250;squeda General Paquetes" 
                                                                        EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda">
                                                                    </SettingsText>
                                                               </dx:ASPxGridView>
                                                           </td>
                                                       </tr>
                                                    </table>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxRoundPanel>
                                   </dx:ContentControl>
                               </ContentCollection>
                           </dx:TabPage>
                       </TabPages>
                   </dx:ASPxPageControl>
                   <dx:ASPxPopupControl ID="pcModificaPlan" runat="server" ClientInstanceName="pcModificaPlan" CloseAction ="CloseButton"
                        HeaderText="Modificar Plan" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                       <ContentCollection>
                           <dx:PopupControlContentControl>
                               <table>
                                   <tr>
                                       <td class ="field" style="text-align:center">
                                           Nombre Plan:
                                           <dx:ASPxLabel ID ="lblIdPlan" runat ="server" ClientInstanceName ="lblIdPlan" ClientVisible ="false" ></dx:ASPxLabel>
                                       </td>
                                       <td>
                                           <dx:ASPxTextBox ID="txtEditNombre" runat ="server" ClientInstanceName="txtEditNombre" Width ="250px">
                                               <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                           </dx:ASPxTextBox>
                                       </td>
                                       <td class ="field" style ="text-align:center">
                                           Tipo Plan:
                                       </td>
                                       <td>
                                           <dx:ASPxComboBox ID="cmbEditTipoPlan" runat="server" Width ="250px">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                            </dx:ASPxComboBox>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td class ="field" style="text-align:center" >
                                           Descripción:
                                       </td>
                                       <td>
                                           <dx:ASPxMemo ID="meEditPlan" runat="server" Width="250px" NullText="Observación..."
                                                ClientInstanceName="meEditPlan" Rows ="2">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEdita">
                                                    <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                </ValidationSettings>
                                            </dx:ASPxMemo>
                                        </td>
                                       <td>
                                           <dx:ASPxCheckBox ID="cbActivo" runat="server">
                                            </dx:ASPxCheckBox>
                                            <div>
                                                <dx:ASPxLabel ID="lblComentario" runat="server" Text="Activo S/N."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                       </td>
                                       <td>
                                           <dx:ASPxImage ID="imgEdita" runat ="server" ClientInstanceName ="imgEdita" ImageUrl="~/images/DxConfirm32.png"
                                               ToolTip ="Editar Plan" Cursor ="pointer">
                                               <ClientSideEvents Click ="function (s, e){
                                                   if(ASPxClientEdit.ValidateGroup(&#39;vgEdita&#39;)){
                                                   pcModificaPlan.Hide();
                                                    EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'editarPlan',lblIdPlan.GetText());
                                                    }
                                                }" />
                                           </dx:ASPxImage>
                                       </td>
                                   </tr>
                               </table>
                           </dx:PopupControlContentControl>
                       </ContentCollection>
                    </dx:ASPxPopupControl> 
                   <dx:ASPxPopupControl ID="pcModificaPaquete" runat="server" ClientInstanceName="pcModificaPaquete" CloseAction ="CloseButton"
                        HeaderText="Modificar Plan" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                       <ContentCollection>
                           <dx:PopupControlContentControl>
                               <table>
                                   <tr>
                                       <td class ="field" style="text-align:center">
                                           Nombre Paquete:
                                           <dx:ASPxLabel ID ="lblIdPaquete" runat ="server" ClientInstanceName ="lblIdPaquete" ClientVisible ="false" ></dx:ASPxLabel>
                                       </td>
                                       <td>
                                           <dx:ASPxTextBox ID="txtEditPaquete" runat ="server" ClientInstanceName="txtEditPaquete" Width ="250px">
                                               <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditaPaq">
                                                    <RegularExpression ErrorText ="Datos Incorrectos" ValidationExpression ="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                    <RequiredField ErrorText ="Información Requerida" IsRequired ="true" />
                                                </ValidationSettings> 
                                           </dx:ASPxTextBox>
                                       </td>
                                       <td class ="field" style="text-align:center">
                                           Descripción:
                                       </td>
                                       <td>
                                           <dx:ASPxMemo ID="meEditPaquete" runat="server" Width="250px" NullText="Observación..."
                                                ClientInstanceName="meEditPaquete" Rows ="2">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditaPaq">
                                                    <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                </ValidationSettings>
                                            </dx:ASPxMemo>
                                       </td>
                                   </tr>
                                   <tr>
                                       <td>
                                           <dx:ASPxCheckBox ID="cbActivoPaq" runat="server">
                                            </dx:ASPxCheckBox>
                                            <div>
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Activo S/N."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                       </td>
                                       <td colspan ="3" style="text-align:center">
                                           <dx:ASPxImage ID="imgEditPaquete" runat ="server" ImageUrl="~/images/DxConfirm32.png"
                                               Cursor ="pointer" ToolTip ="Editar Paquete">
                                               <ClientSideEvents Click ="function(s, e){
                                                   if(ASPxClientEdit.ValidateGroup(&#39;vgEdita&#39;)){
                                                    pcModificaPaquete.Hide();
                                                    EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'editarPaquete',lblIdPaquete.GetText());
                                                    }
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
