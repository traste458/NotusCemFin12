<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmacionServicioTipoSiembra.aspx.vb"
    Inherits="BPColSysOP.ConfirmacionServicioTipoSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Confirmación de Servicio SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var myWidth, myHeight;
        TamanioVentana();

        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
        };

        function TamanioVentana() {
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
                        s.SetEnabled(false);
                        cpFiltroMaterial.PerformCallback(s.GetText());
                    }
                }
            } catch (e) { }
        }

        function ControlFinFiltro(s, e) {
            try {
                if (txtEquipoFiltro.GetEnabled()) { txtEquipoFiltro.SetEnabled(true); }
                txtEquipoFiltro.SetCaretPosition(1);
                txtEquipoFiltro.Focus();
            } catch (e) { }
        }

        function AdicionarEquipo(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgAdicionarEquipo')) {
                gvEquipos.PerformCallback('registrar');
            }
        }

        function AdicionarSim(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgRegistrarSim')) {
                gvSIMs.PerformCallback('registrar');
            }
        }

        function EliminarEquipo(s, key) {
            if (confirm('¿Realmente desea eliminar la referencia?')) {
                gvEquipos.PerformCallback('eliminar|' + key);
            }
        }

        function EliminarSim(s, idClase, idRegion) {
            if (confirm('¿Realmente desea eliminar la referencia?')) {
                gvSIMs.PerformCallback('eliminar|' + idClase + ',' + idRegion);
            }
        }

        function ConfirmarServicio(s, e) {
            if ((gvEquipos.GetVisibleRowsOnPage() > 0) && ASPxClientEdit.ValidateGroup('vgRegistrar')) {
                callbackConfirmacion.PerformCallback();
            } else {
                alert('Se debe diligenciar todos los campos obligatorios y seleccionar al menos un Equipo o SIM.');
            }
        }

        function ValidacionFechaAgenda(s, e) {
            if (cmbJornada.GetValue() != null && cmbCiudadEntrega.GetValue() != null) {
                if (hfFechasNoDisponibles.Get('fechas').indexOf(s.GetDate().yyyymmdd()) == -1) {
                    CallbackCupos.PerformCallback();
                } else {
                    alert('La fecha seleccionada se encuentra marcada cómo no disponible.');
                    s.SetValue(null);
                    s.Focus();
                }
            } else {
                alert('Se debe seleccionar una Ciudad de Entrega y Jornada antes de seleccionar la fecha de agenda.');
                s.SetValue(null);
            }
        }

        function ControlFinCupoEntrega(s, e) {
            if (s.cpMensaje) { $('#divEncabezado').html(s.cpMensaje); }
            if (s.cpControlAgenda != null) {
                if (s.cpControlAgenda == '0')
                    dateFechaAgenda.SetValue(null);
            }
        }

        function VisualizarNovedades(s, e) {
            dialogoNovedades.SetSize(myWidth * 0.7, myHeight * 0.7);
            dialogoNovedades.SetVisible(true);
            gvNovedades.PerformCallback();
        }

        function AdicionarNovedad(s, e) {
            gvNovedades.PerformCallback('registrar');
        }

        function ControlFinNovedad(s, e) {
            cmbTipoNovedad.SetValue(null);
            memoObservacionesNovedad.SetText(null);
            if (s.cpMensajeRespuesta =='0') {
                btnConfirmar.SetEnabled(false);
            }
        }

        function ControlFinConfirmacion(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
            }
            else {
                setTimeout("window.location='PoolServiciosNew.aspx?resOk=true&codRes=1'", 500);
            }
            
        }

        function CerrarVisualizacionNovedad(s, e) {
            callbackConfirmacion.PerformCallback('novedades');
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    
    <%--Callback Manejo cupos de Entrega--%>
    <dx:ASPxCallback ID="cbCuposEntrega" runat="server" ClientInstanceName="CallbackCupos">
        <ClientSideEvents CallbackComplete="function(s, e) {
            ControlFinCupoEntrega(s, e);
        }" />
    </dx:ASPxCallback>

    <dx:ASPxRoundPanel ID="rpConfirmacionSiembra" runat="server" HeaderText="Confirmación del Servicio Siembra">
        <PanelCollection>
            <dx:PanelContent>
                
                <dx:ASPxCallbackPanel ID="cpConfirmacion" runat="server" ClientInstanceName="callbackConfirmacion">
                    <ClientSideEvents EndCallback="function(s, e) {
                        ControlFinConfirmacion(s, e);
                    }" />
                    <PanelCollection>
                        <dx:PanelContent>
                            
                            <dx:ASPxFormLayout ID="flRegistro" runat="server" ColCount="2">
                                <Items>
                                    <dx:LayoutItem Caption="Fecha de Solicitud:" RequiredMarkDisplayMode="Required">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                <dx:ASPxDateEdit ID="dateFechaSolicitud" runat="server" Width="100px">
                                                </dx:ASPxDateEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Estado:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                <dx:ASPxLabel ID="lblEstado" runat="server" 
                                                    style="font-weight: 700; font-size: medium">
                                                </dx:ASPxLabel>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Ciudad de Entrega:" RequiredMarkDisplayMode="Required">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" 
                                                    IncrementalFilteringMode="Contains" TextFormatString="{0} ({1})" 
                                                    ValueField="idCiudad" Width="300px" ClientEnabled="false" ClientInstanceName="cmbCiudadEntrega">
                                                    <Columns>
                                                        <dx:ListBoxColumn Caption="Ciudad" FieldName="nombreCiudad" Width="200px" />
                                                        <dx:ListBoxColumn Caption="Departamento" FieldName="nombreDepartamento" 
                                                            Width="200px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="La ciudad es requerida" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Nombre de la Empresa:" 
                                        RequiredMarkDisplayMode="Required">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                <dx:ASPxTextBox ID="txtNombreEmpresa" runat="server" 
                                                    NullText="Nombre de la Empresa..." Width="300px" ClientEnabled="False">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="El nombre de la empresa es requerido" 
                                                            IsRequired="True" />
                                                        <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Número NIT:" RequiredMarkDisplayMode="Required">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                <dx:ASPxTextBox ID="txtIdentificacionCliente" runat="server" MaxLength="15" 
                                                    NullText="NIT..." onkeypress="javascript:return ValidaNumero(event);" 
                                                    Width="170px" ClientEnabled="False">
                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" 
                                                        ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="La identificación es requerida" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Teléfono Fijo Empresa:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                <div style="display: inline; float: left">
                                                    <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" NullText="Número fijo del cliente..."
                                                        Width="170px" ClientEnabled="False">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField ErrorText="E teléfono fjo de la empresa es requerido" 
                                                                IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </div>
                                                <div style="display: inline; float: left">
                                                    &nbsp;Ext.&nbsp;
                                                </div>
                                                <div style="display: inline; float: left">
                                                    <dx:ASPxTextBox ID="txtExtTelefonoFijo" runat="server" NullText="Extensión..." 
                                                        Width="70px" ClientEnabled="False">
                                                    </dx:ASPxTextBox>
                                                </div>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Nombre Representante Legal:" 
                                        RequiredMarkDisplayMode="Required">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                <dx:ASPxTextBox ID="txtNombreRepresentante" runat="server" 
                                                    NullText="Nombre Representante Legal..." Width="300px" 
                                                    ClientEnabled="False">
                                                    <ValidationSettings 
                                                        ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="El nombre del representante es requerido" 
                                                            IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Número Cédula Representante:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                <dx:ASPxTextBox ID="txtIdentificacionRepresentante" runat="server" MaxLength="15"
                                                    NullText="Cédula Representante..." onkeypress="javascript:return ValidaNumero(event);"
                                                    Width="170px" ClientEnabled="False">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar" CausesValidation="True" 
                                                        ErrorText="Valor incorrecto">
                                                        <RequiredField IsRequired="True" ErrorText="La identificación es requerida">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Teléfono Celular Representante:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                <dx:ASPxTextBox ID="txtTelefonoMovilRepresentante" runat="server" NullText="Número Celular del Representante..."
                                                    Width="170px" Height="19px" MaxLength="10" 
                                                    onkeypress="javascript:return ValidaNumero(event);" ClientEnabled="False">
                                                    <MaskSettings Mask="3000000000" />
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar" Display="Dynamic">
                                                        <RequiredField ErrorText="El teléfono móvil es requerido" 
                                                            IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Nombre persona Autorizada:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                <dx:ASPxTextBox ID="txtPersonaAutorizada" runat="server" 
                                                    NullText="Nombre Persona Autorizada..." Width="300px" 
                                                    ClientEnabled="False">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" 
                                                            ErrorText="El nombre de la persona autorizada es requerido">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Número Cédula Autorizado:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                <dx:ASPxTextBox ID="txtIdentificacionAutorizado" runat="server" Width="170px" 
                                                    MaxLength="15" NullText="Cédula Autorizado..." 
                                                    onkeypress="javascript:return ValidaNumero(event);" ClientEnabled="False">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar" CausesValidation="True" 
                                                        ErrorText="Valor incorrecto">
                                                        <RequiredField IsRequired="True" 
                                                            ErrorText="La identificación es requerida">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Cargo Persona Autorizada:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                <dx:ASPxTextBox ID="txtCargoPersonaAutorizada" runat="server" Width="300px" 
                                                    ClientEnabled="False">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" 
                                                            ErrorText="El cargo de la Persona autorizada es requerido">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Teléfono persona autorizada:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server">
                                                <dx:ASPxTextBox ID="txtTelefonoAutorizado" runat="server" MaxLength="10" 
                                                    NullText="Número Celular Autorizado..." 
                                                    onkeypress="javascript:return ValidaNumero(event);" Width="170px" 
                                                    ClientEnabled="False">
                                                    <MaskSettings Mask="3000000000" />
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="El teléfono móvil es requerido" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Barrio:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server">
                                                <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del Cliente..." 
                                                    Width="300px" ClientEnabled="false" >
                                                    <ValidationSettings CausesValidation="True" Display="Dynamic" 
                                                        ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="El barrio es requerido" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Dirección:" VerticalAlign="Middle">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server">
                                                <as:AddressSelector ID="memoDireccion" runat="server" />
                                                <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" 
                                                    ControlToValidate="memoDireccion" Display="Dynamic" 
                                                    ErrorMessage="La dirección es requerida." ValidationGroup="vgRegistrar"></asp:RequiredFieldValidator>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <CaptionSettings VerticalAlign="Middle" />
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Observaciones sobre dirección:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server">
                                                <dx:ASPxMemo ID="memoObservacionDireccion" runat="server" 
                                                    NullText="Información adicional a la dirección..." Rows="2" Width="300px">
                                                </dx:ASPxMemo>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Gerencia:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server">
                                                <dx:ASPxComboBox ID="cmbGerencia" runat="server" ClientInstanceName="cmbGerencia"
                                                    DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idGerencia"
                                                    ValueType="System.Int32" Width="300px">
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                                            
                                                        }" />
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
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
                                                    ValueType="System.Int32" Width="300px">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" ErrorText="El Coordinador es requerido"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Consultor:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server">
                                                <dx:ASPxComboBox ID="cmbConsultor" runat="server" ClientInstanceName="cmbConsultor"
                                                    DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="IdTercero"
                                                    ValueType="System.Int32" Width="300px">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" ErrorText="El Consultor es requerido"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Cliente Claro:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server">
                                                <dx:ASPxRadioButtonList ID="rblClienteClaro" runat="server" 
                                                    ClientEnabled="False">
                                                    <Items>
                                                        <dx:ListEditItem Text="Sí" Value="1" />
                                                        <dx:ListEditItem Text="No" Value="0" />
                                                    </Items>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                        ValidationGroup="vgRegistrar">
                                                        <RequiredField ErrorText="Se debe especificar si esl cliente Claro" 
                                                            IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxRadioButtonList>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Observaciones:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxMemo ID="memoObservaciones" runat="server" NullText="Observaciones..." 
                                                    Rows="3" Width="300px">
                                                </dx:ASPxMemo>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Jornada de Entrega:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server">
                                                <dx:ASPxComboBox ID="cmbJornada" runat="server" ClientInstanceName="cmbJornada"
                                                    DropDownWidth="150px" IncrementalFilteringMode="Contains" ValueField="idJornada"
                                                    ValueType="System.Int32" Width="150px">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" ErrorText="La Jornada es requerida"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Fecha de Agenda:">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server">
                                                <dx:ASPxDateEdit ID="dateFechaAgenda" runat="server" Width="100px" ClientInstanceName="dateFechaAgenda">
                                                    <ClientSideEvents DateChanged="function(s, e) { ValidacionFechaAgenda(s, e) }" />
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                                        ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                        <RequiredField IsRequired="True" ErrorText="La Fecha de entrega es requerida"></RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxDateEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    
                                </Items>
                            </dx:ASPxFormLayout>
                            <dx:ASPxHiddenField ID="hfFechasNoDisponibles" runat="server" ClientInstanceName="hfFechasNoDisponibles">
                            </dx:ASPxHiddenField>
                            <table cellpadding="1" width="100%">
                                <tr>
                                    <td valign="top" align="center" style="width: 100%">
                                        <dx:ASPxRoundPanel ID="rpEquipos" runat="server" 
                                            HeaderText="Información de Referencias">
                                            <ContentPaddings Padding="5px" />
                                            <ContentPaddings Padding="5px"></ContentPaddings>
                                            <PanelCollection>
                                                <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                                                     <table>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxGridView ID="gvEquipos" runat="server" AutoGenerateColumns="False" 
                                                                    ClientInstanceName="gvEquipos" KeyFieldName="material" >
                                                                    <ClientSideEvents EndCallback="function(s, e) {
                                                                        if (s.cpMensajeEquipo) {
                                                                            $('#divEncabezado').html(s.cpMensajeEquipo);
                                                                        } 

                                                                        if (s.cpMensajeEquipoError) {
                                                                            $('#divEncabezado').html(s.cpMensajeEquipoError);
                                                                            $('html, body').animate({ scrollTop: 0 }, 'slow');
                                                                        }
                                                                    }" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Material" FieldName="material" 
                                                                            ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Descripción" FieldName="referencia" 
                                                                            ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Cantidad" FieldName="cantidad" 
                                                                            ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn Caption="Fecha Devolución" 
                                                                            FieldName="fechaDevolucion" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                        </dx:GridViewDataDateColumn>
                                                                          <dx:GridViewDataDateColumn Caption="cantidad Disponible" 
                                                                            FieldName="cantidadDisponible" ShowInCustomizationForm="True" VisibleIndex="4" Visible="False">
                                                                        </dx:GridViewDataDateColumn>
                                                                    
                                                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="12">
                                                                            <DataItemTemplate>
                                                                                <dx:ASPxHyperLink runat="server" ID="lnkDisponibilidad"  AutoPostBack="False"  OnInit="LinkDisponibilidad_Init"
                                                                                    ImageUrl="../images/BallGreen.gif" Cursor="pointer">
                                                                                   </dx:ASPxHyperLink>
                                                                            </DataItemTemplate> 
                                                                        </dx:GridViewDataColumn> 
                                                                    </Columns>
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                </dx:ASPxGridView>
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
                                        <div style="width: 100%; text-align: center">
                                            <dx:ASPxButton ID="btnConfirmar" runat="server" Text="Confirmar Servicio" ValidationGroup="vgRegistrar"
                                                Width="200px" HorizontalAlign="Center" Style="display: inline" ClientInstanceName="btnConfirmar" 
                                                AutoPostBack="false">
                                                <ClientSideEvents Click="function(s, e) {
                                                                ConfirmarServicio(s, e);
                                                            }">
                                                </ClientSideEvents>
                                                <Image Url="../images/confirmation.png">
                                                </Image>
                                            </dx:ASPxButton>
                                            &nbsp;&nbsp;
                                            <dx:ASPxButton ID="btnNovedad" runat="server" Text="Gestión Novedades"
                                                Width="200px" HorizontalAlign="Center" Style="display: inline" 
                                                AutoPostBack="false">
                                                <ClientSideEvents Click="function(s, e) {
                                                    VisualizarNovedades(s, e);
                                                }">
                                                </ClientSideEvents>
                                                <Image Url="../images/comment_add.png">
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

    <dx:ASPxPopupControl ID="pcNovedades" runat="server" AllowDragging="True" ClientInstanceName="dialogoNovedades"
        HeaderText="Gestión de Novedades" Modal="True" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter">
        <ClientSideEvents CloseUp="function(s, e) { CerrarVisualizacionNovedad(s, e); }" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            Tipo Novedad:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbTipoNovedad" runat="server" ClientInstanceName="cmbTipoNovedad"
                                DropDownWidth="600px" IncrementalFilteringMode="Contains" ValueField="idTipoNovedad"
                                ValueType="System.Int32" Width="300px">
                                <ClientSideEvents EndCallback="function(s, e) { 
                                            s.SetSelectedIndex(-1);     
                                        }" />
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" 
                                    ErrorText="Valor incorrecto" ValidationGroup="vgRegistrarNovedad">
                                    <RequiredField ErrorText="El tipo de novedad es requerido" IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Observación:
                        </td>
                        <td>
                            <dx:ASPxMemo ID="memoObservacionesNovedad" runat="server" NullText="Observaciones..." Rows="3"
                                Width="400px" ClientInstanceName="memoObservacionesNovedad">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="" 
                                    ValidationGroup="vgRegistrarNovedad">
                                    <RequiredField ErrorText="La observación es requerida" IsRequired="true" />
                                </ValidationSettings>
                            </dx:ASPxMemo>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxButton ID="btnAdicionarNovedad" runat="server" HorizontalAlign="Center" Style="display: inline"
                                Text="Adicionar" ValidationGroup="vgRegistrarNovedad" Width="150px" AutoPostBack="false">
                                <ClientSideEvents Click="function(s, e) {
                                        if(ASPxClientEdit.ValidateGroup('vgRegistrarNovedad')) {
                                            AdicionarNovedad(s, e);
                                        }
                                    }" />
                                <Image Url="../images/add.png">
                                </Image>
                            </dx:ASPxButton>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxPanel ID="pnlNovedades" runat="server" ScrollBars="Auto"
                                Height="250px">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" 
                                            KeyFieldName="id" ClientInstanceName="gvNovedades">
                                            <ClientSideEvents EndCallback="function(s, e) {
                                                ControlFinNovedad(s, e);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="IdNovedad" ReadOnly="True" ShowInCustomizationForm="True"
                                                    VisibleIndex="0" Caption="Id">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Estado" ShowInCustomizationForm="True" 
                                                    VisibleIndex="1" Caption="Estado Novedad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True" 
                                                    VisibleIndex="2" Caption="Tipo de Novedad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True"
                                                    VisibleIndex="3" Caption="Observación">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn FieldName="FechaRegistro" ShowInCustomizationForm="True" 
                                                    VisibleIndex="4" Caption="Fecha de Registro">
                                                </dx:GridViewDataDateColumn>
                                            </Columns>
                                        </dx:ASPxGridView>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxPanel>
                            
                        </td>
                    </tr>
                </table>
                
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    </form>
</body>
</html>
