<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VistaLogOrdenRecoleccion.aspx.vb" Inherits="BPColSysOP.VistaLogOrdenRecoleccion" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
    
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    
    </div>
    <asp:GridView ID="gvLogRecoleccion" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="idRegistroHistorial" CssClass="grid">
        <Columns>
            <asp:BoundField DataField="idRegistroHistorial" 
                HeaderText="idRegistroHistorial" InsertVisible="False" ReadOnly="True" 
                SortExpression="idRegistroHistorial" />
            <asp:BoundField DataField="idOrden" HeaderText="idOrden" 
                SortExpression="idOrden" />
            <asp:BoundField DataField="guia" HeaderText="Guia" SortExpression="guia" />
            <asp:BoundField DataField="origen" HeaderText="Origen" 
                SortExpression="origen" />
            <asp:BoundField DataField="destino" HeaderText="Destino" 
                SortExpression="destino" />
            <asp:BoundField DataField="ordenServicio" HeaderText="Orden de Servicio" 
                SortExpression="ordenServicio" />
            <asp:BoundField DataField="fechaCreacion" HeaderText="Fecha Creacion" 
                SortExpression="fechaCreacion" />
            <asp:BoundField DataField="observacion" HeaderText="Observación" 
                SortExpression="observacion" />
            <asp:BoundField DataField="fechaModificacion" HeaderText="Fecha Modificación" 
                SortExpression="fechaModificacion" />
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                <p>     <asp:LinkButton ID="lnkVer" CssClass="search" runat="server" CausesValidation="False" 
                        CommandName="Select" Text="Ver detalle"></asp:LinkButton></p>               
                </ItemTemplate>               
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </form>
</body>
</html>
