<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CargueInventarioServicioFinancierosSerializado.aspx.vb" Inherits="BPColSysOP.CargueInventarioServicioFinancierosSerializado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>::: Cargue Inventario Pod. Financiero ::: </title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
    <script type="text/javascript">
        
        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            LoadingPanel.Show();
            cpGeneral.PerformCallback(parametro + '|' + valor);
        }

    </script>
</head>
<body>
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div>
            <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
                <ClientSideEvents EndCallback="function(s,e){ 
                $('#divEncabezado').html(s.cpMensaje);
                LoadingPanel.Hide();
            }"></ClientSideEvents>
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxCallback ID="callback" runat="server" ClientInstanceName="callback">
                            <ClientSideEvents EndCallback="function (s,e){
                    }" />
                        </dx:ASPxCallback>
                        <dx:ASPxPageControl ID="pcConsulta" runat="server" ActiveTabIndex="1" ClientInstanceName="pcConsulta"
                            EnableTheming="True" Height="80%" Theme="Default" Width="100%" ClientVisible="true" Visible="true">
                            <TabPages>
                                <dx:TabPage Text="Inventario Individual" Name="tbIndividual">
                                    <TabImage Url="../images/usuario.png">
                                    </TabImage>
                                    <ContentCollection>
                                        <dx:ContentControl ID="ContentControl1" runat="server">
                                            <dx:ASPxRoundPanel ID="rpAdministradorInventario" ClientInstanceName="rpAdministradorInventario" ClientVisible="true" runat="server" HeaderText="Administración Inventario Financiero"
                                                Width="70%" Theme="Default">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table cellpadding="1" width="100%">
                                                            <tr>
                                                                <td class="field" align="left">Cedula Cliente:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtCedulaCliente" ClientInstanceName="txtCedulaCliente" runat="server" Width="270px" MaxLength="50">
                                                                        <ClientSideEvents LostFocus="function(s, e) { if(txtCedulaCliente.GetValue() != null){
                                                                            EjecutarCallbackGeneral(s, e, 'consultarCliente',txtCedulaCliente.GetValue());
                                                                            } else{
                                                                            cmbBodega.ClearItems();
                                                                            cmbMaterialSerial.ClearItems();
                                                                            }
                                                        
                                                                        }"></ClientSideEvents>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td class="field" align="left">Bodega Destino:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxComboBox ID="cmbBodega" runat="server" ClientInstanceName="cmbBodega" ValueType="System.String" ValueField="idBodega" Width="470px">
                                                                        <Columns>
                                                                            <dx:ListBoxColumn FieldName="idBodega" Caption="IdBod|idServicio" Width="90px" Visible="true" />
                                                                            <dx:ListBoxColumn FieldName="bodega" Caption="Nombre" Width="300px" />
                                                                        </Columns>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { EjecutarCallbackGeneral(s, e, 'cargarMateriales',cmbBodega.GetValue()); }"></ClientSideEvents>
                                                                    </dx:ASPxComboBox>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td class="field" align="left">Material Serial:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxComboBox ID="cmbMaterialSerial" ClientInstanceName="cmbMaterialSerial" runat="server" ValueType="System.String" ValueField="Material" Width="470px" ValidationGroup="vgCargar">
                                                                        <Columns>
                                                                            <dx:ListBoxColumn FieldName="Material" Caption="Material" Width="90px" Visible="true" />
                                                                            <dx:ListBoxColumn FieldName="descripcion" Caption="Nombre" Width="300px" />
                                                                        </Columns>
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td class="field" align="left">Serial:
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtSerial" ClientInstanceName="txtSerial" runat="server" Width="370px" MaxLength="50">
                                                                        <ClientSideEvents KeyUp="function(s, e) { var txt = s.GetText(); s.SetText(txt.toUpperCase()); }" />

                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                                            <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                            <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero de serial v&#225;lido"
                                                                                ValidationExpression="[0-9][0-9]{14,25}"></RegularExpression>
                                                                        </ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </td>

                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxButton ID="btnGuardar" runat="server" AutoPostBack="false" Text="Guardar"
                                                                        ClientInstanceName="btnGuardar" ClientEnabled="true" ValidationGroup="vgCargar">
                                                                        <ClientSideEvents Click="function(s, e) { 
                                                                            if(ASPxClientEdit.ValidateGroup('vgCargue') && ASPxClientEdit.AreEditorsValid()){
                                                                               EjecutarCallbackGeneral(s, e, 'cargarSerial',cmbBodega.GetValue()); 
                                                                                                             
                                                                                }
                                                                        }"></ClientSideEvents>
                                                                        <Image Url="../images/upload.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxButton ID="btnLimpiar" ClientInstanceName="btnLimpiar" runat="server" Text="Limpiar" AutoPostBack="false" ToolTip="Limpiar ">
                                                                        <ClientSideEvents Click="function(s, e) { 
                                                        cmbBodega.ClearItems();
                                                        cmbMaterialSerial.ClearItems();
                                                        txtCedulaCliente.SetValue('');
                                                        txtSerial.SetValue('');
                                                        rpAdministradorInventario.SetClientVisible(true);

                                                    }"></ClientSideEvents>
                                                                        <Image Url="../images/eraser_minus.png">
                                                                        </Image>
                                                                    </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                                <dx:TabPage Text="Inventario Masivo" Name="tbMasivo">
                                    <TabImage Url="../images/xlsx_win.png">
                                    </TabImage>
                                    <ContentCollection>
                                        <dx:ContentControl ID="ContentControl2" runat="server">
                                            <dx:ASPxRoundPanel ID="rpAdminInventarioMasivo" runat="server" ClientInstanceName="rpAdminInventarioMasivo" ClientVisible="true" HeaderText="Administracion Inventario Masivo"
                                                Width="70%" Theme="Default">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <table>
                                                            <tr>
                                                                <td>Archivo:</td>
                                                                <td>
                                                                    <div id="cargarArchivo">
                                                                        <asp:FileUpload ID="fuArchivo" runat="server" Width="700px" />
                                                                        <asp:Label ID="lblObligatorio" runat="server" ForeColor="Red" Text="*" Width="50px" />
                                                                        <div>
                                                                            <asp:RegularExpressionValidator ID="revArchivo" runat="server"
                                                                                CssClass="listSearchTheme" ErrorMessage="Formato del archivo incorrecto<br/>" ControlToValidate="fuArchivo" Display="Dynamic"
                                                                                ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.xls|.xlsx|.XLSX|.XLS|.Xlsx|.Xls)$" ValidationGroup="validacion"></asp:RegularExpressionValidator>
                                                                            <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Es necesario seleccionar un archivo."
                                                                                ControlToValidate="fuArchivo" Display="Dynamic" ValidationGroup="validacion" />
                                                                        </div>
                                                                        <div class="comentario" style="font-size: small">Cargar archivos con extensión (xls o xlsx)</div>

                                                                    </div>
                                                                    <asp:LinkButton ID="lbVerArchivo" runat="server">(Ver Archivo Ejemplo)</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    <div style="float: inherit; margin-top: 5px; margin-bottom: 5px;">
                                                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="false" Text="Procesar archivo"
                                                                            ClientInstanceName="btnUpload" ClientEnabled="true">
                                                                            <ClientSideEvents Click="function(s, e) { 
                                                                                LoadingPanel.Show(); 
                                                                            }"></ClientSideEvents>
                                                                            <Image Url="../images/upload.png">
                                                                            </Image>
                                                                        </dx:ASPxButton>
                                                                    </div>
                                                                    <div style="float: left; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                        <fieldset>
                                                                            <div id="divFileContainer" style="width: auto">
                                                                            </div>
                                                                        </fieldset>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                            <dx:ASPxPopupControl ID="pcErrores" runat="server" ClientInstanceName="dialogoErrores" ScrollBars="Auto"
                                                HeaderText="Resultado Consulta - Log de Errores" AllowDragging="true" Width="450px" Height="500px"
                                                Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl ID="pccError" runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxComboBox ID="cbFormatoExportar" runat="server" ShowImageInEditBox="true"
                                                                        SelectedIndex="-1" ValueType="System.String" EnableCallbackMode="true" AutoResizeWithContainer="true"
                                                                        AutoPostBack="false"  ClientInstanceName="cbFormatoExportar"
                                                                        Width="250px">
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
                                                                            <RegularExpression ErrorText="Fall&#243; la validaci&#243;n de expresi&#243;n Regular"></RegularExpression>
                                                                            <RequiredField IsRequired="true" ErrorText="Formato a exportar requerido" />
                                                                        </ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores">
                                                            <SettingsPager PageSize="10">
                                                            </SettingsPager>
                                                        </dx:ASPxGridView>
                                                        <dx:ASPxGridViewExporter ID="gveErrores" runat="server" GridViewID="gvErrores">
                                                        </dx:ASPxGridViewExporter>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                            </TabPages>
                        </dx:ASPxPageControl>

                        <dx:ASPxRoundPanel ID="rpAdministrador" runat="server" ClientInstanceName="rpAdministrador" ClientVisible="false" HeaderText="Administración Inventario Financiero"
                            Width="70%" Theme="SoftOrange">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table cellpadding="1" width="100%">
                                        <tr>
                                            <td class="field" align="left">Bodega Destino:
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbBodegasFinancieros" runat="server" ClientInstanceName="cmbBodegasFinancieros" ValueType="System.String" ValueField="idBodega" Width="470px">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="idBodega" Caption="IdBodega" Width="90px" Visible="true" />
                                                        <dx:ListBoxColumn FieldName="bodega" Caption="Nombre" Width="300px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field" align="left">Material Serial:
                                            </td>
                                            <td>
                                                <dx:ASPxComboBox ID="cmbMaterialTipoServicio" ClientInstanceName="cmbMaterialTipoServicio" runat="server" ValueType="System.String" ValueField="Material" Width="470px" ValidationGroup="vgCargar">
                                                    <Columns>
                                                        <dx:ListBoxColumn FieldName="Material" Caption="Material" Width="90px" Visible="true" />
                                                        <dx:ListBoxColumn FieldName="descripcion" Caption="Nombre" Width="300px" />
                                                    </Columns>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="field" align="left">Serial:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtSerialTiposervicio" ClientInstanceName="txtSerialTiposervicio" runat="server" Width="370px" MaxLength="50">
                                                    <ClientSideEvents KeyUp="function(s, e) { var txt = s.GetText(); s.SetText(txt.toUpperCase()); }" />

                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCargar">
                                                        <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                        <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero de serial v&#225;lido"
                                                            ValidationExpression="[0-9][0-9]{10,25}"></RegularExpression>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnGuardars" runat="server" AutoPostBack="false" Text="Guardar"
                                                    ClientInstanceName="btnGuardars" ClientEnabled="true" ValidationGroup="vgCargar">
                                                    <ClientSideEvents Click="function(s, e) { 
                                                    if(ASPxClientEdit.ValidateGroup('vgCargue') && ASPxClientEdit.AreEditorsValid()){
                                                       EjecutarCallbackGeneral(s, e, 'RegistrarSerial',cmbBodegasFinancieros.GetValue()); 
                                                                                                             
                                                        }
                                                    }"></ClientSideEvents>
                                                    <Image Url="../images/upload.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnLimpiars" ClientInstanceName="btnLimpiars" runat="server" Text="Limpiar" AutoPostBack="false" ToolTip="Limpiar ">
                                                    <ClientSideEvents Click="function(s, e) { 
                                                        cmbTipoServicio.SetSelectedIndex('-1');
                                                        cmbMaterialTipoServicio.SetSelectedIndex('-1');
                                                        cmbBodegasFinancieros.SetSelectedIndex('-1');
                                                        txtCedulaCliente.SetValue('');
                                                        txtSerialTiposervicio.SetValue('');
                                                        rpAdministrador.SetClientVisible(false);
                                                    }"></ClientSideEvents>
                                                    <Image Url="../images/eraser_minus.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
