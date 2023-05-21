<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditarServicioFinanciero.aspx.vb" Inherits="BPColSysOP.EditarServicioFinanciero" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> :: Modificar Servicio Financiero ::</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function SetMaxLength(memo, maxLength) {
            if (!memo)
                return;
            if (typeof (maxLength) != "undefined" && maxLength >= 0) {
                memo.maxLength = maxLength;
                memo.maxLengthTimerToken = window.setInterval(function () {
                    var text = memo.GetText();
                    if (text && text.length > memo.maxLength)
                        memo.SetText(text.substr(0, memo.maxLength));
                }, 10);
            } else if (memo.maxLengthTimerToken) {
                window.clearInterval(memo.maxLengthTimerToken);
                delete memo.maxLengthTimerToken;
                delete memo.maxLength;
            }
        }

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                loadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral">
        <ClientSideEvents EndCallback="function(s, e) { 
            $('#divEncabezado').html(s.cpMensaje);
            loadingPanel.Hide();
        }" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpDatos" runat="server" HeaderText="Información Servicio"
                    Width="70%" Theme ="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table cellpadding="1" width="100%">
                                <tr>
                                    <td class ="field" align ="left">
                                        Tipo Servicio:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbTipoServicio" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbTipoServicio" DropDownStyle="DropDownList" TabIndex="1" ValueType ="System.Int32">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="nombre" Width="250px" Caption="Descripción" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="El tipo servicio es requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td class ="field" align ="left">
                                        Número Servicio:
                                    </td> 
                                    <td>
                                        <dx:ASPxTextBox ID="txtServicio" runat ="server" ClientInstanceName ="txtServicio" ClientEnabled ="false" 
                                            TabIndex ="2" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[0-9\s]+\s*$"/>
                                                <RequiredField IsRequired="true" ErrorText="El idServicio es requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Prioridad:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbPrioridad" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbPrioridad" DropDownStyle="DropDownList" TabIndex="3" ValueType ="System.Int32">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="prioridad" Width="250px" Caption="Descripción" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td class ="field" align ="left">
                                        Fecha Vencimiento:
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="dateFechaVencimiento" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaVencimiento"
                                            Width="100px" TabIndex="4">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxDateEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Usuario Ejecutor:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtEjecutor" runat ="server" ClientInstanceName ="txtEjecutor" ClientEnabled ="false" 
                                            TabIndex ="5" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td class ="field" align ="left">
                                        Nombres:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtNombres" runat ="server" ClientInstanceName ="txtNombres" ClientEnabled ="true" 
                                            TabIndex ="6" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Identificación:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtIdentificacion" runat ="server" ClientInstanceName ="txtIdentificacion" ClientEnabled ="false" 
                                            TabIndex ="7" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td class ="field" align ="left">
                                       Persona Contacto:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtContacto" runat ="server" ClientInstanceName ="txtContacto" ClientEnabled ="false" 
                                            TabIndex ="8" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Ciudad:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbCiudad" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbCiudad" DropDownStyle="DropDownList" TabIndex="9" ClientEnabled ="false" ValueType ="System.Int32">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="Ciudad" Width="250px" Caption="Descripción" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </td>
                                    <td class ="field" align ="left">
                                        Barrio:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtBarrio" runat ="server" ClientInstanceName ="txtBarrio" ClientEnabled ="true" 
                                            TabIndex ="10" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$"/>
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Dirección:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtDireccion" runat ="server" ClientInstanceName ="txtDireccion" ClientEnabled ="false" 
                                            TabIndex ="11" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td class ="field" align="left">
                                        Teléfono:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtTelefono" runat ="server" ClientInstanceName ="txtTelefono" ClientEnabled ="false" 
                                            TabIndex ="12" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field" align ="left">
                                        Fecha Asignación:
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="dateFechaAsignacion" runat="server" NullText="Seleccione..." ClientInstanceName="dateFechaAsignacion"
                                            Width="100px" TabIndex="13">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxDateEdit>
                                    </td>
                                    <td class ="field" align ="left" rowspan ="2">
                                        Observaciones:
                                    </td>
                                    <td rowspan ="2">
                                        <dx:ASPxMemo ID="meJustificacion" runat="server" Height="71px" Width="250px" NullText="Ingrese la observación..."
                                            ClientInstanceName="memo" TabIndex ="14">
                                            <ClientSideEvents KeyUp="function(s, e) {return SetMaxLength(memo,150); }" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgEditar">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="^\s*[a-zA-Z_0-9,;:\.\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-]+\s*$" />
                                                <RequiredField ErrorText="La Observación es requerida" IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxMemo>
                                    </td>
                                </tr>
                                <tr>
                                    <td align ="right">
                                        <dx:ASPxImage ID="imgActualiza" runat="server" ImageUrl="../images/DxConfirm32.png"
                                            ToolTip="Actualizar" Cursor ="pointer">
                                            <ClientSideEvents Click="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgEditar')){
                                                        EjecutarCallbackGeneral(s,e,'ActualizaServicio');
                                                    }
                                                }" />
                                        </dx:ASPxImage>
                                    </td>
                                    <td>
                                        <dx:ASPxImage ID="imgCancelar" runat="server" ImageUrl="../images/DxCancel32.png"
                                            ToolTip="Cancelar" Cursor ="pointer">
                                            <ClientSideEvents Click="function(s, e){
                                                if(confirm('Esta seguro que desea cancelar el servicio?'))
                                                    EjecutarCallbackGeneral(s,e,'CancelaServicio');
                                                }" />
                                        </dx:ASPxImage>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan ="4">
                                        Los cambios realizados sobre referencias, serán confirmados inmediatamente
                                        en la base de datos. El botón &quot;Actualizar&quot; solo aplica para los cambios
                                        sobre la cabecera del servicio.<br />
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>

                <dx:ASPxRoundPanel ID= "rpDetalle" runat ="server" HeaderText ="Detalle Servicio" Width="70%" Theme ="SoftOrange">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table>
                                <tr>
                                    <td rowspan ="4">
                                        <dx:ASPxGridView ID="gvReferencias" runat="server" AutoGenerateColumns="False" ClientInstanceName ="gvReferencias"
                                            Width="100%" Theme ="SoftOrange" KeyFieldName ="IdMaterialServicio">
                                            <ClientSideEvents EndCallback ="function (s, e){
                                                $('#divEncabezado').html(s.cpMensaje);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="Material" ShowInCustomizationForm="True" VisibleIndex="1"
                                                    Caption="Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DescripcionMaterial" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" Caption="Descripción Material">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Cantidad" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" Caption="Cantidad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="3" Width="100px">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/eraser_minus.png"
                                                            Cursor="pointer" ToolTip="Eliminar" OnInit="Link_Init">
                                                            <ClientSideEvents Click="function(s, e) { 
                                                                if (confirm('Esta seguro de eliminar este producto?')){
                                                                    gvReferencias.PerformCallback('EliminarReferencia:' + {0});
                                                                }
                                                             }" />
                                                        </dx:ASPxHyperLink>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn> 
                                            </Columns>
                                            <SettingsBehavior AllowSelectByRowClick="true" />
                                            <SettingsPager PageSize="5">
                                            </SettingsPager>
                                        </dx:ASPxGridView>
                                    </td>
                                    <td class ="field">
                                        Agregar Producto:
                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="cmbProducto" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                            ClientInstanceName="cmbProducto" DropDownStyle="DropDownList" TabIndex ="15">
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="Nombre" Width="250px" Caption="Descripción" />
                                            </Columns>
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAgrega">
                                                <RequiredField IsRequired="true" ErrorText="Registro requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class ="field">
                                        Cantidad:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtCantidad" runat ="server" ClientInstanceName ="txtCantidad" 
                                            TabIndex ="16" Width ="250px">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAgrega">
                                                <RegularExpression ErrorText="Formato no valido" ValidationExpression="[1-9][0-9]{0,9}"/>
                                                <RequiredField IsRequired="true" ErrorText="La cantidad es requerida" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxImage ID="imgAgrega" runat="server" ImageUrl="../images/DxAdd32.png"
                                            ToolTip="Agregar" TabIndex="17" Cursor ="pointer">
                                            <ClientSideEvents Click="function (s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgAgrega')){
                                                        gvReferencias.PerformCallback('AgregarReferencia');
                                                    }
                                                }" />
                                        </dx:ASPxImage>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel> 
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel> 
    <dx:ASPxLoadingPanel ID="loadingPanel" runat="server" ClientInstanceName="loadingPanel"
        Modal="True">
    </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
