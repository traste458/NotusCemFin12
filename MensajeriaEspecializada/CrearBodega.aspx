<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearBodega.aspx.vb" Inherits="BPColSysOP.CrearBodega" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
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
                            <asp:Label runat="server" ID="lbBodega">Bodega :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txBodega" placeholder="Bodega (CME_BGA)" BorderWidth="0px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txBodega"
                                Display="Dynamic" ErrorMessage="El campo codigo bodega es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbNomBodega">Nombre Bodega :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txNomBod" placeholder="Nombre de bodea" BorderWidth="0px" Width="308px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txNomBod"
                                Display="Dynamic" ErrorMessage="El campo nombre bodega es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbDireccion">Dirección :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txDireccion" placeholder="Cra 123" BorderWidth="0px" Width="269px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txDireccion"
                                Display="Dynamic" ErrorMessage="El campo telefono es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbTelefono">Telefono :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txTelefono" placeholder="12345" BorderWidth="0px"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txTelefono"
                                Display="Dynamic" ErrorMessage="El campo telefono es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorCantidadUnidades" runat="server"
                                ControlToValidate="txTelefono" Display="Dynamic" ErrorMessage="La cantidad debe ser numérica y mayor que cero"
                                ValidationExpression="[1-9][0-9]{0,9}" ValidationGroup="vgBuscar"></asp:RegularExpressionValidator><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                ControlToValidate="txTelefono" Display="Dynamic" ErrorMessage="La cantidad debe estar entre 7 a 10 digitos"
                                ValidationExpression="[0-9]{7,10}" ValidationGroup="vgBuscar"></asp:RegularExpressionValidator>
                        </td>
                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label1">Producto sin reconocimiento :</asp:Label>
                        </td>
                        <td>
                            <asp:RadioButton runat="server" ID="rdBtnTrue" GroupName="reconocimiento" Text="Si" />
                            <asp:RadioButton runat="server" ID="rdBtnFalse" GroupName="reconocimiento" Text="No" />
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="Label2">Cliente Externo :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCliExt" runat="server" ClientInstanceName="cmbCliExt" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="cmbCliExt"
                                Display="Dynamic" ErrorMessage="El campo cliente externo es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                    </tr>

                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbUnidNegocio">Unidad de negocio :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbUnidNegocio" runat="server" ClientInstanceName="cmbUnidNegocio" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbUnidNegocio"
                                Display="Dynamic" ErrorMessage="El campo unidad de negocio es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbTipo">Tipo:</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbTipo" runat="server" ClientInstanceName="cmbTipo" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbTipo"
                                Display="Dynamic" ErrorMessage="El campo tipo es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbCodBodega">Codigo :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txCodigo" Placeholder="Codigo de Bodega" BorderWidth="0px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txCodigo"
                                Display="Dynamic" ErrorMessage="El campo codigo es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbCiudad">Ciudad Principal :</asp:Label>
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbCiudad" runat="server" ClientInstanceName="cmbCiudad" FilterMinLength="0"
                                Width="200px" Theme="SoftOrange" ValueType="System.Int32"
                                IncrementalFilteringMode="Contains" CallbackPageSize="25" EnableCallbackMode="true" TabIndex="6">
                                <InvalidStyle BackColor="#ffffcc"></InvalidStyle>
                            </dx:ASPxComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbCiudad"
                                Display="Dynamic" ErrorMessage="El campo ciudad es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="lbCentro">Centro :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txCentro" placeholder="Centro de Bodega" BorderWidth="0px" Width="471px" MaxLength="5"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txCentro"
                                Display="Dynamic" ErrorMessage="El campo centro es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="lbAlmacen">Almacen :</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txAlmacen" placeholder="Almacen de Bodega" BorderWidth="0px" Width="276px" MaxLength="5"></asp:TextBox><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txAlmacen"
                                Display="Dynamic" ErrorMessage="El campo Almacen es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>

                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label3">Token SimpliRoute:</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtTokenSimpliRoute" Placeholder="Token SimpliRoute" BorderWidth="0px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtTokenSimpliRoute"
                                Display="Dynamic" ErrorMessage="El campo Token SimpliRoute es obligatorio" ValidationGroup="vgBuscar"></asp:RequiredFieldValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="Label4">Horario de atención:</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtHorarioAtencion" BorderWidth="0px" Width="471px"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td class="field">
                            <asp:Label runat="server" ID="Label9">Codigo Sucursasl InterRapidisimo:</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtcodigoSucursalInterRapidisimo" placeholder="12345" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtcodigoSucursalInterRapidisimo"
                                Display="Dynamic" ErrorMessage="Solo numeros" ValidationExpression="[0-9]+" ValidationGroup="vgBuscar"></asp:RegularExpressionValidator>
                        </td>
                        <td class="field">
                            <asp:Label runat="server" ID="Label5">ID Sucursal:</asp:Label>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtIdSucursal" BorderWidth="0px" Width="471px"></asp:TextBox><br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <center>
                       <br />
                       <asp:Button runat="server" ID="BtnCreaBodega" ValidationGroup="vgBuscar" Text="Crear"/>

                     </center>
                        </td>

                    </tr>

                </table>

            </asp:Panel>


        </div>
    </form>
</body>
</html>
