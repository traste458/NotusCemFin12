<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VerInformacionServicioTipoVenta.aspx.vb"
    Inherits="BPColSysOP.VerInformacionServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx" TagName="EncabezadoVenta" TagPrefix="ev" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Información detallada de Servicio</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function GetWindowSize() {
            var myWidth = 0, myHeight = 0;
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }

            document.getElementById("hfMedidasVentana").value = myHeight + ";" + myWidth;
        }

        $(document).ready(function () {
            var notice = '<div class="notice">'
                            + '<div class="notice-body">'
							+ '<img src="../images/info.png" alt="" />'
							+ '<h3>Nota:</h3>'
							+ '<p>Recuerde que puede cerrar esta información con la tecla "ESC" o con el botón de la parte superior derecha.</p>'
							+ '</div>'
							+ '<div class="notice-bottom">'
							+ '</div>'
							+ '</div>';

            $(notice).purr(
							{
							    usingTransparentPNG: true,
							    removeTimer: 6000
							});
            return false;
        });

        function MostrarDocumentos(titulo, mensaje) {
            var notice = '<div class="notice">'
                            + '<div class="notice-body">'
							+ '<img src="../images/info.png" alt="" />'
							+ '<h3>' + titulo + '</h3>'
							+ '<p>' + mensaje + '</p>'
							+ '</div>'
							+ '<div class="notice-bottom">'
							+ '</div>'
							+ '</div>';

            $(notice).purr(
							{
							    usingTransparentPNG: true,
							    isSticky: true
							});
            return false;
        }
    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize()">
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True">
    </dx:ASPxLoadingPanel>
    <dx:ASPxGlobalEvents ID="global" runat="server">
        <ClientSideEvents ControlsInitialized="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxGlobalEvents>

    <script type="text/javascript">
        LoadingPanel.Show();
        window.onbeforeunload = doBeforeUnload;
        function doBeforeUnload() {
            LoadingPanel.Show();
        }
    </script>

    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <asp:UpdatePanel ID="upFormulario" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            
            <ev:EncabezadoVenta runat="server" ID="evEncabezado" />

            

            <div style="clear:both" />

            <div style="margin-top: 10px; float: left; width: 90%;">
                <dx:ASPxRoundPanel ID="rpNovedades" runat="server" Width="100%"
                    HeaderText="Novedades">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" Width="100%"
                                ClientInstanceName="gridNovedad">
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True" VisibleIndex="0"
                                        Caption="Tipo de Novedad">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UsuarioRegistra" ShowInCustomizationForm="True" VisibleIndex="1"
                                        Caption="Registrada Por">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FechaRegistro" ShowInCustomizationForm="True" VisibleIndex="2"
                                        Caption="Fecha de Registro">
                                        <PropertiesTextEdit DisplayFormatString="{0:d}" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ComentarioEspecifico" ShowInCustomizationForm="True" VisibleIndex="3"
                                        Caption="Comentario Espec&iacute;fico">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True" VisibleIndex="4"
                                        Caption="Comentario General">
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                            </dx:ASPxGridView>
                        </dx:PanelContent>
                    </PanelCollection>

                    
                </dx:ASPxRoundPanel>
            </div>
            <div style="margin-top: 10px; margin-right: 10px; float:left; width: 60%;">
                <dx:ASPxRoundPanel ID="rpAgenda" runat="server" HeaderText="Información de Agendamientos" Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gvAgendamientos" runat="server" AutoGenerateColumns="false" 
                            Width="100%">
                            <Columns>
                                <dx:GridViewDataTextColumn Caption="Fecha Agenda Anterior" FieldName="fechaAgendaActual" 
                                    ShowInCustomizationForm="True" VisibleIndex="0">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Jornada Agenda Anterior" FieldName="jornadaActual" 
                                    ShowInCustomizationForm="True" VisibleIndex="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Fecha Agenda Nueva" FieldName="fechaAgendaNueva" 
                                    ShowInCustomizationForm="True" VisibleIndex="2">
                                    <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Jornada Agenda Nueva" FieldName="jornadaNueva" 
                                    ShowInCustomizationForm="True" VisibleIndex="3">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Tipo Agendamiento" FieldName="tipoAgenda" 
                                    ShowInCustomizationForm="True" VisibleIndex="4">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn Caption="Usuario Registro" FieldName="usuarioRegistro" 
                                    ShowInCustomizationForm="True" VisibleIndex="5">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView> 
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            </div> 
            <div>
                  <asp:Panel ID="pnlCambioEstado" runat="server" Visible="true">
            <table class="tabla" style="width: 95%">
                <tr style="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                    <td>Información de cambios de estado</td>
                </tr>
                <tr>
                    <td style="width: 45%" valign="top">

                        <asp:GridView ID="gvCambioEstado" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen registros asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="idRegistro" HeaderText="Registro No." ItemStyle-HorizontalAlign="Center" Visible="false" />
                                <asp:BoundField DataField="estadoAnterior" HeaderText="Estado anterior" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="estadoActual" HeaderText="Estado actual" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="usuarioCambio" HeaderText="Usuario de cambio" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="hora" HeaderText="Hora" ItemStyle-HorizontalAlign="Center" />
                                
                            </Columns>
                        </asp:GridView>                        

                        </td>
                </tr>
            </table>
        </asp:Panel>
      
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
