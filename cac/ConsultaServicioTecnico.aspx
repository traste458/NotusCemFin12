<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaServicioTecnico.aspx.vb"
    Inherits="BPColSysOP.ConsultaServicioTecnico" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register assembly="Anthem" namespace="Anthem" tagprefix="anthem" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta de seriales en servicio tecnico</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
      <script language="javascript" type="text/javascript">
        String.prototype.trim = function() { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }
        function esRangoValidorDespacho(source, arguments) {
            var fecha1, fecha2;
            if (source.id == "CustomValidatorIngreso") {
                fecha1 = "txtFechaIngreso1"
                fecha2 = "txtFechaIngreso2"
              }
              else {
                  fecha1 = "txtFechaEntrega1"
                  fecha2 = "txtFechaEntrega2"
            }

            try {
                if (document.getElementById(fecha1).value.trim() != "" || document.getElementById(fecha2).value.trim() != "") {
  
                    if (document.getElementById(fecha1 ).value.trim() != "" && document.getElementById(fecha2).value.trim() == "") {
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
            var txtSeriales = document.getElementById("txtSerial").value;
            var ddlCAC = document.getElementById("ddlCAC").value;
            var txtFecha1 = document.getElementById("txtFechaIngreso1").value;
            var txtFecha2 = document.getElementById("txtFechaEntrega1").value;
            var ddlEstado = document.getElementById("ddlEstado").value;
            try {

                if (txtSeriales == "" && ddlCAC == 0 && txtFecha1 == "" && ddlEstado == -1 && txtFecha2 == "")
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
    <div>
        <h3>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True">
            </asp:ScriptManager>
            Consulta de Seriales en Servicio Técnico</h3>
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
    <blockquote style="width: 500px">
        <p>
            Puede consultar varios seriales ingresandolos separados por la tecla enter. Ejemplo:</p>
        <pre>010704004113523
010704004476557
010704004116807
</pre>
    </blockquote>
    
    <table class="tabla">
        <tr>
            <th colspan="4" class="thGris">
                Filtros de Busqueda
            </th>
        </tr>
        <tr>
            <td class="field">
                Estado
            </td>
            <td colspan="3">
                <asp:DropDownList ID="ddlEstado" runat="server">
                    <asp:ListItem Value="-1">Seleccione un Estado...</asp:ListItem>
                    <asp:ListItem Value="0">Recibido</asp:ListItem>
                    <asp:ListItem Value="1">Entregado a Servicio Técnico</asp:ListItem>
                    <asp:ListItem Value="2">Por confirmación de Comcel</asp:ListItem>
                    <asp:ListItem Value="3">Cerrado</asp:ListItem>
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
             <span class="listSearchTheme">
                Desde: </span> 
                &nbsp;<asp:TextBox ID="txtFechaIngreso1" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="txtFechaIngreso1_CalendarExtender" runat="server" PopupButtonID="imginreso1"
                    Enabled="True" TargetControlID="txtFechaIngreso1">
                </cc1:CalendarExtender>
                <asp:ImageButton ID="imginreso1" runat="server" ImageUrl="~/images/calendar.png" />
               <span class="listSearchTheme">   &nbsp;Hasta: </span><asp:TextBox ID="txtFechaIngreso2" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="txtFechaIngreso2_CalendarExtender" runat="server" PopupButtonID="imgIngreso2"
                    Enabled="True" TargetControlID="txtFechaIngreso2">
                </cc1:CalendarExtender>
                <asp:ImageButton ID="imgIngreso2" runat="server" ImageUrl="~/images/calendar.png" />
                <div style="display:block">
                    <asp:CompareValidator ID="CompareValidatorFechaIngreso1" runat="server" 
                        ControlToValidate="txtFechaIngreso1" ErrorMessage="Formato de Fecha Incorrecto" Operator="DataTypeCheck" Display="Dynamic"
                        Type="Date" CssClass="listSearchTheme"></asp:CompareValidator>
       </div>    
       <div style="display:block">
                    <asp:CompareValidator ID="CompareValidatorFechaIngreso2" runat="server" Display="Dynamic"
                        ControlToValidate="txtFechaIngreso2" 
                        ErrorMessage="La fecha final debe ser mayor o igual a la inicial" Operator="GreaterThanEqual"
                        Type="Date" CssClass="listSearchTheme" ControlToCompare="txtFechaIngreso1"></asp:CompareValidator>
    </div>    <div style="display:block">
                    <asp:CustomValidator ID="CustomValidatorIngreso" runat="server" ErrorMessage="Es necesario especificar los dos valores del Rango"
                        ClientValidationFunction="esRangoValidorDespacho" 
                        CssClass="listSearchTheme" Display="Dynamic"></asp:CustomValidator>
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
                    QueryPattern="Contains" TargetControlID="ddlCAC" PromptCssClass="listSearchTheme"
                    PromptText="Digite para buscar en la lista...">
                </cc1:ListSearchExtender>
            </td>
            <td class="field">
                Fecha Entrega
            </td>
            <td>
                <span class="listSearchTheme">    Desde:</span>
                <asp:TextBox ID="txtFechaEntrega1" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="txtFechaEntrega1_CalendarExtender" runat="server" PopupButtonID="imgEntrega1"
                    Enabled="True" TargetControlID="txtFechaEntrega1">
                </cc1:CalendarExtender>
                <asp:ImageButton ID="imgEntrega1" runat="server" ImageUrl="~/images/calendar.png" />
                 <span class="listSearchTheme">     &nbsp;Hasta:&nbsp; </span><asp:TextBox ID="txtFechaEntrega2" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="txtFechaEntrega2_CalendarExtender" runat="server" PopupButtonID="imgEntrega2"
                    Enabled="True" TargetControlID="txtFechaEntrega2">
                </cc1:CalendarExtender>
                <asp:ImageButton ID="imgEntrega2" runat="server" ImageUrl="~/images/calendar.png" />
                <div style="display:block">
                    <asp:CompareValidator ID="CompareValidatorFechaEntrega1" runat="server" 
                        ControlToValidate="txtFechaEntrega1" 
                        ErrorMessage="Formato de Fecha Incorrecto" Operator="DataTypeCheck"
                        Type="Date" CssClass="listSearchTheme" Display="Dynamic"></asp:CompareValidator>
                         <div style="display:block">
                    <asp:CompareValidator ID="CompareValidator5" runat="server" 
                        ControlToValidate="txtFechaEntrega2" 
                        ErrorMessage="La fecha final debe ser mayor o igual a la inicial" Operator="GreaterThanEqual"
                        Type="Date" CssClass="listSearchTheme" ControlToCompare="txtFechaEntrega1" 
                        Display="Dynamic"></asp:CompareValidator>
              </div>
               <div style="display:block">
                          <asp:CustomValidator ID="CustomValidatorEntrega" runat="server" ErrorMessage="Es necesario especificar los dos valores del Rango"
                            ClientValidationFunction="esRangoValidorDespacho" 
                        CssClass="listSearchTheme" Display="Dynamic"></asp:CustomValidator></div>
                       
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <center>
                    <asp:CustomValidator ID="CustomValidatorBuscar" runat="server" 
                        ErrorMessage="Debe Proporcionar almenos un filtro de busqueda" 
                            CssClass="listSearchTheme" Display="Dynamic" 
                            ClientValidationFunction="filtrosBusqueda"></asp:CustomValidator>
                <br />
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" /></center>
            </td>
        </tr>
    </table>
    <br />
    <asp:LinkButton ID="lnkExportar" runat="server"> <img src="../images/Excel.gif" />Exportar a Excel</asp:LinkButton>
    <br />
    <br />
    <asp:DataGrid ID="gvDatos" runat="server" CssClass="grid" AutoGenerateColumns="False"
        DataKeyNames="idservicio" 
   
        ShowFooter="True">
        <FooterStyle CssClass="footer" />
        <AlternatingItemStyle CssClass="alternatingItem" />
        <Columns>
            <asp:BoundColumn DataField="serial" HeaderText="Serial" SortExpression="serial">
                <ItemStyle CssClass="text" />
            </asp:BoundColumn>
            <asp:BoundColumn DataField="descripcionEstado" HeaderText="Estado" SortExpression="estado" />
            <asp:BoundColumn DataField="fecha_ingreso" HeaderText="Fecha Ingreso" SortExpression="fecha_ingreso"
                DataFormatString="{0:d}" />
            <asp:BoundColumn DataField="fecha_entrega" HeaderText="Fecha Entrega" SortExpression="fecha_entrega" />
            <asp:BoundColumn DataField="fecha_respuesta" HeaderText="Fecha Respuesta" SortExpression="fecha_respuesta" />
            <asp:BoundColumn DataField="fecha_cierre" HeaderText="Fecha Cierre" SortExpression="fecha_cierre" />
            <asp:BoundColumn DataField="razon" HeaderText="Razon" SortExpression="razon" />
            <asp:BoundColumn DataField="cac" HeaderText="CAC" SortExpression="cac" />
            <asp:BoundColumn DataField="centro" HeaderText="Centro" SortExpression="centro" />
            <asp:BoundColumn DataField="almacen" HeaderText="Almacen" SortExpression="almacen" />
        </Columns>
        <HeaderStyle CssClass="thGris" Font-Bold="True" HorizontalAlign="Center" />
    </asp:DataGrid>
    </form>
</body>
</html>
