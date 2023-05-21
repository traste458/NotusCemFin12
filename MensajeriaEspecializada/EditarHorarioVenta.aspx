<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarHorarioVenta.aspx.vb" Inherits="BPColSysOP.EditarHorarioVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar Horario</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { 
                LoadingPanel.Hide(); 
                document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
            }" />
        </dx:ASPxCallback>
        <dx:ASPxRoundPanel ID="rpEncabezado" runat="server" HeaderText="Información del Horario"
            Width="100%">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1" width="100%">
                        <tr>
                            <td>Jornada:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbJornada" runat="server" ValueType="System.Int32">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgHorario">
                                        <RequiredField ErrorText="La jornada es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Hora Inicio:</td>
                            <td>
                                <dx:ASPxTimeEdit ID="timeHoraInicio" runat="server">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgHorario">
                                        <RequiredField ErrorText="La hora de inicio es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td>Hora Fin:</td>
                            <td>
                                <dx:ASPxTimeEdit ID="timeHoraFin" runat="server" AutoResizeWithContainer="True">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                        ValidationGroup="vgHorario">
                                        <RequiredField ErrorText="La hora final es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td>Activo:</td>
                            <td>
                                <dx:ASPxCheckBox ID="chbActivo" runat="server" CheckState="Checked">
                                </dx:ASPxCheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <div style="text-align: center; width: 100%">
                                    <dx:ASPxButton ID="btnModificar" runat="server" Text="Modificar" Width="110px" Style="display: inline"
                                        AutoPostBack="false">
                                        <Image Url="../images/save_all.png">
                                        </Image>
                                        <ClientSideEvents Click="function(s, e) {
                                            if(ASPxClientEdit.ValidateGroup('vgHorario')) {
                                                Callback.PerformCallback();
                                            }
                                        }" />
                                    </dx:ASPxButton>
                                </div>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
