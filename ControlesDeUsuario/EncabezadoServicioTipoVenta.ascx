<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EncabezadoServicioTipoVenta.ascx.vb" Inherits="BPColSysOP.EncabezadoServicioTipoVenta" %>

<div style="float: left; width: 100%;">
    <dx:ASPxRoundPanel ID="rpRegistros" runat="server" HeaderText="Datos Básicos" Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <table cellpadding="1" width="100%">
<tr>
                        <td style="width: 15%">Número de Servicio:</td>
                        <td style="width: 35%">
                            <dx:ASPxLabel ID="lblIdServicio" runat="server" Text="" ClientVisible="false" />
                            <asp:Image ID="imgBarCode" runat="server" Width="150px" Height="60px" />
                        </td>
                        <td style="width: 15%">Estado:</td>
                        <td style="width: 35%">
                            <dx:ASPxLabel ID="lblEstado" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Ciudad de Entrega:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblCiudadEntrega" runat="server" Text="" />
                        </td>
                        <td>Campaña: </td>
                        <td>
                            <dx:ASPxLabel ID="lblCampania" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Plan:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblPlan" runat="server" Text="" />
                            &nbsp;- CFM:
                            <dx:ASPxLabel ID="lblCFM" runat="server">
                            </dx:ASPxLabel>
                        </td>
                        <td>Identificación del Cliente:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblIdentificacionCliente" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Barrio:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblBarrio" runat="server">
                            </dx:ASPxLabel>
                        </td>
                        <td>Nombres del Cliente:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblNombresCliente" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Dirección:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblDireccion" runat="server" Text="" />
                        </td>
                        <td>Observaciones sobre dirección:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblObservacionDireccion" runat="server" Text="" />
                        </td>
                    </tr>
                    <tr>
                        <td>Teléfono Móvil:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblTelefonoMovil" runat="server" Text="" />
                        </td>
                        <td>Teléfono Fijo:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblTelefonoFijo" runat="server" Text="" />
                        </td>
                    </tr>
                    <tr>
                        <td>Forma de Pago:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblFormaPago" runat="server" Text="" />
                        </td>
                        <td>Fecha agenda:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblFechaAgenda" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Jornada:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblJornada" runat="server">
                            </dx:ASPxLabel>
                        </td>
                        <td>Observaciones:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblObservaciones" runat="server">
                            </dx:ASPxLabel>
                        </td>
                    </tr>
                    <tr>
                        <td>Fecha de Creación:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblFechaCreacion" runat="server"></dx:ASPxLabel>
                        </td>
                        <td>Fecha de Confirmación:
                        </td>
                        <td>
                            <dx:ASPxLabel ID="lblFechaConfirmacion" runat="server"></dx:ASPxLabel>
                        </td>
                    </tr>
                </table>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
</div>

<div style="margin-top: 10px; float: left; width: 45%;">
    <dx:ASPxRoundPanel ID="rpEquipos" runat="server" HeaderText="Información de Equipos"
        Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxGridView ID="gvListaReferencias" runat="server" AutoGenerateColumns="False"
                    Width="100%" ClientInstanceName="grid">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="Material" ShowInCustomizationForm="True" VisibleIndex="0"
                            Caption="Material">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="DescripcionMaterial" ShowInCustomizationForm="True"
                            VisibleIndex="0" Caption="Descripción Material">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsBehavior AllowSelectByRowClick="true" />
                    <SettingsPager PageSize="5">
                    </SettingsPager>
                </dx:ASPxGridView>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
</div>

<div style="margin-top: 10px; margin-left: 10px; float: left; width: 45%;">
    <dx:ASPxRoundPanel ID="rpMins" runat="server" HeaderText="Información de Líneas"
        Width="100%">
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxGridView ID="gvListaMsisdn" runat="server" AutoGenerateColumns="False" Width="100%"
                    ClientInstanceName="grid">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="MSISDN" ShowInCustomizationForm="True" VisibleIndex="0"
                            Caption="Línea">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="PrecioConIva" ShowInCustomizationForm="True"
                            VisibleIndex="1" Caption="Precio con IVA">
                            <PropertiesTextEdit DisplayFormatString="{0:c}" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="PrecioSinIva" ShowInCustomizationForm="True"
                            VisibleIndex="2" Caption="Precio sin IVA">
                            <PropertiesTextEdit DisplayFormatString="{0:c}" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Clausula" ShowInCustomizationForm="True" VisibleIndex="3"
                            Caption="Clausula">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NombreRegion" ShowInCustomizationForm="True" VisibleIndex="4"
                            Caption="Región">
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsBehavior AllowSelectByRowClick="true" />
                    <SettingsPager PageSize="5">
                    </SettingsPager>
                </dx:ASPxGridView>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>
</div>
