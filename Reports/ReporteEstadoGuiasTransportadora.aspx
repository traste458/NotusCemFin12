<%@ Register TagPrefix="anthem" Namespace="Anthem" Assembly="Anthem" %>

<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteEstadoGuiasTransportadora.aspx.vb"
    Inherits="BPColSysOP.ReporteEstadoGuiasTransportadora" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>Reporte de Estados de Guias por Transportadora</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <link href="../include/style_ventana.css" type="text/css" rel="stylesheet" />

    <script language="javascript" src="../include/jscript_ventana.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function verNovedades(guia) {
            try {
                Anthem_InvokePageMethod('getNovedades', [guia]);
                var ancho, alto;
                ancho = document.getElementById("divNovedades").offsetWidth;
                alto = document.getElementById("divNovedades").offsetHeight;
                mostrarVentana(720, 320, document.getElementById("divNovedades"))
            } catch (e) {
                alert(e.description);
            }
        }
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }
        function validacion() {
            try {
                var forma = document.Form1;
                if (forma.txtGuia.value.trim() == "" && forma.flFileUploader.value.trim() == "" && forma.txtCuenta.value.trim() == "" && forma.fechaInicial.value == "" && forma.fechaFinal.value == "") {
                    document.getElementById("divImagen").style.display = "none";
                    alert("Debe escoger por lo menos un filtro de búsqueda.");
                    forma.txtGuia.focus();
                    return (false);
                }
                var expReg = /^[0-9a-zA-Z\-]+$/
                if (forma.txtCuenta.value.trim() != "") {
                    if (!expReg.test(forma.txtCuenta.value.trim())) {
                        document.getElementById("divImagen").style.display = "none";
                        alert("El campo Cuenta contiene caracteres no válidos. Por favor verifique");
                        return (false);
                    }

                    if (forma.fechaInicial.value == "" || forma.fechaFinal.value == "") {
                        document.getElementById("divImagen").style.display = "none";
                        alert("Cuando se proporciona un número de Cuenta es necesario especificar un rango de Fechas.\nEscoja el rango de fecha que desea consultar para la cuenta escogida, Por favor");
                        return (false);
                    }
                }

                if (forma.fechaInicial.value == "" && forma.fechaFinal.value != "") {
                    document.getElementById("divImagen").style.display = "none";
                    alert("Escoja una Fecha Inicial (Desde), Por favor");
                    return (false);
                }

                if (forma.fechaInicial.value != "" && forma.fechaFinal.value == "") {
                    document.getElementById("divImagen").style.display = "none";
                    alert("Escoja una Fecha Final (Hasta), Por favor");
                    return (false);
                }

                if (forma.flFileUploader.value.trim() != "" && forma.flFileUploader.value.indexOf(".txt") == -1) {
                    document.getElementById("divImagen").style.display = "none";
                    alert("El archivo seleccionado no es un archivo de Texto.\nSe espera un archivo con extensión .txt. Por favor verifique.");
                    document.Form1.flFileUploader.focus();
                    return (false);
                }
            } catch (e) {
                document.getElementById("divImagen").style.display = "none";
                alert("Error al tratar de validar filtros.\n" + e.description);
                return (false);
            }
        }
          
    </script>

