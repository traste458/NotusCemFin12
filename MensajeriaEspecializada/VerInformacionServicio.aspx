<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VerInformacionServicio.aspx.vb"
    Inherits="BPColSysOP.VerInformacionServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx" TagName="EncabezadoSM"
    TagPrefix="esm" %>
<%@ Register Src="~/ControlesDeUsuario/OfficeTrackInformacionRuta.ascx" TagName="OfficeTrack"
    TagPrefix="ot" %>
<%@ Register Src="../ControlesDeUsuario/NotificacionGuiaTransportadora.ascx" TagName="notificacionTransp" TagPrefix="uc3" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Ver Información del Servicio</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
    <script type="text/javascript">
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
        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc;
        }
    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize()">
    <form id="form1" runat="server">
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <asp:Panel ID="pnlGeneral" runat="server">
        <esm:EncabezadoSM ID="esmInformacion" runat="server" />
        <br />
        <asp:Panel ID="pnlInfoServicioTecnico" runat="server" Visible="false">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%" valign="top">
                        <asp:GridView ID="gvSerialesPrestamo" runat="server" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="idDetalle" HeaderText="ID" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="serial" HeaderText="IMEI Reparación" />
                                <asp:BoundField DataField="ReferenciaReparado" HeaderText="Referencia" />
                                <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                <asp:CheckBoxField DataField="requierePrestamoEquipo" HeaderText="Requiere Préstamo"
                                    ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="serialPrestamo" HeaderText="Serial Préstamo" />
                                <asp:BoundField DataField="ReferenciaPrestamo" HeaderText="Referencia" />
                                <asp:BoundField DataField="fechaEntregaServicioTecnicoString" HeaderText="Fecha Entrega"
                                    DataFormatString="{0:dd/MM/yyyy}" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlInfoReposicion" runat="server" Visible="false">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%; vertical-align:top">
                        <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                            ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                            <div style="display: block; padding-bottom: 3px;">
                                <asp:LinkButton ID="lbVerSeriales" runat="server" CssClass="search"><img src="../images/view.png" alt=""/>&nbsp;Ver Seriales</asp:LinkButton>
                            </div>
                        </eo:CallbackPanel>
                        <asp:GridView ID="gvListaReferencias" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen referencias asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia Solicitada" />
                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadLeida" HeaderText="Cantidad Le&iacute;da" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadCambio" HeaderText="Cantidad Cambio" ItemStyle-HorizontalAlign="Center" />
                                <asp:TemplateField HeaderText="Disponibilidad">
                                    <ItemTemplate>
                                        <asp:Image ID="imgDisponibilidad" ImageUrl="~/images/BallGreen.gif" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <br />
                        <asp:GridView ID="gvNovedad" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                    DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="ComentarioEspecifico" HeaderText="Comentario Espec&iacute;fico" />
                                <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 45%; vertical-align:top">
                        <asp:GridView ID="gvListaMsisdn" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen MSISDNs asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                <asp:BoundField DataField="numeroReserva" HeaderText="No. Reserva" />
                                <asp:BoundField DataField="activaEquipoAnteriorTexto" HeaderText="Activar Equipo Anterior (S/N)"
                                    ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="comseguroTexto" HeaderText="Comseguro (S/N)" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="precioConIva" HeaderText="Precio Con Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="precioSinIva" HeaderText="Precio Sin Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="clausula" HeaderText="Clausula" />
                                <asp:TemplateField HeaderText="Lista 28">
                                    <ItemTemplate>
                                        <asp:Image ID="imgLista28" ImageUrl="~/images/transparent_16.gif" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                     <td style="width: 45%; vertical-align:top">
                        <asp:GridView ID="gvHistorialReagenda" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existe historial de agendamientos&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="fechaAgendaActual" HeaderText="Fecha Agenda Anterior" DataFormatString="{0:dd/MM/yyyy}"/>
                                <asp:BoundField DataField="jornadaActual" HeaderText="Jornada Agenda Anterior"/>
                                <asp:BoundField DataField="fechaAgendaNueva" HeaderText="Fecha Agenda Nueva" DataFormatString="{0:dd/MM/yyyy}"/>
                                <asp:BoundField DataField="jornadaNueva" HeaderText="Jornada Agenda Nueva"/>
                                <asp:BoundField DataField="tipoAgenda" HeaderText="Tipo Agendamiento"/>
                                <asp:BoundField DataField="usuarioRegistro" HeaderText="Usuario Registro"/>   
                            </Columns>
                        </asp:GridView>
                    </td>
                     <td style="width: 10%">
                        &nbsp;
                    </td>
                   <td style="width: 45%; vertical-align:top">
                        <asp:GridView ID="gvHistorialRechazo" runat="server" Width="100%" AutoGenerateColumns="false" 
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existe historial de Novedades en Mesa de Control&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="Causal" HeaderText="Causal" />
                                <asp:BoundField DataField="Origen" HeaderText="Origen" />
                                <asp:BoundField DataField="tercero" HeaderText="Responsable" />
                                <asp:BoundField DataField="fechaModificacion" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}"/>
                            </Columns>
                        </asp:GridView>

                    </td>
                </tr>
                <tr style="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                    <td>Información de Documentos</td>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="gvDocumentos" runat="server" Width="100%" AutoGenerateColumns="false" DataKeyNames ="IdDocumento"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existe historial de documentos&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="NombreDocumento" HeaderText="Nombre del Documento"/>
                                <asp:BoundField DataField="NombreArchivo" HeaderText="Nombre del Archivo"/>
                                <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha de Recepción" DataFormatString="{0:dd/MM/yyyy}"/>
                                <asp:TemplateField HeaderText="Opciones">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbVer" runat="server" CommandName="verDocumento" CommandArgument='<%# Bind("IdDocumento")%>'
                                            ToolTip="Ver Información del Documento">
                                            <asp:Image ID="imgDisponibilidad" ImageUrl="~/images/DxPdf.png" runat="server" />
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField> 
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
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

        <uc3:notificacionTransp ID="UCNotificacionGuia" runat="server" />

        <eo:CallbackPanel ID="cpSeriales" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
            <eo:Dialog runat="server" ID="dlgSerial" ControlSkinID="None" Height="350px" HeaderHtml="Detalle de Seriales"
                CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                <ContentTemplate>
                    <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%;
                        overflow: auto;">
                        <table style="text-align:center" class="tabla">
                            <tr>
                                <td>
                                    <asp:GridView ID="gvSeriales" runat="server" Width="100%" AutoGenerateColumns="false"
                                        ShowFooter="true" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                        <Columns>
                                            <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia" />
                                            <asp:BoundField DataField="Serial" HeaderText="Serial" />
                                            <asp:BoundField DataField="Msisdn" HeaderText="MSISDN" />
                                            <asp:BoundField DataField="Factura" HeaderText="Factura" />
                                            <asp:BoundField DataField="Remision" HeaderText="Remisi&oacute;n" />
                                            <asp:BoundField DataField="EstadoSerial" HeaderText="Estado Serial" />
                                        </Columns>
                                        <FooterStyle CssClass="field" />
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </ContentTemplate>
                <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </FooterStyleActive>
                <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                </HeaderStyleActive>
                <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                </ContentStyleActive>
                <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                    TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                    TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                </BorderImages>
            </eo:Dialog>
        </eo:CallbackPanel>
    </asp:Panel>
    <br />
    <div style="display: inline">
        <i>La fuente requerida para visualizar el n&uacute;mero de radicado en c&oacute;digo
            de barras puede ser descargada </i>
        <asp:HyperLink ID="hlFuente" runat="server" NavigateUrl="Fuentes/Code39_0.ttf">Aqu&iacute;</asp:HyperLink>
    </div>
         <ot:OfficeTrack runat="server" id="OfficeTrackInfo" />
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
