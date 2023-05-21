<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="OfficeTrackInformacionRuta.ascx.vb"
    Inherits="BPColSysOP.OfficeTrackInformacionRuta" %>


<div id="informacionGeneral">

    <dx:ASPxRoundPanel ID="rpRegistroVentaCorporativa" runat="server" HeaderText="Historial OfficeTrack" Width="90%" Theme="SoftOrange">
        <PanelCollection>
            <dx:PanelContent>
                <div style="margin-top: 5px; margin-bottom: 10px;">
                    <asp:LinkButton ID="lbCrearTareaOT" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgCliente" OnClick="lbBuscar_Click">
                                    Crear Tarea en OfficeTrack
                    </asp:LinkButton>
                </div>
                <asp:Label id="lblError" runat="server" CssClass="error"></asp:Label>

                <dx:ASPxFormLayout ID="flRegistro" runat="server" ColCount="3">
                    <Items>
                        <dx:LayoutItem Caption="Task Number:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer25" runat="server">
                                    <dx:ASPxLabel ID="lblTaskNumber" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Estado:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                    <dx:ASPxLabel ID="lblEstado" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Duracion:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                    <dx:ASPxLabel ID="lblDuracion" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Fecha de Inicio:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                    <dx:ASPxLabel ID="lblStartDate" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Fecha de Vencimiento:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                    <dx:ASPxLabel ID="lblDueDate" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Notas:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                    <dx:ASPxLabel ID="lblNotas" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Descripción:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                    <dx:ASPxLabel ID="lblDescription" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Contacto:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                    <dx:ASPxLabel ID="lblInfoContacto" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Identificación Contacto:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                    <dx:ASPxLabel ID="lblEmployeeNumber" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="TelefonoContacto:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                    <dx:ASPxLabel ID="lblTelContacto" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Cliente:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                    <dx:ASPxLabel ID="lblInfoCliente" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Telefonos:">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                    <dx:ASPxLabel ID="lblTelefonosCliente" runat="server"
                                        Style="font-weight: 700; font-size: small">
                                    </dx:ASPxLabel>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>

                    </Items>
                </dx:ASPxFormLayout>
                <div id="HistorialTask">
                    <asp:GridView ID="gvDatos" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                        CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                        EmptyDataText="No hay log" HeaderStyle-HorizontalAlign="Center"
                        PageSize="30" ShowFooter="True" BorderColor="Gray" CellPadding="1" CellSpacing="1"
                        AllowSorting="true" DataKeyNames="IdTask, idDetalle" Width="100%" Caption="Historial">
                        <PagerSettings Mode="NumericFirstLast" />
                        <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                        <PagerStyle CssClass="field" HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <AlternatingRowStyle CssClass="alterColor" />
                        <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                        <Columns>
                            <asp:BoundField DataField="TaskNumber" HeaderText="TaskNumber" />
                            <asp:BoundField DataField="Estado" HeaderText="Estado" />
                            <asp:BoundField DataField="Notas" HeaderText="Notas" />
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                            <asp:BoundField DataField="Direccion" HeaderText="Direccion" />
                            <asp:BoundField DataField="ExternalStartDate" HeaderText="Fecha de Creación" />
                            <asp:BoundField DataField="StartDate" HeaderText="Fecha de Inicio" />
                            <asp:BoundField DataField="DueDate" HeaderText="Fecha de Finalización" />
                        </Columns>
                    </asp:GridView>
                </div>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxRoundPanel>

    <asp:HiddenField ID="hfIdServicio" runat ="server"/>
</div>

