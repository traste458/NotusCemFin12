<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaRutaMensajeria_prueba.aspx.vb"
    Inherits="BPColSysOP.ConsultaRutaMensajeria_prueba" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta Ruta Sercicio Mensajeria</title>

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            height: 25px;
        }
    </style>

    <script type="text/javascript" language="javascript">
        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                //alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }

        }

        function MostrarOcultarDivFloater(mostrar) {
            if (mostrar)
                $("#divFloater").show();
            else
                $("#divFloater").hide();
            //            var valorDisplay = mostrar ? "block" : "none";
            //            var elDiv = document.getElementById("divFloater");
            //            elDiv.style.display = valorDisplay;
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

        function validarVacios(source, arguments) {
            try {
                var idRuta = $("#txtIdRuta").val();
                var idMoto = $("#ddlMoto").val();
                var idEstado = $("#ddlEstado").val();
                var fechaInicial = $("#txtFechaInicial").val().trim().toString();
                var fechaFinal = $("#txtFechaFinal").val().trim().toString();

                if (idRuta == "" && idMoto == "0" && idEstado == "0" && fechaInicial == "" && fechaFinal == "") {
                    arguments.IsValid = false;
                } else {
                    arguments.IsValid = true;
                }
            } catch (e) {
                alert("Error =" + e.Message);
                arguments.IsValid = false;
            }
        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <div>
         <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="300"
            EnableScriptGlobalization="True" EnablePageMethods="True">
        </asp:ScriptManager>

    <eo:CallbackPanel ID="cpNotificacion" runat="server" Width="100%" UpdateMode="Always">
        <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
    </eo:CallbackPanel>
      <asp:Panel ID="pnlFiltros" runat="server">
    
    <table class="tablaGris" cellpadding="1" style="width: 700px;">
        <tr>
            <th colspan="4" align="left">
                Filtro:
            </th>
        </tr>
        <tr>
            <td>
                Id. Ruta:
            </td>
            <td>
                <asp:TextBox ID="txtIdRuta" runat="server" MaxLength="8" ValidationGroup="buscarRuta"></asp:TextBox>
                <div>
                    <asp:RegularExpressionValidator ID="rglIdRuta" runat="server" ErrorMessage="El campo id Ruta es numérico. Digite un número válido, por favor"
                        ControlToValidate="txtIdRuta" Display="Dynamic" ValidationExpression="[0-9]+"></asp:RegularExpressionValidator>
                </div>
            </td>
            <td>
                Estado:
            </td>
            <td>
                <asp:DropDownList ID="ddlEstado" runat="server" ValidationGroup="buscarRuta">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                Id. Moto:
            </td>
            <td colspan="3" valign="bottom">
                <asp:TextBox ID="txtFiltroMoto" runat="server" MaxLength="15" onkeyup="FiltrarEOPanel(this.id, 1, 'filtrarMoto');"></asp:TextBox>
                <eo:CallbackPanel ID="cpFiltroMoto" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                    Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle" GroupName="generalFiltro">
                    <div style="display: block">
                        <asp:Label ID="lblMoto" runat="server" CssClass="comentario"></asp:Label>
                        <asp:HiddenField ID="hfMoto" runat="server" />
                    </div>
                    <asp:DropDownList ID="ddlMoto" runat="server" Style="display: inline;" ValidationGroup="buscarRuta">
                    </asp:DropDownList>
                </eo:CallbackPanel>
                <div id="divFloater" style="display: none; position: static; height: 35px; width: 200px;">
                    <table align="center">
                        <tr>
                            <td align="center" valign="middle" style="height: 100%">
                                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                                <b>Procesando...</b>
                            </td>
                        </tr>
                    </table>
                </div>
                <asp:HiddenField ID="hfFlagFiltroMoto" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table style="padding: 0px !important">
                    <tr>
                        <td>
                            Fecha Inicio:&nbsp;&nbsp;
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
                            Fecha Fin:&nbsp;&nbsp;
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
                Jornada:
                <asp:DropDownList ID="ddlJornada" runat="server" ValidationGroup="buscarRuta">
                </asp:DropDownList>
            </td>
        </tr>
        <tr runat="server" id="trFiltroCiudad">
            <td colspan="4">
                Ciudad:<asp:DropDownList ID="ddlCiudad" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td colspan="4" align="center">
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="search" ValidationGroup="buscarRuta" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnBorrarFiltro" runat="server" Text="Cancelar" CssClass="search" />
                <div>
                    <asp:CustomValidator ID="cvValidarVacios" runat="server" ErrorMessage="Seleccione un filtro de búsqueda"
                        ClientValidationFunction="validarVacios" ValidationGroup="buscarRuta"></asp:CustomValidator>
                </div>
            </td>
        </tr>
    </table>
   <%-- <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        UpdateMode="Group" GroupName="generalPrincipal" LoadingDialogID="ldrWait_dlgWait">--%>
         <%--<asp:UpdatePanel ID="pnlDatos" runat="server">
            <ContentTemplate>--%>
        <asp:GridView ID="gvDatos" runat="server" CssClass="tablaGris" Style="margin-top: 10px;
            width: 700px;" AutoGenerateColumns="False" EnableModelValidation="True" EmptyDataText="&lt;b&gt;No se encontraron rutas.&lt;/b&gt;"
            AllowPaging="True" PageSize="60" ShowFooter="True" DataKeyNames="idRuta">
            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
            <PagerStyle CssClass="field" HorizontalAlign="Center" />
            <Columns>
                <asp:BoundField DataField="idRuta" HeaderText="Id. Ruta">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="TipoRuta" HeaderText="Tipo" />
                <asp:BoundField DataField="responsable" HeaderText="Responsable" />
                <asp:BoundField DataField="telefono" HeaderText="Tel. Responsable">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="fechaCreacion" HeaderText="Fecha Creación">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="fechaSalida" HeaderText="Fecha Salida">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="fechaCierre" HeaderText="Fecha Cierre">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="estado" HeaderText="Estado">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="jornada" HeaderText="Jornada">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Ciudad" HeaderText="Bodega" />
                <asp:TemplateField HeaderText="Opc.">
                    <ItemTemplate>
                        <asp:ImageButton ID="imgEditarRuta" runat="server" ToolTip="Editar Ruta" CommandName="EditarRuta"
                            CommandArgument='<%# Bind("idRuta") %>' ImageUrl="~/images/Edit-32.png" />
                        <asp:ImageButton ID="imgVerRadicados" runat="server" ToolTip="Ver Radicados" CommandName="VerRadicados"
                            CommandArgument='<%# Bind("idRuta") %>' ImageUrl="~/images/view.png" />
                        <asp:ImageButton ID="imgVerRuta" runat="server" ToolTip="Ver Ruta" CommandName="VerRuta"
                            CommandArgument='<%# Bind("idRuta") %>' ImageUrl="~/images/pdf.png" />
                        <asp:ImageButton ID="imgVerRutaSerializada" runat="server" ToolTip="Ver Ruta Serializada"
                            CommandName="VerRutaSerializada" CommandArgument='<%# Bind("idRuta") %>' ImageUrl="~/images/new.png" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
       <%--  </ContentTemplate>
        </asp:UpdatePanel>--%>
        <eo:Dialog runat="server" ID="dlgSerial" ControlSkinID="None" HeaderHtml="Detalle de Radicados"
            CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
            <ContentTemplate>
                <table align="center" class="tabla">
                    <tr>
                        <td>
                            <asp:GridView ID="gvVerRadicados" runat="server" Width="100%" AutoGenerateColumns="false"
                                ShowFooter="true" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="numeroRadicado" HeaderText="No. Radicado" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="secuencia" HeaderText="Secuencia" />
                                    <asp:BoundField DataField="estado" HeaderText="Estado" />
                                    <asp:BoundField DataField="CantTelefonos" HeaderText="Cant. Telefonos" />
                                    <asp:BoundField DataField="CantSims" HeaderText="Cant. Sims" />
                                    <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agendamiento" />
                                </Columns>
                                <FooterStyle CssClass="field" />
                            </asp:GridView>
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
<%--    </eo:CallbackPanel>--%>
    
      </asp:Panel>
</div>
    <uc2:Loader ID="ldrWait" runat="server" />
    <!-- iframe para uso de selector de fechas -->
    <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible;
        position: absolute; top: -500px" name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
        frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>
