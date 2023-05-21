<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EncabezadoServicioMensajeria.ascx.vb" Inherits="BPColSysOP.EncabezadoServicioMensajeria" %>
<script language="javascript" type="text/javascript">
    function Imprimir(ctrl) {
        ctrl.style.display = "none";
        window.print();
        ctrl.style.display = "block";
    }   
</script>
<table width="100%">
    <tr>
        <td colspan="2">
            <div style="display: block">
                <font face="Bar-Code39" size="4">
                    <asp:Label ID="lblCodigoRadicado" runat="server" Font-Names="Bar-Code39"></asp:Label>
                </font>
            </div>
            <b>No. Radicado:</b>&nbsp;&nbsp;<asp:Label ID="lblNumRadicado" runat="server" Text=""></asp:Label>
        </td>
        <td aling="center">
            <asp:Label ID="lblClienteVIP" runat="server" Text="" Font-Bold="true" Font-Size="XX-Large"></asp:Label>
        </td>
        <td colspan="2">
            <b><asp:Label ID="lblEjecutor" runat="server" Text=""></asp:Label></b>
        </td>
        <td align="right" style="margin-left: 40px">
            <asp:Image ID="imgImprimir" runat="server" ImageUrl="~/images/print.png" Style="cursor: pointer;" onclick="javascript: Imprimir(this);" />
        </td>
    </tr>
</table>
<table class="tabla" width="100%" style="border-collapse: collapse;" border="1" rules="all" cellspacing="0">
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
        <td class="field" width="17%">
            Nombre Cliente:
        </td>
        <td width="17%">
            <asp:Label ID="lblNombreCliente" runat="server" Text=""></asp:Label>
        </td>
        <td class="field" width="16%">
            C&eacute;dula/Nit:
        </td>
        <td width="16%">
            <asp:Label ID="lblIdentificacion" runat="server" Text=""></asp:Label>
        </td>
        <td class="field" width="17%">
            Direcci&oacute;n Correspondencia:
        </td>
        <td width="17%">
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
        <td colspan="3">
            <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
        </td>
         <td class="field">
            Factura:
        </td>
         <td colspan="1">
            <asp:Label ID="lbFactura" runat="server" Text=""></asp:Label>
        </td>
    </tr>
    <tr>
        <td class="field">Medio envío Certificado Homologación:</td>
        <td>
            <asp:Label ID="lblMedioEnvioCH" runat="server" Text="" />
        </td>
        <td class="field" colspan="2">Correo Electrónico envío Certificado Homologación:</td>
        <td colspan="2">
            <asp:Label ID="lblCorreoElectronicoCH" runat="server" Text="" />
        </td>
    </tr>
    <tr>
        <td class="field">Actividad Laboral:</td>
        <td>
            <asp:Label ID="lblActividadLaboral" runat="server" Text="" />
        </td>
        <td class="field" colspan="2">Campaña:</td>
        <td colspan="2">
            <asp:Label ID="lblCampania" runat="server" Text="" />
        </td>
    </tr>
</table>