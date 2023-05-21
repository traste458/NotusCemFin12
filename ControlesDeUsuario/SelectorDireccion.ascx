<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SelectorDireccion.ascx.vb" Inherits="BPColSysOP.SelectorDireccion" %>

<script language="javascript" type="text/jscript">
    function ObtenerDireccion() {
        try {
            var NombreVia = $("input[id*=cmbNombreVia]");
            var NumeroVia = $("input[id*=spNumeroVia]");
            var LetraVia = $("input[id*=cmbLetraVia]");
            var BisVia = $("input[id*=cmbBisVia]");
            var OrientacionVia = $("input[id*=cmbOrientacionVia]");
            var NumeroViaSec = $("input[id*=spNumeroViaSec]");
            var LetraViaSec = $("input[id*=cmbLetraViaSec]");
            var BisViaSec = $("input[id*=cmbBisViaSec]");
            var NumeroNomenclatura = $("input[id*=spNumeroNomenclatura]");
            var OrientacionViaSec = $("input[id*=cmbOrientacionViaSec]");

            var direccionEdicion = $("input[id*=hdDireccionEdicion]")
            var memoDireccion = $("textarea[id*=memoDireccion]");
            memoDireccion.val(NombreVia.val() + " " + NumeroVia.val() + " " + LetraVia.val() + " " + BisVia.val() + " " + OrientacionVia.val() + " " + NumeroViaSec.val() + " " + LetraViaSec.val() + " " + BisViaSec.val() + " " + NumeroNomenclatura.val() + " " + OrientacionViaSec.val());
            direccionEdicion.val(NombreVia.val() + "|" + NumeroVia.val() + "|" + LetraVia.val() + "|" + BisVia.val() + "|" + OrientacionVia.val() + "|" + NumeroViaSec.val() + "|" + LetraViaSec.val() + "|" + BisViaSec.val() + "|" + NumeroNomenclatura.val() + "|" + OrientacionViaSec.val());
        } catch (e) { alert("No se logro obtener la dirección: " + e.Message); }
    }
</script>

