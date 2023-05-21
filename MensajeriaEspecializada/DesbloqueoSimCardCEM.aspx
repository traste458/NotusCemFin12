<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DesbloqueoSimCardCEM.aspx.vb" 
Inherits="BPColSysOP.DesbloqueoSimCardCEM" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Desbloqueo Sim Card CEM</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function ProcesarEnter() {

            var btn = document.getElementById("lbFiltros");
            var kCode = (event.keyCode ? event.keyCode : event.which);

            if (kCode.toString() == "13") {

                DetenerEvento(event)
                btn.click();

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
    <form id="form1" runat="server">
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
                        MODULO DE DESBLOQUEO DE SERIALES
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
                        </td> 
                </tr>
                <tr>
                    <td colspan="4" align="center">
                    <br />
                    <asp:LinkButton ID="lbFiltros" runat="server" CssClass="submit" Font-Bold="True" TabIndex="3" ValidationGroup="lecturaSerial">
                  <img alt="Descargar" src="../images/filtro.png" /> Filtrar </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="submit" Font-Bold="True" TabIndex="4">
                  <img alt="Descargar" src="../images/cancelar.png" /> Quitar Filtros </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbBloqueo" runat="server" CssClass="submit" Font-Bold="True"
                             TabIndex="5">
                  <img alt="Descargar" src="../images/unlock.png" /> Desbloquear Serial
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        </eo:CallbackPanel>
        <eo:CallbackPanel ID="cpdatosReporte" runat="server" UpdateMode="always" >
        <table class="tablaGris">
            <tr>
                <td>
                    <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
                        <div style="text-align: center;">
                            <b>Resultado de la busqueda</b>
                            <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                EmptyDataText="No hay resultados" HeaderStyle-HorizontalAlign="Center" PageSize="50"
                                ShowFooter="True">
                                <PagerSettings Mode="NumericFirstLast" />
                                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                                <AlternatingRowStyle CssClass="alterColor" />
                                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                <Columns>
                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                    <asp:BoundField DataField="numeroRadicado" HeaderText="Número Radicado" />
                                    <asp:BoundField DataField="fechaBloqueo" HeaderText="Fecha Bloqueo" />
                                    <asp:BoundField DataField="UsuarioBloqueo" HeaderText="Usuario" />
                                </Columns>
                            </asp:GridView>
                        </div>
                        <br />
                        <br />
                        </asp:Panel>
           
                </td>
           </tr>
        </table> 
        </eo:CallbackPanel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </div>
    </form>
</body>
</html>

