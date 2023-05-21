﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BusquedaPedidos.aspx.vb" Inherits="BPColSysOP.BusquedaPedidosGenerales" %>


<%@ Register Assembly="DevExpress.Web.v18.1, Version=18.1.17.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Src="../ControlesDeUsuario/NotificationControl.ascx" TagName="NotificationControl" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../Estilos/estiloContenidos.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        function ActualizarEncabezado(s, e) {
            if (loadingPanel) { loadingPanel.Hide(); }
            if (s.cpMensaje) {
                if (document.getElementById('divEncabezado')) {
                    document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
                }
            }
        }

        function SetImageState(value) {
            var img = document.getElementById('imgButton');
            var imgSrc = value ? '../images/arrow-minimise20.png' : '../images/arrow-maximise20.png';
            img.src = imgSrc;
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid() && tbNumeroPedido.GetText() != '') {
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function LimpiaFormulario() {
            ASPxClientEdit.ClearEditorsInContainerById('form1');
        }


    </script>
    <style type="text/css">
        .comentario {
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        </div>
        <div>
            <br />
            <br />
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
                <ClientSideEvents EndCallback="function(s,e){  
                    ActualizarEncabezado(s,e); 
            }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxFormLayout ID="formLayout" runat="server" AlignItemCaptionsInAllGroups="True" Style="margin-bottom: 11px" Width="500px">
                            <Items>
                                <dx:LayoutGroup Caption="Busqueda de Pedido" Width="450px" GroupBoxDecoration="Box" ColCount="2">
                                    <Items>
                                        <dx:LayoutItem Caption="Tipo de Referencia" ColSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer SupportsDisabledAttribute="True">
                                                    <dx:ASPxRadioButtonList ID="rblReferencia" runat="server"
                                                        ValueField="ID" TextField="Name" RepeatColumns="4" RepeatLayout="Table" AutoPostBack="false" Caption="Choose language" Height="16px" SelectedIndex="3" Width="240px">
                                                        <Items>
                                                            <dx:ListEditItem Selected="True" Text="Pedido" Value="2" />
                                                            <dx:ListEditItem Text="Guia" Value="1" />
                                                        </Items>
                                                        <ValidationSettings ValidationGroup="RegistroInformacion" ErrorDisplayMode="ImageWithTooltip">
                                                            <RequiredField ErrorText="Información requerida" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxRadioButtonList>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Numero de Referencia" ColSpan="2">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                    <dx:ASPxTextBox ID="tbNumeroPedido" ClientInstanceName="tbNumeroPedido" runat="server" Width="240px" TabIndex="1" AutoPostBack="false" MaxLength="20">
                                                        <ValidationSettings ErrorDisplayMode="Text" ValidationGroup="ValidaPedido" ErrorTextPosition="Bottom" SetFocusOnError="True" Display="Dynamic">
                                                            <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                            <RequiredField ErrorText="Número de pedido requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" VerticalAlign="Middle" HorizontalAlign="Center">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                    <dx:ASPxImage ID="imgDetalle" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Consultar Pedido"
                                                        Cursor="pointer" ImageAlign="Middle" AutoPostBack="false">
                                                        <ClientSideEvents Click="function (s, e){
                                                                if(ASPxClientEdit.ValidateGroup('ValidaPedido')){
                                                                    EjecutarCallbackGeneral(s,e,'ConsultarPedido');
                                                                }
                                                            }" />
                                                        <BackgroundImage HorizontalPosition="center" />
                                                    </dx:ASPxImage>
                                                    <br />
                                                    <dx:ASPxLabel ID="lblDetalle" runat="server" CssClass="comentario" Font-Bold="False" Font-Italic="True" Font-Names="Arial" Font-Overline="False" Font-Size="XX-Small" Font-Strikeout="False" Text="Buscar" Width="100px">
                                                    </dx:ASPxLabel>

                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" HorizontalAlign="Center">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                    <dx:ASPxImage ID="imgActualiza" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Cancelar"
                                                        Cursor="pointer" ImageAlign="Middle">
                                                        <BorderRight BorderWidth="50px" />
                                                        <ClientSideEvents Click="function (s, e){
                                                                LimpiaFormulario();
                                                            }" />
                                                    </dx:ASPxImage>
                                                    <br />
                                                    <dx:ASPxLabel ID="lblConsultar" runat="server" CssClass="comentario" Font-Bold="False" Font-Italic="True" Font-Names="Arial" Font-Overline="False" Font-Size="XX-Small" Font-Strikeout="False" Text="Cancelar" Width="132px" Height="16px">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>
                            </Items>
                        </dx:ASPxFormLayout>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
        <br />
        <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
