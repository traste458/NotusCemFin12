<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VisorReportes.aspx.vb" Inherits="BPColSysOP.VisorReportes" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Ver Reporte</title>
</head>
<body>
    <form id="form1" runat="server">
     <asp:Label ID="lblError" runat="server" ></asp:Label>
    <div >
        <CR:CrystalReportViewer ID="rptViewer" runat="server" 
             HasCrystalLogo="False" Width="50px" Height="350px"
        AutoDataBind="true" />      
    
    </div>
    </form>
</body>
</html>
