<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionOrdenesRecoleccion.aspx.vb"
    Inherits="BPColSysOP.CreacionOrdenesRecoleccion" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Creación de Órdenes de Recolección</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function RefrescaUpdatePanel(objFiltro) {
            var filtro = objFiltro.value;
            var patron = new RegExp("^\s*[a-zA-Z_0-9 ,\s áéíóúÁÉÍÓÚ]+\s*$");
            if (patron.test(filtro)) {
                if (filtro.length > 3) {

                    $("input[name*='hfFlagFiltrado']").get(0).value = 1;
                    __doPostBack(objFiltro.id, '');
                    $find(ModalProgress).hide();
                    if (objFiltro.id == "txtEditFiltroMaterial") {
                        $get('txtEditFiltroMaterial').focus();
                        $get('txtEditFiltroMaterial').selectionStart = filtro.length;

                    }

                }
                else if (filtro.length <= 3 && $("input[name*='hfFlagFiltrado']").get(0).value == 1) {
                    __doPostBack(objFiltro.id, '');
                    $find(ModalProgress).hide();
                }
            }
            else if (objFiltro.value != "") { alert("los caracteres especiales no son permitidos") }
        }

        function ValidarSucursal(source, args) {
            if ($get("hfIdDestino").value == "")
                args.IsValid = false;
            if ($get("hfIdOrigen").value == "")
                args.IsValid = false;
        }

        function ValidarConsultaSucursal(source, args) {
            if (($get("ddlCiudad").value == "0") && ($get("txtCentro").value == "") && ($get("txtAlmacen").value == "") && ($get("txtCodigo").value == ""))
                args.IsValid = false;
        }

        function CallbackAfterUpdateHandler(callback, extraData) {
            try {
                MostrarOcultarDivFloater(false);
            } catch (e) {
                alert("Error al tratar de evaluar respuesta del servidor.\n" + e.description);
            }

        }

        function MostrarOcultarDivFloater(mostrar) {
            var valorDisplay = mostrar ? "block" : "none";
            var elDiv = document.getElementById("divFloater");
            elDiv.style.display = valorDisplay;
        }

        function FiltrarSucursal(idFiltro, idFlag, idCallbackPanel, parametro) {
            var filtro = document.getElementById(idFiltro).value.trim();
            var comboFiltrado = document.getElementById(idFlag).value;
            try {
                if (filtro.length >= 4 || (filtro.length < 4 && comboFiltrado == "1")) {
                    MostrarOcultarDivFloater(true);
                    eo_Callback(idCallbackPanel, parametro);
                    if (filtro.length >= 4) {
                        document.getElementById(idFlag).value = "1";
                    } else {
                        document.getElementById(idFlag).value = "0";
                    }
                }
                document.getElementById(idFiltro).focus();
            } catch (e) {
                MostrarOcultarDivFloater(false);
                alert("Error al tratar de filtrar Datos.\n" + e.description);
            }
        }

        function SeleccionOrigenDestinoEsValida(source, args) {
            try {

            } catch (e) {
                alert("Error al tratar de evaluar selección de Origen/Destino Recolección.\n" + e.description);
                args.IsValid = false;
            }
        }
    </script>

    <style type="text/css">
        .izquierda
        {
            float: left;
        }
        .margenColumnas
        {
            margin-right: 84px;
        }
        #divArchivo
        {
            width: 426px;
        }
    </style>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div style="font-style: italic">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc2:ModalProgress ID="ModalProgress1" runat="server" />
        <eo:CallbackPanel ID="cpNotificacion" runat="server" Width="98%" UpdateMode="Always">
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        </eo:CallbackPanel>
    </div>
    <div id="divFloater" style="display: none;">
        <table width="98%" align="center">
            <tr>
                <td style="width: 40px">
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loader_dots.gif" />
                </td>
                <td valign="middle">
                    <b>Procesando...</b>
                </td>
            </tr>
        </table>
    </div>
    <table class="tablaGris">
        <tr>
            <th colspan="4">
                Información General de la Orden de Recolección
            </th>
        </tr>
        <tr>
            <th colspan="4">
                Datos de Origen - Destino
            </th>
        </tr>
        <tr>
            <td class="field">
                Origen
            </td>
            <td colspan="3">
                <div style="display: inline">
                    <asp:TextBox ID="txtFiltroOrigen" runat="server" onkeyup="FiltrarSucursal(this.id,'hfIdOrigen','cpFiltroOrigen','filtrarOrigen');"
                        MaxLength="20"></asp:TextBox>&nbsp;-&nbsp;
                    <eo:CallbackPanel ID="cpFiltroOrigen" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                        Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle">
                        <asp:DropDownList ID="ddlOrigen" runat="server">
                        </asp:DropDownList>
                    </eo:CallbackPanel>
                </div>
                <asp:HiddenField ID="hfIdOrigen" runat="server" />
                <div style="display: block">
                    <asp:RequiredFieldValidator ID="rfvOrigen" runat="server" ErrorMessage="Campo Origen requerido. Seleccione un origen, por favor"
                        ControlToValidate="ddlOrigen" Display="Dynamic" ValidationGroup="guardar" 
                        InitialValue="0"></asp:RequiredFieldValidator>
                </div>
            </td>
        </tr>
        <tr>
            <td class="field">
                Destino
            </td>
            <td colspan="3">
                <div style="display: inline">
                    <asp:TextBox ID="txtFiltroDestino" runat="server" onkeyup="FiltrarSucursal(this.id,'hfIdDestino','cpFiltroDestino','filtrarDestino');"
                        MaxLength="20"></asp:TextBox>&nbsp;-&nbsp;
                    <eo:CallbackPanel ID="cpFiltroDestino" runat="server" UpdateMode="Self" ClientSideAfterUpdate="CallbackAfterUpdateHandler"
                        Style="display: inline; padding: 0px 0px opx 0px; vertical-align: middle">
                        <asp:DropDownList ID="ddlDestino" runat="server">
                        </asp:DropDownList>
                    </eo:CallbackPanel>
                </div>
                <asp:HiddenField ID="hfIdDestino" runat="server" />
                <div style="display: block">
                    <asp:RequiredFieldValidator ID="rfvDestino" runat="server" ErrorMessage="Campo Destino requerido. Seleccione un destino, por favor"
                        ControlToValidate="ddlDestino" Display="Dynamic" ValidationGroup="guardar" 
                        InitialValue="0"></asp:RequiredFieldValidator>
                </div>
            </td>
        </tr>
        <tr>
            <td class="field">
                Transportadora
            </td>
            <td>
                <asp:DropDownList ID="ddlTransportadora" runat="server" AutoPostBack="True">
                </asp:DropDownList>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlTransportadora"
                        Display="Dynamic" ErrorMessage="Debe proporcionar una transportadora" InitialValue="0"
                        ValidationGroup="guardar"></asp:RequiredFieldValidator></div>
            </td>
            <td class="field">
                Gu&iacute;a
            </td>
            <td>
                <asp:TextBox ID="txtGuia" runat="server" MaxLength="20"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="field">
                Orden de Servicio
            </td>
            <td>
                <asp:TextBox ID="txtOrdenServicio" runat="server" MaxLength="20"></asp:TextBox>
            </td>
            <td class="field">
                Observaci&oacute;n
            </td>
            <td>
                <asp:TextBox ID="txtObservacion" runat="server" MaxLength="20" TextMode="MultiLine"
                    Width="215px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <div style="display: block">
                    <asp:CustomValidator ID="cusValidarSeleccionOriDest" runat="server" ErrorMessage="El origen de la recolección no puede ser igual al destino de la misma. Por favor verifique"
                        ClientValidationFunction="SeleccionOrigenDestinoEsValida" ControlToValidate="ddlOrigen"
                        Display="Dynamic" ValidationGroup="guardar"></asp:CustomValidator>
                </div>
                <br />
                <center>
                    <asp:LinkButton ID="lnkGuardar" runat="server" CssClass="submit" ValidationGroup="guardar"
                        ForeColor="Blue">&nbsp;&nbsp;Guardar&nbsp;&nbsp;</asp:LinkButton></center>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <div class="thGris">
        <a style="cursor: pointer;"><b>1. Registro de Referencias y Seriales</b></a>
    </div>
     <div id="divZona1">
        <div style="width: 430px"  class="izquierda margenColumnas search">
            <div class="field">
                Carga de Archivo de Seriales</div>
            <div id="divArchivo">
                <blockquote>
                    <p>
                                                Formato del Archivo(texto.txt): SERIAL,MATERIAL,CAJA ABIERTA</p>
                </blockquote>
                <table class="tablaGris">
                    <tr>
                        <td class="field">
                            Archivo de Seriales
                        </td>
                        <td class="field">
                            <asp:FileUpload ID="FileUploadSeriales" runat="server" />
                            <div>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidatorfile" ValidationExpression=".+\.([Tt][Xx][Tt])"
                                    ControlToValidate="FileUploadSeriales" ValidationGroup="carga" runat="server"
                                    Display="Dynamic" ErrorMessage="El formato del archivo debe ser de texto (.txt)"></asp:RegularExpressionValidator></div>
                            <div>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorFile" ControlToValidate="FileUploadSeriales"
                                    ValidationGroup="carga" runat="server" ErrorMessage="Debe proporcionar un archivo para cargar"
                                    Display="Dynamic"></asp:RequiredFieldValidator></div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <center>
                                <p>
                                    <asp:LinkButton ID="lnkCargarSeriales" runat="server" ValidationGroup="carga"><img src="../images/upload.png" border="0" alt="Agregar a la Lista de Correos">Cargar Seriales</asp:LinkButton></p>
                            </center>
                        </td>
                    </tr>
                </table>
                <asp:GridView ID="gvErrores" runat="server" AutoGenerateColumns="False" CssClass="grid">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <img src="../images/exclamation.png" alt="warning" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField ItemStyle-HorizontalAlign="Center" DataField="lineaArchivo" HeaderText="Linea Archivo" />
                        <asp:BoundField DataField="serial" HeaderText="Serial" />
                        <asp:BoundField DataField="mensajeError" HeaderText="Material" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div  class="izquierda search ">
            <table class="tablaGris">
                <tr>
                    <td colspan="4" class="field">
                        Agregar Referencias de Forma Manual
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Producto
                    </td>
                    <td>
                        &nbsp;<asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlProductos" runat="server" AutoPostBack="True">
                                </asp:DropDownList>
                                <cc1:ListSearchExtender ID="ddlProductos_ListSearchExtender" runat="server" Enabled="True"
                                    TargetControlID="ddlProductos" PromptCssClass="listSearchTheme" PromptText="Digite para filtrar"
                                    QueryPattern="Contains">
                                </cc1:ListSearchExtender>
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorProducto" runat="server" ErrorMessage="Debe proporcionar un Producto"
                                        InitialValue="0" ValidationGroup="ref" Display="Dynamic" ControlToValidate="ddlProductos"></asp:RequiredFieldValidator></div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Material
                    </td>
                    <td>
                        <asp:HiddenField ID="hfFlagFiltrado" runat="server" />
                        <asp:TextBox ID="txtFiltroMaterial" runat="server" Width="100px" MaxLength="10" onkeyup="RefrescaUpdatePanel(this);"
                            OnTextChanged="FiltrarMaterial" Height="22px"></asp:TextBox>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlMaterial" runat="server" AutoPostBack="True">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMaterial" runat="server" ControlToValidate="ddlMaterial"
                                    Display="Dynamic" ErrorMessage="Debe seleccionar un Material" InitialValue="0"
                                    ValidationGroup="ref" CssClass="bloque"></asp:RequiredFieldValidator>
                                <div>
                                    <asp:Label ID="lblValorMaterial" runat="server" Visible="False" 
                                        CssClass="error">El material seleccionado no tiene valor asociado</asp:Label>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="txtFiltroMaterial" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Cantidad
                    </td>
                    <td>
                        <asp:TextBox ID="txtCantidad" runat="server" MaxLength="4"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCantidad" runat="server" ControlToValidate="txtCantidad"
                                ErrorMessage="Debe proporcionar una cantidad" ValidationGroup="ref" Display="Dynamic"></asp:RequiredFieldValidator></div>
                        <div>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorCantidad" runat="server"
                                ControlToValidate="txtCantidad" ErrorMessage="Digite únicamente números" ValidationExpression="\d+"
                                ValidationGroup="ref" Display="Dynamic"></asp:RegularExpressionValidator></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <p>
                            <asp:LinkButton ID="lnkAgregarReferencia" runat="server" ValidationGroup="ref"><img src="../images/add.png" border="0" alt="Agregar a la Lista de Correos">&nbsp;Agregar Referencia</asp:LinkButton>
                        </p>
                    </td>
                </tr>
            </table>
        </div>
        <div style="clear: both">
        <br />
            <div class="field">
                Referencias Agregadas
                
            </div>
            <asp:UpdatePanel ID="UpdatePanelMateriales" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td valign="top">
                                    <div id="divReferencias">
                                        <asp:GridView ID="gvMateriales" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                            Width="440px" CssClass="grid" EmptyDataText="<blockquote><p>No hay referencias agregadas</p></blockquote>"
                                            BorderStyle="None" DataKeyNames="material">
                                            <FooterStyle CssClass="footerChildDG" />
                                            <SelectedRowStyle BackColor="LightSteelBlue" />
                                            <AlternatingRowStyle CssClass="alterItemChildDG" />
                                            <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                                            <Columns>
                                                <asp:ButtonField CommandName="Select" DataTextField="material" HeaderText="Material"
                                                    Text="Select"></asp:ButtonField>
                                                <asp:BoundField DataField="referencia" HeaderText="Referencia"></asp:BoundField>
                                                <asp:BoundField DataField="cantidad" HeaderText="Cantidad"></asp:BoundField>
                                                <asp:TemplateField HeaderText="Eliminar">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="Lnkremover" CommandName="Eliminar" CommandArgument='<%# Bind("material") %>'
                                                            runat="server" CausesValidation="false" OnClientClick="return confirm('¿Desea eliminar esta referencia? se eliminaran los seriales que contenga');"
                                                            Text="Delete">
												<img 
                                                src="../images/eliminar.gif" 
                                                border="0" alt="Eliminar Referencia"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerStyle CssClass="pagerChildDG" />
                                        </asp:GridView>
                                    </div>
                                </td>
                                <td>
                                </td>
                                <td valign="top">
                                    <asp:LinkButton ID="lnkVerTodos" TabIndex="15" runat="server" Width="160px" CommandName="ver"><img src="../images/arrow_down2.gif" border="0" alt="Agregar Referencia">&nbsp;Ver todos los Seriales</asp:LinkButton>
                                    <asp:Panel ID="pnlSeriales" runat="server">
                                        <asp:Panel ID="pnlLectura" runat="server">
                                            <table class="tablaGris">
                                                <tr>
                                                    <td class="field">
                                                        Seriales Leidos
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblSerialesLeidos" runat="server" CssClass="ok">0</asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field">
                                                        Serial
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtSerial" runat="server"></asp:TextBox>
                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidatorSerial" runat="server"
                                                            ErrorMessage="&lt;br/&gt;El serial no tiene un formato válido" 
                                                            ControlToValidate="txtSerial" Display="Dynamic" ValidationGroup="agregarSerial"></asp:RegularExpressionValidator>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorSerial" runat="server" ErrorMessage="&lt;br/&gt;Debe Proporcionar un el serial"
                                                            ControlToValidate="txtSerial" Display="Dynamic" 
                                                            ValidationGroup="agregarSerial"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field">
                                                        <asp:CheckBox ID="chbxCajaAbierta" runat="server" Text="Caja Abierta" />
                                                    </td>
                                                    <td>
                                                        <asp:LinkButton ID="lnkAgregarSerial" runat="server" 
                                                            ValidationGroup="agregarSerial"><img src="../images/add.png" border="0" alt="Agregar Serial">&#160;Agregar Serial</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <asp:GridView ID="gvSeriales" runat="server" AutoGenerateColumns="False" Width="300px"
                                            DataKeyField="serial" ShowFooter="True" GridLines="None">
                                            <AlternatingRowStyle CssClass="alterItemChildDG" />
                                            <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                            <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
                                            </HeaderStyle>
                                            <FooterStyle CssClass="footerChildDG" />
                                            <Columns>
                                                <asp:BoundField DataField="serial" HeaderText="Serial"></asp:BoundField>
                                                <asp:BoundField DataField="material" HeaderText="Material"></asp:BoundField>
                                                <asp:CheckBoxField DataField="CajaVacia" HeaderText="Es Caja Abierta" />
                                                <asp:TemplateField HeaderText="Eliminar">
                                                    <HeaderStyle Width="10px" />
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkEliminar" runat="server" CausesValidation="false" CommandName="Eliminar"
                                                            CommandArgument='<%# Bind("serial") %>' Font-Size="7pt" Text="Delete">
												<img 
                                                src="../images/remove.png" 
                                                border="0" alt="Remover Serial"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerStyle CssClass="pagerChildDG" />
                                        </asp:GridView>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
        </div>
    </div>
    <asp:Panel ID="pnlAccesorios" runat = "server">
        <div class="thGris">
        <a style="cursor: pointer;"><b>2. Registro de Accesorios y Papeleria </b></a>
        </div>
        <table class="tablaGris">
                <tr>
                    <td class="field">
                        Articulo
                    </td>
                    <td>
                        <asp:TextBox ID="txtAccesorio" runat="server" Width="90%" MaxLength="50"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAccesorio" runat="server" ControlToValidate="txtAccesorio"
                                Display="Dynamic" ErrorMessage="Debe proporcionar el nombre del Item" ValidationGroup="acc"></asp:RequiredFieldValidator></div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Cantidad
                    </td>
                    <td>
                        <asp:TextBox ID="txtCantidadAccesorio" runat="server" MaxLength="4"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCantAccesorio" runat="server"
                                ControlToValidate="txtCantidadAccesorio" Display="Dynamic" ErrorMessage="Debe proporcionar la cantidad"
                                ValidationGroup="acc"></asp:RequiredFieldValidator></div>
                        <div>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCantidadAccesorio"
                                ErrorMessage="Digite únicamente números" ValidationExpression="\d+" ValidationGroup="acc"
                                Display="Dynamic"></asp:RegularExpressionValidator></div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Valor Total del
                        <div>
                            Articulo 
                        </div>
                    </td>
                    <td>
                        <asp:TextBox ID="txtValorArticulo" runat="server"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorValorAccesorio" runat="server"
                                ControlToValidate="txtValorArticulo" Display="Dynamic" ErrorMessage="Debe proporcionar el valor del articulo"
                                ValidationGroup="acc"></asp:RequiredFieldValidator></div>
                        <div>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtValorArticulo"
                                ErrorMessage="Digite únicamente números" ValidationExpression="\d+" ValidationGroup="acc"
                                Display="Dynamic"></asp:RegularExpressionValidator></div>
                    </td>
                </tr>
                <tr>
                    <td class="field">
                        Tipo de Articulo
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoArticulo" runat="server">
                        </asp:DropDownList>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorArticulo" runat="server" ErrorMessage="Debe seleccionar un Tipo de Articulo"
                                InitialValue="0" ValidationGroup="acc" Display="Dynamic" ControlToValidate="ddlTipoArticulo"></asp:RequiredFieldValidator></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:LinkButton ID="lnkAgregarAccesorio" runat="server" ValidationGroup="acc"><img src="../images/add.png" border="0" alt="Agregar Item">&nbsp;Agregar Item</asp:LinkButton>
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblAccesorioWarning" runat="server" CssClass="warning"></asp:Label>
            <div>
                <asp:GridView ID="gvAccesorios" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                    GridLines="None">
                    <FooterStyle CssClass="footerChildDG" />
                    <SelectedRowStyle BackColor="LightSteelBlue" />
                    <AlternatingRowStyle CssClass="alterItemChildDG" />
                    <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                    <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                    <Columns>
                        <asp:ButtonField CommandName="Select" DataTextField="articulo" HeaderText="Articulo">
                        </asp:ButtonField>
                        <asp:BoundField DataField="cantidadPedida" HeaderText="Cantidad">
                            <HeaderStyle Width="80px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="valorArticulo" HeaderText="Valor">
                            <HeaderStyle Width="80px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipoArticuloDescripcion" HeaderText="Tipo Articulo">
                            <HeaderStyle Width="80px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Eliminar">
                            <ItemTemplate>
                                <asp:LinkButton ID="Lnkremover" runat="server" CausesValidation="false" CommandName="Eliminar"
                                    CommandArgument='<%# Bind("idAccesorio") %>' Text="Delete">
												    <img 
                                                    src="../images/eliminar.gif" 
                                                    border="0" alt="Eliminar Referencia"></asp:LinkButton>
                            </ItemTemplate>
                            <HeaderStyle Width="80px" />
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagerChildDG" />
                </asp:GridView>
            </div>
       </asp:Panel>
    <br />
    </form>
</body>
</html>
