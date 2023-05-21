<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearRutaTransportadoraCEM.aspx.vb" Inherits="BPColSysOP.CrearRutaTransportadoraCEM" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script>
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
                lblTipoBodegaOrigen.SetVisible(true);
                cmbTipoBodegaOrigen.SetVisible(true);
                lblBodegaOrigen.SetVisible(true);
                cmbBodegaOrigen.SetVisible(true);
                lblTipoBodegaDestino.SetVisible(true);
                cmbTipoBodegaDestino.SetVisible(true);
                lblBodegaDestino.SetVisible(true);
                cmbBodegaDestino.SetVisible(true);
            } else {
                //lblTipoBodegaOrigen.SetVisible(false);
                //cmbTipoBodegaOrigen.SetVisible(false);
                //lblBodegaOrigen.SetVisible(false);
                //cmbBodegaOrigen.SetVisible(false);
                lblTipoBodegaDestino.SetVisible(false);
                cmbTipoBodegaDestino.SetVisible(false);
                lblBodegaDestino.SetVisible(false);
                cmbBodegaDestino.SetVisible(false);
            }
        }

        function eliminarRadicado(Radicado) {
            hidIdRadicado.Set("Value", Radicado);
            lblEliRadicado.SetValue(Radicado);
            popEliminar.Show();
        }

    </script>
    <style type="text/css">
        .auto-style1 {
            height: 15px;
        }
        .auto-style2 {
            width: 232px;
        }
        .auto-style3 {
            height: 15px;
            width: 232px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                <dx:ASPxHiddenField ID="hidIdRadicado" ClientInstanceName="hidIdRadicado" runat="server"></dx:ASPxHiddenField>
            </div>

            <dx:ASPxRoundPanel ID="rpInfoAgente" runat="server" HeaderText="Selección de Servicio para Transportadora"
                Width="81%" ClientInstanceName="rpInfoAgente">
                <PanelCollection>
                    <dx:PanelContent>
                        <table>
                            <tr>
                                <td style="width: 120px;">
                                    <dx:ASPxLabel runat="server" Text="Tipo asignación"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cmbTipoAsignacion" runat="server" ClientInstanceName="cmbTipoAsignacion">
                                        <Items>
                                            <dx:ListEditItem Value="1" Text="Traslado" />
                                            <dx:ListEditItem Value="2" Text="Entrega a Cliente" />
                                        </Items>
                                        <ClientSideEvents ValueChanged="function() { comboTipoCambia(cmbTipoAsignacion.GetValue()) }" />
                                    </dx:ASPxComboBox>
                                </td>
                                <td style="width: 120px;"></td>
                                <td class="auto-style2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel runat="server" Text="Transportadora"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cmbTransportadora" runat="server" ClientInstanceName="cmbTransportadora" AutoPostBack="true">
                                    </dx:ASPxComboBox>
                                </td>
                                <td>
                                    <dx:ASPxLabel runat="server" Text="Rango guías"></dx:ASPxLabel>
                                </td>
                                <td class="auto-style2">
                                    <dx:ASPxComboBox ID="cmbRangoGuias" runat="server" >
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblTipoBodegaOrigen" runat="server" Text="Tipo bodega origen" ClientInstanceName="lblTipoBodegaOrigen"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cmbTipoBodegaOrigen" runat="server" ClientInstanceName="cmbTipoBodegaOrigen" AutoPostBack="true" Width="319px">
                                    </dx:ASPxComboBox>
                                </td>
                                <td>
                                    <dx:ASPxLabel ID="lblBodegaOrigen" runat="server" Text="Bodega Origen" ClientInstanceName="lblBodegaOrigen"></dx:ASPxLabel>
                                </td>
                                <td class="auto-style2">
                                    <dx:ASPxComboBox ID="cmbBodegaOrigen" runat="server" ClientInstanceName="cmbBodegaOrigen" Width="319px">
                                    </dx:ASPxComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="lblTipoBodegaDestino" runat="server" Text="Tipo bodega destino" ClientInstanceName="lblTipoBodegaDestino"></dx:ASPxLabel>
                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="cmbTipoBodegaDestino" runat="server" ClientInstanceName="cmbTipoBodegaDestino" AutoPostBack="true" Width="319px">
                                    </dx:ASPxComboBox>
                                </td>
                                <td>
                                    <dx:ASPxLabel ID="lblBodegaDestino" runat="server" Text="Bodega Destino" ClientInstanceName="lblBodegaDestino"></dx:ASPxLabel>
                                </td>
                                <td class="auto-style2">
                                    <dx:ASPxComboBox ID="cmbBodegaDestino" runat="server" ClientInstanceName="cmbBodegaDestino" Width="319px"></dx:ASPxComboBox>
                                </td>
                            </tr>

                            <tr style="height: 20px;">
                                <td class="auto-style1"></td>
                                <td class="auto-style1"></td>
                                <td class="auto-style1"></td>
                                <td class="auto-style3"></td>
                            </tr>

                            <tr>
                                <td>
                                    <dx:ASPxTextBox ID="txtRadicado" runat="server" ClientInstanceName="txtRadicado"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <dx:ASPxButton ID="btnAgregarRadicado" runat="server" Text="Agregar radicado" AutoPostBack="true">
                                        <%--                                        <ClientSideEvents Click="function() { clickAgregarRadicado(txtRadicado.GetValue(), cmbBodegaDestino.GetValue()) }" />--%>
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

            <table style="width: 50%;">
                <tr>
                    <td>
                        <dx:ASPxRoundPanel ID="rpRadicados" runat="server" HeaderText="Radicados Asociados a la Ruta"
                            Style="margin-top: 10px;" Width="30%" ClientVisible="true">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <div>
                                        <dx:ASPxGridView ID="gvDatos" ClientInstanceName="gvDatos" runat="server" AutoGenerateColumns="False"
                                            Width="100%" KeyFieldName="Radicado">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="Radicado" VisibleIndex="1" Caption="Radicado">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="2" CellStyle-HorizontalAlign="Center" Width="75px">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink ID="linkEliminar" ClientInstanceName="linkEliminar" runat="server"
                                                            ImageUrl="~/images/close.png" Cursor="pointer" ToolTip="Eliminar Radicado" OnInit="Link_Init">
                                                            <ClientSideEvents Click="function(s, e){ eliminarRadicado({0}); }" />
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
                        <dx:ASPxRoundPanel ID="rpGenerar" runat="server" HeaderText="Generar Despacho"
                            Style="margin-top: 10px;" Width="70%" ClientVisible="true">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <div>
                                        <table>
                                            <tr>
                                                <td>Peso</td>
                                                <td>Volumen</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtPeso" runat="server" ClientInstanceName="txtPeso" Width="90">
                                                        <ClientSideEvents   KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                    </dx:ASPxTextBox>
                                                </td>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtVolumen" runat="server" ClientInstanceName="txtVolumen" Width="90">
                                                        <ClientSideEvents   KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                    </dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <br />
                                                </td>
                                                
                                            </tr>
                                            <tr>
                                                <td>Cantidad</td>
                                                <td>Tipo Unidades</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtCantidad" runat="server" Width="40px" DisplayFormatString="#">
                                                        <ClientSideEvents   KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                        <ValidationSettings ErrorTextPosition="Top" SetFocusOnError="True" ErrorText="La cantidad de unidades debe ser numérica y mayor a cero"
                                                            ErrorDisplayMode="ImageWithTooltip">
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox ID="ddlUnidades" runat="server" Width="200px" DropDownStyle="DropDown"
                                                        ValueField="Occupation" TextField="Occupation" MaxLength="128" IncrementalFilteringMode="StartsWith">
                                                        <ValidationSettings ErrorTextPosition="Top" ErrorDisplayMode="ImageWithTooltip" ErrorText="Debe escoger las unidades del despacho">
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <br />
                                                    <dx:ASPxButton ID="btnGenerarGuia" runat="server" ClientInstanceName="btnGenerarGuia" Text="Generar Guía" AutoPostBack="true">
                                                        <%--                                                        <ClientSideEvents Click="function() { generarDespacho(); }" />--%>
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

            <div>
                <dx:ASPxPopupControl ID="popEliminar" runat="server" CloseAction="CloseButton" Width="250" Height="100"
                    CloseOnEscape="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true"
                    ClientInstanceName="popEliminar" HeaderText="Rangos Guías" AutoUpdatePosition="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <dx:ASPxPanel ID="panEliminar" runat="server">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table>
                                            <tr>
                                                <td colspan="2">Desea eliminar este Radicado?</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <dx:ASPxLabel ID="lblEliRadicado" ClientInstanceName="lblEliRadicado" runat="server"></dx:ASPxLabel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <dx:ASPxButton ID="btnEliCancelar" ClientInstanceName="btnEliCancelar" runat="server" Text="Cancelar">
                                                        <ClientSideEvents Click="function() { popEliminar.Hide(); }" />
                                                    </dx:ASPxButton>
                                                </td>
                                                <td>
                                                    <dx:ASPxButton ID="btnEliAceptar" ClientInstanceName="btnEliAceptar" runat="server" Text="Aceptar">
                                                        <ClientSideEvents Click="function() { popEliminar.Hide(); }" />
                                                    </dx:ASPxButton>
                                                </td>
                                            </tr>

                                        </table>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxPanel>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
            </div>

        </div>
    </form>
</body>
</html>
