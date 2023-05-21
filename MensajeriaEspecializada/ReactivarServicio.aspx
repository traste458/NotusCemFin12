<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReactivarServicio.aspx.vb" Inherits="BPColSysOP.ReactivarServicio" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <script language="javascript" type="text/javascript">
        function validaSeleccionReactivacion() {
            try {
                var strMensaje = "";
                var numRadicado = txtNuevoRadicado.GetText();
                var reactivaSin = rbReactivacion.GetValue();
                if (numRadicado == undefined) {
                    numRadicado = '';
                }
                else { }
                var txtObservacion = document.getElementById('cpGeneral_txtObservacionReactivacion').value;

                /*Se validan los datos antes de guadar.*/
                if (reactivaSin == null) {
                    strMensaje += "- Debe seleccionar si se realiza cambio de Radicado.\n";
                }
                if (reactivaSin && numRadicado == '') {
                    strMensaje += "- El nuevo número de radicado es requerido.\n";
                }
                if (txtObservacion.length == 0) {
                    strMensaje += "- La observación de reactivación es obligatoria.\n";
                }

                if (strMensaje.length == 0) {
                    cpGeneral.PerformCallback('ReactivarServicio:');

                } else {
                    alert(strMensaje);
                    return false;
                }
            } catch (ex) {
                return false;
            }
        }

        function ValidarNumeroRadicado() {
            try {
                var numRadicado = txtNuevoRadicado.GetText();
                if (numRadicado.length > 0) {
                    ActivarRadicado();
                    cpGeneral.PerformCallback('consultarRadicado:' + numRadicado);
                    LoadingPanel.Show();
                }
            } catch (e) {
                LoadingPanel.Hide();

            }
        }
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
                LoadingPanel.Hide();
            }
        }
        function ActivarRadicado() {
            reactivaSin = rbReactivacion.GetValue();
            ///*Se muestra u oculta el textbox del radicado.*/
            if (reactivaSin) {
                txtNuevoRadicado.SetVisible(true);
                lbNuevoRadicado.SetVisible(true);
            } else {
                txtNuevoRadicado.SetVisible(false);
                lbNuevoRadicado.SetVisible(false);
                imgError.SetVisible(false);

            }
        }
        
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
            >
            <ClientSideEvents EndCallback="function (s, e){
                  MostrarInfoEncabezado(s,e);
                LoadingPanel.Hide();                
            }" />
            <PanelCollection>
                <dx:PanelContent>
                    <div id="divEncabezado">
                        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                    </div>
                    <div>
                        <table align="center" class="tabla">
                            <tr>
                                <td class="field">¿Con cambio de Radicado?
                                </td>
                                <td>
                                    <dx:ASPxRadioButtonList ID="rbReactivacion" AutoPostBack="false" runat="server" ClientInstanceName="rbReactivacion" ValueType="System.Int32" ValidationGroup="cambioRadicado" RepeatDirection="Horizontal">
                                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
	                                            ActivarRadicado();
                                            }" />
                                        <Items>
                                            <dx:ListEditItem Value="0" Text="No" />
                                            <dx:ListEditItem Value="1" Text="Si" />
                                        </Items>
                                    </dx:ASPxRadioButtonList>

                                    <dx:ASPxLabel ID="lbNuevoRadicado" ClientInstanceName="lbNuevoRadicado" ClientVisible="false" runat="server" Text="&nbsp;Nuevo radicado:"></dx:ASPxLabel>
                                    <dx:ASPxTextBox ID="txtNuevoRadicado" ClientInstanceName="txtNuevoRadicado" ClientVisible="false" runat="server" Width="170px">
                                        <ClientSideEvents LostFocus="function(s, e) {
	                                        ValidarNumeroRadicado();
                                        }" />
                                    </dx:ASPxTextBox>
                                    <dx:ASPxImage ID="imgError" ClientInstanceName="imgError" runat="server" ImageUrl="~/images/close.gif" ClientVisible="false"
                                        ToolTip="El número de radicado digitado ya existe.">
                                    </dx:ASPxImage>

                                </td>
                            </tr>
                            <tr>
                                <td class="field">Observación:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtObservacionReactivacion" runat="server" Rows="6" Width="300px"
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <br />
                                    <br />
                                    <dx:ASPxButton ID="lbReactivar" AutoPostBack="false" ClientInstanceName="lbReactivar" runat="server" ToolTip="&nbsp;Reactivar Servicio" ValidationGroup="reactivarServicio">
                                        <ClientSideEvents Click="function(s, e) {
	                                        validaSeleccionReactivacion()
                                            }" />
                                        <Image Url="~/images/Open.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </td>
                                <td align="left">
                                    <br />
                                    <br />
                                    <dx:ASPxHyperLink ID="lbCancelarReactivacion1" ClientVisible="true" runat="server" ImageUrl="~/images/cancelar.png" Text="Cancelar" ToolTip="Cancelar" CausesValidation="false">
                                        <ClientSideEvents Click="function(s, e){
                                            window.location.href ='PoolServiciosNew.aspx';
                                                }" />
                                    </dx:ASPxHyperLink>

                                    <asp:HiddenField ID="hfReactivarIdServicio" runat="server" />
                                </td>
                            </tr>
                        </table>

                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
        <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
        <script src="../include/jquery-1.4.2.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