</head>
<body class="cuerpo2" onscroll="if(document.getElementById('divContenedorVentana').style.visibility == 'visible'){javascript:centrarVentana(document.getElementById('divVentana'))};"
    onload="javascript:crearAreaMostrado();carga()">
    <form id="Form1" method="post" runat="server">
    <font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Reporte de Estados
        de Guías de Transportadora</b></font>
    <hr />
    <br />
    <div>
        <asp:HyperLink ID="hlRegresar" runat="server">Regresar</asp:HyperLink>
    </div>
    <br />
    <table class="tabla" width="90%">
        <tr>
            <td align="center">
                <anthem:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="Red" Font-Size="X-Small"
                    AutoUpdateAfterCallBack="True"></anthem:Label>
            </td>
        </tr>
    </table>
    <ul class="tabla">
        <asp:Label ID="lblLeyenda" Font-Bold="True" ForeColor="Gray" Font-Size="X-Small"
            Font-Italic="True" Font-Name="Arial" runat="server">Se debe proporcionar por lo menos un filtro de búsqueda</asp:Label></ul>
    <div id="divImagen" style="display: none">
        <img src="../images/loader_black.gif"><font face="arial" size="2" /><b> Generando reporte,
            por favor espere...</b></font></div>
    <table class="tabla" bordercolor="#f0f0f0" border="1">
        <tr>
            <td class="tdEncabezadoAR" colspan="2">
                <asp:Label ID="Label1" runat="server" Font-Bold="True">FILTROS DE BUSQUEDA</asp:Label>
            </td>
        </tr>
        <tr>
            <td class="tdTituloAR">
                <asp:Label ID="Label2" runat="server" Font-Bold="True">Guía:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtGuia" runat="server" CssClass="textbox"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdTituloAR">
                <asp:Label ID="Label3" runat="server" Font-Bold="True">Archivo de Guías:</asp:Label>
            </td>
            <td>
                <input class="file" id="flFileUploader" type="file" size="56" name="flFileUploader"
                    runat="server" />
            </td>
        </tr>
        <tr>
            <td class="tdTituloAR">
                <asp:Label ID="Label5" runat="server" Font-Bold="True">No. de Cuenta:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtCuenta" runat="server" CssClass="textbox"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tdTituloAR">
                <asp:Label ID="Label4" runat="server" Font-Bold="True">Fecha de Creación:</asp:Label>
            </td>
            <td>
                Desde
                <input class="textbox" id="fechaInicial" readonly size="11" name="fechaInicial" runat="server" /><a
                    hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
                    href="javascript:void(0)"><img class="PopcalTrigger" height="22" alt="Fecha Inicial"
                        src="../include/HelloWorld/calbtn.gif" width="34" align="absMiddle" border="0"></a><font
                            color="#ff0000" size="2">**</font>&nbsp; Hasta
                <input class="textbox" id="fechaFinal" readonly size="11" name="fechaFinal" runat="server" /><a
                    hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.Form1.fechaInicial,document.Form1.fechaFinal);return false;"
                    href="javascript:void(0)"><img class="PopcalTrigger" height="22" alt="Fecha Final"
                        src="../include/HelloWorld/calbtn.gif" width="34" align="absMiddle" border="0"></a><font
                            color="#ff0000" size="2">**</font>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <font color="#ff0000" size="2">**</font>&nbsp;Se debe especificar los dos valores
                <br />
                <br />
                <asp:Button ID="btnBuscar" runat="server" CssClass="botonAR" Text="Generar Reporte"
                    OnClientClick="return validacion();"></asp:Button>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <anthem:Panel ID="pnlResultado" runat="server" AutoUpdateAfterCallBack="True" AddCallBacks="False">
        <table class="tabla">
            <tr>
                <td>
                    <asp:LinkButton ID="lbExportar" runat="server" ForeColor="Green" Font-Bold="True"><img src="../images/excel.gif" border="0" alt="" />&nbsp;Exportar Resultado a Excel</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td>
                    <anthem:DataGrid ID="dgGuias" runat="server" AutoUpdateAfterCallBack="True" CssClass="tabla"
                        GridLines="Horizontal" AutoGenerateColumns="False" ShowFooter="True" CellPadding="3"
                        BackColor="White" BorderWidth="1px" BorderStyle="None" BorderColor="#E7E7FF"
                        AllowPaging="True" PageSize="30">
                        <PagerStyle Font-Size="X-Small" Font-Bold="True" HorizontalAlign="Right" ForeColor="#4A3C8C"
                            BackColor="#E7E7FF" Mode="NumericPages"></PagerStyle>
                        <AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
                        <FooterStyle Font-Size="X-Small" Font-Bold="True" ForeColor="#4A3C8C" BackColor="#B5C7DE">
                        </FooterStyle>
                        <SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
                        <ItemStyle ForeColor="#4A3C8C" BackColor="#E7E7FF"></ItemStyle>
                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center" ForeColor="#F7F7F7" BackColor="#4A3C8C">
                        </HeaderStyle>
                        <Columns>
                            <asp:BoundColumn DataField="guia" HeaderText="Gu&#237;a"></asp:BoundColumn>
                            <asp:BoundColumn DataField="estado_actual" HeaderText="Estado Actual"></asp:BoundColumn>
                            <asp:BoundColumn DataField="numero_cuenta" HeaderText="N&#250;mero de Cuenta"></asp:BoundColumn>
                            <asp:BoundColumn DataField="fec_produccion" HeaderText="Fecha de Producci&#243;n">
                            </asp:BoundColumn>
                            <asp:BoundColumn DataField="ciudad_origen" HeaderText="Ciudad Origen"></asp:BoundColumn>
                            <asp:BoundColumn DataField="ciudad_destino" HeaderText="Ciudad Destino"></asp:BoundColumn>
                            <asp:BoundColumn DataField="nombre_destinatario" HeaderText="Destinatario"></asp:BoundColumn>
                            <asp:BoundColumn DataField="direccion_destinatario" HeaderText="Direcci&#243;n Destinatario">
                            </asp:BoundColumn>
                            <asp:BoundColumn DataField="num_unidades" HeaderText="N&#250;mero de Unidades"></asp:BoundColumn>
                            <asp:BoundColumn DataField="valor_declarado" HeaderText="Valor Declarado"></asp:BoundColumn>
                            <asp:BoundColumn DataField="numero_documento" HeaderText="N&#250;mero de Documento">
                            </asp:BoundColumn>
                            <asp:BoundColumn DataField="notas" HeaderText="Notas"></asp:BoundColumn>
                            <asp:BoundColumn DataField="fec_entrega" HeaderText="Fecha de Entrega"></asp:BoundColumn>
                            <asp:BoundColumn DataField="hora" HeaderText="Hora de Entrega"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderText="Novedades">
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlVerNovedades" runat="server" ToolTip="Ver Novedades" ImageUrl="../images/view_large.png"
                                        Visible="False">Ver Novedades</asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                    </anthem:DataGrid>
                </td>
            </tr>
        </table>
    </anthem:Panel>
    <div id="divNovedades" style="visibility: hidden; overflow: auto; width: 700px; height: 300px;
        text-align: center" align="center" runat="server">
        <table class="table" width="100%" align="center">
            <tr>
                <td align="center">
                    <anthem:Label ID="lblErrorNovedades" runat="server" Font-Bold="True" ForeColor="Red"
                        Font-Size="X-Small" AutoUpdateAfterCallBack="True"></anthem:Label>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <anthem:DataGrid ID="dgNovedades" runat="server" AutoUpdateAfterCallBack="True" CssClass="tabla"
                        GridLines="Horizontal" AutoGenerateColumns="False" ShowFooter="True" CellPadding="3"
                        BackColor="White" BorderWidth="1px" BorderStyle="None" BorderColor="#E7E7FF"
                        AllowPaging="True" Width="660px">
                        <PagerStyle Font-Size="X-Small" Font-Bold="True" HorizontalAlign="Right" ForeColor="#4A3C8C"
                            BackColor="#E7E7FF" Mode="NumericPages"></PagerStyle>
                        <AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
                        <FooterStyle Font-Size="X-Small" Font-Bold="True" ForeColor="#4A3C8C" BackColor="#B5C7DE">
                        </FooterStyle>
                        <SelectedItemStyle Font-Bold="True" ForeColor="#F7F7F7" BackColor="#738A9C"></SelectedItemStyle>
                        <ItemStyle ForeColor="#4A3C8C" BackColor="#E7E7FF"></ItemStyle>
                        <HeaderStyle Font-Bold="True" HorizontalAlign="Center" ForeColor="#F7F7F7" BackColor="#4A3C8C">
                        </HeaderStyle>
                        <Columns>
                            <asp:BoundColumn DataField="guia" HeaderText="Gu&#237;a"></asp:BoundColumn>
                            <asp:BoundColumn DataField="des_novedad" HeaderText="Descripci&#243;n"></asp:BoundColumn>
                            <asp:BoundColumn DataField="fec_novedad" HeaderText="Fecha"></asp:BoundColumn>
                            <asp:BoundColumn DataField="aclaracion" HeaderText="Aclaraci&#243;n"></asp:BoundColumn>
                        </Columns>
                    </anthem:DataGrid>
                </td>
            </tr>
        </table>
    </div>
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>
