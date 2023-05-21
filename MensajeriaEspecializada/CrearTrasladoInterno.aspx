<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CrearTrasladoInterno.aspx.vb" Inherits="BPColSysOP.CrearTrasladoInterno" %>

<%@ Register src="../ControlesDeUsuario/EncabezadoPagina.ascx" tagname="EncabezadoPagina" tagprefix="uc1" %>

<%@ Register src="../ControlesDeUsuario/ModalProgress.ascx" tagname="ModalProgress" tagprefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Creación de Traslado</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        function doClick(buttonName, e) {            
            var key;
            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox
            if (key == 13) {                
                var btn = document.getElementById(buttonName);
                if (btn != null) { 
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
     <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="upGeneral" runat="server">
        <ContentTemplate>
    <div>       
        <uc1:EncabezadoPagina ID="epPrincipal" runat="server" />
    </div>
    <div style="width:600px;">
        <asp:Panel ID="pnlLecturaRadicados" runat="server" style="border:1px solid;">
            <p class="subtitulo" style="text-align:left;">Datos de traslado:</p>
            <div style="background:#E6E6E6;color:#333333;float:left;height:20px;font-weight:bold;width:100px;">
                No. Radicado:
            </div>
            <div style="float:left;">
                <asp:TextBox ID="txtNoRadicado" runat="server" MaxLength="10" ValidationGroup="AgregarRadicado"></asp:TextBox>
                <div>
                    <asp:RegularExpressionValidator ID="rglNoRadicado" runat="server" ErrorMessage="El campo número radicado es numérico. Ingrese un número válido, por favor"
                                        ControlToValidate="txtNoRadicado" ValidationGroup="AgregarRadicado" Display="Dynamic"
                                        ValidationExpression="[0-9]+"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="rfvNoRadicado" runat="server" ErrorMessage="Indique el radicado, por favor."
                    ControlToValidate="txtNoRadicado" Display="Dynamic" ValidationGroup="AgregarRadicado" ></asp:RequiredFieldValidator>
                </div>
            </div>
            <div style="clear:both;"></div>
            <div>
                <asp:Button ID="btnAdicionar" runat="server" Text="Adicionar" CssClass="search" ValidationGroup="AgregarRadicado" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlLecturaSeriales" runat="server" style="border:1px solid;" Visible="false">
            <p class="subtitulo" style="text-align:left;">Seriales:</p>
            <div style="background:#E6E6E6;color:#333333;float:left;height:20px;font-weight:bold; width:100px;">
                Serial:
            </div>
            <div style="float:left;">
                <asp:TextBox ID="txtSerial" runat="server" MaxLength="25" ValidationGroup="AdicionarSerial"></asp:TextBox>
                <div>
                    <asp:RegularExpressionValidator ID="revSerial" runat="server" ErrorMessage="El campo serial es numérico. Ingrese un número válido, por favor"
                                        ControlToValidate="txtSerial" ValidationGroup="AgregarSerial" Display="Dynamic"
                                        ValidationExpression="[0-9]+"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="rfvSerial" runat="server" ErrorMessage="Indique el serial, por favor."
                    ControlToValidate="txtSerial" Display="Dynamic" ValidationGroup="AgregarSerial" ></asp:RequiredFieldValidator>
                </div>
            </div>            
            <div style="clear:both;"></div>
            <div>
                <asp:Button ID="btnAdicionarSerial" runat="server" Text="Adicionar Serial" CssClass="search" ValidationGroup="AgregarSerial" />
            </div>  
            <asp:GridView ID="gvSeriales" runat="server" CssClass="tablaGris" 
                AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField HeaderText="Serial" DataField="serial">
                        <ItemStyle Width="250px" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="Material" DataField="material">
                        <ItemStyle Width="100px" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Opc.">
                        <ItemTemplate>
                            <asp:ImageButton ID="imgBtnEliminar" runat="server" 
                                ImageUrl="~/images/remove.png" 
                                CommandName="Eliminar"
                                CommandArgument='<%# Bind("serial") %>'
                                onclientclick="return confirm('¿Esta seguro de eliminar el serial?');" 
                                ToolTip="Eliminar" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>  
            <asp:Button ID="btnCerrar" runat="server" Text="Cerrar y Confirmar Traslado" style="margin-top:15px;" 
                CssClass="search" 
                OnClientClick="return confirm('Esta seguro de cerrar el traslado');" 
                Visible="False" />   
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelarTraslado" runat="server" Text="Cancelar Traslado" style="margin-top:15px;background:#F3F781;" 
                CssClass="search" 
                OnClientClick="return confirm('Esta seguro de cancelar el traslado\n perdera toda su información.');" 
                 />   
        </asp:Panel>
        <asp:Panel ID="pnlErrores" runat="server" Visible="False" style="width:500px;">
            <p class="subtitulo" style="text-align:left;color:Orange;">Errores:</p>
            <asp:GridView ID="gvErrores" runat="server" CssClass="tablaGris" 
                style="width:100%;" AutoGenerateColumns="False">
                <Columns>                    
                    <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                </Columns>
            </asp:GridView>
        </asp:Panel>
    </div>
    </ContentTemplate>
    </asp:UpdatePanel>
    <uc2:ModalProgress ID="ModalProgress1" runat="server" />
    </form>
</body>
</html>
