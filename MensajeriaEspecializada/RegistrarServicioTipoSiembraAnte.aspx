<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarServicioTipoSiembraAnte.aspx.vb"
    Inherits="BPColSysOP.RegistrarServicioTipoSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDirecciondv.ascx" TagName="AddressSelector"
    TagPrefix="as" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Registro de Servicio SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
        <script src="../include/jquery-1.4.2.min.js" type="text/javascript"></script>
        <script src="../include/jquery.timers.js" type="text/javascript"></script>
    
    <script language="javascript" type="text/javascript">

        $().ready(function () {

            $(document).everyTime(4000, function () {

                $.ajax({
                    type: "POST",
                    url: "RegistrarServicioTipoSiembra.aspx/KeepActiveSession",
                    data: {},
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: VerifySessionState,
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus + ": " + XMLHttpRequest.responseText);
                    }
                });

            });


        });

        var cantValidaciones = 0;

        function VerifySessionState(result) {

            lbcantValidaciones.SetValue(cantValidaciones);
            cantValidaciones++;

        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function FiltrarDevExpMaterial(s, e) {
            try {
                if (e.htmlEvent.keyCode >= 97 && e.htmlEvent.keyCode <= 122
                    || e.htmlEvent.keyCode >= 65 && e.htmlEvent.keyCode <= 90
                    || e.htmlEvent.keyCode >= 48 && e.htmlEvent.keyCode <= 57
                    || (e.htmlEvent.keyCode == 32 || e.htmlEvent.keyCode == 8)) {
                    if (s.GetText().length >= 4 || cmbEquipo.GetItemCount() != 0) {
                        //s.SetEnabled(true);
                        cpFiltroMaterial.PerformCallback(s.GetText());
                    }
                }
            } catch (e) { }
        }

        function AdicionarEquipo(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgAdicionarCombinacion')) {
                if (cmbEquipo.GetValue() != null || (cmbClaseSim.GetValue() != null)) {
                    gvEquipos.PerformCallback('registrar');
					cmbEquipo.ClearItems();
					cmbEquipo.SetEnabled(false);
                } else {
                    alert('La seleccion de un Equipo y/o Sim es requerida.');
                }
            }
        }

        function EliminarEquipo(s, key) {
            if (confirm('¿Realmente desea eliminar la referencia?')) {
                gvEquipos.PerformCallback('eliminar|' + key);
            }
        }

        function EditarEquipo(s, key) {
            callbackRegistro.PerformCallback('editarEquipo|' + key);
        }

        function ActualizarEquipo(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgAdicionarCombinacion')) {
                if (cmbEquipo.GetValue() != null || (cmbClaseSim.GetValue() != null)) {
                    gvEquipos.PerformCallback('actualizar');
					cmbEquipo.ClearItems();
					cmbEquipo.SetEnabled(false);
                    CancelarEquipo()
                } else {
                    alert('La seleccion de un Equipo y/o Sim es requerida.');
                }
            }
        }

        function CancelarEquipo() {
            LimpiarFiltroEquipo();

            btnAdicionarCombinacion.SetVisible(true);
            btnEdicionCombinacion.SetVisible(false);
            btnCancelarEdicion.SetVisible(false);
        }

        function RegistrarServicio(s, e) {
            var cantidadEquipos = 0;

            if (ASPxClientEdit.ValidateGroup('vgRegistrar')) {
                cantidadEquipos = gvEquipos.GetVisibleRowsOnPage();

                if (cantidadEquipos > 0) {
                    callbackRegistro.PerformCallback('registrar');
                } else {
                    alert('Se debe seleccionar al menos un Equipo ó Sim para registrar el servicio');
                }
            }
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                dateFechaSolicitud.SetDate(new Date());
                txtMsisdn.SetEnabled(false);
                dateFechaAgenda.SetEnabled(false);
                btnAdicionarCombinacion.SetEnabled(false);
                btnAdicionarCombinacion.SetEnabled(false);
                lblResultadoMaterial.SetVisible(false);
            }
        }

        function LimpiarFiltroEquipo() {
            rblTipo.SetSelectedIndex(-1);
            txtMsisdn.SetValue(null);
            cmbPlan.SetValue(null);
            dateFechaAgenda.SetValue(null);
            cmbEquipo.SetValue(null);
            cmbClaseSim.SetValue(null);
            cmbPaquete.SetValue(null);
            txtMsisdn.Focus();
        }

        function ControlarCambioCombinacion(s, e) {
            txtMsisdn.SetEnabled(true);
            dateFechaAgenda.SetEnabled(true);
            btnAdicionarCombinacion.SetEnabled(true);
            switch (s.GetValue()) {
                //Equipo y Sim                
                case "0":
                    cmbPlan.SetEnabled(true);
                    cmbPaquete.SetEnabled(true);
                    cmbEquipo.SetEnabled(true);
                    cmbClaseSim.SetEnabled(false);
                    cmbClaseSim.ClearItems();
                    lblResultadoMaterial.SetVisible(false);
                    cmbEquipo.ClearItems();
                    break;
                    //Solo equipo
                case "1":
                    cmbPlan.SetEnabled(false);
                    cmbPlan.SetSelectedIndex(-1);
                    cmbPaquete.SetEnabled(false);
                    cmbPaquete.SetSelectedIndex(-1);
                    cmbEquipo.SetEnabled(true);
                    cmbClaseSim.ClearItems();
                    cmbClaseSim.SetEnabled(false);
                    lblResultadoMaterial.SetVisible(false);
                    break;

                    //Solo Sim
                case "2":
                    cmbPlan.SetEnabled(true);
                    cmbPaquete.SetEnabled(true);
                    cmbEquipo.SetEnabled(false);
                    cmbEquipo.ClearItems();
                    //cmbClaseSim.SetEnabled(true);
                    lblResultadoMaterial.SetVisible(false);
                    cmbClaseSim.PerformCallback("CargarTodas");
                    break;
            }
        }

        function EstablecerTipoSim(s, e) {
            var tipo = rblTipo.GetValue();
            if (tipo == 0) {
                cmbClaseSim.PerformCallback(s.GetValue());
            }
        }

        function ControlFinalizacionClaseSIM(s, e) {
            MostrarInfoEncabezado(s, e);

            if (s.cpTipoSeleccionado) {
                s.SetValue(s.cpTipoSeleccionado);
                s.SetEnabled(false);
            } else {
                s.SetEnabled(true);
                //s.SetSelectedIndex(-1);
            }
        }

        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
            }
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxRoundPanel ID="rpRegistroSiembra" runat="server" HeaderText="Información del Servicio Siembra">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName="callbackRegistro">
                        <ClientSideEvents EndCallback="MostrarInfoEncabezado" />
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxFormLayout ID="flRegistro" runat="server" ColCount="2">
                                    <Items>
                                        <dx:LayoutItem Caption="Fecha de Solicitud:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                    <dx:ASPxDateEdit ID="dateFechaSolicitud" runat="server" Width="100px" ClientInstanceName="dateFechaSolicitud">
                                                    </dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Ciudad de Entrega:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                    <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" DropDownStyle="DropDownList"
                                                        ValueField="idCiudad" ValueType="System.String" TextFormatString="{0} ({1})"
                                                        IncrementalFilteringMode="Contains" Width="300px">
                                                        <Columns>
                                                            <dx:ListBoxColumn FieldName="nombreCiudad" Caption="Ciudad" Width="200px" />
                                                            <dx:ListBoxColumn FieldName="nombreDepartamento" Caption="Departamento" Width="200px" />
                                                        </Columns>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="La ciudad es requerida" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre de la Empresa:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                    <dx:ASPxTextBox ID="txtNombreEmpresa" runat="server" NullText="Nombre de la Empresa..."
                                                        Width="300px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="El nombre de la empresa es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número NIT:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                    <dx:ASPxTextBox ID="txtIdentificacionCliente" runat="server" MaxLength="10" NullText="NIT..."
                                                        onkeypress="javascript:return ValidaNumero(event);" Width="170px">
                                                        <MaskSettings Mask="0000000009" />
                                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                            ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="La identificación es requerida" IsRequired="True" />
                                                            <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono Fijo Empresa:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                    <div style="display: inline; float: left">
                                                        <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" NullText="Número fijo del cliente..."
                                                            Width="170px">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                                <RequiredField ErrorText="E teléfono fjo de la empresa es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                    <div style="display: inline; float: left">
                                                        &nbsp;Ext.&nbsp;
                                                    </div>
                                                    <div style="display: inline; float: left">
                                                        <dx:ASPxTextBox ID="txtExtTelefonoFijo" runat="server" NullText="Extensión..." Width="70px">
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre Representante Legal:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                    <dx:ASPxTextBox ID="txtNombreRepresentante" runat="server" NullText="Nombre Representante Legal..."
                                                        Width="300px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El nombre del representante es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número Cédula Representante:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                    <dx:ASPxTextBox ID="txtIdentificacionRepresentante" runat="server" MaxLength="15"
                                                        NullText="Cédula Representante..." onkeypress="javascript:return ValidaNumero(event);"
                                                        Width="170px">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono Celular Representante:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                    <dx:ASPxTextBox ID="txtTelefonoMovilRepresentante" runat="server" Height="19px" MaxLength="10"
                                                        NullText="Número Celular del Representante..." onkeypress="javascript:return ValidaNumero(event);"
                                                        Width="170px">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre persona Autorizada:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                    <dx:ASPxTextBox ID="txtPersonaAutorizada" runat="server" NullText="Nombre Persona Autorizada..."
                                                        Width="300px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número Cédula Autorizado:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                    <dx:ASPxTextBox ID="txtIdentificacionAutorizado" runat="server" MaxLength="15" NullText="Cédula Autorizado..."
                                                        onkeypress="javascript:return ValidaNumero(event);" Width="170px">
                                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                            ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Cargo Persona Autorizada:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                    <dx:ASPxTextBox ID="txtCargoPersonaAutorizada" runat="server" Width="300px">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El cargo de la Persona autorizada es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono persona autorizada:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                    <dx:ASPxTextBox ID="txtTelefonoAutorizado" runat="server" MaxLength="10" NullText="Número Celular Autorizado..."
                                                        onkeypress="javascript:return ValidaNumero(event);" Width="170px">
                                                        <MaskSettings Mask="3000000000"></MaskSettings>
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El tel&#233;fono m&#243;vil es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Dirección:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server">
                                                    <as:AddressSelector ID="memoDireccion" runat="server" />
                                                    <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" ControlToValidate="memoDireccion"
                                                        Display="Dynamic" ErrorMessage="La dirección es requerida." ValidationGroup="vgRegistrar"></asp:RequiredFieldValidator>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                            <CaptionSettings VerticalAlign="Middle"></CaptionSettings>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Observaciones sobre dirección:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server">
                                                    <dx:ASPxMemo ID="memoObservacionDireccion" runat="server" NullText="Información adicional a la dirección..."
                                                        Rows="2" Width="300px">
                                                    </dx:ASPxMemo>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Barrio:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server">
                                                    <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del Cliente..." Width="300px">
                                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El barrio es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Gerencia:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server">
                                                    <dx:ASPxComboBox ID="cmbGerencia" runat="server" ClientInstanceName="cmbGerencia"
                                                        DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idGerencia"
                                                        Width="300px">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="La Gerencia es requerida"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Coordinador:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer22" runat="server">
                                                    <dx:ASPxComboBox ID="cmbCoordinador" runat="server" ClientInstanceName="cmbCoordinador"
                                                        DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="IdTercero"
                                                        ValueType="System.Int32" Width="300px" ClientEnabled="false">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El Coordinador es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Consultor:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server">
                                                    <dx:ASPxComboBox ID="cmbConsultor" runat="server" ClientInstanceName="cmbConsultor"
                                                        DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="IdTercero"
                                                        ValueType="System.Int32" Width="300px" ClientEnabled="false">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El Consultor es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Cliente Claro:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server">
                                                    <dx:ASPxRadioButtonList ID="rblClienteClaro" runat="server">
                                                        <Items>
                                                            <dx:ListEditItem Text="Sí" Value="1" />
                                                            <dx:ListEditItem Text="No" Value="0" />
                                                        </Items>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="Se debe especificar si esl cliente Claro" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxRadioButtonList>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Observaciones:">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server">
                                                    <dx:ASPxMemo ID="memoObservaciones" runat="server" NullText="Observaciones..." Rows="3"
                                                        Width="300px">
                                                    </dx:ASPxMemo>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                                <dx:ASPxRoundPanel ID="rpEquipos" runat="server" HeaderText="Información de Equipos">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxFormLayout ID="flEquipos" runat="server" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Tipo:" RequiredMarkDisplayMode="Required" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxRadioButtonList runat="server" ID="rblTipo" ClientInstanceName="rblTipo"
                                                                    RepeatDirection="Horizontal">
                                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
	                                                                ControlarCambioCombinacion(s, e);
                                                                }" />
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Equipo y SIM" Value="0" />
                                                                        <dx:ListEditItem Text="Solo Equipo" Value="1" />
                                                                        <dx:ListEditItem Text="Solo SIM" Value="2" />
                                                                    </Items>
                                                                    <ValidationSettings ValidationGroup="vgAdicionarCombinacion" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField ErrorText="Por favor seleccione una combinación" IsRequired="True" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxRadioButtonList>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="MSISDN" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtMsisdn" runat="server" ClientInstanceName="txtMsisdn" Height="19px"
                                                                    MaxLength="10" NullText="MSISDN..." onkeypress="javascript:return ValidaNumero(event);"
                                                                    Width="170px">
                                                                    <MaskSettings Mask="3000000000" />
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAdicionarCombinacion">
                                                                        <RequiredField ErrorText="El MSISDN es requerido" IsRequired="True" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fecha Devolución:" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server">
                                                                <dx:ASPxDateEdit ID="dateFechaDevolucionEquipo" runat="server" ClientInstanceName="dateFechaAgenda"
                                                                    NullText="Seleccione..." Width="100px">
                                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                        ValidationGroup="vgAdicionarCombinacion">
                                                                        <RequiredField ErrorText="La fecha de agenda es requerida" IsRequired="True" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Plan:" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server">
                                                                <dx:ASPxComboBox ID="cmbPlan" runat="server" ClientInstanceName="cmbPlan" IncrementalFilteringMode="Contains"
                                                                    ValueType="System.String">
                                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                        ValidationGroup="vgAdicionarCombinacion">
                                                                        <RequiredField ErrorText="El Plan es requerido" IsRequired="True" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Paquete:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cmbPaquete" runat="server" ClientInstanceName="cmbPaquete" IncrementalFilteringMode="Contains"
                                                                    ValueType="System.String">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Equipo:" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                 <dx:ASPxLabel ID="lbcantValidaciones" runat="server" CssClass="comentario" ClientInstanceName="lbcantValidaciones" Width="200px">
                                                                                </dx:ASPxLabel>
                                                               <dx:ASPxComboBox ID="cmbEquipo" runat="server" ClientInstanceName="cmbEquipo" ClientEnabled="false" IncrementalFilteringMode="Contains"
                                                                                TextFormatString="{0} ({1})" ValueField="Material" Width="450px" CallbackPageSize="20" EnableCallbackMode="True" FilterMinLength="4" IncrementalFilteringDelay="0" 
                                                                                OnItemRequestedByValue="cbCiudad_OnItemRequestedByValue_SQL" OnItemsRequestedByFilterCondition="cbCiudad_OnItemsRequestedByFilterCondition_SQL">
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { EstablecerTipoSim(s, e); }" />
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn Caption="Material" FieldName="Material" Width="60px" />
                                                                                    <dx:ListBoxColumn Caption="Referencia" FieldName="Referencia" Width="400px" />
                                                                                </Columns>
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                                                    ValidationGroup="vgAdicionarCombinacion">
                                                                                    <RequiredField ErrorText="Por favor seleccione un equipo" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                           
                                                                                
                                                                            <br />
                                                                            <div id="divResultadoMaterial">
                                                                                <dx:ASPxLabel ID="lblResultadoMaterial" runat="server" CssClass="comentario" ClientInstanceName="lblResultadoMaterial" Width="200px">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Tipo SIM:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cmbClaseSim" runat="server" ClientInstanceName="cmbClaseSim"
                                                                    IncrementalFilteringMode="Contains" ValueType="System.String"
                                                                    ClientEnabled="false" AutoPostBack="false">
                                                                    <ClientSideEvents EndCallback="function(s, e) {ControlFinalizacionClaseSIM(s, e);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                                        ValidationGroup="vgAdicionarCombinacion">
                                                                        <RequiredField ErrorText="Por favor seleccione un tipo de SIM"
                                                                            IsRequired="True" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                  
                                                </Items>
                                            </dx:ASPxFormLayout>
                                            <div style="width: 100%; text-align: center">
                                                <dx:ASPxButton ID="btnAdicionarCombinacion" runat="server" HorizontalAlign="Center" ClientInstanceName="btnAdicionarCombinacion"
                                                    AutoPostBack="false" Style="display: inline" Text="Adicionar" ValidationGroup="vgAdicionarCombinacion"
                                                    Width="150px">
                                                    <ClientSideEvents Click="function(s, e) {AdicionarEquipo()}"></ClientSideEvents>
                                                    <Image Url="../images/add.png"></Image>
                                                </dx:ASPxButton>

                                                <dx:ASPxButton ID="btnEdicionCombinacion" runat="server" HorizontalAlign="Center" ClientInstanceName="btnEdicionCombinacion"
                                                    AutoPostBack="false" Style="display: inline" Text="Actualizar" ValidationGroup="vgAdicionarCombinacion"
                                                    Width="150px" ClientVisible="false">
                                                    <ClientSideEvents Click="function(s, e) {ActualizarEquipo()}"></ClientSideEvents>
                                                    <Image Url="../images/cancelar.png"></Image>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btnCancelarEdicion" runat="server" HorizontalAlign="Center"
                                                    AutoPostBack="false" Style="display: inline" Text="Cancelar" ClientInstanceName="btnCancelarEdicion"
                                                    Width="150px" ClientVisible="false">
                                                    <ClientSideEvents Click="function(s, e) {CancelarEquipo()}"></ClientSideEvents>
                                                    <Image Url="../images/cross.png"></Image>
                                                </dx:ASPxButton>
                                                &nbsp;
                                            <br />
                                                <br />
                                                <dx:ASPxGridView ID="gvCombinacionEquipos" runat="server" AutoGenerateColumns="False"
                                                    ClientInstanceName="gvEquipos" KeyFieldName="msisdn" Width="100%">
                                                    <ClientSideEvents EndCallback="function(s, e) {
                                                    MostrarInfoEncabezado(s,e); 

                                                    if (s.cpMensajeEquipoError=='0') {
                                                        LimpiarFiltroEquipo();
                                                    }
                                                }" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="MSISDN" ShowInCustomizationForm="True" VisibleIndex="0"
                                                            FieldName="msisdn">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Plan" ShowInCustomizationForm="True" VisibleIndex="1"
                                                            FieldName="plan">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Paquete" ShowInCustomizationForm="True" VisibleIndex="1"
                                                            FieldName="paquete">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Material" FieldName="material" ShowInCustomizationForm="True"
                                                            VisibleIndex="3">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Tipo SIM" ShowInCustomizationForm="True" VisibleIndex="5"
                                                            FieldName="tipoSim">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Descripción" FieldName="referencia" ShowInCustomizationForm="True"
                                                            VisibleIndex="4">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="Fecha Devolución" FieldName="fechaDevolucion"
                                                            ShowInCustomizationForm="True" VisibleIndex="2">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn Caption="Región SIM" ShowInCustomizationForm="True" VisibleIndex="11"
                                                            FieldName="region">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataColumn Caption="Opc." ShowInCustomizationForm="True" VisibleIndex="12"
                                                            Width="80px">
                                                            <DataItemTemplate>
                                                                <dx:ASPxHyperLink ID="lnkEliminar" runat="server" Cursor="pointer" ImageUrl="../images/Delete-32.png"
                                                                    OnInit="Link_InitEquipo" ToolTip="Eliminar">
                                                                    <ClientSideEvents Click="function(s, e) { EliminarEquipo(this, {0}) }" />
                                                                </dx:ASPxHyperLink>
                                                                <dx:ASPxHyperLink ID="lnkEditar" runat="server" Cursor="pointer" ImageUrl="../images/Edit-User.png"
                                                                    ToolTip="Editar">
                                                                    <ClientSideEvents Click="function(s, e) { EditarEquipo(this, {0}) }" />
                                                                </dx:ASPxHyperLink>
                                                            </DataItemTemplate>
                                                        </dx:GridViewDataColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords">
                                                    </SettingsPager>
                                                </dx:ASPxGridView>

                                            </div>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td align="center">
                                            <div style="width: 100%; text-align: center">
                                                <dx:ASPxButton ID="btnGuardar" runat="server" AutoPostBack="False" HorizontalAlign="Center"
                                                    Style="display: inline" Text="Guardar" ValidationGroup="vgRegistrar" Width="150px">
                                                    <ClientSideEvents Click="function(s, e) {
                                                                RegistrarServicio(s, e);
                                                            }" />
                                                    <Image Url="../images/save_all.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                                &nbsp;&nbsp;
                                            <dx:ASPxButton ID="btnLimpiaCampos" runat="server" AutoPostBack="False" CausesValidation="False"
                                                HorizontalAlign="Center" Style="display: inline" Text="Limpiar Campos" Width="150px">
                                                <ClientSideEvents Click="function(s, e) {
                                                                LimpiaFormulario();
                                                            }" />
                                                <Image Url="../images/eraserminus.gif">
                                                </Image>
                                            </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </form>
</body>
</html>
