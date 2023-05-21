<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteSolicitadoRecogido.aspx.vb"
    Inherits="BPColSysOP.ReporteSolicitadoRecogido" %>

<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem" %>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte Solicitado Recoleccion </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />

    <script language="javascript" type="text/javascript">
        function mostrarImagen() {
            divImagen2.style.display = 'block';
        }

        function ocultarImagen() {
            divImagen2.style.display = 'none';
        }
        function validaciones() {
            try {
                divImagen.style.display = 'block'


                if (document.Form1.fechaInicial.value == "" && document.Form1.fechaFinal.value != "") {
                    document.getElementById("divImagen").style.display = "none";
                    alert("Escoja la Fecha Inicial (Desde), Por favor");
                    document.Form1.fechaInicial.focus();
                    return (false);
                }
                if (document.Form1.fechaFinal.value == "" && document.Form1.fechaInicial.value != "") {
                    document.getElementById("divImagen").style.display = "none";
                    alert("Escoja la Fecha Final (Hasta), Por favor");
                    document.Form1.fechaFinal.focus();
                    return (false);
                }

            }
            catch (e) {
                alert(e.message);
            }
        }
    
    </script>

</head>
<body class="cuerpo2">
    <form id="Form1" runat="server">
    <font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Reporte de Recolección
        de Productos en PDV</b></font>
    <hr />
    <table class="tabla" width="90%">
        <tr>
            <td>
                <asp:HyperLink ID="hlRegresar" runat="server" Font-Bold="true">Regresar</asp:HyperLink><br/>
                <br />
            </td>
        </tr>
        <tr>
            <td align="center">
                <anthem:Label ID="lblError" runat="server" AutoUpdateAfterCallBack="true" Font-Bold="true"
                    Font-Size="Small" ForeColor="Red" UpdateAfterCallBack="true"></anthem:Label>
            </td>
        </tr>
    </table>
    <table class="tabla">
        <tr>
            <td style="height: 16px" colspan="2">
                <div id="divImagen" style="display: none">
                    <img src="../images/loader_black.gif" alt="" /><font face="arial" size="2"><b> Generando
                        reporte, por favor espere...</b></font></div>
                <div id="divImagen2" style="display: none">
                    <img src="../images/loader_clock.gif" alt=""/><font face="arial" size="2"><b> Descargando reporte,
                        por favor espere...</b></font></div>
            </td>
        </tr>
    </table>
    <table class="tabla" bordercolor="#f0f0f0" cellspacing="1" cellpadding="1" border="1">
        <tr>
            <td style="height: 16px" bgcolor="#f0f0f0">
                <asp:Label ID="Label1" runat="server" Font-Bold="true" Font-Size="Small">Ciudad:</asp:Label>
            </td>
            <td style="height: 16px" colspan="1">
                <anthem:DropDownList ID="ddlCiudad" runat="server" EnabledDuringCallBack="False"
                    AutoCallBack="true">
                </anthem:DropDownList>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f0f0f0">
                <asp:Label ID="Label2" runat="server" Font-Bold="true" Font-Size="Small">Cadena:</asp:Label>
            </td>
            <td>
                <anthem:DropDownList ID="ddlCadena" runat="server" AutoUpdateAfterCallBack="true"
                    EnabledDuringCallBack="False" AutoCallBack="true">
                </anthem:DropDownList>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f0f0f0">
                <asp:Label ID="Label3" runat="server" Font-Bold="true" Font-Size="Small">Punto de Venta:</asp:Label>
            </td>
            <td>
                <anthem:DropDownList ID="ddlPOS" runat="server" AutoUpdateAfterCallBack="true">
                </anthem:DropDownList>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f0f0f0">
                <asp:Label ID="Label5" runat="server" Font-Bold="true" Font-Size="Small">Tipo de Fecha:</asp:Label>
            </td>
            <td>
                <asp:RadioButtonList ID="rblTipoFecha" runat="server" RepeatDirection="Horizontal"
                    Font-Size="Small">
                    <asp:ListItem Value="1" Selected="True">Fecha Creación</asp:ListItem>
                    <asp:ListItem Value="2">Fecha Recolección Transportadora</asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f0f0f0">
                <asp:Label ID="Label6" runat="server" Font-Bold="True" Font-Size="Small">Fecha:</asp:Label>
            </td>
            <td>
                <font size="2">Desde</font>
                <input class="textbox" id="fechaInicial" readonly="readonly" size="11" name="fechaInicial" runat="server" /><a
                    hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
                    href="javascript:void(0)"><img class="Popcaltrigger" height="22" alt="Seleccione una Fecha Inicial"
                        src="../include/HelloWorld/calbtn.gif" width="34" align="absMiddle" border="0"/></a>&nbsp;<font
                            color="#ff0000" size="2">*</font>&nbsp; <font size="2">Hasta</font>
                <input class="textbox" id="fechaFinal" readonly="readonly" size="11" name="fechaFinal" runat="server" /><a
                    hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
                    href="javascript:void(0)"><img class="Popcaltrigger" height="22" alt="Seleccione una Fecha Final"
                        src="../include/HelloWorld/calbtn.gif" width="34" align="absMiddle" border="0"/></a>&nbsp;<font
                            color="#ff0000" size="2">*</font>&nbsp;
            </td>
        </tr>
    </table>
    <table class="tabla">
        <tr>
            <td colspan="2">
                <font color="#ff0000" size="2">*</font><font size="2"> Se deben proporcionar los dos
                    valores</font>
                <br/>
                <br/>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="btnContinuar" runat="server" CssClass="boton" OnClientClick="return validaciones()"
                    Text="Consultar"></asp:Button>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <table class="tabla" width="100%" border="0">
        <tr>
            <td>
                <anthem:Label ID="lblRes" runat="server" AutoUpdateAfterCallBack="True" Font-Bold="True"
                    Font-Size="Small" ForeColor="Blue" UpdateAfterCallBack="True" Visible="False">Se genero correctamente el Reporte</anthem:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:LinkButton ID="lbnDescargar" runat="server" Text="&lt;img src='../images/Excel.gif' border='0'/&gt; Descargar Reporte en Excel"
                    Font-Bold="true" Font-Size="Small" ForeColor="#009933" Visible="False"></asp:LinkButton>
            </td>
        </tr>
    </table>
    </form>
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
</body>
</html>
