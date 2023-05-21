<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarNovedadServicioTipoVenta.aspx.vb" Inherits="BPColSysOP.RegistrarNovedadServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registro de Novedad Tipo Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        
        <dx:ASPxRoundPanel ID="rpRegistroNovedad" runat="server" HeaderText="Registro de Novedad">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1">
                        <tr>
                            <td>Tipo de Novedad:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbTipoNovedad" runat="server" ValueType="System.Int32">
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Observación:</td>
                            <td>
                                <dx:ASPxMemo ID="memoObservacion" runat="server" Height="71px" Width="170px">
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <div style="text-align: center; width: 100%">
                                    <dx:ASPxButton ID="btnAdicionar" runat="server" Text="Adicionar" Width="110px" Style="display: inline">
                                    </dx:ASPxButton>
                                    &nbsp;&nbsp;
                                    <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar Campos" Style="display: inline"
                                        Width="110px">
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </form>
</body>
</html>
