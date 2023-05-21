<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargueServicioMensajeria.aspx.vb" Inherits="BPColSysOP.CargueServicioMensajeria" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Cargue Servicio Mensajeria</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <style type="text/css">
        #pnlGeneral
        {
        	width:500px;
        }        
    </style>
    <script type="text/javascript" language="javascript">
        function ValidarArchivo(source, args) {
            var cadenaArchivo = $("#fuArchivo").val();
            var mensaje = "";
            if (cadenaArchivo != "") {
                cadenaArchivo = cadenaArchivo.toLowerCase();
                if (/[a-zA-Z0-9.(.)](.csv)$/.test(cadenaArchivo)) {
                    args.IsValid = true;
                } else {
                    args.IsValid = false;
                    mensaje = "Por favor verifique el archivo sea .csv";
                }
            } else {
                args.IsValid = false;
                mensaje = "Por favor especifique el archivo a cargar";
            }
            source.innerHTML = mensaje;
        }
    </script>    
</head>
<body  class="cuerpo2">
    <form id="form1" runat="server">
    <div>             
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
    </div>
    <div id="pnlGeneral">
        <asp:Panel ID="pnlCargueArchivoPlano" runat="server" style="border:1px solid;">
            <p class="subtitulo" style="text-align:left;">Cargue Archivo:</p>
            <table class="tablaGris" style="width:100%;">
                <tr>
                    <td class="field">Tipo Archivo:</td>
                    <td>
                        <asp:DropDownList ID="ddlTipoArchivo" runat="server">
                        </asp:DropDownList>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvTipoArchivo" runat="server" ControlToValidate="ddlTipoArchivo" Display="Dynamic" 
                                ErrorMessage="Por favor seleccione el tipo de archivo." InitialValue="0" ValidationGroup="Cargar"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                </tr>                
                <tr>
                    <td colspan="2" align="center" class="field">
                        <asp:HyperLink ID="hlkEjempoGeneral" runat="server" 
                            NavigateUrl="~/Reports/Plantillas/ejemploCargueArhivoPlanoGeneralCEM.csv">Ejem. Archivo General</asp:HyperLink>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:HyperLink ID="hlkEjempoCorporativo" runat="server"
                            NavigateUrl="~/Reports/Plantillas/ejemploCargueArhivoPlanoCorporativoCEM.csv">Ejem. Archivo Corporativo</asp:HyperLink>
                    </td>
                </tr>
                <tr>
                    <td class="field">Archivo:</td>
                    <td>
                        <asp:FileUpload ID="fuArchivo" runat="server" />
                        <div>
                            <asp:CustomValidator ID="cvArchivoCEM" runat="server" ClientValidationFunction="ValidarArchivo" 
                                ErrorMessage="" ValidationGroup="Cargar" Display="Dynamic"></asp:CustomValidator>
                        </div>
                    </td>
                </tr>
                <tr>                    
                    <td colspan="2" align="center">
                        <asp:Button ID="btnCargar" runat="server" CssClass="search" Text="Cargar" ValidationGroup="Cargar" />
                    </td>
                </tr>
            </table>
        </asp:Panel>        
    </div>
    
    <asp:Panel ID="pnlErrores" runat="server" style="width:90%;">
            <table class="tablaGris" width="100%">
                <tr>
                    <td style="text-align: center" colspan="3">
                        <div><blockquote><br/><b>LOG DE RESULTADOS</b></blockquote></div>
                    </td>
                </tr> 
                <tr>
                    <td valign="top" width="44%">
                        <asp:GridView ID="gvErrores" runat="server" CssClass="tablaGris" 
                            style="width:100%;" AutoGenerateColumns="False"
                            EmptyDataText="<div><blockquote><br/>No se generaron errores.</blockquote></div>">
                            <AlternatingRowStyle CssClass="alterColor" />
                            <Columns>
                                <asp:BoundField DataField="linea" HeaderText="Linea">
                                    <ItemStyle HorizontalAlign="Center" Width="20px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="descripcion" HeaderText="Descripción de Inconvenientes" />
                            </Columns>
                        </asp:GridView>
                    </td>
                    
                    <td width="2%">&nbsp;</td>
                    
                    <td valign="top" width="44%">
                        <asp:GridView ID="gvCorrectos" runat="server" CssClass="tablaGris" 
                            style="width:100%;" AutoGenerateColumns="False"
                            EmptyDataText="<div><blockquote><br/>No se generaron registros correctos.</blockquote></div>">
                            <AlternatingRowStyle CssClass="alterColor" />
                            <Columns>
                                <asp:BoundField DataField="linea" HeaderText="Linea">
                                    <ItemStyle HorizontalAlign="Center" Width="20px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="descripcion" HeaderText="Descripción registros correctos." />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </form>
</body>
</html>
