<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmacionServicioTipoVenta.aspx.vb" Inherits="BPColSysOP.ConfirmacionServicioTipoVenta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDireccion.ascx" TagName="AddressSelector"
    TagPrefix="as" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Confirmar Servicio Tipo Venta</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/jquery.purr.js" type="text/javascript"></script>
</head>
<body class="cuerpo2" onload="TamanioVentana();">
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

        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
        };

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

        function VisualizarNovedades(s, e) {
            dialogoNovedades.SetSize(myWidth * 0.7, myHeight * 0.7);
            dialogoNovedades.SetVisible(true);
            //gvNovedades.PerformCallback();
        }

        function AdicionarNovedad(s, e) {
            gvNovedades.PerformCallback('registrar');
           
        }

        function ControlFinNovedad(s, e) {
            cmbTipoNovedad.SetValue(null);
            memoObservacionesNovedad.SetText(null);
        }

    </script>
    <form id="formPrincipal" runat="server">
        <script type="text/javascript">
            var idJornada = "<%= cmbJornada.ClientID %>";
            var dateFechaAgenda = "<%= dateFechaAgenda.ClientID %>";
            var idCiudadEntrega = "<%= cmbCiudadEntrega.ClientID %>";
            var fechasNoDisponibles = "<%= hfFechasNoDisponibles.ClientID %>";
            var idPlan = "<%= cmbPlan.ClientID %>";
        </script>
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />

        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s, e) { 
                LoadingPanel.Hide(); 
                var obj = ASPxClientControl.GetControlCollection().GetByName('lblValorEquipo');
                obj.SetText(e.result);
            }" />
        </dx:ASPxCallback>
        <dx:ASPxCallbackPanel ID="rpConfServicio" runat="server">
            <ClientSideEvents EndCallback="function(s, e) {
                                    LoadingPanel.Hide();
                                }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpEdidatServicio" runat="server"
                        HeaderText="Confirmación de la Venta">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1">
                                    <tr>
                                        <td>Ciudad de Entrega:</td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" SelectedIndex="0"
                                                ValueType="System.Int32" Enabled="False">
                                                <Items>
                                                    <dx:ListEditItem Selected="True" Text="Seleccione una ciudad..." Value="0" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td>Campaña:</td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbCompania" runat="server" ValueType="System.Int32"
                                                Enabled="False">
                                                <ValidationSettings CausesValidation="True" Display="Dynamic"
                                                    ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar">
                                                    <RequiredField ErrorText="La campaña es requerida" IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Plan: </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbPlan" runat="server" ValueType="System.Int32" IncrementalFilteringMode="Contains"
                                                Width="400px" ValueField="idPlan" DropDownWidth="600" AutoPostBack="True"
                                                Enabled="False">
                                                <ValidationSettings Display="Dynamic" ErrorText="Valor incorrecto" ErrorDisplayMode="ImageWithTooltip">
                                                    <RequiredField IsRequired="True" ErrorText="El plan es requerido"></RequiredField>
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
                                        <td>Equipo: </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbEquipo" runat="server" ValueType="System.String" DropDownWidth="600"
                                                IncrementalFilteringMode="Contains" Width="400px" ValueField="material"
                                                AutoPostBack="True" Enabled="False">
                                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                    ValidationGroup="vgRegistrar">
                                                    <RequiredField ErrorText="El equipo es requerido" IsRequired="True" />
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
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Identificación del Cliente:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtIdentificacionCLiente" runat="server" Width="170px"
                                                Enabled="False">
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td colspan="2">
                                            <dx:ASPxLabel ID="lblValorEquipo" runat="server" Font-Bold="False" ClientInstanceName="lblValorEquipo"
                                                Font-Italic="True" Font-Overline="False" Font-Strikeout="False"
                                                ForeColor="#6600CC">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nombres del Cliente: </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNombresCliente" runat="server" Width="400px"
                                                Enabled="False">
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td>Barrio: </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtBarrio" runat="server" Width="400px" Enabled="False">
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
                                        <td>Observaciones sobre dirección: </td>
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
                                            <dx:ASPxTextBox ID="txtTelefonoMovil" runat="server" Width="170px"
                                                Enabled="False">
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td>Teléfono Fijo:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" Width="170px">
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Forma de Pago:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbFormaPago" runat="server" SelectedIndex="0" ValueType="System.Int32">
                                                <Items>
                                                    <dx:ListEditItem Selected="True" Text="Seleccione Forma de Pago..." Value="0" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                            <dx:ASPxHiddenField ID="hfFechasNoDisponibles" runat="server">
                                            </dx:ASPxHiddenField>
                                        </td>
                                        <td>Clausula:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbClausula" runat="server" SelectedIndex="0"
                                                ValueType="System.Int32" Enabled="False">
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Región de la línea:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbRegion" runat="server" SelectedIndex="0"
                                                ValueType="System.Int32" Enabled="False">
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td>Jornada:
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
                                        <td>Fecha agenda:
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
                                        </td>
                                        <td>Observaciones:
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
                                                <dx:ASPxButton ID="btnConfirmar" runat="server" Text="Confirmar" ValidationGroup="vgRegistrar"
                                                    Theme="PlasticBlue" Width="150px" HorizontalAlign="Center"
                                                    Style="display: inline">
                                                    <Image Url="../images/confirmation.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                            <dx:ASPxButton ID="btnNovedad" runat="server" Text="Adicionar Novedades"
                                                Width="200px" HorizontalAlign="Center" Style="display: inline"
                                                AutoPostBack="false">
                                                <ClientSideEvents Click="function(s, e) {
                                                    VisualizarNovedades(s, e);
                                                }"></ClientSideEvents>
                                                <Image Url="../images/comment_add.png">
                                                </Image>
                                            </dx:ASPxButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <dx:ASPxPopupControl ID="pcNovedades" runat="server" AllowDragging="True" ClientInstanceName="dialogoNovedades"
                                    HeaderText="Adición de Novedades" Modal="True" PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter">
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
                                                            Height="250px">
                                                            <PanelCollection>
                                                                <dx:PanelContent>
                                                                    <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False"
                                                                        KeyFieldName="id" ClientInstanceName="gvNovedades">
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
    </form>
</body>
</html>
