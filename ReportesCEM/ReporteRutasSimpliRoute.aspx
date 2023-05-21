<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReporteRutasSimpliRoute.aspx.vb" Inherits="BPColSysOP.ReporteRutasSimpliRoute" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>::Reporte de Rutas::</title>
    <link rel="shortcut icon" href="../images/baloons_small.png" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/JavaScriptFunctions.js" type="text/javascript"></script>
    <script type="text/javascript">
        function EsRangoValido(s, e) {
            deFechaInicial.SetIsValid(true);
            deFechaFinal.SetIsValid(true);

            var fechaInicio = deFechaInicial.date;
            var fechaFin = deFechaFinal.date;

            if ((fechaInicio == null || fechaInicio == false) && (fechaFin != null && fechaFin != false)) {
                e.isValid = false;
                e.errorText = "No se han proporcionado los dos valores del rango";
                return e.isValid;
            }
            if ((fechaFin == null || fechaFin == false) && (fechaInicio != null && fechaInicio != false)) {
                e.isValid = false;
                e.errorText = "No se han proporcionado los dos valores del rango";
                return e.isValid;
            }

            if (fechaInicio > fechaFin) {
                e.isValid = false;
                e.errorText = "Dato no válido. Fecha inicial menor que Fecha final"
                return e.isValid;
            }

            if (fechaFin != null || fechaInicio != null) {
                var dias = ((fechaFin - fechaInicio) / (1000 * 60 * 60 * 24));

                if (dias > 32) {
                    e.isValid = false;
                    e.errorText = "El rango de fechas no puede ser superior a 30 dias"
                    return e.isValid;
                }
            }
            if (fechaInicio <= fechaFin) {
                e.isValid = true;
                e.errorText = ""
                return e.isValid;
            }

        }

        function Consultar(s, e) {
            LoadingPanel.Show();

            var fechaInicio = deFechaInicial.date;
            var fechaFin = deFechaFinal.date;

            if (fechaInicio > fechaFin) {
                LoadingPanel.Hide();
                return;
            }

            if (fechaFin != null || fechaInicio != null) {
                var dias = ((fechaFin - fechaInicio) / (1000 * 60 * 60 * 24));

                if (dias > 32) {
                    LoadingPanel.Hide();
                    return;
                }
            }

            cpPrincipal.PerformCallback('consultarRutas');
            LoadingPanel.Hide();
        }


        function ExportarRutas(s, e) {

            var res = 0;
            for (var key in hfRutaSeleccionado["properties"]) {                
                res = hfRutaSeleccionado["properties"][key].split(";");
            }

            if (res <= 0) {
                alert('Debe seleccionar por lo menos una ruta');
                return;
            }

            LoadingPanel.Show();

            var fechaInicio = deFechaInicial.date;
            var fechaFin = deFechaFinal.date;

            if (fechaInicio > fechaFin) {
                LoadingPanel.Hide();
                return;
            }

            if (fechaFin != null || fechaInicio != null) {
                var dias = ((fechaFin - fechaInicio) / (1000 * 60 * 60 * 24));

                if (dias > 32) {
                    LoadingPanel.Hide();
                    return;
                }
            }

            cpPrincipal.PerformCallback('ExportarRutas');
            LoadingPanel.Hide();
        }


        function LimpiaFormulario() {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {

                var date1 = new Date();
                var primerDia = new Date();
                deFechaInicial.SetDate(primerDia);

                var date2 = new Date();
                deFechaFinal.SetDate(date2);

            }
        }




        function seleccionarRuta(s, e) {

            if (s.GetChecked()) {
                gridInfoRutas.GetRowValues(s.cp_indexcm, 'idRuta', rutas);
                var row = gridInfoRutas.GetRow(s.cp_indexcm);
                row.style.backgroundColor = "#DCEBF1";
            }
            else {
                gridInfoRutas.GetRowValues(s.cp_indexcm, 'idRuta', ciclosRemove);
                var row = gridInfoRutas.GetRow(s.cp_indexcm);
                row.style.backgroundColor = "#F1F4DC";
            }
        }

        function rutas(dato) {

            var cm_cInstanceName = "cbRuta" + dato;
            var cm_ClienInstance = ASPxClientControl.GetControlCollection().GetByName(cm_cInstanceName);

            if (cm_ClienInstance != null) {

                var cm_key = dato;
                var cm_Ckey = "key" + dato;
                var cm_check = "true";
                var cm_uncheck = "false";

                if (!hfRutaSeleccionado.Contains(cm_Ckey)) {
                    hfRutaSeleccionado.Add(cm_Ckey, cm_key + ";" + cm_check.toString());

                }

                cm_ClienInstance.SetChecked(true);
                btnExportar.SetEnabled(true);
            }

        }

        function ciclosRemove(dato) {

            var cm_cInstanceName = "cbRuta" + dato;
            var cm_ClienInstance = ASPxClientControl.GetControlCollection().GetByName(cm_cInstanceName);

            var cm_key = dato;
            var cm_Ckey = "key" + dato;
            var cm_uncheck = "false";

            if (cm_ClienInstance != null) {
                if (hfRutaSeleccionado.Contains(cm_Ckey)) {
                    hfRutaSeleccionado.Remove(cm_Ckey);
                    cm_ClienInstance.SetChecked(false);
                }
            }

            //var res = 0;
            //for (var key in hfRutaSeleccionado["properties"]) {
            //    //console.log("key: " + key.replace(ASPxClientHiddenField.TopLevelKeyPrefix, "") + "\nvalue: " + hfRutaSeleccionado["properties"][key]);
            //    res = hfRutaSeleccionado["properties"][key].split(";");
            //}

            //if (res <= 0) {
            //    btnExportar.SetEnabled(false);
            //}
        }

        function cm_OnAllCheckedChanged(s, e) {

            var cm_startIndex = gridInfoRutas.visibleStartIndex;
            var cm_endIndex = cm_startIndex + gridInfoRutas.pageRowCount;

            if (s.GetChecked()) {
                for (var i = cm_startIndex; i < cm_endIndex; i++) {
                    gridInfoRutas.GetRowValues(i, 'idRuta', rutasTodas);
                }
            }
            else {

                for (var i = cm_startIndex; i < cm_endIndex; i++) {
                    gridInfoRutas.GetRowValues(i, 'idRuta', quitarSeleccionTodos);
                }
            }
        }

        function rutasTodas(dato) {

            var cm_cInstanceName = "cbRuta" + dato;
            var cm_ClienInstance = ASPxClientControl.GetControlCollection().GetByName(cm_cInstanceName);

            var cm_key = dato;
            var cm_Ckey = "key" + cm_key;
            var cm_check = "true";
            var cm_uncheck = "false";

            if (cm_ClienInstance != null) {

                if (!hfRutaSeleccionado.Contains(cm_Ckey)) {
                    hfRutaSeleccionado.Add(cm_Ckey, cm_key + ";" + cm_check.toString());
                }
                cm_ClienInstance.SetChecked(true);
                btnExportar.SetEnabled(true);
            }

        }


        function quitarSeleccionTodos(dato) {
            var cm_cInstanceName = "cbRuta" + dato;

            var cm_key = dato;
            var cm_Ckey = "key" + cm_key;
            var cm_ClienInstance = ASPxClientControl.GetControlCollection().GetByName(cm_cInstanceName);

            if (hfRutaSeleccionado.Contains(cm_Ckey)) {
                hfRutaSeleccionado.Remove(cm_Ckey);
            }

            cm_ClienInstance.SetChecked(false);

            //var res = 0;
            //for (var key in hfRutaSeleccionado["properties"]) {
            //    //console.log("key: " + key.replace(ASPxClientHiddenField.TopLevelKeyPrefix, "") + "\nvalue: " + hfRutaSeleccionado["properties"][key]);
            //    res = hfRutaSeleccionado["properties"][key].split(";");
            //}

            //if (res <= 0) {
            //    btnExportar.SetEnabled(false);
            //}
        }
        
        function descargarReporte(s, e) {
            if (s.cpNombreArchivo != null && s.cpNombreArchivo != '') {
                DescargarArchivo(s.cpNombreArchivo)
            }
        }

        function DescargarArchivo(archivo) {
            window.location.href = 'DescargarArchivoReportesCEM.aspx?nombreArchivo=' + archivo;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallbackPanel ID="cpPrincipal" ClientInstanceName="cpPrincipal" runat="server">
                <ClientSideEvents EndCallback="function(s, e) { LoadingPanel.Hide();
                       descargarReporte(s, e);
                    }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezadoPrincipal">
                            <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="roundPanelFiltros" runat="server" ClientInstanceName="roundPanelFiltros" HeaderText="Filtros de Búsqueda" Width="1100px" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table style="width: 100%">
                                        <tr>
                                            <td class="field">Fecha Creación Inicial:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaInicial" runat="server" ClientInstanceName="deFechaInicial" TabIndex="4" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Inicial" EnableClientSideAPI="true">
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>

                                            <td class="field">Fecha Creación Final:</td>
                                            <td>
                                                <dx:ASPxDateEdit ID="deFechaFinal" runat="server" ClientInstanceName="deFechaFinal" TabIndex="5" Theme="SoftOrange"
                                                    Width="200px" ToolTip="Fecha Lectura Final">
                                                    <ClientSideEvents Validation="EsRangoValido" />
                                                </dx:ASPxDateEdit>
                                            </td>
                                        </tr>



                                        <tr>
                                            <td rowspan="2">
                                                <div style="float: right">
                                                    <dx:ASPxImage ID="imgBuscar" runat="server" ImageUrl="../images/DxConfirm32.png" TabIndex="6"
                                                        ToolTip="Búsqueda" ClientInstanceName="imgBuscar" Cursor="pointer">
                                                        <ClientSideEvents Click="function(s,e){
                                                             if(deFechaInicial.GetValue()==null && deFechaFinal.GetValue()==null)
                                                             {
                                                                alert('Debe seleccionar por lo menos un filtro de búsqueda.')
                                                             }
                                                             else
                                                             {
                                                                 hfRutaSeleccionado.Clear();
                                                                 Consultar(s,e);
                                                             }
                                                             }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Filtrar" CssClass="comentario"></dx:ASPxLabel>
                                                    </div>
                                                </div>
                                            </td>

                                            <td rowspan="2">
                                                <div style="float: left">
                                                    &nbsp;&nbsp;<dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros" ClientInstanceName="imgBuscar" TabIndex="7" Cursor="pointer">
                                                        <ClientSideEvents Click="function(s, e){
                                                            LimpiaFormulario();
                                                        }" />
                                                    </dx:ASPxImage>
                                                    <div>
                                                        <dx:ASPxLabel ID="lblComentarioBorrar" runat="server" Text="Borrar" CssClass="comentario">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                </div>

                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <br />
                        <dx:ASPxRoundPanel ID="rpConsulta" runat="server" ClientInstanceName="rpConsulta" HeaderText="Información" Width="93%" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView ID="gridInfoRutas" runat="server" Width="100%" AutoGenerateColumns="False" ClientInstanceName="gridInfoRutas"
                                        KeyFieldName="idRuta" Font-Size="Small" Theme="SoftOrange">
                                        <SettingsBehavior AllowGroup="false" AllowDragDrop="false" />
                                        <Settings ShowTitlePanel="true" />
                                        <Templates>
                                            <%--<DetailRow>
                                                <dx:ASPxGridView ID="gridDetail" runat="server" AutoGenerateColumns="False" OnBeforePerformDataSelect="gridDetail_BeforePerformDataSelect" ClientInstanceName="gridDetail"
                                                    Font-Size="Small" KeyFieldName="idDetalle" Width="100%">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="Numero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="True" VisibleIndex="0">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Fecha Agenda" FieldName="fechaAgenda" ShowInCustomizationForm="True" VisibleIndex="1">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="True" VisibleIndex="3">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </DetailRow>--%>
                                            <DetailRow>
                                                <dx:ASPxGridView ID="gridDetail" runat="server" AutoGenerateColumns="False" OnBeforePerformDataSelect="gridDetail_BeforePerformDataSelect" ClientInstanceName="gridDetail"
                                                    Font-Size="Small" KeyFieldName="idDetalle" Width="100%">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="Numero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="True" VisibleIndex="0">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Fecha Agenda" FieldName="fechaAgenda" ShowInCustomizationForm="True" VisibleIndex="1">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="True" VisibleIndex="3">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>

                                            </DetailRow>
                                            <TitlePanel>
                                                <dx:ASPxButton ID="btnExportar" ClientInstanceName="btnExportar" Text="Exportar" runat="server" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s,e){                                                            
                                                            ExportarRutas(s,e);                                           
                                                        }" />
                                                </dx:ASPxButton>
                                            </TitlePanel>
                                        </Templates>
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="idRuta" Caption="Id Ruta" ShowInCustomizationForm="True" VisibleIndex="1">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="responsableEntrega" Caption="Responsable Entrega" ShowInCustomizationForm="True" VisibleIndex="2">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="tipoRuta" Caption="Tipo Ruta" ShowInCustomizationForm="True" Visible="false" VisibleIndex="3">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="estado" Caption="Estado" ShowInCustomizationForm="True" VisibleIndex="3">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="fechaCreacion" Caption="" ShowInCustomizationForm="True" VisibleIndex="4">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="#" VisibleIndex="11">
                                                <HeaderTemplate>
                                                    <header>
                                                        Todos
                                                    </header>
                                                    <dx:ASPxCheckBox ID="cm_selectAll" runat="server" ClientInstanceName="cm_selectAll" ToolTip="Select all rows" Theme="SoftOrange" BackColor="White" OnInit="cm_selectAll_Init">
                                                        <ClientSideEvents CheckedChanged="cm_OnAllCheckedChanged" />
                                                    </dx:ASPxCheckBox>
                                                </HeaderTemplate>
                                                <DataItemTemplate>
                                                    <dx:ASPxCheckBox ID="cbRuta" runat="server" ClientInstanceName="cbRuta" OnInit="Link_Init_chkBox" AutoPostBack="false" Theme="SoftOrange">
                                                        <ClientSideEvents CheckedChanged="seleccionarRuta" />
                                                    </dx:ASPxCheckBox>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsDetail ShowDetailRow="True" />
                                        <Templates>
                                            <DetailRow>
                                                <dx:ASPxGridView ID="gridDetail" runat="server" AutoGenerateColumns="False" OnBeforePerformDataSelect="gridDetail_BeforePerformDataSelect" ClientInstanceName="gridDetail"
                                                    Font-Size="Small" KeyFieldName="idDetalle" Width="100%">
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn Caption="Numero Radicado" FieldName="numeroRadicado" ShowInCustomizationForm="True" VisibleIndex="0">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Fecha Agenda" FieldName="fechaAgenda" ShowInCustomizationForm="True" VisibleIndex="1">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Cliente" FieldName="cliente" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Bodega" FieldName="bodega" ShowInCustomizationForm="True" VisibleIndex="3">
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <CellStyle HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </DetailRow>
                                        </Templates>
                                    </dx:ASPxGridView>

                                    <br />
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
            <dx:ASPxHiddenField runat="server" ID="hfRutaSeleccionado"
                ClientInstanceName="hfRutaSeleccionado">
            </dx:ASPxHiddenField>
            <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                Modal="True">
            </dx:ASPxLoadingPanel>
        </div>
    </form>
</body>
</html>
