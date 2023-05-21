<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalizarServicio.aspx.vb"
    Inherits="BPColSysOP.LegalizarServicio" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Legalizar Servicios</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <script src="../include/FuncionesJS.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">

        function SeleccionarODesmarcarTodo(ctrl, targetName){
            $(".ckSeleccion input:not(:checked)").each(function(){
                if(!$(this).is(":disabled")){
                    var row = $(this).parent("span").parent("td").parent("tr");
                    var controlSeleccion = row.find('input[id*="chkSeleccion"]');
                    var controlLegalizaComcel = row.find('input[id*="chkLegalizaComcel"]');
                    var rfv = row.find('span[id*="rfvPlanilla"]');                     

                    if(ctrl.attr('checked')){
                        $(this).attr('checked','checked');
                        controlLegalizaComcel.removeAttr('checked');
                        controlLegalizaComcel.attr('disabled','disabled');
                        ValidatorEnable(document.getElementById(rfv.attr('id')),true);
                    }else{
                        $(this).removeAttr('checked');
                        controlLegalizaComcel.removeAttr('disabled');
                        ValidatorEnable(document.getElementById(rfv.attr('id')),false);
                    }
                }
            });
            
            $(".ckSeleccion input:checked").each(function(){
                if(!$(this).is(":disabled")){
                    var row = $(this).parent("span").parent("td").parent("tr");
                    var controlSeleccion = row.find('input[id*="chkSeleccion"]');
                    var controlLegalizaComcel = row.find('input[id*="chkLegalizaComcel"]');
                    var rfv = row.find('span[id*="rfvPlanilla"]');                     

                    if(ctrl.attr('checked')){
                        $(this).attr('checked','checked');
                        controlLegalizaComcel.removeAttr('checked');
                        controlLegalizaComcel.attr('disabled','disabled');
                        ValidatorEnable(document.getElementById(rfv.attr('id')),true);
                    }else{
                        $(this).removeAttr('checked');
                        controlLegalizaComcel.removeAttr('disabled');
                        ValidatorEnable(document.getElementById(rfv.attr('id')),false);
                    }
                }
            });
            
//            //$find(Loader).show();
//            var cont = 0;
//            var arrControl = document.getElementsByTagName("input");
//            for (i = 0; i < arrControl.length; i++) {
//                if (arrControl[i].type == "checkbox" && arrControl[i].name.indexOf(targetName) != -1 && arrControl[i].disabled == false) {
//                    arrControl[i].checked = ctrl.checked;
//                    cont += 1;
//                }
//            }
//            if (ctrl.checked) {
//                if (cont == 0) {
//                    alert("No se encontraron registros seleccionables. Por favor verifique");
//                    ctrl.checked = false;
//                }
//            }
//            //$find(Loader).hide();
        }

        function ValidarSeleccion(source, arguments) {
            var haySeleccion = false;
            try {
                var cont = 0;
                var arrControl = document.getElementsByTagName("input");
                for (i = 0; i < arrControl.length; i++) {
                    if (arrControl[i].type == "checkbox" && 
                        (arrControl[i].name.indexOf("chkSeleccion") != -1 || arrControl[i].name.indexOf("chkLegalizaComcel") != -1)
                        && arrControl[i].disabled == false && arrControl[i].checked == true) {
                        haySeleccion = true;
                        break;
                    }
                }
            } catch (e) {
                alert("Error al tratar de validar selección.\n" + e.description);
            }
            arguments.IsValid = haySeleccion;
        }

