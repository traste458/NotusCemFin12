<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BloqueoSimCardCEM.aspx.vb"
    Inherits="BPColSysOP.BloqueoSimCardCEM" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Bloqueo Sim Card CEM</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function ProcesarEnter() {

            var btn = document.getElementById("lbBloqueo");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {

                DetenerEvento(event)
                btn.click();

            }

        }
        function validacion() {
            try {
                if (!confirm("¿Desea bloquear el ICCID: " + document.getElementById('txtIccid').value + " asociado al radicado : " + document.getElementById('txtRadicado').value + "?")) {
                    return (false);
                }
            } catch (e) {
                alert("Ocurrió un error al tratar de validar información.\n" + e.description);
                return (false);
            }
        }           
            
    </script>

    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            width: 1px;
        }
    </style>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server" onsubmit="return validacion();">
    <div>
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <asp:HiddenField ID="hidIdReg" runat="server" />
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="Encabezado" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="4" style="text-align: center" class="thGris">
                        MODULO DE BLOQUEO DE SERIALES
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        N&#250mero de ICCID:
                    </td>
                    <td>
                        <asp:TextBox ID="txtIccid" runat="server" Width="200px" MaxLength="17" TabIndex="1" onkeydown="ProcesarEnter(this);" ></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvIccid" runat="server" ErrorMessage="El Iccid es requerido"
                                Display="Dynamic" ControlToValidate="txtIccid" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revIccid" runat="server" ErrorMessage="El Iccid digitado no es valido"
                                Display="Dynamic" ControlToValidate="txtIccid" ValidationGroup="lecturaSerial"
                                ValidationExpression="[0-9]{17}"></asp:RegularExpressionValidator>
                        </div>
                </tr>
                <tr>
                    <td class="field" align="left">
                        N&#250mero de Radicado:
                    </td>
                    <td>
                        <asp:TextBox ID="txtRadicado" runat="server" Width="100px" MaxLength="7" TabIndex="2"  onkeydown="ProcesarEnter(this);" ></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvRadicado" runat="server" ErrorMessage="El n&#250mero de radicado es requerido"
                                Display="Dynamic" ControlToValidate="txtRadicado" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revRadicado" runat="server" ErrorMessage="El n&#250mero de radicado digitado no es valido"
                                Display="Dynamic" ControlToValidate="txtRadicado" ValidationGroup="lecturaSerial"
                                ValidationExpression="[0-9]{7}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="center">
                        <asp:LinkButton ID="lbBloqueo" runat="server" CssClass="submit" Font-Bold="True"
                            ValidationGroup="lecturaSerial" TabIndex="3">
                  <img alt="Descargar" src="../images/lock.png" /> Bloquear Serial
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        </eo:CallbackPanel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </div>
    </form>
</body>
</html>
