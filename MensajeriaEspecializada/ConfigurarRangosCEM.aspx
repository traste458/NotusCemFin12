<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfigurarRangosCEM.aspx.vb" Inherits="BPColSysOP.ConfigurarRangosCEM" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script>
        function nuevoRango() {
            hidIdRango.Set("Value", "0");
            txtPopNombreRango.SetValue("");
            cmbPopTransportadora.SetValue("");
            txtPopCodigoCuenta.SetValue("");
            txtPopGuiaInicial.SetValue("");
            txtPopGuiaFinal.SetValue("");
            txtPopGuiaActual.SetValue("");

            popModificar.Show();
        }

        function solonumeros(e) {
            var key = window.event ? e.which : e.keyCode;
            if (key < 48 || key > 57) {
                e.preventDefault();
            }

        }

        function editarRango(IdRango, NombreRango, IdTransportadora, CodigoCuenta, GuiaInicial, GuiaFinal, GuiaActual) {
            hidIdRango.Set("Value", IdRango);
            txtPopNombreRango.SetValue(NombreRango);
            cmbPopTransportadora.SetValue(IdTransportadora);
            txtPopCodigoCuenta.SetValue(CodigoCuenta);
            txtPopGuiaInicial.SetValue(GuiaInicial);
            txtPopGuiaFinal.SetValue(GuiaFinal);
            txtPopGuiaActual.SetValue(GuiaActual);

            popModificar.Show();
        }

        function eliminarRango(IdRango, NombreRango) {
            hidIdRango.Set("Value", IdRango);
            lblEliRango.SetValue(NombreRango);
            popEliminar.Show();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                <dx:ASPxHiddenField ID="hidIdRango" ClientInstanceName="hidIdRango" runat="server"></dx:ASPxHiddenField>
            </div>
                <dx:ASPxRoundPanel ID="rpDatos" ClientInstanceName ="rpDatos" runat="server" HeaderText = "Configuración de Rangos para Expedición de Guías">
                    <PanelCollection>
                        <dx:PanelContent>
                            <p>
                                <dx:ASPxButton ID="btnNuevoRango" ClientInstanceName="btnNuevoRango" runat="server" Text="Nuevo Rango">
                                    <ClientSideEvents Click="function() { nuevoRango() }" />
                                </dx:ASPxButton>
                            </p>
                            <div>
                                <dx:ASPxGridView ID="gvDatos" ClientInstanceName="gvDatos" runat="server" KeyFieldName="IdRango">
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="0" CellStyle-HorizontalAlign="Center"
                                            Width="75px">
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink ID="linkEditar" ClientInstanceName="linkEditar" runat="server" 
                                                    ImageUrl="~/images/edit.gif" Cursor="pointer" ToolTip="Editar Rango" OnInit="Link_Init">
                                                    <ClientSideEvents Click="function(s, e){ editarRango({0}, '{1}', {2}, '{3}', {4}, {5}, {6}); }" />
                                                </dx:ASPxHyperLink>
                                                <dx:ASPxHyperLink ID="linkEliminar" ClientInstanceName="linkEliminar" runat="server" 
                                                    ImageUrl="~/images/close.png" Cursor="pointer" ToolTip="Eliminar Rango" OnInit="Link_Init">
                                                        <ClientSideEvents Click="function(s, e){ eliminarRango({0}, '{1}'); }" />
                                                    </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn FieldName="IdRango" Caption="IdRango" Visible="false">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn FieldName="IdTransportadora" Visible="false">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="NombreTransportadora" VisibleIndex="1">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="NombreRango" VisibleIndex="2">
                                        </dx:GridViewDataColumn>                                            
                                        <dx:GridViewDataColumn FieldName="CodigoCuenta" VisibleIndex="3">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataMemoColumn FieldName="GuiaInicial" VisibleIndex="4">
                                        </dx:GridViewDataMemoColumn>
                                        <dx:GridViewDataColumn FieldName="GuiaFinal" VisibleIndex="5">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="GuiaActual" VisibleIndex="6">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="GuiasPendientes" VisibleIndex="7">
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                </dx:ASPxGridView>
                            </div>
                            
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>

            <div>
                <dx:ASPxPopupControl ID="popModificar" runat="server" CloseAction="CloseButton" Width="290" Height="200"
                CloseOnEscape="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                ClientInstanceName="popModificar" HeaderText="Rangos Guías" AutoUpdatePosition="true" Modal="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl Width="100%">
                            <dx:ASPxPanel runat="server">
                                <PanelCollection>
                                    <dx:PanelContent>                                                
                                        <table>
                                            <tr>
                                                <td><dx:ASPxLabel ID="lblTituloPopup" runat="server"></dx:ASPxLabel></td>
                                            </tr>
                                            <tr>
                                                <td>Transportadora</td>
                                                <td><dx:ASPxComboBox ID="cmbPopTransportadora" runat="server" ClientInstanceName="cmbPopTransportadora"></dx:ASPxComboBox></td>
                                            </tr>
                                            <tr>
                                                <td>Nombre Rango</td>
                                                <td><dx:ASPxTextBox ID="txtPopNombreRango" runat="server" ClientInstanceName="txtPopNombreRango"></dx:ASPxTextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Código Cuenta</td>
                                                <td><dx:ASPxTextBox ID="txtPopCodigoCuenta" runat="server" ClientInstanceName="txtPopCodigoCuenta" onkeypress="solonumeros(event);"></dx:ASPxTextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Guía Inicial</td>
                                                <td><dx:ASPxTextBox ID="txtPopGuiaInicial" runat="server" ClientInstanceName="txtPopGuiaInicial"></dx:ASPxTextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Guía Final</td>
                                                <td><dx:ASPxTextBox ID="txtPopGuiaFinal" runat="server" ClientInstanceName="txtPopGuiaFinal"></dx:ASPxTextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Guía Actual</td>
                                                <td><dx:ASPxTextBox ID="txtPopGuiaActual" runat="server" ClientInstanceName="txtPopGuiaActual"></dx:ASPxTextBox></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="display:inline-block">
                                                    <dx:ASPxButton ID="btnPopGuardar" ClientInstanceName="btnPopGuardar" runat="server" Text="Aceptar">
                                                        <ClientSideEvents Click="function(s,e) { 
                                                                if(!(parseInt(txtPopGuiaInicial.GetText()) > parseInt(txtPopGuiaFinal.GetText()) || parseInt(txtPopGuiaInicial.GetText()) > parseInt(txtPopGuiaActual.GetText()) || parseInt(txtPopGuiaFinal.GetText()) < parseInt(txtPopGuiaActual.GetText()) || cmbPopTransportadora.GetValue() == 0)){
                                                                    popModificar.Hide();
                                                                }else{
                                                                    alert('Existen campos vacíos o la secuencia de numeros de guías no concuerdan [Inicial - Final - Actual]');
                                                                }
                                                            }" />
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton ID="btnPopCancelar" ClientInstanceName="btnPopCancelar" runat="server" Text="Cancelar">
                                                        <ClientSideEvents Click="function() { popModificar.Hide(); }" />
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
                                                <td colspan="2">Desea eliminar este rango?</td>
                                            </tr>
                                            <tr>
                                                <td colspan ="2">                                                    
                                                    <dx:ASPxLabel ID="lblEliRango" ClientInstanceName="lblEliRango" runat="server"></dx:ASPxLabel>
                                                </td>
                                            </tr>
                                            <tr><td></td><td></td></tr>
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
