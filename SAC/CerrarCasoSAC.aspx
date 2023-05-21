<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CerrarCasoSAC.aspx.vb"
    Inherits="BPColSysOP.CerrarCasoSAC" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cerrar Caso SAC</title>

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .style1
        {
            font-family: Helvetica, Arial, sans-serif;
            font-weight: bolder;
            color: #333333;
            background-color: #E6E6E6;
        }
    </style>

    <script type="text/javascript" language="javascript">
        function EsFechaRespuestaValida(source, args) {
            try {
                var fechaGestion = new Date(document.getElementById("hfMaxFechaGestion").value);
                var fechaRespuesta = eo_GetObject("dpFechaRespuesta").getSelectedDate();
                if (fechaRespuesta.valueOf() >= fechaGestion.valueOf()) {
                    var fechaActual = new Date();
                    if (fechaRespuesta.valueOf() <= fechaActual.valueOf()) {
                        args.IsValid = true;
                    } else {
                        args.IsValid = false;
                        source.innerHTML = "La fecha de respuesta no puede ser mayor que la fecha actual.";
                    }
                } else {
                    args.IsValid = false;
                    source.innerHTML = "La fecha de respuesta no puede ser menor que la máxima fecha de gestión."
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar selección de fecha de respuesta.\n" + e.description);
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
            <asp:Panel ID="pnlDatosCaso" runat="server">
                <table style="width: 90%;" class="tabla" border="1" bordercolor="#f0f0f0" cellspacing="1"
                    cellpadding="1">
                    <tr>
                        <th colspan="6">
                            Información General del Caso
                        </th>
                    </tr>
                    <tr>
                        <td class="field">
                            No. de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblNoCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblCliente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Recepción:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRecepcion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Clase de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblClaseCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Tipo de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblTipoCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Estado:
                        </td>
                        <td>
                            <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1">
                            Remitente:
                        </td>
                        <td>
                            <asp:Label ID="lblRemitente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="style1">
                            Tramitador:
                        </td>
                        <td>
                            <asp:Label ID="lblTramitador" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="style1">
                            Fecha Respuesta:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRespuesta" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Descripcion:
                        </td>
                        <td colspan="5">
                            <asp:Label ID="lblDescripcion" runat="server" Text=""></asp:Label>
                            <asp:HiddenField ID="hIdCaso" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Observación:
                        </td>
                        <td colspan="5">
                            <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlGestionRealizada" runat="server">
                <table class="tabla" style="width: 90%">
                    <tr>
                        <th>
                            Información de Gestión del Caso
                        </th>
                    </tr>
                    <tr>
                        <td>
                            <asp:Repeater ID="repInfoGestion" runat="server">
                                <HeaderTemplate>
                                    <table style="width: 100%;" class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1"
                                        cellspacing="1">
                                        <tr>
                                            <td class="field">
                                                Tipo Gestión
                                            </td>
                                            <td class="field">
                                                Cliente
                                            </td>
                                            <td class="field">
                                                Gestionador
                                            </td>
                                            <td class="field">
                                                Fecha Gestión
                                            </td>
                                            <td class="field">
                                                Respuesta
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%#Container.DataItem("TipoGestion")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cliente")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Gestionador")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("FechaDeGestion")%>
                                        </td>
                                        <td rowspan="2">
                                            <asp:GridView ID="gvRespuestaRegistrada" runat="server" AutoGenerateColumns="False"
                                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado respuestas&lt;/i&gt;&lt;/blockquote&gt;"
                                                OnRowDataBound="gvRespuestaRegistrada_RowDataBound" OnRowCommand="gvRespuestaRegistrada_RowCommand">
                                                <Columns>
                                                    <asp:BoundField DataField="OrigenRespuesta" HeaderText="Origen Respuesta" />
                                                    <asp:BoundField DataField="NombreArchivoOriginal" HeaderText="Archivo de Respuesta" />
                                                    <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha de Respuesta" />
                                                    <asp:TemplateField HeaderText="Opc.">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibDescargar" ImageUrl="~/images/descargar.png" CommandName="Descargar"
                                                                CommandArgument='<%#Bind("NombreArchivoConRuta") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Descripción:
                                        </td>
                                        <td colspan="4">
                                            <%#Container.DataItem("Descripcion")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <hr />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr class="fondoGris">
                                        <td>
                                            <%#Container.DataItem("TipoGestion")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cliente")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Gestionador")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("FechaDeGestion")%>
                                        </td>
                                        <td rowspan="2">
                                            <asp:GridView ID="gvRespuestaRegistrada" runat="server" AutoGenerateColumns="False"
                                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado respuestas&lt;/i&gt;&lt;/blockquote&gt;"
                                                OnRowDataBound="gvRespuestaRegistrada_RowDataBound" OnRowCommand="gvRespuestaRegistrada_RowCommand">
                                                <Columns>
                                                    <asp:BoundField DataField="OrigenRespuesta" HeaderText="Origen Respuesta" />
                                                    <asp:BoundField DataField="NombreArchivoOriginal" HeaderText="Archivo de Respuesta" />
                                                    <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha de Respuesta" />
                                                    <asp:TemplateField HeaderText="Opc.">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibDescargar" ImageUrl="~/images/descargar.png" CommandName="Descargar"
                                                                CommandArgument='<%#Bind("NombreArchivoConRuta") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr class="fondoGris">
                                        <td class="field">
                                            Descripción:
                                        </td>
                                        <td colspan="4">
                                            <%#Container.DataItem("Descripcion")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <hr />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:Literal ID="ltAux" runat="server" Text="&lt;blockquote&gt;&lt;i&gt;No existe gestión registrada para el Caso actual&lt;/i&gt;&lt;/blockquote&gt;"></asp:Literal>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlCerrarCaso" runat="server">
                <table class="tabla" style="width: 90%">
                    <tr>
                        <th colspan="2">
                            Datos de Finalización del Caso
                        </th>
                    </tr>
                    <tr>
                        <td class="field" style="width: 180px;">
                            Respuesta:
                        </td>
                        <td>
                            <asp:TextBox ID="txtRespuesta" runat="server" TextMode="MultiLine" Columns="100"
                                Rows="3"></asp:TextBox>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvRespuesta" runat="server" ErrorMessage="Digite la respuesta final del caso, por favor"
                                    ControlToValidate="txtRespuesta" Display="Dynamic" ValidationGroup="finalizarCaso"></asp:RequiredFieldValidator>
                            </div>
                            <div style="display: block">
                                <asp:RegularExpressionValidator ID="revRespuesta" runat="server" ValidationExpression="(.|\n){0,2000}"
                                    Display="Dynamic" ValidationGroup="finalizarCaso" ControlToValidate="txtRespuesta"
                                    ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha de Respuesta:
                        </td>
                        <td>
                            <eo:DatePicker ID="dpFechaRespuesta" runat="server" DayCellHeight="15" SelectedDates=""
                                DisabledDates="" PopupDownImageUrl="~/images/calendar.png" PopupImageUrl="~/images/calendar.png"
                                OtherMonthDayVisible="True" MonthSelectorVisible="True" WaitMessage="Cargando..."
                                DayHeaderFormat="Short" TitleFormat="MMMM, yyyy" PickerFormat="dd/MM/yyyy HH:mm"
                                TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                                DayCellWidth="31" PopupHoverImageUrl="~/images/calendar.png" ControlSkinID="None"
                                PickerHint="" PopupExpandDirection="Auto">
                                <TodayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040401');color:#1176db;">
                                </TodayStyle>
                                <SelectedDayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040403');color:Brown;">
                                </SelectedDayStyle>
                                <DisabledDayStyle CssText="font-family:Verdana;font-size:8pt;color: gray"></DisabledDayStyle>
                                <FooterTemplate>
                                    <table style="font-size: 11px; font-family: Verdana" border="0" cellspacing="5" cellpadding="0">
                                        <tr>
                                            <td width="30">
                                            </td>
                                            <td valign="center">
                                                <img src="{img:00040401}">
                                            </td>
                                            <td valign="center">
                                                Today: {var:today:dd/MM/yyyy}
                                            </td>
                                        </tr>
                                    </table>
                                </FooterTemplate>
                                <MonthSelectorStyle CssText=""></MonthSelectorStyle>
                                <CalendarStyle CssText="background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;">
                                </CalendarStyle>
                                <TitleArrowStyle CssText="cursor: hand"></TitleArrowStyle>
                                <DayHoverStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040402');color:#1c7cdc;">
                                </DayHoverStyle>
                                <MonthStyle CssText="cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px;">
                                </MonthStyle>
                                <TitleStyle CssText="font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;">
                                </TitleStyle>
                                <DayHeaderStyle CssText="font-family:Verdana;font-size:8pt;border-bottom: #f5f5f5 1px solid">
                                </DayHeaderStyle>
                                <DayStyle CssText="font-family:Verdana;font-size:8pt;"></DayStyle>
                            </eo:DatePicker>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvFechaRespuesta" runat="server" ErrorMessage="Fecha de Respuesta requerida. Especifique la fecha de respuesta, por favor"
                                    ValidationGroup="finalizarCaso" Display="Dynamic" ControlToValidate="dpFechaRespuesta"></asp:RequiredFieldValidator>
                            </div>
                            <div style="display: block">
                                <asp:CustomValidator ID="cusFechaRespuesta" runat="server" ErrorMessage="La fecha de respuesta no puede ser mayor que la fecha actual."
                                    ValidationGroup="finalizarCaso" Display="Dynamic" ClientValidationFunction="EsFechaRespuestaValida"
                                    ControlToValidate="dpFechaRespuesta"></asp:CustomValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Incoformidad Generada Por:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlGeneradorInconformidad" runat="server">
                            </asp:DropDownList>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvGeneradorInconformidad" runat="server" ErrorMessage="Generador de Inconformidad Requerido. Seleccione un registro, Por favor"
                                    ControlToValidate="ddlGeneradorInconformidad" Display="Dynamic" InitialValue="0"
                                    ValidationGroup="finalizarCaso"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Generó Cobro?:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlGeneroCobro" runat="server" AutoPostBack="True">
                                <asp:ListItem Text="Seleccione una Opción" Value=""></asp:ListItem>
                                <asp:ListItem Text="SI" Value="1"></asp:ListItem>
                                <asp:ListItem Text="NO" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvGeneroCobro" runat="server" ErrorMessage="Por favor indique si se generó o no cobro"
                                    ControlToValidate="ddlGeneroCobro" Display="Dynamic" ValidationGroup="finalizarCaso"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr id="trValorCobro" runat="server">
                        <td class="field">
                            Valor Cobro:
                        </td>
                        <td>
                            <asp:TextBox ID="txtValorCobro" runat="server"></asp:TextBox>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvValorCobro" runat="server" ErrorMessage="Digite el valor del cobro generado, por favor"
                                    ControlToValidate="txtValorCobro" Display="Dynamic" ValidationGroup="finalizarCaso"></asp:RequiredFieldValidator>
                            </div>
                            <div style="display: block">
                                <asp:CompareValidator ID="cvValorCobro" runat="server" ErrorMessage="El valor proporcionado no es valido, Por favor verifique"
                                    Display="Dynamic" ValidationGroup="finalizarCaso" ControlToValidate="txtValorCobro"
                                    Operator="DataTypeCheck" Type="Double"></asp:CompareValidator>
                            </div>
                        </td>
                    </tr>
                    <tr id="trResponsableCobro" runat="server">
                        <td class="field">
                            Responsable Cobro:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlResponsableCobro" runat="server">
                            </asp:DropDownList>
                            <div style="display: block">
                                <asp:RequiredFieldValidator ID="rfvResponsableCobro" runat="server" ErrorMessage="Seleccion el responsable del cobro, por favor"
                                    ControlToValidate="ddlResponsableCobro" Display="Dynamic" ValidationGroup="finalizarCaso"
                                    InitialValue="0"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <br />
                            <asp:HiddenField ID="hfMaxFechaGestion" runat="server" />
                            <asp:Button ID="btnCerrar" runat="server" Text="Cerrar" CssClass="submit" ValidationGroup="finalizarCaso"
                                OnClientClick="try{if(!confirm('¿Realmente desea cerrar el caso?')){return false;}}catch(e){alert('Error al solicitar confirmación.\n' + e.description); return false;};" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    </form>
</body>
</html>
