<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfiguracionCuentasTransportadoras.aspx.vb" Inherits="BPColSysOP.ConfiguracionCuentasTransportadorasCEM" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <%--<link href="../include/styleDiv.css" type="text/css" rel="stylesheet" />--%>
    <title></title>
    <script>
        function nuevaCuenta() {
            hidIdCuenta.Set("Value", "0");
            cmbPopTransportadora.SetValue("");
            txtPopNombreCuenta.SetValue("");
            txtPopCodigoCuenta.SetValue("");
            txtPopCuentaUsuario.SetValue("");
            txtPopCuentaPass.SetValue("");
            txtPopCodFacturacion.SetValue("");
            txtPopNombreCargue.SetValue("");
            cbActivo.SetValue(true);
            cbActivo.SetEnabled(false);
            popModificar.Show();
        }

        function editarCuenta(idCuenta, IdTransportadora, NombreCuenta, xCodigoCuenta, CuentaUsuario, CuentaPass, xCodFacturacion, xNombreCargue, activo,xidtipoBodega,xIdBodega) {
            hidIdCuenta.Set("Value", idCuenta);
            cmbPopTransportadora.SetValue(IdTransportadora);
            txtPopNombreCuenta.SetValue(NombreCuenta);
            txtPopCodigoCuenta.SetValue(xCodigoCuenta);
            txtPopCuentaUsuario.SetValue(CuentaUsuario);
            txtPopCuentaPass.SetValue(CuentaPass);
            txtPopCodFacturacion.SetValue(xCodFacturacion);
            txtPopNombreCargue.SetValue(xNombreCargue);
            cbActivo.SetChecked(activo);
            cbActivo.SetEnabled(true);
            cmbTipoBodegaDestino.SetValue(xidtipoBodega);
            hidBodega.Set("Value", xIdBodega);
            CallbackvsShowPopup(popModificar,xidtipoBodega,'xxxxxx','0.30','0.20');
           // popModificar.Show();
        }

        function verHistorial(idCuenta) {
            // hidIdCuenta.Set("Value", idCuenta); 
            // gvDatos.PerformCallback(idCuenta + '|DataHistorico');
            popHistorico.Show();
        }
    </script>
    <style type="text/css">
        .auto-style2 {
            width: 125px;
        }
        .auto-style4 {
            width: 230px;
        }
        .auto-style5 {
            width: 230px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                <dx:ASPxHiddenField ID="hidIdCuenta" ClientInstanceName="hidIdCuenta" runat="server"></dx:ASPxHiddenField>
                 <dx:ASPxHiddenField ID="hidBodega" value="0" ClientInstanceName="hidBodega" runat="server"></dx:ASPxHiddenField>
            </div>
            <dx:ASPxRoundPanel ID="rpDatos" ClientInstanceName="rpDatos" runat="server" HeaderText="Configuración de cuentas para generar guías">
                <PanelCollection>
                    <dx:PanelContent>
                        <p>
                            <dx:ASPxButton ID="btnNuevoRango" ClientInstanceName="btnNuevoRango" AutoPostBack="false" runat="server" Text="Nueva Cuenta">
                                <ClientSideEvents Click="function() { nuevaCuenta() }" />
                            </dx:ASPxButton>
                        </p>
                        <div>
                            <dx:ASPxGridView ID="gvDatos" ClientInstanceName="gvDatos" runat="server" KeyFieldName="idcuenta">
                                <ClientSideEvents EndCallback="function(s, e) {
                                           popHistorico.Show();
                                        }"></ClientSideEvents>
                                <Columns>
                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="0" CellStyle-HorizontalAlign="Center"
                                        Width="75px">
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <DataItemTemplate>
                                            <dx:ASPxHyperLink ID="linkEditar" ClientInstanceName="linkEditar" runat="server"
                                                ImageUrl="~/images/edit.gif" Cursor="pointer" ToolTip="Editar Cuenta" OnInit="Link_Init">
                                                <ClientSideEvents Click="function(s, e){ editarCuenta({0}, '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', '{10}'); }" />
                                            </dx:ASPxHyperLink>
                                            <dx:ASPxHyperLink ID="linkHistorial" ClientInstanceName="linkHistorial" runat="server"
                                                ImageUrl="~/images/view.png" Cursor="pointer" ToolTip="Ver Historial" OnInit="Link_Init">
                                                <ClientSideEvents Click="function(s, e){  CallbackvsShowPopup(popHistorico,{0},'MostrarHistorico','0.30','0.20');   }" />
                                            </dx:ASPxHyperLink>
                                        </DataItemTemplate>
                                        <CellStyle HorizontalAlign="Center">
                                        </CellStyle>
                                    </dx:GridViewDataColumn>

                                    <dx:GridViewDataTextColumn FieldName="idcuenta" Caption="idcuenta" Visible="false">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataColumn FieldName="idtransportadora" Visible="false">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="NombreTransportadora" VisibleIndex="1">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="Descripcion" VisibleIndex="2">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="CodigoCuenta" VisibleIndex="3">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="CuentaUser" VisibleIndex="4">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="CodFacturacion" VisibleIndex="5">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="NombreCargue" VisibleIndex="6">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="activo" Caption="activo" VisibleIndex="7">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="CodBodega" Caption="CodBodega" VisibleIndex="8">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="Bodega" Caption="Bodega" VisibleIndex="9">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="CiudadBodega" Caption="CiudadBodega" VisibleIndex="10">
                                    </dx:GridViewDataColumn>

                                </Columns>
                            </dx:ASPxGridView>
                        </div>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>

            <div>
                <dx:ASPxPopupControl ID="popModificar" runat="server" CloseAction="CloseButton" Width="450px" Height="200px"
                    CloseOnEscape="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                    ClientInstanceName="popModificar" HeaderText="Cuenta">
                    <ContentCollection>
                        <dx:PopupControlContentControl Width="100%">
                            <dx:ASPxPanel runat="server">
                                <PanelCollection >
                                    <dx:PanelContent width="100%">
                                        <table >
                                            <tr>
                                                <td class="auto-style5">
                                                    <dx:ASPxLabel ID="lblTituloPopup" runat="server"></dx:ASPxLabel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5" >Transportadora </td>
                                                <td class="auto-style5">
                                                    <dx:ASPxComboBox ID="cmbPopTransportadora" runat="server" ClientInstanceName="cmbPopTransportadora" Width="200px"></dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">Nombre Cuenta</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopNombreCuenta" runat="server" ClientInstanceName="txtPopNombreCuenta" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            
                                            <tr>
                                                <td class="auto-style5">Codigo Cuenta</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopCodigoCuenta" runat="server" ClientInstanceName="txtPopCodigoCuenta" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">Cuenta Usuario(Login)</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopCuentaUsuario" runat="server" ClientInstanceName="txtPopCuentaUsuario" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">Cuenta pass</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopCuentaPass" runat="server" ClientInstanceName="txtPopCuentaPass" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td class="auto-style5">Codigo Facturacion</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopCodFacturacion" runat="server" ClientInstanceName="txtPopCodFacturacion" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">Nombre Cargue</td>
                                                <td class="auto-style5">
                                                    <dx:ASPxTextBox ID="txtPopNombreCargue" runat="server" ClientInstanceName="txtPopNombreCargue" Width="200px"></dx:ASPxTextBox>
                                                </td>
                                            </tr>

                                            <tr>

                                                <td class="auto-style5">
                                                    <dx:ASPxLabel ID="lblTipoBodegaDestino" runat="server" Text="Tipo bodega destino" ClientInstanceName="lblTipoBodegaDestino"></dx:ASPxLabel>
                                                </td>
                                                <td class="auto-style5">
                                                    <dx:ASPxComboBox ID="cmbTipoBodegaDestino" runat="server" ClientInstanceName="cmbTipoBodegaDestino" AutoPostBack="true" Width="200px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                            <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">
                                                    <dx:ASPxLabel ID="lblBodegaDestino" runat="server" Text="Bodega Destino" ClientInstanceName="lblBodegaDestino"></dx:ASPxLabel>
                                                </td>
                                                <td class="auto-style2">
                                                    <dx:ASPxComboBox ID="cmbBodegaDestino" runat="server" ClientInstanceName="cmbBodegaDestino" Width="200px">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="addRadicado">
                                                            <RequiredField ErrorText="Campo Requerido" IsRequired="true" />
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                </td>

                                            </tr>

                                            <tr>
                                                <td class="auto-style5">Activo</td>
                                                <td>
                                                    <dx:ASPxCheckBox ID="cbActivo" ClientInstanceName="cbActivo" runat="server"></dx:ASPxCheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">- - -</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="display: inline-block">
                                                    <dx:ASPxButton ID="btnPopGuardar" ClientInstanceName="btnPopGuardar" runat="server" Text="Aceptar">
                                                        <ClientSideEvents Click="function(s,e) { 
                                                                if(!( txtPopNombreCuenta.GetText()=='' || txtPopCodigoCuenta.GetText()=='' || cmbPopTransportadora.GetValue() == 0)){
                                                                    popModificar.Hide();
                                                                    LoadingPanel.Show();
                                                                    setTimeout('LoadingPanel.Hide();',2000);  
                                                                }else{
                                                                    alert('Existen campos vacíos');
                                                            e.processOnServer =false;
                                                                }
                                                            }" />
                                                    </dx:ASPxButton>

                                                </td>
                                                <td>
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
                <dx:ASPxPopupControl ID="popHistorico" runat="server" ClientInstanceName="popHistorico" CloseAction="CloseButton" Width="250" Height="100"
                    CloseOnEscape="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                    HeaderText="Historico" AutoUpdatePosition="true">
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <dx:ASPxPanel ID="panEliminar" runat="server">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <div>
                                            <dx:ASPxGridView ID="gvHistorico" ClientInstanceName="gvHistorico" runat="server" KeyFieldName="id">
                                                <Columns>

                                                    <dx:GridViewDataTextColumn FieldName="id" Caption="idcuenta" Visible="false">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataColumn FieldName="idtransportadora" Visible="false">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="NombreTransportadora" VisibleIndex="1">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="Descripcion" VisibleIndex="2">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="CodigoCuenta" VisibleIndex="3">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="CuentaUser" Caption="CuentaUser" VisibleIndex="4">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="CodFacturacion" VisibleIndex="5">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="nombreCargue" VisibleIndex="6">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="activo" Caption="activo" VisibleIndex="7">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="CodBodega" Caption="CodBodega" VisibleIndex="8">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="Bodega" Caption="Bodega" VisibleIndex="9">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="CiudadBodega" Caption="CiudadBodega" VisibleIndex="10">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="Usuario" Caption="Usuario" VisibleIndex="11">
                                                    </dx:GridViewDataColumn>
                                                    <dx:GridViewDataColumn FieldName="FechaCambio" Caption="FechaCambio" VisibleIndex="12">
                                                    </dx:GridViewDataColumn>
                                                </Columns>
                                                <SettingsBehavior AllowSelectByRowClick="true" />
                                                <Settings ShowHeaderFilterButton="false"></Settings>
                                                <SettingsPager PageSize="5">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                </SettingsPager>
                                                <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                            </dx:ASPxGridView>
                                        </div>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxPanel>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
            </div>
        </div>

        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>

    </form>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
