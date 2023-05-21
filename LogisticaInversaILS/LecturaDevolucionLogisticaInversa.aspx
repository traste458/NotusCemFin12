<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LecturaDevolucionLogisticaInversa.aspx.vb"
    Inherits="BPColSysOP.LecturaDevolucionLogisticaInversa" %>

<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>::Lectura de Devolución::</title>
    <link href="../include/styleBACK.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .izquierda
        {
            float: left;
        }
        .espacio
        {
            margin-left: 50px;
        }
        .bloque
        {
            display: block;
        }
        .limpiar
        {
            clear: both;
        }
    </style>
         <script language="javascript" type ="text/javascript">
         function EjecutarKeyPress(sender,e) {
             try {
                 // look for window.event in case event isn't passed in
                 if (window.event) { e = window.event; }
                 if (e.keyCode == 13) {
                     var id = ""
                     if (sender.id == "txtSerial")
                         id = "btnLeerSerial";
                     else if (sender.id = "txtBorrarSerial")
                         id = "btnEliminarSerial";
                     event.cancel = true;
                     event.returnValue = false;
                     document.getElementById(id).click()
                 }
             } catch (e) {
          //   alert("Error al validar tecla. " & e.description);
             }

         }
        
        

    </script>
</head>
<body class="cuerpo2">
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:EncabezadoPagina ID="EncabezadoPagina1" runat="server" />
    </div>
    <table class="tablaGris" >
        <tr>
            <th colspan="8">
                Datos Generales de la devolución
            </th>
        </tr>
        <tr>
            <td class="field">
                Orden de Recolección No.
            </td>
            <td>
                <asp:Label ID="lblidRecoleccion" runat="server"></asp:Label>
            </td>
            <td class="field">
                Devolución
            </td>
            <td>
                <asp:Label ID="lblidDevolucion" runat="server"></asp:Label>
            </td>
            <td class="field">
                Remisión/Guia
            </td>
            <td>
                <asp:Label ID="lblGuia" runat="server"></asp:Label>
            </td>
            <td class="field" >
                Grupo</td>
            <td>
                <asp:Label ID="lblGrupoDev" runat="server"></asp:Label>
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
                Ciudad
            </td>
            <td>
                <asp:Label ID="lblCiudad" runat="server"></asp:Label>
            </td>
            <td class="field">
                Fecha
            </td>
            <td>
                <asp:Label ID="lblFecha" runat="server"></asp:Label>
            </td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td align="center" colspan="6">
            <br />
                <p>
                    <asp:LinkButton ID="lnkCerrar" runat="server" CssClass="search"><img alt="*" src="../images/lock.png" />&nbsp;Cerrar Devolución</asp:LinkButton>
                    &nbsp;
                    <asp:LinkButton ID="lnkAccesorios" runat="server" CssClass="search"><img alt="*" src="../images/package.png" />&nbsp;Confirmar Accesorios</asp:LinkButton>      &nbsp;
                    <asp:LinkButton ID="lnkDescargar" runat="server" CssClass="search"><img alt="*" src="../images/Excel.gif" />&nbsp;Descargar Seriales Leidos</asp:LinkButton></p>
            </td>
            <td align="center">
                &nbsp;</td>
            <td align="center">
                &nbsp;</td>
        </tr>
    </table><br />
    <asp:Panel ID="pnlTipoLectura" runat="server" CssClass="search" width="650px">
 <blockquote style="width:300px" >
            <p>
                Seleccione un tipo de lectura para empezar...</p>
        </blockquote>
       
        <table width="650px">
                        <tr>
                <td>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:RadioButtonList ID="rdbClasificacion" runat="server" AutoPostBack="True" CssClass="ok listSearchTheme "
                                Font-Size="8pt" RepeatColumns="5" RepeatDirection="Horizontal" RepeatLayout="Flow">
                            </asp:RadioButtonList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td >
                    <asp:LinkButton ID="lnkIniciarLectura" runat="server" CssClass="izquierda Enlaces"><img alt="*" 
    src="../images/pageNext.gif" />Iniciar Lectura</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:CheckBoxList ID="chlbxNovedades" runat="server" CssClass="listSearchTheme" Font-Size="8pt"
                                RepeatColumns="5" RepeatDirection="Horizontal" RepeatLayout="Flow">
                            </asp:CheckBoxList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:Panel ID="pnlLecturaSerial" runat="server" Style="clear: both">
        <table class="tablaGris" width="650px">
            <tr>
                <th class="field" colspan="3">
                    Lectura de Seriales
                </th>
            </tr>
            <tr>
                <td class="field">
                    Ingreso de Serial
                </td>
                <td>
                    <asp:TextBox ID="txtSerial" runat="server" Width="200px" MaxLength="20" 
                        onKeyDown="return EjecutarKeyPress(this,event);" ValidationGroup="registrar"></asp:TextBox>
                 <div> 
                     <asp:RegularExpressionValidator ID="RegularExpressionValidatorSerial" runat="server" 
                        ControlToValidate="txtSerial" Display="Dynamic" 
                        ErrorMessage="El serial no tiene el formato requerido" 
                        ValidationGroup="registrar"></asp:RegularExpressionValidator></div>  
                    <div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorSerial" runat="server" ErrorMessage="debe proporcionar un serial"
                            ControlToValidate="txtSerial" ValidationGroup="registrar" 
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </td>
                <td>
                    <asp:Button ID="btnLeerSerial" runat="server" CssClass="search" Text="Registrar"
                        ValidationGroup="registrar" />
                </td>
            </tr>
            <tr>
                <td align="center" colspan="3">
                    <p>
                        <asp:LinkButton ID="lnkFinalizarLectura" runat="server" CssClass="search espacio">Finalizar Lectura</asp:LinkButton>
                    </p>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br />
    <table class="tablaGris" width="650px">
        <tr>
            <th colspan="3">
                Eliminación de Seriales
            </th>
        </tr>
        <tr>
            <td colspan="3">
                <asp:RadioButton ID="rdLecura" runat="server" Checked="True" Text="Serial Leido"
                    GroupName="Eliminar" />
                <asp:RadioButton ID="rdRechazado" runat="server" Text="Serial Rechazado" GroupName="Eliminar" />
            </td>
        </tr>
        <tr>
            <td class="field">
                Eliminar Serial
            </td>
            <td>
                <asp:TextBox ID="txtBorrarSerial" runat="server" Width="200px" MaxLength="20" 
                    BackColor="#FFDDDD" onKeyDown="return EjecutarKeyPress(this,event);" 
                    ValidationGroup="eliminar"></asp:TextBox>
                <div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorEliminar" runat="server" ErrorMessage="debe proporcionar un serial"
                        ControlToValidate="txtBorrarSerial" ValidationGroup="eliminar" 
                        Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:Label ID="lblNotificacion" runat="server"></asp:Label>
                </div>
            </td>
            <td>
                <asp:Button ID="btnEliminarSerial" runat="server" CssClass="search" Text="Eliminar" 
                    ValidationGroup="eliminar" />
            </td>
        </tr>
    </table>
    <br />
    <div style="clear: both">
