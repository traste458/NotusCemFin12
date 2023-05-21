<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VisualizarInfoCasoSAC.aspx.vb" Inherits="BPColSysOP.VisualizarInfoCasoSAC" %>

<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="../ControlesDeUsuario/ModalProgress.ascx" TagName="ModalProgress"
    TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Visualizar Información de Caso</title>
    <script src="../include/jquery-1.js" type="text/javascript"></script>

    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript"></script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="smAjaxManager" runat="server" EnableScriptGlobalization="true">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
            <uc1:EncabezadoPagina ID="epGeneral" runat="server" />
            <asp:Panel ID="pnlDatosCaso" runat="server">
                <table style="width: 90%;" class="tabla" border="1" bordercolor="#f0f0f0" cellspacing="1"
                    cellpadding="1">
                    <tr>
                        <th colspan="6">
                            Información General del Caso
                        </th>
                    </tr>
                    <tr>
                        <td class="field">
                            No. de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblNoCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Cliente:
                        </td>
                        <td>
                            <asp:Label ID="lblCliente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Generador de Inconformidad:
                        </td>
                        <td>
                            <asp:Label ID="lblGenInconformidad" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Clase de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblClaseCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Tipo de Caso:
                        </td>
                        <td>
                            <asp:Label ID="lblTipoCaso" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Fecha Recepción:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRecepcion" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">
                            Remitente:
                        </td>
                        <td>
                            <asp:Label ID="lblRemitente" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Tramitador:
                        </td>
                        <td>
                            <asp:Label ID="lblTramitador" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">
                            Estado:
                        </td>
                        <td>
                            <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Generó Cobro?;</td>
                        <td>
                            <asp:Label ID="lblGeneroCobro" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">Valor Cobro:</td>
                        <td>
                            <asp:Label ID="lblValorCobro" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">Responsable Cobro:</td>
                        <td><asp:Label ID="lblResponsableCobro" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="field">
                            Fecha Respuesta:
                        </td>
                        <td>
                            <asp:Label ID="lblFechaRespuesta" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="field">Fecha de Cierre:</td>
                        <td><asp:Label ID="lblFechaCierre" runat="server" Text=""></asp:Label></td>
                        <td class="field">Usuario que Cierra:</td>
                        <td><asp:Label ID="lblUsuarioCierra" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                        
                        <td class="field">
                            Descripcion:
                        </td>
                        <td colspan="5">
                            <asp:Label ID="lblDescripcion" runat="server" Text=""></asp:Label>
                            <asp:HiddenField ID="hIdCaso" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="field">Respuesta:</td>
                        <td colspan="5"><asp:Label ID="lblRespuesta" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="field">Observación:</td>
                        <td colspan="5"><asp:Label ID="lblObservacion" runat="server" Text=""></asp:Label></td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlGestionRealizada" runat="server">
                <table class="tabla" style="width: 90%">
                    <tr>
                        <th>
                            Información de Gestión del Caso
                        </th>
                    </tr>
                    <tr>
                        <td>
                            <asp:Repeater ID="repInfoGestion" runat="server">
                                <HeaderTemplate>
                                    <table style="width: 100%;" class="tabla" border="1" bordercolor="#f0f0f0" cellpadding="1"
                                        cellspacing="1">
                                        <tr>
                                            <td class="field">
                                                Tipo Gestión
                                            </td>
                                            <td class="field">
                                                Cliente
                                            </td>
                                            <td class="field">
                                                Gestionador
                                            </td>
                                            <td class="field">
                                                Fecha Gestión
                                            </td>
                                            <td class="field">
                                                Respuesta
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%#Container.DataItem("TipoGestion")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cliente")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Gestionador")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("FechaDeGestion")%>
                                        </td>
                                        <td rowspan="2">
                                            <asp:GridView ID="gvRespuestaRegistrada" runat="server" AutoGenerateColumns="False"
                                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado respuestas&lt;/i&gt;&lt;/blockquote&gt;"
                                                OnRowDataBound="gvRespuestaRegistrada_RowDataBound" OnRowCommand="gvRespuestaRegistrada_RowCommand">
                                                <Columns>
                                                    <asp:BoundField DataField="OrigenRespuesta" HeaderText="Origen Respuesta" />
                                                    <asp:BoundField DataField="NombreArchivoOriginal" HeaderText="Archivo de Respuesta" />
                                                    <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha de Respuesta" />
                                                    <asp:TemplateField HeaderText="Opc.">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibDescargar" ImageUrl="~/images/descargar.png" CommandName="Descargar"
                                                                CommandArgument='<%#Bind("NombreArchivoConRuta") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">
                                            Descripción:
                                        </td>
                                        <td colspan="3">
                                            <%#Container.DataItem("Descripcion")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <hr />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr class="fondoGris">
                                        <td>
                                            <%#Container.DataItem("TipoGestion")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Cliente")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("Gestionador")%>
                                        </td>
                                        <td>
                                            <%#Container.DataItem("FechaDeGestion")%>
                                        </td>
                                        <td rowspan="2">
                                            <asp:GridView ID="gvRespuestaRegistrada" runat="server" AutoGenerateColumns="False"
                                                EmptyDataText="&lt;blockquote&gt;&lt;i&gt;No se han adicionado respuestas&lt;/i&gt;&lt;/blockquote&gt;"
                                                OnRowDataBound="gvRespuestaRegistrada_RowDataBound" OnRowCommand="gvRespuestaRegistrada_RowCommand">
                                                <Columns>
                                                    <asp:BoundField DataField="OrigenRespuesta" HeaderText="Origen Respuesta" />
                                                    <asp:BoundField DataField="NombreArchivoOriginal" HeaderText="Archivo de Respuesta" />
                                                    <asp:BoundField DataField="FechaRecepcion" HeaderText="Fecha de Respuesta" />
                                                    <asp:TemplateField HeaderText="Opc.">
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="ibDescargar" ImageUrl="~/images/descargar.png" CommandName="Descargar"
                                                                CommandArgument='<%#Bind("NombreArchivoConRuta") %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr class="fondoGris">
                                        <td class="field">
                                            Descripción:
                                        </td>
                                        <td colspan="3">
                                            <%#Container.DataItem("Descripcion")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <hr />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:Literal ID="ltAux" runat="server" Text="&lt;blockquote&gt;&lt;i&gt;No existe gestión registrada para el Caso actual&lt;/i&gt;&lt;/blockquote&gt;"></asp:Literal>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="mpWait" runat="server" />
    </form>
</body>
</html>
