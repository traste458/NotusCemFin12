<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LiberarServicio.aspx.vb" Inherits="BPColSysOP.LiberarServicio" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::: Liberación Servicio ::: </title>
    <link rel="shortcut icon" href ="../images/baloons_small.png"/>
</head>
<body class ="cuerpo2">
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdServicio" runat ="server" ClientInstanceName ="hdServicio"></dx:ASPxHiddenField>
                    <dx:ASPxRoundPanel ID="rpInformacion" runat="server" Theme="SoftOrange" HeaderText="Información de Servicio">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxFormLayout ID="FlInformacion" runat="server" ColCount="2">
                                    <Items>
                                        <dx:LayoutItem Caption="Id. Servicio:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                    <dx:ASPxLabel ID="lblIdServicio" runat ="server" ClientInstanceName ="lblIdServicio" Font-Size ="Large" 
                                                        Font-Italic ="true"></dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Estado Actual:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                    <dx:ASPxLabel ID="lblEstado" runat ="server" ClientInstanceName ="lblEstado" Font-Size ="Large" 
                                                        Font-Italic ="true"></dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Cliente:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                    <dx:ASPxLabel ID="lblCliente" runat ="server" ClientInstanceName ="lblProceso"
                                                        Font-Italic ="true"></dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Tipo Servcio:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                    <dx:ASPxLabel ID="lblTipoServicio" runat ="server" ClientInstanceName ="lblTipoServicio"
                                                        Font-Italic ="true"></dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Eventos:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                    <dx:ASPxImage ID="imgCambio" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Cambio de Estado"
                                                            ClientInstanceName="imgCambio" Cursor="pointer">
                                                            <ClientSideEvents Click ="function (s,e){
                                                                if(ASPxClientEdit.ValidateGroup('VgCambio')){
                                                                    EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'LiberarServicio', 1);
                                                                }
                                                            }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Liberar."
                                                            CssClass="comentario" Width="180px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div> 
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Novedades:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                    <dx:ASPxImage ID="imgNov" runat="server" ImageUrl="../images/List.png" ToolTip="Ver Novedades" Cursor="pointer">
                                                        <ClientSideEvents Click="function (s, e){
                                                            CallbackvsShowPopup(pcNovedades,1,'verNovedades','0.6','0.6');
                                                        }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblNov" runat="server" Text="Adicionar Novedades."
                                                            CssClass="comentario" Width="180px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items> 
                                </dx:ASPxFormLayout> 
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <dx:ASPxPopupControl ID="pcNovedades" runat="server" ClientInstanceName="pcNovedades" ScrollBars ="Auto" 
                    HeaderText="Administrador Novedades" AllowDragging="true" Width="400px" Height="180px"
                    Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction ="CloseButton" Theme ="SoftOrange">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <dx:ASPxRoundPanel ID="rpNovedades" runat="server" HeaderText="Visualización y Registro Novedades" Theme="SoftOrange">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table>
                                                <tr>
                                                    <td class ="field" style ="text-align:left">
                                                        Tipo Novedad:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cmbNovedad" runat ="server" ClientInstanceName ="cmbNovedad" Width ="250" ValueType ="System.Int32"
                                                            IncrementalFilteringMode ="Contains">
                                                            <Columns>
                                                            <dx:ListBoxColumn FieldName ="descripcion" Width ="300px" Caption ="Novedad" />
                                                            </Columns>
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgNovedad">
                                                                <RequiredField ErrorText="La novedad es requerida" IsRequired="True" />
                                                            </ValidationSettings> 
                                                        </dx:ASPxComboBox> 
                                                        <div>
                                                            <dx:ASPxLabel ID="lbNovedad" runat="server" Text="Digite parte de la novedad."
                                                                CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </div> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class ="field" style ="text-align:left">
                                                        Comentario General:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxMemo ID="meJustificacion" runat="server" Height="71px" Width="350px" NullText="Ingrese el comentario..."
                                                            ClientInstanceName="memo" >
                                                            <ClientSideEvents KeyUp="function(s, e) {return SetMaxLength(memo,150); }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgNovedad">
                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                                <RequiredField ErrorText="El comentario es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxMemo>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxImage ID="imgNovedad" runat="server" ImageUrl="../images/DxAdd32.png" ToolTip="Agregar Serial"
                                                            Cursor ="pointer">
                                                            <ClientSideEvents Click="function (s, e){
                                                                if(ASPxClientEdit.ValidateGroup('vgNovedad')){
                                                                   pcNovedades.PerformCallback('Registra'); 
                                                                }
                                                            }" />
                                                        </dx:ASPxImage>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan ="4">
                                                        <dx:ASPxGridView ID="gvNovedad" runat="server" AutoGenerateColumns="false" ClientInstanceName="gvNovedad"
                                                            Theme="SoftOrange">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True" VisibleIndex="1"
                                                                    Caption="Tipo de Novedad">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="UsuarioRegistra" ShowInCustomizationForm="True"
                                                                    VisibleIndex="2" Caption="Registrada Por">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="FechaRegistro" ShowInCustomizationForm="True"
                                                                    VisibleIndex="3" Caption="Fecha de Registro">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True"
                                                                    VisibleIndex="4" Caption="Comentario General">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <SettingsPager PageSize="20">
                                                            </SettingsPager>
                                                        </dx:ASPxGridView>
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
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
