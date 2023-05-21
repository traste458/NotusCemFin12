<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionRutasServicio.aspx.vb"
    Inherits="BPColSysOP.CreacionRutasServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pool Creación de Rutas - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" language="javascript">
        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                //alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }

        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function FiltrarEOPanel(idFiltro, idFlag, parametro, idCallbackPanel) {
            var filtro = document.getElementById(idFiltro).value.trim();
            if (idFlag != 0) { ObtenerIdFlagCallBackPanelFilter(idFlag); }
            var comboFiltrado = ctrIdFlagFilterFilter.value;
            try {
                if (filtro.length >= 4 || (filtro.length < 4 && comboFiltrado == "1")) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(callBackPanelFilter.id, parametro);
                    if (filtro.length >= 4) {
                        ctrIdFlagFilterFilter.value = "1";
                    } else {
                        ctrIdFlagFilterFilter.value = "0";
                    }
                }
                document.getElementById(idFiltro).focus();
            } catch (e) {
                //MostrarOcultarDivFloater(false);
                //alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }

        function ObtenerIdFlagCallBackPanelFilter(idFlag) {

            switch (idFlag) {
                case 1:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMoto.ClientID %>');
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMoto.ClientID %>');
                    break;
                case 2:
                    ctrIdFlagFilterFilter = document.getElementById('<%= hfFlagFiltroMoto.ClientID %>')
                    callBackPanelFilter = document.getElementById('<%= cpFiltroMoto.ClientID %>');
                    break;
                default:
                    break;
            }
        }

        function SeleccionarODesmarcarTodo(ctrl, targetName) {
            var cont = 0;
            var arrControl = document.getElementsByTagName("input");
            for (i = 0; i < arrControl.length; i++) {
                if (arrControl[i].type == "checkbox" && arrControl[i].name.indexOf(targetName) != -1 && arrControl[i].disabled == false) {
                    arrControl[i].checked = ctrl.checked;
                    cont += 1;
                }
            }
            if (ctrl.checked) {
                if (cont == 0) {
                    alert("No se encontraron registros seleccionables. Por favor verifique");
                    ctrl.checked = false;
                }
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="pnlLog" runat="server" HorizontalAlign="Right" Width="100%">
            <asp:GridView ID="gvLog" runat="server" AutoGenerateColumns="False" CssClass="grid"
                EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                BorderColor="Gray" CellPadding="1" CellSpacing="1" HorizontalAlign="Center">
                <AlternatingRowStyle CssClass="alterColor" />
                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                <Columns>
                    <asp:BoundField DataField="idRuta" HeaderText="Ruta" />
                    <asp:BoundField DataField="responsable" HeaderText="Responsable entrega" />
                </Columns>
            </asp:GridView>
            <br />
        </asp:Panel>
        <asp:Panel ID="pnlFiltros" runat="server">
            <table class="tablaGris" style="width: 100%;">
                <tr>
                    <td colspan="6" style="text-align: center" class="thGris">
                        INGRESE LOS FILTROS DE BÚSQUEDA
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Motorizado:
                    </td>
                    <td colspan="3" valign="top">
                        <asp:TextBox ID="txtFiltroMoto" runat="server" MaxLength="15" onkeyup="FiltrarEOPanel(this.id, 1, 'filtrarMoto');"></asp:TextBox>
                        <eo:CallbackPanel ID="cpFiltroMoto" runat="server" UpdateMode="Group" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                            Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle" GroupName="general">
                            <div style="display: block">
                                <asp:HiddenField ID="hfMoto" runat="server" />
                            </div>
                            <asp:DropDownList ID="ddlMotorizado" runat="server" Style="display: inline;">
                            </asp:DropDownList>
                            <br />
                            <asp:Label ID="lblMoto" runat="server" CssClass="comentario"></asp:Label>
                        </eo:CallbackPanel>
                        <asp:HiddenField ID="hfFlagFiltroMoto" runat="server" />
                        <div id="divFloater" style="display: none; position: absolute; height: 35px; width: 200px;">
                            <table align="center">
                                <tr>
                                    <td align="center" valign="middle" style="height: 100%">
                                        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                                        <b>Procesando...</b>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td class="field">
                        Fecha Agenda:
                    </td>
                    <td valign="middle">
                        <table style="padding: 0px !important">
                            <tr>
                                <td>
                                    Entre:&nbsp;&nbsp;
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
                                    y:&nbsp;&nbsp;
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
                </tr>
                <tr>
                    <td class="field">
                        Jornada:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlJornada" runat="server" Width="150px">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Radicado:
                    </td>
                    <td>
                        <asp:TextBox ID="txtRadicado" runat="server" Width="150px" MaxLength="15" onkeypress="javascript:return ValidaNumero(event);">
                        </asp:TextBox>
                    </td>
                    <td class="field">
                        Tipo de Servicio:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoServicio" runat="server" Width="250px">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <br />
            <table style="width: 100%">
                <tr>
                    <td align="left">
                        <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                        </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                        </asp:LinkButton>
                    </td>
                    <td align="right">
                        <asp:LinkButton ID="lbGenerarRuta" runat="server" CssClass="search" Font-Bold="True"
                            OnClientClick="return confirm('¿Está seguro que desea crear las rutas para los servicios seleccionados?')">
                                    <img alt="Filtrar Pedido" src="../images/trans_small.png" />&nbsp;Generar Ruta
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
            <br />
        </asp:Panel>
        <asp:Panel ID="pnlResultados" runat="server">
            <asp:GridView ID="gvDatos" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                EmptyDataText="No existen elementos disponibles." HeaderStyle-HorizontalAlign="Center"
                PageSize="50" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1">
                <PagerSettings Mode="NumericFirstLast" />
                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                <HeaderStyle HorizontalAlign="Center" />
                <AlternatingRowStyle CssClass="alterColor" />
                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                <Columns>
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <center>
                                <asp:Image ID="imgUrgente" runat="server" ImageUrl="../images/transparent_16.gif"
                                    ToolTip="Urgente" Style="margin: 1px; display:inline" />
                                <asp:LinkButton ID="lnkNovedad" runat="server" CommandName="adicionarNovedad" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                    ToolTip="Adicionar Novedad" style="display:inline"> 
                                    <img alt="Adicionar Novedad" border="0" src="../images/comment_add.png"/>
                                </asp:LinkButton>
                            </center>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Selección">
                        <HeaderTemplate>
                            <asp:CheckBox ID="chkTodos" runat="server" Text="Todos" AutoPostBack="true" onclick="SeleccionarODesmarcarTodo(this,'chkSeleccion');" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkSeleccion" runat="server" OnCheckedChanged="OnCheckChangedEvent">
                            </asp:CheckBox>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                    <asp:BoundField DataField="nombreTipoServicio" HeaderText="Tipo Servicio" />
                    <asp:BoundField DataField="nombre" HeaderText="Empresa" />
                    <asp:BoundField DataField="identificacion" HeaderText="Identificación" />
                    <asp:BoundField DataField="nombreAutorizado" HeaderText="Contacto" />
                    <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                    <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                    <asp:BoundField DataField="CantidadSIMs" HeaderText="Cant. SIMs">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CantidadTelefonos" HeaderText="Cant. Teléfonos">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" />
                    <asp:BoundField DataField="idJornada" HeaderText="idJornada" Visible="false" />
                    <asp:BoundField DataField="Jornada" HeaderText="Jornada" />
                    <asp:TemplateField HeaderText="Entrega Transp." ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:CheckBox ID="cbEntTrasnp" runat="server" Checked='<%# Bind("entregaTransportadora") %>'
                                Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="tercero" HeaderText="Resp. Entrega" />
                    <asp:BoundField DataField="idTercero" HeaderText="Id Resp." />
                    <asp:BoundField DataField="idtercero2" HeaderText="C.C. Resp. Entrega" />
                </Columns>
            </asp:GridView>
        </asp:Panel>
        <eo:Dialog runat="server" ID="dlgNovedad" ControlSkinID="None" Height="170px" Width="400px"
            HeaderHtml="Adici&oacute;n de Novedades" CloseButtonUrl="00020312" BackColor="White"
            CancelButton="lbCerrarPopUp" BackShadeColor="Gray" BackShadeOpacity="50">
            <ContentTemplate>
                <table align="center" class="tabla">
                    <tr>
                        <th colspan="2">
                            INFORMACI&Oacute;N DE LA NOVEDAD
                        </th>
                    </tr>
                    <tr>
                        <td class="field" width="40%">
                            Seleccione tipo de Novedad:
                        </td>
                        <td width="60%">
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
                        <td class="field">
                            Comentario General:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacionNovedad" runat="server" TextMode="MultiLine" Rows="3"
                                Columns="50"></asp:TextBox>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvObservacionNovedad" runat="server" ErrorMessage="Indique la descripci&oacute;n general de la novedad, por favor"
                                    Display="Dynamic" ControlToValidate="txtObservacionNovedad" ValidationGroup="registroNovedad"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:LinkButton ID="lbRegistrar" runat="server" ValidationGroup="registroNovedad"
                                CssClass="submit">
                                <img src="../images/save_all.png" alt="" />&nbsp;Registrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp
                            <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="submit">
                                <img src="../images/close.gif" alt="" />&nbsp;Cancelar
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
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
