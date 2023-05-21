<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmarRecoleccionServicioMensajeria.aspx.vb"
    Inherits="BPColSysOP.ConfirmarRecoleccionServicioMensajeria" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Confirmar Recolección - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ConfirmarRecoleccion(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgRecoleccion')) {
                cpGeneral.PerformCallback();
            }
        }

        function ControlFinalizacionCallBack(s, e) {
            if (s.cpMensaje) { $('#divEncabezado').html(s.cpMensaje); }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" 
        >
        <ClientSideEvents EndCallback="function(s, e) {
	        ControlFinalizacionCallBack(s, e);
        }"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent runat="server">
                <dx:ASPxRoundPanel ID="rpDatos" runat="server" HeaderText="Información de Servicio">
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <dx:ASPxFormLayout ID="flDatos" runat="server">
                                <Items>
                                    <dx:LayoutItem Caption="Tipo de Servicio:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxRadioButtonList ID="rblTipoServicio" runat="server">
                                                    <Items>
                                                        <dx:ListEditItem Text="Servicio Técnico" Value="5" />
                                                        <dx:ListEditItem Text="Siembra" Value="8" />
                                                    </Items>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRecoleccion">
                                                        <RequiredField IsRequired="True" ErrorText="El tipo de servicio es requerido"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxRadioButtonList>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Número Servicio / Orden Recolección:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtNumeroServicioOrden" runat="server" Width="150px" MaxLength="15">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRecoleccion">
                                                        <RequiredField IsRequired="True" ErrorText="El n&#250;mero de servicio / orden es requerido">
                                                        </RequiredField>
                                                        <RegularExpression ErrorText="Por favor ingrese valores num&#233;ricos" ValidationExpression="[0-9]{1,15}">
                                                        </RegularExpression>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Número Equipos Recogidos:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtNumEquiposRecogidos" runat="server" Width="150px" MaxLength="5">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRecoleccion">
                                                        <RequiredField IsRequired="True" ErrorText="El n&#250;mero de equipos recogidos es requerido">
                                                        </RequiredField>
                                                        <RegularExpression ErrorText="Por favor ingrese valores num&#233;ricos" ValidationExpression="[0-9]{1,5}">
                                                        </RegularExpression>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Layout Item" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnConfirmarRecoleccion" runat="server" Text="Confirmar Recolección"
                                                    ValidationGroup="vgRecoleccion" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s, e) { ConfirmarRecoleccion(s, e); }"></ClientSideEvents>
                                                    <Image Url="~/images/package.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
