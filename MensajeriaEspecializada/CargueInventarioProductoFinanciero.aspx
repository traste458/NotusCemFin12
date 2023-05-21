<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargueInventarioProductoFinanciero.aspx.vb" Inherits="BPColSysOP.CargueInventarioProductoFinanciero" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::: Cargue Inventario Pod. Financiero ::: </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">
        function UpdateUploadButton() {
            btnUpload.SetEnabled(upArchivo.GetText(0) != "");
        }

        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }

        function CargaCompleta(e) {
            if (e.errorText.length > 0) {
                if (e.errorText.indexOf('Violation') >= 0) {
                    alert('No fue posible cargar el archivo, por favor verifique que el mismo no se encuentre abierto e intente nuevamente.');
                } else {
                    alert(e.errorText);
                }
                LoadingPanel.Hide();
            }
        }

        function ProcesarCarga(s, e) {
            if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            if (e.callbackData != null) {
                $('#divFileContainer').html(e.callbackData);
            }

            if (s.cpResultadoProceso != null) {
                if (s.cpResultadoProceso == 0) {
                    $('#divReporte').css('visibility', 'visible');
                } else {
                    if (s.cpResultadoProceso == 1 || s.cpResultadoProceso == 2 || s.cpResultadoProceso == 10 || s.cpResultadoProceso == 20 || s.cpResultadoProceso == 30 || s.cpResultadoProceso == 40) {
                        gvErrores.PerformCallback();
                        TamanioVentana();
                        dialogoErrores.SetSize(myWidth * 0.6, myHeight * 0.6);
                        dialogoErrores.ShowWindow();
                    }
                }
            }
            LoadingPanel.Hide();
        }

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

        function VerEjemplo(ctrl) {
            window.location.href = 'Plantillas/EjemploInventarioSerializadoFinanciero.xlsx';
        }

        function VerEjemplo2(ctrl) {
            window.location.href = 'Plantillas/EjemploInventarioFinanciero.xlsx';
        }

        function VerEjemplo3(ctrl) {
            window.location.href = 'Plantillas/EjemploInventarioProductoFinanciero.xlsx';
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

           function ValidarArchivoTipo(s, e) {
               var validator = document.getElementById('validacion');
               var val = Page_ClientValidate("validacion")
               if (Page_ClientValidate("validacion")) {
                   LoadingPanel.Show();

               }
               else {
                   LoadingPanel.Hide();
               }

           }
      
        function DescargarReporte() {
            window.location.href = 'DescargaDeDocumentos.aspx?id=1';
        }
    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
            <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxRoundPanel ID="rpAdministradorInventario" runat="server" HeaderText="Administración Inventario Financiero"
                        Width="70%" Theme="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td class="field" align="left">Archivo Cargue:
                                        </td>
                                        <td>
                                            <div id="cargarArchivo">

                                                <asp:FileUpload ID="fuArchivo" runat="server" />
                                                <asp:Label ID="lblObligatorio" runat="server" ForeColor="Red" Text="*" Width="50px" />
                                                <div>
                                                    <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                                        CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo" Display="Dynamic"
                                                        ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.xls|.xlsx|.XLSX|.XLS|.Xlsx|.Xls)$" ValidationGroup="validacion"></asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                                        ControlToValidate="fuArchivo" Display="Dynamic" ValidationGroup="validacion" />
                                                </div>
                                                <div class="comentario" style="font-size: small">Cargar archivos con extensión (xls o xlsx)</div>

                                            </div>
                                            <a href="javascript:void(0);" id="VerEjemplo" onclick="javascript:VerEjemplo($(this));">(Ver Ejemplo Doc. Numerada)</a>
                                            <a href="javascript:void(0);" id="VerEjemplo2" onclick="javascript:VerEjemplo2($(this));">(Ver Ejemplo Doc. No Numerada)</a>
                                            <a href="javascript:void(0);" id="A1" onclick="javascript:VerEjemplo3($(this));">(Ver Ejemplo Producto Serializado)</a>
                                        </td>
                                        <td>
                                            <dx:ASPxButton ID="btnUpload" AutoPostBack="false" runat="server" ValidationGroup="validacion" ClientInstanceName="btnUpload" CssClass="submit"
                                                                        Text="Procesar Archivo." Theme="SoftOrange" Width="30px" Height="10px">
                                                                        <ClientSideEvents Click="function (s, e){  ValidarArchivoTipo(s, e);  setTimeout ('LoadingPanel.Hide();', 8000); }" />
                                                                        <Image Url="../images/upload.png"></Image>
                                                                    </dx:ASPxButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field" align="left">Tipo Cargue
                                        </td>
                                        <td>
                                            <dx:ASPxRadioButtonList ID="rblTipoCargue" runat="server" RepeatDirection="Horizontal"
                                                ClientInstanceName="rblTipoCargue" Font-Size="XX-Small" Height="10px">
                                                <ClientSideEvents SelectedIndexChanged="function (s, e){
                                                    var valor =rblTipoCargue.GetValue();
                                                    cpGeneral.PerformCallback('Tipo:' + valor);
                                                }" />
                                                <Items>
                                                    <dx:ListEditItem Text="Doc. Numerada" Value="0" />
                                                    <dx:ListEditItem Text="Doc. No Numerada" Value="1" />
                                                    <dx:ListEditItem Text="Producto Serializado" Value="2" />
                                                </Items>
                                                <Border BorderStyle="None"></Border>
                                                <ValidationSettings CausesValidation="true" ValidationGroup="vgCargue" ErrorDisplayMode="ImageWithTooltip">
                                                    <RequiredField ErrorText="Seleccione el tipo de cargue" IsRequired="true" />
                                                </ValidationSettings>
                                            </dx:ASPxRadioButtonList>
                                        </td>
                                        <td>
                                            <dx:ASPxHyperLink ID="imgDescarga" runat="server" ImageUrl="../images/MSExcel.png" ToolTip="Maestro Productos"
                                                Cursor="pointer">
                                                <ClientSideEvents Click="function (s, e){
                                                    DescargarReporte();
                                                }" />
                                            </dx:ASPxHyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPopupControl ID="pcErrores" runat="server" ClientInstanceName="dialogoErrores" ScrollBars="Auto"
            HeaderText="Resultado Consulta" AllowDragging="true" Width="400px" Height="180px"
            Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" Theme="SoftOrange">
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
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
