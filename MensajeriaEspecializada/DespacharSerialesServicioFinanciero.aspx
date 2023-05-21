﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DespacharSerialesServicioFinanciero.aspx.vb" Inherits="BPColSysOP.DespacharSerialesServicioFinanciero" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx" TagName="EncabezadoSM"
    TagPrefix="esm" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx" TagName="EncabezadoSMTV"
    TagPrefix="esmtv" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Despacho Servicios Financieros </title>
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

        function SeleccionarODesmarcarTodo(ctrl, targetName) {
            $('#formPrincipal input[type="checkbox"]').each(function () {
                if (!$(this).attr("disabled"))
                    $(this).attr("checked", ctrl.checked);
            });
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                loadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
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

        function VerSeriales() {
            TamanioVentana();
            pcSeriales.PerformCallback("VerSerial");
            pcSeriales.SetSize(myWidth * 0.25, myHeight * 0.5);
            pcSeriales.ShowWindow();
        }

        function VerNovedades() {
            TamanioVentana();
            pcNovedades.PerformCallback("Inicial");
            pcNovedades.SetSize(myWidth * 0.7, myHeight * 0.7);
            pcNovedades.ShowWindow();
        }

        function DeshabilitarSerial(s)
        {
            var producto = cmbMaterial.GetValue().toString();
            if (producto == 'NS0000' || producto == 'NS0001')
            {
                txtSerial.SetEnabled(false);
            }
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
            <ClientSideEvents CallbackComplete="function(s, e) {
            $('#divEncabezado').html(s.cpMensaje);
            loadingPanel.Hide();
        }" />
        </dx:ASPxCallback>
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <asp:PlaceHolder ID="phEncabezado" runat="server"></asp:PlaceHolder>
        &nbsp;&nbsp;&nbsp;&nbsp;
    <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral">
        <ClientSideEvents EndCallback="function(s, e) { 
      
        $('#divEncabezado').html(s.cpMensaje);
       
        loadingPanel.Hide();
    }" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpLectura" runat="server" HeaderText="Lectura Seriales"
                    Width="60%" Theme="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table>
                                <tr>
                                    <td rowspan="6">
                                        <dx:ASPxGridView ID="gvListaReferencias" runat="server" AutoGenerateColumns="False"
                                            Width="100%" ClientInstanceName="grid" Theme="SoftOrange" KeyFieldName="IdMaterialServicio">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="Material" ShowInCustomizationForm="True" VisibleIndex="1"
                                                    Caption="Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DescripcionMaterial" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" Caption="Descripción Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Cantidad" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" Caption="Cantidad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CantidadLeida" ShowInCustomizationForm="True"
                                                    VisibleIndex="3" Caption="Cantidad leida">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Caption="No serializado" VisibleIndex="4">
                                                    <HeaderCaptionTemplate>
                                                        <asp:CheckBox ID="chkSeleccionarTodo" runat="server" AutoPostBack="false" onclick="SeleccionarODesmarcarTodo(this,'chkMaterial');" />
                                                        <asp:Panel ID="pnlMaterial" runat="server" Style="display: inline">
                                                            <dx:ASPxImage ID="imgMaterial" runat="server" ImageUrl="../images/DxMarker.png"
                                                                ClientInstanceName="imgMaterial" ToolTip="No Serializado" Cursor="pointer">
                                                            </dx:ASPxImage>
                                                        </asp:Panel>
                                                    </HeaderCaptionTemplate>
                                                    <DataItemTemplate>
                                                        <asp:CheckBox ID="chkMaterial" runat="server" OnInit="Chk_Init" CssClass="{0}" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior AllowSelectByRowClick="true" />
                                            <SettingsPager PageSize="5">
                                            </SettingsPager>
                                        </dx:ASPxGridView>
                                    </td>
                                    <td class="field" align="left">Seleccione Material:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbMaterial" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbMaterial" DropDownStyle="DropDownList" TabIndex="1">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="DescripcionMaterial" Width="250px" Caption="Descripción" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAtender">
                                                <RequiredField IsRequired="True" ErrorText="Ingrese un material para procesar" />
                                            </ValidationSettings>
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) { DeshabilitarSerial(s); }" /> 
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td>
                                        <dx:ASPxRadioButtonList ID="rblTipo" runat="server" RepeatDirection="Horizontal"
                                            ClientInstanceName="rblTipo" Font-Size="XX-Small">
                                            <Items>
                                                <dx:ListEditItem Text="Registro" Value="1" Selected="true" />
                                                <dx:ListEditItem Text="Desvincular" Value="0" />
                                            </Items>
                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxRadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field" align="left">Dispare Serial:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtSerial" runat="server" NullText="Ingrese Serial..." AutoPostBack="false"
                                            ClientInstanceName="txtSerial" Width="250px" TabIndex="2">
                                            <ClientSideEvents KeyDown="function (s, e) {
                                                if(ASPxClientEdit.ValidateGroup('vgAtender')){
                                                    if(e.htmlEvent.keyCode == 13) {
                                                var valor 
                                                valor =rblTipo.GetValue();
                                                if (valor ==1){
                                                    EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                }else {
                                                    if(confirm('Esta seguro de desvincular el serial?')){
                                                        EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                        }
                                                    }
                                                      
                                                     } 
                                                 } 
                                            }" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAtender">
                                                <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero de serial v&#225;lido"
                                                    ValidationExpression="[0-9]{0,25}"></RegularExpression>
                                                <RequiredField IsRequired="True" ErrorText="Ingrese un serial para procesar" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <table>
                                            <tr>
                                                <td align="left">
                                                    <dx:ASPxImage ID="imgAgregar" runat="server" ImageUrl="../images/DxAdd32.png" ToolTip="Agregar Serial"
                                                        TabIndex="3" Cursor="pointer">
                                                        <ClientSideEvents Click="function (s, e){
                                                        if(ASPxClientEdit.ValidateGroup('vgAtender')){
                                                                    var valor 
                                                valor =rblTipo.GetValue();
                                                if (valor ==1){
                                                    EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                }else {
                                                    if(confirm('Esta seguro de desvincular el serial?')){
                                                        EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                        }
                                                    }
                                                            }
                                                    }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblComentario" runat="server" Text="Agregar Serial."
                                                            CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False"
                                                            Height="16px">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </td>
                                                <td align="left">
                                                    <dx:ASPxImage ID="imgVer" runat="server" ImageUrl="../images/lectora.png" ToolTip="Ver Seriales"
                                                        TabIndex="3" Cursor="pointer">
                                                        <ClientSideEvents Click="function (s, e){
                                                        VerSeriales();
                                                    }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Ver Seriales."
                                                            CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </td>
                                                <td align="left">
                                                    <dx:ASPxImage ID="imgNov" runat="server" ImageUrl="../images/List.png" ToolTip="Ver Novedades"
                                                        TabIndex="3" Cursor="pointer">
                                                        <ClientSideEvents Click="function (s, e){
                                                        VerNovedades();
                                                    }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblNov" runat="server" Text="Ver Novedades."
                                                            CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </td>
                                                <td id="tdCierra" runat="server" visible="false">
                                                    <dx:ASPxImage ID="imgCerrar" runat="server" ImageUrl="../images/DxConfirm32.png" ToolTip="Cerrar Despacho"
                                                        TabIndex="4" Cursor="pointer">
                                                        <ClientSideEvents Click="function (s, e){
                                                        EjecutarCallbackGeneral(s, e, 'Cerrar');
                                                    }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblCerrar" runat="server" Text="Cerrar Despacho."
                                                            CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                            Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <%--<dx:ASPxButton ID="btnAtender" runat ="server" ClientInstanceName ="btnAtender" AutoPostBack ="false" ClientVisible ="false">
                                            <ClientSideEvents Click ="function (s, e){
                                                var valor 
                                                valor =rblTipo.GetValue();
                                                if (valor ==1){
                                                    EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                }else {
                                                    if(confirm('Esta seguro de desvincular el serial?')){
                                                        EjecutarCallbackGeneral(s, e, 'Registrar',valor);
                                                        }
                                                    }
                                            }" />
                                        </dx:ASPxButton>--%>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
                <dx:ASPxPopupControl ID="pcSeriales" runat="server" ClientInstanceName="pcSeriales" ScrollBars="Auto"
                    HeaderText="Seriales Leidos" AllowDragging="true" Width="400px" Height="180px"
                    Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" Theme="SoftOrange">
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <dx:ASPxRoundPanel ID="rpSeriales" runat="server" HeaderText="Seriales Leídos" Theme="SoftOrange">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxGridView ID="gvSeriales" runat="server" AutoGenerateColumns="false" ClientInstanceName="gvSeriales"
                                            Theme="SoftOrange">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="Material" ShowInCustomizationForm="True" VisibleIndex="1"
                                                    Caption="Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Serial" ShowInCustomizationForm="True"
                                                    VisibleIndex="3" Caption="Serial">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                            <SettingsPager PageSize="20">
                                            </SettingsPager>
                                        </dx:ASPxGridView>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
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
                                                <td colspan="4">
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
        <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
