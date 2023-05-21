<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="editarBodega.aspx.vb" Inherits="BPColSysOP.editarBodega" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Creación de Bodega</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
</head>

<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
        </div>
        <div>
            <asp:Panel ID="pnlCreacion" runat="server">

                <table class="tablaGris">
                    <tr>
                        <th colspan="4" style="text-align: center;">
                            <b>Formulario</b>
                        </th>
                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbCodBodega">Codigo :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txCodigo" Placeholder="Codigo de Bodega" BorderWidth="0px" Width="230px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="rqCodigo" runat="server" ControlToValidate="txCodigo"
                                Display="Dynamic" ErrorMessage="El campo codigo es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbBodega">Bodega :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txBodega" placeholder="Bodega (CME_BGA)" BorderWidth="0px" Width="280px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="rqBodega" runat="server" ControlToValidate="txBodega"
                                Display="Dynamic" ErrorMessage="El campo codigo bodega es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>

                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbNomBodega">Nombre Bodega :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txNomBod" placeholder="Nombre de bodea" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="rqNomBod" runat="server" ControlToValidate="txNomBod"
                                Display="Dynamic" ErrorMessage="El campo nombre bodega es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbDireccion">Dirección :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txDireccion" placeholder="Cra 123" BorderWidth="0px" Width="276px" TextMode="MultiLine"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="rqDieccion" runat="server" ControlToValidate="txDireccion"
                                Display="Dynamic" ErrorMessage="El campo direccion es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>

                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbTelefono">Telefono :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txTelefono" placeholder="12345" BorderWidth="0px" Width="230px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txTelefono"
                                Display="Dynamic" ErrorMessage="El campo telefono es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorCantidadUnidades" runat="server"
                                ControlToValidate="txTelefono" Display="Dynamic" ErrorMessage="La cantidad debe ser numérica y mayor que cero"
                                ValidationExpression="[1-9][0-9]{0,9}" ValidationGroup="vgBodega"></asp:RegularExpressionValidator><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                ControlToValidate="txTelefono" Display="Dynamic" ErrorMessage="La cantidad debe estar entre 7 a 10 digitos"
                                ValidationExpression="[0-9]{7,10}" ValidationGroup="vgBodega"></asp:RegularExpressionValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="Label1">Producto sin reconocimiento :</asp:Label>
                        </td>
                        <td>
                            <asp:RadioButton runat="server" ID="rdBtnTrue" GroupName="reconocimiento" Text="Si" />
                            <asp:RadioButton runat="server" ID="rdBtnFalse" GroupName="reconocimiento" Text="No" />
                        </td>

                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label2">Cliente Externo :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCliExt" runat="server" ClientInstanceName="cmbCliExt" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="cmbCliExt"
                                Display="Dynamic" ErrorMessage="El campo cliente externo es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbUnidNegocio">Unidad de negocio :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbUnidNegocio" runat="server" ClientInstanceName="cmbUnidNegocio" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.String"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rqNegocio" runat="server" ControlToValidate="cmbUnidNegocio"
                                Display="Dynamic" ErrorMessage="El campo unidad de negocio es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>

                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbTipo">Tipo:</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbTipo" runat="server" ClientInstanceName="cmbTipo" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rqTippo" runat="server" ControlToValidate="cmbTipo"
                                Display="Dynamic" ErrorMessage="El campo tipo bodega es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbCiudad">Ciudad :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCiudad" runat="server" ClientInstanceName="cmbCiudad" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbCiudad"
                                Display="Dynamic" ErrorMessage="El campo ciudad es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label3">Token SimpliRoute :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtTokenSimpliRoute" placeholder="Token SimpliRoute" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtTokenSimpliRoute"
                                Display="Dynamic" ErrorMessage="El campo Token SimpliRoute es obligatorio" ValidationGroup="vgBodega"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field" colspan="2"></td>
                        <tr>
                            <td class="field">
                                <asp:Label runat="server" ID="Label5">ID Sucursal:</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txtIdSucursal" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                            </td>
                        </tr>


                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label9">Codigo Sucursasl InterRapidisimo:</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtcodigoSucursalInterRapidisimo" placeholder="12345" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtcodigoSucursalInterRapidisimo"
                                Display="Dynamic" ErrorMessage="Solo numeros" ValidationExpression="[0-9]+" ValidationGroup="vgBodega"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="Panel1" runat="server" Width="1117px">
                <table>

                    <tr>
                        <td valign="top">
                            <div style="overflow: auto; height: 220px; width: 320px">
                                <div>
                                    Ciudades Libres
                                </div>
                                <asp:GridView ID="gvCiudades" runat="server" AutoGenerateColumns="False"
                                    CellPadding="4" ForeColor="#333333" GridLines="None" DataKeyNames="idCiudad">
                                    <Columns>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSeleccion" runat="server" />
                                            </ItemTemplate>

                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ciudad" HeaderText="Ciudad" />
                                    </Columns>
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                    <EmptyDataTemplate>
                                        No hay registros
                                    </EmptyDataTemplate>

                                </asp:GridView>
                            </div>
                        </td>
                        <td valign="middle">
                            <asp:Button ID="btnSeleccionar" runat="server" Text=">>"
                                OnClick="btnSeleccionar_Click" />
                            <br />
                            <br />
                            <asp:Button ID="btnQuitar" runat="server" Text="<<" OnClick="btnQuitar_Click" />
                        </td>
                        <td valign="top">
                            <div style="overflow: auto; height: 220px; width: 320px">
                                <div>
                                    Ciudades Seleccionadas
                                </div>
                                <asp:GridView ID="gvSeleccion" runat="server" AutoGenerateColumns="False"
                                    CellPadding="4" ForeColor="#333333" GridLines="None" DataKeyNames="idCiudad">

                                    <Columns>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSeleccion" runat="server" />
                                            </ItemTemplate>

                                        </asp:TemplateField>
                                        <asp:BoundField DataField="idBodegaCiudad" HeaderText="id" />
                                        <asp:BoundField DataField="ciudad" HeaderText="Ciudad" />
                                    </Columns>
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                                    <EmptyDataTemplate>
                                        Seleccione un item de la lista para agregar
                                    </EmptyDataTemplate>
                                    <AlternatingRowStyle BackColor="White" />
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3">
                            <center>
                       <br />
                        <asp:Button runat="server" ID="btnActu" Text="Actualizar" ValidationGroup="vgBodega"/>

                     </center>
                        </td>

                    </tr>
                </table>
            </asp:Panel>

        </div>
    </form>
</body>
</html>
