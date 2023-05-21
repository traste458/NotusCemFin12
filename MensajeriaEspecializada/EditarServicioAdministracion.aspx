<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarServicioAdministracion.aspx.vb" Inherits="BPColSysOP.EditarServicioAdministracion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Edición de Servicio Administracion - Mensajería Especializada</title>
    
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    
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
    </script>
</head>
<body class="cuerpo2" onload="GetWindowSize()">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
            <asp:HiddenField ID="hfMedidasVentana" runat="server" />
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true" UpdateMode="Always"
            LoadingDialogID="ldrWait_dlgWait">
            
            <asp:Panel ID="pnlBusquedaServicio" runat="server">
                <table class="tablaGris" style="width: auto; height: auto">
                    <tr>
                        <td class="field" align="left">
                            Número de Radicado:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtNumeroRadicado" runat="server" TabIndex="1"></asp:TextBox>
                            <div>
                                <asp:RequiredFieldValidator ID="rfvNumeroRadicado" runat="server" ErrorMessage="Numero de Radicado Requerido"
                                    Display="Dynamic" ControlToValidate="txtNumeroRadicado" ValidationGroup="vgLegalizacion"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                    ControlToValidate="txtNumeroRadicado" ValidationGroup="vgEdicion" ErrorMessage="El número de radicado digitado no es válido, por favor verifique."
                                    ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <br />
                            <br />
                            <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgEdicion">
                                    <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                    <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                            </asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
            <asp:Panel ID="pnlEdicionServicio" runat="server">
                <table class="tablagris" style="width: auto; height: auto">
                    <tr>
                        <th colspan="6">
                            INFORMACI&Oacute;N DEL SERVICIO
                        </th>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div style="display: block">
                                <font face="Bar-Code 39" size="4">
                                    <asp:Label ID="lblCodigoRadicado" runat="server" Font-Names="Bar-Code 39"></asp:Label>
                                </font>
                            </div>
                            <b>No. Radicado:</b>&nbsp;<asp:Label ID="lblNumRadicado" runat="server" Text=""></asp:Label>
                        </td>
                        <td colspan="3">
                            <b>Ejecutor:</b>&nbsp;<asp:Label ID="lblEjecutor" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <asp:Label ID="lblTipoServicio" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </td>
                        <td class="field">
                            Estado:
                        </td>
                        <td colspan="6">
                            <asp:Label ID="lblEstado" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Nombre Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblNombreCliente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            C&eacute;dula/Nit:
                        </td>
                        <td>
                            <asp:Label ID="lblIdentificacion" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Direcci&oacute;n Correspondencia:
                        </td>
                        <td>
                            <asp:Label ID="lblDireccion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Barrio:
                        </td>
                        <td>
                            <asp:Label ID="lblBarrio" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Ciudad donde se encuentra Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblCiudad" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Tel&eacute;fono de Contacto:
                        </td>
                        <td>
                            <asp:Label ID="lblTelefono" runat="server" Text=""></asp:Label>
                            <asp:Label ID="lblExtension" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Persona de Contacto (Autorizado):
                        </td>
                        <td>
                            <asp:Label ID="lblPersonaContacto" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Agendamiento:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaAgenda" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Jornada:
                        </td>
                        <td>
                            <asp:Label ID="lblJornada" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha de Registro:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRegistro" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Registrado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblRegistradoPor" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Prioridad:
                        </td>
                        <td>
                            <asp:Label ID="lblPrioridad" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha Confirmacion:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaConfirmacion" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Confirmado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblUsuarioConfirma" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Bodega CME:
                        </td>
                        <td>
                            <asp:Label ID="lblBodega" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha Despacho:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaDespacho" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Despachado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblUsuarioDespacho" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Cambio Servicio:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaCambioServicio" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Zona:
                        </td>
                        <td>
                            <asp:Label ID="lblZona" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Responsable Entrega:
                        </td>
                        <td>
                            <asp:Label ID="lblResponsableEntrega" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Entrega:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaEntrega" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Observaciones:
                        </td>
                        <td colspan="5">
                            <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
            <asp:Panel ID="pnlInfoReposicion" runat="server" Visible="false">
                <table class="tabla" style="width: 95%" cellspacing="3">
                    <tr>
                        <td colspan="3">
                            <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                                <div style="display: block; padding-bottom: 3px;">
                                    <asp:LinkButton ID="lbVerSeriales" runat="server" CssClass="search"><img src="../images/view.png" alt=""/>&nbsp;Ver Seriales</asp:LinkButton>
                                </div>
                            </eo:CallbackPanel>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 49%" valign="top">
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
                        </td>
                        <td style="width: 2%">
                            &nbsp;
                        </td>
                        <td style="width: 49%" valign="top">
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
                    </tr>
                    <tr>
                        <td style="width: 49%" valign="top">
                            <asp:GridView ID="gvListaMsisdn" runat="server" AutoGenerateColumns="false" Width="100%"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen MSISDNs asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <Columns>
                                    <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                    <asp:BoundField DataField="Factura" HeaderText="Factura" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Remision" HeaderText="Remisión" ItemStyle-HorizontalAlign="Center" />
                                    
                                    
                                    <asp:TemplateField HeaderText="Opciones" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ibEditar" runat="server" CommandArgument='<%# Bind("idDetalle") %>' CommandName="Editar" ImageUrl="../images/Edit-32.png" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
            
            <eo:CallbackPanel ID="cpSeriales" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                <eo:Dialog runat="server" ID="dlgSerial" ControlSkinID="None" Height="350px" HeaderHtml="Detalle de Seriales"
                    CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                    <ContentTemplate>
                        <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%;
                            overflow: auto;">
                            <table align="center" class="tabla">
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
            
            <eo:CallbackPanel ID="cpEdicionSeriales" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                <eo:Dialog runat="server" ID="dlgEdicionSeriales" ControlSkinID="None" Height="350px" HeaderHtml="Detalle Edición de Seriales"
                    CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50" CancelButton="lbCerrarPopUp">
                    <ContentTemplate>
                        <asp:Panel ID="pnlEdicionSeriales" runat="server" Style="height: 100%; width: 100%; overflow: auto;">
                            <table align="center" class="tablaGris">
                                <tr>
                                    <td class="field">Id:</td>
                                    <td>
                                        <asp:Label ID="lblEditarId" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">MSISDN:</td>
                                    <td>
                                        <asp:TextBox ID="txtEditarMsisdn" runat="server" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Serial:</td>
                                    <td>
                                        <asp:TextBox ID="txtEditarSerial" runat="server" Enabled="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Factura:</td>
                                    <td>
                                        <asp:TextBox ID="txtEdicionFactura" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">Remisión:</td>
                                    <td>
                                        <asp:TextBox ID="txtEdicionRemision" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <br />
                                        <asp:LinkButton ID="lbEditarGuardar" runat="server" ValidationGroup="vgEditarGuardar"
                                            CssClass="search"><img src="../images/save_all.png" alt="" />&nbsp;Guardar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="search"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
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
            
        </eo:CallbackPanel>
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
