<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PoolRemarcadoPresence.aspx.vb" Inherits="BPColSysOP.PoolRemarcadoPresence" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/Loader.ascx" TagName="Loader" TagPrefix="uc2" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Pool Remarcación Precense:</title>
    <%--<link href="../Estilos/estiloContenidos.css" rel="stylesheet" type="text/css" />--%>
    <script src="../Scripts/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
    <script src="../include/jquery-3.4.1.min.js" type="text/javascript"></script>
    <link href="../include/Bootstrap/bootstrap.min.css" rel="stylesheet" />
    <link href="../include/Bootstrap/main.css" rel="stylesheet" />
    <script src="../include/jquery.min.js" type="text/javascript"></script>
    <script src="../include/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                loadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function solonumeros(e) {
            var key;
            if (window.event) // IE
            {
                key = e.keyCode;
            }
            else if (e.which) // Netscape/Firefox/Opera
            {
                key = e.which;
            }

            if (key < 48 || key > 57) {
                return false;
            }
            return true;
        }

        function TamanioVentana() {
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
        }

        function testtimeout() {
            setTimeout("Temporizador()", 12000);
        }

        function Temporizador() {
            loadingPanel.Hide();
        }

        function OnExpandCollapseButtonClick(s, e) {
            var isVisible = pnlFiltros.GetVisible();
            s.SetText(isVisible ? "+" : "-");
            pnlFiltros.SetVisible(!isVisible);
        }

        function ValidacionDeFecha(s, e) {
            var fechaInicio = deFechaInicio.date;
            var fechaFin = deFechaFin.date;
            if (fechaInicio == null || fechaInicio == false || fechaFin == null || fechaFin == false) { return; }
            if (fechaInicio > fechaFin) { e.isValid = false; }
            var diff = Math.floor((fechaFin.getTime() - fechaInicio.getTime()) / (1000 * 60 * 60 * 24));
            if (diff > 60) { e.isValid = false; }
        }

        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            }
        }

        function ValidarFiltros(s, e) {



            if (deFechaInicio.GetValue() == null && deFechaFin.GetValue() == null && txtRadicado.GetValue() == null && cmbCampania.GetValue() == null && cmbEmpresa.GetValue() == null
                && cmbBanco.GetValue() == null && cmbEstadosConfirmacion.GetValue() == null) {
                alert('Debe seleccionar por lo menos un filtro de búsqueda.');
                setTimeout(function () { $("#warn").css("display", "none"); }, 2000)
            } else {

                if (deFechaInicio.GetValue() != null && deFechaFin.GetValue() != null) {


                    if (deFechaInicio.GetValue() == null && deFechaFin.GetValue() != null) {
                        alert('Debe digitar los dos rangos de fechas.');
                        setTimeout(function () { $("#warn").css("display", "none"); }, 2000)
                    } else {
                        if (deFechaInicio.GetValue() != null && deFechaFin.GetValue() == null) {
                            alert('Debe digitar los dos rangos de fechas.');
                            setTimeout(function () { $("#warn").css("display", "none"); }, 2000)
                        } else { EjecutarCallbackGeneral(s, e, 'filtrarDatos'); }
                    }

                } else {
                    alert('El rango de Fecha es Obligatorio.');

                }

            }
        }

        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function ValidarFiltroLimpiar(s, e) {
            EjecutarCallbackGeneral(s, e, 'LimpiarConsulta');
        }


        function limpiarPop() {
            $('#txtNombreCarga_I').val('');
            $('#cpGeneral_popGeneral').hide();
            $('#cpGeneral_popGeneral_OV').hide();
        }

        function grid_realceCheck(s, e) {

            var datos = gvDatos.GetSelectedKeysOnPage();
            //var tipobase = cmbTipoBase.GetValue();

            if (datos == "") {
                alert('Debe Seleccionar un elemento de la lista', 'Rojo');
                setTimeout(function () { $("#danger").css("display", "none"); }, 4000)
            } else {
                $('#modalProducto').modal();
                //EjecutarCallbackGeneral(s, e, 'BuscarserviciosTipoBase', tipobase);
            }

        }

        function CloseGridLookupCampania() {
            cmbCampania.ConfirmCurrentSelection();
            cmbCampania.HideDropDown();
        }

        /*
           Funciones para el manejo de los combos de múltiple selección.
       */
        var textSeparator = ";";
        function OnListBoxSelectionChanged(listBox, args) {
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemState();
            UpdateText();
        }

        function UpdateSelectAllItemState() {
            IsAllSelected() ? lbCampanias.SelectIndices([0]) : lbCampanias.UnselectIndices([0]);
        }

        function IsAllSelected() {
            var selectedDataItemCount = lbCampanias.GetItemCount() - (lbCampanias.GetItem(0).selected ? 0 : 1);
            return lbCampanias.GetSelectedItems().length == selectedDataItemCount;
        }

        function UpdateText() {
            var selectedItems = lbCampanias.GetSelectedItems();
            cmbCampania.SetText(GetSelectedItemsText(selectedItems));
        }

        function SynchronizeListBoxValues(dropDown, args) {
            lbCampanias.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            var values = GetValuesByTexts(texts);
            lbCampanias.SelectValues(values);
            UpdateSelectAllItemState();
            UpdateText(); // for remove non-existing texts
        }

        function GetSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.join(textSeparator);
        }

        function GetValuesByTexts(texts) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = lbCampanias.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }

        function limpiarPop() {
            $('#txtNombreCarga').val('');                          
            $('#listTipoServicio').val('');
            $('#modalProducto').modal('hide');
        }

    
    </script>

