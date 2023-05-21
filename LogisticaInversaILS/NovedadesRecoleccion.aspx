<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NovedadesRecoleccion.aspx.vb"
    Inherits="BPColSysOP.NovedadesRecoleccion" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Novedades Recolección</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .espacio
        {
            margin-left: 100px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="cuerpo2">
    <div>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    </div>
    <table class="tablaGris">
        <tr>
            <th colspan="4">
                Información de la Orden de Recolección
            </th>
        </tr>
        <tr>
            <td class="field">
                ID Orden
            </td>
            <td>
                <asp:Label ID="lblIdOrden" runat="server"></asp:Label>
            </td>
            <td class="field">
                Transportadora
            </td>
            <td>
                <asp:Label ID="lblTransportadora" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="field">
                Origen
            </td>
            <td>
                <asp:Label ID="lblOrigen" runat="server"></asp:Label>
            </td>
            <td class="field">
                Destino
            </td>
            <td>
                <asp:Label ID="lblDestino" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="field">
                Guia
            </td>
            <td>
                <asp:Label ID="lblGuia" runat="server"></asp:Label>
            </td>
            <td class="field">
                Orden de Servicio
            </td>
            <td>
                <asp:Label ID="lblOrdenServicio" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="field">
                Valor Declarado</td>
            <td>
                <asp:Label ID="lblValorDeclarado" runat="server"></asp:Label>
            </td>
            <td class="field">
                Observación</td>
            <td>
                <asp:Label ID="lblObservacion" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <div class="thGris" style="width: 500px">
        Seriales de la Orden</div>
    <asp:GridView ID="gvSeriales" runat="server" AutoGenerateColumns="False" Width="500px"
        DataKeyField="serial" ShowFooter="True" GridLines="None">
        <AlternatingRowStyle CssClass="alterItemChildDG" />
        <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
        <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
        </HeaderStyle>
        <FooterStyle CssClass="footerChildDG" />
        <Columns>
            <asp:BoundField DataField="serial" HeaderText="Serial"></asp:BoundField>
            <asp:BoundField DataField="material" HeaderText="Material"></asp:BoundField>
            <asp:BoundField DataField="referencia" HeaderText="Referencia"></asp:BoundField>
            <asp:CheckBoxField DataField="CajaVacia" HeaderText="Es Caja Abierta" />
        </Columns>
        <PagerStyle CssClass="pagerChildDG" />
    </asp:GridView><br />
    <div class="thGris" style="width: 500px">
        Accesorios</div>
    <asp:GridView ID="gvAccesorios" runat="server" AutoGenerateColumns="False" Width="500px"
        DataKeyField="serial" ShowFooter="True" GridLines="None">
        <AlternatingRowStyle CssClass="alterItemChildDG" />
        <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
        <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
        </HeaderStyle>
        <FooterStyle CssClass="footerChildDG" />
        <Columns>
            <asp:BoundField DataField="articulo" HeaderText="Articulo" ReadOnly="True" />
            <asp:BoundField DataField="cantidadpedida" HeaderText="Cantidad Pedida" />
            <asp:BoundField DataField="cantidadRecogida" HeaderText="Cantidad Recogida" ReadOnly="True">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="cantidadentregada" HeaderText="Cantidad Entregada" />
        </Columns>
        <PagerStyle CssClass="pagerChildDG" />
    </asp:GridView>
    <br />
    <div style="width: 500px" class="izquierda">
        <div class="thGris">
            &nbsp; Novedades de Serial</div>
        <asp:GridView ID="gvNovedadesSerial" runat="server" AutoGenerateColumns="False" Width="500px"         
         EmptyDataText="<blockquote><p> No se registran novedades de serial</p> </blockquote>"
          ShowFooter="True" GridLines="None">
            <AlternatingRowStyle CssClass="alterItemChildDG" />
            <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
            <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
            </HeaderStyle>
            <FooterStyle CssClass="footerChildDG" />
  
            <Columns>
                <asp:BoundField DataField="serial" HeaderText="serial" ReadOnly="True" SortExpression="serial" />
                <asp:BoundField DataField="novedad" HeaderText="Novedad" SortExpression="novedad" />
                <asp:BoundField DataField="procesoNovedad" HeaderText="Proceso" SortExpression="procesoNovedad" />
            </Columns>
        </asp:GridView>
    </div>
    <div style="width: 500px" class="izquierda espacio">
        <div class="thGris">
            &nbsp; Novedades de Carga</div>
        <asp:GridView ID="gvNovedadesCarga" 
        runat="server" AutoGenerateColumns="False" Width="500px"         
         EmptyDataText="<blockquote><p> No se registran novedades de Carga</p> </blockquote>"
          ShowFooter="True" GridLines="None">
            <AlternatingRowStyle CssClass="alterItemChildDG" />
            <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
            <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
            </HeaderStyle>
            <FooterStyle CssClass="footerChildDG" />
            <Columns>
                <asp:BoundField DataField="novedad" HeaderText="Novedad" SortExpression="novedad" />
                <asp:BoundField DataField="fechaSistema" HeaderText="Fecha" SortExpression="fechaSistema" />
                <asp:BoundField DataField="observaciones" HeaderText="Observaciones" SortExpression="observaciones" />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
