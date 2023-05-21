<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AsignarZonaServicioMensajeria.aspx.vb" Inherits="BPColSysOP.AsignarZonaServicioMensajeria" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">
    <title>Asignar Zona- Servicio Mensajeria</title>
    
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                var tgId = callback.getEventTarget();
                if (tgId == "btnRegistrar") {
                    var txt = document.getElementById("txtSerial");
                    if (txt) {
                        if (!txt.disabled) { txt.select(); }
                    }
                }
            } catch (e) {
                alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }
        }
    </script>
    
    <style type="text/css">
        .style1
        {
            height: 27px;
        }
    </style>
    
</head>

<body class="cuerpo2">
    <form id="form1" runat="server">
    
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
    </eo:CallbackPanel>
    
    <asp:Panel ID="pnlGeneral" runat="server">
        <table class="tabla" style="width: 95%">
            <tr>
                <th colspan="6">
                    INFORMACI&Oacute;N DEL SERVICIO
                </th>
            </tr>
            <tr>
                <td colspan="3">
                    <b>No. Radicado:</b>&nbsp;<asp:Label ID="lblNumRadicado" runat="server" Text=""></asp:Label>
                </td>
                <td colspan="3">
                    <b>Ejecutor:</b>&nbsp;<asp:Label ID="lblEjecutor" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <asp:Label ID="lblTipoServicio" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
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
                    Observaciones:
                </td>
                <td colspan="5">
                    <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>
        <br />
        
        <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" ClientSideAfterUpdate="CallbackAfterUpdateHandler">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%" valign="top">
                        <asp:Panel ID="pnlLectura" runat="server">
                            <table style=" width: 100%">
                                <tr>
                                    <th colspan="2">
                                        ASIGNACIÓN DE ZONA
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field" align="center">Zona</td>
                                    <td class="field" align="center">Motorizado</td>
                                </tr>
                                
                                <tr>
                                    <td class="style1">
                                        <asp:DropDownList ID="ddlZona" runat="server" Width="200px" AutoPostBack="True">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvZona" runat="server" ErrorMessage="El valor del campo Zona es requerido."
                                        Display="Dynamic" ControlToValidate="ddlZona" InitialValue="0" ValidationGroup="actualizacion"></asp:RequiredFieldValidator>
                                    </td>
                                    <td class="style1">
                                        <asp:DropDownList ID="ddlRecurso" runat="server" Width="200px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                
                                <tr><td colspan="2">&nbsp;</td></tr>
                                
                                <tr>
                                    <td colspan="2">
                                        <asp:LinkButton ID="lbGuardar" runat="server" CssClass="search" ValidationGroup="actualizacion">
                                            <img src="../images/save_all.png" alt="" />&nbsp;Guardar</asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 45%" valign="top">
                        <asp:GridView ID="gvListaReferencias" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen referencias asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia Solicitada" />
                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadLeida" HeaderText="Cantidad Le&iacute;da" ItemStyle-HorizontalAlign="Center" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </eo:CallbackPanel>
        
    </asp:Panel>
    
    <uc2:Loader ID="ldrWait" runat="server" />
    
    <script language="javascript" type="text/javascript">
        function CambiarEnfoque() {
            var ctrl = document.getElementById("txtSerial");
            if (ctrl != null) {
                if (!ctrl.disabled) { ctrl.select(); }
            }
        }
        window.setTimeout("CambiarEnfoque()", 10)
    </script>
    </form>
</body>
</html>
