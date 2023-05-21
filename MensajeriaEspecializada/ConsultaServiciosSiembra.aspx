<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConsultaServiciosSiembra.aspx.vb" Inherits="BPColSysOP.ConsultaServiciosSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Consulta de Servicios SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        Date.prototype.yyyymmdd = function () {
            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();
            return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]); // padding
        };

        var myWidth, myHeight;
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

        function MaxLongitud(text, len) {
            var maxlength = new Number(len);
            //if (text.value.length > maxlength) {
            //  text.value = text.value.substring(0, maxlength);
            //}
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function VisualizarRecoleccion(s, e, key) {
            dialogoRecoleccion.SetVisible(true);
            gvSeriales.PerformCallback('consulta|' + key);
        }

        function CambiarFechaMin(s, e, idServicio, msisdn) {
            if (confirm('¿Realmente desea cambiar la fecha de Devolución?')) {
                gvSeriales.PerformCallback('cambioFechaDevolucion|' + idServicio + ',' + msisdn + ',' + s.GetDate().yyyymmdd());
            }
        }

        function CambiarEstadoDevolucion(s, e, idDetalle) {
            if (confirm('¿Realmente desea cambiar el estado de devolución?')) {
                gvSeriales.PerformCallback('cambioEstado|' + idDetalle + ',' + s.GetValue());
            }
        }

        function VerDetalle(element, key) {
            TamanioVentana();
            gvMateriales.PerformCallback(key);
            dialogoVerMateriales.SetSize(myWidth * 0.4, myHeight * 0.4);
            dialogoVerMateriales.ShowWindow();
        }

        function CrearServicio(s, e, key) {
            if (confirm('¿Realmente desea crear un nuevo servicio asociado?')) {
                window.location.href = 'RegistrarServicioTipoSiembra.aspx?idServicioPadre=' + key;
            }
        }

        function grid_SelectionChanged(s, e) {
            s.GetSelectedFieldValues("idDetalle", ObtieneValoresSerialesCallback);
        }

        function ObtieneValoresSerialesCallback(values) {
            var listaSeriales = new Array()
            for (var i = 0; i < values.length; i++) {
                listaSeriales[i] = values[i]
            }
            gvServicios.PerformCallback('crearOrdenRecoleccion|' + listaSeriales);
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:encabezadopagina ID="miEncabezado" runat="server" />
        </div>

        <dx:ASPxRoundPanel ID="rpFiltros" runat="server" HeaderText="Filtro de Búsqueda de Servicios">
            <PanelCollection>
                <dx:PanelContent>
                    <table>
                        <tr>
                            <td>Número de Servicio:</td>
                            <td>
                                <dx:ASPxMemo ID="txtidServicio" runat="server" Height="40px" Width="150px"
                                    onKeyUp="javascript:MaxLongitud(this,4000);" onChange="javascript:MaxLongitud(this,4000);"
                                    onkeypress="javascript:return ValidaNumero(event);">
                                </dx:ASPxMemo>
                            </td>
                            <td>Estado:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbEstado" runat="server" 
                                    ClientInstanceName="cmbCiudadEntrega" IncrementalFilteringMode="Contains" 
                                    ValueType="System.Int32" Width="250px">
                                    <ValidationSettings CausesValidation="True" Display="Dynamic" 
                                        ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar">
                                        <RequiredField ErrorText="La ciudad es requerida" IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                         <tr>
                        <td>
                            Fecha Inicial:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaInicio"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                        dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                        <td>
                            Fecha Final:
                        </td>
                        <td>
                            <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaFin"
                                Width="100px">
                                <ClientSideEvents ValueChanged="function(s, e){
                                    if (dateFechaInicio.GetDate()==null){
                                        dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                        }
                                    }" />
                            </dx:ASPxDateEdit>
                        </td>
                    </tr>
                        <tr>
                            <td>
                                Gerencia:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbGerencia" runat="server" 
                                    ClientInstanceName="cmbGerencia" IncrementalFilteringMode="Contains" 
                                    ValueType="System.Int32" Width="250px">
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                        cmbCoordinador.PerformCallback(s.GetValue());
                                    }"></ClientSideEvents>
                                </dx:ASPxComboBox>
                            </td>
                            <td>
                                Coordinador:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbCoordinador" runat="server" 
                                    ClientInstanceName="cmbCoordinador" IncrementalFilteringMode="Contains" 
                                    ValueType="System.Int32" Width="250px">
                                    <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                        cmbConsultor.PerformCallback(s.GetValue());
                                    }" />
                                </dx:ASPxComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Consultor:</td>
                            <td>
                                <dx:ASPxComboBox ID="cmbConsultor" runat="server" 
                                    ClientInstanceName="cmbConsultor" IncrementalFilteringMode="Contains" 
                                    ValueType="System.Int32" Width="250px">
                                    <ClientSideEvents EndCallback="function(s, e) {
                                        s.SetSelectedIndex(-1);
                                    }" />
                                </dx:ASPxComboBox>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <dx:ASPxButton ID="btnFiltrar" runat="server" AutoPostBack="False" 
                                    CausesValidation="False" HorizontalAlign="Center" Style="display: inline" 
                                    Text="Buscar" Width="100px">
                                    <ClientSideEvents Click="function(s, e) {
                                                gvServicios.PerformCallback('consultar');
                                            }" />
                                    <Image Url="../images/find.gif">
                                    </Image>
                                </dx:ASPxButton>
                                &nbsp;&nbsp;
                                <dx:ASPxButton ID="btnQuitarFiltro" runat="server" AutoPostBack="False" 
                                    CausesValidation="False" HorizontalAlign="Center" Style="display: inline" 
                                    Text="Limpiar Filtros" Width="140px">
                                    <ClientSideEvents Click="function(s, e) {
                                                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                                            }" />
                                    <Image Url="../images/unfunnel.png">
                                    </Image>
                                </dx:ASPxButton>
                            </td>
                            <td align="center" colspan="2">
                                <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                                Width="200px">
                                <Items>
                                    <dx:ListEditItem ImageUrl="../images/excel.gif" Text="Exportar a XLS" Value="xls"
                                        Selected="true" />
                                    <dx:ListEditItem ImageUrl="../images/pdf.png" Text="Exportar a PDF" Value="pdf" />
                                    <dx:ListEditItem ImageUrl="../images/xlsx_win.png" Text="Exportar a XLSX" Value="xlsx" />
                                    <dx:ListEditItem ImageUrl="../images/csv.png" Text="Exportar a CSV" Value="csv" />
                                </Items>
                                <Buttons>
                                    <dx:EditButton Text="Exportar" ToolTip="Exportar Reporte al formato seleccionado">
                                        <Image Url="../images/upload.png">
                                        </Image>
                                    </dx:EditButton>
                                </Buttons>
                                <ValidationSettings ErrorText="Formato a exportar requerido" RequiredField-ErrorText="Formato a exportar requerido"
                                    Display="Dynamic" CausesValidation="true" ValidateOnLeave="true" ValidationGroup="exportar">
                                    <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular">
                                    </RegularExpression>
                                    <RequiredField IsRequired="True" ErrorText="Formato a exportar requerido"></RequiredField>
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                            </td>
                        </tr>
                    </table>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>

        
        <dx:ASPxRoundPanel ID="rpResultadoServicios" runat="server" style="margin-top: 10px;"
            EnableClientSideAPI="True" HeaderText="Listado de Servicios">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">

                    <dx:ASPxGridView ID="gvServicios" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="IdServicioMensajeria" ClientInstanceName="gvServicios">
                        <ClientSideEvents EndCallback="function(s, e) {
                            if(s.cpMensaje) {
                                $('#divEncabezado').html(s.cpMensaje);
                            }
                        }"></ClientSideEvents>
                        <Columns>
                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="0" Width="80px">
                                <DataItemTemplate>
                                    <dx:ASPxHyperLink runat="server" ID="lnkVer" ImageUrl="../images/view.png" 
                                        Cursor="pointer" ToolTip="Ver detalle Servicio" OnInit="Link_Init">
                                        <ClientSideEvents Click="function(s, e) { 
                                            VerDetalle(this, {0});
                                        }" />
                                    </dx:ASPxHyperLink>
                                    <dx:ASPxHyperLink runat="server" ID="lnkProgramarRecoleccion" ImageUrl="../images/trans_small.png"
                                        Cursor="pointer" ToolTip="Programar Recolección">
                                        <ClientSideEvents Click="function(s, e) {  
                                            VisualizarRecoleccion(s, e, {0});
                                        }" />
                                    </dx:ASPxHyperLink>
                                    <dx:ASPxHyperLink runat="server" ID="lnkNuevoServicio" ImageUrl="../images/arrow-split.png"
                                        Cursor="pointer" ToolTip="Crear Servicio Asociado">
                                        <ClientSideEvents Click="function(s, e) {  
                                            CrearServicio(s, e, {0});
                                        }" />
                                    </dx:ASPxHyperLink>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataTextColumn FieldName="IdServicioMensajeria" ReadOnly="True" 
                                ShowInCustomizationForm="True" VisibleIndex="0" Caption="Id Servicio">
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Ciudad" ShowInCustomizationForm="True" 
                                VisibleIndex="1" Caption="Ciudad">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NombreCliente" ShowInCustomizationForm="True" 
                                VisibleIndex="2" Caption="Empresa">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="IdentificacionCliente" ShowInCustomizationForm="True" 
                                VisibleIndex="3" Caption="NIT">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NombreRepresentanteLegal" ShowInCustomizationForm="True" 
                                VisibleIndex="4" Caption="Representante Legal">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="IdentificacionRepresentanteLegal" 
                                ShowInCustomizationForm="True" VisibleIndex="5" Caption="Identificación Representante">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Direccion" ShowInCustomizationForm="True" 
                                VisibleIndex="6" Caption="Dirección">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="TelefonoContacto" ShowInCustomizationForm="True" 
                                VisibleIndex="7" Caption="Teléfono">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Estado" ShowInCustomizationForm="True" 
                                VisibleIndex="8" Caption="Estado">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NombreGerencia" ShowInCustomizationForm="True" 
                                VisibleIndex="9" Caption="Gerencia">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NombreCoordinador" ShowInCustomizationForm="True" 
                                VisibleIndex="10" Caption="Coordinador">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NombreConsultor" ShowInCustomizationForm="True" 
                                VisibleIndex="10" Caption="Consultor">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="FechaRegistro" 
                                ShowInCustomizationForm="True" VisibleIndex="11">
                            </dx:GridViewDataDateColumn>
                        </Columns>
                    </dx:ASPxGridView>
                    <dx:ASPxGridViewExporter ID="gveServicios" runat="server" GridViewID="gvServicios">
                    </dx:ASPxGridViewExporter>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
        
        <dx:ASPxPopupControl ID="pcVerDetalle" runat="server" 
            ClientInstanceName="dialogoVerMateriales" HeaderText="Detalle de Equipos" 
            Modal="True" PopupHorizontalAlign="WindowCenter" 
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxGridView ID="gvMateriales" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="idMsisdn" ClientInstanceName="gvMateriales">
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="msisdn" ShowInCustomizationForm="True" 
                                VisibleIndex="1" Caption="MSISDN">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="materialEquipo" ShowInCustomizationForm="True" 
                                VisibleIndex="2" Caption="Material">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="referenciaEquipo" 
                                ShowInCustomizationForm="True" VisibleIndex="3" Caption="Referencia" >
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="iccid" ShowInCustomizationForm="True" 
                                VisibleIndex="4" Caption="ICCID">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="imei" 
                                ShowInCustomizationForm="True" VisibleIndex="5" Caption="IMEI">
                            </dx:GridViewDataDateColumn>
                        </Columns>
                    </dx:ASPxGridView>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        
        <dx:ASPxPopupControl ID="pcProgramarRecoleccion" runat="server" 
            HeaderText="Programación de Recolección" AllowDragging="true"
            ClientInstanceName="dialogoRecoleccion" 
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
            Modal="True" CloseAction="CloseButton">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" SupportsDisabledAttribute="True">
                    
                    <dx:ASPxGridView ID="gvSeriales" runat="server" AutoGenerateColumns="False" 
                        KeyFieldName="idDetalle" ClientInstanceName="gvSeriales">
                        <ClientSideEvents EndCallback="function(s, e) {
                            if(s.cpMensaje) {
                                $('#divEncabezado').html(s.cpMensaje);
                            }
                        }" />
                        <Columns>
                            <dx:GridViewCommandColumn ShowInCustomizationForm="True"  
                                ShowSelectCheckbox="True" VisibleIndex="0" Caption="">
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="idDetalle" ReadOnly="True" 
                                ShowInCustomizationForm="True" VisibleIndex="1" Caption="ID">
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="msisdn" ShowInCustomizationForm="True" 
                                VisibleIndex="2" Caption="MSISDN">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="serial" Caption="Serial" 
                                ShowInCustomizationForm="True" VisibleIndex="3">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="fechaDevolucion" ShowInCustomizationForm="True" VisibleIndex="5" Caption="Fecha Devolución">
                                <DataItemTemplate>
                                    <dx:ASPxDateEdit id="dateFechaDevolucion" runat="server" Width="100px"
                                        OnInit="dateFechaDevolucion_Init">
                                       <ClientSideEvents DateChanged="function(s, e) {
                                            CambiarFechaMin(s, e, {0}, '{1}');
                                       }" />
                                    </dx:ASPxDateEdit>
                                </DataItemTemplate>
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="12" Width="80px">
                                <DataItemTemplate>
                                    <dx:ASPxComboBox ID="cmbEstadoDevolucion" runat="server" IncrementalFilteringMode="Contains"
                                        Width="250px" ValueField="idCLasificacion" ClientInstanceName="cmbClasificaion"
                                        DropDownStyle="DropDownList" OnInit="cmbEstadoDevolucion_Init">
                                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
                                            CambiarEstadoDevolucion(s, e, {0});
                                        }" />
                                    </dx:ASPxComboBox>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                        </Columns>
                    </dx:ASPxGridView>
                    
                    
                    <dx:ASPxButton ID="btnCrearRecolecion" runat="server" AutoPostBack="False" 
                        CausesValidation="False" HorizontalAlign="Center" Style="display: inline" 
                        Text="Crear Orden Recolección" Width="250px">
                        <ClientSideEvents Click="function(s, e) {
                            if(gvSeriales.GetSelectedRowCount() == 0) {
                                alert('Por favor seleccione los seriales para crear la orden de recolección.');
                            } else {
                                grid_SelectionChanged(gvSeriales);
                                dialogoRecoleccion.HideWindow();
                            }
                        }" />
                        <Image Url="../images/package.png">
                        </Image>
                    </dx:ASPxButton>
                    
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        
    </form>
</body>
</html>
