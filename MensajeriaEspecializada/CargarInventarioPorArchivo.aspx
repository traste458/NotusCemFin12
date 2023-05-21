<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargarInventarioPorArchivo.aspx.vb"
    Inherits="BPColSysOP.CargarInventarioPorArchivo" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cargar Inventario por Archivo</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script src="../include/animatedcollapse.js" type="text/javascript"></script>

    <link media="all" href="../include/widget02.css" type="text/css" rel="stylesheet">
    <link href="../include/style_ventana.css" type="text/css" rel="stylesheet">

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

        $(document).ready(function() {
            $("#VerEjemplo2").click(function() {
                if ($(this).text().trim() == "(Ver Ejemplo)") {
                    $("#imagen").slideDown();
                    $(this).text('(Ocultar Ejemplo)')
                } else {
                $("#imagen").slideUp();
                    $(this).text('(Ver Ejemplo)');
                }
            });
        });

        function ProcesarEnter() {

            var btn = document.getElementById("lbRegistrar");
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
        <table class="tablaGris" style="width: auto;">
        
            <asp:Panel ID="pnlRegistro" runat="server">
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
                        <asp:Button ID="btnSubir" runat="server" Text="Cargar" ValidationGroup="vgCargue"/>
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
                <img src="../images/save_all.png" alt="" />&nbsp;Cargar Inventario CEM</asp:LinkButton>
                </td>
                </tr>
                
            </asp:Panel>
            
            <asp:Panel ID="pnlRegistroZmma1" runat="server">
                <tr>
                    <td colspan="3" style="text-align: center" class="thGris">
                        INGRESE EL ARCHIVO QUE DESEA CARGAR
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Archivo ZMMA1:
                        <br />
                        <span class="listSearchTheme">Formatos de archivo aceptados: Texto (.txt)</span>
                    </td>
                    <td align="left">
                        <span class="field">
                            <asp:FileUpload ID="fuArchivo2" runat="server" />
                            <div>
                                <asp:RequiredFieldValidator ID="rfvArchivo2" runat="server" ErrorMessage="No ha seleccionado ningún archivo"
                                    Display="Dynamic" ControlToValidate="fuArchivo2" ValidationGroup="vgCargue2"></asp:RequiredFieldValidator>
                            </div>
                        </span>
                    </td>
                    <td>
                        <asp:Button ID="btnCargar" runat="server" Text="Cargar" ValidationGroup="vgCargue2" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a href="javascript:void(0);" id="VerEjemplo2"><font color="#0000ff">(Ver Ejemplo)</font></a>
                        <div id="imagen" style="display: none; -moz-background-clip: -moz-initial;
                            -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial"
                            name="imagen">
                            <img id="pedidos" src="../images/EjemploZMMA1_CEM.jpg" name="pedidos">
                        </div>
                    </td>
                </tr>
                
            </asp:Panel>
            
        </table>
        <asp:Panel ID="pnlErrores" runat="server" HorizontalAlign="Center">
            <table class="tablaGris">
                <tr>
                    <td style="text-align: center">
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
