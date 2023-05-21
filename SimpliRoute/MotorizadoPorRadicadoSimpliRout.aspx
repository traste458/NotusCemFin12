<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MotorizadoPorRadicadoSimpliRout.aspx.vb" Inherits="BPColSysOP.MotorizadoPorRadicadoSimpliRout" %>

<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Consultar Motorizado</title>
    <script>
        function editarRuta(ruta) {            
            PopUpSetContenUrl(pcGeneral, 'EditarRutaServicio.aspx?idRuta=' + ruta, '0.9', '0.9');   
            cpSincroniza.RefreshContentUrl();
        }
        function verRadicados(ruta) {            
            PopUpSetContenUrl(pc8eneral, 'VerInformacionServicio.aspx?idRuta=' + ruta, '0.9', '0.9');       
            cpSincroniza.RefreshContentUrl();
        }
        function verRuta(ruta) {            
            PopUpSetContenUrl(pcGeneral, 'Reportes/VisorHojaRuta.aspx?id=' + ruta, '0.9', '0.9'); 
            cpSincroniza.RefreshContentUrl();   
        }
        function verRutaSerializada(ruta) {            
            PopUpSetContenUrl(pcGeneral, 'Reportes/VisorHojaRutaSerializado.aspx?id=' + ruta, '0.9', '0.9');   
            cpSincroniza.RefreshContentUrl();
        }

        function VerRadicados2(ruta) {
            EjecutarCallback(LoadingPanel, cpSincroniza, 'VerRadicados', ruta);
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div>
            <dx:ASPxCallback ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                
            </dx:ASPxCallback>
            <div id="divEncabezado">
                <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
            </div>
            <div style="float: left; margin-right: 20px; margin-bottom: 20px; margin-top: 15px; width: 100%;">

                <dx:ASPxCallbackPanel ID="cpSincroniza" runat="server" ClientInstanceName="cpSincroniza"
                    Width="100%">
                    <ClientSideEvents  
                        EndCallback="function(s, e) { 
                $(&#39;#divEncabezado&#39;).html(s.cpMensaje);
                LoadingPanel.Hide(); }"></ClientSideEvents>
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText=""
                                Width="72%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table width="95%">
                                            <tr>
                                                <td>
                                                    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" ColCount="2" Width="916px">
                                                        <Items>
                                                            <dx:LayoutGroup ColCount="2" >
                                                                <Items>
                                                                    <dx:LayoutItem Caption="Radicado: " ColSpan="2" RowSpan="2">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">                                                                                  
                                                                                <table>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <dx:ASPxTextBox ID="txtRadicado" runat="server" ClientInstanceName="txtRadicado">
                                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                                                    <RegularExpression ErrorText="Solo números. No se admite cadena vacia" ValidationExpression="[0-9]*" />
                                                                                                    <RequiredField ErrorText="Ingrese un número de radicado!." />
                                                                                                </ValidationSettings>
                                                                                            </dx:ASPxTextBox> 
                                                                                        </td>
                                                                                        <td>Id Ruta: </td>
                                                                                        <td>
                                                                                            <dx:ASPxTextBox ID="txtRuta" runat="server" ClientInstanceName="txtRuta">
                                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                                                    <RegularExpression ErrorText="Solo números. No se admite cadena vacia" ValidationExpression="[0-9]*" />
                                                                                                    <RequiredField ErrorText="Ingrese un número de radicado!." />
                                                                                                </ValidationSettings>
                                                                                            </dx:ASPxTextBox> 
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="" ShowCaption="False" ColSpan="1" RowSpan="2">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                              <table>
                                                                                  <tr>
                                                                                      <td>
                                                                                          <dx:ASPxButton ID="btnBuscar" AutoPostBack="false" runat="server" ClientInstanceName="btnBuscar"
                                                                                             Text="Consultar" Border-BorderColor="#7d3d9e" Width="15px" Height="20px">
                                                                                             <Image Url="../images/lupa.png"></Image>
                                                                                             <Border BorderColor="#7D3D9E"></Border>
                                                                                                <ClientSideEvents Click="function(s,e){
                                                                                                   
                                                                                                 LoadingPanel.Show();
                                                                                                }" />
                                                                                          </dx:ASPxButton>  
                                                                                      </td>
                                                                                      <td>
                                                                                          <dx:ASPxButton ID="btnLimpiar" AutoPostBack="false" runat="server" ClientInstanceName="btnLimpiar"
                                                                                             Text="Limpiar" Border-BorderColor="#7d3d9e" Width="15px" Height="20px">  
                                                                                             <Image Url="../images/clean.png"></Image>
                                                                                             <Border BorderColor="#7D3D9E"></Border>
                                                                                          </dx:ASPxButton>
                                                                                      </td>
                                                                                  </tr>
                                                                              </table>    
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="" ShowCaption="False" ColSpan="1" RowSpan="2">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                                                                                       
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="" ShowCaption="False" Colspan="1" HorizontalAlign="Center">
                                                                        <LayoutItemNestedControlCollection>
                                                                             <dx:LayoutItemNestedControlContainer runat="server">                                                                                            
                                                                                 <dx:ASPxGridView ID="gvMotorizados" runat="server" KeyFieldName="ruta" AutoGenerateColumns="true" Visible="true" ClientInstanceName="gvMotorizados" Width="899px">
                                                                                   <Columns>
                                                                                       <dx:GridViewDataTextColumn Caption="ruta" FieldName="ruta" VisibleIndex="1" ShowInCustomizationForm="True">
                                                                                      </dx:GridViewDataTextColumn>
                                                                                       <dx:GridViewDataTextColumn Caption="numeroRadicado" FieldName="numeroRadicado" VisibleIndex="2" ShowInCustomizationForm="True">
                                                                                      </dx:GridViewDataTextColumn>  
                                                                                      <dx:GridViewDataTextColumn Caption="documento" FieldName="documento" VisibleIndex="3" ShowInCustomizationForm="True">
                                                                                      </dx:GridViewDataTextColumn>
                                                                                      <dx:GridViewDataTextColumn Caption="nombre" FieldName="nombre" VisibleIndex="4" ShowInCustomizationForm="True">
                                                                                      </dx:GridViewDataTextColumn>

                                                                                        <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="0" Width="40px">
                                                                                                        <DataItemTemplate>                                                                                                            
                                                                                                            <dx:ASPxHyperLink ID="lblView" runat="server" ImageUrl="~/images/view.png" Cursor="pointer" ClientVisible="true"
                                                                                                                ToolTip="Ver radicados asociados" OnInit="Link_Init">
                                                                                                                <ClientSideEvents Click="function(s, e){
                                                                                                                     EjecutarCallbackGeneral(LoadingPanel, cpSincroniza, 'VerRadicados', {0})
                                                                                                            }" />
                                                                                                            </dx:ASPxHyperLink>
                                                                                                            <dx:ASPxHyperLink ID="lblPdf" runat="server" ImageUrl="~/images/pdf.png" Cursor="pointer" ClientVisible="true"
                                                                                                                ToolTip="Ver ruta pdf" OnInit="Link_Init">
                                                                                                                <ClientSideEvents Click="function(s, e){
                                                                                                                      verRuta({0}) ;                                                    
                                                                                                            }" />
                                                                                                            </dx:ASPxHyperLink>  
                                                                                                            <dx:ASPxHyperLink ID="lblNew" runat="server" ImageUrl="~/images/new.png" Cursor="pointer" ClientVisible="true"
                                                                                                                ToolTip="Ver ruta serializada" OnInit="Link_Init">
                                                                                                                <ClientSideEvents Click="function(s, e){
                                                                                                                      verRutaSerializada({0}) ;                                                    
                                                                                                            }" />
                                                                                                            </dx:ASPxHyperLink>  
                                                                                            </DataItemTemplate>
                                                                                        </dx:GridViewDataColumn>

                                                                                   </Columns> 
                                                                                     
                                                                                <SettingsPager PageSize="20">
                                                                                </SettingsPager>
                                                                                </dx:ASPxGridView>
                                                                              </dx:LayoutItemNestedControlContainer>
                                                                       </LayoutItemNestedControlCollection>
                                                                   </dx:LayoutItem>                                                                                                                                                                                                       </Items>
                                                            </dx:LayoutGroup>
                                                        </Items>
                                                    </dx:ASPxFormLayout>
                                                </td>

                                            </tr>
                                        </table>                                       
                                    </dx:PanelContent>                                 
                                </PanelCollection>                                
                            </dx:ASPxRoundPanel>

                            <br />
                            
                                <dx:ASPxCallbackPanel ID="cpRadicados" ClientInstanceName="cpRadicados" ClientVisible="false" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxRoundPanel ID="rpRadicados" runat="server"  HeaderText="Listado de rutas" Width="350px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxGridView ID="gvRadicados" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvRadicados" Width="300px">
                                                             <Columns>
                                                                <dx:GridViewDataTextColumn Caption="numeroRadicado" FieldName="numeroRadicado" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>     
                                                                 <dx:GridViewDataTextColumn Caption="secuencia" FieldName="secuencia" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>  
                                                                 <dx:GridViewDataTextColumn Caption="estado" FieldName="estado" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>  
                                                                 <dx:GridViewDataTextColumn Caption="CantTelefonos" FieldName="CantTelefonos" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>  
                                                                 <dx:GridViewDataTextColumn Caption="CantSims" FieldName="CantSims" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>  
                                                                 <dx:GridViewDataTextColumn Caption="fechaAgenda" FieldName="fechaAgenda" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>  
                                                              </Columns>  
                                                            <SettingsPager PageSize="20">
                                                            </SettingsPager>
                                                        </dx:ASPxGridView>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
          
                            
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>

                 <dx:ASPxPopupControl ID="pcGeneral" runat="server" EnableViewState="False"
            ClientInstanceName="pcGeneral" Modal="True" CloseAction="CloseButton"
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True" RefreshButtonStyle-Wrap="True" ShowRefreshButton="True">
          
            <RefreshButtonStyle Wrap="True"></RefreshButtonStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True"></dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

                       

            </div>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="true">
            </dx:ASPxLoadingPanel>
            <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        </div>
    </form>
</body>
</html>
