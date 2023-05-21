<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecepcionserialesMesacontrol.aspx.vb" Inherits="BPColSysOP.RecepcionserialesMesacontrol" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>::: Cargue Inventario Pod. Financiero ::: </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
    <script type="text/javascript">

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            LoadingPanel.Show();
            cpGeneral.PerformCallback(parametro + '|' + valor);
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
                <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallback ID="callback" runat="server" ClientInstanceName="callback">
                            <ClientSideEvents EndCallback="function (s,e){
                    }" />
                        </dx:ASPxCallback>
                        <dx:ASPxPageControl ID="pcConsulta" runat="server" ActiveTabIndex="1" ClientInstanceName="pcConsulta"
                            EnableTheming="True" Height="80%" Theme="Default" Width="100%" ClientVisible="true" Visible="true">
                            <TabPages>
                                <dx:TabPage Text="Mesa de control" Name="tbIndividual">
                                    <TabImage Url="../images/usuario.png">
                                    </TabImage>
                                    <ContentCollection>
                                        <dx:ContentControl ID="ContentControl1" runat="server">
                                            <dx:ASPxRoundPanel ID="rpAdministradorInventario" ClientInstanceName="rpAdministradorInventario" ClientVisible="true" runat="server" HeaderText=" Recepcion seriales mesa de control"
                                                Width="70%" Theme="Default">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table>
                                                            <tr>
                                                                <td class="field">IdServicio:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtSerial" ClientInstanceName="txtSerial" AutoPostBack="false" runat="server" NullText="Ingrese el idservicio y preciones Enter" Width="370px" MaxLength="50">
                                                                         <ClientSideEvents KeyPress="function(s, e) {
                                                                                    if(ASPxClientEdit.ValidateGroup('vgCargar')){
                                                                                        if(e.htmlEvent.keyCode == 13) {
                                                                                            btnGuardar.DoClick();
                                                                                         ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                                                        }
                                                                                    }
                                                                                }"></ClientSideEvents>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero v&#225;lido"
                                                                                ValidationExpression="[0-9][0-9]{3,25}"></RegularExpression>
                                                                        </ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxButton ID="btnGuardar" runat="server" AutoPostBack="false" Text="Registar"
                                                                        ClientInstanceName="btnGuardar" ClientEnabled="true" ValidationGroup="vgCargar">
                                                                        <ClientSideEvents Click="function(s, e) { 
                                                                            if(ASPxClientEdit.ValidateGroup('vgCargue') && ASPxClientEdit.AreEditorsValid()){
                                                                               EjecutarCallbackGeneral(s, e, 'cargarSerial',txtSerial.GetValue()); 
                                                                                                          
                                                                                }
                                                                        }"></ClientSideEvents>
                                                                        <Image Url="../images/upload.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxButton ID="btnLimpiar" ClientInstanceName="btnLimpiar" runat="server" Text="Limpiar" AutoPostBack="false" ToolTip="Limpiar ">
                                                                        <ClientSideEvents Click="function(s, e) { 
                                                                  txtSerial.SetValue('');
                                                                   rpAdministradorInventario.SetClientVisible(true);
                                                                             gvDatos.ClearFilter(); 
                                                                    gvDatos.PerformCallback('clear'); 
                                                                           

                                                              }"></ClientSideEvents>
                                                                        <Image Url="../images/eraser_minus.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5"></td>
                                                               
                                                                <td><dx:ASPxButton ID="btnConfirmar" runat="server" AutoPostBack="false" Text="Confirmar"
                                                                        ClientInstanceName="btnConfirmar" ClientEnabled="true" >
                                                                        <ClientSideEvents Click="function(s, e) {                                                                             
                                                                               EjecutarCallbackGeneral(s, e, 'ConfirmarSeriales', 0); 
                                                                        }"></ClientSideEvents>
                                                                        <Image Url="../images/upload.png">
                                                                        </Image>
                                                                    </dx:ASPxButton></td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                            </TabPages>
                        </dx:ASPxPageControl>

                        <dx:ASPxRoundPanel ID="rpAdministrador" runat="server" ClientInstanceName="rpAdministrador" ClientVisible="false" HeaderText="Administración Inventario Financiero"
                            Width="70%" >
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td>
                                                <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                                    KeyFieldName="idServicioMensajeria" Theme="SoftOrange" Width="100%">
                                                    
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn VisibleIndex="2" Caption="Id Servicio" FieldName="idServicioMensajeria" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="3" Caption="Campañia" FieldName="Campania" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="4" Caption="Codigo Estrategia " FieldName="CCEcodigo" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="5" Caption="Cliente" FieldName="Usuario" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="6" Caption="Numero de identificacion" FieldName="identicacion" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="7" Caption="Estado Radicado" FieldName="EstadoRadicado" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="8" Caption="Ciudad" FieldName="Ciudad" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="10" Caption="Telefono" FieldName="telefono" ShowInCustomizationForm="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn VisibleIndex="11" Caption="Opciones">
                                                            <DataItemTemplate>
                                                               <dx:ASPxHyperLink ID="lnkRemueve" runat="server" ImageUrl="~/images/remove.png" Cursor="pointer" ClientVisible="true"
                                                                    ToolTip="Confirmar Servicio" OnInit="LinkDatos_Init">
                                                                    <ClientSideEvents Click="function(s, e){
                                                                      EjecutarCallbackGeneral(s, e, 'removerSerial',{0});                                                    
                                                                         }" />
                                                                   
                                                                </dx:ASPxHyperLink>
                                                            </DataItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataColumn VisibleIndex="21" Caption="">
                                                            <DataItemTemplate>
                                                                </td> </tr>
                                                                        <tr>
                                                                            <td class="field">Direcci&oacute;n
                                                                            </td>
                                                                            <td colspan="16" style="text-align: left">
                                                                                <asp:Literal runat="server" ID="ltdireccion" Text='<%# Bind("direccion")%>'></asp:Literal>
                                                                            </td>
                                                                        </tr>
                                                            </DataItemTemplate>
                                                        </dx:GridViewDataColumn>
                                                        <dx:GridViewDataColumn VisibleIndex="22" Caption="">
                                                            <DataItemTemplate>
                                                                </td> </tr>
                                                <tr>
                                                    <td class="field">Observaci&oacute;n
                                                    </td>
                                                    <td colspan="16" style="text-align: left">
                                                        <asp:Literal runat="server" ID="ltObservacion" Text='<%# Bind("observacion")%>'></asp:Literal>
                                                    </td>
                                                </tr>
                                                            </DataItemTemplate>
                                                        </dx:GridViewDataColumn>
                                                    </Columns>
                                                    <SettingsBehavior AllowSelectByRowClick="true" />
                                                    <Settings ShowHeaderFilterButton="false"></Settings>
                                                    <SettingsPager PageSize="20">
                                                        <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                    </SettingsPager>
                                                    <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                                    <SettingsText Title="Resultado B&#250;squeda"
                                                        EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                                </dx:ASPxGridView>
                                            </td>

                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
