<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuscarCasoSAC.aspx.vb"
    Inherits="BPColSysOP.BuscarCasoSAC" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="../ControlesDeUsuario/ModalProgress.ascx" tagname="ModalProgress" tagprefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Buscar Caso SAC</title>

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, "") }

        function ValidarDatos(sorce, arguments) {
            try {
                switch (sorce.id) {
                    case "cusRango":
                        var fechaInicial = $("#txtFechaInicial").val();
                        var fechaFinal = $("#txtFechaFinal").val();
                        if ((fechaInicial != "" && fechaFinal == "") || (fechaInicial == "" && fechaFinal != "")) {
                            arguments.IsValid = false;
                        } else {
                            arguments.IsValid = true;
                        }
                        break;
                    case "cusSeleccion":
                        var noCaso = $("#txtNoCaso").val();
                        var claseCaso = $("#ddlClaseCaso").val();
                        var tipoCliente = $("#ddlTipoCliente").val();
                        var tipoCaso = $("#ddlTipoCaso").val();
                        var cliente = $("#ddlCliente").val();
                        var remitente = $("#ddlRemitente").val();
                        var generadorInconformidad = $("#ddlGeneradorInconformidad").val();
                        var tramitador = $("#ddlTramitador").val();
                        var estado = $("#ddlEstado").val();
                        var fechaInicial = $("#txtFechaInicial").val();
                        var fechaFinal = $("#txtFechaFinal").val();
                        if (noCaso.trim() == "" && claseCaso == "0" && tipoCliente == "0" && tipoCaso == "0" && cliente == "0"
                            && remitente == "0" && generadorInconformidad == "0" && tramitador == "0" && estado == "0"
                            && fechaInicial == "" && fechaFinal == "") {
                            arguments.IsValid = false;
                        } else {
                            arguments.IsValid = true;
                        }
                        break;
                    default:
                        arguments.IsValid = true;
                }
            } catch (e) {
                alert("Error al tratar de valida datos seleccionados.\n" + e.description);
                arguments.IsValid = false;
            }
        }
        
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="smAjaxManager" runat="server" EnableScriptGlobalization="true">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
            <uc1:EncabezadoPagina ID="epGeneral" runat="server" />
            <table class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1" cellspacing="1"
                style="width: 90%">
                <tr>
                    <th colspan="6">
                        Filtros de Búsqueda
                    </th>
                </tr>
                <tr>
                    <td class="field" style="width: 130px">
                        No. de Caso:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNoCaso" MaxLength="17" runat="server"></asp:TextBox>
                        <div>
                            <asp:RegularExpressionValidator ID="revNoCaso" runat="server" ValidationExpression="^([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])([a-zA-Z_0-9,\-\s\.áéíóúñÁÉÍÓÚÑ])*([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])*$"
                                Display="Dynamic" ControlToValidate="txtNoCaso" ValidationGroup="buscarCaso"
                                ErrorMessage="El No. de caso contiene caracteres no validos, por favor verifique."></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field">
                        Clases de Caso:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlClaseCaso" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Tipo de Caso:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoCaso" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        No. Radicado:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNoRadicado" MaxLength="9" runat="server"></asp:TextBox>
                        <div>
                            <asp:RegularExpressionValidator ID="revNoRadicado" runat="server" ValidationExpression="^([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])([a-zA-Z_0-9,\-\s\.áéíóúñÁÉÍÓÚÑ])*([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])*$"
                                Display="Dynamic" ControlToValidate="txtNoRadicado" ValidationGroup="buscarCaso"
                                ErrorMessage="El No. de radicado contiene caracteres no validos, por favor verifique."></asp:RegularExpressionValidator>
                        </div>
                    </td>
                    <td class="field">
                        Min:
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtMin" MaxLength="10" runat="server"></asp:TextBox>
                        <div>
                            <asp:RegularExpressionValidator ID="revMin" runat="server" ValidationExpression="^([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])([a-zA-Z_0-9,\-\s\.áéíóúñÁÉÍÓÚÑ])*([a-zA-Z_0-9áéíóúñÁÉÍÓÚÑ])*$"
                                Display="Dynamic" ControlToValidate="txtMin" ValidationGroup="buscarCaso"
                                ErrorMessage="El Min contiene caracteres no validos, por favor verifique."></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Tipo de Cliente:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoCliente" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Cliente:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCliente" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Remitente:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlRemitente" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Generador de Inconformidad:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlGeneradorInconformidad" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Tramitador:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTramitador" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td class="field">
                        Estado:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlEstado" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Fecha:
                    </td>
                    <td style="width: 230px">
                        <div style="display: inline">
                            <div style="display: inline">
                                <asp:TextBox ID="txtFechaInicial" runat="server" MaxLength="10" Width="80px" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="ceFechaInicial" runat="server" PopupButtonID="imgFechaIni"
                                    Format="dd/MM/yyyy" CssClass="calendarTheme" TargetControlID="txtFechaInicial">
                                </cc1:CalendarExtender>
                                <img src="../images/calendar.png" id="imgFechaIni" alt="Fecha Inicial" title="Fecha Inicial" />&nbsp;&nbsp;&nbsp;
                            </div>
                            <div style="display: inline">
                                <asp:TextBox ID="txtFechaFinal" runat="server" MaxLength="10" Width="80px" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtFechaFinal_CalendarExtender" runat="server" PopupButtonID="imgFechaFin"
                                    Format="dd/MM/yyyy" CssClass="calendarTheme" TargetControlID="txtFechaFinal">
                                </cc1:CalendarExtender>
                                <img src="../images/calendar.png" id="imgFechaFin" alt="Fecha Inicial" title="Fecha Final" />
                            </div>
                        </div>
                    </td>
                    <td class="field">
                        Tipo de Fecha:
                    </td>
                    <td colspan="3">
                        <asp:RadioButtonList ID="rblTipoFecha" runat="server" RepeatColumns="4" 
                            RepeatDirection="Horizontal">
                            <asp:ListItem Text="Fecha de Recepción" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Registro" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Respuesta" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Fecha de Cierre" Value="4"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <div style="display: block">
                            <asp:CompareValidator ID="cvRangoFecha" runat="server" ControlToCompare="txtFechaInicial"
                                ControlToValidate="txtFechaFinal" ErrorMessage="La Fecha Final debe ser mayor o igual a la Fecha Inicial"
                                Operator="GreaterThanEqual" Type="Date" Display="Dynamic" ValidationGroup="buscarCaso"></asp:CompareValidator>
                        </div>
                        <div style="display: block">
                            <asp:CustomValidator ID="cusRango" runat="server" ErrorMessage="Es necesario especificar los dos valores del Rango"
                                Display="Dynamic" ClientValidationFunction="ValidarDatos" ValidationGroup="buscarCaso"
                                ControlToValidate="txtFechaInicial"></asp:CustomValidator>
                        </div>
                        <asp:CustomValidator ID="cusSeleccion" runat="server" ErrorMessage="Seleccione un filtro de búsqueda, por favor"
                            ClientValidationFunction="ValidarDatos" ValidationGroup="buscarCaso" Display="Dynamic"
                            Enabled="false"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" align="center" style="margin-left: 40px;padding-bottom:10px;">
                        <br />
                        <asp:LinkButton ID="lbBuscar" runat="server" ValidationGroup="buscarCaso" CssClass="search"><img src="../images/find.gif" alt="" />&nbsp;Buscar </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search"><img src="../images/unfunnel.png" alt="" />&nbsp;Quitar Filtros</asp:LinkButton>
                    </td>
                </tr>
            </table>
            <asp:Panel ID="pnlReporte" runat="server">
                <asp:LinkButton ID="lbDescargarReporte" runat="server" ValidationGroup="descargarReporte" CssClass="search"><img src="../images/Excel.gif" alt="" />&nbsp;Descargar </asp:LinkButton>
            </asp:Panel>
            <br />
            <div style="margin-top: 20px;">
                <asp:Repeater ID="repCaso" runat="server">
                    <HeaderTemplate>
                        <table style="width: 98%;" class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1" cellspacing="1">
                            <tr>
                                <th>
                                    No. de Caso
                                </th>
                                <th>
                                    No. de Radicado
                                </th>
                                <th>
                                    Cliente
                                </th>
                                <th>
                                    Clase de Caso
                                </th>
                                <th>
                                    Tipo de Caso
                                </th>
                                <th>
                                    Remitente
                                </th>
                                <th>
                                    Tramitador
                                </th>
                                <th>
                                    Generador de Inconformidad
                                </th>
                                <th>
                                    Fecha Recepción
                                </th>
                                <th>
                                    Fecha Respuesta
                                </th>
                                <th>
                                    Estado
                                </th>
                                <th>
                                    Opc.
                                </th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <b>
                                    <%#Container.DataItem("Consecutivo")%></b>
                            </td>
                            <td>
                                <b>
                                    <%#Container.DataItem("ConsecutivoServicio")%></b>
                            </td>
                            <td>
                                <%#Container.DataItem("Cliente")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("ClaseDeServicio")%>
                            </td>
                            <td>
                                <%#Container.DataItem("TipoDeServicio")%>
                            </td>
                            <td>
                                <%#Container.DataItem("Remitente")%>
                            </td>
                            <td>
                                <%#Container.DataItem("Tramitador")%>
                            </td>
                            <td>
                                <%#Container.DataItem("GeneradorInconformidad")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("FechaDeRecepcion")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("FechaRespuesta")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("Estado")%>
                            </td>
                            <td align="center" valign="middle" rowspan="3">
                                <asp:ImageButton ID="ibVer" ImageUrl="~/images/view.png" ToolTip="Ver Información Detallada del Caso"
                                    runat="server" CommandName="Ver" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibEditar" ImageUrl="~/images/manager.png" ToolTip="Administrar Gestión"
                                    runat="server" CommandName="Editar" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibEditarCaso" ImageUrl="~/images/edit.gif" ToolTip="Editar Caso"
                                    runat="server" CommandName="EditarCaso" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibFinalizar" ImageUrl="~/images/save_all.png" ToolTip="Finalizar Caso"
                                    runat="server" CommandName="Finalizar" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Descripción:
                            </td>
                            <td colspan="10">
                                <%#Container.DataItem("Descripcion")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Observación:
                            </td>
                            <td colspan="10">
                                <%#Container.DataItem("Observacion")%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="12">
                                <hr />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="fondoGris">
                            <td>
                                <b>
                                    <%#Container.DataItem("Consecutivo")%></b>
                            </td>
                            <td>
                                <b>
                                    <%#Container.DataItem("ConsecutivoServicio")%></b>
                            </td>
                            <td>
                                <%#Container.DataItem("Cliente")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("ClaseDeServicio")%>
                            </td>
                            <td>
                                <%#Container.DataItem("TipoDeServicio")%>
                            </td>
                            <td>
                                <%#Container.DataItem("Remitente")%>
                            </td>
                            <td>
                                <%#Container.DataItem("Tramitador")%>
                            </td>
                            <td>
                                <%#Container.DataItem("GeneradorInconformidad")%>
                            </td>
                            <td>
                                <%#Container.DataItem("FechaDeRecepcion")%>
                            </td>
                            <td>
                                <%#Container.DataItem("FechaRespuesta")%>
                            </td>
                            <td align="center">
                                <%#Container.DataItem("Estado")%>
                            </td>
                            <td align="center" valign="middle" rowspan="3">
                                <asp:ImageButton ID="ibVer" ImageUrl="~/images/view.png" ToolTip="Ver Información Detallada del Caso"
                                    runat="server" CommandName="Ver" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibEditar" ImageUrl="~/images/manager.png" ToolTip="Administrar Gestión"
                                    runat="server" CommandName="Editar" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibEditarCaso" ImageUrl="~/images/edit.gif" ToolTip="Editar Caso"
                                    runat="server" CommandName="EditarCaso" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                                <asp:ImageButton ID="ibFinalizar" ImageUrl="~/images/save_all.png" ToolTip="Finalizar Caso"
                                    runat="server" CommandName="Finalizar" CommandArgument='<%#Container.DataItem("IdCaso")%>' />
                            </td>
                        </tr>
                        <tr class="fondoGris">
                            <td class="field">
                                Descripción:
                            </td>
                            <td colspan="10">
                                <%#Container.DataItem("Descripcion")%>
                            </td>
                        </tr>
                        <tr class="fondoGris">
                            <td class="field">
                                Observación:
                            </td>
                            <td colspan="10">
                                <%#Container.DataItem("Observacion")%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="12">
                                <hr />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </ContentTemplate>
        <Triggers >
            <asp:PostBackTrigger ControlID="lbDescargarReporte" />
        </Triggers>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    <script language="javascript" type="text/javascript">
        ValidatorHookupControlID('<% = txtFechaFinal.ClientID %>', document.getElementById('<% = cusRango.ClientID%>'));
    </script>
    </form>
</body>
</html>
