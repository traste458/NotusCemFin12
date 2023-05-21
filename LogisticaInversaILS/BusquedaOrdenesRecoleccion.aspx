<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BusquedaOrdenesRecoleccion.aspx.vb"
    Inherits="BPColSysOP.BusquedaOrdenesRecoleccion" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta de Órdenes de Recolección</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        //funcion para validar fechas
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }
        function esRangoValido(source, arguments) {
            var fecha1, fecha2;
            fecha1 = "txtFechaCreacion1";
            fecha2 = "txtFechaCreacion2";
            try {
                if (document.getElementById(fecha1).value.trim() == "" && document.getElementById(fecha2).value.trim() == "") {
                    arguments.IsValid = true;
                }
                else if (document.getElementById(fecha1).value.trim() != "" || document.getElementById(fecha2).value.trim() != "") {

                    if (document.getElementById(fecha1).value.trim() != "" && document.getElementById(fecha2).value.trim() == "") {
                        arguments.IsValid = false;
                    } else {
                        if (document.getElementById(fecha1).value.trim() == "" && document.getElementById(fecha2).value.trim() != "") {
                            arguments.IsValid = false;
                        } else {
                            arguments.IsValid = true;
                        }
                    }
                } else {
                    arguments.IsValid = true;
                }
            } catch (e) {
                arguments.IsValid = false;
            }
        }


        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }

        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function FiltrarSucursal(idFiltro, idFlag, idCallbackPanel, parametro) {
            var filtro = document.getElementById(idFiltro).value.trim();
            var comboFiltrado = document.getElementById(idFlag).value;
            try {
                if (filtro.length >= 4 || (filtro.length < 4 && comboFiltrado == "1")) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(idCallbackPanel, parametro);
                    if (filtro.length >= 4) {
                        document.getElementById(idFlag).value = "1";
                    } else {
                        document.getElementById(idFlag).value = "0";
                    }
                }
                document.getElementById(idFiltro).focus();
            } catch (e) {
                MostrarOcultarDivFloater(false);
                alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }
        
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
<div>
        <uc2:ModalProgress ID="ModalProgress1" runat="server" />
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
        <div id="divFloater" style="display: none;">
            <table width="98%" align="center">
                <tr>
                    <td style="width: 40px">
                        <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" />
                    </td>
                    <td valign="middle">
                        <b>Procesando...</b>
                    </td>
                </tr>
            </table>
        </div>
       
                <table class="tablaGris">
                    <tr>
                        <th colspan="4">
                            Filtros de Busqueda
                        </th>
                    </tr>
                    <tr>
                        <td class="field">
                            ID Orden
                        </td>
                        <td>
                            <asp:TextBox ID="txtIdOrden" runat="server"></asp:TextBox>
                        </td>
                        <td class="field">
                            Transportadora
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTransportadora" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    
                        <tr>
            <td class="field">
                Origen
            </td>
            <td colspan="3">
                <div style="display: inline">
                    <asp:TextBox ID="txtFiltroOrigen" runat="server" onkeyup="FiltrarSucursal(this.id,'hfIdOrigen','cpFiltroOrigen','filtrarOrigen');"
                        MaxLength="20"></asp:TextBox>&nbsp;-&nbsp;
                    <eo:CallbackPanel ID="cpFiltroOrigen" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                        Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle">
                        <asp:DropDownList ID="ddlOrigen" runat="server">
                        </asp:DropDownList>
                    </eo:CallbackPanel>
                </div>
                <asp:HiddenField ID="hfIdOrigen" runat="server" />
                <div style="display: block">
                    <asp:RequiredFieldValidator ID="rfvOrigen" runat="server" ErrorMessage="Campo Origen requerido. Seleccione un origen, por favor"
                        ControlToValidate="ddlOrigen" Display="Dynamic" ValidationGroup="guardar" InitialValue="0"></asp:RequiredFieldValidator>
                </div>
            </td>
        </tr>
        <tr>
            <td class="field">
                Destino
            </td>
            <td colspan="3">
                <div style="display: inline">
                    <asp:TextBox ID="txtFiltroDestino" runat="server" onkeyup="FiltrarSucursal(this.id,'hfIdDestino','cpFiltroDestino','filtrarDestino');"
                        MaxLength="20"></asp:TextBox>&nbsp;-&nbsp;
                    <eo:CallbackPanel ID="cpFiltroDestino" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                        Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle">
                        <asp:DropDownList ID="ddlDestino" runat="server">
                        </asp:DropDownList>
                    </eo:CallbackPanel>
                </div>
                <asp:HiddenField ID="hfIdDestino" runat="server" />
                <div style="display: block">
                    <asp:RequiredFieldValidator ID="rfvDestino" runat="server" ErrorMessage="Campo Destino requerido. Seleccione un destino, por favor"
                        ControlToValidate="ddlDestino" Display="Dynamic" ValidationGroup="guardar" InitialValue="0"></asp:RequiredFieldValidator>
                </div>
            </td>
        </tr>
                    
                    <tr>
                        <td class="field">
                            Orden de servicio
                        </td>
                        <td>
                            <asp:TextBox ID="txtOrdensServicio" runat="server"></asp:TextBox>
                        </td>
                        <td class="field">
                            Guia
                        </td>
                        <td>
                            <asp:TextBox ID="txtGuia" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Tipo Fecha
                        </td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlFecha" runat="server" AutoPostBack="True">
                                <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                                <asp:ListItem Value="1">Fecha de creación</asp:ListItem>
                                <asp:ListItem Value="2">Recolección según la transportadora</asp:ListItem>
                                <asp:ListItem Value="3">Recolección según el punto</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trFerchas" runat="server">
                        <td class="field">
                            Rango de Fechas
                        </td>
                        <td colspan="3">
                            <span class="listSearchTheme">Desde:</span>
                            <asp:TextBox ID="txtFechaCreacion1" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFechaCreacion1_CalendarExtender" runat="server" PopupButtonID="imgFechaCreacion1"
                                CssClass="calendarTheme" Enabled="True" TargetControlID="txtFechaCreacion1">
                            </cc1:CalendarExtender>
                            <span class="listSearchTheme">
                                <img id="imgFechaCreacion1" alt="calendario" style="cursor: pointer" src="../images/calendar.png" />
                                &nbsp;Hasta:</span>
                            <asp:TextBox ID="txtFechaCreacion2" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFechaCreacion2_CalendarExtender" runat="server" PopupButtonID="imgFechaCreacion2"
                                CssClass="calendarTheme" Enabled="True" TargetControlID="txtFechaCreacion2">
                            </cc1:CalendarExtender>
                            <img id="imgFechaCreacion2" alt="" style="cursor: pointer" src="../images/calendar.png" />
                            <div>
                                <asp:CompareValidator ID="CompareValidatorFechaCreacion1" runat="server" ControlToValidate="txtFechaCreacion1"
                                    ErrorMessage="Formato de fecha incorrecto" Operator="DataTypeCheck" Type="Date"
                                    CssClass="listSearchTheme" Display="Dynamic"></asp:CompareValidator>
                            </div>
                            <div>
                                <asp:CompareValidator ID="CompareValidatorFechaCreacion2" runat="server" ControlToValidate="txtFechaCreacion2"
                                    ErrorMessage="Formato de fecha incorrecto" Operator="DataTypeCheck" Type="Date"
                                    CssClass="listSearchTheme" Display="Dynamic"></asp:CompareValidator>
                            </div>
                            <div>
                                <asp:CompareValidator ID="CompareValidatorFechaCreacion12" runat="server" ErrorMessage="La fecha final no debe ser menor a la inicial"
                                    ControlToCompare="txtFechaCreacion1" ControlToValidate="txtFechaCreacion2" CssClass="listSearchTheme"
                                    Display="Dynamic" Operator="GreaterThanEqual" Type="Date"></asp:CompareValidator>
                            </div>
                            <div>
                                <asp:CustomValidator ID="CustomValidatorFechaCreacion" runat="server" CssClass="listSearchTheme"
                                    Display="Dynamic" ErrorMessage="Debe especificar un rango de fehcas válido" ClientValidationFunction="esRangoValido"></asp:CustomValidator>
                            </div>
                            <div>
                                <asp:CompareValidator ID="CompareValidatorcreacionActual" runat="server" ControlToValidate="txtFechaCreacion1"
                                    ErrorMessage="El valor no debe sobrepasar la fecha actual" Operator="LessThanEqual"
                                    Type="Date" CssClass="listSearchTheme" Display="Dynamic"></asp:CompareValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <br />
                            <center>
                                <p>
                                    <asp:LinkButton ID="lnkBuscar" runat="server" CssClass="search">Buscar</asp:LinkButton></p>
                            </center>
                        </td>
                    </tr>
                </table>
 </div>

      
        <asp:GridView ID="gvOrdenes" runat="server" AutoGenerateColumns="False" DataKeyNames="idOrden"
            EmptyDataText="<br /> <blockquote><b>No se encontraron registros</b></blockquote>"
            CssClass="grid">
            <Columns>
                <asp:BoundField DataField="idOrden" HeaderText="ID Orden" InsertVisible="False" ReadOnly="True"
                    SortExpression="idOrden">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="origen" HeaderText="Origen" SortExpression="origen" />
                <asp:BoundField DataField="destino" HeaderText="Destino" SortExpression="destino" />
                <asp:BoundField DataField="transportadora" HeaderText="Transportadora" SortExpression="transportadora" />
                <asp:BoundField DataField="guia" HeaderText="Guia" SortExpression="guia" />
                <asp:BoundField DataField="ordenServicio" HeaderText="Orden Servicio" SortExpression="ordenServicio" />
                <asp:BoundField DataField="usuarioCreacion" HeaderText="Usuario Creacion" SortExpression="usuarioCreacion" />
                <asp:BoundField DataField="fechaCreacion" HeaderText="Fecha Creación" SortExpression="fechaCreacion" />
                <asp:BoundField DataField="fechaRecoleccionTrans" HeaderText="Fecha Recolección Transportadora"
                    SortExpression="fechaRecoleccionTrans" />
                <asp:BoundField DataField="fechaRecoleccionPunto" HeaderText="Fecha Recolección Punto"
                    SortExpression="fechaRecoleccionPunto" />
                <asp:BoundField DataField="observacion" HeaderText="Observación" />
                <asp:TemplateField HeaderText="Opciones" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <asp:ImageButton ID="imgEditar" runat="server" CommandName="Editar" CommandArgument='<%# Bind("idOrden") %>'
                            ImageUrl="~/images/edit.gif" />
                        &nbsp;<asp:ImageButton ID="ibtnNovedadSerial" runat="server" CommandName="VerNovedades"
                            CommandArgument='<%# Bind("idOrden") %>' ImageUrl="~/images/view.png" ToolTip="Ver Detalle" />
                        <asp:ImageButton ID="ImageHistorial" runat="server" CommandName="VerHistorial" CommandArgument='<%# Bind("idOrden") %>'
                            ImageUrl="~/images/charts.png" ToolTip="Ver Historial" />
                        &nbsp;
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
            <AlternatingRowStyle CssClass="alternatingItem" />
        </asp:GridView>
    </form>
</body>
</html>
