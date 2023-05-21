<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmacionServicioTipoVentaCorporativa.aspx.vb" Inherits="BPColSysOP.ConfirmacionServicioTipoVentaCorporativa" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="miEncabezado"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Confirmación Servicio Venta Corporativa ::.</title>
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
        var myWidth, myHeight;
        $(document).ready(function () { $(window).resize(function () { TamanioVentana(); }) });

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

        var idJornada = "<%= cmbJornada.ClientID %>";
        var dateFechaAgenda = "<%= dateFechaAgenda.ClientID %>";
        var fechasNoDisponibles = "<%= hfFechasNoDisponibles.ClientID %>";

        LoadingPanel.Show();
        window.onbeforeunload = doBeforeUnload;

        function doBeforeUnload() {
            LoadingPanel.Show();
        }

        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString();
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]);
        };

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
        }

        function CerrarVisualizacionNovedad(s, e) {
            callbackConfServicio.PerformCallback('novedades');
        }

        function ControlFinCupoEntrega(s, e) {
            var ctrlAgenda = ASPxClientControl.GetControlCollection().GetByName(dateFechaAgenda);
            if (s.cpMensaje) { $('#divEncabezado').html(s.cpMensaje); }
            if (s.cpControlAgenda != null) {
                if (s.cpControlAgenda == '1')
                    ctrlAgenda.SetValue(null);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function soloLetras(e) {
            tecla = (document.all) ? e.keyCode : e.which;
            if (tecla == 8 || tecla == 32) return true;
            patron = /[A-Za-zñÑ]/;
            te = String.fromCharCode(tecla);
            return patron.test(te);
        }

    </script>

    <div id="divEncabezado">
        <uc1:miEncabezado ID="miEncabezado" runat="server" />
    </div>

    <form id="formPrincipal" runat="server">

        <div style="float: left; width: 1280px;">
            <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
                <ClientSideEvents CallbackComplete="function(s, e) { 
                LoadingPanel.Hide();
                ControlFinCupoEntrega(s, e); 
            }" />
            </dx:ASPxCallback>
            <dx:ASPxCallbackPanel ID="rpConfServicio" runat="server" ClientInstanceName="callbackConfServicio">
                <ClientSideEvents EndCallback="function(s, e) {
                    LoadingPanel.Hide();
                }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxRoundPanel ID="rpEdidatServicio" runat="server"
                            HeaderText="Confirmación de la Venta Corporativa" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxHiddenField ID="hfFechasNoDisponibles" runat="server">
                                    </dx:ASPxHiddenField>
                                    <dx:ASPxFormLayout ID="flRegistro" runat="server" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Estado:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                        <dx:ASPxLabel ID="lblEstado" runat="server"
                                                            Style="font-weight: 700; font-size: medium">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="No. Servicio:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer27" runat="server">
                                                        <dx:ASPxLabel ID="lblIdServicio" runat="server"
                                                            Style="font-weight: 700; font-size: medium">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Tipo servicio:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer25" runat="server">
                                                        <dx:ASPxLabel ID="lblTipoServicio" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fecha de Solicitud:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                        <dx:ASPxLabel ID="lblFechaSolicitud" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Forma de Pago:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer24" runat="server">
                                                        <dx:ASPxLabel ID="lblFormaPago" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Ciudad de Entrega:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                        <dx:ASPxLabel ID="lblCiudad" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Nombre de la Empresa:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                        <dx:ASPxLabel ID="lblNombreEmpresa" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Número NIT:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                        <dx:ASPxLabel ID="lblNumeroNit" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Teléfono Fijo Empresa:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                        <div style="display: inline; float: left">
                                                            <dx:ASPxLabel ID="lblTelefonoFijo" runat="server">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                        <div style="display: inline; float: left">
                                                            &nbsp;Ext.&nbsp;
                                                        </div>
                                                        <div style="display: inline; float: left">
                                                            <dx:ASPxLabel ID="lblExtTelefonoFijo" runat="server">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Nombre Representante Legal:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                        <dx:ASPxLabel ID="lblNombreRepresentante" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Número Cédula Representante:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                        <dx:ASPxLabel ID="lblNumeroIdentificacionRepresentante" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Teléfono Celular Representante:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                        <dx:ASPxLabel ID="lblTelefonoRepresentante" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Nombre persona Autorizada:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                        <dx:ASPxTextBox ID="txtPersonaAutorizada" runat="server" NullText="Nombre Persona Autorizada..." Width="200px"
                                                            TabIndex="1" onkeypress="return soloLetras(event)">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgActualizar">
                                                                <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Número Cédula Autorizado:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                        <dx:ASPxTextBox ID="txtIdentificacionAutorizado" runat="server" MaxLength="15" NullText="Cédula Autorizado..."
                                                            onkeypress="javascript:return ValidaNumero(event);" Width="150px" TabIndex="2">
                                                            <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                ErrorText="Valor incorrecto" ValidationGroup="vgActualizar">
                                                                <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Teléfono persona autorizada:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server">
                                                        <dx:ASPxLabel ID="lblTelefonoPersonaAutorizada" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cargo Persona Autorizada:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                        <dx:ASPxTextBox ID="txtCargoPersonaAutorizada" runat="server" NullText="Cargo Persona Autorizada..." Width="200px"
                                                            TabIndex="3" onkeypress="return soloLetras(event)">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgActualizar">
                                                                <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Dirección:" VerticalAlign="Middle">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server" CssClass="cuerpoSinImagen">
                                                        <as:AddressSelector ID="asDireccion" runat="server" />
                                                        <div style="clear: both; display: table">
                                                            <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" ControlToValidate="asDireccion:memoDireccion"
                                                                Display="Dynamic" ErrorMessage="La dirección es requerida." ValidationGroup="vgActualizar"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                <CaptionSettings VerticalAlign="Middle" />
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Barrio:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server">
                                                        <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del Cliente..." Width="150px" TabIndex="4">
                                                            <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                ValidationGroup="vgActualizar">
                                                                <RequiredField IsRequired="True" ErrorText="El barrio es requerido"></RequiredField>
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Observaciones sobre dirección:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server">
                                                        <dx:ASPxLabel ID="lblObservacionDireccion" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Gerencia:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server">
                                                        <dx:ASPxLabel ID="lblGerencia" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Coordinador:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer22" runat="server">
                                                        <dx:ASPxLabel ID="lblCoordinador" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Consultor:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server">
                                                        <dx:ASPxLabel ID="lblConsultor" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cliente Claro:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server">
                                                        <dx:ASPxLabel ID="lblClienteClaro" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fecha de Confirmacion:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server">
                                                        <dx:ASPxLabel ID="lblFechaConfirmacion" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fecha de Entrega:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer29" runat="server">
                                                        <dx:ASPxLabel ID="lblFechaEntrega" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Confirmado por:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer30" runat="server">
                                                        <dx:ASPxLabel ID="lblConfirmadoPor" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fecha de Despacho:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer31" runat="server">
                                                        <dx:ASPxLabel ID="lblFechaDespacho" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Despacho por:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer32" runat="server">
                                                        <dx:ASPxLabel ID="lblDespachoPor" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Responsable de entrega:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer33" runat="server">
                                                        <dx:ASPxLabel ID="lblResponsableEntrega" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Zona:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer34" runat="server">
                                                        <dx:ASPxLabel ID="lblZona" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Bodega:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer35" runat="server">
                                                        <dx:ASPxLabel ID="lblBodega" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Observacion:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer26" runat="server">
                                                        <dx:ASPxMemo ID="memoObservaciones" runat="server"
                                                            NullText="Observaciones generales del servicio..." Rows="3" Width="200px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Jornada de Entrega:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server">
                                                        <dx:ASPxComboBox ID="cmbJornada" runat="server" SelectedIndex="0"
                                                            ValueType="System.Int32" Width="150px">
                                                            <Items>
                                                                <dx:ListEditItem Selected="True" Text="Seleccione una jornada..." Value="0" />
                                                            </Items>
                                                            <ValidationSettings CausesValidation="True" Display="Dynamic"
                                                                ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                                <RequiredField ErrorText="La Jornada es requerida" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fecha de Agenda:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer23" runat="server">
                                                        <dx:ASPxDateEdit ID="dateFechaAgenda" runat="server" NullText="Seleccione una fecha de agenda habil..."
                                                            Width="200px">
                                                            <ClientSideEvents DateChanged="function(s, e) {
                                                                var ctrlJornada = ASPxClientControl.GetControlCollection().GetByName(idJornada);
                                                                var ctrlAgenda = ASPxClientControl.GetControlCollection().GetByName(dateFechaAgenda);
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
                                                                    alert('Se debe seleccionar una Jornada antes de seleccionar la fecha de agenda.');
                                                                    ctrlAgenda.SetValue(null);
                                                                    if(ctrlJornada.GetValue()==null) {
                                                                        ctrlJornada.Focus();
                                                                    } 
                                                                }
                                                            }" />
                                                            <ValidationSettings CausesValidation="True" Display="Dynamic"
                                                                ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                                <RequiredField ErrorText="La fecha de agenda es requerida" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption=" ">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer28" runat="server" Visible="false">
                                                        <dx:ASPxLabel ID="lblIdBodega" runat="server">
                                                        </dx:ASPxLabel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                    <table width="100%">
                                        <tr>
                                            <td colspan="4" align="center">
                                                <dx:ASPxButton ID="btnActualizar" runat="server" Text="Actualizar Información" ValidationGroup="vgActualizar"
                                                    Theme="Metropolis" Width="150px" HorizontalAlign="Center"
                                                    Style="display: inline;">
                                                    <Image Url="../images/DxUpdate.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>

                                    <h5>Detalle del servicio</h5>

                                    <dx:ASPxGridView ID="gvEquipos" runat="server" AutoGenerateColumns="False" Width="100%"
                                        ClientInstanceName="gvEquipos" KeyFieldName="material" Theme="SoftOrange" Style="margin-bottom: 15px;">
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
                                            <dx:GridViewDataDateColumn Caption="Cantidad Leida"
                                                FieldName="cantidadLeida" ShowInCustomizationForm="True" VisibleIndex="3">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn Caption="Fecha Devolución"
                                                FieldName="fechaDevolucion" ShowInCustomizationForm="True" VisibleIndex="4">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn Caption="Cantidad Disponible"
                                                FieldName="cantidadDisponible" ShowInCustomizationForm="True" VisibleIndex="5" Visible="false">
                                            </dx:GridViewDataDateColumn>

                                            <dx:GridViewDataColumn Caption="Disponibilidad" VisibleIndex="6">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink runat="server" ID="lnkDisponibilidad" AutoPostBack="False" OnInit="LinkDisponibilidad_Init"
                                                        ImageUrl="../images/BallGreen.gif" Cursor="pointer">
                                                    </dx:ASPxHyperLink>
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                        </Columns>
                                        <SettingsPager Mode="ShowAllRecords">
                                        </SettingsPager>
                                    </dx:ASPxGridView>

                                    <center>
                                        <dx:ASPxButton ID="btnConfirmar" runat="server" Text="Confirmar" ValidationGroup="vgRegistrar"
                                            Theme="PlasticBlue" Width="150px" HorizontalAlign="Center"
                                            Style="display: inline;">
                                            <Image Url="../images/confirmation.png">
                                            </Image>
                                        </dx:ASPxButton>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                <dx:ASPxButton ID="btnNovedad" runat="server" Text="Adicionar Novedades"
                                    Width="200px" HorizontalAlign="Center" Style="display: inline;"
                                    AutoPostBack="false">
                                    <ClientSideEvents Click="function(s, e) {
                                        VisualizarNovedades(s, e);
                                    }"></ClientSideEvents>
                                    <Image Url="../images/comment_add.png">
                                    </Image>
                                </dx:ASPxButton>
                                    </center>

                                    <dx:ASPxPopupControl ID="pcNovedades" runat="server" AllowDragging="True" ClientInstanceName="dialogoNovedades"
                                        HeaderText="Adición de Novedades" Modal="True" PopupHorizontalAlign="WindowCenter"
                                        PopupVerticalAlign="WindowCenter">
                                        <ClientSideEvents CloseUp="function(s, e) { CerrarVisualizacionNovedad(s, e); }" />
                                        <ContentCollection>
                                            <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" SupportsDisabledAttribute="True">
                                                <table style="width: 100%;">
                                                    <tr>
                                                        <td>Tipo Novedad:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbTipoNovedad" runat="server" ClientInstanceName="cmbTipoNovedad"
                                                                DropDownWidth="600px" IncrementalFilteringMode="Contains" ValueField="idTipoNovedad"
                                                                ValueType="System.Int32" Width="300px">
                                                                <ClientSideEvents EndCallback="function(s, e) {s.SetSelectedIndex(-1);}" />
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                    ErrorText="Valor incorrecto" ValidationGroup="vgRegistrarNovedad">
                                                                    <RequiredField ErrorText="El tipo de novedad es requerido" IsRequired="True" />
                                                                </ValidationSettings>
                                                            </dx:ASPxComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Observación:</td>
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
                                                                Height="250px" Theme="SoftOrange">
                                                                <PanelCollection>
                                                                    <dx:PanelContent>
                                                                        <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False"
                                                                            KeyFieldName="id" ClientInstanceName="gvNovedades" Theme="SoftOrange">
                                                                            <ClientSideEvents EndCallback="function(s, e) {ControlFinNovedad(s, e);}" />
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
                                                                            <SettingsLoadingPanel Mode="Disabled" />
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
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
    </form>
</body>
</html>
