<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SubirInformacionParaDespachos.aspx.vb"
    Inherits="BPColSysOP.SubirInformacionParaDespachos" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>:: Subir Información Para Despachos ::</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
        function VerificarCantidad(source, arguments) {
            try {
                var diferencia = 0
                diferencia = document.getElementById("txtGuiaFinal").value.trim() - document.getElementById("txtGuiaInicial").value.trim()
                if (diferencia < 1000) {
                    arguments.IsValid = false;
                }
                else {
                    arguments.IsValid = true;
                }
                
                
            } catch (e) {
                arguments.IsValid = false;
            }

        }
        
    </script>

</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        <table width="1000px" class="tabla">
            <thead>
                <tr>
                    <th colspan="2">
                        Escoja tipo de dato que desea subir
                    </th>
                </tr>
            </thead>
            <tr>
                <td width="20%" class="field">
                    Opciones
                </td>
                <td>
                    <asp:DropDownList ID="ddlOpciones" runat="server" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Panel ID="pnlInfoTransportadoras" runat="server" Style="padding-top: 15px">
                        <table style="width: 100%;" class="tabla">
                            <tr>
                                <td class="field" width="20%">
                                    Archivo de Transportadoras:
                                </td>
                                <td width="40%">
                                    &nbsp;
                                    <asp:FileUpload ID="fuTransportadoras" runat="server" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fuTransportadoras"
                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;Debe escoger un archivo" ValidationGroup="transportadoras">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="Dynamic"
                                        ErrorMessage="&lt;br /&gt;El archivo no tiene la extensión esperada" ValidationExpression=".*(\.[Xx][Ll][Ss])"
                                        ValidationGroup="transportadoras" ControlToValidate="fuTransportadoras">
                                    </asp:RegularExpressionValidator>
                                </td>
                                <td>
                                    <asp:LinkButton ID="lnkBajarMatrizActual" runat="server" CausesValidation="False"
                                        CssClass="search">
<img alt="xls" src="../images/Excel.gif" /> Bajar Plantilla de Matriz Actual</asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                    <asp:Button ID="btnSubirTransportadoras" runat="server" CssClass="submit" Text="Subir Archivo"
                                        ValidationGroup="transportadoras" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlValorDeclarado" runat="server" Style="padding-top: 15px">
                        <table style="width: 100%;" class="tabla">
                            <tr>
                                <td class="field" width="20%">
                                    Archivo de Valores:
                                </td>
                                <td>
                                    &nbsp;
                                    <asp:FileUpload ID="fuValores" runat="server" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic"
                                        ErrorMessage="&lt;br /&gt;Debe escoger un archivo" ValidationGroup="valores"
                                        ControlToValidate="fuValores">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" Display="Dynamic"
                                        ErrorMessage="&lt;br /&gt;El archivo no tiene la extensión esperada" ValidationExpression=".*(\.[Xx][Ll][Ss])"
                                        ValidationGroup="valores" ControlToValidate="fuValores">
                                    </asp:RegularExpressionValidator>
                                </td>
                                <td>
                                    <asp:LinkButton ID="lnkBajarValoresActuales" runat="server" CausesValidation="False"
                                        CssClass="search">
<img alt="xls" src="../images/Excel.gif" /> Bajar Plantilla de Valores Actuales</asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                    <asp:Button ID="btnSubirValores" runat="server" CssClass="submit" Text="Subir Archivo"
                                        ValidationGroup="valores" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlGuias" runat="server" Style="padding-top: 15px">
                        <table style="width: 100%;" class="tabla">
                            <tr>
                                <td class="field" width="10%">
                                    Transportadora:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlTransportadoras" runat="server" ValidationGroup="guias">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlTransportadoras"
                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;Debe escoger una transportadora"
                                        InitialValue="0" ValidationGroup="guias">
                                    </asp:RequiredFieldValidator>
                                </td>
                                <td class="field" width="10%">
                                    Guia Inicial:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtGuiaInicial" runat="server" MaxLength="15" ValidationGroup="guias">
                                    </asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic"
                                        ErrorMessage="&lt;br /&gt;Debe digitar un valor para la guia inicial" ValidationGroup="guias"
                                        ControlToValidate="txtGuiaInicial">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtGuiaInicial"
                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;El valor debe ser numérico" ValidationExpression="^[0-9]+$"
                                        ValidationGroup="guias">
                                    </asp:RegularExpressionValidator>
                                </td>
                                <td class="field" width="10%">
                                    Guia Final:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtGuiaFinal" runat="server" MaxLength="15" ValidationGroup="guias">
                                    </asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtGuiaFinal"
                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;Debe digitar un valor para la guia final"
                                        ValidationGroup="guias">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtGuiaFinal"
                                        Display="Dynamic" ErrorMessage="&lt;br /&gt;El valor debe ser numérico" ValidationExpression="^[0-9]+$"
                                        ValidationGroup="guias">
                                    </asp:RegularExpressionValidator>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtGuiaInicial"
                                        ControlToValidate="txtGuiaFinal" Display="Dynamic" ErrorMessage="&lt;br /&gt;El valor de la guía final debe ser mayor que el de la inicial"
                                        Operator="GreaterThanEqual" Type="Double" ValidationGroup="guias">
                                    </asp:CompareValidator>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server" ClientValidationFunction="VerificarCantidad"
                                        ErrorMessage="&lt;br /&gt;Debe registrar un número mayor a mil guías" ValidationGroup="guias"
                                        Display="Dynamic">
                                    </asp:CustomValidator>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <asp:Button ID="btnGuias" runat="server" CssClass="submit" Text="Registrar Rango"
                                        ValidationGroup="guias" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlErrores" runat="server" Visible="false">
                        <blockquote>
                            Se produjeron los siguientes errores durante la lectura del archivo, ningún dato
                            fue registrado en la base de datos</blockquote>
                        <asp:GridView ID="gvErrores" runat="server" CssClass="tabla" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="Fila" HeaderText="Fila del Archivo">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="mensaje" HeaderText="Mensaje de Error">
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
