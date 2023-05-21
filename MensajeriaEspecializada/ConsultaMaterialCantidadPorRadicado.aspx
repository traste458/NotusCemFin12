<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaMaterialCantidadPorRadicado.aspx.vb"
    Inherits="BPColSysOP.ConsultaMaterialCantidadPorRadicado" %>

<%@ Register TagPrefix="uc1" TagName="EncabezadoPagina" Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script language="javascript" type="text/javascript">
        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }


        function MaxLongitud(text, len) {
            var maxlength = new Number(len);
            if (text.value.length > maxlength) {
                text.value = text.value.substring(0, maxlength);
            }
        }

        function ValidaNumerodeEntero(s, e) {
            if (e.value == null) {
                s.SetIsValid(false);
                s.SetErrorText("No ingreso ningún Radicado!");
                if (e.htmlEvent != 'undefined')
                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                return (false);
            }
            else {
                var name = e.value.toString().replace(/\r\n|\n|\r/g, '');
                if (/^[0-9]+$/.test(name)) {
                    s.SetIsValid(true);
                    return (true);
                } else {
                    s.SetIsValid(false);
                    s.SetErrorText("Existen Carácter no válidos solo acepta numeros!");
                    if (e.htmlEvent != 'undefined')
                        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                    return (false);
                }
            }
        }
        function OnKeyPress(s, e) {
            if ((e.htmlEvent.keyCode > 47 && e.htmlEvent.keyCode < 58) || e.htmlEvent.keyCode == 46 || e.htmlEvent.keyCode == 13) {
                s.SetIsValid(true);
            } else {
                s.SetIsValid(false);
                s.SetErrorText("Carácter no válido!");
                if (e.htmlEvent != 'undefined')
                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }
        function actualizar() {
            window.gvDatosResultado.DataBinding();
        }
    </script>
</head>
<body>
    <form id="formPrincipal" runat="server" whidth="60%">
    <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="cbPrincipal">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div>
        <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
    </div>
    <div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" Width="60%">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxFormLayout ID="Cplayout" runat="server" RequiredMarkDisplayMode="Auto" Styles-LayoutGroupBox-Caption-CssClass="layoutGroupBoxCaption"
                        AlignItemCaptionsInAllGroups="true" Width="100%">
                        <Items>
                            <dx:LayoutGroup ShowCaption="False" GroupBoxDecoration="HeadingLine" SettingsItemCaptions-HorizontalAlign="Right">
                                <Items>
                                    <dx:LayoutItem Caption="&nbsp;">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <table class="tablaGris" style="width: auto;">
                                                    <tr>
                                                        <th class="thGris" colspan="2" style="text-align: center">
                                                            FILTROS DE BÚSQUEDA
                                                        </th>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" class="field">
                                                            Radicad(os):
                                                        </td>
                                                        <td align="left">
                                                            <dx:ASPxMemo ID="MemoRadicado" ClientInstanceName="MemoRadicado" runat="server" Height="100px"
                                                                Width="190px" onkeypress="javascript:return ValidaNumero(event);" NullText="Ingrese los Radicados separados por saltos de línea Ejemplo:       6732781             6736838                    6736848                    6736839"
                                                                ValidateRequestMode="Enabled">
                                                                <ClientSideEvents Validation="ValidaNumerodeEntero"></ClientSideEvents>
                                                                <ValidationSettings SetFocusOnError="True" ErrorText="Existen Carácter no válidos solo acepta numeros!"
                                                                    ErrorDisplayMode="ImageWithText" ValidationGroup="VgConsultar">
                                                                    <RequiredField IsRequired="True" ErrorText="No ingreso ningún Radicado!!"></RequiredField>
                                                                </ValidationSettings>
                                                            </dx:ASPxMemo>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" colspan="2">
                                                            <div style="float: left; margin-top: 20px;">
                                                                <dx:ASPxButton ID="btConsultar" ClientInstanceName="btConsultar" runat="server" Text="Consultar Radicados"
                                                                    Style="display: inline!important;" AutoPostBack="false" ValidationGroup="VgConsultar">
                                                                    <Image Url="~/images/view.png">
                                                                    </Image>
                                                                    <ClientSideEvents Click="function(s, e) { gvDatosResultado.PerformCallback('Filtro'); cbPrincipal.PerformCallback(); LoadingPanel.Show();}">
                                                                    </ClientSideEvents>
                                                                </dx:ASPxButton>
                                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                                <dx:ASPxButton ID="lbLimpiar" runat="server" Text="Limpiar Filtro" Style="display: inline!important;"
                                                                    AutoPostBack="false">
                                                                    <Image Url="~/images/unfunnel.png">
                                                                    </Image>
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <HelpTextSettings Position="Top"></HelpTextSettings>
                                    </dx:LayoutItem>
                                </Items>
                                <SettingsItemCaptions HorizontalAlign="Right"></SettingsItemCaptions>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup GroupBoxDecoration="HeadingLine" Caption="Resultado de la Busqueda">
                                <Items>
                                    <dx:LayoutItem Caption="&nbsp;">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <table cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <dx:ASPxButton runat="server" AutoPostBack="False" Text="Exportar Resultado" ValidationGroup="VgConsultar"
                                                                ID="btnExportar" Style="display: inline!important;">
                                                                <ClientSideEvents Click="function(s, e) {cbPrincipal.PerformCallback();LoadingPanel.Show();}">
                                                                </ClientSideEvents>
                                                                <Image Url="~/images/Excel.gif">
                                                                </Image>
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                        <HelpTextSettings Position="Top"></HelpTextSettings>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="&nbsp;">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvDatosResultado" runat="server" ClientInstanceName="gvDatosResultado"
                                                    KeyFieldName="numeroRadicado" AutoGenerateColumns="False" Font-Size="Small" EnableCallBacks="False">
                                                    <Settings ShowFooter="True" ShowHeaderFilterButton="true" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="numeroRadicado" ShowInCustomizationForm="True"
                                                            Caption="Numero Radicado" VisibleIndex="1">
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="material" ShowInCustomizationForm="True" Caption="Material"
                                                            VisibleIndex="2">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="subproducto" ShowInCustomizationForm="True"
                                                            Caption="Descripci&#243;n Material" VisibleIndex="3">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="cantidad" ShowInCustomizationForm="True" ReadOnly="True"
                                                            Caption="Cantidad" VisibleIndex="4">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="EstadoRadicado" ShowInCustomizationForm="True"
                                                            Caption="Estado Radicado" VisibleIndex="5">
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager PageSize="50" AlwaysShowPager="True">
                                                    </SettingsPager>
                                                </dx:ASPxGridView>
                                                <dx:ASPxGridViewExporter runat="server" ID="exporter" GridViewID="gvDatosResultado">
                                                </dx:ASPxGridViewExporter>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                        <Styles>
                            <LayoutGroupBox>
                                <Caption CssClass="layoutGroupBoxCaption">
                                </Caption>
                            </LayoutGroupBox>
                        </Styles>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </div>
    </form>
</body>
</html>
