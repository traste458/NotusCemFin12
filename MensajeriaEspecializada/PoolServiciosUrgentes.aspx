<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolServiciosUrgentes.aspx.vb" Inherits="BPColSysOP.PoolServiciosUrgentes" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Pool de Servicios Urgentes</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epPoolServicios" runat="server" />
        </eo:CallbackPanel>
    
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="panelDatosPoolServicios" runat="server">
                <table class="tablaGris" style="width: auto;">
                    <tr>
                        <td colspan="6" style="text-align: center" class="thGris">
                            INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            No. Radicado:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtidServicio" runat="server"></asp:TextBox>
                            <div>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" Display="Dynamic"
                                    ControlToValidate="txtidServicio" ValidationGroup="vgCliente" ErrorMessage="El numero de id Servicio digitado no es válido, por favor verifique"
                                    ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                        <td class="field">
                            <b>Campaña: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCampana" runat="server">
                                <asp:ListItem Value="0">Seleccione una Campaña</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td class="field">
                            <b>Ciudad: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCiudad" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">
                            Estado:
                        </td>
                        <td align="left">
                            <asp:DropDownList ID="ddlEstado" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">
                            <b>Bodega: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlBodega" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">
                            <b>Tipo Servicio: </b>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTipoServicio" runat="server">
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
                            Cliente VIP:</td>
                        <td>
                            <asp:DropDownList ID="ddlVIP" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">
                            Estado Novedad:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTieneNovedad" runat="server">
                                <asp:ListItem Value="0" Text="Seleccione una Opci&oacute;n"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Sin Novedad"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Con Novedad"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <br />
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
                <br />
            </asp:Panel>
            
            <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
                <div style="text-align: center;">
                    <b>Resultados de busqueda</b>
                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="No hay pedidos pendientes" HeaderStyle-HorizontalAlign="Center"
                        PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" 
                        CellSpacing="1" AllowSorting="True">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        <Columns>
                            <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="numeroRadicado" SortExpression="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                            <asp:BoundField DataField="fechaAsignacion" HeaderText="Fecha Asignación" 
                                DataFormatString="{0:dd/MM/yyyy}" SortExpression="fechaAsignacion" />
                            <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" 
                                DataFormatString="{0:dd/MM/yyyy}" SortExpression="fechaAgenda" />
                            <asp:BoundField DataField="usuarioEjecutor" HeaderText="Usuario Ejecutor" />
                            <asp:BoundField DataField="jornada" HeaderText="Jornada" />
                            <asp:BoundField DataField="estado" HeaderText="Estado" />
                            <asp:BoundField DataField="fechaConfirmacion" HeaderText="Fecha Confirmacion" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="responsableEntrega" HeaderText="Responsable Entrega" />
                            <asp:BoundField DataField="tieneNovedad" HeaderText="Tiene Novedad (S/N)" />
                            <asp:BoundField DataField="nombreCliente" HeaderText="Nombre Cliente" 
                                SortExpression="nombreCliente" />
                            <asp:BoundField DataField="personaContacto" HeaderText="Persona Contacto" />
                            <asp:BoundField DataField="ciudadCliente" HeaderText="Ciudad Cliente" 
                                SortExpression="ciudadCliente" />
                            <asp:BoundField DataField="barrio" HeaderText="Barrio" />
                            <asp:BoundField DataField="direccion" HeaderText="Direcci&oacute;n" />
                            <asp:BoundField DataField="telefonoContacto" HeaderText="Tel&eacute;fono" />
                            <asp:TemplateField HeaderText="Opciones">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbVer" runat="server" CommandName="ver" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Ver Información del Servicio">
                                    <img alt="Ver Información del Servicio" border="0" src="../images/view.png"></img></asp:LinkButton>
                                    <asp:LinkButton ID="lbAdicionarNovedad" runat="server" CommandName="adicionarNovedad" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Adicionar Novedad"> 
                                        <img alt="Adicionar Novedad" border="0" src="../images/comment_add.png"></img></asp:LinkButton>
                                    <asp:LinkButton ID="lbModificarServicio" runat="server" CommandName="modificarServicio"
                                    CommandArgument='<%# Bind("idServicioMensajeria") %>' ToolTip="Modificar servicio">
                                        <img alt="Modificar Servicio" border="0" src="../images/Edit-User.png"/></asp:LinkButton>                                       
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>
        
            <eo:Dialog runat="server" ID="dlgAdicionarNovedad" ControlSkinID="None" Height="500px" HeaderHtml="Apertura de Servicio"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50" CancelButton="lbCancelarServicio"
                Width="500px">
                <ContentTemplate>
                    <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%;
                        overflow: auto;">
                        <table align="center" class="tabla">
                            <tr>
                                <td class="field">
                                    Novedad:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtObservacionNovedad" runat="server" Rows="6" Width="400px"
                                        TextMode="MultiLine"></asp:TextBox>
                                    <div>
                                        <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Debe diligenciar el texto d ela novedad."
                                            Display="Dynamic" ValidationGroup="adicionarNovedad" ControlToValidate="txtObservacionNovedad"></asp:RequiredFieldValidator>
                                    </div>
                                    <br />
                                    <asp:DropDownList ID="ddlTipoNovedad" runat="server" ValidationGroup="registroNovedad">
                                    </asp:DropDownList>
                                    <div style="display: block;">
                                    <asp:RequiredFieldValidator ID="rfvTipoNovedad" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                        Display="Dynamic" ControlToValidate="ddlTipoNovedad" ValidationGroup="registroNovedad"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <br />
                                    <br />
                                    <asp:LinkButton ID="lbAgregarNovedad" runat="server" CssClass="search" ValidationGroup="adicionarNovedad"><img src="../images/save_all.png" alt=""/>&nbsp;Adicionar Novedad</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:LinkButton ID="lbCancelarServicio" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                    <asp:HiddenField ID="hfIdServicio" runat="server" />
                                </td>
                            </tr>
                            <tr><td colspan="2">&nbsp;</td></tr>
                            <tr>
                                <td colspan="2">
                                    <asp:GridView ID="gvNovedad" runat="server" Width="100%" AutoGenerateColumns="false"
                                        EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                        <Columns>
                                            <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                            <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                            <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                                DataFormatString="{0:dd/MM/yyyy}" />
                                            <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                        </Columns>
                                        <AlternatingRowStyle CssClass="alterColor" />
                                    </asp:GridView>        
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
            frameborder="0" width="132" scrolling="no" height="142">
        </iframe>
    </form>
</body>
</html>
