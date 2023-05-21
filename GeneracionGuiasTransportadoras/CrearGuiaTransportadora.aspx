<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearGuiaTransportadora.aspx.vb" Inherits="BPColSysOP.CrearGuiaTransportadora" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <title></title>
    <script>
        //
        //  debugger;
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
                LoadingPanel.Hide();
            }
        }

        function fn_AllowonlyNumeric(s, e) {
            var theEvent = e.htmlEvent || window.event;
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
            var regex = /[0-9]/;
            if (!regex.test(key)) {
                theEvent.returnValue = false;
                if (theEvent.preventDefault)
                    theEvent.preventDefault();
            }
        }

        function comboTipoCambia(IdTipo) {
            if (IdTipo == 1) {
                lblBodegaOrigen.SetVisible(true);
                cmbBodegaOrigen.SetVisible(true);
                lblTipoBodegaDestino.SetVisible(true);
                cmbTipoBodegaDestino.SetVisible(true);
                lblBodegaDestino.SetVisible(true);
                cmbBodegaDestino.SetVisible(true);
            } else {
                lblTipoBodegaDestino.SetVisible(false);
                cmbTipoBodegaDestino.SetVisible(false);
                lblBodegaDestino.SetVisible(false);
                cmbBodegaDestino.SetVisible(false);
            }
        }
        function ValidarCamposNewRadicadp(s, e) {
            var SinDato = 0;
            if (cmbTipoAsignacion.GetValue() == 0 || cmbTipoAsignacion.GetValue() == null) {
                SinDato = 1;
            }
            if (cmbTransportadora.GetValue() == 0 || cmbTransportadora.GetValue() == null) {
                SinDato = 1;
            }
            if (cmbRangoGuias.GetValue() == 0 || cmbRangoGuias.GetValue() == null) {
                SinDato = 1;
            }
            if (cmbBodegaOrigen.GetValue() == 0 || cmbBodegaOrigen.GetValue() == null) {
                SinDato = 1;
            }

            if (txtRadicado.GetValue() == '' || txtRadicado.GetValue() == null) {
                SinDato = 1;
            }
            if (cmbTipoAsignacion.GetValue() == 1) {
                if (cmbTipoBodegaDestino.GetValue() == 0 || cmbTipoBodegaDestino.GetValue() == null) {
                    SinDato = 1;
                }
                if (cmbBodegaDestino.GetValue() == 0 || cmbBodegaDestino.GetValue() == null) {
                    SinDato = 1;
                }
            }
            if (SinDato > 0) {
                alert('Campos Incompletos')
                return false;
            } else {
                return true;
            }
        }


        function MostrarGuia(s) {
            if (s.cpMostrarDoc != null) {
                window.open(s.cpMostrarDoc);
            }
            if (s.cpMostrarDoc2 != null) {
                window.open(s.cpMostrarDoc2);
            }
        }

        function DescargarDocumento(s) {
            if (s.cpDescargarDoc != null) {
                window.open(s.cpDescargarDoc);
            }
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>

            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true">
                <ClientSideEvents EndCallback="function (s, e){
                LoadingPanel.Hide();
                MostrarInfoEncabezado(s,e);
                MostrarGuia(s);
                    DescargarDocumento(s);                   
            }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxRoundPanel ID="rpInfoAgente" runat="server" HeaderText="Selección de Servicio para Transportadora"
                            Width="60%" ClientInstanceName="rpInfoAgente">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td class="auto-style4">
                                                <dx:ASPxLabel runat="server" Text="Tipo asignación"></dx:ASPxLabel>
                                            </td>
                                            <td class="auto-style5">
                                                <dx:ASPxComboBox ID="cmbTipoAsignacion" runat="server" ClientInstanceName="cmbTipoAsignacion" AutoPostBack="false">
                                                    <Items>
                                                        <dx:ListEditItem Value="1" Text="Traslado" />
                                                        <dx:ListEditItem Value="2" Text="Entrega a Cliente" />
                                                    </Items>
                                                    <ClientSideEvents ValueChanged="function() { comboTipoCambia(cmbTipoAsignacion.GetValue()) }" />
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td class="auto-style4"></td>
                                            <td class="auto-style6"></td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblBodegaOrigen" runat="server" Text="Bodega Origen" ClientInstanceName="lblBodegaOrigen"></dx:ASPxLabel>
                                            </td>
                                            <td class="auto-style2">
                                                <dx:ASPxComboBox ID="cmbBodegaOrigen" runat="server" ClientInstanceName="cmbBodegaOrigen" AutoPostBack="true" Width="319px">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxLabel ID="lblTipoBodegaDestino" runat="server" Text="Tipo bodega destino" ClientInstanceName="lblTipoBodegaDestino"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbTipoBodegaDestino" runat="server" ClientInstanceName="cmbTipoBodegaDestino" AutoPostBack="true" Width="319px">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>
                                                <dx:ASPxLabel ID="lblBodegaDestino" runat="server" Text="Bodega Destino" ClientInstanceName="lblBodegaDestino"></dx:ASPxLabel>
                                            </td>
                                            <td class="auto-style2">
                                                <dx:ASPxComboBox ID="cmbBodegaDestino" runat="server" ClientInstanceName="cmbBodegaDestino" Width="319px">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <dx:ASPxLabel runat="server" Text="Transportadora"></dx:ASPxLabel>
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbTransportadora" runat="server" ClientInstanceName="cmbTransportadora" AutoPostBack="true">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td>
                                                <dx:ASPxLabel runat="server" Text="Cuenta"></dx:ASPxLabel>
                                            </td>
                                            <td class="auto-style2">
                                                <dx:ASPxComboBox ID="cmbRangoGuias" ClientInstanceName="cmbRangoGuias" AutoPostBack="false" runat="server" Width="319px">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Numero Radicado:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxTextBox ID="txtRadicado" runat="server" ClientInstanceName="txtRadicado">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                        <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnAgregarRadicado" CausesValidation="true" ValidationGroup="addRadicado" runat="server" Text="Agregar radicado" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s,e) {
                                                                         if (ValidarCamposNewRadicadp()==true) {
                                                                            EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'AgregarRadicado', txtRadicado.GetText());                                                                       
                                                                        }                                                                        
                                                                    }" />
                                                </dx:ASPxButton>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar" AutoPostBack="true">
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>


                        <table style="width: 30%;">
                            <tr>
                                <td>
                                    <dx:ASPxRoundPanel ID="rpRadicados" runat="server" HeaderText="Radicados Asociados"
                                        Style="margin-top: 10px;" Width="60%" ClientVisible="true" Visible="False">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <div>
                                                    <dx:ASPxGridView ID="gvDatos" ClientInstanceName="gvDatos" runat="server" AutoGenerateColumns="False"
                                                        Width="100%" KeyFieldName="numRadicado">
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="numRadicado" VisibleIndex="1" Caption="Radicado">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="2" CellStyle-HorizontalAlign="Center" Width="75px">
                                                                <DataItemTemplate>
                                                                    <dx:ASPxHyperLink ID="linkEliminar" ClientInstanceName="linkEliminar" runat="server"
                                                                        ImageUrl="~/images/close.png" Cursor="pointer" ToolTip="Eliminar Radicado" OnInit="Link_Init">
                                                                        <ClientSideEvents Click="function(s, e){ 
                                                                            if (confirm('Desea eliminar este Radicado? ' + '{0}' )){
                                                                             EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'EliminarRadicado', {0}); 
                                                                            }   
                                                                            }" />
                                                                    </dx:ASPxHyperLink>
                                                                </DataItemTemplate>
                                                                <CellStyle HorizontalAlign="Center">
                                                                </CellStyle>
                                                            </dx:GridViewDataColumn>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </div>
                                                <div>
                                                </div>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </td>
                                <td>
                                    <dx:ASPxRoundPanel ID="rpGenerar" runat="server" HeaderText="Generar Guia"
                                        Style="margin-top: 10px;" Width="65%" ClientVisible="true" Visible="False">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <div>
                                                    <table>
                                                        <tr>

                                                            <td>Valor Declarado:</td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="txtpopValorDeclarado" DisplayFormatString="{0:C}" runat="server" ClientEnabled="true" ClientInstanceName="txtpopValorDeclarado" Width="90%">
                                                                    <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgGuia">
                                                                        <RequiredField ErrorText="Debe ser numérica y mayor a cero" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>

                                                            <td>Contenido:</td>
                                                            <td>
                                                                <dx:ASPxMemo ID="txtpopContenido" runat="server" ClientInstanceName="txtpopContenido" Width="90%" ClientReadOnly="True" ReadOnly="True" AutoResizeWithContainer="True" Height="35px"></dx:ASPxMemo>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table>
                                                        <tr>
                                                            <td>No. Cajas</td>
                                                            <td>Peso (kg)</td>
                                                            <td>Volumen (kg)</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxTextBox ID="txtCantidad" ClientInstanceName="txtCantidad" runat="server" Width="60px" DisplayFormatString="#">
                                                                    <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgGuia">
                                                                        <RequiredField ErrorText="La cantidad de unidades debe ser numérica y mayor a cero" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="txtPeso" runat="server" ClientInstanceName="txtPeso" Width="60px">
                                                                    <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />

                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgGuia">
                                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="txtVolumen" runat="server" ClientInstanceName="txtVolumen" Width="60px">
                                                                    <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgGuia">
                                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>

                                                    </table>
                                                    <br />
                                                    <table>
                                                        <tr>
                                                            <td></td>
                                                            <dx:ASPxLabel ID="lblnumBolsaSeguridad" ClientInstanceName="lblnumBolsaSeguridad" runat="server" Text="Numero Bolsa de Seguridad"></dx:ASPxLabel>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxTextBox ID="txtnumBolsaSeguridad" runat="server" ClientInstanceName="txtnumBolsaSeguridad" ClientVisible="false" Width="190px">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField ErrorText="Numero Bolsa de Seguridad" IsRequired="false" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                                &nbsp;
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td></td>
                                                            <dx:ASPxLabel ID="lblMedioTransporte" ClientInstanceName="lblMedioTransporte" runat="server" Text="Medio de Transporte"></dx:ASPxLabel>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxComboBox ID="ddlMedioTransporte" ClientInstanceName="ddlMedioTransporte" runat="server" Width="200px" NullText="Seleccione un valor..."
                                                                    ValueField="Occupation" TextField="Occupation" MaxLength="128" IncrementalFilteringMode="StartsWith">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgGuia">
                                                                        <RequiredField IsRequired="true" ErrorText="Información Requerida" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <br />
                                                                <dx:ASPxButton ID="btnGenerarGuia" runat="server" ClientInstanceName="btnGenerarGuia" Text="Generar Guía" AutoPostBack="false" ValidationGroup="vgGuia">
                                                                    <ClientSideEvents Click="function(s,e) {
                                                                        if (cmbTransportadora.GetText()=='SERVIENTREGA'){
                                                                            if (!(txtPeso.GetText() == '' || txtVolumen.GetText() == '' || txtCantidad.GetText() == '' || ddlMedioTransporte.GetValue()==null || txtpopValorDeclarado.GetText()==''  ) ){
                                                                                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'GenerarGuia', 1);                                                                       
                                                                            } 
                                                                            }else{
                                                                            if (!(txtPeso.GetText() == '' || txtVolumen.GetText() == '' || txtCantidad.GetText() == '' || txtpopValorDeclarado.GetText()==''  ) ){
                                                                                EjecutarCallbackGeneral(LoadingPanel, cpGeneral, 'GenerarGuia', 1);                                                                       
                                                                            } 
                                                                            }                                                                        
                                                                                                                                                
                                                                    }" />
                                                                </dx:ASPxButton>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </td>
                            </tr>
                        </table>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
        <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        <script src="../include/jquery-1.js" type="text/javascript"></script>
    </form>
</body>
</html>