//        function ProcesarEnter() {
//            var btn = document.getElementById("lbBuscar");
//            var kCode = (event.keyCode ? event.keyCode : event.which);
//            if (kCode.toString() == "13") {
//                DetenerEvento(event)
//                btn.click();
//            }
//        }
       

        function OnCheckChangedEvent(objCheck){
            try{
                var row = objCheck.parent("span").parent("td").parent("tr");
                var controlSeleccion = row.find('input[id*="chkSeleccion"]');
                var controlLegalizaComcel = row.find('input[id*="chkLegalizaComcel"]');
                var rfv = row.find('span[id*="rfvPlanilla"]'); 
                
                switch(objCheck.parent("span").attr('class')){
                    case 'ckSeleccion':
                        if(objCheck.attr('checked')){
                            controlLegalizaComcel.removeAttr('checked');
                            controlLegalizaComcel.attr('disabled','disabled');
                            ValidatorEnable(document.getElementById(rfv.attr('id')),true);
                        }else{
                            controlLegalizaComcel.removeAttr('disabled');
                            ValidatorEnable(document.getElementById(rfv.attr('id')),false);
                        }
                        break;
                    case 'ckLegalizaComcel':
                        if(objCheck.attr('checked')){
                            controlSeleccion.removeAttr('checked');
                            controlSeleccion.attr('disabled','disabled');
                        }else{
                            controlSeleccion.removeAttr('disabled');
                        }
                        break;
                }
            }catch(e){
                alert(e.description);
            }
        }
        
    </script>

    <style type="text/css">
        .style1
        {
            background-color: #eee9e9;
            width: 1px;
        }
    </style>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <input id="hfPosFiltrado" type="hidden" value="0" runat="server" />
    <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
        <asp:HiddenField ID="hidIdReg" runat="server" />
        <uc1:EncabezadoPagina ID="epLegalizacionServicio" runat="server" />
    </eo:CallbackPanel>
    <eo:CallbackPanel ID="cpGeneral" runat="server" Width="100%" ChildrenAsTriggers="true"
        LoadingDialogID="ldrWait_dlgWait">
        <asp:Panel ID="panelLegalizacionServicio" runat="server">
            <table class="tablaGris" style="width: auto; height: auto">
                <tr>
                    <td colspan="4" style="text-align: center" class="thGris">
                        INGRESE LOS DATOS PARA LEGALIZACIÓN
                    </td>
                </tr>
                <tr valign="middle">
                    <td>
                        Tipo de Servicio:
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rblTipoServicio" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Text="Reposición" />
                            <asp:ListItem Value="2" Text="Venta" />
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="rfvrblTipoServicio" runat="server" ControlToValidate="rblTipoServicio"
                            ErrorMessage="Por favor seleccione un tipo de servicio" ValidationGroup="vgLegalizacion" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td class="field" align="left">
                        Número de Radicado:
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtNumeroRadicado" runat="server" TabIndex="1"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvNumeroRadicado" runat="server" ErrorMessage="Numero de Radicado Requerido"
                                Display="Dynamic" ControlToValidate="txtNumeroRadicado" ValidationGroup="vgLegalizacion"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                ControlToValidate="txtNumeroRadicado" ValidationGroup="vgLegalizacion" ErrorMessage="El número de radicado digitado no es válido, por favor verifique"
                                ValidationExpression="[0-9]{1,15}"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <br />
                        <br />
                        <asp:LinkButton ID="lbBuscar" runat="server" CssClass="search" Font-Bold="True" ValidationGroup="vgLegalizacion">
                                <img alt="Filtrar Pedido" src="../images/filtro.png" />Filtrar
                        </asp:LinkButton>
                        &nbsp;&nbsp;&nbsp;
                        <asp:LinkButton ID="lbQuitarFiltros" runat="server" CssClass="search" Font-Bold="True">
                                <img alt="Filtrar Pedido" src="../images/cancelar.png" />Quitar Filtros
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
            <br />
        </asp:Panel>
        
        <asp:Panel ID="pnlResultados" runat="server">
            <div style="margin-top: 10px; margin-bottom: 10px; position:absolute;  top: 130px; left: 500px;">
                <asp:Panel ID="pnlTipoServicioVenta" runat="server" Visible="false">
                    <dx:ASPxRoundPanel ID="rpTipoServioVenta" runat="server" HeaderText="Número de Contrato entregado">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtNumeroContrato" runat="server" Width="100px" /><br />
                                            <asp:RequiredFieldValidator ID="rfvtxtNumeroContrato" runat="server" ValidationGroup="vgRegistro" Display="Dynamic"
                                                ControlToValidate="txtNumeroContrato" ErrorMessage="Ingrese el número de contrato entregado"  Enabled="false"/>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </asp:Panel>
            </div>  

            <div style="clear:both"></div>
            
            <div style="margin-top: 10px; margin-bottom: 10px">
                <asp:LinkButton ID="lbGuardar" ValidationGroup="vgRegistro" CssClass="submit" runat="server"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>
                <asp:CustomValidator ID="cusSeleccion" runat="server" ValidationGroup="vgRegistro"
                    Display="Dynamic" ErrorMessage="Debe seleccionar por lo menos un registro a legalizar."
                    ClientValidationFunction="ValidarSeleccion"></asp:CustomValidator>
            </div>

            <dx:ASPxRoundPanel ID="rpLineasRadicado" runat="server" HeaderText="Lineas asociadas al número de radicado consultado">
                <PanelCollection>
                    <dx:PanelContent>
                        <div style="text-align: center; height: auto" class="thGris">
                            <b>Lineas asociadas al número de radicado consultado</b>
                            <asp:GridView ID="gvDatos" runat="server" AutoGenerateColumns="False" CssClass="grid"
                                EmptyDataRowStyle-CssClass="footerChildDG" EmptyDataRowStyle-Font-Size="14px"
                                EmptyDataText="No hay resultados" HeaderStyle-HorizontalAlign="Center" PageSize="50"
                                ShowFooter="True">
                                <PagerSettings Mode="NumericFirstLast" />
                                <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                <PagerStyle CssClass="field" HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                                <EmptyDataRowStyle CssClass="footerChildDG" Font-Size="14px" />
                                <Columns>
                                    <asp:BoundField DataField="iddetalle" Visible="true" HeaderText="ID" />
                                    <asp:TemplateField HeaderText="Selección">
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkTodos" runat="server" Text="Todos" AutoPostBack="false" Enabled="true"
                                                onclick="SeleccionarODesmarcarTodo($(this),'chkSeleccion');" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSeleccion" runat="server" AutoPostBack="false" CssClass="ckSeleccion"
                                                onclick="OnCheckChangedEvent($(this));"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Legaliza Comcel">
                                        <HeaderTemplate>
                                            <asp:Label ID="lbLegalizaComcel" runat="server" Text="Legaliza Comcel" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkLegalizaComcel" runat="server" AutoPostBack="false" CssClass="ckLegalizaComcel"
                                                onclick="OnCheckChangedEvent($(this));"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                    <asp:BoundField DataField="msisdn" HeaderText="Msisdn" />
                                    <asp:BoundField DataField="codigoCliente" Visible="false" HeaderText="Código Cliente" />
                                    <asp:TemplateField HeaderText="Número de Planilla">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtPlanilla" runat="server" Width="100px" MaxLength="10"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RequiredFieldValidator ID="rfvPlanilla" runat="server" ControlToValidate="txtPlanilla"
                                                    Display="Dynamic" ErrorMessage="Planilla requerida" ValidationGroup="vgRegistro"
                                                    Enabled="false"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revPlanilla" runat="server" Display="Dynamic"
                                                    ControlToValidate="txtPlanilla" ValidationGroup="vgRegistro" ErrorMessage="El n&uacute;mero de planilla digitado no es válido, por favor verifique"
                                                    ValidationExpression="[a-zA-Z0-9]{1,10}"></asp:RegularExpressionValidator>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Nuevo Msisdn">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNuevoMSISDN" runat="server" Width="100px" Enabled="false" MaxLength="10"></asp:TextBox>
                                            <div style="display: block">
                                                <asp:RegularExpressionValidator ID="revNumeroRadicado" runat="server" Display="Dynamic"
                                                    ControlToValidate="txtNuevoMSISDN" ValidationGroup="vgRegistro" ErrorMessage="El nuevo MSISDN no es válido"
                                                    ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Novedad">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlNovedad" runat="server">
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Legalizado">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEstado" runat="server" Text="" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </asp:Panel>
        <br />
        <asp:Panel ID="pnlErrores" runat="server">
            <table>
                <tr>
                    <td valign="top">
                        <div style="text-align: center">
                            <table>
                                <tr>
                                    <td colspan="3" style="text-align: center">
                                        <b>Log De Resultados</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvLegaliza" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="<div><blockquote><br/>No se encontraron registros.<br/></blockquote></div>"
                                            HeaderStyle-HorizontalAlign="Center" PageSize="20" AutoGenerateColumns="true">
                                            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                            <PagerStyle CssClass="pagerChildDG" />
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 100px">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <asp:GridView ID="gvErrores" runat="server" CssClass="grid" EmptyDataRowStyle-CssClass="footerChildDG"
                                            EmptyDataRowStyle-Font-Size="14px" EmptyDataText="<div><blockquote><br/>No se encontraron registros.<br/></blockquote></div>"
                                            HeaderStyle-HorizontalAlign="Center" PageSize="20" AutoGenerateColumns="true">
                                            <FooterStyle CssClass="footerChildDG" HorizontalAlign="Left" />
                                            <PagerStyle CssClass="pagerChildDG" />
                                            <HeaderStyle HorizontalAlign="Center" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </eo:CallbackPanel>
    <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
