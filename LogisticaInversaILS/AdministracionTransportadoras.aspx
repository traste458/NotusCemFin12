<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionTransportadoras.aspx.vb"
    Inherits="BPColSysOP.AdministracionTransportadoras" Culture="es-CO" UICulture="es-CO" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"  
  
<html>
<head runat="server">
    <title>Administración de Transportadoras</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function CheckIfCheckBoxListIsChecked(source, args) {
            var chkList = document.getElementById('<%= chblProductosCombo.ClientID %>');
            var chk = chkList.getElementsByTagName("input");
            var cantidadChk = 0
            for (var i = 0; i < chk.length; i++) {
                if (chk[i].checked) {
                    cantidadChk = cantidadChk + 1;
                }
            }
            //document.write(cantidadChk);
            if (cantidadChk >= 2) {
                args.IsValid = true;
                return;
            }
            args.IsValid = false;
            return;
        }

        function validaCheckBoxListDetalle(source, args) {
            var chkList = document.getElementById('<%= chblComboDetalle.ClientID %>');
            var chk = chkList.getElementsByTagName("input");
            var cantidadChk = 0
            for (var i = 0; i < chk.length; i++) {
                if (chk[i].checked) {
                    cantidadChk = cantidadChk + 1;
                }
            }
            //document.write(cantidadChk);
            if (cantidadChk >= 2) {
                args.IsValid = true;
                return;
            }
            args.IsValid = false;
            return;
        }
        
    </script>
