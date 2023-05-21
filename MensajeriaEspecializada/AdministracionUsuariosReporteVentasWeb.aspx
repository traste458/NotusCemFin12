<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionUsuariosReporteVentasWeb.aspx.vb" Inherits="BPColSysOP.AdministracionUsuariosReporteVentasWeb" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
    
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Administración Usuarios Reporte WEB ::: </title>
</head>
<body class ="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback ="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="Administrador Usuarios Reporte Ventas WEB" Width="70%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                    ClientInstanceName="gvDatos" KeyFieldName="IdClienteCem" Theme ="SoftOrange">
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="Id" ShowInCustomizationForm="True"
                                            VisibleIndex="0" FieldName="IdClienteCem">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Nombre Cadena" ShowInCustomizationForm="True"
                                            VisibleIndex="1" FieldName="Nombre">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataCheckColumn VisibleIndex="2" Caption="Activo" FieldName="Estado" 
                                            ShowInCustomizationForm="true">
                                        </dx:GridViewDataCheckColumn>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="3" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID="lnkAgregar" runat ="server" ImageUrl="~/images/DxAdd16.png" Cursor ="pointer" 
                                                    ToolTip ="Agregar Usuarios" OnInit="Link_Init">
                                                    <ClientSideEvents Click ="function(s, e){
                                                        CallbackvsShowPopup(pcCofigurar,{0},'configurarUsuario','0.5','0.8');
                                                    }" />
                                                </dx:ASPxHyperLink> 
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn> 
                                    </Columns>
                                    <Settings ShowHeaderFilterButton="True"></Settings>
                                    <Settings VerticalScrollableHeight="300"/>
                                    <SettingsPager PageSize="20">
			                            <PageSizeItemSettings Visible="true" ShowAllItem="true" />
		                            </SettingsPager>
                                    <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                    <SettingsText Title="B&#250;squeda General Cadenas" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                </dx:ASPxGridView> 
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel> 
                    <dx:ASPxPopupControl ID="pcCofigurar" runat="server" ClientInstanceName="pcCofigurar" CloseAction ="CloseButton"
                        HeaderText="Administración de Usuario" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars ="Auto">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxLabel ID="lbIdCliente" runat ="server" ClientInstanceName ="lbIdCliente" ClientVisible ="false" ></dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dx:ASPxListBox ID="lbUsuarios" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                ValueField="IdUsuario" Height="400px" ClientInstanceName="lbUsuarios">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Nombre" Caption="Usuario" Width="300px" />
                                                    <dx:ListBoxColumn FieldName="NombrePerfil" Caption="Perfil" Width="250px" />
                                                </Columns>
                                            </dx:ASPxListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center">
                                            <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Agregar Usuario" Cursor ="pointer">
                                                <ClientSideEvents Click ="function (s, e){
                                                    if (lbUsuarios.GetSelectedValues().length==0){
                                                        alert('No ha seleccionado ningún valor de la lista.');
                                                    } else {
                                                        pcCofigurar.Hide();
                                                        EjecutarCallbackGeneral(LoadingPanel,cpGeneral,'adcionarUsuario',lbIdCliente.GetText() + ':' + lbUsuarios.GetSelectedValues());
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
