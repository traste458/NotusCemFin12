<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteIndicadoresSiembra.aspx.vb"
    Inherits="BPColSysOP.ReporteIndicadoresSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Reporte Indicadores SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">

    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>

    <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtro de Búsqueda"
        ClientInstanceName="rpFiltros">
        <PanelCollection>
            <dx:PanelContent>
                <table>
                    <tr>
                        <td>
                            Fecha Inicial:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                        <td>
                            Fecha Final:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                    if (dateFechaInicio.GetDate()==null){
                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                        }
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Width="100px" AutoPostBack="false">
                                    <ClientSideEvents Click="function(s, e) {
                                        
                                    }" />
                                    <Image Url="../images/Excel.gif">
                                    </Image>
                                </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
    </form>
</body>
</html>
