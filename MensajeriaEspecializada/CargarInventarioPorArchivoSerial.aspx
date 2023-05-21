<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargarInventarioPorArchivoSerial.aspx.vb" 
Inherits="BPColSysOP.CargarInventarioPorArchivoSerial" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Cargar Inventario por Archivo</title>
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
            height: 21px;
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
        <asp:Panel ID="pnlRegistro" runat="server">
        <table class="tablaGris" style="width: auto;">
        <tr>
        <td colspan="3" style="text-align: center" class="thGris">
                        INGRESE EL ARCHIVO QUE DESEA CARGAR
         </td>
        </tr>
        <tr>
                    <td class="field" align="left">
                        Seleccione archivo de seriales:
                        <br />
                        <span class="listSearchTheme">Formatos de archivo aceptados: Texto (.txt)</span>
                    </td>
                    <td align="left" class="field">
                            <asp:FileUpload ID="fuArchivo" runat="server" />
                            <div>
                                <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="No ha seleccionado ningún archivo"
                                    Display="Dynamic" ControlToValidate="fuArchivo" ValidationGroup="vgCargue"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revArchivo" runat="server" ErrorMessage="Tipo de archivo incorrecto. Se espera un archivo de texto con extensión .TXT"
                                Display="Dynamic" ControlToValidate="fuArchivo" ValidationGroup="vgCargue" ValidationExpression=".+(\.[T|t][X|x][T|t])"></asp:RegularExpressionValidator>
                            </div>
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
                            <img id="seriales" src="../images/EjemploPlano_CEM.jpg" name="seriales" alt=""/>
                        </div>
                    </td>
                    </tr>
                    
        </table> 
        </asp:Panel>
        <br />
        
        <div style="width: 50%;">
            <blockquote><b>NOTA: </b> El formato del archivo debe contener: <i>Serial </i> <i> Material </i> <i>Centro</i> <i> Almacén</i>, separado por tabulación. 
            </blockquote>
        </div>
        
        <br />
        <asp:Panel ID="pnlErrores" runat="server" HorizontalAlign="Center">
            <table class="tablaGris">
                <tr>
                    <td colspan="2" style="text-align: center" class="style1">
                        <br />
                        <b>Log De Resultados</b>
                    </td>
                </tr> 
                <tr>
                    <td>
                        
                        <asp:GridView ID="gvErrores" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="No hay errores " HeaderStyle-HorizontalAlign="Center"
                            PageSize="200" AutoGenerateColumns="true" AllowPaging="true">
                            <PagerSettings Mode="NumericFirstLast" />
                            <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
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



