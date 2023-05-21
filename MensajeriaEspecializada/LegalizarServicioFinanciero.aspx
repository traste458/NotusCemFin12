<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalizarServicioFinanciero.aspx.vb" Inherits="BPColSysOP.LegalizarServicioFinanciero" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script language="javascript" type="text/javascript">
        function validaSeleccionLegalizacion() {
            var strMensaje = "";
            var txtObservacion = document.getElementById("txtLegaliza").value;
            if (txtObservacion.length == 0) {
                strMensaje += "La observación de legalización es obligatoria.\n";
            }

            if (strMensaje.length == 0) {
                return true;
            } else {
                alert(strMensaje);
                return false;
            }
        }


    </script>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <asp:Panel ID="Panel1" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                <table align="center" class="tabla">
                    <tr>
                        <td class="field">Observación:
                        </td>
                        <td>
                            <asp:TextBox ID="txtLegaliza" runat="server" Rows="6" Width="300px"
                                TextMode="MultiLine"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <br />
                            <br />
                            <asp:LinkButton ID="lbLegaliza" runat="server" CssClass="search" ValidationGroup="legalizarServicio"
                                OnClientClick="return validaSeleccionLegalizacion()">
                                    <img src="../images/Open.png" alt=""/>&nbsp;Legalizar Servicio
                            </asp:LinkButton>
                            <dx:ASPxHyperLink ID="lbAbortarModificacion1" runat="server" ImageUrl="~/images/arrow-turn.gif" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                <ClientSideEvents Click="function(s, e){
                                                           window.history.back();                                                  
                                                }" />
                            </dx:ASPxHyperLink>
                            <asp:HiddenField ID="hflegalizaIdServicio" runat="server" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

        </div>
    </form>
</body>
</html>
