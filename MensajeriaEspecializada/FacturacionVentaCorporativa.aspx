<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FacturacionVentaCorporativa.aspx.vb" Inherits="BPColSysOP.FacturacionVentaCorporativa" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx" TagName="EncabezadoSM"
    TagPrefix="esm" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioTipoVentaCorporativa.ascx" TagName="EncabezadoSMTVC"
    TagPrefix="esmtc" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Facturación Venta Corporativa ::</title>

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

        function SetMaxLength(memo, maxLength) {
            if (!memo)
                return;
            if (typeof (maxLength) != "undefined" && maxLength >= 0) {
                memo.maxLength = maxLength;
                memo.maxLengthTimerToken = window.setInterval(function () {
                    var text = memo.GetText();
                    if (text && text.length > memo.maxLength)
                        memo.SetText(text.substr(0, memo.maxLength));
                }, 10);
            } else if (memo.maxLengthTimerToken) {
                window.clearInterval(memo.maxLengthTimerToken);
                delete memo.maxLengthTimerToken;
                delete memo.maxLength;
            }
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function LimpiaFormulario(s, e) {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                EjecutarCallbackGeneral(s, e, 'CancelarRegistro');
            }
        }

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function VerNovedades() {
            TamanioVentana();
            pcNovedades.PerformCallback("Inicial");
            pcNovedades.SetSize(myWidth * 0.7, myHeight * 0.7);
            pcNovedades.ShowWindow();
        }

        function Eliminar(element, key) {
            if (confirm("Esta seguro que desea eliminar el registro seleccionado?")) {
                gvFacturas.PerformCallback('eliminarDetalle:' + key);
            }
        }

        function Procesar() {
            var valor = hdIdServicio.Get("valor");
            if (valor == 0) {
                txtPedidoSAP.SetText(null);
                txtDocumentoSAP.SetText(null);
                gvFacturas.PerformCallback("CargueDocumentos");
            }
            LoadingPanel.Hide();
        }

    </script>

    <style type="text/css">
        .comentario {
        }
    </style>

