<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargarInventarioPorLectura.aspx.vb"
    Inherits="BPColSysOP.CargarInventarioPorLectura" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cargar Inventario por Lectura</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script src="../include/animatedcollapse.js" type="text/javascript"></script>

    <link media="all" href="../include/widget02.css" type="text/css" rel="stylesheet"/>
    <link href="../include/style_ventana.css" type="text/css" rel="stylesheet"/>

    <script language="javascript" src="../include/jscript_ventana.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">

        $(document).ready(function() {
            $("#VerEjemplo").click(function() {
                if ($(this).text().trim() == "(Ver archivo Ejemplo)") {
                    $("#imagenEjemplo").slideDown();
                    $(this).text('(Ocultar Ejemplo)')
                } else {
                    $("#imagenEjemplo").slideUp();
                    $(this).text('(Ver archivo Ejemplo)');
                }
            });
        });

        function ProcesarEnter() {

            var btn = document.getElementById("btnRegistrar");
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
        <asp:Panel ID="Encabezado" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="4" style="text-align: center" class="thGris">
                        MODULO DE RECEPCIÓN DE SERIALES
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Numero de entrega:
                    </td>
                    <td>
                        <asp:TextBox ID="txtEntrega" runat="server" Width="100px" MaxLength="10"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvNumeroEntrega" runat="server" ErrorMessage="El valor del número de entrega es requerido"
                                Display="Dynamic" ControlToValidate="txtEntrega" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revNumeroEntrega" runat="server" ErrorMessage="El número de entrega no es valido"
                                Display="Dynamic" ControlToValidate="txtEntrega" ValidationGroup="lecturaSerial"
                                ValidationExpression="[0-9]{8,10}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        Cantidad a leer:
                    </td>
                    <td>
                        <asp:Label ID="lblLectura" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Cantidad a Leer:
                    </td>
                    <td>
                        <asp:TextBox ID="txtCantidad" runat="server" Width="100px" MaxLength="10"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ErrorMessage="La cantidad es requerida"
                                Display="Dynamic" ControlToValidate="txtCantidad" ValidationGroup="lecturaSerial"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revCantidad" runat="server" ErrorMessage="El número digitado no es valido"
                                Display="Dynamic" ControlToValidate="txtCantidad" ValidationGroup="lecturaSerial"
                                ValidationExpression="[0-9]{1,10}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        Cantidad Leida:
                    </td>
                    <td>
                        <asp:Label ID="lblCantidad" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:LinkButton ID="lbDescargar" runat="server" CssClass="submit" Font-Bold="True">
                  <img alt="Descargar" src="../images/Excel.gif" /> Descargar seriales leidos
                        </asp:LinkButton>
                    </td>
                    <td>
                        <asp:LinkButton ID="lbCrear" runat="server" CssClass="submit" Font-Bold="True" ValidationGroup="lecturaSerial">
                                <img alt="Leer Serial" src="../images/encontrar_small.png" />Crear orden
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <br />
        <asp:Panel ID="pnlLectura" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="4" style="text-align: center" class="thGris">
                        MODULO DE LECTURA DE SERIALES
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Ingrese el serial:
                    </td>
                    <td>
                        <asp:TextBox ID="txtSerial" runat="server" onkeydown="ProcesarEnter(this);" Width="200px"
                            MaxLength="17"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvSerial" runat="server" ErrorMessage="El serial es requerido"
                                Display="Dynamic" ControlToValidate="txtSerial" ValidationGroup="lectura"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revIccid" runat="server" ErrorMessage="El serial digitado no es válido"
                                Display="Dynamic" ControlToValidate="txtSerial" ValidationGroup="lectura"
                                ValidationExpression="[0-9]{15,17}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field" align="left">
                        Ultimo Serial Leido:
                    </td>
                    <td>
                        <asp:Label ID="lblSerial" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:LinkButton ID="btnRegistrar" runat="server" CssClass="submit" Font-Bold="True"
                            ValidationGroup="lectura">
                                <img alt="Leer Serial" src="../images/pageNext.gif" />Leer serial
                        </asp:LinkButton>
                        &nbsp;&nbsp;
                        <asp:LinkButton ID="lbCerrar" runat="server" CssClass="submit" Font-Bold="True">
                                <img alt="Cerrar Inventario" src="../images/save_all.png" />Cerrar Inventario
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlRegistro" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="3" style="text-align: center" class="thGris">
                        INGRESE EL ARCHIVO QUE DESEA CARGAR
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Archivo ZMMAK:
                        <br />
                        <span class="listSearchTheme">Formatos de archivo aceptados: Texto (.txt)</span>
                    </td>
                    <td align="left">
                        <span class="field">
                            <asp:FileUpload ID="fuArchivo" runat="server" />
                            <div>
                                <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="No ha seleccionado ningún archivo"
                                    Display="Dynamic" ControlToValidate="fuArchivo" ValidationGroup="vgCargue"></asp:RequiredFieldValidator>
                            </div>
                        </span>
                    </td>
                    <td>
                        <asp:Button ID="btnSubir" runat="server" Text="Cargar" ValidationGroup="vgCargue" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a href="javascript:void(0);" id="VerEjemplo"><font color="#0000ff">(Ver archivo Ejemplo)</font></a>
                        <div id="imagenEjemplo" style="display: none; -moz-background-clip: -moz-initial;
                            -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial"
                            name="imagenEjemplo">
                            <img id="seriales" src="../images/EjemploZMMAK_CEM.jpg" name="seriales">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:LinkButton ID="lbGuardar" CssClass="submit" runat="server">
                <img src="../images/save_all.png" alt="" />&nbsp;Cargar Inventario</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlErrores" runat="server" HorizontalAlign="Center">
            <table class="tablaGris">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <br />
                        <b>Log De Resultados</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <asp:GridView ID="gvErrores" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="No hay errores " HeaderStyle-HorizontalAlign="Center"
                            PageSize="20" AutoGenerateColumns="true">
                            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                            <PagerStyle CssClass="pagerChildDG" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>
    </form>
</body>
</html>