<h4> Referencias Agregadas</h4>
           <hr />
        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
            <ContentTemplate>
                <table>
                    <tr>
                        <td valign="top">
                            <div id="divReferencias">
                                <asp:GridView ID="gvMateriales" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                                    Width="440px" CssClass="grid" EmptyDataText="<blockquote><p>No hay referencias agregadas</p></blockquote>"
                                    BorderStyle="None" DataKeyNames="idDetalle">
                                    <FooterStyle CssClass="footerChildDG" />
                                    <SelectedRowStyle BackColor="LightSteelBlue" />
                                    <AlternatingRowStyle CssClass="alterItemChildDG" />
                                    <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="thGris" HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:ButtonField CommandName="Select" DataTextField="producto" HeaderText="Producto"
                                            Text="Select"></asp:ButtonField>
                                        <asp:BoundField DataField="cantidad" HeaderText="Cantidad Esperada"></asp:BoundField>
                                        <asp:BoundField DataField="cantidadLeida" HeaderText="Cantidad Leida" />
                                    </Columns>
                                    <PagerStyle CssClass="pagerChildDG" />
                                </asp:GridView>
                            </div>
                        </td>
                        <td>
                        </td>
                        <td valign="top">
                            <asp:LinkButton ID="lnkVerTodos" TabIndex="15" runat="server" Width="160px" 
                                CommandName="ver" CausesValidation="False"><img src="../images/arrow_down2.gif" border="0" alt="Agregar Referencia">&nbsp;Ver todos los Seriales</asp:LinkButton>
                            <asp:Panel ID="pnlSeriales" runat="server">
                                <asp:GridView ID="gvSeriales" runat="server" AutoGenerateColumns="False" Width="300px" 
                                    DataKeyField="serial" ShowFooter="True" GridLines="None">
                                    <AlternatingRowStyle CssClass="alterItemChildDG" />
                                    <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headerChildDG" BackColor="Gray">
                                    </HeaderStyle>
                                    <FooterStyle CssClass="footerChildDG" />
                                    <Columns>
                                        <asp:BoundField DataField="serial" HeaderText="Serial"></asp:BoundField>
                                    </Columns>
                                    <PagerStyle CssClass="pagerChildDG" />
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                        <td>
                            <div>
                                Seriales Rechazados</div>
                            <asp:GridView ID="gvRechazados" runat="server" AutoGenerateColumns="False" DataKeyField="serial"
                                GridLines="None" ShowFooter="True" Width="300px" EmptyDataText="<blockquote><p>No se han leido seriales rechazados</p></blockquote>">
                                <AlternatingRowStyle CssClass="alterItemChildDG" />
                                <RowStyle CssClass="itemChildDG" HorizontalAlign="Center" />
                                <HeaderStyle BackColor="Gray" CssClass="headerChildDG" HorizontalAlign="Center" />
                                <FooterStyle CssClass="footerChildDG" />
                                <Columns>
                                    <asp:BoundField DataField="serial" HeaderText="Serial" />
                                </Columns>
                                <PagerStyle CssClass="pagerChildDG" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:HiddenField ID="hfCerrar" runat="server" />
    <cc1:ModalPopupExtender ID="hfCerrar_ModalPopupExtender" runat="server" PopupControlID="pnlWarning"
        CancelControlID="lnkSalir" BackgroundCssClass="modalBackground" 
        Enabled="True" TargetControlID="hfCerrar">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlWarning" Width="500px" CssClass="modalPopUp" Style="display: none;"
        runat="server">
        <div class="warning tablaGris">
            <ul>
                <li>&nbsp; Hay diferencias entre la cantidad esperada y la cantidad leida ¿Desea cerrar
                    la devolución?</li></ul>
            <div class="thGris field">
                Observación</div>
            <center>
                <asp:TextBox ID="txtObservacion" runat="server" Height="43px" TextMode="MultiLine"
                    Width="446px"></asp:TextBox>
                <br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorObservacion" runat="server"
                    ErrorMessage="Debe proporcionar una observación para cerrar con diferencias"
                    ControlToValidate="txtObservacion" ValidationGroup="CerrarObservacion" 
                    Display="Dynamic"></asp:RequiredFieldValidator>
                <p>
                    <asp:LinkButton ID="lnkCerrarObservacion" runat="server" CssClass="search" ValidationGroup="CerrarObservacion"><img alt="*" 
                        src="../images/lock.png" />&nbsp;Cerrar Devolución</asp:LinkButton>
                    &nbsp;
                    <asp:LinkButton ID="lnkSalir" runat="server" CssClass="search"><img alt="*" src="../images/cancelar.png" />  &#160;Salir</asp:LinkButton>
                </p>
            </center>
        </div>
    </asp:Panel>
    </form>
</body>
</html>