</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <dx:ASPxHiddenField ID="hfidGestion" runat="server" ClientInstanceName="hfidGestion"></dx:ASPxHiddenField>
        <dx:ASPxHiddenField ID="hfidEstado" runat="server" ClientInstanceName="hfidEstado"></dx:ASPxHiddenField>
        <dx:ASPxHiddenField ID="hfaccion" runat="server" ClientInstanceName="hfaccion"></dx:ASPxHiddenField>

        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <br />
         <dx:ASPxCallback ID="cbPrincipal" runat="server" ClientInstanceName="Callback">
            <ClientSideEvents EndCallback="function(s, e) { 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide(); }" />
        </dx:ASPxCallback>

        <div id="divGeneral" runat="server">
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" OnCallback="cpGeneral_Callback">
                <ClientSideEvents EndCallback="function(s,e){
                      ActualizarEncabezado(s,e); 
               
                    
                 }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtros de B&uacute;squeda" Width="1000px">
                            <HeaderTemplate>
                                <table>
                                    <tr>
                                        <td style="white-space: nowrap;">Filtros de B&uacute;squeda
                                        </td>
                                        <td style="width: 1%; padding-left: 5px;">
                                            <dx:ASPxButton ID="btnExpandCollapse" runat="server" Text="-" AllowFocus="False"
                                                AutoPostBack="False" Width="20px">
                                                <Paddings Padding="1px" />
                                                <FocusRectPaddings Padding="0" />
                                                <ClientSideEvents Click="OnExpandCollapseButtonClick" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </HeaderTemplate>
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxPanel ID="pnlFiltros" runat="server" Width="100%" ClientInstanceName="pnlFiltros">
                                        <Paddings Padding="0px" />
                                        <Paddings Padding="0px"></Paddings>
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <table>

                                                    <tr>
                                                        <td>Fecha Agenda Inicial:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxDateEdit ID="deFechaInicio" runat="server" ClientInstanceName="deFechaInicio"
                                                                TabIndex="5" Width="250px">
                                                                <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                                </CalendarProperties>
                                                                <ClientSideEvents Validation="ValidacionDeFecha"></ClientSideEvents>
                                                                <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inválido. Fecha inicial menor que Fecha final. Rango menor que 60 días"
                                                                    ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                                </ValidationSettings>                                                                
                                                            </dx:ASPxDateEdit>
                                                        </td>
                                                        <td>Fecha Agenda Final:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxDateEdit ID="deFechaFin" runat="server" ClientInstanceName="deFechaFin" TabIndex="6"
                                                                Width="250px">
                                                                <CalendarProperties ClearButtonText="Limpiar" TodayButtonText="Hoy">
                                                                </CalendarProperties>
                                                                <ClientSideEvents Validation="ValidacionDeFecha"></ClientSideEvents>
                                                                <ValidationSettings SetFocusOnError="True" EnableCustomValidation="true" ErrorText="Dato Inválido. Fecha inicial menor que Fecha final. Rango menor que 60 días"
                                                                    ErrorDisplayMode="ImageWithText" Display="Dynamic" ErrorTextPosition="Bottom">
                                                                </ValidationSettings>                                                                
                                                            </dx:ASPxDateEdit>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Numero Radicado:
                                                        </td>
                                                        <td>
                                                            <dx:ASPxTextBox ID="txtRadicado" Width="250px" runat="server" ClientInstanceName="txtRadicado"
                                                                MaxLength="15" onkeypress="return solonumeros(event);" TabIndex="3">
                                                            </dx:ASPxTextBox>
                                                        </td>

                                                        <td>BPO: 
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbEmpresa" runat="server"
                                                                ClientInstanceName="cmbEmpresa"
                                                                TabIndex="3" ValueType="System.Int32" Width="80%">
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td>Campaña:
                                                        </td>

                                                        <td>
                                                            <dx:ASPxDropDownEdit ID="cmbCampania" runat="server" ClientInstanceName="cmbCampania" Width="250px">
                                                                <DropDownWindowTemplate>
                                                                    <dx:ASPxListBox Width="100%" ID="lbCampanias" ClientInstanceName="lbCampanias" SelectionMode="CheckColumn"
                                                                        runat="server">
                                                                        <Border BorderStyle="None" />
                                                                        <ClientSideEvents SelectedIndexChanged="OnListBoxSelectionChanged" />
                                                                    </dx:ASPxListBox>
                                                                    <table style="width: 100%" cellspacing="0" cellpadding="4">
                                                                        <tr>
                                                                            <td align="right">
                                                                                <dx:ASPxButton ID="btnCerrar" AutoPostBack="False" runat="server" Text="Cerrar">
                                                                                    <ClientSideEvents Click="function(s, e){ cmbCampania.HideDropDown(); }" />
                                                                                </dx:ASPxButton>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </DropDownWindowTemplate>
                                                                <ClientSideEvents TextChanged="SynchronizeListBoxValues" DropDown="SynchronizeListBoxValues" />

                                                                <ClientSideEvents DropDown="SynchronizeListBoxValues" TextChanged="SynchronizeListBoxValues"></ClientSideEvents>
                                                            </dx:ASPxDropDownEdit>
                                                        </td>

                                                        <td>Estado Banco: 
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbBanco" runat="server"
                                                                ClientInstanceName="cmbBanco"
                                                                TabIndex="3" ValueType="System.Int32" Width="80%">
                                                            </dx:ASPxComboBox>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td>Estado: 
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="cmbEstadosConfirmacion" runat="server"
                                                                ClientInstanceName="cmbEstadosConfirmacion"
                                                                TabIndex="3" ValueType="System.Int32" Width="80%">
                                                            </dx:ASPxComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="padding-top: 8px">
                                                            <table>
                                                                <tr>
                                                                    <td style="white-space: nowrap;">
                                                                        <dx:ASPxButton ID="btnBuscar" runat="server" Text="Buscar"
                                                                            AutoPostBack="false" ValidationGroup="Filtrado" TabIndex="7" ClientInstanceName="btnBuscar" HorizontalAlign="Justify">
                                                                            <ClientSideEvents Click="function(s, e) { 
                                                                                ValidarFiltros(s, e); 
                                                                                }"></ClientSideEvents>
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                    <td>
                                                                        <dx:ASPxButton ID="btnLimpiar" runat="server" Text="Limpiar"
                                                                            AutoPostBack="false" TabIndex="8" HorizontalAlign="Justify">
                                                                            <ClientSideEvents Click="function(s, e) { LimpiaFormulario(); }"></ClientSideEvents>
                                                                            <ClientSideEvents Click="function(s, e) { 
                                                                                LimpiaFormulario();
                                                                                gvDatos.PerformCallback();
                                                                            }" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div style="clear: both;">
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxPanel>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <br />
                        <div id="divGrilla" style="float: left; margin-top: 5px; width: 100%; visibility: visible">
                            <dx:ASPxRoundPanel ID="rpDatos" runat="server" ClientInstanceName="rpDatos" Width="100%" HeaderText="Información" Visible="true" HorizontalAlign="left">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxHiddenField ID="hfUsuario" ClientInstanceName="hfUsuario" runat="server">
                                        </dx:ASPxHiddenField>
                                        <dx:ASPxGridView ID="gvDatos" runat="server" ClientInstanceName="gvDatos" AutoGenerateColumns="false"
                                            KeyFieldName="idServicioMensajeria" Width="100%">


                                            <Columns>
                                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0">
                                                    <HeaderTemplate>
                                                        <dx:ASPxButton ID="btnRealce" runat="server" Text="Enviar a Presence"
                                                            ToolTip="Enviar a Presence" AutoPostBack="false" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="@mdo">
                                                            <ClientSideEvents Click="function(s, e) {
                                                                if(confirm('¿Realmente desea enviar las gestiones seleccionadas a Precense?')) {
                                                                    grid_realceCheck();      
                                                                
                                                                 }
                                                            }" />
                                                        </dx:ASPxButton>

                                                        <dx:ASPxCheckBox ID="seleccionTodos" runat="server" ToolTip="Seleccionar / Deseleccionar todas las filas" ClientInstanceName="seleccionTodos"
                                                            ClientSideEvents-CheckedChanged="function(s, e) { 
                                                                gvDatos.SelectAllRowsOnPage(s.GetChecked());
                                                    
                                                                    }" />
                                                    </HeaderTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" />

                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn Caption="id Servicio" FieldName="idServicioMensajeria" ShowInCustomizationForm="True"
                                                    VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Fecha Agenda" FieldName="fechaAgenda" ShowInCustomizationForm="True" HeaderStyle-HorizontalAlign="Center"
                                                    VisibleIndex="2">
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Nombre Cliente" FieldName="nombreCliente" ShowInCustomizationForm="True"
                                                    VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="IdentificacionCliente" FieldName="identificacionCliente" ShowInCustomizationForm="true"
                                                    VisibleIndex="4">
                                                </dx:GridViewDataTextColumn>


                                                <dx:GridViewDataTextColumn Caption="Ciudad Entrega" FieldName="ciudadEntrega" ShowInCustomizationForm="True" HeaderStyle-HorizontalAlign="Center"
                                                    VisibleIndex="5">
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Direccion" FieldName="direccion" ShowInCustomizationForm="true"
                                                    VisibleIndex="6">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Telefono" FieldName="telefono" ShowInCustomizationForm="true"
                                                    VisibleIndex="7">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Estado" FieldName="estado" ShowInCustomizationForm="true"
                                                    VisibleIndex="8">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Estado Entrega" FieldName="EstadoEntrega" ShowInCustomizationForm="true"
                                                    VisibleIndex="9">
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn Caption="Tipo de Novedad" FieldName="TipoNovedad" ShowInCustomizationForm="true"
                                                    VisibleIndex="10">
                                                </dx:GridViewDataTextColumn>


                                                <dx:GridViewDataTextColumn Caption="Nombre Campaña" FieldName="nombreCampania" ShowInCustomizationForm="True" HeaderStyle-HorizontalAlign="Center"
                                                    VisibleIndex="11">
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                </dx:GridViewDataTextColumn>

                                            </Columns>
                                            <Settings ShowFooter="false" ShowHeaderFilterButton="true" />


                                            <SettingsPager PageSize="20">
                                                <PageSizeItemSettings Visible="true" ShowAllItem="false" />
                                            </SettingsPager>
                                            <SettingsText Title="Información" EmptyDataRow="No se encontraron datos asociados al documento consultado."
                                                CommandEdit="Editar"></SettingsText>
                                            <SettingsText CommandEdit="Editar" Title="Detalle Gestiones realizadas"
                                                EmptyDataRow="No se encontraron datos acordes con los filtros de búsqueda" />
                                            <SettingsBehavior EnableCustomizationWindow="False" AutoExpandAllGroups="False" />
                                        </dx:ASPxGridView>
                                        <dx:ASPxGridViewExporter ID="gveExportador" runat="server">
                                        </dx:ASPxGridViewExporter>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </div>
                    </dx:PanelContent>
                </PanelCollection>

            </dx:ASPxCallbackPanel>
        </div>
        <div class="modal fade" id="modalProducto" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="sparkline13-list">

                            <div class="sparkline13-graph">
                                <div class="datatable-dashv1-list custom-datatable-overright">
                                    <div class="table-content">
                                        <div class="col-md-10">
                                            <label for="lblNombreBase">Nombre Base<a style="color: #FF0000">*</a></label>
                                            <div class="input-group mb-2 col">
                                                <asp:TextBox runat="server" ID="txtNombreCarga" class="form-control" Width="350px"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-10">
                                            <label for="lblTipoBase">Tipo Servicio <a style="color: #FF0000">*</a> </label>
                                            <div class="input-group mb-2 col">
                                                <asp:DropDownList ID="listTipoServicio" runat="server" CssClass="form-control" />
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">

                        <dx:ASPxButton ID="idSendToPresence" runat="server" Text="Enviar a Presence" AutoPostBack="false" ClientInstanceName="idSendToPresence" HorizontalAlign="Justify"
                            class="btn btn-default">
                            <ClientSideEvents Click="function(s, e) {
                                
                                var datos = gvDatos.GetSelectedKeysOnPage();
                                var tipoServicio = $('#listTipoServicio').val();
                                var nombreBase = $('#txtNombreCarga').val();
                                                  
                                if (tipoServicio == 0 ) {
                                    alert('Debe seleccionar un tipo de Servicio');
                                } else if (nombreBase == '') {
                                    alert('Debe de asignar un nombre o descripcion a la carga');
                                } else {
                                    EjecutarCallbackGeneral(s, e, 'EnviarDatosPresence', datos+':'+tipoServicio+':'+nombreBase);
                                    limpiarPop();
                                }                                                           
                                                            
                                                            }" />
                            <Image Url="~/img/find.gif">
                            </Image>
                        </dx:ASPxButton>


                        
                    </div>
                </div>
            </div>
        </div>

        <br />
        <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel"
            Modal="True">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
