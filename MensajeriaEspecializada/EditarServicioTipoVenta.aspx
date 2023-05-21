<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarServicioTipoVenta.aspx.vb"
    Inherits="BPColSysOP.EditarServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Editar Servicio Tipo Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
</head>
<body class="cuerpo2">
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" Modal="true" ClientInstanceName="LoadingPanel" />
    <dx:ASPxGlobalEvents ID="global" runat="server">
        <ClientSideEvents ControlsInitialized="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxGlobalEvents>
    <script type="text/javascript">
        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
        };

        var idRegion = "<%= cmbRegion.ClientID %>";
        var fechasNoDisponibles = "<%= hfFechasNoDisponibles.ClientID %>";
        var idJornada = "<%= cmbJornada.ClientID %>";
        var dateFechaAgenda = "<%= dateFechaAgenda.ClientID %>";
        var idCiudadEntrega = "<%= cmbCiudadEntrega.ClientID %>";

        LoadingPanel.Show();
        window.onbeforeunload = doBeforeUnload;
        function doBeforeUnload() {
            LoadingPanel.Show();
        }

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

        function ValidarCambioEstadoEquipoRequerido(s, e) {
            var checked = cbRequerido.GetChecked();
            if (!checked) {
                pcAutorizar.Show();
                //var ctrlRegion = ASPxClientControl.GetControlCollection().GetByName(idRegion);
                //if (ctrlRegion.GetValue() == null && !s.GetValue()) {
                //    alert('Debe seleccionar la región antes de solicitar autorización.');
                //    s.SetValue(true);
                //} else {
                //    pcAutorizar.Show();
                //}
                cmbEquipo.SetSelectedIndex(-1)
                cmbEquipo.SetEnabled(false);
            } else {
                cmbEquipo.PerformCallback();
                cmbEquipo.SetEnabled(true);
                cmbEquipo.SetSelectedIndex(-1)
            }
        }
    </script>
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>

    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { 
            LoadingPanel.Hide(); 
            var obj = ASPxClientControl.GetControlCollection().GetByName('lblValorEquipo');
            obj.SetText(e.result);
            document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
        }" />
    </dx:ASPxCallback>
        
    <dx:ASPxRoundPanel ID="rpEdidatServicio" runat="server" HeaderText="Editar información de la Venta">
        <PanelCollection>
            <dx:PanelContent>
                <table cellpadding="1">
                    <tr>
                        <td>
                            Ciudad de Entrega:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" SelectedIndex="0" ValueType="System.Int32" AutoPostBack ="true" ClientEnabled="false">
                                <Items>
                                    <dx:ListEditItem Selected="True" Text="Seleccione una ciudad..." Value="0" />
                                </Items>
                            </dx:ASPxComboBox>
                        </td>
                        <td>
                            Campaña:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCompania" runat="server" ValueType="System.Int32" AutoPostBack ="true" Width ="250px">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="idCampania" Width="70px" Caption="Id." />
                                    <dx:ListBoxColumn FieldName="nombre" Width="300px" Caption="Descripción" />
                                </Columns>
                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorText="Valor incorrecto">
                                    <RequiredField ErrorText="La campaña es requerida" IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Plan:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbPlan" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                Width="400px" ValueField="idPlan" DropDownWidth="600" AutoPostBack="True" 
                                ClientInstanceName ="cmbPlan">
                                <ValidationSettings Display="Dynamic" ErrorText="Valor incorrecto" ErrorDisplayMode="ImageWithTooltip">
                                    <%--<RequiredField IsRequired="True" ErrorText="El plan es requerido"></RequiredField>--%>
                                </ValidationSettings>
                                <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                    Callback.PerformCallback();
                                    LoadingPanel.Show();
                                }" />
                                <Columns>
                                    <dx:ListBoxColumn FieldName="idPlan" Width="30px" Caption="Id" />
                                    <dx:ListBoxColumn FieldName="nombrePlan" Width="50%" Caption="Plan" />
                                    <dx:ListBoxColumn FieldName="descripcion" Width="50%" Caption="Descripción" />
                                    <dx:ListBoxColumn FieldName="cargoFijoMensual" Width="100px" Caption="CFM" />
                                </Columns>
                            </dx:ASPxComboBox>
                        </td>
                        <td>
                            Equipo:
                        </td>
                        <td>
                            <div style="float: left; margin-right: 0px;">
                                <dx:ASPxComboBox ID="cmbEquipo" runat="server" ValueType="System.String" DropDownWidth="600" 
                                    IncrementalFilteringMode="Contains" Width="300px" ValueField="material" AutoPostBack="True" ClientInstanceName ="cmbEquipo">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <%--<RequiredField ErrorText="El equipo es requerido" IsRequired="True" />--%>
                                    </ValidationSettings>
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                    Callback.PerformCallback();
                                    LoadingPanel.Show();
                                }" />
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="material" Width="50px" Caption="Material" />
                                        <dx:ListBoxColumn FieldName="referencia" Width="100%" Caption="Descripción Material" />
                                        <dx:ListBoxColumn FieldName="cantidad" Width="100px" Caption="Cantidad Disponible" />
                                    </Columns>
                                </dx:ASPxComboBox>
                            </div>
                            <div style="float: left; margin-right: 0px;">
                                <dx:ASPxCheckBox ID="cbRequerido" runat="server" Checked="true" Text="Requerido"
                                    Style="display: inline;" Theme="Aqua" ClientInstanceName="cbRequerido" AutoPostBack="false">
                                    <CheckBoxStyle Font-Size="XX-Small" />
                                    <ClientSideEvents CheckedChanged="ValidarCambioEstadoEquipoRequerido" />
                                </dx:ASPxCheckBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Identificación del Cliente:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtIdentificacionCLiente" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </td>
                        <td colspan="2">
                            <dx:ASPxLabel ID="lblValorEquipo" runat="server" Font-Bold="False" ClientInstanceName="lblValorEquipo"
                                Font-Italic="True" Font-Overline="False" Font-Strikeout="False" ForeColor="#6600CC">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Nombres del Cliente:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtNombresCliente" runat="server" Width="400px">
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            Barrio:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtBarrio" runat="server" Width="400px">
                            </dx:ASPxTextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Dirección:
                        </td>
                        <td>
                            <as:AddressSelector ID="asDireccion" runat="server" />
                            <div style="clear: both; display: table">
                                <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" ControlToValidate="asDireccion:memoDireccion"
                                    Display="Dynamic" ErrorMessage="La dirección es requerida." ValidationGroup="vgRegistrar"></asp:RequiredFieldValidator>
                            </div>
                        </td>
                        <td>
                            Observaciones sobre dirección:
                        </td>
                        <td>
                            <dx:ASPxMemo ID="memoObservacionDireccion" runat="server" Width="400px" NullText="Información adicional a la dirección..."
                                Rows="2">
                            </dx:ASPxMemo>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Teléfono Móvil:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtTelefonoMovil" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </td>
                        <td>
                            Teléfono Fijo:
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" Width="170px">
                            </dx:ASPxTextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Forma de Pago:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbFormaPago" runat="server" SelectedIndex="0" ValueType="System.Int32">
                                <Items>
                                    <dx:ListEditItem Selected="True" Text="Seleccione Forma de Pago..." Value="0" />
                                </Items>
                            </dx:ASPxComboBox>
                        </td>
                        <td>
                            Clausula:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbClausula" runat="server" SelectedIndex="0" ValueType="System.Int32">
                                <Items>
                                    <dx:ListEditItem Selected="True" Text="Selecione una clausula..." Value="0" />
                                </Items>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Región de la línea:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbRegion" runat="server" SelectedIndex="0" ValueType="System.Int32">
                                <Items>
                                    <dx:ListEditItem Selected="True" Text="Seleccione una región..." Value="0" />
                                </Items>
                            </dx:ASPxComboBox>
                        </td>
                        <td>
                            Jornada:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbJornada" runat="server" SelectedIndex="0" 
                                ValueType="System.Int32">
                                <Items>
                                    <dx:ListEditItem Selected="True" Text="Seleccione una jornada..." Value="0" />
                                </Items>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Fecha agenda:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaAgenda" runat="server" NullText="Seleccione..." 
                                Width="100px">
                                <ClientSideEvents DateChanged="function(s, e) {
                                                var ctrlJornada = ASPxClientControl.GetControlCollection().GetByName(idJornada);
                                                var ctrlAgenda = ASPxClientControl.GetControlCollection().GetByName(dateFechaAgenda);
                                                var ctrlCiudadEntrega = ASPxClientControl.GetControlCollection().GetByName(idCiudadEntrega);
                                                var ctrlFechasNoDisponibles = ASPxClientControl.GetControlCollection().GetByName(fechasNoDisponibles);
                                                
                                                if(ctrlJornada.GetValue()!=null){
                                                    if(ctrlFechasNoDisponibles.Get('fechas').indexOf(s.GetDate().yyyymmdd()) == -1) {
                                                        Callback.PerformCallback('ValidarCupos');
                                                        LoadingPanel.Show();    
                                                    } else {
                                                        alert('La fecha seleccionada se encuentra marcada cómo no disponible.');
                                                        s.SetValue(null);
                                                        s.Focus();
                                                    }
                                                } else {
                                                    alert('Se debe seleccionar una Ciudad de Entrega y Jornada antes de seleccionar la fecha de agenda.');
                                                    ctrlAgenda.SetValue(null);
                                                    if(ctrlCiudadEntrega.GetValue()==null) {
                                                        ctrlCiudadEntrega.Focus();
                                                    } else {
                                                        ctrlJornada.Focus();
                                                    }
                                                }
                                            }" />
                                <ValidationSettings CausesValidation="True" Display="Dynamic" 
                                    ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                    <RequiredField ErrorText="La fecha de agenda es requerida" IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxDateEdit>
                            <dx:ASPxHiddenField ID="hfFechasNoDisponibles" runat="server" 
                                ClientInstanceName="hfFechasNoDisponibles">
                            </dx:ASPxHiddenField>
                        </td>
                        <td>
                            Observaciones:
                        </td>
                        <td>
                            <dx:ASPxMemo ID="memoObservaciones" runat="server" 
                                NullText="Observaciones generales del servicio..." Rows="3" Width="400px">
                            </dx:ASPxMemo>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <div style="width: 100%; text-align: center">
                                <dx:ASPxButton ID="btnActualizar" runat="server" Text="Actualizar" ValidationGroup="vgRegistrar"
                                    Theme="PlasticBlue" Width="150px" HorizontalAlign="Center" Style="display: inline">
                                    <Image Url="../images/save_all.png"></Image>
                                </dx:ASPxButton>
                            </div>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>

    <dx:ASPxPopupControl ID="pcAutorizar" runat="server" ClientInstanceName="pcAutorizar"
        HeaderText="Autorizar Registro sin Equipo" AllowDragging="true" Width="310px"
        Height="160px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        Modal="True">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <table cellpadding="1" align="center">
                    <tr>
                        <td align="center">
                            <dx:ASPxRoundPanel ID="rpClaseSim" runat="server" HeaderText="Clase de SIM">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxComboBox ID="cmbClaseSIM" runat="server" ValueType="System.Int32">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAutorizar">
                                                <RequiredField ErrorText="La Clase de SIM es requerida" IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <dx:ASPxRoundPanel ID="rpAutenticacion" runat="server" Width="100%" HeaderText="Credenciales de Usuario Autorizado">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table cellpadding="1">
                                            <tr>
                                                <td>
                                                    Usuario:
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtUsuarioAdmin" runat="server" Width="170px" NullText="Ingrese usuario...">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAutorizar">
                                                            <RequiredField ErrorText="El usuario es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Clave:
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtClaveAdmin" runat="server" Width="170px" MaxLength="50" NullText="Ingrese clave..."
                                                        Password="True">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAutorizar">
                                                            <RequiredField ErrorText="La clave es requerida" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <dx:ASPxButton ID="btnAutorizar" runat="server" Text="Autorizar" ValidationGroup="vgAutorizar">
                                <Image Url="../images/unlock.png"></Image>
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    </form>
</body>

</html>
