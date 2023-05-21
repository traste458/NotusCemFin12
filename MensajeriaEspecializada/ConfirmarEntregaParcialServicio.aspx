<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmarEntregaParcialServicio.aspx.vb" Inherits="BPColSysOP.ConfirmarEntregaParcialServicio" %>


<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recepción Seriales Devolución - Mesnajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }

        function ProcesarEnter(boton) {
            var btn = document.getElementById(boton);
            var kCode = (event.keyCode ? event.keyCode : event.which);
            if (kCode.toString() == "13") {
                MostrarOcultarDivFloater(true);
                DetenerEvento(event)
                btn.click();
            }
        }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
                var tgId = callback.getEventTarget();
                if (tgId == "btnRecibir") {
                    var txt = document.getElementById("txtSerial");
                    if (txt) {
                        if (!txt.disabled) { txt.select(); }
                    }
                }
            } catch (e) {
                alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }
        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        </eo:CallbackPanel>
        
        <asp:Panel ID="pnlGeneral" runat="server">
            <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" ClientSideAfterUpdate="CallbackAfterUpdateHandler">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%" valign="top">
                        <asp:Panel ID="pnlLectura" runat="server">
                            <table>
                                <tr>
                                    <th colspan="2">
                                        LECTURA DE SERIALES
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">Tipo de Novedad:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlNovedad" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Observación:</td>
                                    <td>
                                        <asp:TextBox ID="txtObservacion" runat="server" MaxLength="1024" Rows="5" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Número de Radicado:</td>
                                    <td>
                                        <asp:TextBox ID="txtNumRadicado" runat="server" Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Serial:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSerial" runat="server" onkeydown="ProcesarEnter('btnRecibir');"
                                            Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator id="rfvddlNovedad" runat="server" ValidationGroup="lecturaSerial"
                                                ControlToValidate="ddlNovedad" Display="Dynamic" ErrorMessage="Seleccione un tipo de novedad <br />" InitialValue="0">
                                            </asp:RequiredFieldValidator>
                                        
                                            <asp:RequiredFieldValidator ID="rfvtxtObservacion" runat="server" ValidationGroup="lecturaSerial"
                                                ControlToValidate="txtObservacion" Display="Dynamic" ErrorMessage="Ingrese una Observación de la novedad <br />">
                                            </asp:RequiredFieldValidator>
                                        
                                            <asp:RequiredFieldValidator ID="rfvtxtNumRadicado" runat="server" ValidationGroup="lecturaSerial"
                                                ControlToValidate="txtNumRadicado" Display="Dynamic" ErrorMessage="Digite el número del Radicado <br />">
                                            </asp:RequiredFieldValidator>
                                        
                                            <asp:RequiredFieldValidator ID="rfvSerial" runat="server" ErrorMessage="Digite el serial a registrar por favor <br />"
                                                Display="Dynamic" ValidationGroup="lecturaSerial" 
                                                ControlToValidate="txtSerial"></asp:RequiredFieldValidator>
                                                
                                            <asp:RegularExpressionValidator ID="revSerial" runat="server" ErrorMessage="El serial digitado no es válido <br />"
                                                Display="Dynamic" ControlToValidate="txtSerial" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9]{15,17}"></asp:RegularExpressionValidator>
                                        </div>
                                        <br />
                                        <asp:LinkButton ID="btnRecibir" runat="server" Text="Recibir" CssClass="search" 
                                            ValidationGroup="lecturaSerial">
                                            <img alt="Registrar Entrega Parcial" src="../images/save_all.png" />&nbsp;Registrar 
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                            <div id="divFloater" style="display: none; position: static; height: 35px; width: 200px;">
                                <table align="center">
                                    <tr>
                                        <td align="center" valign="middle" style="height: 100%">
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                                            <b>Procesando...</b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                        <br />
                    </td>
                </tr>
            </table>
        </eo:CallbackPanel>
        </asp:Panel>
    </form>
</body>
</html>
