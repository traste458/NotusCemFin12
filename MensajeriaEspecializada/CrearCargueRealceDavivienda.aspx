<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearCargueRealceDavivienda.aspx.vb" Inherits="BPColSysOP.CrearCargueRealceDavivienda" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cargue realces Davivienda</title>
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


        function CargarArchivo() {
            var mensaje = document.getElementById('divEncabezadoPrincipal').innerHTML;
            if (mensaje != undefined) {
                if (mensaje.indexOf("tablaErrores") >= 0) {
                    gridErrores.PerformCallback();
                    VerErrores();
                }
            }
        }

        function VerErrores() {
            TamanioVentana();
            pcGridErrores.SetSize(myWidth * 0.5, myHeight * 0.8);
            pcGridErrores.ShowWindow();
        }

        function VerEjemplo() {
            window.location.href = 'Archivos/PlantillaRealcesDavivienda.xlsx';
        }

        function CambioTipoArchivo(s, e) {
            var tipoArchivo = radTipoArchivo.GetValue();
            cpPrincipal.PerformCallback("CAMBIOTIPOARCHIVO¬" + tipoArchivo);
        }

        function CargarArchivoServicio(s, e) {
            cpPrincipal.PerformCallback("CARGARARCHIVO");
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
                        <dx:ASPxFormLayout ID="frmCargarArchivo" runat="server">
                            <Items>
                                <dx:LayoutGroup Caption="Archivos Ejemplo" ColCount="5">
                                    <Items>
                                        <dx:LayoutItem Caption="Archivos Ejemplo" ShowCaption="False">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <a href="javascript:void(0)" id="VerEjemplo" onclick="VerEjemplo()">Descargar ejemplo</a>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>                                        
                                    </Items>
                                </dx:LayoutGroup>
                                <dx:LayoutGroup Caption="Cargar Archivo">
                                    <Items>
                                        <dx:LayoutItem Caption="Archivo a Cargar" >
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer ID="linccCargarArchivo" runat="server">
                                                    <asp:FileUpload ID="fUploadArchivo" runat="server"/>
                                                    <dx:ASPxButton ID="btnUpload" runat="server"  Text="Cargar archivo" ClientInstanceName="btnUpload" ValidationGroup="CargarArchivo">
                                                        <Image Url="../images/upload.png">
                                                        </Image>
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>
                            </Items>
                        </dx:ASPxFormLayout>
                        <dx:ASPxPopupControl ID="pcGridErrores" runat="server" ClientInstanceName="pcGridErrores"
                            HeaderText="Errores" AllowDragging="True" Width="400px" Height="180px" Modal="True"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto">
                            <ContentCollection>
                                <dx:PopupControlContentControl ID="pcccGridErrores" runat="server">
                                    <dx:ASPxRoundPanel ID="rpErrores" runat="server" Width="100%" ClientInstanceName="rpErrores" ShowHeader="false">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxGridView ID="gridErrores" runat="server" ClientInstanceName="gridErrores"
                                                    KeyFieldName="Columna" Width="100%" AutoGenerateColumns="true">
                                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowFilterRowMenuLikeItem="True"
                                                        ShowHeaderFilterButton="True" ShowFilterBar="Visible" HorizontalScrollBarMode="Auto"></Settings>
                                                    <ClientSideEvents EndCallback="function(s, e){$('#divEncabezado').html(s.cpMensaje);}" />
                                                </dx:ASPxGridView>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxRoundPanel>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </dx:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="function(s,e){CargarArchivo(s.cpMensaje);}" />
            </dx:ASPxCallbackPanel>
        </div>
    </form>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
</body>
</html>
