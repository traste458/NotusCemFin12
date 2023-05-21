<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarSerialesGarantia.aspx.vb"
    Inherits="BPColSysOP.RegistrarSerialesGarantia" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registrar Seriales - Garantías</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        function validateSubmit() {
            if (document.form1.hfAuxiliar.value == "show") {
                $find(ModalProgress).show();
                document.form1.hfAuxiliar.value = "";
            }
        }

        function setAuxiliarValue(theValue) {
            document.form1.hfAuxiliar.value = theValue;
        }

    </script>

</head>
<body class="cuerpo2" onload="if($find(ModalProgress)){$find(ModalProgress).hide();}">
    <form id="form1" runat="server" onsubmit="validateSubmit();">
    <asp:ScriptManager ID="smAjaxManager" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
            <br />
            <table>
                <tr>
                    <td colspan="5" class="field">
                        <asp:Label ID="Label1" runat="server" Text="Formato de Archivo:" 
                            Font-Bold="True" Font-Italic="True" Font-Size="Small"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Tipo de Archivo:"></asp:Label></td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Font-Italic="true" Text=".txt"></asp:Label></td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td><asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Campos:"></asp:Label></td>
                    <td><asp:Label ID="Label4" runat="server" Font-Italic="true" Text="Serial, Material, Fecha de Cargue"></asp:Label></td>
                </tr>
            </table>
            <table class="tabla" width="500px" border="1" bordercolor="whitesmoke">
                <tr>
                    <th colspan="2" style="text-align: center">
                        REGISTRAR SERIALES
                    </th>
                </tr>
                <tr>
                    <td class="field" style="width: 120px;">
                        Archivo:
                    </td>
                    <td>
                        <asp:FileUpload ID="fuManager" runat="server" Width="350px" CssClass="search" />
                        <div style="display: block;">
                            <asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ErrorMessage="Escoja el archivo que contiene los seriales a registrar, por favor"
                                Display="Dynamic" ValidationGroup="registrarArchivo" ControlToValidate="fuManager"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revArchivo" runat="server" ErrorMessage="El archivo seleccionado no es válido. Se espera un archivo de texto (.txt)"
                                Display="Dynamic" ControlToValidate="fuManager" ValidationExpression=".+\.([Tt][Xx][Tt])"
                                ValidationGroup="registrarArchivo"></asp:RegularExpressionValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <br />
                        <asp:Button ID="btnRegistrarArchivo" runat="server" Text="Registrar" CssClass="submit"
                            ValidationGroup="registrarArchivo" 
                            OnClientClick="setAuxiliarValue('show');" />
                        <asp:HiddenField ID="hfAuxiliar" runat="server" />
                    </td>
                </tr>
            </table>
            <br />
            <br />
            <asp:Panel ID="pnlResultadoArchivo" runat="server">
                <table>
                    <tr>
                        <td>
                            <asp:GridView ID="gvErrores" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                ForeColor="#333333" GridLines="None" PageSize="100" ShowFooter="true" AllowPaging="True">
                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                <Columns>
                                    <asp:BoundField DataField="linea" HeaderText="LÍNEA" />
                                    <asp:BoundField DataField="descripcion" HeaderText="DESCRIPCIÓN" />
                                </Columns>
                                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                <EditRowStyle BackColor="#999999" />
                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnRegistrarArchivo" />
        </Triggers>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="ModalProgress1" runat="server" />
    </form>
</body>
</html>
