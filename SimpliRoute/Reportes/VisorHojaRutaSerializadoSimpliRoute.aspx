<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VisorHojaRutaSerializadoSimpliRoute.aspx.vb" Inherits="BPColSysOP.VisorHojaRutaSerializadoSimpliRoute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="~/ControlesDeUsuario/ucViewReportDevExpress.ascx" TagName="Visor" TagPrefix="vdx" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <vdx:Visor id="vsReporte" runat="server" />
    </form>
</body>
</html>
