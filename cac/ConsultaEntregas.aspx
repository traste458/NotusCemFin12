<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaEntregas.aspx.vb"
    Inherits="BPColSysOP.ConsultaEntregas" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta de Seriales por Prestamo y Siembra</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }
        function esRangoValidorDespacho(source, arguments) {
            var fecha1, fecha2;
            fecha1 = "txtFecha1";
            fecha2 = "txtFecha2";

            try {
                if (document.getElementById(fecha1).value.trim() != "" || document.getElementById(fecha2).value.trim() != "") {

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

        function filtrosBusqueda(source, arguments) {
            var ddlTipo = document.getElementById("ddlTipoEntrega").value;
            var txtSeriales = document.getElementById("txtSerial").value;
            var ddlCAC = document.getElementById("ddlCAC").value;
            var txtFecha = document.getElementById("txtFecha1").value;
            var ddlEstado = document.getElementById("ddlEstado").value;
            try {

                if (ddlTipo == 0 && txtSeriales == "" && ddlCAC == 0 && txtFecha == "" && ddlEstado == -1)
                { arguments.IsValid = false; }
                else
                { arguments.IsValid = true; }

            }
            catch (e) { arguments.IsValid = false; }

        }
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True">
    </asp:ScriptManager>
    <div>
        <h3>
            Consulta de Entregas por Serial</h3>
        <hr />
        			<TABLE class="tabla" width="90%">
				<TR>
					<TD><asp:hyperlink id="hlRegresar" runat="server" NavigateUrl="BuscarserialCambio.aspx">Regresar</asp:hyperlink>
					</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 16px" align="center"></TD>
				</TR>
				<TR>
					<TD align="center"><asp:label id="lblError" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" 
							ForeColor="Red"></asp:label><asp:label id="lblRes" runat="server" Font-Bold="True" AutoUpdateAfterCallBack="True" 
							ForeColor="Blue"></asp:label></TD>
				</TR>
			</TABLE>
    
    </div>
    <div>
        <blockquote style="width: 500px">
            <p>
                Puede consultar varios seriales ingresandolos separados por la tecla enter. Ejemplo:</p>
            <pre>010704004113523
010704004476557
010704004116807
</pre>
        </blockquote>
    </div>
    <div>
        <table class="tabla">
            <tr>
                <th colspan="4" class="thGris">
                    Filtros de Busqueda
                </th>
            </tr>
            <tr>
                <td class="field">
                    Tipo de Entrega
                </td>
                <td colspan="3">
                    <asp:DropDownList ID="ddlTipoEntrega" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="field">
                    Serial(les)<br />
                    <span class="listSearchTheme">ingrese uno o varios Seriales</span>
                </td>
                <td>
                    <asp:TextBox ID="txtSerial" runat="server" TextMode="MultiLine"></asp:TextBox>
                </td>
                <td class="field">
                    Fecha Ingreso
                </td>
                <td>
                    <span class="listSearchTheme">Desde:</span>
                    <asp:TextBox ID="txtFecha1" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="txtFecha1_CalendarExtender" runat="server" PopupButtonID="imgFecha1"
                        Enabled="True" TargetControlID="txtFecha1">
                    </cc1:CalendarExtender>
                    <img ID="imgFecha1"  style="cursor:pointer" src="../images/calendar.png" />
                    <span class="listSearchTheme">&nbsp;Hasta:</span>
                    <asp:TextBox ID="txtFecha2" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="txtFecha2_CalendarExtender" runat="server" PopupButtonID="imgFecha2"
                        Enabled="True" TargetControlID="txtFecha2">
                    </cc1:CalendarExtender>
                    <asp:ImageButton ID="imgFecha2" runat="server" ImageUrl="~/images/calendar.png" />
                    <div style="display: block">
                        <asp:CompareValidator ID="CompareValidatorFecha1" runat="server" ControlToValidate="txtFecha1"
                            ErrorMessage="Formato de Fecha Incorrecto" Display="Dynamic" Operator="DataTypeCheck"
                            Type="Date" CssClass="listSearchTheme"></asp:CompareValidator>
                    </div>
                    <div style="display: block">
                        <asp:CompareValidator ID="CompareValidatorFecha2" runat="server" ControlToValidate="txtFecha2"
                            ErrorMessage="La fecha final debe ser mayor o igual a la inicial" Operator="GreaterThanEqual"
                            Display="Dynamic" Type="Date" CssClass="listSearchTheme" ControlToCompare="txtFecha1"></asp:CompareValidator>
                    </div>
                    <div style="display: block">
                        <asp:CustomValidator ID="CustomValidatorIngreso" runat="server" ErrorMessage="Es necesario especificar los dos valores del Rango"
                            ClientValidationFunction="esRangoValidorDespacho" CssClass="listSearchTheme"
                            Display="Dynamic"></asp:CustomValidator>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="field">
                    CAC<br />
                    <span class="listSearchTheme">Digite para&nbsp; buscar</span>
                </td>
                <td>
                    <br />
                    <asp:DropDownList ID="ddlCAC" runat="server">
                    </asp:DropDownList>
                    <cc1:ListSearchExtender ID="ddlCAC_ListSearchExtender" runat="server" Enabled="True"
                        TargetControlID="ddlCAC" PromptCssClass="listSearchTheme" PromptText="Digite para Buscar"
                        QueryPattern="Contains">
                    </cc1:ListSearchExtender>
                </td>
                <td class="field">
                    Estado
                </td>
                <td class="style1">
                    <asp:DropDownList ID="ddlEstado" runat="server">
                        <asp:ListItem Value="-1">Seleccione un Estado...</asp:ListItem>
                        <asp:ListItem Value="1">Activo</asp:ListItem>
                        <asp:ListItem Value="0">Inactivo</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <center>
                        <asp:CustomValidator ID="CustomValidatorBuscar" runat="server" ErrorMessage="Debe Proporcionar almenos un filtro de busqueda"
                            CssClass="listSearchTheme" Display="Dynamic" ClientValidationFunction="filtrosBusqueda"></asp:CustomValidator>
                        <br />
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" Width="61px" />
                    </center>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <asp:LinkButton ID="lnkExportar" runat="server"> <img 
        src="../images/Excel.gif" />Exportar a Excel</asp:LinkButton>
    <br />
    <br />
    <asp:DataGrid ID="gvDatos" runat="server" AutoGenerateColumns="False" CssClass="grid"
        ShowFooter="True">
        <FooterStyle CssClass="footer" />
        <AlternatingItemStyle CssClass="alternatingItem" />
        <Columns>
            <asp:BoundColumn DataField="identrega" HeaderText="No. Entrega" SortExpression="identrega" />
            <asp:BoundColumn DataField="serial" HeaderText="Serial" SortExpression="serial">
                <ItemStyle CssClass="text" />
            </asp:BoundColumn>
            <asp:BoundColumn DataField="idsubproducto2" HeaderText="Material" SortExpression="idsubproducto2" />
            <asp:BoundColumn DataField="subproducto" HeaderText="Referencia" />
            <asp:BoundColumn DataField="tipoentrega" HeaderText="Tipo Entrega"></asp:BoundColumn>
            <asp:BoundColumn DataField="descripcionEstado" HeaderText="Estado" SortExpression="estado" />
            <asp:BoundColumn DataField="fechaRegistro" HeaderText="Fecha Ingreso" DataFormatString="{0:d}"
                SortExpression="fechaRegistro" />
            <asp:BoundColumn DataField="cac" HeaderText="CAC" SortExpression="cac" />
            <asp:BoundColumn DataField="centro" HeaderText="Centro" SortExpression="centro" />
            <asp:BoundColumn DataField="almacen" HeaderText="Almacen" SortExpression="almacen" />
        </Columns>
        <HeaderStyle CssClass="thGris" Font-Bold="True" HorizontalAlign="Center" />
    </asp:DataGrid>
    </form>
</body>
</html>
