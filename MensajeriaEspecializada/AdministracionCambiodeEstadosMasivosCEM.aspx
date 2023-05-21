<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdministracionCambiodeEstadosMasivosCEM.aspx.vb"
    Inherits="BPColSysOP.AdministracionCambiodeEstadosMasivosCEM" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>:: Administración Cambios de Estado Servicio CEM ::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ddlTipoServicio.SetSelectedIndex(0);
                gvMatrialClaseSim.PerformCallback(null);
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function CargarEstadosServicios(s, e) {
            cpPrincipal.PerformCallback('consultaEstadosServicios' + ':' + ddlTipoServicio.GetValue());
        }
        function Editartiposim(s, e, parametro, valor) {
            cpPrincipal.PerformCallback(parametro + ':' + valor);
        }
        function MostrarInfoEncabezado(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
                if (s.cpMensaje.indexOf("lblError") != -1 || s.cpMensaje.indexOf("lblWarning") != -1 || s.cpMensaje.indexOf("lblSuccess") != -1) {
                    $('html, body').animate({ scrollTop: $('#divEncabezado').offset().top }, 'slow');
                }
            }
        }
        function RegistarCambiodeestado(s, e) {
            cpPrincipal.PerformCallback('RegistarCambiodeestado' + ':' + ddlTipoServicio.GetValue());
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 50%;">
            <dx:ASPxRoundPanel ID="rpFiltroCampanias" runat="server" HeaderText="Filtro de Búsqueda" Theme="SoftOrange">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallbackPanel ID="cpPrincipal" runat="server" ClientInstanceName="cpPrincipal">
                            <ClientSideEvents EndCallback="MostrarInfoEncabezado" />
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1">
                                        <tr>

                                            <td>Tipo Servicio</td>
                                            <td>
                                                <dx:ASPxComboBox ID="ddlTipoServicio" runat="server" ClientInstanceName="ddlTipoServicio" IncrementalFilteringMode="Contains"
                                                    TextFormatString="{0} {1}" ValueField="idTipoServicio" Width="200px" CallbackPageSize="14" >
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { CargarEstadosServicios(s, e); }" />
                                                    <Columns>
                                                        <dx:ListBoxColumn Caption="idTipoServicio" FieldName="idTipoServicio" Width="20px" />
                                                        <dx:ListBoxColumn Caption="nombre" FieldName="nombre" Width="150" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                        ValidationGroup="vgAdicionarCombinacion">
                                                        <RequiredField ErrorText="Por favor seleccione un tipo de servicio" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <dx:ASPxImage ID="imgFiltro" runat="server" ImageUrl="../images/DxAdd32.png"
                                                    ToolTip="Nuevo Registro" Cursor="pointer">
                                                    <ClientSideEvents Click="function (s, e){
                                                        if(ASPxClientEdit.ValidateGroup(&#39;vgAdicionarCombinacion&#39;)){
                                                               cpPrincipal.PerformCallback('CrearNuevocambioestado' + ':' + ddlTipoServicio.GetValue()); } 
                                                       
                                                    }" />
                                                </dx:ASPxImage>
                                                <dx:ASPxImage ID="imgCancela" runat="server" ImageUrl="../images/DxCancel32.png"
                                                    ToolTip="Cancelar" Cursor="pointer">
                                                    <ClientSideEvents Click="function(s, e){
                                                        LimpiaFormulario();
                                                    }" />
                                                </dx:ASPxImage>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                    <div style="margin-bottom: 5px;">
                                        <dx:ASPxGridView ID="gvConfEstadoMasivo" runat="server" Width="100%" ClientInstanceName="gvConfEstadoMasivo"
                                            AutoGenerateColumns="False" KeyFieldName="idRegistro" Theme="SoftOrange" SettingsLoadingPanel-Mode="Disabled">
                                            <ClientSideEvents EndCallback="function(s,e){ 
                                            $('#divEncabezado').html(s.cpMensaje);
                                            LoadingPanel.Hide();
                                        }"></ClientSideEvents>
                                            <Columns>
                                                <dx:GridViewDataTextColumn Caption="idRegistro" ShowInCustomizationForm="True"
                                                    VisibleIndex="1" FieldName="idRegistro">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Estado Inicial" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" FieldName="EstadoInicial">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Estado Final" ShowInCustomizationForm="True"
                                                    VisibleIndex="3" FieldName="EstadoFinal" Visible="true">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Valida Disponibilidad" FieldName="ValidaDisponibilidad" ShowInCustomizationForm="True"
                                                    VisibleIndex="4" ToolTip="Valida que en el inventario exista la cantidad de material suficiente para atender el servicio y realiza la reserva">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Valida Cupos" FieldName="ValidaCupos" ShowInCustomizationForm="True"
                                                    VisibleIndex="5" ToolTip="Valida que exista disponibilidad de cupos en la capacidad de entrega ">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Carga Inventario" FieldName="CargaInventario" ShowInCustomizationForm="True"
                                                    VisibleIndex="6" ToolTip="Regresa los seriales asociados al servicio al inventario en libre utilización">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="Libera Disponibilidad Inventario" FieldName="LiberaDisponibilidadInventario" ShowInCustomizationForm="True"
                                                    VisibleIndex="7" ToolTip="Libera los cupos reservados por los materiales asociados al servicio ">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn Caption="Usuario Registro" ShowInCustomizationForm="true" VisibleIndex="7"
                                                    FieldName="UsuarioRegistra">
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataColumn Caption="" VisibleIndex="8">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/Edit-User.png"
                                                            Cursor="pointer" ToolTip="Modificar Clase Sim Card" OnInit="Link_Init">
                                                            <ClientSideEvents Click="function(s, e) { Editartiposim(s,e,'ActualizarCambiodeestado', {0}); }" />
                                                        </dx:ASPxHyperLink>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
											<Settings ShowFilterRow="true" ShowFilterRowMenu="true" ShowGroupPanel="true" ShowFooter="true" /> 
                                            <SettingsText Title="B&#250;squeda General de Campañas" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda"></SettingsText>
                                            <SettingsLoadingPanel Mode="Disabled"></SettingsLoadingPanel>
                                        </dx:ASPxGridView>
                                    </div>

                                    <br />
                                    <br />
                                    <dx:ASPxPopupControl ID="pcEditar" runat="server" ClientInstanceName="pcEditar" Modal="true" CloseAction="CloseButton" Theme="SoftOrange" Width="600" Height="300"
                                        HeaderText="Información Estados Masivos CEM" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ScrollBars="Auto" AllowDragging="True">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl>
                                                <fieldset>
                                                    <legend>Configuracion Estado</legend>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxHiddenField ID="hfidRegistro" runat="server" ClientInstanceName="hfidRegistro"></dx:ASPxHiddenField>
                                                               
                                                            </td>

                                                        </tr>
                                                        <tr>
                                                            <td>Estado Inicial
                                                            </td>
                                                            <td>
                                                                <dx:ASPxComboBox ID="cmEstadosActualCEM" runat="server" ClientInstanceName="cmEstadosActualCEM" Width="230px"
                                                                    IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idEstado"
                                                                    EnableCallbackMode="true" ValueType="System.Int32">
                                                                    <ClientSideEvents Validation="function(s, e) {
	                                                                    if (s.GetSelectedIndex()==cmEstadosFinalCEM.GetSelectedIndex()) {
			                                                                    e.isValid = false;                                                                                
                                                                                e.errorText = &quot;Los estados no pueden ser iguales&quot;;
                                                                                } else {
                                                                        cmEstadosFinalCEM.isValid=true;
                                                                        }
           
                                                                    }" />
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="idEstado" Caption="idEstadoInicial" Width="10px" Visible="false" />
                                                                        <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="220px" />
                                                                    </Columns>
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                    </ValidationSettings>

                                                                </dx:ASPxComboBox>
                                                            </td>
                                                            <td>Estado Final</td>
                                                            <td>
                                                                <dx:ASPxComboBox ID="cmEstadosFinalCEM" runat="server" ClientInstanceName="cmEstadosFinalCEM" Width="230px"
                                                                    IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idEstado"
                                                                    EnableCallbackMode="true" ValueType="System.Int32">
                                                                    <ClientSideEvents Validation="function(s, e) {
	                                                                    if (s.GetSelectedIndex()==cmEstadosActualCEM.GetSelectedIndex()) {
			                                                                    e.isValid = false;
                                                                                e.errorText = &quot;Los estados no pueden ser iguales&quot;;
                                                                                }else {
                                                                        cmEstadosActualCEM.isValid=true;
                                                                        }
           
                                                                    }" />
                                                                    <Columns>
                                                                        <dx:ListBoxColumn FieldName="idEstado" Caption="idEstadoFinal" Width="10px" Visible="false" />
                                                                        <dx:ListBoxColumn FieldName="nombre" Caption="Nombre" Width="220px" />
                                                                    </Columns>
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxComboBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <table>
                                                        <tr>
                                                            <td>Valida Disponibilidad
                                                            </td>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="cbValidaDisponibilidad" ClientInstanceName="cbValidaDisponibilidad" runat="server"></dx:ASPxCheckBox>
                                                            </td>

                                                            <td>Valida capacidad de entrega
                                                            </td>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="cbValidaCupos" ClientInstanceName="cbValidaCupos" runat="server"></dx:ASPxCheckBox>
                                                            </td>
                                                        </tr>                                                       
                                                        <tr> 
                                                            <td>Retorna seriles al inventario
                                                            </td>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="cbRetornaseralesInventario" ClientInstanceName="cbValidaDisponibilidad" runat="server"></dx:ASPxCheckBox>
                                                            </td>
                                                            <td>libera disponibilidad de inventario
                                                            </td>
                                                            <td>
                                                                <dx:ASPxCheckBox ID="cbLiberaCuposBloqueados" ClientInstanceName="cbValidaCupos" runat="server"></dx:ASPxCheckBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" align="center">
                                                                <dx:ASPxImage ID="imgEdita" runat="server" ImageUrl="~/images/DxConfirm16.png" Cursor="pointer"
                                                                    ToolTip="Registrar">
                                                                    <ClientSideEvents Click="function(s, e){
                                                            if(ASPxClientEdit.ValidateGroup(&#39;vgEditar&#39;)){
                                                                pcEditar.Hide();
                                                                 RegistarCambiodeestado(s, e); }                                                          
                                                            }" />
                                                                </dx:ASPxImage>
                                                            </td>
                                                        </tr>
                                                    </table>


                                                </fieldset>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>

        </div>

        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
