<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecibirOrdenDevolucion.aspx.vb" Inherits="BPColSysOP.RecibirOrdenDevolucion" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::Recibir Orden de Devolución::</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function cambiarLabel(sender) {
            if (sender.id == "rdbOrden")
                $("#pID").text("Orden")
            else
                $("#pID").text("Guía")
        }
        function ValidarTipoDatoOrden(source, arguments) {

            if ($get("txtID").value != "") {
                numerico = new RegExp("^[0-9]+$");
                if ($get("rdbOrden").checked)
                    arguments.IsValid = numerico.test($get("txtID").value)
            }
            else {
                arguments.IsValid = true;
            }
        }
        function EjecutarKeyPress(sender, e) {
            try {
                // look for window.event in case event isn't passed in
                if (window.event) { e = window.event; }
                if (e.keyCode == 13) {
                    var id = ""
                    if (sender.id == "txtID")
                        id = "btnBuscar";
                    else if (sender.id = "txtBorrarSerial")
                        id = "btnImprimir";
                    event.cancel = true;
                    event.returnValue = false;
                    document.getElementById(id).click()
                }
            } catch (e) {
                //   alert("Error al validar tecla. " & e.description);
            }

        }

    </script>
    </head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="True" EnableScriptGlobalization="True">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    </div>
    <div class="search" style="width:400px">
    <table class="tablaGris">
        <tr>
            <th colspan="2">
                Recepción de la Devolución</th>
        </tr>
        <tr>
            <td class="field">
                Busqueda por
            </td>
            <td>
                <asp:RadioButton ID="rdbOrden" onClick="javascript:cambiarLabel(this)" runat="server"
                    Text="Orden de Recolección" Checked="True" GroupName="buscar" />
                <asp:RadioButton ID="rdbGuia" onClick="javascript:cambiarLabel(this)" runat="server"
                    Text="Guia" GroupName="buscar" />
            &nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td class="field">
                Número de
                <p style="display: inline" id="pID">
                    Orden</p>
            </td>
            <td>
                <asp:TextBox ID="txtID" runat="server" MaxLength="20" ValidationGroup="buscar" onKeyDown="return EjecutarKeyPress(this,event);"></asp:TextBox>
                <div>
                    <asp:CustomValidator ID="CustomValidatorOrden" runat="server" ErrorMessage="El campo debe ser numérico para buscar por orden de recolección"
                        ClientValidationFunction="ValidarTipoDatoOrden" Display="Dynamic" 
                        ValidationGroup="buscar"></asp:CustomValidator>
                </div>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorID" runat="server" ControlToValidate="txtID"
                        Display="None" ErrorMessage="Debe proporcionar el  número de orden o guía" 
                        ValidationGroup="buscar"></asp:RequiredFieldValidator></div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <center>
                    <asp:Button ID="btnBuscar" CssClass="search" runat="server" Text="Buscar"  ForeColor="Blue" 
                        ValidationGroup="buscar" />
                </center>
            </td>
        </tr>
    </table>
    </div>
    <asp:Panel ID="pnlDevolucionManual" Width="500px" style="display:none"  CssClass="modalPopUp" runat="server">
        <div class="warning tablaGris">
            <ul>
                <li>&nbsp; No se encontró ninguna recolección ¿Desea crear la devolución completa?</li></ul>
            <center>
                <p>
                    <asp:LinkButton ID="lnkCrearDevolucionManual" runat="server" CssClass="search"><img alt="*" src="../images/new.png" />    &nbsp;Crear Devolución</asp:LinkButton>
                    &nbsp;
                    <asp:LinkButton ID="lnkSalirDevolucionManual" runat="server" CssClass="search"><img alt="*" src="../images/cancelar.png" />  &nbsp;Salir</asp:LinkButton>
                </p>
            </center>
        </div>
    </asp:Panel>
    <asp:HiddenField ID="HiddenFieldWarning" runat="server" />
    <cc1:ModalPopupExtender ID="HiddenFieldWarning_ModalPopupExtender" runat="server"
         Enabled="True" BackgroundCssClass="modalBackground" PopupControlID="pnlWarning"
        CancelControlID="lnkSalir" TargetControlID="HiddenFieldWarning">
    </cc1:ModalPopupExtender>
    <cc1:ModalPopupExtender ID="HiddenFieldWarning_DevMnual" runat="server" 
        Enabled="True" BackgroundCssClass="modalBackground" PopupControlID="pnlDevolucionManual"
        CancelControlID="lnkSalirDevolucionManual" TargetControlID="HiddenFieldWarning">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlWarning" Width="500px" style="display:none" CssClass="modalPopUp" runat="server">
        <div class="warning tablaGris">
            <ul>
                <li>&nbsp; No se encontró ninguna devolución asociada a la orden de recolección ¿Desea
                    crear la devolución?</li></ul>
            <center>
                <p>
                    <asp:LinkButton ID="lnkCrearDevolucion" runat="server" CssClass="search"><img alt="*" src="../images/new.png" />    &nbsp;Crear Devolución</asp:LinkButton>
                    &nbsp;
                    <asp:LinkButton ID="lnkSalir" runat="server" CssClass="search"><img alt="*" src="../images/cancelar.png" />  &nbsp;Salir</asp:LinkButton>
                </p>
            </center>
        </div>
    </asp:Panel>
<br />
<div class="search" style="width:400px">
    <table class="tablaGris"  >
        <tr>
            <th  colspan="2"><img style="float:left" alt="print" src="../images/print.png" />
                Reimpresión de Devolución</th>
        </tr>
        <tr>
            <td class="field">
                Numero de Recolección</td>
            <td>
                <asp:TextBox ID="txtIdRecoleccion" runat="server" MaxLength="5" 
                    onKeyDown="return EjecutarKeyPress(this,event);" ValidationGroup="imprimir" ></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtIdRecoleccion" 
                    ErrorMessage="&lt;br/&gt;El cambo es solo numérico" ValidationExpression="\d+" 
                    ValidationGroup="imprimir" Display="Dynamic"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorImprimir" runat="server" 
                    ControlToValidate="txtIdRecoleccion" 
                    ErrorMessage="&lt;br/&gt;Debe proporcionar el código de la recolección" 
                    ValidationGroup="imprimir" Display="Dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                   <center>
                    <asp:Button ID="btnImprimir" CssClass="search" runat="server" 
                           Text="Reimprimir Remisión"  ForeColor="Blue" 
                        ValidationGroup="imprimir" /></center>
            </td>
        </tr>
    </table>
</div>
    </form>
    </body>
</html>
