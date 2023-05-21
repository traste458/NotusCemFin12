<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolNovedades.aspx.vb"
    Inherits="BPColSysOP.PoolNovedades" EnableEventValidation="false" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pool de Novedades - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .tooltip {
            background-color:#000;
            border:1px solid #fff;
            padding:10px 15px;
            width:200px;
            display:none;
            color:#fff;
            text-align:left;
            font-size:12px;
 
            /* outline radius for mozilla/firefox only */
            -moz-box-shadow:0 0 10px #000;
            -webkit-box-shadow:0 0 10px #000;
        }
    </style>
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.tools.min.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function CollapseDetail(img, control) {
            try {
                var panel = document.getElementById(control);
                if (panel.style.display == "none") {
                    panel.style.display = "inline";
                    img.src = "../images/contraer.png";
                }
                else {
                    panel.style.display = "none";
                    img.src = "../images/expandir.png";
                }
            } catch (err) {
                alert(err);
            }
        }

        function pageLoad(sender, args) {
            Load();
        }

        $(document).ready(function () {
            Load();
        });

        function Load() {
            $("#txtidServicio").tooltip({
                position: "center right",
                offset: [-2, 10],
                effect: "fade",
                opacity: 0.7
            });
        }

        function validarRadicados(sender, args) {
            var objRadicados = $("#<%=txtidServicio.ClientID%>").val().split('\n');
            if (objRadicados.length <= 500) {
                var linea = 1;
                var mensaje = "";
                for (i = 0; i < objRadicados.length; i++) {
                    if (isNaN(Number(objRadicados[i]))) {
                        mensaje = mensaje + "Línea " + linea + ": El valor no es un radicado válido [" + objRadicados[i] + "].\n";
                    } else if (objRadicados[i].length > 10) {
                        mensaje = mensaje + "Línea " + linea + ": El valor es demasiado largo [" + objRadicados[i] + "]. \n";
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
                alert("El límite máximo de radicados para la búsqueda es de 500.");
                args.IsValid = false;
            }
        }

        function MaxLongitud(text, len) {
            var maxlength = new Number(len);
            if (text.value.length > maxlength) {
                text.value = text.value.substring(0, maxlength);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
        </eo:CallbackPanel>
    
        <asp:Panel ID="pnlFiltro" runat="server">
            <table class="tablaGris" style="width: auto;">
                <tr>
                    <td colspan="6" style="text-align: center" class="thGris">
                        INGRESE LOS DATOS PARA CONSULTA
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        No Radicado:
                    </td>
                    <td align="left">
                        <div style="float: left; margin-right: 5px;">
                            <asp:RadioButtonList id="rblTipoBusqueda" runat="server" RepeatDirection="Vertical">
                                <asp:ListItem Text="Radicado" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Servicio" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div style="float: left">
                            <asp:TextBox ID="txtidServicio" runat="server" TextMode="MultiLine" onKeyUp="javascript:MaxLongitud(this,4000);" onChange="javascript:MaxLongitud(this,4000);"
                                Rows="4" Columns="20" onkeypress="javascript:return ValidaNumero(event);" title="Seleccione el tipo de búsqueda e Ingrese los números de radicados o servicio separados por saltos de línea." >
                            </asp:TextBox>
                        </div>
                        <div style="clear:both">
                            <asp:CustomValidator ID="cvRadicado" runat="server" Display="Dynamic"
                                ValidationGroup="vgCliente" ErrorMessage="Radicados incorrectos, por favor verifique." 
                                ControlToValidate="txtidServicio" ClientValidationFunction="validarRadicados" />
                        </div>
                    </td>
                    <td class="field">
                        <b>Ciudad: </b>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCiudad" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        <b>Bodega: </b>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlBodega" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        <b>Fecha Agenda:</b>
                    </td>
                    <td style="vertical-align: middle" nowrap="nowrap">
                        <table style="padding: 0px !important">
                            <tr>
                                <td>
                                    De:&nbsp;&nbsp;
                                </td>
                                <td valign="middle">
                                    <input class="textbox" id="txtFechaInicial" readonly="readonly" size="11" name="txtFechaInicial"
                                        runat="server" />
                                </td>
                                <td valign="middle">
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.formPrincipal.txtFechaInicial,document.formPrincipal.txtFechaFinal);return false;"
                                        href="javascript:void(0)">
                                        <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Inicial" src="../include/DateRange/calbtn.gif"
                                            width="34" align="middle" border="0"></a>
                                </td>
                                <td>
                                    &nbsp;&nbsp;&nbsp;
                                </td>
                                <td>
                                    Hasta:&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input class="textbox" id="txtFechaFinal" readonly="readonly" size="11" name="txtFechaFinal"
                                        runat="server" />
                                </td>
                                <td>
                                    <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.formPrincipal.txtFechaInicial,document.formPrincipal.txtFechaFinal);return false;"
                                        href="javascript:void(0)">
                                        <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                            width="34" align="middle" border="0"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class="field">
                        Cliente VIP:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlVIP" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Urgente:</td>
                    <td>
                        <asp:DropDownList ID="ddlUrgente" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">Prioridad:</td>
                    <td>
                        <asp:DropDownList ID="ddlPrioridad" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">Estado Novedad:</td>
                    <td>
                        <asp:DropDownList ID="ddlEstadoNovedad" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">Tipo de Servicio:</td>
                    <td>
                        <asp:DropDownList ID="ddlTipoServicio" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                
                <tr>
                    <td colspan="4" align="center" style="height: 35px; ">
                        <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                        </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                        </asp:LinkButton>
                    </td>
                    <td colspan="2" align="center">
                        <asp:LinkButton ID="lbExportar" runat="server" CssClass="search" Font-Bold="true" Enabled="false">
                            <img alt="Exportar a Excel" src="../images/Excel.gif" />&nbsp;Exportar a Excel
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <asp:Panel ID="pnlResultados" runat="server">
            <div style="text-align: left;">
                <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                    CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                    EmptyDataText="No hay pedidos pendientes" HeaderStyle-HorizontalAlign="Center"
                    PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                    AllowSorting="true" Width="100%">
                    <PagerSettings Mode="NumericFirstLast" />
                    <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                    <PagerStyle CssClass="field" HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <AlternatingRowStyle CssClass="alterColor" />
                    <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                    
                    <Columns>
                        <asp:TemplateField HeaderText="[+/-]" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Image ID="imgCollapse" runat="server" ImageUrl="~/images/expandir.png" ToolTip="Ver detalle" ImageAlign="Middle" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="idServicioMensajeria" HeaderText="Id" SortExpression="idServicioMensajeria">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipoServicio" SortExpression="tipoServicio" HeaderText="Tipo de Servicio" />
                        <asp:BoundField DataField="numeroRadicado" SortExpression="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                        <asp:BoundField DataField="NombreCliente" SortExpression="NombreCliente" HeaderText="Nombre Cliente" />
                        <asp:BoundField DataField="Identificacion" SortExpression="Identificacion" HeaderText="Identificación" />
                        <asp:BoundField DataField="nombreContacto" SortExpression="nombreContacto" HeaderText="Contacto" />
                        <asp:BoundField DataField="direccion" SortExpression="direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="telefono" SortExpression="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="fechaAgenda" SortExpression="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="consultor" SortExpression="consultro" HeaderText="Consultor" />
                        
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                </td></tr>
                                <tr>
                                    <td colspan="10">
                                        <asp:Panel ID="pnlDetalle" runat="server" Style="display: none;" Width="100%">
                                            <asp:GridView ID="gvDatosDetalle" runat="server" AutoGenerateColumns="False"
                                                BackColor="White" BorderColor="Gray" BorderStyle="Dashed" BorderWidth="2px"
                                                CellPadding="4" ForeColor="Black" GridLines="Vertical" Width="100%" OnRowCommand="gvDatosDetalle_RowCommand"
                                                OnRowDataBound="gvDatosDetalle_RowDataBound" DataKeyNames="idNovedad" >
                                                <RowStyle BackColor="#F7F7DE" />
                                                <Columns>
                                                    <asp:BoundField DataField="fechaRegistro" HeaderText="Fecha Asignación" DataFormatString="{0:dd/MM/yyyy}" />
                                                    <asp:BoundField DataField="tipoNovedad" HeaderText="Novedad" />
                                                    <asp:BoundField DataField="usuarioRegistra" HeaderText="Usuario Registro" />
                                                    <asp:BoundField DataField="estado" HeaderText="Estado" SortExpression="estado" />
                                                    <asp:BoundField DataField="observacion" HeaderText="Observaci&oacute;n" />
                                                    <asp:BoundField DataField="comentarioEspecifico" HeaderText="Comentario Espec&iacute;fico" />
                            
                                                    <asp:TemplateField HeaderText="Opción" ItemStyle-HorizontalAlign="Center">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="imgSolucionar" runat="server" ImageUrl="~/images/ok.png" CommandName="solucionar"
                                                            CommandArgument='<%# Bind("idNovedad") %>' ToolTip="Solucionar" ImageAlign="Middle" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <FooterStyle BackColor="#CCCC99" />
                                                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                                <AlternatingRowStyle BackColor="White" />
                                            </asp:GridView>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    
    <eo:CallbackPanel ID="cpSolucionarNovedad" runat="server" Width="100%" UpdateMode="Group"
        GroupName="general" LoadingDialogID="ldrWait_dlgWait">
        <eo:Dialog runat="server" ID="dlgSolucionarNovedad" ControlSkinID="None" Height="200px"
            HeaderHtml="Generar Solución" CloseButtonUrl="00020312" BackColor="White"
            BackShadeColor="Gray" BackShadeOpacity="50" CancelButton="lbCancelarServicio"
            Width="500px">
            <ContentTemplate>
                <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                    <table align="center" class="tabla">
                        <tr>
                            <td class="field">
                                Observacion:
                            </td>
                            <td>
                                <asp:TextBox ID="txtObservacionSolucion" runat="server" Rows="6" Width="400px"
                                    TextMode="MultiLine"></asp:TextBox>
                                <div>
                                    <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Para marcar como solucionada la novedad se requiere una observación."
                                        Display="Dynamic" ValidationGroup="solucionarNovedad" 
                                        ControlToValidate="txtObservacionSolucion"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <br />
                                <br />
                                <asp:LinkButton ID="lbSolucionarNovedad" runat="server" CssClass="search" ValidationGroup="solucionarNovedad"><img src="../images/ok.png" alt=""/>&nbsp;Marcar como solucionado</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbCancelarServicio" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                <asp:HiddenField ID="hfIdNovedad" runat="server" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
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
    
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
    
</body>
</html>
