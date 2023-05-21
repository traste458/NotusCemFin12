<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionServicioTecnico.aspx.vb" Inherits="BPColSysOP.GestionServicioTecnico" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Gestión Servicio Técnico - Mensajería Especializada</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function validarAceptaCosto(objeto) {
            try {
                var row = objeto.parent("td").parent("tr");
                var controlGeneraCosto = row.find('select[id*="ddlCosto"]');
                if (controlGeneraCosto.val() == 'No' && objeto.val() == 'Si') {
                    objeto.val('No');
                    alert("Si no se genera costo, el cliente no lo puede aceptar.");
                }
            } catch (e) {
                alert("Error a tratar de validar costos.\n" + e.description);
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <asp:ScriptManager ID="ScriptManager" runat="server">
        </asp:ScriptManager>
        
        <eo:CallbackPanel ID="cpNotificacion" runat="server" UpdateMode="Always" Width="100%">
            <asp:UpdatePanel ID="upEncabezado" runat="server">
                <ContentTemplate>
                    <uc1:EncabezadoPagina ID="epNotificacion" runat="server" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="pnlGeneral" runat="server" LoadingDialogID="ldrWait_dlgWait" 
            GroupName="general" ChildrenAsTriggers="true" Width="100%">
            
            <asp:Panel ID="PanelServicio" runat="server">
                <table class="tabla">
                    <tr>
                        <th colspan="6">
                            INFORMACI&Oacute;N DEL SERVICIO
                        </th>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div style="display: block">
                                <font face="Bar-Code 39" size="4">
                                    <asp:Label ID="lblCodigoRadicado" runat="server" Font-Names="Bar-Code 39"></asp:Label>
                                </font>
                            </div>
                            <b>No. Radicado:</b>&nbsp;<asp:Label ID="lblNumRadicado" runat="server" Text=""></asp:Label>
                        </td>
                        <td colspan="3">
                            <b>Ejecutor:</b>&nbsp;<asp:Label ID="lblEjecutor" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <asp:Label ID="lblTipoServicio" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </td>
                        <td class="field">
                            Estado:
                        </td>
                        <td colspan="6">
                            <asp:Label ID="lblEstado" runat="server" Text="" Font-Bold="true" Font-Size="Small"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Nombre Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblNombreCliente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            C&eacute;dula/Nit:
                        </td>
                        <td>
                            <asp:Label ID="lblIdentificacion" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Direcci&oacute;n Correspondencia:
                        </td>
                        <td>
                            <asp:Label ID="lblDireccion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Barrio:
                        </td>
                        <td>
                            <asp:Label ID="lblBarrio" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Ciudad donde se encuentra Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblCiudad" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Tel&eacute;fono de Contacto:
                        </td>
                        <td>
                            <asp:Label ID="lblTelefono" runat="server" Text=""></asp:Label>
                            <asp:Label ID="lblExtension" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Persona de Contacto (Autorizado):
                        </td>
                        <td>
                            <asp:Label ID="lblPersonaContacto" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Agendamiento:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaAgenda" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Jornada:
                        </td>
                        <td>
                            <asp:Label ID="lblJornada" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha de Registro:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRegistro" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Registrado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblRegistradoPor" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Prioridad:
                        </td>
                        <td>
                            <asp:Label ID="lblPrioridad" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha Confirmacion:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaConfirmacion" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Confirmado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblUsuarioConfirma" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Bodega CME:
                        </td>
                        <td>
                            <asp:Label ID="lblBodega" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha Despacho:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaDespacho" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Despachado Por:
                        </td>
                        <td>
                            <asp:Label ID="lblUsuarioDespacho" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Cambio Servicio:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaCambioServicio" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Zona:
                        </td>
                        <td>
                            <asp:Label ID="lblZona" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Responsable Entrega:
                        </td>
                        <td>
                            <asp:Label ID="lblResponsableEntrega" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Entrega:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaEntrega" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Observaciones:
                        </td>
                        <td colspan="5">
                            <asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
                <br />
                <table class="tabla" style="width: 95%;" cellpadding="3">
                    <tr>
                        <td style="margin-right:15px">
                            <asp:GridView ID="gvDatos" runat="server" AutoGenerateColumns="false" CssClass="grid" DataKeyNames="idDetalle"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se encontraron IMEIS asociados al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <AlternatingRowStyle CssClass="alterColor" />
                                <FooterStyle CssClass="footer" />
                                <Columns>
                                    <asp:BoundField DataField="idDetalle" HeaderText="ID" />
                                    <asp:BoundField DataField="serial" HeaderText="IMEI" />
                                    <asp:TemplateField HeaderText="ODS" ItemStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtODS" runat="server" Width="100px" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Gestiones" ItemStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ibGestion" runat="server" CommandName="gestion" CommandArgument='<%# Bind("idDetalle") %>'
                                                ImageUrl="../images/management.png" ToolTip="Ver/Adicionar Gestiones" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="¿Genera Costo?" ItemStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlCosto" runat="server" />                                            
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="¿Cliente acepta costo?" ItemStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlAceptaCosto" runat="server" onChange="validarAceptaCosto($(this))" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Fecha de Entrega" ItemStyle-HorizontalAlign="Center" >
                                        <ItemTemplate>
                                            <eo:DatePicker ID="dpFechaEntrega" runat="server" PickerFormat="dd/MM/yyyy"
                                                ControlSkinID="None" CssBlock="&lt;style type=&quot;text/css&quot;&gt;
                                            .DatePickerStyle1 {background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                                            .DatePickerStyle2 {border-bottom-color:#f5f5f5;border-bottom-style:solid;border-bottom-width:1px;font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle3 {font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle4 {background-image:url('00040402');color:#1c7cdc;font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle5 {background-image:url('00040401');color:#1176db;font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle6 {color:gray;font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle7 {cursor:pointer;cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px}
                                            .DatePickerStyle8 {background-image:url('00040403');color:Brown;font-family:Verdana;font-size:8pt}
                                            .DatePickerStyle9 {cursor:pointer;cursor:hand}
                                            .DatePickerStyle10 {font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px}
                                                &lt;/style&gt;" DayCellHeight="15" DayCellWidth="31" DayHeaderFormat="Short"
                                                DisabledDates="" OtherMonthDayVisible="True" SelectedDates="" TitleFormat="MMMM, yyyy"
                                                TitleLeftArrowImageUrl="DefaultSubMenuIconRTL" TitleRightArrowImageUrl="DefaultSubMenuIcon"
                                                AllowMultiSelect="False">
                                                <TodayStyle CssClass="DatePickerStyle5" />
                                                <SelectedDayStyle CssClass="DatePickerStyle8" />
                                                <DisabledDayStyle CssClass="DatePickerStyle6" />
                                                <FooterTemplate>
                                                    <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                                        <tr>
                                                            <td width="30">
                                                            </td>
                                                            <td valign="center">
                                                                <img src="{img:00040401}"></img>
                                                            </td>
                                                            <td valign="center">
                                                                Today: {var:today:dd/MM/yyyy}
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </FooterTemplate>
                                                <CalendarStyle CssClass="DatePickerStyle1" />
                                                <TitleArrowStyle CssClass="DatePickerStyle9" />
                                                <DayHoverStyle CssClass="DatePickerStyle4" />
                                                <MonthStyle CssClass="DatePickerStyle7" />
                                                <TitleStyle CssClass="DatePickerStyle10" />
                                                <DayHeaderStyle CssClass="DatePickerStyle2" />
                                                <DayStyle CssClass="DatePickerStyle3" />
                                            </eo:DatePicker>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:LinkButton ID="ibActualizarSeriales" runat="server" CssClass="search" Font-Bold="true"
                                OnClientClick="return confirm('¿Está seguro que desea actualizar la información del IMEI?')">
                                <img src="../images/save_all.png" alt="Actualizar Información" />&nbsp;Actualizar Información
                            </asp:LinkButton>
                        </td>
                    </tr>
                    
                    <tr>
                        <td>
                            <asp:GridView ID="gvNovedad" runat="server" Width="100%" AutoGenerateColumns="false" CssClass="grid"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen Novedades asignadas al servicio&lt;/i&gt;&lt;/blockquote&gt;">
                                <AlternatingRowStyle CssClass="alterColor" />
                                <FooterStyle CssClass="footer" />
                                <Columns>
                                    <asp:BoundField DataField="TipoNovedad" HeaderText="Tipo de Novedad" />
                                    <asp:BoundField DataField="UsuarioRegistra" HeaderText="Registrada Por" />
                                    <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha de Registro" ItemStyle-HorizontalAlign="Center"
                                        DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="ComentarioEspecifico" HeaderText="Comentario Espec&iacute;fico" />
                                    <asp:BoundField DataField="observacion" HeaderText="Comentario General" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </eo:CallbackPanel>
        
        <eo:CallbackPanel ID="cpGestiones" runat="server" Width="100%" UpdateMode="Group"
            GroupName="general" LoadingDialogID="ldrWait_dlgWait" >
            
            <eo:Dialog runat="server" ID="dlgAdicionarGestion" ControlSkinID="None" Height="300px"
                HeaderHtml="Adicionar Gestión" CloseButtonUrl="00020312" BackColor="White"
                BackShadeColor="Gray" BackShadeOpacity="50" CancelButton="lbCancelarGestion"
                Width="500px">
                <ContentTemplate>
                    <asp:Panel ID="pnlAuxiliar" runat="server" Style="height: 100%; width: 100%;
                        overflow: auto;">
                        <table class="tabla" cellpadding="2" cellspacing="2" style="float:left; margin-right:15px">
                            <tr>
                                <th colspan="2">Ingrese los datos de la gestión realizada</th>
                            </tr>
                            <tr>
                                <td class="field">Id:</td>
                                <td><asp:Label ID="lbIdDetalleSerial" runat="server" /></td>
                            </tr>
                            <tr>
                                <td class="field">Gestión:</td>
                                <td>
                                    <asp:TextBox ID="txtObservacion" runat="server" TextMode="MultiLine" Rows="5" />
                                </td>
                            </tr>
                        </table>
                        <table style="float:left;">
                            <tr>
                                <td align="center">
                                    <br />
                                    <asp:LinkButton ID="lbGuardarGestion" runat="server" CssClass="search"><img src="../images/save_all.png" alt=""/>&nbsp;Guardar Gestión</asp:LinkButton>
                                </td>
                            </tr>
                            
                            <tr>
                                <td align="center">
                                    <br />
                                    <asp:LinkButton ID="lbCancelarGestion" runat="server" CssClass="search"><img src="../images/close.png" alt=""/>&nbsp;Cancelar</asp:LinkButton>
                                </td>
                            </tr>
                            
                            <tr>
                                <td align="center">
                                    <br />
                                    <br />
                                    <br />
                                    <asp:LinkButton ID="lbAdicionarNovedad" runat="server" CssClass="search"><img src="../images/notepad.gif" alt=""/>&nbsp;Adicionar Novedad</asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                        
                        <div style="clear:both">
                            <br />
                            <br />
                            <asp:GridView ID="gvGestiones" runat="server" Width="100%" AutoGenerateColumns="false" CssClass="grid"
                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No existen gestiones asignadas al IMEI&lt;/i&gt;&lt;/blockquote&gt;">
                                <AlternatingRowStyle CssClass="alterColor" />
                                <FooterStyle CssClass="footer" />
                                <Columns>
                                    <asp:BoundField DataField="fecha" HeaderText="Fecha" ItemStyle-HorizontalAlign="Center"
                                        DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                                    <asp:BoundField DataField="observacion" HeaderText="Gestión" />
                                    <asp:BoundField DataField="nombreUsuario" HeaderText="Registrada Por" />
                                </Columns>
                            </asp:GridView>
                        </div>
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
        
        <eo:CallbackPanel ID="cpNovedades" runat="server" Width="100%" UpdateMode="Group"
            GroupName="general" LoadingDialogID="ldrWait_dlgWait">
            
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
                            <td align="center" colspan ="2">
                                <br />
                                <asp:LinkButton ID="lbRegistrarNovedad" runat="server" ValidationGroup="registroNovedad"
                                    CssClass="search"><img src="../images/save_all.png" alt="" />&nbsp;Registrar</asp:LinkButton>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lbCerrarPopUp" runat="server" CssClass="search"><img src="../images/close.gif" alt="" />&nbsp;Cancelar</asp:LinkButton>
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
        
        <uc2:Loader ID="ldrWait" runat="server" />
    </form>
</body>
</html>
