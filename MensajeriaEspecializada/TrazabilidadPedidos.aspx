﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TrazabilidadPedidos.aspx.vb" Inherits="BPColSysOP.TrazabilidadPedidos" %>

<%@ Register Assembly="DevExpress.Web.v18.1, Version=18.1.17.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Src="../ControlesDeUsuario/NotificationControl.ascx" TagName="NotificationControl" TagPrefix="uc1" %>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" TagPrefix="uc2" TagName="EncabezadoPagina" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../Estilos/estiloContenidos.css" rel="stylesheet" type="text/css" />
    <%--<script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>--%>
    <script src="../include/jquery-1.12.4.js"></script>
    <script src="../include/jquery-1.12.1-ui.js"></script>
    <script src="../Scripts/FuncionesJS.js" type="text/javascript"></script>
    <link href="../css/bootstrap3.3.7.min.css" rel="stylesheet" />
    <link href="../css/StyleAlert.css" rel="stylesheet" />
    <script src="../include/ScriptAlert.js"></script>

    <script type="text/javascript">
        function toggle(control) {
            $("#" + control).slideToggle("slow");
        }

        function SetImageState(value) {
            var img = document.getElementById('imgButton');
            var imgSrc = value ? '../images/arrow-minimise20.png' : '../images/arrow-maximise20.png';
            img.src = imgSrc;
        }

        function ValidaNumeros(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (((charCode == 8) || (charCode == 46) ||
                 (charCode >= 35 && charCode <= 40) ||
                 (charCode >= 48 && charCode <= 57) ||
                 (charCode >= 96 && charCode <= 105) ||
                 (charCode == 9))) {
                return true;
            }
            else {
                alert('Este campo solo admite números', 'rojo');
                return false;
            }
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <uc1:EncabezadoPagina ID="epNotificador" runat="server" />
        </div>
        <div class="col-xs-7">
            <label for="txtIdServicio">Número de Servicio o identificación del cliente</label>
            <input class="form-control" id="txtIdServicio" type="text" placeholder="Ingrese su búsqueda..." runat="server" onkeydown="return ValidaNumeros(event)" required="required" />
            <div class="input-group-btn">
                <asp:Button ID="btnTrazabilidadServicio" Text="Buscar" runat="server" OnClick="btnBuscarTrazabilidad_ServerClick" class="btn btn-primary" />
           </div>
        </div>
        
        <div>
            <br />

            <dx:ASPxFormLayout ID="formLayout" runat="server" Width="90%" AlignItemCaptionsInAllGroups="True">
                <Items>
                    <dx:LayoutGroup Caption="Información del envio" ColCount="3" GroupBoxDecoration="Box">
                        <Items>
                            <dx:LayoutItem Caption="Fecha Reparto:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbFechaEnvio" ClientInstanceName="lbFechaEnvio" runat="server" Text="Jue 17/11/2016"></dx:ASPxLabel>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="" ShowCaption="False">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxImage ID="imgEstado" runat="server" CssClass="largeImg" ImageUrl="~/images/TrackingEntregado.png"></dx:ASPxImage>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Fecha Esperada de Entrega:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbFechaEntrega" ClientInstanceName="lbFechaEntrega" runat="server" Text="Jue 17/11/2016 10:18"></dx:ASPxLabel>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Origen">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lborigen" ClientInstanceName="lborigen" runat="server" Text="BOGOTA CO"></dx:ASPxLabel>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Estado">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbEstado" ClientInstanceName="lbEstado" runat="server" Text="Entregado" Font-Bold="True" ForeColor="#00CC00"></dx:ASPxLabel>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Destino">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbDestino" ClientInstanceName="lbDestino" runat="server" Text="BOGOTA / SUBA CO "></dx:ASPxLabel>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
            <dx:ASPxRoundPanel ID="ASPxRoundPanel2" runat="server" HeaderText="Informacion General"
                Width="90%" Font-Bold="True" ForeColor="#666666">
                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxFormLayout ID="flFiltro" runat="server" ColCount="4">
                            <Items>
                                <%--<dx:LayoutItem Caption="Entregado a" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                <dx:ASPxLabel ID="lbEntregadoa" runat="server" ></dx:ASPxLabel>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                <dx:LayoutItem Caption="Número de Entrega:" RequiredMarkDisplayMode="Required" Height="20%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                            <dx:ASPxLabel ID="lbNumeroDocumento" runat="server"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Numero de Pedido">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                            <dx:ASPxLabel ID="lblPedido" runat="server" Text="ASPxLabel">
                                            </dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Guia">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                            <dx:ASPxLabel ID="lblGuia" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Transportadora">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                            <dx:ASPxLabel ID="lblTransportadora" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Número total de piezas:" RequiredMarkDisplayMode="Required">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                            <dx:ASPxLabel ID="lbUnidades" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Peso:" RequiredMarkDisplayMode="Required">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                            <dx:ASPxLabel ID="lbPeso" runat="server" Text="ASPxLabel">
                                            </dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Remitente:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                            <dx:ASPxLabel ID="lbRemitente" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Tel.Remitente:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                            <dx:ASPxLabel ID="lbTelRemitente" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Destinatario">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                            <dx:ASPxLabel ID="lbDestinatario" runat="server" Text="ASPxLabel"></dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Tel.Destinatario">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxLabel ID="lbTelDestinatario" runat="server" Text="ASPxLabel">
                                            </dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Dir.Destinatario">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxLabel ID="lbDirDestinatario" runat="server" Text="ASPxLabel">
                                            </dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Proceso ">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxLabel ID="lbProceso" runat="server" Text="ASPxLabel">
                                            </dx:ASPxLabel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:ASPxFormLayout>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <br />
            <table style="width: 98%">
                <tr>
                    <td style="vertical-align: top; width: 50%; padding-right: 10px;">
                        <dx:ASPxPivotGrid ID="pgInfoProducto" runat="server" EnableTheming="True" Theme="Office2003Olive" Width="100%" Autopostback="False">
                            <Fields>
                                <dx:PivotGridField ID="fileTipoProducto" Area="RowArea" AreaIndex="0" Caption="Tipo de Producto" FieldName="Descripcion"></dx:PivotGridField>
                                <dx:PivotGridField ID="fileMaterial" Area="FilterArea" AreaIndex="0" Caption="Producto - Referencia" FieldName="TipoProducto"></dx:PivotGridField>
             <%--                   <dx:PivotGridField ID="fieldCantidad" Area="DataArea" AllowedAreas="DataArea" AreaIndex="0" Caption="Unidades" FieldName="Cantidad"
                                    TotalCellFormat-FormatType="Numeric" GrandTotalCellFormat-FormatType="Numeric" ValueStyle-HorizontalAlign="Center"
                                    ValueTotalStyle-HorizontalAlign="Center">
                                </dx:PivotGridField>--%>
                            </Fields>
                            <OptionsView DataHeadersDisplayMode="Popup" />
                            <OptionsPager ShowSeparators="True">
                            </OptionsPager>
                        </dx:ASPxPivotGrid>
                    </td>
                    <td style="vertical-align: top;">
                        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server" ClientInstanceName="cpGeneral" EnableAnimation="true" 
                            >
                            <PanelCollection>
                                <dx:PanelContent>
                                    <div>
                                        <a style="color: Black; font-size: 10px; cursor: hand; cursor: pointer;" id="aLecturas"
                                            onclick="toggle('divFiltros');">
                                            <asp:Image ID="imgFiltro" runat="server" ImageUrl="../images/arrow-maximise20.png" ToolTip="Ver/Ocultar Filtros Búsqueda"
                                                Width="16px" />Ver/Ocultar Novedades</a>
                                        <%--<span runat="server" enableviewstate="False" id="lblCursor1" style="cursor: pointer;">Historial de desplazamiento 
                                <img id="imgButton1" alt="" src="../img/arrow-maximise20.png" style="width: 28px; height: 28px;" />

                            </span>--%>
                                        <br />
                                        <div id="divFiltros" style="float: left; margin-right: 5px; margin-bottom: 5px; margin-top: 5px; width: 90%;">
                                            <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" HeaderText="Seguimiento de entrega"
                                                Width="507px" Font-Bold="True" ForeColor="#666666">
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxGridView ID="gridEncabezado" ClientInstanceName="gridEncabezado" runat="server"
                                                            KeyFieldName="Fecha" Width="530px">
                                                            <Columns>
                                                                <dx:GridViewDataColumn FieldName="idRuta" Caption="idRuta" VisibleIndex="0" Visible="false" />
                                                                <dx:GridViewDataColumn FieldName="Fecha" Caption="Fecha" VisibleIndex="0" />
                                                            </Columns>
                                                            <Templates>
                                                                <DetailRow>
                                                                    <dx:ASPxGridView ID="gvDetalle" runat="server" KeyFieldName="Fecha"
                                                                        Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect">
                                                                        <Columns>
                                                                            <dx:GridViewDataColumn FieldName="hora" Caption="hora" VisibleIndex="1" />
                                                                            <dx:GridViewDataColumn FieldName="observacion" Caption="observacion" VisibleIndex="2" />
                                                                            <dx:GridViewDataColumn FieldName="Ciudad" Caption="Ciudad" VisibleIndex="2" />
                                                                        </Columns>
                                                                        <Settings ShowFooter="True" />
                                                                    </dx:ASPxGridView>
                                                                </DetailRow>
                                                            </Templates>
                                                            <SettingsDetail ShowDetailRow="true" />
                                                        </dx:ASPxGridView>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxRoundPanel>
                                        </div>
                                        <br />
                                    </div>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </td>
                </tr>
            </table>

        </div>
    </form>
</body>
</html>
