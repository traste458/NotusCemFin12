<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministrarCapacidadesDeEntrega.aspx.vb"
    Inherits="BPColSysOP.AdministrarCapacidadesDeEntrega" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Administrar Capacidades de Entrega</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\n\r]+|[\s\t\n\r]+$/g, "") }
        function ValidarCantidadServicios(source, args) {
            try {
                var numServicios = document.getElementById(source.controltovalidate).value;
                if (numServicios.trim().length > 0) {
                    var oExp = /^[0-9]+$/
                    if (oExp.test(numServicios)) {
                        if (parseInt(numServicios) > 0) {
                            args.IsValid = true;
                        } else {
                            args.IsValid = false;
                        }
                    } else {
                        args.IsValid = false;
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar campo N&uacute;mero de Turnos.\n" + e.description);
            }
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        LoadingDialogID="ldrWait_dlgWait">
        <table class="tabla">
            <tr>
                <th colspan="2">
                    INFORMACI&Oacute;N DE CAPACIDADES DE ENTREGA
                </th>
            </tr>
            <tr>
                <td class="field">
                    Fecha:
                </td>
                 <td valign="middle">
                                <input class="textbox" id="dpFecha" readonly="readonly" size="11" name="dpFecha"
                                    runat="server" />       
                                <a hidefocus onclick="if(self.gfPop)gfPop.fPopCalendar(document.getElementById('dpFecha'));return false;"
                                    href="javascript:void(0)">
                                    <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Inicial" src="../include/DateRange/calbtn.gif"
                                        width="34" align="middle" border="0"></a>
                                <div style="display: block">   
                                    
                           <asp:RangeValidator ID="rvfecha" runat="server" Type="Date"  ErrorMessage="La fecha debe ser maximo de 30 dias a partir de la fecha actual"
                               Display="Dynamic" ControlToValidate="dpFecha" ValidationGroup="registro" ></asp:RangeValidator>
                        <asp:RequiredFieldValidator ID="rfvFecha" runat="server" ErrorMessage="El valor del campo fecha es requerido"
                            Display="Dynamic" ControlToValidate="dpFecha" ValidationGroup="registro"></asp:RequiredFieldValidator>
                    </div>
                           
                </td>
            </tr>
            <tr>
                <td class="field">
                    Cliente:
                </td>
                <td>
                    <asp:DropDownList ID="ddlcliente" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Debe seleccionar un cliente"
                            Display="Dynamic" ControlToValidate="ddlcliente" ValidationGroup="registro" InitialValue="0"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Jornada:
                </td>
                <td>
                    <asp:DropDownList ID="ddlJornada" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvJornada" runat="server" ErrorMessage="Debe seleccionar una jornada"
                            Display="Dynamic" ControlToValidate="ddlJornada" ValidationGroup="registro" InitialValue="0"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    N&uacute;mero de Turnos:
                </td>
                <td>
                    <asp:TextBox ID="txtNumServicios" runat="server" MaxLength="4" Width="60px"></asp:TextBox>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvNumServicios" runat="server" ErrorMessage="El valor del campo n&uacute;mero de turnos es requerido"
                            Display="Dynamic" ControlToValidate="txtNumServicios" ValidationGroup="registro"></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="cusNumServicios" runat="server" ErrorMessage="El valor digitado no es v&aacute;lido. Se espera un n&uacute;mero entero mayor que cero(0)"
                            Display="Dynamic" ControlToValidate="txtNumServicios" ClientValidationFunction="ValidarCantidadServicios"
                            ValidationGroup="registro"></asp:CustomValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">Agrupación de Servicios:</td>
                <td>
                    <asp:DropDownList ID="ddlAgrupacion" runat="server"></asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvddlAgrupacion" runat="server" ErrorMessage="Debe seleccionar un tipo de agrupación"
                            Display="Dynamic" ControlToValidate="ddlAgrupacion" ValidationGroup="registro" InitialValue="0"></asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <br />
                    <asp:LinkButton ID="lbRegistrar" runat="server" CssClass="search" ValidationGroup="registro"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>
                    <br />
                </td>
            </tr>
        </table>
        <br />
        <br />
        <br />
        <table class="tabla">
            <tr>
                <th colspan="3">
                    CONSULTAR DATOS REGISTRADOS
                </th>
            </tr>
            <tr>
                <td class="field">
                    Fecha:
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
                                <a hidefocus onclick="if(self.gfPop)gfPop.fStartPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;"
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
                                <a hidefocus onclick="if(self.gfPop)gfPop.fEndPop(document.form1.txtFechaInicial,document.form1.txtFechaFinal);return false;"
                                    href="javascript:void(0)">
                                    <img class="PopcalTrigger" height="22" alt="Seleccione una Fecha Final" src="../include/DateRange/calbtn.gif"
                                        width="34" align="middle" border="0"></a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td>
                    &nbsp;&nbsp;&nbsp;<asp:LinkButton ID="lbConsultar" runat="server" CssClass="search"><img src="../images/find.gif" alt="" />&nbsp;Consultar</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="tablaGris">
                    <br />
                    <br />
                    <asp:GridView ID="gvInfoCapacidades" runat="server" AutoGenerateColumns="false" EmptyDataText="&lt;blocquote&gt;&lt;i&gt;No se encontraron registros&lt;/i&gt;&lt;/blocquote&gt;"
                        ShowFooter="true">
                        <AlternatingRowStyle CssClass="alterColor" />
                        <FooterStyle CssClass="thGris" />
                        <Columns>
                            
                            <asp:BoundField DataField="nit" HeaderText="Nit" />
                              <asp:BoundField DataField="cliente" HeaderText="Cliente" />
                              <asp:BoundField DataField="Bodega" HeaderText="Bodega" />
                            <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="jornada" HeaderText="Jornada" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="cantidadServicios" HeaderText="Num. Servicios Programados"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="cantidadServiciosUtilizados" HeaderText="Num. Servicios Utilizados"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="fechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="usuarioRegistra" HeaderText="Registrado Por" />
                            <asp:BoundField DataField="nombreAgrupacion" HeaderText="Agrupación" />
                            <asp:TemplateField HeaderText="Opciones">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("idRegistro") %>'
                                        ToolTip="Editar Informaci&oacute;n" ImageUrl="~/images/Edit-32.png" />
                                    <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idRegistro") %>'
                                        ToolTip="Informaci&oacute;n" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el registro?');" />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
        <eo:Dialog runat="server" ID="dlgModificar" ControlSkinID="None" Height="300px" HeaderHtml="Modificar Capacidad"
            CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50"
            CancelButton="lbAbortar" Width="500px">
            <ContentTemplate>
                <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%;
                    overflow: auto;">
                    <table class="tabla">
                        <tr>
                            <th colspan="2">
                                INFORMACI&Oacute;N DE CAPACIDADES DE ENTREGA
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Fecha:
                            </td>
                            <td>
                                <asp:Label ID="lblFecha" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Jornada:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlJornadaEdicion" runat="server">
                                </asp:DropDownList>
                                <div style="display: block">
                                    <asp:RequiredFieldValidator ID="rfvJornadaEdicion" runat="server" ErrorMessage="Debe seleccionar una jornada"
                                        Display="Dynamic" ControlToValidate="ddlJornadaEdicion" ValidationGroup="edicion"
                                        InitialValue="0"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                N&uacute;mero de Turnos:
                            </td>
                            <td>
                                <asp:TextBox ID="txtNumServiciosEdicion" runat="server" MaxLength="4"  Width="60px"></asp:TextBox>
                                <div style="display: block">
                                    <asp:RequiredFieldValidator ID="rfvNumServiciosEdicion" runat="server" ErrorMessage="El valor del campo n&uacute;mero de turnos es requerido"
                                        Display="Dynamic" ControlToValidate="txtNumServiciosEdicion" ValidationGroup="edicion"></asp:RequiredFieldValidator>
                                    <asp:CustomValidator ID="cusNumServiciosEdicion" runat="server" ErrorMessage="El valor digitado no es v&aacute;lido. Se espera un n&uacute;mero entero mayor que cero(0)"
                                        Display="Dynamic" ControlToValidate="txtNumServiciosEdicion" ClientValidationFunction="ValidarCantidadServicios"
                                        ValidationGroup="edicion"></asp:CustomValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Turnos Utilizados:
                            </td>
                            <td>
                                <asp:Label ID="lblNumServiciosUtilizados" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <br /><br />
                                <asp:LinkButton ID="lbActualizar" runat="server" CssClass="search" ValidationGroup="edicion"><img src="../images/save_all.png" alt="" />&nbsp;Actualizar</asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbAbortar" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <asp:HiddenField ID="hfIdInfoCapacidad" runat="server" />
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
