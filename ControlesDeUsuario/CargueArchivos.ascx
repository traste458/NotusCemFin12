<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CargueArchivos.ascx.vb" Inherits="BPColSysOP.CargueArchivos" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"     TagPrefix="uc1" %>
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
     function VerImagen(NombreImagen) {
         //var idInstruccion = gvDetalle.GetRowKey(gvDetalle.GetFocusedRowIndex());
         pcVerImagen.SetContentUrl('VerImagenSoporteBlackPlatinum.aspx?RutaArchivo=' + NombreImagen);
         TamanioVentana();
         pcVerImagen.SetSize(myWidth * 0.5, myHeight * 0.8);
         pcVerImagen.ShowWindow();
     }
     var validFiles = ["bmp", "gif", "png", "jpg", "jpeg", "pdf"];

     function OnUpload() {
         var obj = document.getElementById("<% = fuArchivos.ClientID%>");
         var file = obj.files[0];
         if (file != null) {
             var tamanoArchivo = file.size;
             tamanoArchivo = Math.round(tamanoArchivo / 1024);
             if (tamanoArchivo > 10240) {
                 document.getElementById("<% = fuArchivos.ClientID%>").value = '';
                 document.getElementById("<% = rfvArchivo.ClientID%>").innerHTML = 'El archivo es demaciado grande, el tamaño maximo permitido es 10 MB';
                 return false
             }
         }
         if (obj == null) {
             document.getElementById("<% = rfvArchivo.ClientID%>").innerHTML = 'Es necesario seleccionar un archivo';
             return false
         }
         else {
             document.getElementById("<% = rfvArchivo.ClientID%>").innerHTML = '';
         }
         var source = obj.value;
         var ext = source.substring(source.lastIndexOf(".") + 1, source.length).toLowerCase();
         for (var i = 0; i < validFiles.length; i++) {
             if (validFiles[i] == ext) {
                 document.getElementById("<% = rfvArchivo.ClientID%>").innerHTML = '';
                 break;
             }
         }
         if (i >= validFiles.length) {
             document.getElementById("<% = fuArchivos.ClientID%>").value = '';
             document.getElementById("<% = rfvArchivo.ClientID%>" ).innerHTML = 'Formato del archivo incorrecto';

         }
         return true;
     }

     function EliminarSoporte(nombre) {
         //CargaImg.ShowWindow();
         cpPrincipal.PerformCallback('0:909:' + nombre);
     }
     function AgregarSoportes(s, e) {
         //CargaImg.ShowWindow();
         cpPrincipal.PerformCallback('0:905');
     }
     function DescargarDocumento(idRuta, ruta, nombre) {
         var _origen = 'RemisionSinHub';
         window.location.href = 'DescargaDocumento.aspx?id=' + idRuta + '&origen=' + _origen + '&ruta=' + ruta + '&nombre=' + nombre;
     }
     function ValidarArchivoTipo(s, e) {
         var validator = document.getElementById('vgAdicionarArchivo');
         var val = Page_ClientValidate("vgAdicionarArchivo")
         if (Page_ClientValidate("vgAdicionarArchivo")) {
             LoadingPanel.Show();

         }
         else {
             LoadingPanel.Hide();
         }

     }
       </script>
<div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
<dx:ASPxFormLayout ID="flProdManual" runat="server" Width="100%" Theme="SoftOrange">
    <Items>
          
        <dx:LayoutGroup Caption="Manual" ColCount="2" Width="100%">
            <Items>
              
                <dx:LayoutGroup Caption="Soportes" SettingsItemHelpTexts-Position="Top" ColCount="2" ShowCaption="True" VerticalAlign="Bottom">
                    <Items>
                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" ColSpan="2">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <blockquote>
                                        NOTA: Para seleccionar los archivos de soporte del equipo, debe hacerlo de a uno a la vez y puede seleccionar maximo 5 archivos; Formatos validos jpg,png.
                                    </blockquote>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" ColSpan="1">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server">
                                    <asp:FileUpload ID="fuArchivos" ClientIDMode="Static" runat="server" accept="jpg|png" maxlength="4" onChange="OnUpload();" TabIndex="7" Width="400px"></asp:FileUpload>
                                    <div>
                                        <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                            CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivos"
                                            ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.pdf|.jpg|.PDF|.JPG|.png|.PNG|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
                                        <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                            ControlToValidate="fuArchivos" ValidationGroup="vgAdicionarArchivo" />
                                    </div>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" ColSpan="1">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                    <dx:ASPxButton ID="btnAgregarSoportes" runat="server" AutoPostBack="False" ValidationGroup="vgAdicionarArchivo" Text="Guardar">
                                </dx:ASPxButton>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Layout Item" ShowCaption="False" ColSpan="2">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                    <dx:ASPxGridView ID="gvSoporte" ClientInstanceName="gvSoporte" runat="server" KeyFieldName="ruta" Visible="false" AutoGenerateColumns="false">
                                        <Settings ShowColumnHeaders="true" />
                                        <SettingsBehavior AllowFocusedRow="true" />
                                        <Columns>
                                            <dx:GridViewDataColumn FieldName="nombre" Caption="Nombre" Width="230px" VisibleIndex="1" />
                                            <dx:GridViewDataColumn FieldName="ruta" Caption="ruta" Width="230px" VisibleIndex="1" Visible="false" />
                                            <dx:GridViewDataColumn FieldName="tipoImagen" Caption="Tipo Archivo" Width="30px" VisibleIndex="2" />
                                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="6" Width="40px">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink ID="hlVerImagen" ClientInstanceName="hlVerImagen" runat="server" ImageUrl="~/images/search.png" Cursor="pointer" ClientVisible="true"
                                                        ToolTip="Ver soporte" OnInit="LinkDatosEditar_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                                                                                                              VerImagen('{0}') ; }" />
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="hlCrear" ClientInstanceName="hlCrear" runat="server" ImageUrl="~/images/eliminar.gif" Cursor="pointer" ClientVisible="true"
                                                        ToolTip="Eliminar Soporte" OnInit="LinkDatosEditar_Init">
                                                        <ClientSideEvents Click="function(s, e){
                                                                                                                                        EliminarSoporte('{0}') ; }" />
                                                    </dx:ASPxHyperLink>

                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>
                                            <dx:GridViewDataTextColumn VisibleIndex="16" Caption="idEstado" FieldName="idEstado" ShowInCustomizationForm="false" Visible="false">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <Settings ShowFooter="True" />
                                    </dx:ASPxGridView>
                                    <div>
                                        <dx:ASPxPopupControl ID="pcVerImagen" runat="server" ClientInstanceName="pcVerImagen"
                                            HeaderText="Ver Imagen" AllowDragging="True" Width="360"
                                            Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                            ScrollBars="Auto" ShowMaximizeButton="true">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="pcccVerImagen" runat="server">
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                    </div>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                    </Items>
                    <SettingsItemHelpTexts Position="Top"></SettingsItemHelpTexts>
                </dx:LayoutGroup>
            </Items>
        </dx:LayoutGroup>
    </Items>
</dx:ASPxFormLayout>
