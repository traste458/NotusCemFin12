<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreaciónServicioServicioTecnico.aspx.vb" Inherits="BPColSysOP.CreaciónServicioServicioTecnico" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> ::: Equipos Reparados Servicio Técnico :::</title>
    <link rel="shortcut icon" href ="../images/baloons_small.png"/>
    <script language="javascript" type="text/javascript">

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

        function Procesar() {
            var valor = hdIdGeneral.Get("valor");
                if (valor == 0) {
                } else {
                    gvErrores.PerformCallback();
                    TamanioVentana();
                    dialogoErrores.SetSize(myWidth * 0.6, myHeight * 0.6);
                    dialogoErrores.ShowWindow();
                }
                LoadingPanel.Hide();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                FinalizarCallbackGeneral(s, e, 'divEncabezado');
            }" />
           <PanelCollection>
               <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdGeneral" runat ="server" ClientInstanceName ="hdIdGeneral"></dx:ASPxHiddenField>
                    <dx:ASPxRoundPanel ID="rpInformacion" runat="server" HeaderText="Equipos Reparados Servicio Técnico" Width="60%" Theme ="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <fieldset>
                                    <legend> Creación Servicio: </legend>
                                    <dx:ASPxFormLayout ID="flInformacion" runat="server" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Archivo:" RequiredMarkDisplayMode="Required">
                                            <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                        <asp:FileUpload ID="fuArchivo" runat="server" />
                                                        <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                            <a href="javascript:void(0);" id="VerEjemplo" onclick="WindowLocation('Plantillas/EjemploReparadoServicioTecnico.xlsx');"
                                                                class="style2"><span class="style3">(Ver Archivo Ejemplo)</span></a>
                                                        </div> 
                                                    </dx:LayoutItemNestedControlContainer> 
                                            </LayoutItemNestedControlCollection> 
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Acciones:" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                        <dx:ASPxButton ID="btnUpload" runat ="server" ClientInstanceName ="btnUpload" ValidationGroup ="vgCrea"
                                                            Text ="Crear Servicio" Theme ="SoftOrange" AutoPostBack ="true"> 
                                                            <ClientSideEvents Click ="function (s, e){
                                                                LoadingPanel.Show(); 
                                                            }" />
                                                            <Image Url="~/images/upload.png"></Image>
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer> 
                                                </LayoutItemNestedControlCollection> 
                                            </dx:LayoutItem> 
                                        </Items> 
                                    </dx:ASPxFormLayout> 
                                </fieldset> 
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel> 
                   <dx:ASPxPopupControl ID="pcErrores" runat="server" ClientInstanceName="dialogoErrores" ScrollBars ="Auto" 
                        HeaderText="Resultado Proceso" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction ="CloseButton" Theme ="SoftOrange">
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="pccError" runat="server">
                                <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" HeaderText="Log de Errores" Theme="SoftOrange">
                                    <HeaderTemplate>
                                        <dx:ASPxImage ID="headerImage" runat="server" ImageUrl="../images/MSExcel.png" Cursor="pointer"
                                            ImageAlign="Right" ToolTip="Descargar Archivo">
                                            <ClientSideEvents Click="function (s,e){
                                                    btnReporte.DoClick();
                                                }" />
                                        </dx:ASPxImage>
                                    </HeaderTemplate>
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxButton ID="btnReporte" runat="server" ClientInstanceName="btnReporte" ClientVisible="false"
                                                UseSubmitBehavior="False" OnClick="btnXlsxExport_Click">
                                            </dx:ASPxButton>
                                            <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores"
                                                Theme="SoftOrange">
                                                <SettingsPager PageSize="20">
                                                </SettingsPager>
                                            </dx:ASPxGridView>
                                            <dx:ASPxGridViewExporter ID="gveErrores" runat="server" GridViewID="gvErrores">
                                            </dx:ASPxGridViewExporter>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
               </dx:PanelContent>
           </PanelCollection> 
        </dx:ASPxCallbackPanel> 
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
