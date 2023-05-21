<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RptView.aspx.vb" Inherits="BPColSysOP.RptView" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>RptView</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet">
</head>
<body>
    <form id="Form1" method="post" runat="server">
    <p>
        <table class="tabla" id="Table1" width="90%">
            <tr>
                <td>
                    <asp:HyperLink ID="hlRegresar" runat="server">Regresar</asp:HyperLink>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <asp:Label ID="lblRes" runat="server" ForeColor="Blue" Font-Bold="True" AutoUpdateAfterCallBack="True"
                        Font-Size="Small"></asp:Label><asp:Label ID="lblError" runat="server" AutoUpdateAfterCallBack="True"
                            Font-Bold="True" ForeColor="Red" Font-Size="Small"></asp:Label>
                </td>
            </tr>
        </table>
    </p>
    <table class="tabla" id="Table2">
        <tr>
            <td class="header">
                Exportar a:
            </td>
            <td>
                <asp:DropDownList ID="ddlExportar" runat="server">
                </asp:DropDownList>
            </td>
            <td>
                <asp:Button ID="btnExportar" runat="server" Enabled="False" Text="Exportar"></asp:Button>
            </td>
        </tr>
    </table>
    <CR:CrystalReportViewer runat="server" ID="rptViewer" AutoDataBind="true" DisplayToolbar="False"
        EnableDrillDown="False" HasCrystalLogo="False" HasToggleGroupTreeButton="false"
        HasToggleParameterPanelButton="false" ToolPanelView="None"></CR:CrystalReportViewer>
    </form>
</body>
</html>
