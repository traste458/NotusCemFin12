<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecepcionSeriales.aspx.vb" Inherits="BPColSysOP.RecepcionSeriales" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>::Creacion Redistribución Seriales::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
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

        function CargarSerial(s, e) {
            if (ASPxClientEdit.ValidateGroup('GuardarProducto')) {
                cpPrincipal.PerformCallback('0:200'); //Cargar Serial
            }
        }

        function GuardarOrden(s, e) {
            if (ASPxClientEdit.ValidateGroup('Guardar')) {
                cpPrincipal.PerformCallback('0:100'); //Confirmar entrega seriales
            }
        }

        function ValidarSerial(s, e) {
            cpPrincipal.PerformCallback('0:400'); //Validar Serial
        }


        function soloNumeros(e) {
            var key = window.Event ? e.which : e.keyCode
            return (key >= 48 && key <= 57)
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <div style="padding: 1em 3em; margin: 1em 25%;">
            <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="rpCrearOrden" runat="server" ClientInstanceName="rpCrearOrden" HeaderText=" " Width="650" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxFormLayout ID="flCrearOrden" runat="server" Theme="SoftOrange">
                                        <Items>
                                            <dx:LayoutGroup Caption="Búsqueda por guía" ColCount="2" Width="650">
                                                <Items>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxPageControl ID="pcProductos" runat="server" ClientInstanceName="pcProductos" ActiveTabIndex="0" Width="100%" Theme="SoftOrange">
                                                                    <TabPages>
                                                                        <dx:TabPage Text="">
                                                                            <ContentCollection>
                                                                                <dx:ContentControl>
                                                                                    <dx:ASPxFormLayout ID="flProdManual" runat="server" Width="100%" Theme="SoftOrange">
                                                                                        <Items>
                                                                                            <dx:LayoutGroup Caption="Búsqueda traslado de seriales" ColCount="2" Width="100%">
                                                                                                <Items>
                                                                                                    <dx:LayoutItem Caption="Guía o Ruta" Width="150px" HorizontalAlign="Center" ColSpan="2">
                                                                                                        <LayoutItemNestedControlCollection>
                                                                                                            <dx:LayoutItemNestedControlContainer ID="linccSerial" runat="server" CssClass="margin-left: 93px">
                                                                                                                <dx:ASPxTextBox ID="txtSerial" runat="server" ClientInstanceName="txtSerial" AutoPostBack="false" Theme="SoftOrange"
                                                                                                                    TabIndex="2" MaxLength="22">
                                                                                                                    <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="GuardarProducto"
                                                                                                                        ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" RequiredField-IsRequired="True">
                                                                                                                        <RequiredField IsRequired="True" ErrorText="Ingrese guía o ruta"></RequiredField>
                                                                                                                        <RegularExpression ErrorText="Número de guía o ruta invalido" ValidationExpression="[a-zA-Z0-9]{2,22}" />
                                                                                                                    </ValidationSettings>
                                                                                                                 <%--   <ClientSideEvents LostFocus="function(s,e){
                                                                                                                        ValidarSerial(s,e);
                                                                                                                    }" />--%>
                                                                                                                </dx:ASPxTextBox>
                                                                                                            </dx:LayoutItemNestedControlContainer>
                                                                                                        </LayoutItemNestedControlCollection>
                                                                                                    </dx:LayoutItem>


                                                                                                    <dx:LayoutItem Caption="Layout Item" ShowCaption="False" Width="150px" HorizontalAlign="Center" ColSpan="2">
                                                                                                        <LayoutItemNestedControlCollection>
                                                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                                                <dx:ASPxButton ID="btnBuscarTraslado" runat="server" AutoPostBack="False" Text="Buscar"
                                                                                                                     Width="180px" Font-Bold="true" Theme="SoftOrange" TabIndex="11">
                                                                                                                    <ClientSideEvents Click="function(s,e){
                                                                                                                        CargarSerial(s,e);
                                                                                                                    }" />
                                                                                                                    <Image Url="~/images/find.gif">
                                                                                                                    </Image>
                                                                                                                </dx:ASPxButton>
                                                                                                        
                                                                                                            </dx:LayoutItemNestedControlContainer>
                                                                                                        </LayoutItemNestedControlCollection>
                                                                                                    </dx:LayoutItem>
                                                                                                    
                                                                                                       <dx:LayoutItem Caption="Layout Item" ShowCaption="False" Width="150px" HorizontalAlign="Center" ColSpan="2">
                                                                                                        <LayoutItemNestedControlCollection>
                                                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                                                <dx:ASPxButton ID="btnConfirmarEntrega" runat="server" AutoPostBack="False" ClientInstanceName="btnConfirmarEntrega" Text="Confirmar Entrega"
                                                                                                                    ValidationGroup="GuardarProducto" Width="180px" Font-Bold="true" Theme="SoftOrange" TabIndex="2">
                                                                                                                    <ClientSideEvents Click="function(s,e){
                                                                                                                        GuardarOrden(s,e);
                                                                                                                    }" />
                                                                                                                    <Image Url="~/images/ok.png">
                                                                                                                    </Image>
                                                                                                                </dx:ASPxButton>
                                                                                                            </dx:LayoutItemNestedControlContainer>
                                                                                                        </LayoutItemNestedControlCollection>
                                                                                                    </dx:LayoutItem>
                                                                                                 
                                                                                                </Items>
                                                                                            </dx:LayoutGroup>
                                                                                        </Items>
                                                                                    </dx:ASPxFormLayout>
                                                                                </dx:ContentControl>
                                                                            </ContentCollection>
                                                                        </dx:TabPage>
                                                                    </TabPages>
                                                                </dx:ASPxPageControl>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:EmptyLayoutItem ColSpan="2">
                                                    </dx:EmptyLayoutItem>
                                                    <dx:LayoutItem Caption="Productos" ShowCaption="False" ColSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="linccGridProductos" runat="server" Theme="SoftOrange">
                                                                <dx:ASPxGridView ID="gridProductos" runat="server" ClientInstanceName="gridProductos" AutoGenerateColumns="false" Width="100%" KeyFieldName="numGuia" Theme="SoftOrange">
                                                                    <SettingsBehavior ColumnResizeMode="Control" AllowFocusedRow="true" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="idProducto" Caption="idProducto" VisibleIndex="0" Width="1px" EditFormSettings-Visible="False" Visible="false">
                                                                            <EditFormSettings Visible="False"></EditFormSettings>
                                                                        </dx:GridViewDataTextColumn>
                                                            
                                                                        <dx:GridViewDataTextColumn Caption="serial" VisibleIndex="3" EditFormSettings-Visible="True" FieldName="serial" Width="20%">
                                                                            <EditFormSettings Visible="True"></EditFormSettings>
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Ruta" FieldName="idRuta" ShowInCustomizationForm="True" VisibleIndex="9" Width="8%">
                                                                           <HeaderStyle HorizontalAlign="Center" />
                                                                           <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Producto" FieldName="Producto" ShowInCustomizationForm="True" VisibleIndex="9" Width="18%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Resp. Entrega" FieldName="responsableEntrega" ShowInCustomizationForm="True" VisibleIndex="10" Width="25%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Resp. Recepción" FieldName="responsableRecepcion" ShowInCustomizationForm="True" VisibleIndex="11" Width="25%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                          <dx:GridViewDataTextColumn Caption="Observaciones" FieldName="observacion" ShowInCustomizationForm="True" VisibleIndex="11" Width="30%">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <CellStyle Font-Size="X-Small"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="function(s,e){FuncionesBotones(s,e);}"
                                                                        EndCallback="function(s,e){ 
                                                                            FinCallbackGrid(s.cpGrMensaje);
                                                                         }" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                                <SettingsItems HorizontalAlign="Center"></SettingsItems>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>

                    </dx:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="function(s,e){
                        
                    }" />
            </dx:ASPxCallbackPanel>
        </div>



    </form>
</body>
</html>
