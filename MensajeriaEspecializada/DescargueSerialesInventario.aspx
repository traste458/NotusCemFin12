<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DescargueSerialesInventario.aspx.vb" Inherits="BPColSysOP.DescargueSerialesInventario" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Descargue de Seriales - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">
    
        function ValidarArchivo(source, args) {
            var cadenaArchivo = $("#fuArchivo").val();
            var mensaje = "";
            if (cadenaArchivo != "") {
                cadenaArchivo = cadenaArchivo.toLowerCase();
                
                if (/[a-zA-Z0-9.(.)](.txt)$/.test(cadenaArchivo)) {
                    args.IsValid = true;
                } else {
                    args.IsValid = false;
                    mensaje = "Por favor verifique el archivo sea de texto (.txt).";
                }
            } else {
                args.IsValid = false;
                mensaje = "Por favor especifique el archivo a cargar.";
            }
            source.innerHTML = mensaje;
        }

        function ValidaNumero(e) {
            var tecla= document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
        
        $(document).ready(function(){
            $("#VerEjemplo").click(function(event){
                if($("#imagenEjemplo").attr("style")=="display: none;"){
                    $("#VerEjemplo").html('(Ocultar archivo Ejemplo)');
                }else{
                    $("#VerEjemplo").html('(Ver archivo Ejemplo)');
                }
                $("#imagenEjemplo").toggle('slow');
            });
        });
        
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
        
        <asp:Panel ID="pnlPrincipal" runat="server">
            <table style="width:100%">
                <tr valign="top">
                    <td align="center" width="50%">
                        <table class="tablaGris" style="width: auto;">
                            <tr>
                                <td colspan="3" style="text-align: center" class="thGris">
                                    SELECCIONE EL ARCHIVO</td>
                            </tr>
                            <tr>
                                <td class="field" align="left">
                                    Archivo Descargue de Seriales:
                                    <br />
                                    <span class="listSearchTheme">Formato de archivo aceptado: Texto (.txt)</span>
                                </td>
                                <td align="left">
                                    <asp:FileUpload ID="fuArchivo" runat="server" CssClass="search" />
                                    <div>
                                        <asp:CustomValidator ID="cvArchivo" runat="server" ErrorMessage="El archivo a cargar debe ser de tipo texto (.txt)."
                                            Display="Dynamic" ClientValidationFunction="ValidarArchivo" ValidationGroup="vgCargue" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" valign="middle" align="center">
                                    <a href="javascript:void(0);" id="VerEjemplo">(Ver archivo Ejemplo)</a><br />
                                    <div id="imagenEjemplo" style="display: none;">
                                        <img id="seriales" src="../images/EjemploDescargueSerial.png" name="seriales" alt="Ver imagen de ejemplo." />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" valign="bottom" align="right">
                                    <asp:LinkButton ID="lbProcesar" runat="server" CssClass="search" Text="Procesar Archivo" ValidationGroup="vgCargue" CausesValidation="true">
                                        <img src="../images/engranaje.jpg" alt="Procesar Archivo" />&nbsp;Procesar archivo
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td align="center" width="50%">
                        <table class="tablaGris" style="width: auto;">
                            <tr>
                                <td colspan="3" style="text-align: center" class="thGris">
                                    INGRESE EL SERIAL</td>
                            </tr>
                            <tr>
                                <td class="field" align="left">
                                    Serial:&nbsp;
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtSerial" runat="server" MaxLength="20" ValidationGroup="vgDescargarSerial" /><br />
                                    <asp:RequiredFieldValidator ID="rfvtxtSerial" runat="server" ControlToValidate="txtSerial"
                                        ErrorMessage="Debe ingresar un serial para realizar el descargue" ValidationGroup="vgDescargarSerial" />
                                    
                                </td>
                                
                                <td valign="bottom" align="right">
                                    <asp:LinkButton ID="lbDescargarSerial" runat="server" CssClass="search" Text="Descargar Serial" ValidationGroup="vgDescargarSerial" CausesValidation="true">
                                        <img src="../images/eliminar.gif" alt="Descargar Serial" />&nbsp;Descargar Serial
                                    </asp:LinkButton>
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    
        <asp:Panel ID="pnlErrores" runat="server" HorizontalAlign="Center" Visible="false">
            <table class="tablaGris">
                <tr>
                    <td style="text-align: center">
                        <br />
                        <b>Log de Resultados</b>
                    </td>
                </tr> 
                <tr>
                    <td>
                        <asp:GridView ID="gvErrores" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="No se encontraron errores." 
                            HeaderStyle-HorizontalAlign="Center"
                            AutoGenerateColumns="true">
                            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                            <PagerStyle CssClass="pagerChildDG" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        
    </form>
</body>
</html>
