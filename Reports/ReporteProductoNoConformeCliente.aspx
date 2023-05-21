<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteProductoNoConformeCliente.aspx.vb"
    Inherits="BPColSysOP.ReporteProductoNoConformeCliente" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div >
        <asp:DataGrid ID="dgDatos" runat="server" CssClass="tabla">
            <HeaderStyle Font-Bold="True" HorizontalAlign="Center" ForeColor="White" BackColor="#000084" />
        </asp:DataGrid>
    </div>
    </form>
</body>
</html>