</head>
<body>
    <form id="frmAdministracionTransportadora" runat="server">
    <div>
        <asp:ScriptManager ID="smAjaxManager" runat="server" EnableScriptGlobalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upGeneral" runat="server" RenderMode="Inline">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="epNotificar" runat="server" />
                <uc2:ModalProgress ID="mpEspera" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div>
        <asp:Panel ID="pnlInfoGeneral" runat="server">
            <table class="tablaGris">
                <tr>
                    <th colspan="2">
                        Datos de la Transportadora
                    </th>
                </tr>
                <tr>
                    <td class="field">
                        Nombre Trasportadora:
                    </td>
                    <td>
                        <asp:TextBox ID="txtNombre" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                            Display="Dynamic" ValidationGroup="crear" ErrorMessage="&lt;br&gt; Debe proporcionar un nombre de transportadora"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <center>
                            <asp:Button ID="btnCrear" runat="server" Text="Crear" CssClass="submit" ValidationGroup="crear" />
                        </center>
                    </td>
                </tr>
            </table>
            <br />
            <asp:LinkButton ID="LnkBtnTipoTarifa" runat="server"><img alt="*" 
                src="../images/engranaje.jpg" />&nbsp;Creación Tipo Tarifa</asp:LinkButton>
            <br />
        </asp:Panel>
        <%------------------------------------------------------------------------------------------------------------------------------%>
        <h3>
            Transportadoras Registradas</h3>
        <asp:GridView ID="gvTransportadoras" runat="server" AutoGenerateColumns="False" CssClass="tablaGris"
            DataKeyNames="idTransportadora" EmptyDataText="No hay registros de datos para mostrar."
            BorderStyle="Double">
            <Columns>
                <asp:BoundField DataField="transportadora" HeaderText="Nombre Transportadora">
                    <HeaderStyle HorizontalAlign="Center" Width="250px"></HeaderStyle>
                </asp:BoundField>
                <asp:TemplateField HeaderText="Editar Transportadora" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkOpciones" runat="server" OnClientClick="$find(ModalProgress).show()"
                            CommandArgument='<%# Bind("idTransportadora") %>' CommandName="detalleTransportadora"
                            ToolTip="Detalle Transportadora"><img alt = ""
                            src="../images/edit.gif" /></asp:LinkButton>
                    </ItemTemplate>
                    <FooterStyle Font-Size="XX-Small"></FooterStyle>
                    <ItemStyle HorizontalAlign="center" Width="80px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Editar Tarifas" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkTarifas" runat="server" OnClientClick="$find(ModalProgress).show()"
                            CommandArgument='<%# Bind("idTransportadora") %>' CommandName="detalleTarifa"
                            ToolTip="Detalle Tarifa Transportadora"><img alt = "" 
                            src="../images/engranaje.jpg" /></asp:LinkButton>
                    </ItemTemplate>
                    <FooterStyle Font-Size="XX-Small"></FooterStyle>
                    <ItemStyle HorizontalAlign="center" Width="80px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Editar Combos" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkCombo" runat="server" OnClientClick="$find(ModalProgress).show()"
                            CommandArgument='<%# Bind("idTransportadora") %>' CommandName="detalleCombo"
                            ToolTip="Detalle Combo Transportadora"><img alt = ""
                            src="../images/admin.png" /></asp:LinkButton>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="center" Width="80px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Editar Rango" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkRango" runat="server" OnClientClick="$find(ModalProgress).show()"
                            CommandArgument='<%# Bind("idTransportadora") %>' CommandName="detalleRango"
                            ToolTip="Detalle Rango Transportadora"><img alt = ""
                            src="../images/search.png" /></asp:LinkButton>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="center" Width="80px" />
                </asp:TemplateField>
            </Columns>
            <HeaderStyle BorderStyle="Solid" />
            <EditRowStyle HorizontalAlign="Right" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="alternatingRow" BackColor="#E2D8E6" BorderStyle="Solid" />
        </asp:GridView>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgDetalle" ControlSkinID="None" HeaderHtml="&nbsp;&nbsp;Detalle de Transportadora"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="330px" Height="100px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <div id="div1" visible="false">
                    <div style="border-style: none; border-width: inherit; border-color: #F5F5F5; width: 330px;
                        background-color: #F5F5F5;" class="izquierda margenColumnas search">
                        <asp:Panel ID="pnlPropiedades" runat="server" Height="232px" Width="325px" HorizontalAlign="Left"
                            Style="overflow: auto;" ScrollBars="None" BorderStyle="Double" Direction="NotSet">
                            <table class="tablaGris" width="315px">
                                <tr>
                                    <th colspan="2" style="font-size: small">
                                        Propiedades
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Maneja POS:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbPOS" runat="server" AutoPostBack="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Usa Guia:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbGuia" runat="server" AutoPostBack="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Usa Precinto:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbPrecinto" runat="server" AutoPostBack="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Hace Logistica Inversa:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbLogisticaInversa" runat="server" AutoPostBack="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Carga Por Importación:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbImportacion" runat="server" AutoPostBack="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Aplica Tipo de Producto:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbTipoProducto" runat="server" AutoPostBack="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Aplica Para despachos Nacionales:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbNacionales" runat="server" AutoPostBack="true" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                    <div class="izquierda search " style="border-style: none; border-width: inherit;
                        border-color: #F5F5F5; width: 330px; background-color: #F5F5F5;">
                        <asp:Panel ID="pnlTarifaTransportadora" runat="server" Height="232px" Width="370px"
                            Visible="false" HorizontalAlign="center" Style="overflow: auto;" ScrollBars="Auto"
                            BorderStyle="Double" Direction="NotSet">
                            <table class="tablaGris">
                                <tr>
                                    <th colspan="2" style="font-size: small">
                                        Datos de Tarifa Transportadora
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Tipo servicio:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlServicio" runat="server">
                                        </asp:DropDownList>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:RequiredFieldValidator ID="rfvTipo" runat="server" ControlToValidate="ddlServicio"
                                            Display="Dynamic" ValidationGroup="vgDetalle" InitialValue="0" Font-Size="XX-Small"
                                            ErrorMessage="&lt;br&gt; Debe seleccionar el Tipo de Servicio"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Valor Manejo:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtValor" runat="server" Width="100px" MaxLength="9" CausesValidation="True"></asp:TextBox>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:Label ID="Label1" runat="server" Text="(valor decimal Ej: 0,50)" Font-Size="XX-Small"
                                            ForeColor="Red" Visible="true"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvValorTarifa" runat="server" ControlToValidate="txtValor"
                                            Display="Dynamic" ValidationGroup="vgDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar el Valor de Manejo"></asp:RequiredFieldValidator>
                                        <cc1:FilteredTextBoxExtender ID="ftbPeso" runat="server" FilterType="Numbers,Custom"
                                            TargetControlID="txtValor" ValidChars=",">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Tarifa Minima:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTarifa" runat="server" Width="100" MaxLength="9"></asp:TextBox>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:RequiredFieldValidator ID="rfvTarifaTransporte" runat="server" ControlToValidate="txtTarifa"
                                            Display="Dynamic" ValidationGroup="vgDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la tarifa minima"></asp:RequiredFieldValidator>
                                        <cc1:FilteredTextBoxExtender ID="ftbTarifa" runat="server" FilterType="Numbers,Custom"
                                            TargetControlID="txtTarifa" ValidChars=",">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Tipo Tarifa:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlTarifa" runat="server" AutoPostBack="true">
                                        </asp:DropDownList>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:RequiredFieldValidator ID="rfvTarifa" runat="server" ControlToValidate="ddlTarifa"
                                            Display="Dynamic" ValidationGroup="vgDetalle" InitialValue="0" Font-Size="XX-Small"
                                            ErrorMessage="Debe seleccionar el Tipo de Tarifa"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Tipo Producto:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlProducto" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Maneja Combos:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbCombo" runat="server" AutoPostBack="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Maneja Rangos:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chbRango" runat="server" AutoPostBack="true" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                </div>
                <table>
                    <tr>
                        <th colspan="2">
                            <asp:Button ID="btnGrabar" runat="server" Text="Grabar" CssClass="submit" Enabled="true"
                                ValidationGroup="vgDetalle" />
                        </th>
                    </tr>
                    <tr>
                        <th colspan="2">
                            <asp:Label ID="LblErrorDetalle" runat="server" Text="" Font-Size="X-Small" ForeColor="Red"></asp:Label>
                        </th>
                    </tr>
                </table>
                <div id="divZona1" visible="false">
                    <div style="border-style: none; border-width: inherit; border-color: #F5F5F5; width: 330px;
                        background-color: #F5F5F5;" class="izquierda margenColumnas search">
                        <asp:Panel ID="pnlCombo" runat="server" Height="210px" Width="325px" Style="overflow: auto;"
                            Font-Size="XX-Small" ScrollBars="Auto" BorderStyle="Double" Direction="NotSet"
                            Visible="false" HorizontalAlign="Left">
                            <table class="tablaGris" width="300px">
                                <tr>
                                    <th colspan="2" style="font-size: small">
                                        Datos de los combos
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Productos:
                                    </td>
                                    <td align="left">
                                        <asp:CheckBoxList ID="chblProductosCombo" runat="server" CellPadding="5" TextAlign="Right"
                                            CellSpacing="5" RepeatDirection="Vertical" RepeatLayout="Flow" Font-Bold="false"
                                            Font-Size="XX-Small">
                                        </asp:CheckBoxList>
                                        <span style="color: Red; font-size: small">*</span>
                                    </td>
                                    <tr>
                                        <td class="field">
                                        </td>
                                        <td>
                                            <asp:CustomValidator ID="cvProductosCombo" runat="server" ClientValidationFunction="CheckIfCheckBoxListIsChecked"
                                                ErrorMessage="Seleccione al menos dos elemento" Font-Size="XX-Small" ValidationGroup="vgDetalle"
                                                Display="Dynamic"></asp:CustomValidator>
                                        </td>
                                    </tr>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                    <div class="izquierda search " style="border-style: none; border-width: inherit;
                        border-color: #F5F5F5; width: 330px; background-color: #F5F5F5;">
                        <asp:Panel ID="pnlRango" runat="server" HorizontalAlign="Left" Height="210px" Width="325px"
                            Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double" Direction="NotSet"
                            Visible="false">
                            <table class="tablaGris" width="315px">
                                <tr>
                                    <th colspan="2" style="font-size: small">
                                        Datos de los Rangos
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Cantidad Inicial:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCntInicial" runat="server" Width="200px" MaxLength="9"></asp:TextBox>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:RequiredFieldValidator ID="rfvCntInicial" runat="server" ControlToValidate="txtCntInicial"
                                            Display="Dynamic" ValidationGroup="vgDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la cantidad Inicial"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Cantidad Final:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCntFinal" runat="server" Width="200px" MaxLength="9"></asp:TextBox>
                                        <span style="color: Red; font-size: small">*</span>
                                        <asp:RequiredFieldValidator ID="rfvCntFinal" runat="server" ControlToValidate="txtCntFinal"
                                            Display="Dynamic" ValidationGroup="vgDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la cantidad Final"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                </div>
                <br />
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgDetalleTransportadora" ControlSkinID="None" HeaderHtml="&nbsp;Detalle Transportadora"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="330px" Height="100px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlDetalleTransportadora" runat="server" Height="232px" Width="325px"
                    HorizontalAlign="Left" Style="overflow: auto;" ScrollBars="None" BorderStyle="Double"
                    Direction="NotSet">
                    <table class="tablaGris" width="315px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                Propiedades
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Maneja POS:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbPosDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Usa Guia:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbGuiaDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Usa Precinto:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbPrecintoDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Hace Logistica Inversa:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbLogisticaDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Carga Por Importación:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbImportacionDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Aplica Tipo de Producto:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbTipoProductoDetalle" runat="server" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Aplica Para despachos Nacionales:
                            </td>
                            <td>
                                <asp:CheckBox ID="chbNacionalesDetalle" runat="server" AutoPostBack="False" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Button ID="BtnGrabarDetalleTransportadora" runat="server" Text="Grabar Propiedades"
                                    CssClass="submit" Enabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label ID="LblErrorTransportadoraDetalle" runat="server" Text="Debe Seleccionar Minimo una Propiedad"
                                    Font-Size="X-Small" ForeColor="Red" Visible="false"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgDetalleTarifa" ControlSkinID="None" HeaderHtml="&nbsp;Detalle de Tarifa Transportadora"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="750px" Height="500px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlDetalleTarifa" runat="server" Height="208px" Width="355" BackColor="#eeeeee"
                    Visible="false" HorizontalAlign="Left" Style="overflow: auto;" ScrollBars="Auto"
                    BorderStyle="Double" Direction="NotSet">
                    <table class="tablaGris">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                Datos de Tarifa Transportadora
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Tipo servicio:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlServicioDetalle" runat="server">
                                </asp:DropDownList>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvServicioDetalle" runat="server" ControlToValidate="ddlServicioDetalle"
                                    Display="Dynamic" ValidationGroup="vgTarifaDetalle" InitialValue="0" Font-Size="XX-Small"
                                    ErrorMessage="&lt;br&gt; Debe seleccionar el Tipo de Servicio"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Valor Manejo:
                            </td>
                            <td>
                                <asp:TextBox ID="txtValorDetalle" runat="server" Width="100px" MaxLength="9" CausesValidation="True"></asp:TextBox>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:Label ID="lblValorDetalle" runat="server" Text="(valor decimal Ej: 0,50)" Font-Size="XX-Small"
                                    ForeColor="Red" Visible="true"></asp:Label>
                                <asp:RequiredFieldValidator ID="rfvValorDetalle" runat="server" ControlToValidate="txtValorDetalle"
                                    Display="Dynamic" ValidationGroup="vgTarifaDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar el Valor de Manejo"></asp:RequiredFieldValidator>
                                <cc1:FilteredTextBoxExtender ID="ftbValorDetalle" runat="server" FilterType="Numbers,Custom"
                                    TargetControlID="txtValorDetalle" ValidChars=",">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Tarifa Minima:
                            </td>
                            <td>
                                <asp:TextBox ID="txtTarifaDetalle" runat="server" Width="100" MaxLength="9"></asp:TextBox>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvtxtTarifaDetalle" runat="server" ControlToValidate="txtTarifaDetalle"
                                    Display="Dynamic" ValidationGroup="vgTarifaDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la tarifa minima"></asp:RequiredFieldValidator>
                                <cc1:FilteredTextBoxExtender ID="ftbTarifaDetalle" runat="server" FilterType="Numbers,Custom"
                                    TargetControlID="txtTarifaDetalle" ValidChars=",">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Tipo Tarifa:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlTarifaDetalle" runat="server" AutoPostBack="true">
                                </asp:DropDownList>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvddlTarifaDetalle" runat="server" ControlToValidate="ddlTarifaDetalle"
                                    Display="Dynamic" ValidationGroup="vgTarifaDetalle" InitialValue="0" Font-Size="XX-Small"
                                    ErrorMessage="Debe seleccionar el Tipo de Tarifa"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Tipo Producto:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlProductoDetalle" runat="server">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Canal de Distribución:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlCanal" runat="server">
                                </asp:DropDownList>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvddlCanal" runat="server" ControlToValidate="ddlCanal"
                                    Display="Dynamic" ValidationGroup="vgTarifaDetalle" InitialValue="0" Font-Size="XX-Small"
                                    ErrorMessage="&lt;br&gt; Debe seleccionar el Tipo de Canal"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <br />
                                <asp:Button ID="btnGrabarDetalleTarifa" runat="server" Text="Grabar Tarifas" CssClass="submit"
                                    Enabled="true" ValidationGroup="vgTarifaDetalle" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Label ID="LblErrorTarifaDetalle" runat="server" Text="" Font-Size="X-Small"
                    ForeColor="Red" Visible="true"></asp:Label>
                <br />
                <h3>
                    Tarifas Registradas</h3>
                <div style="overflow: auto; width: 700px; height: 240px">
                    <asp:GridView ID="gvDetalleTarifa" runat="server" AutoGenerateColumns="False" CssClass="tablaGris"
                        DataKeyNames="idTransportadora" EmptyDataText="No hay tarifas registradas para mostrar..."
                        BorderStyle="Double" AlternatingRowStyle-Wrap="False" EditRowStyle-Wrap="False"
                        RowStyle-Wrap="False">
                        <Columns>
                            <asp:BoundField DataField="tipoServicio" HeaderText="Tipo Servicio" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="valordeManejo" HeaderText="Valor de Manejo" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="tarifaMinima" HeaderText="Tarifa Minima" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="tipoProducto" HeaderText="Tipo Producto" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="tipoTarifa" HeaderText="Tipo Tarifa" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="canalDistribucion" HeaderText="Canal" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="250px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Opciones" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkOpciones" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idTarifa") %>' CommandName="EditarTarifa" ToolTip="Editar Tarifa"><img alt = ""
                                            src="../images/edit.gif" /></asp:LinkButton>
                                    <asp:LinkButton ID="lnkTarifas" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idTarifa") %>' CommandName="BorrarTarifa" ToolTip="Borrar Tarifa"><img alt = "" 
                                            src="../images/delete.gif" /></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" Width="80px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BorderStyle="Solid" />
                        <EditRowStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <AlternatingRowStyle CssClass="alternatingRow" BackColor="#FFFFFF" BorderStyle="Solid" />
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgDetalleCombo" ControlSkinID="None" HeaderHtml="&nbsp;Detalle de Combo Transportadora"
            BackColor="#F4F4F4" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="370px" Height="400px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#F4F4F4;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="PnlDetalleCombo" runat="server" Height="240px" Width="335px" Style="overflow: auto;
                    background-color: White" Font-Size="XX-Small" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Visible="true" HorizontalAlign="Left" Enabled="false">
                    <table class="tablaGris" width="300px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                Datos de los combos
                            </th>
                        </tr>
                        <tr>
                        </tr>
                        <td class="field">
                            Tipo Tarifa:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTarifaCombo" runat="server">
                            </asp:DropDownList>
                            <span style="color: Red; font-size: small">*</span>
                            <asp:RequiredFieldValidator ID="rfvtarifaCombo" runat="server" ControlToValidate="ddlTarifaCombo"
                                Display="Dynamic" ValidationGroup="vgComboDetalle" InitialValue="0" Font-Size="XX-Small"
                                ErrorMessage="Debe seleccionar el Tipo de Tarifa"></asp:RequiredFieldValidator>
                        </td>
                        <tr>
                            <td class="field">
                                Productos:
                            </td>
                            <td align="left">
                                <asp:CheckBoxList ID="chblComboDetalle" runat="server" CellPadding="5" TextAlign="Right"
                                    CellSpacing="5" RepeatDirection="Vertical" RepeatLayout="Flow" Font-Bold="false"
                                    Font-Size="XX-Small">
                                </asp:CheckBoxList>
                                <%--<span style="color:Red; font-size:small">*</span>--%>
                                <br />
                                <asp:CustomValidator ID="cvComboDetalle" runat="server" ClientValidationFunction="validaCheckBoxListDetalle"
                                    ErrorMessage="Seleccione al menos dos elemento" Font-Size="XX-Small" ValidationGroup="vgComboDetalle"
                                    Display="Dynamic"></asp:CustomValidator>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlBotones" runat="server" Height="50px" Width="308px" Style="overflow: auto;
                    background-color: #F4F4F4" Font-Size="XX-Small" ScrollBars="Auto" BorderStyle="None"
                    Direction="NotSet" Visible="true" HorizontalAlign="center" Enabled="true">
                    <table>
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="lnkNew" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idGrupoTransportadora") %>' CommandName="NuevoCombo"
                                    ToolTip="Nuevo Combo"><img alt = ""
                                            src="../images/add.png" />Nuevo Combo</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:LinkButton ID="lnkGrabar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idGrupoTransportadora") %>' CommandName="GrabarCombo"
                                    ValidationGroup="vgComboDetalle" Enabled="false" ToolTip="Grabar Combo"><img alt = ""
                                            src="../images/confirmation.png" />Grabar Combo</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label ID="LblErrorComboDetalle" runat="server" Text="" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <h3>
                    Combos Registrados</h3>
                <div style="overflow: auto; width: 350px; height: 150px">
                    <asp:GridView ID="gvComboRegistrado" runat="server" AutoGenerateColumns="False" CssClass="tablaGris"
                        BorderColor="Black" DataKeyNames="idGrupoTransportadora" EmptyDataText="No hay Combos registrados para mostrar..."
                        BorderStyle="Double" AlternatingRowStyle-Wrap="False" EditRowStyle-Wrap="False"
                        RowStyle-Wrap="False">
                        <Columns>
                            <asp:TemplateField HeaderText="Combo Registrado" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkCombo" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        Text='<%# Container.DataItem("descripcion") %>' CommandArgument='<%# Bind("idGrupoTransportadora") %>'
                                        CommandName="VerCombo" ToolTip="Ver Combo"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Opciones" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idGrupoTransportadora") %>' CommandName="EditarCombo"
                                        ToolTip="Editar Combo"><img alt = ""
                                            src="../images/edit.gif" /></asp:LinkButton>
                                    <asp:LinkButton ID="lnkBorrar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idGrupoTransportadora") %>' CommandName="BorrarCombo"
                                        ToolTip="Borrar Combo"><img alt = "" 
                                            src="../images/delete.gif" /></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" Width="80px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BorderStyle="Solid" />
                        <EditRowStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <AlternatingRowStyle CssClass="alternatingRow" BackColor="#FFFFFF" BorderStyle="Solid" />
                    </asp:GridView>
                </div>
                <br />
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%--<span style="color:Red; font-size:small">*</span>--%>
    <div>
        <eo:Dialog runat="server" ID="dlgDetalleRango" ControlSkinID="None" HeaderHtml="&nbsp;Detalle de Rango Transportadora"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="330px" Height="100px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlRangoDetalle" runat="server" HorizontalAlign="Left" Height="170px"
                    Width="325px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="false" Visible="true">
                    <table class="tablaGris" width="315px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                Datos de los Rangos
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Cantidad Inicial:
                            </td>
                            <td>
                                <asp:TextBox ID="txtCntInicialDetalle" runat="server" Width="200px" MaxLength="9"></asp:TextBox>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvCntInicialDetalle" runat="server" ControlToValidate="txtCntInicialDetalle"
                                    Display="Dynamic" ValidationGroup="vgRangoDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la cantidad Inicial"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Cantidad Final:
                            </td>
                            <td>
                                <asp:TextBox ID="txtCntFinalDetalle" runat="server" Width="200px" MaxLength="9"></asp:TextBox>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvCntFinalDetalle" runat="server" ControlToValidate="txtCntFinalDetalle"
                                    Display="Dynamic" ValidationGroup="vgRangoDetalle" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar la cantidad Final"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="field">
                                Tipo Tarifa:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlTarifaRangoDetalle" runat="server">
                                </asp:DropDownList>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvDdlTarifaRango" runat="server" ControlToValidate="ddlTarifaRangoDetalle"
                                    Display="Dynamic" ValidationGroup="vgRangoDetalle" InitialValue="0" Font-Size="XX-Small"
                                    ErrorMessage="Debe seleccionar el Tipo de Tarifa"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlBotonesRango" runat="server" Height="50px" Width="308px" Style="overflow: auto;
                    background-color: #F4F4F4" Font-Size="XX-Small" ScrollBars="Auto" BorderStyle="None"
                    Direction="NotSet" Visible="true" HorizontalAlign="center" Enabled="true">
                    <table>
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="lnkNewRango" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idRango") %>' CommandName="NuevoRango" ToolTip="Nuevo Rango"><img alt = ""
                                            src="../images/add.png" />Nuevo Rango</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:LinkButton ID="lnkGrabarRango" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idRango") %>' CommandName="GrabarRango" ValidationGroup="vgRangoDetalle"
                                    Enabled="false" ToolTip="Grabar Rango"><img alt = ""
                                            src="../images/confirmation.png" />Grabar Rango</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label ID="lblerrorRangoDetalle" runat="server" Text="" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <h3>
                    Rangos Registrados</h3>
                <div style="overflow: auto; width: 350px; height: 150px">
                    <asp:GridView ID="gvRangoDetalle" runat="server" AutoGenerateColumns="False" CssClass="tablaGris"
                        BorderColor="Black" DataKeyNames="idRango" EmptyDataText="No hay Rangos registrados para mostrar..."
                        BorderStyle="Double" AlternatingRowStyle-Wrap="False" EditRowStyle-Wrap="False"
                        RowStyle-Wrap="False">
                        <Columns>
                            <asp:BoundField DataField="tipoTarifa" HeaderText="Tipo Tarifa" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="300px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="valorInicial" HeaderText="Valor Inicial" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="200px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="valorFinal" HeaderText="Valor Final" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="200px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Opciones" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkVer" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idRango") %>' CommandName="VerRango" ToolTip="Ver Rango"><img alt = ""
                                            src="../images/view.png" /></asp:LinkButton>
                                    <asp:LinkButton ID="lnkEditar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idRango") %>' CommandName="EditarRango" ToolTip="Editar Rango"><img alt = ""
                                            src="../images/edit.gif" /></asp:LinkButton>
                                    <asp:LinkButton ID="lnkBorrar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idRango") %>' CommandName="BorrarRango" ToolTip="Borrar Rango"><img alt = "" 
                                            src="../images/delete.gif" /></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" Width="90px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BorderStyle="Solid" />
                        <EditRowStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <AlternatingRowStyle CssClass="alternatingRow" BackColor="#FFFFFF" BorderStyle="Solid" />
                    </asp:GridView>
                </div>
                <br />
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgConfirmacionTarifa" ControlSkinID="None" HeaderHtml="&nbsp;Confirmacion"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="360px" Height="60px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlConfirmacionTarifa" runat="server" HorizontalAlign="Center" Height="80px"
                    Width="370px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="true" Visible="true">
                    <table width="350px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                &nbsp;&nbsp;Esta Seguro de Borrar la Información?
                            </th>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="btnSiTarifa" runat="server" Text="&nbsp;Borrar" />
                            </td>
                            <td align="center">
                                <asp:Button ID="btnNoTarifa" runat="server" Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgConfirmacion" ControlSkinID="None" HeaderHtml="&nbsp;Confirmacion"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="360px" Height="60px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlConfirmacion" runat="server" HorizontalAlign="Center" Height="80px"
                    Width="370px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="true" Visible="true">
                    <table width="350px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                &nbsp;&nbsp;Esta Seguro de Borrar la Información?
                            </th>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="BtnSi" runat="server" Text="&nbsp;Borrar" />
                            </td>
                            <td align="center">
                                <asp:Button ID="BtnNO" runat="server" Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgConfirmacionRango" ControlSkinID="None" HeaderHtml="&nbsp;Confirmacion"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="360px" Height="60px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlConfirmacionRango" runat="server" HorizontalAlign="Center" Height="80px"
                    Width="370px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="true" Visible="true">
                    <table width="350px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                &nbsp;&nbsp;Esta Seguro de Borrar la Información?
                            </th>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="BtnSiRango" runat="server" Text="&nbsp;Borrar" />
                            </td>
                            <td align="center">
                                <asp:Button ID="BtnNoRango" runat="server" Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgTipoTarifa" ControlSkinID="None" HeaderHtml="&nbsp;Tipo Tarifa Transportadora"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="400px" Height="60px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black" CloseButtonUrl="00020312">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlTipoTarifa" runat="server" HorizontalAlign="Left" Height="100px"
                    Width="390px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="false" Visible="true">
                    <table class="tablaGris" width="380px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                Datos del tipo de tarifa
                            </th>
                        </tr>
                        <tr>
                            <td class="field" style="width: 150">
                                Nombre de Tipo de Tarifa:
                            </td>
                            <td>
                                <asp:TextBox ID="txtTipoTarifa" runat="server" Width="300px" MaxLength="50"></asp:TextBox>
                                <span style="color: Red; font-size: small">*</span>
                                <asp:RequiredFieldValidator ID="rfvTipoTarifa" runat="server" ControlToValidate="txtTipoTarifa"
                                    Display="Dynamic" ValidationGroup="vgTipoTarifa" Font-Size="XX-Small" ErrorMessage="&lt;br&gt; Debe proporcionar el nombre del tipo de tarifa"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlBotonTipoTarifa" runat="server" HorizontalAlign="center" Height="50px"
                    Width="390px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="None" Direction="NotSet"
                    Enabled="true" Visible="true">
                    <table>
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="lnkNuevoTipoTarifa" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idRango") %>' CommandName="Nuevo Tipo Tarifa" Font-Size="X-Small"
                                    ToolTip="Nuevo Tipo Tarifa"><img alt = ""
                                            src="../images/add.png" />Nuevo Tipo Tarifa</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:LinkButton ID="lnkGrabarTipoTarifa" runat="server" OnClientClick="$find(ModalProgress).show()"
                                    CommandArgument='<%# Bind("idRango") %>' CommandName="GrabarTipoTarifa" Font-Size="X-Small"
                                    ValidationGroup="vgTipoTarifa" Enabled="false" ToolTip="Grabar Tipo Tarifa"><img alt = ""
                                            src="../images/confirmation.png" />Grabar Tipo Tarifa</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label ID="LblResulTipoTarifa" runat="server" Text="" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <h3>
                    Tipos de Tarifa Registrados</h3>
                <div style="overflow: auto; width: 350px; height: 150px">
                    <asp:GridView ID="gvTipoTarifa" runat="server" AutoGenerateColumns="False" CssClass="tablaGris"
                        BorderColor="Black" DataKeyNames="idTipoTarifa" EmptyDataText="No hay Tipos de Tarifas registrados para mostrar..."
                        BorderStyle="Double" AlternatingRowStyle-Wrap="False" EditRowStyle-Wrap="False"
                        RowStyle-Wrap="False">
                        <Columns>
                            <asp:BoundField DataField="descripcion" HeaderText="Tipo Tarifa" ItemStyle-Font-Size="X-Small">
                                <HeaderStyle HorizontalAlign="Center" Font-Size="X-Small" Width="300px"></HeaderStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Opciones" ShowHeader="False" FooterStyle-Font-Size="XX-Small">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idTipoTarifa") %>' CommandName="EditarTipoTarifa"
                                        ToolTip="Editar Tipo Tarifa"><img alt = ""
                                            src="../images/edit.gif" /></asp:LinkButton>
                                    <asp:LinkButton ID="lnkBorrar" runat="server" OnClientClick="$find(ModalProgress).show()"
                                        CommandArgument='<%# Bind("idTipoTarifa") %>' CommandName="BorrarTipoTarifa"
                                        ToolTip="Borrar Tipo Tarifa"><img alt = "" 
                                            src="../images/delete.gif" /></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" Width="90px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BorderStyle="Solid" />
                        <EditRowStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <AlternatingRowStyle CssClass="alternatingRow" BackColor="#FFFFFF" BorderStyle="Solid" />
                    </asp:GridView>
                </div>
                <br />
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    <div>
        <eo:Dialog runat="server" ID="dlgConfirmacionTipo" ControlSkinID="None" HeaderHtml="&nbsp;Confirmacion"
            BackColor="WhiteSmoke" BackShadeColor="Gray" BackShadeOpacity="50" HorizontalAlign="Center"
            Width="360px" Height="60px" Font-Bold="True" Font-Size="Small" AllowMove="False"
            ActivateOnClick="False" ForeColor="Black">
            <HeaderStyleActive CssText="background-color:#eeeeee;" />
            <FooterStyleActive CssText="" />
            <ContentTemplate>
                <asp:Panel ID="pnlConfitmacionTipo" runat="server" HorizontalAlign="Center" Height="80px"
                    Width="370px" Style="overflow: auto;" ScrollBars="Auto" BorderStyle="Double"
                    Direction="NotSet" Enabled="true" Visible="true">
                    <table width="350px">
                        <tr>
                            <th colspan="2" style="font-size: small">
                                &nbsp;&nbsp;Esta Seguro de Borrar la Información?
                            </th>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="BtnSiTipo" runat="server" Text="&nbsp;Borrar" />
                            </td>
                            <td align="center">
                                <asp:Button ID="BtnNoTipo" runat="server" Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </ContentTemplate>
        </eo:Dialog>
    </div>
    <%------------------------------------------------------------------------------------------------------------------------------%>
    </form>
</body>
</html>
