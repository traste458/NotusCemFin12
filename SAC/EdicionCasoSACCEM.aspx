<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EdicionCasoSACCEM.aspx.vb"
    Inherits="BPColSysOP.EdicionCasoSACCEM" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registrar Gestión de Caso SAC</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
        function EsFechaValida(source, args) {
            try {
                var fechaSeleccionada = eo_GetObject("dpFechaRecepcion").getSelectedDate();
                if (fechaSeleccionada != null) {
                    if (IsDate(fechaSeleccionada)) {
                        var fechaActual = new Date();
                        if (fechaSeleccionada.valueOf() <= fechaActual.valueOf()) {
                            //alert(fechaActual.valueOf() + ' > ' + fechaSeleccionada.valueOf())
                            args.IsValid = true;
                        } else {
                            args.IsValid = false;
                            source.innerHTML = "La fecha de recepción no puede ser mayor que la fecha actual.";
                        }
                    } else {
                        args.IsValid = false;
                        source.innerHTML = "La fecha proporcionada no es válida. Por favor verifique"
                    }
                } else { args.IsValid = true; }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar Fecha.\n" + e.description);
            }
        }
        
        function EsFechaGestionValida(source, args) {
            try {
                var fechaSeleccionada = eo_GetObject("dpFechaGestion").getSelectedDate();
                if (fechaSeleccionada != null) {
                    var sFechaRecepcion = document.getElementById("hfFechaRecepcion").value;
                    var fechaRecepcion = new Date(sFechaRecepcion);
                    if (fechaSeleccionada.valueOf() >= fechaRecepcion.valueOf()) {
                        var esValida = true;
                        var mensaje = "";
                        var fechaActual = new Date();
                        if (fechaSeleccionada.valueOf() > fechaActual.valueOf()) {
                            esValida = false;
                            mensaje = "La fecha de gestión no puede ser mayor que la fecha actual.";
                        }
                        if (esValida) {
                            var minFechaRespuesta = document.getElementById("hfMinFechaRespuesta").value;
                            if (minFechaRespuesta.length > 0) {
                                var fechaRespuesta = new Date(minFechaRespuesta)
                                if (fechaSeleccionada.valueOf() > fechaRespuesta.valueOf()) {
                                    esValida = false;
                                    mensaje = "La fecha de gestión debe ser menor que todas las fechas de respuesta registradas."
                                }
                            }
                        }
                        args.IsValid = esValida
                        if (!esValida) { source.innerHTML = mensaje; }
                    } else {
                        args.IsValid = false;
                        source.innerHTML = "La fecha de gestión no puede ser menor que la fecha de recepción del caso.";
                    }
                } else { args.IsValid = true; }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar Fecha.\n" + e.description);
            }
        }

        function ExisteFechaGestion(source, args) {
            try {
                var fechaRespuesta = eo_GetObject("dpFechaRespuesta").getSelectedDate();
                if (fechaRespuesta != null) {
                    var fechaGestion = eo_GetObject("dpFechaGestion").getSelectedDate();

                    if (fechaGestion != null) {
                        args.IsValid = true;
                    } else {
                        args.IsValid = false;
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar selección de fecha de gestión.\n" + e.description);
            }
        }

        function EsFechaRespuestaValida(source, args) {
            try {
                var fechaGestion = eo_GetObject("dpFechaGestion").getSelectedDate();
                var fechaRespuesta = eo_GetObject("dpFechaRespuesta").getSelectedDate();
                if (fechaGestion != null && fechaRespuesta != null) {
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
                        source.innerHTML = "La fecha de respuesta no puede ser menor que la fecha de gestión."
                    }
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar selección de fecha de respuesta.\n" + e.description);
            }
        }

        function MostrarPopUp(popUpId, titulo, url) {
            var dlg = eo_GetObject(popUpId);
            dlg.setCaption("<b>" + titulo + "</b>");
            if (url.length > 0) { dlg.setContentUrl(url); }
            dlg.show(true);
            return (false);
        }

        function ActualizarListaFuncionario() {
            try {
                eo_Callback("cpFuncionario", "actualizarListado");
            } catch (e) {
                alert("Error al tratar de actualizar listado.\n" + e.description);
            }
        }

        function ExisteRespuesta(source, args) {
            try {
                var numRespuestas = parseInt(document.getElementById('hfNumRespuestas').value);
                if (numRespuestas > 0) {
                    args.IsValid = true;
                } else {
                    args.IsValid = false;
                }
            } catch (e) {
                alert("Error al tratar de validar adición de respuestas.\n" + e.description);
                args.IsValid = false;
            }
        }
       
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <eo:CallbackPanel ID="cpEncabezado" runat="server" GroupName="general" style="width:98%">
        <uc1:EncabezadoPagina ID="epGeneral" runat="server" />
    </eo:CallbackPanel>
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
                    <eo:DatePicker ID="dpFechaRecepcion" runat="server" DayCellHeight="15" SelectedDates=""
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
                        <asp:RequiredFieldValidator ID="rfvFechaRecepcion" runat="server" ErrorMessage="Fecha de recepción requerida. Proporcione la fecha de recepción del caso, por favor. "
                            ControlToValidate="dpFechaRecepcion" Display="Dynamic" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                    <div style="display: block">
                        <asp:CustomValidator ID="cusFechaRecepcion" runat="server" ErrorMessage="La fecha de recepción no puede ser mayor que la fecha actual."
                            ControlToValidate="dpFechaRecepcion" ValidationGroup="formularioGeneral" Display="Dynamic"
                            ClientValidationFunction="EsFechaValida"></asp:CustomValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Clase de Caso:
                </td>
                <td>
                    <asp:DropDownList ID="ddlClaseCaso" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvClaseDeCaso" runat="server" ErrorMessage="Clase de Caso Requerida. Seleccione una Clase de Caso, Por favor"
                            ControlToValidate="ddlClaseCaso" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
                <td class="field">
                    Tipo de Caso:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipoCaso" runat="server">
                    </asp:DropDownList>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvTipoDeCaso" runat="server" ErrorMessage="Tipo de Caso Requerido. Seleccione un Tipo de Caso, Por favor"
                            ControlToValidate="ddlTipoCaso" Display="Dynamic" InitialValue="0" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                </td>
                <td class="field">
                    Estado:
                </td>
                <td>
                    <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Remitente:
                </td>
                <td>
                    <asp:Label ID="lblRemitente" runat="server" Text=""></asp:Label>
                </td>
                <td class="field">
                    Tramitador:
                </td>
                <td>
                    <asp:Label ID="lblTramitador" runat="server" Text=""></asp:Label>
                </td>
                <td class="field">
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
                    <asp:TextBox ID="txtDescripcionCaso" runat="server" Columns="70" Rows="4" TextMode="MultiLine"></asp:TextBox>
                    <div style="display: block">
                        <asp:RequiredFieldValidator ID="rfvDescripcionCaso" runat="server" ErrorMessage="Digite la descripción del Caso, Por favor"
                            ControlToValidate="txtDescripcionCaso" Display="Dynamic" ValidationGroup="formularioGeneral"></asp:RequiredFieldValidator>
                    </div>
                    <div style="display: block">
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationExpression="(.|\n){0,2000}"
                            Display="Dynamic" ValidationGroup="formularioGeneral" ControlToValidate="txtDescripcion"
                            ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                    </div>
                    <asp:HiddenField ID="hIdCaso" runat="server" />
                    <asp:HiddenField ID="hfFechaRecepcion" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="field">
                    Observación:
                </td>
                <td colspan="5">
                    <asp:TextBox ID="txtObservacion" runat="server" Columns="70" Rows="4" TextMode="MultiLine"></asp:TextBox>
                    <div style="display: block">
                        <asp:RegularExpressionValidator ID="revObservaciones" runat="server" ValidationExpression="(.|\n){0,2000}"
                            Display="Dynamic" ValidationGroup="formularioGeneral" ControlToValidate="txtObservacion"
                            ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                    </div>
                </td>
            </tr>
            <tr id="trCerrarCaso" runat="server" style="height:40px;">
                <td colspan="6" align="center">
                    <asp:LinkButton ID="lbCerrarCaso" runat="server" ToolTip="Ir a Cerrar Caso" Font-Bold="true"
                        CssClass="search" ><img src="../images/save_all.png" alt="" />&nbsp;Ir a Cerrar Caso</asp:LinkButton>
                    <asp:LinkButton ID="lbEditarCaso" runat="server" ToolTip="Editar Caso" Font-Bold="true" ValidationGroup="formularioGeneral"
                        CssClass="search" ><img src="../images/edit.gif" alt="Editar Caso" />&nbsp;Editar</asp:LinkButton>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br />
    <eo:CallbackPanel ID="cpGestion" runat="server" GroupName="general" 
        AutoDisableContents="True" LoadingDialogID="ldrWait_dlgWait"
        Triggers="{ControlID:ddlTipoGestion;Parameter:},{ControlID:rblOrigenRespuesta;Parameter:}" style="width: 90%">
        <asp:Panel ID="pnlAdicionGestion" runat="server">
            <table style="width: 100%; margin-right: 0px;" class="tabla" border="1" bordercolor="#f0f0f0"
                cellpadding="1" cellspacing="1">
                <tr>
                    <th colspan="6">
                        Formulario de Adición de Gestión
                    </th>
                </tr>
                <tr>
                    <td class="field" style="width: 120px;">
                        Tipo de Gestión:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoGestion" runat="server" ValidationGroup="registrarGestion"
                            AutoPostBack="True">
                        </asp:DropDownList>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvTipoGestion" runat="server" ErrorMessage="Seleccione el tipo de gestión, por favor."
                                InitialValue="0" ValidationGroup="registrarGestion" Display="Dynamic" ControlToValidate="ddlTipoGestion"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                    <td class="field" style="width: 100px;">
                        Cliente:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCliente" runat="server" ValidationGroup="registrarGestion">
                        </asp:DropDownList>
                        <div>
                            <asp:RequiredFieldValidator ID="revCliente" runat="server" ControlToValidate="ddlCliente"
                                Display="Dynamic" ErrorMessage="Seleccione el cliente, por favor." InitialValue="0"
                                ValidationGroup="registrarGestion"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                    <td class="field" style="width: 100px;">
                        Funcionario:
                    </td>
                    <td>
                        <div style="display: inline">
                            <eo:CallbackPanel ID="cpFuncionario" runat="server" ChildrenAsTriggers="true">
                                <asp:DropDownList ID="ddlFuncionario" runat="server" ValidationGroup="registrarGestion">
                                </asp:DropDownList>
                                &nbsp;
                                <asp:ImageButton ID="ibCrearFuncionario" runat="server" ToolTip="Adicionar funcionario"
                                    ImageUrl="~/images/add_user.png" Style="vertical-align: middle !important" OnClientClick="return MostrarPopUp('dlgPopUp', 'Creación de Nuevo Funcionario', 'CrearUsuarioModuloSAC.aspx');" />
                            </eo:CallbackPanel>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="revFuncionario" runat="server" ControlToValidate="ddlFuncionario"
                                Display="Dynamic" ErrorMessage="Seleccione el funcionario, por favor." InitialValue="0"
                                ValidationGroup="registrarGestion"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="field" style="width: 100px;">
                        Descripción:
                    </td>
                    <td colspan="5">
                        <asp:TextBox ID="txtDescripcion" runat="server" Columns="100" Rows="3" TextMode="MultiLine"></asp:TextBox>
                        <div style="display: block">
                            <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ErrorMessage="Digite la descripción de la Gestión, Por favor"
                                ControlToValidate="txtDescripcion" Display="Dynamic" ValidationGroup="registrarGestion"></asp:RequiredFieldValidator>
                        </div>
                        <div style="display: block">
                            <asp:RegularExpressionValidator ID="revDescripcion" runat="server" ValidationExpression="(.|\n){0,2000}"
                                Display="Dynamic" ValidationGroup="registrarGestion" ControlToValidate="txtDescripcion"
                                ErrorMessage="Formato o longitud no válidos. Se espera un texto de máximo 2000 caracteres."></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="field" style="width: 100px;">
                        Fecha de Gestión:
                    </td>
                    <td colspan="5">
                        <eo:DatePicker ID="dpFechaGestion" runat="server" DayCellHeight="15" SelectedDates=""
                            DisabledDates="" PopupDownImageUrl="~/images/calendar.png" PopupImageUrl="~/images/calendar.png"
                            OtherMonthDayVisible="True" MonthSelectorVisible="True" WaitMessage="Cargando..."
                            DayHeaderFormat="Short" TitleFormat="MMMM, yyyy" 
                            PickerFormat="dd/MM/yyyy HH:mm" TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
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
                            <asp:RequiredFieldValidator ID="rfvFechaGestion" runat="server" ErrorMessage="Fecha de Gestión requerida. Especifique la fecha de gestión, por favor"
                                ValidationGroup="registrarGestion" Display="Dynamic" ControlToValidate="dpFechaGestion"></asp:RequiredFieldValidator>
                        </div>
                        <div style="display: block">
                            <asp:CustomValidator ID="cusFechaGestion" runat="server" ErrorMessage="La fecha de gestión no puede ser mayor que la fecha actual."
                                ValidationGroup="registrarGestion" Display="Dynamic" ClientValidationFunction="EsFechaGestionValida"></asp:CustomValidator>
                        </div>
                        <div style="display: block">
                            <asp:CustomValidator ID="cusSeleccionFechaGestion" runat="server" ErrorMessage="No se puede adicionar respuesta sin haber registrado fecha de Gestión"
                                ValidationGroup="registrarRespuesta" Display="Dynamic" ClientValidationFunction="ExisteFechaGestion"></asp:CustomValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Respuesta:
                    </td>
                    <td colspan="5">
                        <table>
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td class="field" style="width: 50px;">
                                                Origen:
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblOrigenRespuesta" runat="server" RepeatColumns="3" RepeatDirection="Horizontal"
                                                    AutoPostBack="True">
                                                </asp:RadioButtonList>
                                            </td>
                                            <td style="width: 30px">
                                                &nbsp;
                                            </td>
                                            <td class="field" style="width: 60px;">
                                                Archivo:
                                            </td>
                                            <td>
                                                <asp:FileUpload ID="fuArchivo" runat="server" />
                                            </td>
                                            <td style="width: 30px">
                                                &nbsp;
                                            </td>
                                            <td class="field" style="width: 120px;">
                                                Fecha Respuesta:
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
                                            </td>
                                            <td align="center" valign="middle">
                                                <asp:ImageButton ID="ibAdicionar" runat="server" ImageUrl="~/images/add.png" ToolTip="Adicionar Archivo de Respuesta"
                                                    ValidationGroup="registrarRespuesta" CssClass="search" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="9">
                                                <div style="display: block">
                                                    <asp:CustomValidator ID="cusAdicionRespuesta" runat="server" ErrorMessage="Debe proporcionar la información correspondiente a las respuestas de la gestión"
                                                        ValidationGroup="registrarGestion" Display="Dynamic" ClientValidationFunction="ExisteRespuesta">
                                                    </asp:CustomValidator>
                                                </div>
                                                <div style="display: block">
                                                    <asp:RequiredFieldValidator ID="rfvFechaRespuesta" runat="server" ErrorMessage="Fecha de Respuesta requerida. Especifique la fecha de respuesta, por favor"
                                                        ValidationGroup="registrarRespuesta" Display="Dynamic" ControlToValidate="dpFechaRespuesta"></asp:RequiredFieldValidator>
                                                </div>
                                                <div style="display: block">
                                                    <asp:CustomValidator ID="cusFechaRespuesta" runat="server" ErrorMessage="La fecha de respuesta no puede ser mayor que la fecha actual."
                                                        ValidationGroup="registrarRespuesta" Display="Dynamic" ClientValidationFunction="EsFechaRespuestaValida"
                                                        ControlToValidate="dpFechaRespuesta"></asp:CustomValidator>
                                                </div>
                                                <div style="display: block">
                                                    <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ControlToValidate="fuArchivo"
                                                        Display="Dynamic" Enabled="false" ErrorMessage="Seleccione el archivo que contiene la respuesta, Por favor"
                                                        ValidationGroup="registrarRespuesta"></asp:RequiredFieldValidator>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="gvRespuesta" runat="server" AutoGenerateColumns="False" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado respuestas&lt;/i&gt;&lt;/blockquote&gt;">
                                        <Columns>
                                            <asp:BoundField DataField="OrigenRespuesta" HeaderText="Origen Respuesta" />
                                            <asp:BoundField DataField="NombreArchivoOriginal" HeaderText="Archivo de Respuesta" />
                                            <asp:BoundField DataField="NombreArchivo" HeaderText="Archivo en Sistema" />
                                            <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha" />
                                            <asp:TemplateField HeaderText="Opc.">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="ibDescargar" ImageUrl="~/images/descargar.png" CommandName="Descargar"
                                                        CommandArgument='<%#Bind("NombreArchivoConRuta") %>' runat="server" />
                                                    <asp:ImageButton ID="ibEliminar" ImageUrl="~/images/cross.png" CommandName="Eliminar"
                                                        CommandArgument='<%#Bind("IdRespuesta") %>' runat="server" OnClientClick="try{return confirm('¿Realmente desea eliminar el archivo de respuesta?')}catch(e){alert('Error al solicitar confirmación.\n' + e.description); return false;};" />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                    <asp:HiddenField ID="hfMinFechaRespuesta" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="hfNumRespuestas" runat="server" Value="0" />
                    </td>
                </tr>
                <tr>
                    <td colspan="6" align="center">
                        <br />
                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="submit" ValidationGroup="registrarGestion" />
                        <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="submit" ValidationGroup="registrarGestion" />
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="submit" ValidationGroup="cancelarRegistrarGestion" />
                        <asp:HiddenField ID="hfIdGestionEdicion" runat="server" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </eo:CallbackPanel>
    <br />
    <asp:Panel ID="pnlGestionRealizada" runat="server">
        <asp:Repeater ID="repInfoGestion" runat="server">
            <HeaderTemplate>
                <table style="width: 98%;" class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1"
                    cellspacing="1">
                    <tr>
                        <th>
                            Tipo Gestión
                        </th>
                        <th>
                            Cliente
                        </th>
                        <th>
                            Gestionador
                        </th>
                        <th>
                            Fecha Gestión
                        </th>
                        <th>
                            Respuesta
                        </th>
                        <th>
                            Opc.
                        </th>
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
                    <td rowspan="2" style="width:30px;text-align:center;">
                        <asp:ImageButton ID="imgBtnEditarGestion" runat="server" ToolTip="Editar Gestión" 
                            CommandName="EditarGestion" CommandArgument='<%#Container.DataItem("idGestion")%>' ImageUrl="~/images/edit.gif" />
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Descripción:
                    </td>
                    <td colspan="3">
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
                    <td rowspan="2" style="width:30px;text-align:center;">
                        <asp:ImageButton ID="imgBtnEditarGestion" runat="server" ToolTip="Editar Gestión" 
                         CommandName="EditarGestion" CommandArgument='<%#Container.DataItem("idGestion")%>'  ImageUrl="~/images/edit.gif" />
                    </td>
                </tr>
                <tr class="fondoGris">
                    <td class="field">
                        Descripción:
                    </td>
                    <td colspan="3">
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
    </asp:Panel>
    <eo:Dialog ID="dlgPopUp" runat="server" CloseButtonUrl="00070101" ContentUrl="CrearUsuarioModuloSAC.aspx"
        ControlSkinID="None" Height="300px" Width="400px" AllowResize="True" BorderColor="#335C88"
        BorderStyle="Solid" BorderWidth="1px" HeaderHtml="<b>Creación de Nuevo Funcionario</b>"
        MinimizeButtonUrl="00070102" ResizeImageUrl="00020014" RestoreButtonUrl="00070103"
        ShadowColor="LightGray" ShadowDepth="3" MaxHeight="400" MaxWidth="550" MinHeight="200"
        MinWidth="400" VerticalAlign="Middle" BackShadeColor="Gray" ClientSideOnCancel="ActualizarListaFuncionario"
        IconUrl="~/images/add_user.png">
        <HeaderStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 11px; background-image: url(00070104); padding-bottom: 3px; padding-top: 3px; font-family: tahoma" />
        <FooterStyleActive CssText="background-color: #e5f1fd; padding-bottom: 8px;" />
        <ContentStyleActive CssText="border-top: #335c88 1px solid; background-color: #e5f1fd; height: 300px; width: 400px;" />
    </eo:Dialog>
    <uc3:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
