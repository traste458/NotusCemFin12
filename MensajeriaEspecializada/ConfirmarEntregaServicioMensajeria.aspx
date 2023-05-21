<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfirmarEntregaServicioMensajeria.aspx.vb"
    Inherits="BPColSysOP.ConfirmarEntregaServicioMensajeria" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Confirmar entrega - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />

    <style type="text/css">        
    .tablaRound td, .tablaRound th {
        padding: 2px;
        border-bottom: 1px solid #f2f2f2;    
    }

    .tablaRound tbody {
        background: #f5f5f5;
        -webkit-box-shadow: 0 1px 0 rgba(255,255,255,.8) inset; 
        -moz-box-shadow:0 1px 0 rgba(255,255,255,.8) inset;  
        box-shadow: 0 1px 0 rgba(255,255,255,.8) inset;        
    }

    .tablaRound th {
        text-align: left;
        text-shadow: 0 1px 0 rgba(255,255,255,.5); 
        border-bottom: 1px solid #ccc;
        background-color: #eee;
        background-image: -webkit-gradient(linear, left top, left bottom, from(#f5f5f5), to(#eee));
        background-image: -webkit-linear-gradient(top, #f5f5f5, #eee);
        background-image:    -moz-linear-gradient(top, #f5f5f5, #eee);
        background-image:     -ms-linear-gradient(top, #f5f5f5, #eee);
        background-image:      -o-linear-gradient(top, #f5f5f5, #eee); 
        background-image:         linear-gradient(top, #f5f5f5, #eee);
    }

    
    .tablaRound th:only-child{
        -moz-border-radius: 6px 6px 0 0;
        -webkit-border-radius: 6px 6px 0 0;
        border-radius: 6px 6px 0 0;
    }
    </style>

    <script language="javascript" type="text/javascript">
        var myWidth = 0, myHeight = 0;

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function GetWindowSize() {
            //var myWidth = 0, myHeight = 0;
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

            document.getElementById("hfMedidasVentana").value = myHeight + ";" + myWidth;
        }

        function ocultarTemporales() {
            gvBase.SetVisible(false);
        }

        function VisualizarNovedades(s, e) {
            alert(dialogoNovedades);
            dialogoNovedades.SetSize(myWidth * 0.5, myHeight * 0.6);
            dialogoNovedades.SetVisible(true);
            gvNovedades.PerformCallback();
        }

        function ControlFinNovedad(s, e) {
            //cmbTipoNovedad.SetValue(null);
            memoObservacionesNovedad.SetText(null);
            if (s.cpMensajeRespuesta == '0') {
                btnDespachar.SetEnabled(false);
            }
        }

        function verSucursal(obj) {
            valores = ['382', '383', '384']
            if(valores.indexOf(obj.value) >= 0){
                document.getElementById("tdSucursal").style.display = 'table-row'
            } else {
                document.getElementById("tdSucursal").style.display = 'none'
            }
        }
    </script>

    <style type="text/css">
        .style2
        {
            height: 21px;
        }
    </style>
</head>
<body class="cuerpo2" onload="GetWindowSize(); ocultarTemporales();">
    <form id="formPrindipal" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <eo:CallbackPanel ID="cpEncabezado" runat="server" UpdateMode="Always" Width=" 98%">
        <asp:UpdatePanel ID="upEncabezado" runat="server">
            <ContentTemplate>
                <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait"
        ChildrenAsTriggers="true" Width="100%">

        <div style="float:left; margin-right: 20px">
            <table class="tablaRound">
                <thead>
                <tr>
                    <th>RADICADO / SERVICIO</th>        
                </tr>
                </thead>
                <tr>
                    <td>
                    <table class="tabla" style="width: 100%;">
                        <tr valign="middle">
                            <td>
                                Tipo de Servicio:
                            </td>
                            <td>
                                <asp:RadioButtonList ID="rblTipoServicio" runat="server">
                                    <%--<asp:ListItem Value="1" Text="Reposición" />
                                    <asp:ListItem Value="2" Text="Venta" />
                                    <asp:ListItem Value="8" Text="Siembra"></asp:ListItem>
                                    <asp:ListItem Value="9" Text="Venta WEB"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Cesión Contrato"></asp:ListItem>
                                    <asp:ListItem Value="10" Text="Financiero"></asp:ListItem>
                                    <asp:ListItem Value="12" Text="Venta Corporativa"></asp:ListItem>
                                    <asp:ListItem Value="13" Text="Campaña Claro Fijo"></asp:ListItem>
                                    <asp:ListItem Value="16" Text="Equipos Reparados ST"></asp:ListItem>
                                    <asp:ListItem Value="17" Text="Servicios Financieros Bancolombia"></asp:ListItem>--%>
                                    <asp:ListItem Value="18" Text="Servicios Financieros Davivienda"></asp:ListItem>
                                    <%--<asp:ListItem Value="19" Text="Servicios Financieros Davivienda- Samsung"></asp:ListItem>--%>
                                </asp:RadioButtonList>
                                <asp:RequiredFieldValidator ID="rfvrblTipoServicio" runat="server" ControlToValidate="rblTipoServicio"
                                    ErrorMessage="Por favor seleccione un tipo de servicio" ValidationGroup="vgRadicado" Display="Dynamic" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Número de Radicado:
                            </td>
                            <td>
                                <asp:TextBox ID="txtNoRadicado" runat="server" MaxLength="15"></asp:TextBox>
                                <br />
                                <asp:RequiredFieldValidator ID="rfvtxtNoRadicado" runat="server" ControlToValidate="txtNoRadicado"
                                    ValidationGroup="vgRadicado" ErrorMessage="Por favor ingrese un radicado." Text="Por favor ingrese un radicado."
                                    Display="Dynamic" />
                            </td>
                        </tr>
                    </table>
                    </td>
                </tr>    
                <tr>
                    <td>
                    <table class="tabla" style="width: 100%;">
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="lbBuscar" runat="server" Width="150px" HorizontalAlign="Center"
                                    Style="display: inline" CssClass="search" AutoPostBack="true" ValidationGroup="vgRadicado">
                                    <img alt="Buscar" src="../images/find.gif" />&nbsp;Buscar
                                </asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:LinkButton ID="btnNovedad" runat="server" Width="150px" HorizontalAlign="Center"
                                    Style="display: inline" AutoPostBack="true" Enabled="false" CssClass="search">
                                    <img src="../images/comment_add.png" alt="Novedades"/>&nbsp;Novedades
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    </td>
                </tr> 
            </table>
        </div>
        <br />
        <div style="float:left; width: 250px;">
            <blockquote>
                <b>NOTA: </b>Solamente se permite la confirmación de entrega, para servicios que
                se encuentren en estado <i>Tránsito</i> ó <i>Devolución</i>.
            </blockquote>
        </div>
        <br />
        <br />
        <div style="clear:both"></div>
        <asp:Panel ID="pnlGeneral" runat="server" Visible="false">
            <table style="width: 95%;">
                <tr>
                    <td width="50%">
                       <%-- <table class="tabla">
                            <tr>
                                <th>ZONA</th><th>RESPONSABLE</th>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlZona" runat="server" AutoPostBack="True" Width="150px">
                                    </asp:DropDownList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvddlZona" runat="server" ControlToValidate="ddlZona"
                                        Display="Dynamic" ErrorMessage="Seleccione una Zona" InitialValue="0" ValidationGroup="vgZona"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlResponsableEntrega" runat="server" Width="300px">
                                    </asp:DropDownList>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rfvddlResponsableEntrega" runat="server" ControlToValidate="ddlResponsableEntrega"
                                        Display="Dynamic" ErrorMessage="Seleccione un responsable" InitialValue="0" ValidationGroup="vgZona"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>--%>
                    </td>
                </tr>
                <tr>
                    <td width="50%">
                        <asp:Panel ID="pnlDatosVenta" runat="server" Visible="false">
                            <table class="tabla" style="width: 100%;">
                                <tr>
                                    <td>Medio de Pago:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlMedioPago" runat="server">
                                            <asp:ListItem Value="1" Text="Efectivo" />
                                            <asp:ListItem Value="2" Text="Tarjeta Débito" />
                                            <asp:ListItem Value="3" Text="Tarjeta Crédito" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Valor recaudo:</td>
                                    <td>
                                        <asp:TextBox ID="txtValorRecaudo" runat="server" Width="80px" onkeypress="javascript:return ValidaNumero(event);" MaxLength="10" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Número de Contrato:</td>
                                    <td>
                                        <asp:TextBox ID="txtNumeroContrato" runat="server" Width="100px" onkeypress="javascript:return ValidaNumero(event);" MaxLength="15" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" width="100%">
                        <asp:LinkButton ID="lbConfirmarEntrega" runat="server" CssClass="search" Enabled="False"
                            Font-Bold="True" OnClientClick="return confirm('¿Desea realizar la confirmación de la entrega del servicio seleccionado?')"
                            ValidationGroup="vgZona">
                        <img alt="Confirmar entrega" src="../images/delivery_ok.png" />&nbsp;Confirmar 
                        entrega
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
            <br />
            <br />
            <asp:PlaceHolder ID="phEncabezado" runat="server"></asp:PlaceHolder>            
            <br />

            <asp:Panel ID="pnlDetalleReposicion" runat="server">
                <table class="tabla" style="width: 95%">
                    <tr>
                        <td style="width: 45%" valign="top">
                            <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                                <div style="display: block; padding-bottom: 3px; margin: 5px;">
                                    <asp:LinkButton ID="lbVerSeriales" runat="server" CssClass="search" Visible="False">
                                        <img src="../images/view.png" alt=""/>&nbsp;Ver Seriales
                                    </asp:LinkButton>
                                </div>
                            </eo:CallbackPanel>
                        
                            <asp:GridView ID="gvListaReferencias" runat="server" AutoGenerateColumns="False"
                                Width="100%" ClientInstanceName="gvListaReferencias">
                                <Columns>
                                    <asp:BoundField DataField="Material" HeaderText="Material" />
                                    <asp:BoundField DataField="DescripcionMaterial" HeaderText="Descripción Material" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="CantidadLeida" HeaderText="Cantidad Le&iacute;da" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="CantidadCambio" HeaderText="Cantidad Cambio" ItemStyle-HorizontalAlign="Center" />
                                </Columns>
                            </asp:GridView>
                            <br />
                            <br />
                            <asp:GridView ID="gvNovedad" runat="server" AutoGenerateColumns="False"
                                Width="100%" ClientInstanceName="gvNovedad">
                                <Columns>
                                    <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                    <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                    <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                        DataFormatString="{0:d}">
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ComentarioEspecifico" HeaderText="Comentario Espec&iacute;fico" />
                                    <asp:BoundField DataField="Observacion" HeaderText="Comentario General" />
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td style="width: 5%">
                            &nbsp;
                        </td>
                        <td style="width: 45%" valign="top">
                            <asp:GridView ID="gvListaMsisdn" runat="server" AutoGenerateColumns="False"
                                Width="100%" ClientInstanceName="gvListaMsisdn">
                                <Columns>
                                    <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                                    <asp:BoundField DataField="ActivaEquipoAnteriorTexto" HeaderText="Activar Equipo Anterior (S/N)" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="ComseguroTexto" HeaderText="Comseguro (S/N)" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="PrecioConIva" HeaderText="Precio Con Iva" ItemStyle-HorizontalAlign="Right" 
                                        DataFormatString="{0:C2}">
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PrecioSinIva" HeaderText="Precio Sin Iva" ItemStyle-HorizontalAlign="Right" 
                                        DataFormatString="{0:C2}">
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <br />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            

            <asp:Panel ID="pnlDetalleSiembra" runat="server" Visible="false">
                <div style="margin-top: 10px; margin-right: 10px; float:left; width: 48%;">
                    <dx:ASPxRoundPanel ID="rpSeriales" runat="server" HeaderText="Información de Referencias"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvReferencias" runat="server" AutoGenerateColumns="false" 
                                    Width="100%">
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="Material" FieldName="Material" 
                                            ShowInCustomizationForm="True" VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Descripción Material" FieldName="DescripcionMaterial" 
                                            ShowInCustomizationForm="True" VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Cantidad" 
                                            FieldName="Cantidad" ShowInCustomizationForm="True" VisibleIndex="2">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsPager Visible="False">
                                    </SettingsPager>
                                </dx:ASPxGridView>

                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>

                <div style="margin-top: 10px; float:left; width: 48%;">
                    <dx:ASPxRoundPanel ID="rpMins" runat="server" HeaderText="Información de MSISDNs"
                        Width="100%">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvMins" runat="server" AutoGenerateColumns="False" 
                                    Width="100%">
                                    <Columns>
                                        <dx:GridViewDataTextColumn Caption="MSISDN" FieldName="MSISDN" 
                                            ShowInCustomizationForm="True" VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Plan" FieldName="NombrePlan" 
                                            ShowInCustomizationForm="True" VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Fecha Devolución" 
                                            FieldName="FechaDevolucion" ShowInCustomizationForm="True" VisibleIndex="2">
                                            <PropertiesTextEdit DisplayFormatString="{0:d}"></PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsPager Visible="False">
                                    </SettingsPager>
                                </dx:ASPxGridView>

                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
            </asp:Panel>

            <eo:CallbackPanel ID="cpSeriales" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                <eo:Dialog runat="server" ID="dlgSerial" ControlSkinID="None" Height="350px" HeaderHtml="Detalle de Seriales"
                    CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                    <ContentTemplate>
                        <asp:Panel ID="pnlDetalleSerial" runat="server" Style="height: 100%; width: 100%;
                            overflow: auto;">
                            <table align="center" class="tabla">
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvSeriales" runat="server" Width="100%" AutoGenerateColumns="false"
                                            ShowFooter="true" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                            <Columns>
                                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia" />
                                                <asp:BoundField DataField="Serial" HeaderText="Serial" />
                                                <asp:BoundField DataField="Msisdn" HeaderText="MSISDN" />
                                            </Columns>
                                            <FooterStyle CssClass="field" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </ContentTemplate>
                    <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                    </FooterStyleActive>
                    <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                    </HeaderStyleActive>
                    <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                    </ContentStyleActive>
                    <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                        TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                        TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                    </BorderImages>
                </eo:Dialog>
            </eo:CallbackPanel>

            <eo:CallbackPanel ID="cpNovedades" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
                ChildrenAsTriggers="true" UpdateMode="Group" GroupName="verSeriales">
                <eo:Dialog runat="server" ID="dlgNovedades" ControlSkinID="None" Height="350px" HeaderHtml="Novedades"
                    CloseButtonUrl="00020312" BackColor="White" BackShadeColor="Gray" BackShadeOpacity="50">
                    <ContentTemplate>
                        <asp:Panel ID="Panel1" runat="server" Style="height: 100%; width: 100%;
                            overflow: auto;">
                            <table align="center" class="tabla">
                                <tr>
                                    <td class="field">
                                        Seleccione tipo de Novedad:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlTipoNovedad" runat="server" ValidationGroup="registroNovedad" onchange="verSucursal(this)">
                                        </asp:DropDownList>
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvTipoNovedad" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                                Display="Dynamic" ControlToValidate="ddlTipoNovedad" ValidationGroup="registroNovedad"
                                                InitialValue="0"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="tdSucursal" style="display: none">
                                    <td class="field">
                                        Sucursal
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlSucursal" runat="server" ValidationGroup="registroNovedad">
                                        </asp:DropDownList> 
                                        <div style="display: block;">
                                            <asp:RequiredFieldValidator ID="rfvSucursal" runat="server" ErrorMessage="Seleccione una sucursal"
                                                Display="Dynamic" ControlToValidate="ddlSucursal" ValidationGroup="registroNovedad2"
                                                ></asp:RequiredFieldValidator>
                                        </div>                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Comentario General:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtObservacionNovedad" runat="server" TextMode="MultiLine" Rows="3"
                                            Columns="50"></asp:TextBox>
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvObservacionNovedad" runat="server" ErrorMessage="Indique la descripci&oacute;n general de la novedad, por favor"
                                                Display="Dynamic" ControlToValidate="txtObservacionNovedad" ValidationGroup="registroNovedad"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                <td align="center">
                                        <br />
                                        <asp:LinkButton ID="lbRegistrar" runat="server" ValidationGroup="registroNovedad"
                                            CssClass="search"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="search"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvNovedades" runat="server" Width="100%" AutoGenerateColumns="false"
                                            ShowFooter="true" EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen seriales asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                            <Columns>
                                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia" />
                                                <asp:BoundField DataField="Serial" HeaderText="Serial" />
                                                <asp:BoundField DataField="Msisdn" HeaderText="MSISDN" />
                                            </Columns>
                                            <FooterStyle CssClass="field" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </ContentTemplate>
                    <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                    </FooterStyleActive>
                    <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;">
                    </HeaderStyleActive>
                    <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma">
                    </ContentStyleActive>
                    <BorderImages BottomBorder="00020305" RightBorder="00020307" TopRightCornerBottom="00020308"
                        TopRightCorner="00020309" LeftBorder="00020303" TopLeftCorner="00020301" BottomRightCorner="00020306"
                        TopLeftCornerBottom="00020302" BottomLeftCorner="00020304" TopBorder="00020310">
                    </BorderImages>
                </eo:Dialog>
            </eo:CallbackPanel>

        </asp:Panel>

    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    
    <dx:ASPxGridView ID="gvBase" runat="server" AutoGenerateColumns="True"
        Width="1px" ClientInstanceName="gvBase">
    </dx:ASPxGridView>

    </form>
</body>
</html>
