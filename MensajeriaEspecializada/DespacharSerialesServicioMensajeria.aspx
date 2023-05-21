<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DespacharSerialesServicioMensajeria.aspx.vb"
    Inherits="BPColSysOP.DespacharSerialesServicioMensajeria" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioMensajeria.ascx" TagName="EncabezadoSM"
    TagPrefix="esm" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoServicioTipoVenta.ascx" TagName="EncabezadoSMTV"
    TagPrefix="esmtv" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Despachar Seriales - Servicio Mensajeria</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2" onload="GetWindowSize();">

    <form id="form1" runat="server">

        <script src="../include/FuncionesJS.js" type="text/javascript"></script>
        <script src="../include/jquery-1.js" type="text/javascript"></script>
        <script src="../include/jquery.purr.js" type="text/javascript"></script>

        <script language="javascript" type="text/javascript">
            String.prototype.trim = function () { return this.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g, ""); }

            function ProcesarEnter(boton) {

                var btn = document.getElementById(boton);
                var kCode = (event.keyCode ? event.keyCode : event.which);
                if (kCode.toString() == "13") {
                    DetenerEvento(event)
                    btn.click();
                }
            }

            function CallbackAfterUpdateHandler(callback, extraData) {
                try {
                    MostrarOcultarDivFloater(false);
                    var tgId = callback.getEventTarget();
                    if (tgId == "btnRegistrar") {
                        var txt = document.getElementById("txtSerial");
                        if (txt) {
                            if (!txt.disabled) { txt.select(); }
                        }
                    }
                } catch (e) {
                    alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
                }
            }

            function MostrarOcultarDivFloater(mostrar) {
                var valorDisplay = mostrar ? "block" : "none";
                var elDiv = document.getElementById("divFloater");
                elDiv.style.display = valorDisplay;
            }

            function FiltrarMateriales(ctrlFiltro) {
                var filtro = ctrlFiltro.value;
                var hfFlagComboFiltrado = document.getElementById("<%=hfFlagFiltroMaterial.ClientID %>");
                try {
                    if (filtro.length >= 4 || (filtro.length < 4 && hfFlagComboFiltrado.value == "1")) {
                        MostrarOcultarDivFloater(true);
                        document.getElementById("__EVENTTARGET").value = "";
                        document.getElementById("__EVENTARGUMENT").value = "";
                        eo_Callback("<%= cpFiltroMaterial.ClientID%>", "filtrarMaterial");
                        if (filtro.length >= 4) {
                            hfFlagComboFiltrado.value = "1";
                        } else {
                            hfFlagComboFiltrado.value = "0";
                        }
                    }
                    ctrlFiltro.focus();
                } catch (e) {
                    MostrarOcultarDivFloater(false);
                    alert("Error al tratar de filtrar Datos.\n" + e.description);
                }
            }

            function GetWindowSize() {
                var myWidth = 0, myHeight = 0;
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

            function ConfirmarEliminacion() {
                Page_ClientValidate('eliminacionSerial');
                if (Page_IsValid) {
                    return confirm('¿Realmente desea desvincular el serial?');
                }
                return Page_IsValid;
            }

            function ValidarCantidadActualizar(source, args) {
                var cantidadPedida = document.getElementById("<%= txtCantidad.ClientID%>").value;
                var cantidadLeida = document.getElementById("<%= txtCantidadLeida.ClientID%>").value;
                cantidadPedida = (cantidadPedida != "" ? parseInt(cantidadPedida) : 0)
                cantidadLeida = (cantidadLeida != "" ? parseInt(cantidadLeida) : 0)
                try {
                    if (cantidadPedida > 0) {
                        if (cantidadPedida >= cantidadLeida) {
                            args.IsValid = true;
                        } else {
                            args.IsValid = false;
                        }
                    } else {
                        args.IsValid = false;
                    }
                } catch (e) {
                    alert("Error al tratar de validar cantidades.\n" + e.description);
                    args.IsValid = false;
                }
            }


            function VisualizarTransportadora(ver) {
                if(ver) {
                    $('#divEntrega').css("display", 'none');
                } else {
                    $('#divEntrega').css("display", 'inline');
                }
                ValidatorEnable(document.getElementById('rfvNumeroGuia'), !ver);
                ValidatorEnable(document.getElementById('rfvTransportadora'), !ver);
            }
    </script>

    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        <asp:HiddenField ID="hfMedidasVentana" runat="server" />
    </eo:CallbackPanel>
    <asp:Panel ID="pnlGeneral" runat="server">
        
        <asp:PlaceHolder ID="phEncabezado" runat="server"></asp:PlaceHolder>

        <table class="tabla" style="width: 95%">
            <tr>
                <td colspan="6">
                    <br />
                    <eo:CallbackPanel ID="cpCierre" runat="server" UpdateMode="Always" Width="100%" LoadingDialogID="ldrWait_dlgWait">
                        <div style="float: left; margin-right: 20px">
                            <asp:LinkButton ID="lbCerrar" runat="server" CssClass="search" Enabled="False" ValidationGroup="vgEntrega">
                                <img src="../images/save_all.png" alt="" />&nbsp;Cerrar Despacho
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbMostrarFormNovedad" runat="server" CssClass="search" Font-Bold="True"
                                CausesValidation="false"> 
                                <img alt="Adicionar Novedad" src="../images/notepad.gif" />&nbsp;Adicionar Novedad 
                            </asp:LinkButton>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:CheckBox ID="cbEntegaAgente" runat="server" Text="Entrega Agente de Servicio" 
                                Checked="true" OnClick="VisualizarTransportadora(this.checked);">
                            </asp:CheckBox>
                        </div>
                        
                        <div id="divEntrega" style="display:none; float: left; margin: 10px">
                            <table class="tabla">
                                <tr>
                                    <td class="field">Número de Guia:</td>
                                    <td>
                                        <asp:TextBox ID="txtNumeroGuia" runat="server" Width="100px" MaxLength="15">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvNumeroGuia" runat="server" ControlToValidate="txtNumeroGuia"
                                            ErrorMessage="El número de guía es requerido" Display="Dynamic" ValidationGroup="vgEntrega" 
                                            Enabled="false">
                                        </asp:RequiredFieldValidator>
                                    </td>
                                    <td class="field">Transportadora:</td>
                                    <td>
                                        <asp:DropDownList ID="ddlTransportadora" runat="server">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvTransportadora" runat="server" ControlToValidate="ddlTransportadora"
                                            ErrorMessage="La transportadora es requerida" Display="Dynamic" ValidationGroup="vgEntrega"
                                            Enabled="false" InitialValue="-1">
                                        </asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </table>
                        </div>

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
                </td>
            </tr>
        </table>

        <br />
        <eo:CallbackPanel ID="cpLectura" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" ClientSideAfterUpdate="CallbackAfterUpdateHandler">
            <table class="tabla" style="width: 95%">
                <tr>
                    <td style="width: 45%" valign="top">
                        <asp:Panel ID="pnlLectura" runat="server">
                            <table>
                                <tr>
                                    <th colspan="2">
                                        LECTURA DE SERIALES
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Serial:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSerial" runat="server" onkeydown="ProcesarEnter('btnRegistrar');"
                                            Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvSerial" runat="server" ErrorMessage="Digite el serial a registrar, por favor"
                                                Display="Dynamic" ValidationGroup="lecturaSerial" ControlToValidate="txtSerial"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="revSerial" runat="server" ErrorMessage="El serial digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtSerial" ValidationGroup="lecturaSerial"
                                                ValidationExpression="[0-9a-zA-Z;]{9,25}"></asp:RegularExpressionValidator>
                                        </div>
                                        <br />
                                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="search" ValidationGroup="lecturaSerial" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <br />
                        <br />
                        <br />
                        <asp:Panel ID="pnlEliminacion" runat="server">
                            <table>
                                <tr>
                                    <th colspan="2">
                                        DESVINCULACI&Oacute;N DE SERIALES
                                    </th>
                                </tr>
                                <tr>
                                    <td class="field">
                                        Serial:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSerialEliminar" runat="server" onkeydown="ProcesarEnter('btnEliminarSerial');"
                                            Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="display: block">
                                            <asp:RequiredFieldValidator ID="rfvSerialEliminar" runat="server" ErrorMessage="Digite el serial a desvincular, por favor"
                                                Display="Dynamic" ValidationGroup="eliminacionSerial" ControlToValidate="txtSerialEliminar"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="revSerialEliminar" runat="server" ErrorMessage="El serial digitado no es válido"
                                                Display="Dynamic" ControlToValidate="txtSerialEliminar" ValidationGroup="eliminacionSerial"
                                                ValidationExpression="[0-9a-zA-Z;]{9,25}"></asp:RegularExpressionValidator>
                                        </div>
                                        <br />
                                        <asp:Button ID="btnEliminarSerial" runat="server" Text="Registrar" CssClass="search"
                                            ValidationGroup="eliminacionSerial" OnClientClick="javascript: return ConfirmarEliminacion();" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 45%" valign="top">
                        <div style="display: block; padding-bottom: 3px; margin: 5px;">
                            <asp:LinkButton ID="lbVerSeriales" runat="server" CssClass="search">
                                <img src="../images/view.png" alt=""/>&nbsp;Ver Seriales
                            </asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lbAdicionarReferencia" runat="server" CssClass="search" Font-Bold="True"
                                CausesValidation="false"> 
                                <img alt="Adicionar referencia" src="../images/add.png" />&nbsp;Adicionar Referencia
                            </asp:LinkButton>
                        </div>
                        <asp:GridView ID="gvListaReferencias" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen referencias asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="Material" HeaderText="Material" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="DescripcionMaterial" HeaderText="Referencia Solicitada" />
                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="CantidadLeida" HeaderText="Cantidad Le&iacute;da" ItemStyle-HorizontalAlign="Center" />
                                <asp:TemplateField HeaderText="Opciones">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibEditar" runat="server" CommandName="editar" CommandArgument='<%# Bind("idMaterialServicio") %>'
                                            ToolTip="Editar" ImageUrl="~/images/Edit-32.png" />&nbsp;&nbsp;
                                        <asp:ImageButton ID="ibEliminar" runat="server" CommandName="eliminar" CommandArgument='<%# Bind("idMaterialServicio") %>'
                                            ToolTip="Eliminar" ImageUrl="~/images/Delete-32.png" OnClientClick="return confirm('¿Realmente desea eliminar el material?');" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:GridView ID="gvListaMsisdn" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen MSISDNs asignados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="msisdn" HeaderText="MSISDN" />
                                <asp:BoundField DataField="activaEquipoAnteriorTexto" HeaderText="Activar Equipo Anterior (S/N)"
                                    ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="comseguroTexto" HeaderText="Comseguro (S/N)" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="precioConIva" HeaderText="Precio Con Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="precioSinIva" HeaderText="Precio Sin Iva" DataFormatString="{0:c}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="clausula" HeaderText="Clausula" />
                                <asp:TemplateField HeaderText="Disponibilidad">
                                <ItemTemplate>
                                    <asp:Image ID="imgBloquear" ImageUrl="~/images/BallGreen.gif" runat="server" />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <eo:Dialog runat="server" ID="dlgEdicionReferencia" ControlSkinID="None" Height="350px"
                HeaderHtml="Actualizaci&oacute;n de Referencia" CloseButtonUrl="00020312" BackColor="White"
                BackShadeColor="Gray" BackShadeOpacity="50" CancelButton="lbCancelarActRef" EnableKeyboardNavigation="True">
                <ContentTemplate>
                    <div id="divFloater" style="display: none; position: static; height: 35px; width: 200px;">
                        <table align="center">
                            <tr>
                                <td align="center" valign="middle" style="height: 100%">
                                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" ImageAlign="Middle" />
                                    <b>Procesando...</b>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:Panel ID="pnlEdicionMaterial" runat="server" Style="height: 100%; width: 100%;
                        overflow: auto;">
                        <table class="tabla" align="center">
                            <tr>
                                <th colspan="2">
                                    Informaci&oacute;n de la Referencia
                                </th>
                            </tr>
                            <tr>
                                <td class="field">
                                    Referencia:
                                </td>
                                <td>
                                    <table>
                                        <tr>
                                            <td valign="middle">
                                                <asp:TextBox ID="txtFiltroMaterial" runat="server" CssClass="textbox" MaxLength="50"
                                                    onkeyup="FiltrarMateriales(this);" Width="150px" Style="display: inline !important;"></asp:TextBox>&nbsp;-&nbsp;
                                            </td>
                                            <td valign="middle">
                                                <eo:CallbackPanel ID="cpFiltroMaterial" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                                                    Style="display: inline !important; padding: 0px 0px 0px 0px; vertical-align: middle"
                                                    Width="100%">
                                                    <asp:DropDownList ID="ddlMaterial" runat="server" Style="display: inline;">
                                                    </asp:DropDownList>
                                                    <div style="display: block">
                                                        <asp:Label ID="lblMateriales" runat="server" CssClass="comentario"></asp:Label>
                                                    </div>
                                                </eo:CallbackPanel>
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="display: block">
                                        <asp:RequiredFieldValidator ID="rfvMaterial" runat="server" ErrorMessage="La referencia solicitada es requerida"
                                            ControlToValidate="ddlMaterial" Display="Dynamic" InitialValue="0" ValidationGroup="vgReferencia"></asp:RequiredFieldValidator>
                                    </div>
                                    <asp:HiddenField ID="hfFlagFiltroMaterial" runat="server" Value="0" />
                                </td>
                            </tr>
                            <tr>
                                <td class="field">
                                    Cantidad Le&iacute;da:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCantidadLeida" runat="server" Width="100px" Enabled="false"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="field">
                                    Cantidad:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCantidad" runat="server" Width="100px" ValidationGroup="vgReferencia"
                                        MaxLength="4"></asp:TextBox>
                                    <div style="display: block">
                                        <asp:RequiredFieldValidator ID="rfvtxtCantidad" runat="server" ControlToValidate="txtCantidad"
                                            Display="Dynamic" ErrorMessage="La Cantidad es requerida" ValidationGroup="vgReferencia" />
                                        <asp:RegularExpressionValidator ID="revtxtCantidad" runat="server" Display="Dynamic"
                                            ControlToValidate="txtCantidad" ValidationGroup="vgReferencia" ErrorMessage="La cantidad debe ser numérica."
                                            ValidationExpression="[0-9]{1,3}"></asp:RegularExpressionValidator>
                                        <asp:CustomValidator ID="cusCantidad" runat="server" ErrorMessage="La cantidad pedida del material debe ser mayor que cero (0) y no puede ser menor que la cantidad le&iacute;da"
                                            ControlToValidate="txtCantidad" Display="Dynamic" ClientValidationFunction="ValidarCantidadActualizar"
                                            ValidationGroup="vgReferencia"></asp:CustomValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <br />
                                    <div style="display: inline">
                                        <asp:LinkButton ID="lbRegistrarReferencia" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgReferencia" CausesValidation="true"> <img alt="Registrar referencia" src="../images/add.png" />&nbsp;Registrar</asp:LinkButton>
                                    </div>
                                    <asp:Panel ID="pnlBotonEdicionReferencia" runat="server" Style="display: inline;">
                                        <asp:LinkButton ID="lbActualizarRef" runat="server" CssClass="search" Font-Bold="True"
                                            ValidationGroup="vgReferencia" CausesValidation="true"> <img alt="Actualizar Referencia" src="../images/save_all.png" />&nbsp;Actualizar </asp:LinkButton>&nbsp;&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbCancelarActRef" runat="server" CssClass="search" Font-Bold="True"
                                            CausesValidation="false"> <img alt="Cancelar Actualizaci&oacute;n" src="../images/cancelar.png" />&nbsp;Cancelar </asp:LinkButton>
                                        <br />
                                    </asp:Panel>
                                    <asp:HiddenField ID="hfMaterialAct" runat="server" />
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
        </eo:CallbackPanel><br />
        <eo:CallbackPanel ID="cpNovedad" runat="server" Width="100%" LoadingDialogID="ldrWait_dlgWait"
            ChildrenAsTriggers="true" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
            UpdateMode="Self" Triggers="{ControlID:lbMostrarFormNovedad;Parameter:}">
            <table class="tabla">
                <tr>
                    <td>
                        <asp:GridView ID="gvNovedad" runat="server" Width="100%" AutoGenerateColumns="false"
                            EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                            <Columns>
                                <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                    DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                            </Columns>
                            <AlternatingRowStyle CssClass="alterColor" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <eo:Dialog runat="server" ID="dlgNovedad" ControlSkinID="None" Height="350px" HeaderHtml="Adici&oacute;n de Novedades"
                CloseButtonUrl="00020312" BackColor="White" CancelButton="lbCerrarPopUp" BackShadeColor="Gray"
                BackShadeOpacity="50">
                <ContentTemplate>
                    <table align="center" class="tabla">
                        <tr>
                            <th colspan="2">
                                INFORMACI&Oacute;N DE LA NOVEDAD
                            </th>
                        </tr>
                        <tr>
                            <td class="field">
                                Seleccione tipo de Novedad:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlTipoNovedad" runat="server" ValidationGroup="registroNovedad">
                                </asp:DropDownList>
                                <div style="display: block;">
                                    <asp:RequiredFieldValidator ID="rfvTipoNovedad" runat="server" ErrorMessage="Seleccione un tipo de novedad"
                                        Display="Dynamic" ControlToValidate="ddlTipoNovedad" ValidationGroup="registroNovedad"
                                        InitialValue="0"></asp:RequiredFieldValidator>
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
                                <asp:LinkButton ID="lbRegistrarNovedad" runat="server" ValidationGroup="registroNovedad"
                                    CssClass="submit"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="submit"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
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
    <uc2:Loader ID="ldrWait" runat="server" />

    <script language="javascript" type="text/javascript">
        function CambiarEnfoque() {
            var ctrl = document.getElementById("txtSerial");
            if (ctrl != null) {
                if (!ctrl.disabled) { ctrl.select(); }
            }
        }
        window.setTimeout("CambiarEnfoque()", 10)

        function MostrarDocumentos(titulo, mensaje) {
            var notice = '<div class="notice">'
                            + '<div class="notice-body">'
							+ '<img src="../images/info.png" alt="" />'
							+ '<h3>' + titulo + '</h3>'
							+ '<p>' + mensaje + '</p>'
							+ '</div>'
							+ '<div class="notice-bottom">'
							+ '</div>'
							+ '</div>';

            $(notice).purr(
							{
							    usingTransparentPNG: true,
                                isSticky: true
							});
            return false;
        }
    </script>

    </form>
</body>
</html>