</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents CallbackComplete="function(s,e){  if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            };}" />
        </dx:ASPxCallback>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="width: 90%; min-width: 500px">
            <table>
                <tr>
                    <td align="left">
                        <a style="color: Black; font-size: 15px; cursor: hand; cursor: pointer;" id="aLecturas"
                            onclick="toggle('divInfo');">
                            <asp:Image ID="imgFiltro" runat="server" ImageUrl="~/images/find.gif" ToolTip="Ver/Ocultar Información Servicio"
                                Width="16px" /></a>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divInfo" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 90%;">
            <asp:PlaceHolder ID="phEncabezado" runat="server"></asp:PlaceHolder>
            &nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral">
            <ClientSideEvents EndCallback="function(s,e){  if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            };}" />
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdServicio" runat ="server" ClientInstanceName ="hdIdServicio"></dx:ASPxHiddenField>
                    <dx:ASPxRoundPanel ID="rpDocumentos" runat="server" HeaderText="Documentos de Facturación"
                        Width="96%" Theme="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td class="field" aling="left">Pedido SAP:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtPedidoSAP" runat="server" NullText="Ingrese número pedido..." AutoPostBack="false"
                                                ClientInstanceName="txtPedidoSAP" Width="250px" TabIndex="1">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                    <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero v&#225;lido"
                                                        ValidationExpression="[1-9][0-9]{0,25}"></RegularExpression>
                                                    <RequiredField IsRequired="True" ErrorText="Ingrese el número de pedido" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class="field" aling="left">Documento SAP:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtDocumentoSAP" runat="server" NullText="Ingrese número documento..." AutoPostBack="false"
                                                ClientInstanceName="txtDocumentoSAP" Width="250px" TabIndex="2">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                                    <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero v&#225;lido"
                                                        ValidationExpression="[1-9][0-9]{0,25}"></RegularExpression>
                                                    <RequiredField IsRequired="True" ErrorText="Ingrese el número de pedido" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Soportes:
                                        </td>
                                        <td>
                                            <asp:FileUpload ID="fuSoportes" runat="server" />
                                            <div style="margin-top: 5px; margin-bottom: 5px;">
                                                <dx:ASPxButton ID="btnSoportes" runat ="server" ClientInstanceName ="tnSoportes" 
                                                    Text ="" Theme ="SoftOrange" AutoPostBack ="true" Width ="30px" Height ="10px"> 
                                                    <ClientSideEvents Click ="function (s, e){
                                                        if (txtPedidoSAP.GetValue() == txtDocumentoSAP.GetValue()) {
                                                            alert('Por favor verifique que el número de pedido SAP sea diferente al número de documento SAP');
                                                            e.processOnServer=false;
                                                        } else{
                                                            e.processOnServer=true;
                                                            LoadingPanel.Show(); 
                                                        }
                                                    }" />
                                                    <Image Url="~/images/upload.png" Height ="5px" Width ="15px"></Image>
                                                </dx:ASPxButton>
                                            </div>
                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Procesar Archivo."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                    </tr>
                                </table>

                                <div style="margin-bottom: 5px; margin-top: 10px;">
                                    <dx:ASPxGridView ID="gvFacturas" runat="server" AutoGenerateColumns="false" ClientInstanceName="gvFacturas"
                                        KeyFieldName="idRegistro" Theme="SoftOrange" Width="100%">
                                        <ClientSideEvents EndCallback="function(s,e){  if (s.cpMensaje != null) {
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            };}" />
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="idRegistro" ShowInCustomizationForm="True" VisibleIndex="1"
                                                Caption="idRegistro" Visible="false">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="nombreArchivo" ShowInCustomizationForm="True"
                                                VisibleIndex="3" Caption="Nombre Archivo">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="pedidoSAP" ShowInCustomizationForm="True"
                                                VisibleIndex="5" Caption="Pedido SAP">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="documentoSAP" ShowInCustomizationForm="True"
                                                VisibleIndex="6" Caption="Documento SAP">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fechaRecepcion" ShowInCustomizationForm="True"
                                                VisibleIndex="7" Caption="Fecha Recepcion">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="tipoDocumento" ShowInCustomizationForm="True"
                                                VisibleIndex="8" Caption="Tipo Documento">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Opciones" ReadOnly="True" ShowInCustomizationForm="True"
                                                VisibleIndex="9">
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/DXEraser16.png"
                                                        Cursor="pointer" ToolTip="Eliminar Detalle" OnInit="Link_Init">
                                                        <ClientSideEvents Click="function(s, e) { Eliminar(this, {0}); 
                                                            }" />
                                                    </dx:ASPxHyperLink>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPager PageSize="20">
                                        </SettingsPager>
                                    </dx:ASPxGridView>
                                </div>
                                <center> <div>
                                    <div style="width: 100px;float:left;">
                                        <dx:ASPxImage ID="imgNov" runat="server" ImageUrl="../images/List.png" ToolTip="Ver Novedades"
                                            TabIndex="6" Cursor="pointer">
                                            <ClientSideEvents Click="function (s, e){
                                                VerNovedades();
                                            }" />
                                        </dx:ASPxImage><br />
                                        <dx:ASPxLabel ID="lblNov" runat="server" Text="Adicionar Novedades."
                                            CssClass="comentario" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                        </dx:ASPxLabel>
                                    </div>

                                    <div style="width: 100px; float:left;" >
                                        <dx:ASPxImage ID="imgFacturar" runat="server" ImageUrl="~/images/Facturar.jpg" ToolTip="Facturar" 
                                            TabIndex="7" Cursor="pointer" Height="27px">
                                            <ClientSideEvents Click="function(s, e){EjecutarCallbackGeneral(s,e,'Registrar');                                                            
                                                }" />
                                        </dx:ASPxImage><br />
                                        <dx:ASPxLabel ID="lblFac" runat="server" Text="Facturar"
                                            CssClass="comentario" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True" 
                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                        </dx:ASPxLabel>
                                    </div>
                                </div></center>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <dx:ASPxPopupControl ID="pcNovedades" runat="server" ClientInstanceName="pcNovedades" ScrollBars="Auto"
                        HeaderText="Administrador Novedades" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" Theme="SoftOrange">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <dx:ASPxRoundPanel ID="rpNovedades" runat="server" HeaderText="Visualización y Registro Novedades" Theme="SoftOrange">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table>
                                                <tr>
                                                    <td class="field" align="left">Tipo Novedad:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cmbNovedad" runat="server" ClientInstanceName="cmbNovedad" Width="250" ValueType="System.Int32"
                                                            IncrementalFilteringMode="Contains">
                                                            <Columns>
                                                                <dx:ListBoxColumn FieldName="descripcion" Width="300px" Caption="Novedad" />
                                                            </Columns>
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgNovedad">
                                                                <RequiredField ErrorText="La novedad es requerida" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                        <div>
                                                            <dx:ASPxLabel ID="lbNovedad" runat="server" Text="Digite parte de la novedad."
                                                                CssClass="comentario" Width="270px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field" align="left">Comentario General:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxMemo ID="meJustificacion" runat="server" Height="71px" Width="350px" NullText="Ingrese el comentario..."
                                                            ClientInstanceName="memo">
                                                            <ClientSideEvents KeyUp="function(s, e) {return SetMaxLength(memo,150); }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgNovedad">
                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                                <RequiredField ErrorText="El comentario es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxMemo>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxImage ID="imgNovedad" runat="server" ImageUrl="../images/DxAdd32.png" ToolTip="Agregar Serial"
                                                            Cursor="pointer">
                                                            <ClientSideEvents Click="function (s, e){
                                                                if(ASPxClientEdit.ValidateGroup('vgNovedad')){
                                                                   pcNovedades.PerformCallback('Registra'); 
                                                                }
                                                            }" />
                                                        </dx:ASPxImage>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <dx:ASPxGridView ID="gvNovedad" runat="server" AutoGenerateColumns="false" ClientInstanceName="gvNovedad"
                                                            Theme="SoftOrange">
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True" VisibleIndex="1"
                                                                    Caption="Tipo de Novedad">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="UsuarioRegistra" ShowInCustomizationForm="True"
                                                                    VisibleIndex="2" Caption="Registrada Por">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="FechaRegistro" ShowInCustomizationForm="True"
                                                                    VisibleIndex="3" Caption="Fecha de Registro">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True"
                                                                    VisibleIndex="4" Caption="Comentario General">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <SettingsPager PageSize="20">
                                                            </SettingsPager>
                                                        </dx:ASPxGridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
