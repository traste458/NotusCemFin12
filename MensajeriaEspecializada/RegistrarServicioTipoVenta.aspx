<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarServicioTipoVenta.aspx.vb"
    Inherits="BPColSysOP.RegistrarServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registro Servicio Tipo Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
        };

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
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
        
        function ManejarCierreDeVentanaDeAutorizacion(s, e) {
            cbRequerido.SetChecked(true);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <script type="text/javascript">
            var idJornada = "<%= cmbJornada.ClientID %>";
            var dateFechaAgenda = "<%= dateFechaAgenda.ClientID %>";
            var idCiudadEntrega = "<%= cmbCiudadEntrega.ClientID %>";
            var idPlan = "<%= cmbPlan.ClientID %>";
            var fechasNoDisponibles = "<%= hfFechasNoDisponibles.ClientID %>";
            var idRegion = "<%= cmbRegion.ClientID %>";
        </script>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <%--Callback Manejo cupos de Entrega--%>
        <dx:ASPxCallback ID="cbCuposEntrega" runat="server" ClientInstanceName="CallbackCupos">
            <ClientSideEvents CallbackComplete="function(s, e) {
            LoadingPanel.Hide(); 
            document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
            document.getElementById('divFechaAgenda').innerHTML = s.cpControlAgenda;
        }" />
        </dx:ASPxCallback>
        <%--Callback Manejo Precio Equipo--%>
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) { 
            LoadingPanel.Hide(); 
            document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
            var objEquipo = ASPxClientControl.GetControlCollection().GetByName('lblValorEquipo');
            objEquipo.SetText(e.result);
        }" />
        </dx:ASPxCallback>
        <dx:ASPxRoundPanel ID="rpRegistros" runat="server" HeaderText="Información de la Preventa">
            <PanelCollection>
                <dx:PanelContent>
                    <table cellpadding="1">
                        <tr>
                            <td>Ciudad de Entrega:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                    Width="250px" ClientInstanceName="cmbCiudadEntrega">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La ciudad es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                            <td>Campaña:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbCompania" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                    Width="400px" AutoPostBack="false" ClientInstanceName="cmbCompania" >
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                            if(cmbCiudadEntrega.GetValue()!=null) {
                                                LoadingPanel.Show();
                                                cmbPlan.PerformCallback();
                                            } else {
                                                alert(&#39;Se debe seleccionar una Ciudad de Entrega antes de seleccionar una campa&#241;a.&#39;);
                                                cmbCompania.SetText(null);
                                                cmbPlan.SetText(null);
                                                cmbCiudadEntrega.Focus();
                                            }
                                        }"></ClientSideEvents>
                                    <ValidationSettings Display="Dynamic" ErrorText="Valor incorrecto" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" ErrorText="La campa&#241;a es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Plan:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbPlan" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                    Width="400px" ValueField="idPlan" DropDownWidth="600" AutoPostBack="false" ClientInstanceName="cmbPlan"
                                     EncodeHtml="False">
                                    <ValidationSettings Display="Dynamic" ErrorText="Valor incorrecto" ErrorDisplayMode="ImageWithTooltip">
                                        <RequiredField IsRequired="True" ErrorText="El plan es requerido"></RequiredField>
                                    </ValidationSettings>
                                    <ClientSideEvents EndCallback="function(s, e) { 
                                        s.SetSelectedIndex(-1); 
                                        cmbEquipo.PerformCallback();
                                    }"
                                        SelectedIndexChanged="function(s, e) {
                                            LoadingPanel.Show();
                                            cmbEquipo.PerformCallback();
                                        }"></ClientSideEvents>
                                    <Columns>
                                        <dx:ListBoxColumn FieldName="nombrePlan" Width="50%" Caption="Plan" />
                                        <dx:ListBoxColumn FieldName="descripcion" Width="50%" Caption="Descripción" />
                                        <dx:ListBoxColumn FieldName="cargoFijoMensual" Width="100px" Caption="CFM" />
                                    </Columns>
                                </dx:ASPxComboBox>
                            </td>
                            <td>Equipo:
                            </td>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbEquipo" runat="server" ValueType="System.String" DropDownWidth="600"
                                                IncrementalFilteringMode="Contains" Width="300px" ValueField="material" AutoPostBack="false"
                                                Style="display: inline!important" ClientInstanceName="cmbEquipo">
                                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgRegistrar">
                                                    <RequiredField IsRequired="True" ErrorText="El equipo es requerido"></RequiredField>
                                                </ValidationSettings>
                                                <ClientSideEvents EndCallback="function(s, e) {
                                                s.SetSelectedIndex(-1); 
                                                document.getElementById('divEncabezado').innerHTML = s.cpMensaje;
                                                LoadingPanel.Hide(); 
                                            }"
                                                    SelectedIndexChanged="function(s, e) {
                                                if(cmbEquipo.GetSelectedItem().texts[2] != 0){
                                                    Callback.PerformCallback();
                                                    LoadingPanel.Show();
                                                } else {
                                                    alert('El equipo seleccionado no tiene disponibilidad de inventario.');
                                                    s.SetSelectedIndex(-1);
                                                }
                                            }"></ClientSideEvents>
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="material" Width="50px" Caption="Material" />
                                                    <dx:ListBoxColumn FieldName="referencia" Width="100%" Caption="Descripción Material" />
                                                    <dx:ListBoxColumn FieldName="cantidad" Width="100px" Caption="Cantidad Disponible" />
                                                </Columns>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td>
                                            <dx:ASPxCheckBox ID="cbRequerido" runat="server" Checked="true" Text="Requerido"
                                                Style="display: inline!important;" Theme="Aqua" ClientInstanceName="cbRequerido">
                                                <ClientSideEvents CheckedChanged="ValidarCambioEstadoEquipoRequerido"></ClientSideEvents>
                                                <CheckBoxStyle Font-Size="XX-Small" />
                                            </dx:ASPxCheckBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>Identificación del Cliente:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtIdentificacionCliente" runat="server" Width="170px" NullText="Número de Cédula..."
                                    onkeypress="javascript:return ValidaNumero(event);" MaxLength="15">
                                    <ValidationSettings ErrorText="Valor incorrecto" CausesValidation="True" Display="Dynamic"
                                        ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                            <td colspan="2">
                                <dx:ASPxLabel ID="lblValorEquipo" runat="server" Font-Bold="False" ClientInstanceName="lblValorEquipo"
                                    Font-Italic="True" Font-Overline="False" Font-Strikeout="False" Width="100%"
                                    ForeColor="#6600CC" Theme="Aqua">
                                </dx:ASPxLabel>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>Nombres del Cliente:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtNombresCliente" runat="server" NullText="Nombres y Apellidos..."
                                    Width="400px">
                                    <ValidationSettings ErrorText="Valor incorrecto" CausesValidation="True" Display="Dynamic"
                                        ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="El Nombre del Cliente es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                            <td>Barrio:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del cliente..." Width="400px">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="El barrio es requerido"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Dirección:
                            </td>
                            <td>
                                <as:AddressSelector ID="asDireccion" runat="server" />
                                <div style="clear: both; display: table">
                                    <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" ControlToValidate="asDireccion:memoDireccion"
                                        Display="Dynamic" ErrorMessage="La dirección es requerida." ValidationGroup="vgRegistrar"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                            <td>Observaciones sobre dirección:
                            </td>
                            <td>
                                <dx:ASPxMemo ID="memoObservacionDireccion" runat="server" Width="400px" NullText="Información adicional a la dirección..."
                                    Rows="2">
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td>Teléfono Móvil:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtTelefonoMovil" runat="server" Width="170px" MaxLength="10"
                                    NullText="Número Celular del cliente..." onkeypress="javascript:return ValidaNumero(event);">
                                    <MaskSettings Mask="3000000000"></MaskSettings>
                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                        <RequiredField ErrorText="El teléfono móvil es requerido" IsRequired="True"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxTextBox>
                            </td>
                            <td>Teléfono Fijo:
                            </td>
                            <td>
                                <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" Width="170px" NullText="Número fijo del cliente...">
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Forma de Pago:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbFormaPago" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La forma de pago es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                            <td>Clausula:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbClausula" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La cl&#225;usula es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Región de la línea:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbRegion" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                    ClientInstanceName="cmbRegion">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La regi&#243;n es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                            <td>Jornada:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbJornada" runat="server" IncrementalFilteringMode="Contains">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                        ValidationGroup="vgRegistrar">
                                        <RequiredField IsRequired="True" ErrorText="La jornada es requerida"></RequiredField>
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Fecha agenda:
                            </td>
                            <td>
                                <div id="divFechaAgenda">
                                    <dx:ASPxDateEdit ID="dateFechaAgenda" runat="server" NullText="Seleccione..." Width="100px"
                                        ClientInstanceName="dateFechaAgenda">
                                        <ClientSideEvents DateChanged="function(s, e) {
                                            var ctrlJornada = ASPxClientControl.GetControlCollection().GetByName(idJornada);
                                            var ctrlAgenda = ASPxClientControl.GetControlCollection().GetByName(dateFechaAgenda);
                                            var ctrlCiudadEntrega = ASPxClientControl.GetControlCollection().GetByName(idCiudadEntrega);
                                            var ctrlFechasNoDisponibles = ASPxClientControl.GetControlCollection().GetByName(fechasNoDisponibles);
                                                                                                
                                            if(ctrlJornada.GetValue()!=null &amp;&amp; ctrlCiudadEntrega.GetValue()!=null){
                                                if(ctrlFechasNoDisponibles.Get('fechas').indexOf(s.GetDate().yyyymmdd()) == -1) {
                                                    CallbackCupos.PerformCallback('ValidarCupos');
                                                    LoadingPanel.Show();    
                                                } else {
                                                    alert('La fecha seleccionada se encuentra marcada cómo no disponible.');
                                                    s.SetValue(null);
                                                    s.Focus();
                                                }
                                            } else {
                                                alert('Se debe seleccionar una Ciudad de Entrega y Jornada antes de seleccionar la fecha de agenda.');
                                                dateFechaAgenda.SetValue(null);
                                                if(ctrlCiudadEntrega.GetValue()==null) {
                                                    ctrlCiudadEntrega.Focus();
                                                } else {
                                                    ctrlJornada.Focus();
                                                }
                                            }
                                        }"></ClientSideEvents>
                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                            ValidationGroup="vgRegistrar">
                                            <RequiredField ErrorText="La fecha de agenda es requerida" IsRequired="True"></RequiredField>
                                        </ValidationSettings>
                                    </dx:ASPxDateEdit>
                                </div>
                                <dx:ASPxHiddenField ID="hfFechasNoDisponibles" runat="server" ClientInstanceName="hfFechasNoDisponibles">
                                </dx:ASPxHiddenField>
                            </td>
                            <td>Observaciones:
                            </td>
                            <td>
                                <dx:ASPxMemo ID="memoObservaciones" runat="server" NullText="Observaciones generales del servicio..."
                                    Rows="3" Width="400px">
                                </dx:ASPxMemo>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center" style="width: 100%">
                                <table>
                                    <tr>
                                        <td style="padding-right:10px!important">
                                            <dx:ASPxButton ID="btnGuardar" runat="server" Text="Guardar" ValidationGroup="vgRegistrar"
                                                Width="150px" HorizontalAlign="Center" Style="display: inline">
                                                <ClientSideEvents Click="function(s, e) {
                                                if(ASPxClientEdit.ValidateGroup(&#39;vgRegistrar&#39;)) {
                                                    Callback.PerformCallback();
                                                    LoadingPanel.Show();
                                                }
                                            }"></ClientSideEvents>
                                                <Image Url="../images/save_all.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                        <td style="padding-left:10px;">
                                            <dx:ASPxButton ID="btnLimpiaCampos" runat="server" Text="Limpiar Campos" Width="150px"
                                                HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                                <ClientSideEvents Click="function(s, e) {
                                                LimpiaFormulario();
                                            }"></ClientSideEvents>

                                                <Image Url="../images/eraserminus.gif">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
        <dx:ASPxPopupControl ID="pcAutorizar" runat="server" ClientInstanceName="pcAutorizar"
            HeaderText="Autorizar Registro sin Equipo" AllowDragging="true" Width="310px"
            Height="160px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            Modal="True" CloseAction="CloseButton">
            <ClientSideEvents CloseButtonClick="ManejarCierreDeVentanaDeAutorizacion" />
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <table cellpadding="1" align="center">
                        <tr>
                            <td>Clase de SIM:
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbClaseSIM" runat="server" ValueType="System.Int32">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAutorizar">
                                        <RequiredField ErrorText="La Clase de SIM es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <dx:ASPxRoundPanel ID="rpAutenticacion" runat="server" Width="100%" HeaderText="Credenciales de Usuario Autorizado">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table cellpadding="1">
                                                <tr>
                                                    <td>Usuario:
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
                                                    <td>Clave:
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
                            <td colspan="2" align="center">
                                <dx:ASPxButton ID="btnAutorizar" runat="server" Text="Autorizar" ValidationGroup="vgAutorizar">
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
