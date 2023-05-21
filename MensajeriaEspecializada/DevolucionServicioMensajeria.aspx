<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DevolucionServicioMensajeria.aspx.vb"
    Inherits="BPColSysOP.DevolucionServicioMensajeria" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Devolución Servicio Mensajeria</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ProcesarEnter() {
            var btn = document.getElementById("lbRegistrar");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {

                DetenerEvento(event)
                btn.click();
            }
        }

        function verSucursal(obj) {
            valores = ['382', '383', '384']
            //valores = ['173', '174', '175'] //Demo
            if (valores.indexOf(obj.value) >= 0) {
                document.getElementById("tdSucursal").style.display = 'table-row'
            } else {
                document.getElementById("tdSucursal").style.display = 'none'
            }
        }
    </script>
</head>

<body class="cuerpo2" onload="GetWindowSize('hfMedidasVentana');">
    <form id="form1" runat="server">
        <%--<div>--%>
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Group" Width="100%" groupname="general" childrenastriggers="true">
            <asp:HiddenField ID="hidIdReg" runat="server" />
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
            <asp:HiddenField ID="hfMedidasVentana" runat="server" />
        </eo:CallbackPanel>
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            LoadingDialogID="ldrWait_dlgWait" UpdateMode="Group" groupname="general">
            <table width="50%" class="tablaGris">
                <asp:Panel ID="pnlRegistro" runat="server">
                    <tr>
                        <td colspan="4" style="text-align: center" class="thGris">INGRESE LOS DATOS DE LA DEVOLUCIÓN
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">Número Radicado
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtNumeroRadicado" runat="server" TabIndex="1" MaxLength="15" onkeydown="ProcesarEnter();"></asp:TextBox>
                            <div>
                                <asp:RequiredFieldValidator ID="rfvNumeroRadicado" runat="server" ErrorMessage="Numero de radicado Requerido"
                                    Display="Dynamic" ControlToValidate="txtNumeroRadicado" ValidationGroup="vgDevolucion"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                    ControlToValidate="txtNumeroRadicado" ValidationGroup="vgDevolucion" ErrorMessage="El número del radicado digitado no es válido, por favor verifique"
                                    ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                        <td class="field" align="left">Tipo:
                        </td>
                        <td>
                            <asp:RadioButtonList ID="rblTipoBusqueda" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Radicado" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Servicio" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">Ruta:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtRuta" runat="server" TabIndex="1" onkeydown="ProcesarEnter();"></asp:TextBox>
                            <div>
                                <asp:RegularExpressionValidator ID="revRuta" runat="server" Display="Dynamic"
                                    ControlToValidate="txtRuta" ValidationGroup="vgDevolucion" ErrorMessage="El número de ruta digitado no es válido, por favor verifique"
                                    ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                        <td class="field" align="left">Novedad:
                        </td>
                        <td align="left">
                            <asp:DropDownList ID="ddlNovedad" runat="server" onchange="verSucursal(this)">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="tdSucursal" style="display: none">
                        <td class="field">Sucursal
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlSucursal" runat="server" ValidationGroup="registroNovedad">
                            </asp:DropDownList>
                            <div style="display: block;">
                                <asp:RequiredFieldValidator ID="rfvSucursal" runat="server" ErrorMessage="Seleccione una sucursal"
                                    Display="Dynamic" ControlToValidate="ddlSucursal" ValidationGroup="registroNovedad2"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <br />
                            <asp:LinkButton ID="lbRegistrar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgDevolucion">
                    <img alt="Registrar Devolucion" src="../images/DxAdd16.png" />Registrar </asp:LinkButton>
                        </td>
                        <td colspan="2" align="left">
                            <br />
                            <asp:LinkButton ID="lbNovedad" runat="server" CssClass="search" Font-Bold="True">
                    <img alt="Registrar Novedad" src="../images/comment_add.png" />Novedad </asp:LinkButton>
                        </td>
                    </tr>
                </asp:Panel>
            </table>
        </eo:CallbackPanel>

        <eo:Callbackpanel id="cpVerInformacion" runat="server" loadingdialogid="ldrWait_dlgWait"
            updatemode="Group" groupname="general">
            <eo:Dialog runat="server" ID="dlgVerInformacionServicio" ControlSkinID="None" Height="400px" HeaderHtml="Adicionar Novedad al Servicio"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                <contenttemplate>
                </contenttemplate>
                <footerstyleactive csstext="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </footerstyleactive>
                <headerstyleactive csstext="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </headerstyleactive>
                <contentstyleactive csstext="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </contentstyleactive>
                <borderimages bottomborder="00020305" rightborder="00020307" toprightcornerbottom="00020308"
                    toprightcorner="00020309" leftborder="00020303" topleftcorner="00020301" bottomrightcorner="00020306"
                    topleftcornerbottom="00020302" bottomleftcorner="00020304" topborder="00020310">
                </borderimages>
            </eo:Dialog>
        </eo:Callbackpanel>

        <uc2:Loader ID="ldrWait" runat="server" />

    </form>
</body>

</html>
