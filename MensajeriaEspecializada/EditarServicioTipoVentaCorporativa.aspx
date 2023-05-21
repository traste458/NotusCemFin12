<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarServicioTipoVentaCorporativa.aspx.vb" Inherits="BPColSysOP.EditarServicioTipoVentaCorporativa" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="miEncabezado"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.::: Edición Servicio :::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
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

</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:miEncabezado ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" Width ="80%">
            <ClientSideEvents EndCallback="function(s,e){ 
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide();
        }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpRegistro" runat="server" HeaderText="Modificación Servicio" Width="90%" Theme="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxFormLayout ID="flRegistro" runat="server" ColCount="3">
                                    <Items>
                                    <dx:LayoutGroup Caption="Información General Servicio" ColCount="3" ColSpan="1">
                                        <Items>
                                        <dx:LayoutItem Caption="Estado:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server" CssClass="textbox">
                                                    <dx:ASPxLabel ID="lblEstado" runat="server"
                                                        Style="font-weight: 700; font-size: medium" CssClass ="cuerpoSinImagen">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="No. Servicio:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer27" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblIdServicio" runat="server" CssClass ="cuerpoSinImagen"
                                                        Style="font-weight: 700; font-size: medium">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Tipo servicio:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer25" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblTipoServicio" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha de Solicitud:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFechaSolicitud" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Forma de Pago:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer24" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFormaPago" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Ciudad de Entrega:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblCiudad" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre de la Empresa:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblNombreEmpresa" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número NIT:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblNumeroNit" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono Fijo Empresa:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server" CssClass ="cuerpoSinImagen">
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
                                        <dx:LayoutItem Caption="Nombre Representante Legal:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblNombreRepresentante" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número Cédula Representante:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblNumeroIdentificacionRepresentante" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono Celular Representante:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblTelefonoRepresentante" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Nombre persona Autorizada:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxTextBox ID="txtPersonaAutorizada" runat="server" NullText="Nombre Persona Autorizada..." Width="200px" 
                                                        TabIndex ="1" onkeypress="return soloLetras(event)">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RegularExpression ErrorText ="Los caracteres ingresados no son validos" ValidationExpression ="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                            <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Número Cédula Autorizado:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxTextBox ID="txtIdentificacionAutorizado" runat="server" MaxLength="15" NullText="Cédula Autorizado..."
                                                        onkeypress="javascript:return ValidaNumero(event);" Width="150px" TabIndex ="2">
                                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                            ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                            <RegularExpression ErrorText ="Los caracteres ingresados no son validos" ValidationExpression ="^\s*[0-9]+\s*$"/>
                                                            <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida">
                                                            </RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Cargo Persona Autorizada:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxTextBox ID="txtCargoPersonaAutorizada" runat="server" NullText="Cargo Persona Autorizada..." Width="200px" 
                                                        TabIndex ="3" onkeypress="return soloLetras(event)">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                            <RegularExpression ErrorText ="Los caracteres ingresados no son validos" ValidationExpression ="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                            <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Teléfono persona autorizada:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblTelefonoPersonaAutorizada" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Dirección:" VerticalAlign="Middle" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server" CssClass ="cuerpoSinImagen">
                                                    <as:AddressSelector ID="asDireccion" runat="server" />
                                                    <div style="clear: both; display: table">
                                                        <asp:RequiredFieldValidator ID="rfvasDireccion" runat="server" ControlToValidate="asDireccion:memoDireccion"
                                                            Display="Dynamic" ErrorMessage="La dirección es requerida." ValidationGroup="vgRegistrar"></asp:RequiredFieldValidator>
                                                    </div>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                            <CaptionSettings VerticalAlign="Middle" />
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Barrio:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del Cliente..." Width="200px" TabIndex ="4">
                                                        <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                            ValidationGroup="vgRegistrar">
                                                            <RequiredField IsRequired="True" ErrorText="El barrio es requerido"></RequiredField>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Observaciones sobre dirección:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblObservacionDireccion" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Gerencia:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblGerencia" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Coordinador:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer22" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblCoordinador" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Consultor:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblConsultor" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Cliente Claro:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblClienteClaro" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha de Confirmacion:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFechaConfirmacion" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha de Entrega:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer29" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFechaEntrega" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Confirmado por:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer30" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblConfirmadoPor" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Fecha de Despacho:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer31" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFechaDespacho" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Despacho por:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer32" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblDespachoPor" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Responsable de entrega:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer33" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblResponsableEntrega" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Zona:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer34" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblZona" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Bodega:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer35" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblBodega" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Jornada de Entrega:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblJornadaEntrega" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Fecha de Agenda:" CssClass ="field">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer23" runat="server" CssClass ="cuerpoSinImagen">
                                                    <dx:ASPxLabel ID="lblFechaAgenda" runat="server">
                                                    </dx:ASPxLabel>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutGroup Caption="Eventos" ColCount="3" ColSpan="1">
                                            <Items>
                                                <dx:LayoutItem Caption=" Actualizar">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer26" runat="server" CssClass="textbox">
                                                        <dx:ASPxImage ID="imgRegistro" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                            ToolTip="Registrar" ClientInstanceName="imgRegistro" Cursor="pointer" TabIndex="20">
                                                            <ClientSideEvents Click="function(s, e){
                                                                if(ASPxClientEdit.ValidateGroup('vgRegistrar')){
                                                                    EjecutarCallbackGeneral(s,e,'ActualizarServicio');
                                                                    }        
                                                            }" />
                                                        </dx:ASPxImage>
                                                        <div id="divMensaje" runat ="server">
                                                            <dx:ASPxLabel ID="lblComentario" runat="server" Text="No es posible actualizar el servicio, por favor verifique que las novedades asociadas al servicio se encuentren gestionadas."
                                                                CssClass="comentario" Width="200px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup> 

                                    </Items>
                                    </dx:LayoutGroup>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
