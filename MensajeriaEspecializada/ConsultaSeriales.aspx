<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaSeriales.aspx.vb"
    Inherits="BPColSysOP.ConsultaSeriales" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Consulta de Seriales - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jscript_ventana.js" type="text/javascript" language="javascript"></script>
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function validarSeriales(sender, args) {
            var objSeriales = $("#<%=txtSeriales.ClientID%>").val().split('\n');
            var objExpresion = $("#<%=hfRegexSerial.ClientID%>").val();

            if (objSeriales.length == 0) {
                alert("Se debe ingresar un valor de búsqueda.");
                args.IsValid = false;
            } else if (objSeriales.length <= 5000) {
                var linea = 1;
                var mensaje = "";
                for (i = 0; i < objSeriales.length; i++) {
                    var re = new RegExp('[0-9a-zA-Z]{5,20}');
                    if (re.exec(objSeriales[i]) == null) {
                        mensaje = mensaje + "Línea " + linea + ": El serial no es válido [" + objSeriales[i] + "]. \n";
                    }
                    linea++;
                }
                if (mensaje == "") {
                    args.IsValid = true;
                } else {
                    alert(mensaje);
                    args.IsValid = false;
                }
            } else {
                alert("El límite máximo de radicados para la búsqueda es de 5000.");
                args.IsValid = false;
            }
        }

        function MaxLongitud(text, len) {
            var maxlength = new Number(len);
            if (text.value.length > maxlength) {
                text.value = text.value.substring(0, maxlength);
            }
        }
    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize('hfMedidasVentana');">
    <form id="formPrincipal" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:UpdatePanel ID="upEncabezado" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hfMedidasVentana" runat="server" />
                <asp:HiddenField ID="hfRegexSerial" runat="server" />
                <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
        Triggers="{ControlID:lbConsultar;Parameter:},{ControlID:lbLimpiar;Parameter:}">
        <asp:Panel ID="pnlFiltro" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <th colspan="2" style="text-align: center" class="thGris">
                        FILTROS DE BÚSQUEDA
                    </th>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Serial(es):
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtSeriales" runat="server" TextMode="MultiLine" onKeyUp="javascript:MaxLongitud(this,85000);"
                            onChange="javascript:MaxLongitud(this,85000);" Rows="5">
                        </asp:TextBox>
                        <div style="float: right; margin-left: 10px;">
                            <blockquote>
                                Ingrese los seriales separados por saltos de línea ej:<br />
                                9999999999<br />
                                8888888888<br />
                                7777777777
                            </blockquote>
                        </div>
                        <div style="clear: both">
                            <asp:RequiredFieldValidator ID="rfvtxtSeriales" runat="server" Display="Dynamic"
                                ValidationGroup="vgBusqueda" ErrorMessage="Debe ingresar al menos un serial de búsqueda."
                                ControlToValidate="txtSeriales" />
                            <asp:CustomValidator ID="cvRadicado" runat="server" Display="Dynamic" ValidationGroup="vgBusqueda"
                                ErrorMessage="Seriales incorrectos, por favor verifique." ControlToValidate="txtSeriales"
                                ClientValidationFunction="validarSeriales" />
                        </div>
                    </td>
                </tr>
                <tr style="height: 40px; vertical-align:middle;">
                    <td colspan="2" align="center">
                        <div style="float: left; margin-top: 5px;">
                            <asp:LinkButton ID="lbConsultar" runat="server" CssClass="search" ToolTip="Consultar seriales"
                                ValidationGroup="vgBusqueda">
                                <img alt="Consultar seriales" src="../images/view.png" />&nbsp;Consultar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbLimpiar" runat="server" CssClass="search" ToolTip="Limpiar Filtro">
                                <img alt="Limpiar" src="../images/unfunnel.png" />&nbsp;Limpiar
                            </asp:LinkButton>
                        </div>
                        <div style="float: right; margin-top: 5px;">
                            <asp:LinkButton ID="lbExportar" runat="server" CssClass="search">
                                <img alt="Exportar Resultados" src="../images/Excel.gif" />&nbsp;Exportar resultados
                            </asp:LinkButton>
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <br />
        <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
            <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                EmptyDataText="<blockquote>No se encontraron resultados para los seriales ingresados.</blockquote>"
                HeaderStyle-HorizontalAlign="Center" PageSize="50" ShowFooter="True" BorderColor="Gray"
                CellPadding="1" CellSpacing="1">
                <PagerSettings Mode="NumericFirstLast" />
                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                <HeaderStyle HorizontalAlign="Center" />
                <AlternatingRowStyle CssClass="alterColor" />
                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                <Columns>
                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                    <asp:BoundField DataField="EstadoInventario" HeaderText="Estado Inventario" />
                    <asp:BoundField DataField="Material" HeaderText="Material" />
                    <asp:BoundField DataField="DescripcionMaterial" HeaderText="Descripción Material" />
                    <asp:BoundField DataField="Bodega" HeaderText="Bodega" />
                    <asp:TemplateField HeaderText="Radicado">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbVer" runat="server" CommandName="ver" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "idServicioMensajeria") %>'
                                ToolTip="Ver Información del Servicio" Text='<%# Bind("numeroRadicado") %>'>
                            </asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="EstadoRadicado" HeaderText="Estado Radicado" />
                </Columns>
            </asp:GridView>
        </asp:Panel>
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpVerInformacion" runat="server" LoadingDialogID="ldrWait_dlgWait"
        UpdateMode="Group" GroupName="general">
        <eo:Dialog runat="server" ID="dlgVerInformacionServicio" ControlSkinID="None" Width="800px"
            Height="600px" HeaderHtml="Información detallada del Servicio" CloseButtonUrl="00020312"
            BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
            <ContentTemplate>
            </ContentTemplate>
            <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
            </FooterStyleActive>
            <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
            </HeaderStyleActive>
            <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
            </ContentStyleActive>
            <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
            </BorderImages>
        </eo:Dialog>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
