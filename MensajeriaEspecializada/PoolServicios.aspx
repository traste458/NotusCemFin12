<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolServicios.aspx.vb"
    Inherits="BPColSysOP.PoolServicios" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pool de Servicios</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/jquery.tools.min.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jscript_ventana.js" type="text/javascript" language="javascript"></script>
    <script language="javascript" type="text/javascript">
        String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function validaSeleccionReactivacion() {
            try {
                var strMensaje = "";
                var reactivaSin = document.getElementById('<%= rbReactivacionSinCambio.ClientID %>').checked;
                var reactivaCon = document.getElementById('<%= rbReactivacionConCambio.ClientID %>').checked;
                var txtNuevoRadicado = document.getElementById('<%= txtNuevoRadicado.ClientID %>');
                var txtObservacion = document.getElementById('<%= txtObservacionReactivacion.ClientID %>').value;
                var divRadicado = document.getElementById('divRadicado')

                /*Se muestra u oculta el textbox del radicado.*/
                if (reactivaSin) {
                    divRadicado.style.display = "none";
                } else if (reactivaCon) {
                    divRadicado.style.display = "inline";
                }


                /*Se validan los datos antes de guadar.*/
                if (!reactivaSin && !reactivaCon) {
                    strMensaje += "- Debe seleccionar si se realiza cambio de Radicado.\n";
                }
                if (reactivaCon && txtNuevoRadicado.value.length == 0) {
                    strMensaje += "- El nuevo número de radicado es requerido.\n";
                }
                if (txtObservacion.length == 0) {
                    strMensaje += "- La observación de reactivación es obligatoria.\n";
                }

                if (strMensaje.length == 0) {
                    return true;
                } else {
                    alert(strMensaje);
                    return false;
                }
            } catch (ex) {
                return false;
            }
        }

        function validaSeleccionLegalizacion() {
            var strMensaje = "";
            var txtObservacion = document.getElementById('<%= txtLegaliza.ClientID %>').value;
            if (txtObservacion.length == 0) {
                strMensaje += "La observación de legalización es obligatoria.\n";
            }

            if (strMensaje.length == 0) {
                return true;
            } else {
                alert(strMensaje);
                return false;
            }
        }

        function ValidarNumeroRadicado() {
            try {
                var numRadicado = document.getElementById('<%= txtNuevoRadicado.ClientID %>').value.trim();
                if (numRadicado.length > 0) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback("cpValidacionNumRadicado", numRadicado);
                }
            } catch (e) {
                MostrarOcultarDivFloater(false);
            }
        }
        function ExisteSeleccion(source, args) {
            try {
                var numRadicado = document.getElementById('<%= txtidServicio.ClientID%>').value;
                var idCiudad = document.getElementById('<%= ddlCiudad.ClientID%>').value;
                var idEstado = document.getElementById('<%= ddlEstado.ClientID%>').value;
                var idBodega = document.getElementById('<%= ddlBodega.ClientID%>').value;
                var idTipoServicio = document.getElementById('<%= ddlTipoServicio.ClientID%>').value;
                var fechaInicial = document.getElementById('<%= txtFechaInicial.ClientID%>').value;
                var fechaFinal = document.getElementById('<%= txtFechaFinal.ClientID%>').value;
                var clienteVIP = document.getElementById('<%= ddlVIP.ClientID%>').value;
                var tieneNovedad = document.getElementById('<%= ddlTieneNovedad.ClientID%>').value;
                var min = document.getElementById('<%= txtMIN.ClientID %>').value;

                if (numRadicado.trim() == "" && idCiudad == "0" && idEstado == "0" && idBodega == "0" && idTipoServicio == "0"
                    && fechaInicial.trim() == "" && fechaFinal.trim() == "" && clienteVIP == "0" && tieneNovedad == "0" && min.trim() == "") {

                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
                alert("Error al tratar de validar selección.\n" + e.description);
            }
        }

        function validarRadicados(sender, args) {
            var objRadicados = $("#<%=txtidServicio.ClientID%>").val().split('\n');
            if (objRadicados.length <= 500) {
                var linea = 1;
                var mensaje = "";
                for (i = 0; i < objRadicados.length; i++) {
                    if (isNaN(Number(objRadicados[i]))) {
                        mensaje = mensaje + "Línea " + linea + ": El valor no es un radicado válido [" + objRadicados[i] + "].\n";
                    } else if (objRadicados[i].length > 15) {
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

        function UpdateLabel(checkBox) {
            var label = document.getElementById("10");
            alert("mensaje valo :" + label);
            if (confirm('¿Realmente desea quitar el check de reagendamiento?')) {
                alert("Selecciono SI");
                var inputs = document.getElementById("gvDatos").getElementsByTagName("idServicioMensajeria");
            } else {
                alert("Selecciono NO :");
            }
            var value = parseInt(label.innerText);
            if (checkBox.checked) {
                label.innerText = --value;
            }
            else {
                label.innerText = ++value;
            }
        }

        function Read_Data(value) {
            var ivalue = parseInt(value) + 1;
            var Grid_Table = document.getElementById('<%= gvDatos.ClientID %>');

            var str = Grid_Table.rows[ivalue].cells[1].toString();
            if (confirm('¿Realmente desea quitar el check de reagendamiento?')) {
                alert("Selecciono SI");
                var inputs = document.getElementById("gvDatos").getElementsByTagName("idServicioMensajeria");
                alert(inputs);
            } else {
                alert("Selecciono NO :");
            }
            var variable = str; //Hago como Trim()

            alert(ivalue);
            alert(str);
            return false;

        }

    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize('hfMedidasVentana');">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />

        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <asp:UpdatePanel ID="upEncabezado" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hidIdReg" runat="server" />
                    <asp:HiddenField ID="hfMedidasVentana" runat="server" />
                    <uc1:EncabezadoPagina ID="epPoolServicios" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
            UpdateMode="Group" GroupName="general" LoadingDialogID="ldrWait_dlgWait">
            <asp:Panel ID="panelDatosPoolServicios" runat="server">
                <table class="tablaGris" style="width: auto;">
                    <tr>
                        <td colspan="6" style="text-align: center" class="thGris">INGRESE LOS DATOS PARA CONSULTA
                        </td>
                    </tr>
                    <tr>
                        <td class="field" align="left">No. Radicado:
                        </td>
                        <td align="left">
                            <div style="float: left; margin-right: 5px;">
                                <asp:RadioButtonList ID="rblTipoBusqueda" runat="server" RepeatDirection="Vertical">
                                    <asp:ListItem Text="Radicado" Value="1" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Servicio" Value="2"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div style="float: left">
                                <asp:TextBox ID="txtidServicio" runat="server" TextMode="MultiLine" onKeyUp="javascript:MaxLongitud(this,4000);"
                                    onChange="javascript:MaxLongitud(this,4000);" Rows="4" Columns="20" onkeypress="javascript:return ValidaNumero(event);"
                                    title="Seleccione el tipo de búsqueda e Ingrese los números de radicados o servicio separados por saltos de línea.">
                                </asp:TextBox>
                            </div>
                            <div style="clear: both">
                                <asp:CustomValidator ID="cvRadicado" runat="server" Display="Dynamic" ValidationGroup="vgCliente"
                                    ErrorMessage="Radicados incorrectos, por favor verifique." ControlToValidate="txtidServicio"
                                    ClientValidationFunction="validarRadicados" />
                            </div>
                        </td>
                        <td class="field">
                            <b>MIN (MSISDN): </b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtMIN" runat="server" MaxLength="10"></asp:TextBox>
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
                        <td class="field" align="left">Estado:
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
                                    <td>De:&nbsp;&nbsp;
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
                                    <td>Hasta:&nbsp;&nbsp;
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
                        <td class="field">Cliente VIP:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlVIP" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td class="field">Estado Novedad:
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
                            <div style="display: block;">
                                <asp:CustomValidator ID="cusFiltros" runat="server" ErrorMessage="Debe seleccionar por lo menos un filtro de búsqueda."
                                    Display="Dynamic" ValidationGroup="vgCliente" Enabled="false" ClientValidationFunction="ExisteSeleccion"></asp:CustomValidator>
                            </div>
                            <div style="margin-top: 5px; margin-bottom: 10px;">
                                <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente">
                                    <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                                </asp:LinkButton>
                                &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlResultados" runat="server" HorizontalAlign="Center">
                <div style="text-align: center; margin-top: 5px;">
                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="No hay pedidos pendientes" HeaderStyle-HorizontalAlign="Center"
                        PageSize="30" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                        AllowSorting="true" DataKeyNames="idServicioMensajeria,idTipoServicio">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        <Columns>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Image ID="imgUrgente" runat="server" ImageUrl="../images/transparent_16.gif"
                                        ToolTip="Urgente" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Opciones">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbVer" runat="server" CommandName="ver" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Ver Información del Servicio">
                                <img alt="Ver Información del Servicio" border="0" src="../images/view.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lnkEditar" runat="server" CommandName="adicionarNovedad" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Adicionar Novedad"> 
                                <img alt="Adicionar Novedad" border="0" src="../images/Edit-32.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lnkConfirma" runat="server" CommandName="confirmar" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Confirmar Servicio">
                                <img alt="Confirmar Servicio" border="0" src="../images/confirmation.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lnkDespacho" runat="server" CommandName="despachar" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Despachar">
                                <img alt="Despachar Pedido" border="0" src="../images/trans_small.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lnkAsignarZona" runat="server" CommandName="asignarZona" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Asignar Zona">
                                <img alt="Asignar Zona" border="0" src="../images/encontrar_small.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lbModificarServicio" runat="server" CommandName="modificarServicio"
                                        CommandArgument='<%# Bind("idServicioMensajeria") %>' ToolTip="Modificar servicio">
                                <img alt="Modificar Servicio" border="0" src="../images/Edit-User.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lbCambioServicio" runat="server" CommandName="cambioServicio"
                                        CommandArgument='<%# Bind("idServicioMensajeria") %>' ToolTip="Registrar Cambio Servicio">
                                <img alt="Registrar Cambio de Servicio" border="0" src="../images/usuario.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lbAbrirServicio" runat="server" CommandName="abrirServicio" CommandArgument='<%# Bind("idServicioMensajeria") %>'
                                        ToolTip="Abrir Servicio">
                                    <img alt="Abrir Servicio" border="0" src="../images/unlock.png"/>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="ibCancelarServicio" runat="server" ToolTip="Cerrar Servicio"
                                        CommandName="cancelarServicio" CommandArgument='<%# Bind("idServicioMensajeria") %>'>
                                    <img alt="Cerrar Servicio" border="0" src="../images/package.png"/>
                                    </asp:LinkButton>
                                    <div style="visibility: hidden; display: inline">
                                        <asp:LinkButton ID="lnkAdendoServicio" runat="server" CommandName="adendoServicio"
                                            CommandArgument='<%# Bind("idServicioMensajeria") %>' ToolTip="Adendo Servicio">
                                <img alt="Adendo Servicio" border="0" src="../images/pdf.png"/></asp:LinkButton>
                                    </div>
                                    <asp:LinkButton ID="lbUrgente" runat="server" CommandName="marcarUrgente" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                        ToolTip="Marcar como Urgente" OnClientClick="return confirm('¿Está seguro que desea marcar el servicio como urgente?')">
                                    <img alt="Marcar como Urgente" border="0" src="../images/important.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lbReactivar" runat="server" CommandName="reactivarServicio" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                        ToolTip="Reactivar servicio">
                                    <img alt="Reactivar servicio" border="0" src="../images/Open.png"/></asp:LinkButton>
                                    <asp:LinkButton ID="lbServicioTecnico" runat="server" CommandName="gestionarServicioTecnico"
                                        CommandArgument='<%#Bind("idServicioMensajeria") %>' ToolTip="Gestionar Servicio Técnico">
                                    <img alt="Gestionar Servicio Técnico" border="0" src="../images/kit_tools.png" />
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbDevolverVenta" runat="server" CommandName="DevolverVenta" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                        ToolTip="Devolver Venta a Call Center">
                                    <img alt="Devolver Venta a Call Center" border="0" src="../images/return.png" />
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbLegalizar" runat="server" CommandName="LegalizarFinanciero" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                        ToolTip="Legalizar Servicio Financiero">
                                    <img alt="Legalizar Servicio Financiero" border="0" src="../images/DxMarker.png" />
                                    </asp:LinkButton>
                                <asp:LinkButton ID="LbAsignacion" runat="server" CommandName="asignarSeriales" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Asignación de Seriales">
                                    <img alt="Asignación de Seriales" border="0" src="../images/DXLectora16.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbConfirmaCorp" runat="server" CommandName="confirmaServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Confirmar Servicio">
                                    <img alt="ConfirmarServicio" border="0" src="../images/calendar-select-days.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="LnkEditCorp" runat="server" CommandName="editaServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Editar Servicio">
                                    <img alt="EditarServicio" border="0" src="../images/DxEdit.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="LbAsignacionP" runat="server" CommandName="asignarSeriales" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Asignación de Seriales">
                                    <img alt="Asignación de Seriales" border="0" src="../images/DXLectora16.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbConfirmaCorpP" runat="server" CommandName="confirmaServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Confirmar Servicio">
                                    <img alt="ConfirmarServicio" border="0" src="../images/calendar-select-days.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="LnkEditCorpP" runat="server" CommandName="editaServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Editar Servicio">
                                    <img alt="EditarServicio" border="0" src="../images/DxEdit.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="LnkCamCorp" runat="server" CommandName="desCamServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Despacho con cambio">
                                    <img alt="Despacho con cambio" border="0" src="../images/NewProcess.png" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="LnkCamCorpP" runat="server" CommandName="desCamServicioCorp" CommandArgument='<%#Bind("idServicioMensajeria") %>'
                                    ToolTip="Despacho con cambio">
                                    <img alt="Despacho con cambio" border="0" src="../images/NewProcess.png" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="idServicioMensajeria" HeaderText="ID" SortExpression="idServicioMensajeria">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="numeroRadicado" SortExpression="numeroRadicado" HeaderText="N&uacute;mero Radicado" />
                        <asp:BoundField DataField="tipoServicio" SortExpression="tipoServicio" HeaderText="Tipo de Servicio" />
                        <asp:BoundField DataField="fechaAsignacion" HeaderText="Fecha Asignación" DataFormatString="{0:dd/MM/yyyy}"
                            SortExpression="fechaAsignacion" />
                        <asp:BoundField DataField="fechaAgenda" HeaderText="Fecha Agenda" DataFormatString="{0:dd/MM/yyyy}"
                            SortExpression="fechaAgenda" />
                        <asp:BoundField DataField="usuarioEjecutor" HeaderText="Usuario Ejecutor" />
                        <asp:BoundField DataField="nombreConsultor" HeaderText="Usuario Consultor" />
                        <asp:BoundField DataField="jornada" HeaderText="Jornada" SortExpression="jornada" />
                        <asp:BoundField DataField="estado" HeaderText="Estado" SortExpression="estado" />
                        <asp:BoundField DataField="fechaConfirmacion" HeaderText="Fecha Confirmacion" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="responsableEntrega" HeaderText="Responsable Entrega" SortExpression="responsableEntrega" />
                        <asp:BoundField DataField="tieneNovedad" HeaderText="Tiene Novedad (S/N)" SortExpression="tieneNovedad" />
                        <asp:BoundField DataField="nombreCliente" HeaderText="Nombre Cliente" SortExpression="nombreCliente" />
                        <asp:BoundField DataField="personaContacto" HeaderText="Persona Contacto" />
                        <asp:BoundField DataField="ciudadCliente" HeaderText="Ciudad Cliente" SortExpression="ciudadCliente" />
                        <asp:BoundField DataField="barrio" HeaderText="Barrio" />
                        <asp:BoundField DataField="direccion" HeaderText="Direcci&oacute;n" />
                        <asp:BoundField DataField="telefonoContacto" HeaderText="Tel&eacute;fono" />
                        <asp:TemplateField HeaderText="Check Reagenda">
                            <ItemTemplate>
                                <asp:CheckBox ID="CheReagenda" runat="server" AutoPostBack="true"   HeaderText="Reagenda" Enabled="False" OnCheckedChanged="CheReagenda_OnCheckedChanged"
                                    ToolTip="Quitar Check de reagenda" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                </td> </tr>
                                <tr>
                                    <td class="field">Observaci&oacute;n
                                    </td>
                                    <td colspan="14" align="left">
                                        <asp:Literal runat="server" ID="ltObservacion" Text='<%# Bind("Observacion") %>'></asp:Literal>
                                    </td>
                                </tr>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpModificarServicio" runat="server" Width="100%" UpdateMode="Group"
            GroupName="general" LoadingDialogID="ldrWait_dlgWait">
            <eo:Dialog runat="server" ID="dlgAbrirServicio" ControlSkinID="None" Height="300px"
                HeaderHtml="Modificar Servicio" CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                BackShadeOpacity="50" CancelButton="lbAbortarModificacion" Width="500px">
                <ContentTemplate>
                    <asp:Panel ID="pnlAuxiliar" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                        <table align="center" class="tabla">
                            <asp:Panel ID="pnlMensajeRestriccionNovedad" runat="server">
                                <tr>
                                    <td colspan="2">
                                        <blockquote>
                                            <p>No es posible cerrar el radicado, por favor verifique que exista una novedad creada para el proceso actual y fecha de hoy.</p>
                                        </blockquote>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td class="field">Observacion:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtObservacionModificacion" runat="server" Rows="6" Width="400px"
                                        TextMode="MultiLine"></asp:TextBox>
                                    <div>
                                        <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ErrorMessage="Se requiere una observaci&oacute;n para continuar con el proceso"
                                            Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="txtObservacionModificacion"></asp:RequiredFieldValidator>
                                    </div>
                                </td>
                            </tr>
                            <asp:Panel ID="pnlEstadoReapertura" runat="server">
                                <tr>
                                    <td class="field">Estado de reapertura:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlEstadoReapertura" runat="server" />
                                        <div>
                                            <asp:RequiredFieldValidator ID="rfvddlEstadoReapertura" runat="server" ErrorMessage="El estado de reapertura es requerido."
                                                Display="Dynamic" ValidationGroup="modificacionServicio" ControlToValidate="ddlEstadoReapertura"
                                                InitialValue="0" />
                                        </div>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:LinkButton ID="lbAbrirServicio" runat="server" CssClass="search" ValidationGroup="modificacionServicio"><img src="../images/unlock.png" alt=""/>&nbsp;Abrir Servicio</asp:LinkButton>
                                    <asp:LinkButton ID="lbCancelarServicio" runat="server" CssClass="search" ValidationGroup="modificacionServicio"><img src="../images/package.png" alt=""/>&nbsp;Cerrar Servicio</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbAbortarModificacion" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                    <asp:HiddenField ID="hfIdServicio" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpReactivacion" runat="server" Width="100%" UpdateMode="Group"
            GroupName="general" LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true">
            <eo:Dialog ID="dlgReactivarServicio" runat="server" ControlSkinID="None" Height="300px"
                HeaderHtml="Reactivar Servicio" CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                BackShadeOpacity="50" CancelButton="lbAbortarModificacion" Width="500px">
                <ContentTemplate>
                    <asp:Panel ID="pnlReactivarServicio" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                        <table align="center" class="tabla">
                            <tr>
                                <td class="field">¿Con cambio de Radicado?
                                </td>
                                <td>
                                    <asp:RadioButton ID="rbReactivacionSinCambio" Text="No" runat="server" GroupName="cambioRadicado" />
                                    <asp:RadioButton ID="rbReactivacionConCambio" Text="Si" runat="server" GroupName="cambioRadicado" />
                                    <div id="divRadicado" style="display: none">
                                        <eo:CallbackPanel ID="cpValidacionNumRadicado" runat="server" UpdateMode="Self" Width=" 100%"
                                            ClientSideAfterUpdate="CallbackAfterUpdateHandler">
                                            &nbsp;Nuevo radicado:
                                        <asp:TextBox ID="txtNuevoRadicado" runat="server" MaxLength="10" Width="120px" onblur="ValidarNumeroRadicado();" />
                                            <asp:Image ID="imgError" runat="server" ImageUrl="~/images/close.gif" Visible="false"
                                                ToolTip="El número de radicado digitado ya existe." />
                                        </eo:CallbackPanel>
                                    </div>
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
                                </td>
                            </tr>
                            <tr>
                                <td class="field">Observación:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtObservacionReactivacion" runat="server" Rows="6" Width="300px"
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <br />
                                    <br />
                                    <asp:LinkButton ID="lbReactivar" runat="server" CssClass="search" ValidationGroup="reactivarServicio"
                                        OnClientClick="return validaSeleccionReactivacion()">
                                    <img src="../images/Open.png" alt=""/>&nbsp;Reactivar Servicio
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbCancelarReactivacion" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                    <asp:HiddenField ID="hfReactivarIdServicio" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpLegalizacion" runat="server" Width="100%" UpdateMode="Group"
            GroupName="general" LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true">
            <eo:Dialog ID="dlgLegalizarServicio" runat="server" ControlSkinID="None" Height="300px"
                HeaderHtml="Legalizar Servicio Financiero" CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray"
                BackShadeOpacity="50" CancelButton="lbCancela" Width="500px">
                <ContentTemplate>
                    <asp:Panel ID="Panel1" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                        <table align="center" class="tabla">
                            <tr>
                            </tr>
                            <tr>
                                <td class="field">Observación:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtLegaliza" runat="server" Rows="6" Width="300px"
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <br />
                                    <br />
                                    <asp:LinkButton ID="lbLegaliza" runat="server" CssClass="search" ValidationGroup="legalizarServicio"
                                        OnClientClick="return validaSeleccionLegalizacion()">
                                    <img src="../images/Open.png" alt=""/>&nbsp;Legalizar Servicio
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbCancela" runat="server" CssClass="search" CausesValidation="false"><img src="../images/cancelar.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                    <asp:HiddenField ID="hflegalizaIdServicio" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpVerInformacion" runat="server" LoadingDialogID="ldrWait_dlgWait"
            UpdateMode="Group" GroupName="general">
            <eo:Dialog runat="server" ID="dlgVerInformacionServicio" ControlSkinID="None" Height="400px"
                HeaderHtml="Información detallada del Servicio" CloseButtonUrl="00020312" BackColor="White"
                BackShadeColor="Gray" BackShadeOpacity="50">
                <ContentTemplate>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpValidarVentas" runat="server" LoadingDialogID="ldrWait_dlgWait"
            UpdateMode="Group" GroupName="ventas">
            <eo:Dialog runat="server" ID="dlgAvisoVentas" Height="100px" Width="300px" HeaderHtml="Visualización de Ventas"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50"
                CancelButton="btnCancelar">
                <ContentTemplate>
                    <asp:Panel ID="pnlValidarVentas" runat="server" Style="overflow: auto;">
                        <div>
                            <blockquote>
                                <table cellspacing="2" cellpadding="4">
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:Label ID="lblMensajeVentas" runat="server" Text="Se encontraron [[0]] nuevos servicios de Tipo Venta. ¿Desea gestionarlos?" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <asp:Button ID="btnAceptarVentas" runat="server" Text="Si" CssClass="search" Width="30px" />
                                        </td>
                                        <td align="center">
                                            <asp:Button ID="btnCancelar" runat="server" Text="No" CssClass="search" Width="30px" />
                                        </td>
                                    </tr>
                                </table>
                            </blockquote>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:CallbackPanel ID="cpDevolucionVenta" runat="server" UpdateMode="Group" GroupName="general"
            LoadingDialogID="ldrWait_dlgWait" ChildrenAsTriggers="true">
            <eo:Dialog ID="dlgDevolverVenta" runat="server" ControlSkinID="None" HeaderHtml="Devolver Venta a Call Center"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50"
                Width="350px">
                <ContentTemplate>
                    <asp:Panel ID="pnlDevolucionVenta" runat="server">
                        <table align="center">
                            <tr>
                                <td class="field">Tipo de Novedad:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlTipoNovedadDevolucion" runat="server" />
                                    <asp:RequiredFieldValidator ID="rfvddlTipoNovedadDevolucion" runat="server" ValidationGroup="vgDevolucion"
                                        InitialValue="0" ControlToValidate="ddlTipoNovedadDevolucion" ErrorMessage="Seleccione un tipo de novedad."
                                        Display="Dynamic" />
                                </td>
                            </tr>
                            <tr>
                                <td class="field">Observación:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtObservacionDevolucion" runat="server" Rows="5" Columns="30" TextMode="MultiLine" />
                                    <asp:RequiredFieldValidator ID="rfvtxtObservacionDevolucion" runat="server" ValidationGroup="vgDevolucion"
                                        Display="Dynamic" ControlToValidate="txtObservacionDevolucion" ErrorMessage="Ingrese una observación." />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <asp:Button ID="btnDevolverVenta" runat="server" Text="Devolver" CssClass="search"
                                        ValidationGroup="vgDevolucion" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;"></HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma"></ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310"></BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>

        <eo:callbackpanel id="cpReagenda" runat="server" updatemode="Group"
        groupname="general" loadingdialogid="ldrWait_dlgWait" childrenastriggers="true">
        <eo:Dialog ID="dlgReagenda" runat="server" ControlSkinID="None"
            HeaderHtml="Check Reagenda Servicio" CloseButtonUrl="00020312" BackColor="White"
            BackShadeColor="Gray" BackShadeOpacity="50" Width="350px">
            <ContentTemplate>
                <asp:Panel ID="Panel2" runat="server">
                    <table align="center">
                        <tr>
                            <td class ="field">
                                Id. Servicio:
                            </td>
                            <td>
                                <asp:Label ID="lblIdServicio" runat ="server"></asp:Label> 
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Tipo de Novedad:</td>
                            <td>
                                <asp:DropDownList ID="ddlNovedadReagenda" runat="server" />
                                <asp:RequiredFieldValidator id="rfvAgenda" runat="server" ValidationGroup="vgReagenda" InitialValue="0"
                                    ControlToValidate="ddlNovedadReagenda" ErrorMessage="Seleccione un tipo de novedad." Display="Dynamic" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">Observación:</td>
                            <td>
                                <asp:TextBox ID="txtObservacionReagenda" runat="server" Rows="5" Columns="30" TextMode="MultiLine" />
                                <asp:RequiredFieldValidator ID="rfvObservacionAgenda" runat="server" ValidationGroup="vgReagenda" Display="Dynamic"
                                    ControlToValidate="txtObservacionReagenda" ErrorMessage="Ingrese una observación." />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Button ID="btnReagenda" runat="server" Text="Check Reagenda" CssClass="search" ValidationGroup="vgReagenda" />
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
    </eo:callbackpanel>

        <uc2:Loader ID="ldrWait" runat="server" />
        <!-- iframe para uso de selector de fechas -->
        <iframe id="gToday:contrast:agenda.js" style="z-index: 999; left: -500px; visibility: visible; position: absolute; top: -500px"
            name="gToday:contrast:agenda.js" src="../include/DateRange/ipopeng.htm"
            frameborder="0" width="132" scrolling="no" height="142"></iframe>
    </form>
</body>
</html>
