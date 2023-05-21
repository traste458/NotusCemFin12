<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolCargueServicioMensajeria.aspx.vb" Inherits="BPColSysOP.PoolCargueServicioMensajeria" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Pool Cargue Servicio Mensajeria</title>
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
    </style>
    <script type="text/javascript" language="javascript">
        function validarVacios(source, arguments) {
            try {
                var idCiudad = $("#ddlCiudad").val();
                var idTipoServicio = $("#ddlTipoArchivo").val();
                var numeroRadicado = $("#txtNoRadicado").val();

                if (idCiudad == "0" && idTipoServicio == "0" && numeroRadicado == "" ) {
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
        <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
        <table class="tablaGris" cellpadding="1" style="width: 500px;">
        <tr>
            <th colspan="4" align="left">
                Filtro:
            </th>
        </tr>
        <tr>
            <td>No. Radicado:</td>
            <td>
                <asp:TextBox ID="txtNoRadicado" runat="server" ></asp:TextBox>
                <div>
                    <asp:RegularExpressionValidator ID="rglNoRadicado" runat="server" ErrorMessage="El campo No. Radicado es numérico. Digite un número válido, por favor"
                                                                ControlToValidate="txtNoRadicado" ValidationGroup="buscar" Display="Dynamic"
                                                                ValidationExpression="[0-9]+"></asp:RegularExpressionValidator>
                </div>
            </td>
            <td>Tipo Servicio:</td>
            <td>
                <asp:DropDownList ID="ddlTipoServicio" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="width:80px;">Ciudad:</td>
            <td align="left">
                <asp:DropDownList ID="ddlCiudad" runat="server">
                </asp:DropDownList>
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="4" align="center">
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="search" ValidationGroup="buscar" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnBorrarFiltro" runat="server" Text="Cancelar" CssClass="search" />
                <div>
                    <asp:CustomValidator ID="cvValidarVacios" runat="server" ErrorMessage="Seleccione un filtro de búsqueda"
                        ClientValidationFunction="validarVacios" ValidationGroup="buscar"></asp:CustomValidator>
                </div>
            </td>
        </tr>
    </table>
        <asp:GridView ID="gvDatos" runat="server" CssClass="tablaGris" style="width:700px;margin-top:40px;" 
                AutoGenerateColumns="False" 
                EmptyDataText="&lt;b&gt;No se encontrario registros&lt;/b&gt;">
            <Columns>
                <asp:BoundField DataField="numeroRadicado" HeaderText="No. Radicado">
                    <ItemStyle HorizontalAlign="Center" Width="100px" />
                </asp:BoundField>
                <asp:BoundField DataField="tipoServicio" HeaderText="Tipo de Servicio">
                    <ItemStyle Width="120px" />
                </asp:BoundField>
                <asp:BoundField DataField="ciudad" HeaderText="Ciudad">
                    <ItemStyle Width="100px" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Opc.">
                    <ItemTemplate>
                        <asp:ImageButton ID="imgBtnContinuar" runat="server" CommandName="Completar"
                            CommandArgument='<%# Bind("idCargueServicioMensajeria") %>'
                            ImageUrl="~/images/Childish-Tool-32.png" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </form>
</body>
</html>
