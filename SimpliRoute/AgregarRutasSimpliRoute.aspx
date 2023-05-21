<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AgregarRutasSimpliRoute.aspx.vb" Inherits="BPColSysOP.AgregarRutasSimpliRoute" %>

<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="~/ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc3" %>
<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <script>
        function verRadicados(idRuta) {            
            PopUpSetContenUrl(pcGeneral, 'VerInformacionServicio.aspx?idRuta=' + idRuta, '0.9', '0.9');       
            cpSincroniza.RefreshContentUrl();
        }
        function verRuta(idRuta) {            
            PopUpSetContenUrl(pcGeneral, 'Reportes/VisorHojaRutasSimpliRoute.aspx?id=' + idRuta, '0.9', '0.9'); 
            cpSincroniza.RefreshContentUrl();   
        }
        function verRutaSerializada(idRuta) {            
            PopUpSetContenUrl(pcGeneral, 'Reportes/VisorHojaRutaSerializadoSimpliRoute.aspx?id=' + idRuta, '0.9', '0.9');   
            cpSincroniza.RefreshContentUrl();
        }

        function VerRadicados2(idRuta) {
            EjecutarCallback(LoadingPanel, cpSincroniza, 'VerRadicados', idRuta);
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
                                Width="38%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <table>
                                            <tr>
                                                <td>
                                                    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" ColCount="1" Width="445px">
                                                        <Items>
                                                            <dx:LayoutGroup ColCount="3" ShowCaption="False">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="" ShowCaption="False" ColSpan="1" RowSpan="2">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxButton ID="btnAsync" AutoPostBack="false"  runat="server" ClientInstanceName="btnAsync"
                                                                                Text="Sincronizar" Border-BorderColor="#7d3d9e" Width="40px" Height="10px">
                                                                               <Image Url="../images/sincronizar.png"></Image>
                                                                               <Border BorderColor="#7D3D9E"></Border>
                                                                                 <ClientSideEvents Click="function(s,e){
                                                                                    LoadingPanel.Show();
                                                                                    }" />
                                                                            </dx:ASPxButton>                                                                                
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="" ShowCaption="False" ColSpan="2" RowSpan="2">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxButton ID="btnCrearRuta" Visible="false" AutoPostBack="false"  runat="server" ClientInstanceName="btnCrearRuta"
                                                                                Text="Crear Ruta" Border-BorderColor="#7d3d9e" Width="100px" Height="10px">
                                                                               <Image Url="../images/map.png"></Image>
                                                                               <Border BorderColor="#7D3D9E"></Border>
                                                                                 <ClientSideEvents Click="function(s,e){
                                                                                    LoadingPanel.Show();
                                                                                    }" />
                                                                            </dx:ASPxButton>                                                                                
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                </Items>
                                                            </dx:LayoutGroup>
                                                        </Items>
                                                    </dx:ASPxFormLayout>
                                                </td>
                                            </tr>
                                        </table> 
                            <div>
                                <dx:ASPxLabel runat="server" ID="lbCantidad" BackColor="Green"></dx:ASPxLabel>
                            </div>       
                                                     
                            <div id="dvServicios" style="float:left; margin-top: 5px; width: 100%;" >
                                <dx:ASPxCallbackPanel ID="cpServicios" ClientInstanceName="cpServicios" ClientVisible="false" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxRoundPanel ID="pnServicios" runat="server" HeaderText="Listado de servicios" Width="537px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxGridView ID="gvServis" runat="server" Visible="false" KeyFieldName="idServicioMensajeria" AutoGenerateColumns="false" ClientInstanceName="gvServis" Width="675px">
                                                             <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Radicado" VisibleIndex="0" FieldName="numeroRadicado" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn> 
                                                                 <dx:GridViewDataTextColumn Caption="Documento Motorizado" VisibleIndex="1" FieldName="idtercero2" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Motorizado" VisibleIndex="2" FieldName="tercero" ShowInCustomizationForm="True">
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
                            </div>
                                   
                                  <br />

                                        
                            <div id="dvRutas" style="float: left; margin-top: 5px; width: 100%; visibility: visible">
                                <dx:ASPxCallbackPanel ID="pcRutas" ClientInstanceName="pcRutas" ClientVisible="false" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxRoundPanel ID="rpRutas" runat="server"  HeaderText="Listado de rutas" Width="537px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxGridView ID="gvRutas" runat="server" KeyFieldName="idRuta" AutoGenerateColumns="true" ClientInstanceName="gvRutas" Width="675px">
                                                             <Columns>
                                                                <dx:GridViewDataTextColumn Caption="idRuta" VisibleIndex="0" FieldName="idRuta" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>     
                                                                 <dx:GridViewDataTextColumn Caption="Motorizado" VisibleIndex="1" FieldName="tercero" ShowInCustomizationForm="True">
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="3" Width="40px">
                                                                        <DataItemTemplate>                                                                            
                                                                            <%--<dx:ASPxHyperLink ID="lblView" runat="server" ImageUrl="~/images/view.png" Cursor="pointer" ClientVisible="true"
                                                                                ToolTip="Ver radicados asociados" OnInit="Link_Init">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                                     EjecutarCallbackGeneral(LoadingPanel, cpSincroniza, 'VerRadicados', {0})
                                                                            }" />

                                                                            </dx:ASPxHyperLink>--%>
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
                                                        <dx:ASPxGridView ID="gvRadicados" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvRadicados" Width="674px">
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
                            </div>
                                   
                                        </dx:PanelContent>                                 
                                </PanelCollection>                                
                            </dx:ASPxRoundPanel>

                            <br />


            <dx:ASPxPopupControl ID="pcGeneral" runat="server" EnableViewState="False"
            ClientInstanceName="pcGeneral" Modal="True" CloseAction="CloseButton"
            HeaderText="Información del Servicio" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True" RefreshButtonStyle-Wrap="True" ShowRefreshButton="True">
          
            <RefreshButtonStyle Wrap="True"></RefreshButtonStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True"></dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

                            <br />

         
                            <div id="divpnlErrores" style="visibility: visible">
                                <dx:ASPxCallbackPanel ID="cperrores" ClientInstanceName="cperrores" ClientVisible="false" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxGridViewExporter ID="gveExportadorErrores" runat="server" GridViewID="gvErrores">
                                            </dx:ASPxGridViewExporter>
                                            <dx:ASPxRoundPanel ID="rpLogErrores" runat="server"  HeaderText="Log de Errores" Width="350px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxButton ID="btnExportar" runat="server" Text="Exportar Errores a Excel" Visible="False">
                                                        </dx:ASPxButton>
                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores" Width="300px">
                                                             <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Mensaje" FieldName="Mensaje" ShowInCustomizationForm="True">
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
                            </div>
                            
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>




            </div>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="true">
            </dx:ASPxLoadingPanel>
            <script src="../include/jquery-1.min.js" type="text/javascript"></script>
            <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        </div>
    </form>
</body>
</html>
