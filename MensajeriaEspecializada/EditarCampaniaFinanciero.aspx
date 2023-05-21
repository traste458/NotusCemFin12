<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarCampaniaFinanciero.aspx.vb" Inherits="BPColSysOP.EditarCampaniaFinanciero" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Editar Campañas Financieras :: </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function EjecutarCallbackRegistro(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpRegistro.PerformCallback(parametro + ':' + valor);
            }
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpRegistro" runat="server" ClientInstanceName ="cpRegistro">
            <ClientSideEvents EndCallback="function(s,e){ 
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide();
        }"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpCampania" runat="server" HeaderText="Editar Campañas Financiero"
                    Width="70%" Theme="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxPanel ID="pnlDatos" runat="server" Width="100%" ClientInstanceName="pnlDatos">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <table>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Nombre Campaña:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxTextBox ID="txtNombreCampania" runat="server" Width="150px" TabIndex="1">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField ErrorText="El nombre de la campaña  es requerido" IsRequired="True" />
                                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </td>
                                                    <td class ="field" align ="left">
                                                        Cliente:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxComboBox ID="cmbCl" runat="server" Width="150px" IncrementalFilteringMode="Contains"
                                                            ClientInstanceName="cmbCl" DropDownStyle="DropDownList" TabIndex="2" ValueType ="System.Int32">
                                                            <Columns>
                                                                <dx:ListBoxColumn FieldName="nombre" Width="250px" Caption="Descripción" />
                                                            </Columns>
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField ErrorText="El cliente de la campaña  es requerido" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="field" align="left">
                                                        Fecha Vigencia:
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaInicio" runat="server" NullText="Inicial..." ClientInstanceName="dateFechaInicio"
                                                            Width="100px" TabIndex="3">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                dateFechaFin.SetMinDate(dateFechaInicio.GetDate());
                                                            }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                                            </ValidationSettings>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxDateEdit ID="dateFechaFin" runat="server" NullText="Final..." ClientInstanceName="dateFechaFin"
                                                            Width="100px" TabIndex="4">
                                                            <ClientSideEvents ValueChanged="function(s, e){
                                                                dateFechaInicio.SetMaxDate(dateFechaFin.GetDate());
                                                            }" />
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCampania">
                                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                                            </ValidationSettings>
                                                        </dx:ASPxDateEdit>
                                                    </td>
                                                    <td>
                                                        <dx:ASPxCheckBox ID="cbActivo" runat="server">
                                                        </dx:ASPxCheckBox>
                                                        <div>
                                                            <dx:ASPxLabel ID="lblComentario" runat="server" Text="Activo S/N."
                                                                CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                            </dx:ASPxLabel>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                        <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="0" Width="100%">
                                                            <TabPages>
                                                                <dx:TabPage Text="Tipo Servicio">
                                                                    <TabImage Url="../images/structure.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl1" runat="server">
                                                                            <dx:ASPxPanel ID="pnlServicios" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbServicios" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdTipoServicio" Height="250px" ClientInstanceName="lbServicios">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="Nombre" Caption="Tipo Servicio" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Bodegas CEM">
                                                                    <TabImage Url="../images/list_num.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl2" runat="server">
                                                                            <dx:ASPxPanel ID="pnlBodega" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbBodegas" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdBodega" Height="250px" ClientInstanceName="lbBodegas">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="bodega" Caption="Bodega" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Producto Externo">
                                                                    <TabImage Url="../images/DxPikingList.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl3" runat="server">
                                                                            <dx:ASPxPanel ID="pnlProductoExt" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbProductoExt" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdProductoComercial" Height="250px" ClientInstanceName="lbProductoExt">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="ProductoExterno" Caption="Producto" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                                <dx:TabPage Text="Documentos">
                                                                    <TabImage Url="../images/documents_stack.png">
                                                                    </TabImage>
                                                                    <ContentCollection>
                                                                        <dx:ContentControl ID="ContentControl4" runat="server">
                                                                            <dx:ASPxPanel ID="pnlDocumentos" runat="server" ScrollBars="Auto" Height="250px">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxListBox ID="lbDocumentos" runat="server" Width="250px" SelectionMode="CheckColumn"
                                                                                            ValueField="IdProducto" Height="250px" ClientInstanceName="lbDocumentos">
                                                                                            <Columns>
                                                                                                <dx:ListBoxColumn FieldName="Nombre" Caption="Documentos" Width="250px" />
                                                                                            </Columns>
                                                                                        </dx:ASPxListBox>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxPanel>
                                                                        </dx:ContentControl>
                                                                    </ContentCollection>
                                                                </dx:TabPage>
                                                            </TabPages>
                                                        </dx:ASPxPageControl>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" align="center">
                                                        <dx:ASPxImage ID="imgCrear" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                            ToolTip="Actualizar Campaña" Cursor ="pointer">
                                                            <ClientSideEvents Click ="function (s, e){
                                                                if(ASPxClientEdit.ValidateGroup('vgCampania')){
                                                                    if(lbServicios.GetSelectedValues().length==0 || lbBodegas.GetSelectedValues().length==0 || lbDocumentos.GetSelectedValues().length==0){
                                                                        alert('No se han seleccionado todos los valores requeridos, por favor verifique que esten seleccionados Servicios, Ciudades, Productos y Documentos.');
                                                                    } else {
                                                                        EjecutarCallbackRegistro(s,e,'Actualizar');
                                                                    }
                                                                }
                                                            }" />
                                                        </dx:ASPxImage> 
                                                    </td> 
                                                </tr>
                                            </table>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxPanel>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel> 
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel> 
    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