<div style="float:left; margin-right:0px;">
    <dx:ASPxMemo ID="memoDireccion" runat="server" 
        style="display:inline;" Enabled="False" Rows="2" Columns="30">
        <ValidationSettings CausesValidation="True" ValidationGroup="vgRegistrar">
            <RequiredField IsRequired="True" />
        </ValidationSettings>
    </dx:ASPxMemo>
    <br />
    <dx:ASPxHyperLink ID="hlHome" runat="server" Text="" style="display:inline;" 
        ImageUrl="~/images/home.png" 
        ToolTip="Seleccione para editar la dirección." Cursor="pointer">
    </dx:ASPxHyperLink>
    <asp:HiddenField ID="hdDireccionEdicion" runat="server" Value="" />

    <div style="display:inline">
     <dx:ASPxPopupControl ID="pcDireccion" runat="server" LoadContentViaCallback="OnFirstShow"
            PopupElementID="hlHome" PopupVerticalAlign="Below" 
            PopupHorizontalAlign="LeftSides" AllowDragging="True"
            ShowFooter="True" Width="250px" Height="130px" 
            HeaderText="Establecer dirección" ClientInstanceName="popupControl"
            Modal="True">
        <ContentCollection>
            <dx:PopupControlContentControl ID="pcContentContenido" runat="server">
                <div style="vertical-align:middle">
                    <table>
                        <tr>
                            <td align="right">
                                <dx:ASPxComboBox ID="cmbNombreVia" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="100px">
                                    <Items>
                                        <dx:ListEditItem Value="CL" Text="Calle" />
                                        <dx:ListEditItem Value="CR" Text="Carrera" />
                                        <dx:ListEditItem Value="DG" Text="Diagonal" />
                                        <dx:ListEditItem Value="TV" Text="Transversal" />
                                        <dx:ListEditItem Value="AV" Text="Avenida" />
                                        <dx:ListEditItem Value="AU" Text="Autopista" />
                                        <dx:ListEditItem Value="KM" Text="Kilómetro" />
                                        <dx:ListEditItem Value="Via" Text="Vía" />
                                        <dx:ListEditItem Value="AUN" Text="Autopista Norte" />
                                        <dx:ListEditItem Value="AUS" Text="Autopista Sur" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                            <td>
                                <dx:ASPxSpinEdit ID="spNumeroVia" runat="server" Height="21px" Number="0" 
                                    MaxValue="500" MinValue="1" Width="50px" NumberType="Integer">
                                </dx:ASPxSpinEdit>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbLetraVia" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="40px">
                                    <Items>
                                        <dx:ListEditItem Value="A" Text="A" />
                                        <dx:ListEditItem Value="B" Text="B" />
                                        <dx:ListEditItem Value="C" Text="C" />
                                        <dx:ListEditItem Value="D" Text="D" />
                                        <dx:ListEditItem Value="E" Text="E" />
                                        <dx:ListEditItem Value="F" Text="F" />
                                        <dx:ListEditItem Value="G" Text="G" />
                                        <dx:ListEditItem Value="H" Text="H" />
                                        <dx:ListEditItem Value="I" Text="I" />
                                        <dx:ListEditItem Value="J" Text="J" />
                                        <dx:ListEditItem Value="K" Text="K" />
                                        <dx:ListEditItem Value="L" Text="L" />
                                        <dx:ListEditItem Value="M" Text="M" />
                                        <dx:ListEditItem Value="N" Text="N" />
                                        <dx:ListEditItem Value="O" Text="O" />
                                        <dx:ListEditItem Value="P" Text="P" />
                                        <dx:ListEditItem Value="Q" Text="Q" />
                                        <dx:ListEditItem Value="R" Text="R" />
                                        <dx:ListEditItem Value="S" Text="S" />
                                        <dx:ListEditItem Value="T" Text="T" />
                                        <dx:ListEditItem Value="U" Text="U" />
                                        <dx:ListEditItem Value="V" Text="V" />
                                        <dx:ListEditItem Value="W" Text="W" />
                                        <dx:ListEditItem Value="X" Text="X" />
                                        <dx:ListEditItem Value="Y" Text="Y" />
                                        <dx:ListEditItem Value="Z" Text="Z" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbBisVia" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="50px">
                                    <Items>
                                        <dx:ListEditItem Value="BIS" Text="BIS" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbOrientacionVia" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="100px">
                                    <Items>
                                        <dx:ListEditItem Value="N" Text="Norte" />
                                        <dx:ListEditItem Value="S" Text="Sur" />
                                        <dx:ListEditItem Value="E" Text="Este" />
                                        <dx:ListEditItem Value="O" Text="Oeste" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">#</td>
                            <td>
                                <dx:ASPxSpinEdit ID="spNumeroViaSec" runat="server" Height="21px" Number="0" 
                                    MaxValue="500" MinValue="1" Width="50px" NumberType="Integer">
                                </dx:ASPxSpinEdit>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbLetraViaSec" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="40px">
                                    <Items>
                                        <dx:ListEditItem Value="A" Text="A" />
                                        <dx:ListEditItem Value="B" Text="B" />
                                        <dx:ListEditItem Value="C" Text="C" />
                                        <dx:ListEditItem Value="D" Text="D" />
                                        <dx:ListEditItem Value="E" Text="E" />
                                        <dx:ListEditItem Value="F" Text="F" />
                                        <dx:ListEditItem Value="G" Text="G" />
                                        <dx:ListEditItem Value="H" Text="H" />
                                        <dx:ListEditItem Value="I" Text="I" />
                                        <dx:ListEditItem Value="J" Text="J" />
                                        <dx:ListEditItem Value="K" Text="K" />
                                        <dx:ListEditItem Value="L" Text="L" />
                                        <dx:ListEditItem Value="M" Text="M" />
                                        <dx:ListEditItem Value="N" Text="N" />
                                        <dx:ListEditItem Value="O" Text="O" />
                                        <dx:ListEditItem Value="P" Text="P" />
                                        <dx:ListEditItem Value="Q" Text="Q" />
                                        <dx:ListEditItem Value="R" Text="R" />
                                        <dx:ListEditItem Value="S" Text="S" />
                                        <dx:ListEditItem Value="T" Text="T" />
                                        <dx:ListEditItem Value="U" Text="U" />
                                        <dx:ListEditItem Value="V" Text="V" />
                                        <dx:ListEditItem Value="W" Text="W" />
                                        <dx:ListEditItem Value="X" Text="X" />
                                        <dx:ListEditItem Value="Y" Text="Y" />
                                        <dx:ListEditItem Value="Z" Text="Z" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbBisViaSec" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="50px">
                                    <Items>
                                        <dx:ListEditItem Value="BIS" Text="BIS" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">-</td>
                            <td>
                                <dx:ASPxSpinEdit ID="spNumeroNomenclatura" runat="server" Height="21px" Number="0" 
                                    MaxValue="500" MinValue="1" Width="50px" NumberType="Integer">
                                </dx:ASPxSpinEdit>
                            </td>
                            <td>
                                <dx:ASPxComboBox ID="cmbOrientacionViaSec" runat="server" IncrementalFilteringMode="Contains" 
                                    AutoResizeWithContainer="True" Width="100px">
                                    <Items>
                                        <dx:ListEditItem Value="N" Text="Norte" />
                                        <dx:ListEditItem Value="S" Text="Sur" />
                                        <dx:ListEditItem Value="E" Text="Este" />
                                        <dx:ListEditItem Value="O" Text="Oeste" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                    </table>
                    
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <FooterTemplate>
            <div style="float: right; margin: 3px;">
                <dx:ASPxButton ID="btnGuardar" runat="server" Text="Aceptar" 
                    AutoPostBack="False" >
                    <ClientSideEvents Click="function(s, e){
                        ObtenerDireccion();
                        popupControl.Hide();
                    }" />
                </dx:ASPxButton>
            </div>
        </FooterTemplate>
    </dx:ASPxPopupControl>
    </div>
</div>

