<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CreacionRutasLecturaRadicado.aspx.vb"
    Inherits="BPColSysOP.CreacionRutasLecturaRadicado" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Creación de Rutas de Entrega ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        var myWidth, myHeight;
        TamanioVentana();

        function TamanioVentana() {
            if (typeof (window.innerWidth) == 'number') {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }
        }

        function toggle(toolbar, menu) {
            $("#" + toolbar).slideToggle("slow");
            $("#" + menu).slideToggle("slow");
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function Inicializar(s, e) {
            if (txtIdentificacion != undefined && txtIdentificacion.GetEnabled()) {
                txtIdentificacion.Focus();
            }
        }

        function ProcesarRuta(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgCrear')) {
                cpLectura.PerformCallback('buscarMotorizado');
            }
        }

        function RegistrarRadicado(s, e) {
            if (txtRadicado.GetValue().length > 0) {
                cpLectura.PerformCallback('radicado|' + txtRadicado.GetValue());
            }
        }

        function ControlFinLectura(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            //gvRadicados.Refresh();
        }

        function DesvincularRadicado(s, e) {
            if (txtDesvincularRadicado.GetValue().length > 0) {
                cpLectura.PerformCallback('desvincular|' + txtDesvincularRadicado.GetValue());
            }
        }

        function CrearRuta(s, e) {
            if (gvRadicados.GetVisibleRowsOnPage() > 0) {
                cpLectura.PerformCallback('registrarRuta');
            } else {
                alert('Se deben adicionar raicados antes de intentar crear la ruta.');
            }
        }
    </script>
</head>
<body class="cuerpo2" onload="Inicializar()">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpLectura" runat="server" ClientInstanceName="cpLectura">
        <ClientSideEvents EndCallback="function(s, e) {
                ControlFinLectura(s, e);
            }"></ClientSideEvents>
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpInfoAgente" runat="server" HeaderText="Información Agente de Servicio"
                    Width="50%" ClientInstanceName="rpInfoAgente">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxFormLayout ID="flAgenteServicio" runat="server" Width="100%" AlignItemCaptionsInAllGroups="True"
                                ColCount="4">
                                <Items>
                                    <dx:LayoutItem Caption="Identificación:" HorizontalAlign="Right">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                <dx:ASPxTextBox ID="txtIdentificacion" runat="server" Width="170px" NullText="Cédula..."
                                                    ClientInstanceName="txtIdentificacion">
                                                    <MaskSettings Mask="0000000999999"></MaskSettings>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrear">
                                                        <RequiredField IsRequired="True" ErrorText="Se debe proporcionar la identificaci&#243;n del agente de servicio">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Zona:" HorizontalAlign="Right">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                <dx:ASPxComboBox ID="cmbZona" runat="server">
                                                    <ValidationSettings ValidationGroup="vgCrear" ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField IsRequired="True" ErrorText="La zona es requerida para crear la ruta">
                                                        </RequiredField>
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption=" " HorizontalAlign="Center">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                <dx:ASPxButton ID="btnProcesarRuta" runat="server" Text="Leer Radicados" ValidationGroup="vgCrear"
                                                    Width="150px" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s, e) { ProcesarRuta(s, e); }"></ClientSideEvents>
                                                    <Image Url="~/images/admin.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
                <div style="float: left">
                    <dx:ASPxRoundPanel ID="rpRadicados" runat="server" HeaderText="Radicados Asociados a la Ruta"
                        Style="margin-top: 10px;" Width="95%" ClientVisible="true">
                        <PanelCollection>
                            <dx:PanelContent>
                                <div style="width: 100%; float: left;">
                                    <dx:ASPxGridView ID="gvRadicados" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvRadicados" Width="100%">
                                        <Columns>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Radicado" VisibleIndex="0"
                                                FieldName="NumeroRadicado">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Fecha de Registro"
                                                VisibleIndex="1" FieldName="FechaRegistro">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Fecha de Agenda"
                                                VisibleIndex="2" FieldName="FechaAgenda">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Jornada" VisibleIndex="3"
                                                FieldName="Jornada">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Cliente" VisibleIndex="4"
                                                FieldName="NombreCliente">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Ciudad" VisibleIndex="5"
                                                FieldName="Ciudad">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Barrio" VisibleIndex="6"
                                                FieldName="Barrio">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Dirección" VisibleIndex="7"
                                                FieldName="Direccion">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Tel. Contacto" VisibleIndex="8"
                                                FieldName="TelefonoContacto">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>

                <dx:ASPxPopupControl ID="pcHojaRuta" runat="server" HeaderText="Hoja de Ruta"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="True"
                    ClientInstanceName="dialogoHojaRuta" ContentUrl="" Height="600px" Modal="True"
                    Width="800px" CloseAction="CloseButton" BackColor="White">
                    <ClientSideEvents CloseUp="function(s, e) { }" />
                    <ContentCollection>
                        <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>

                <%--Menú Flotante--%>
                <div id="bluebar" class="menuFlotante">
                    <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4">
                    </b></b>
                    <table id="tblMenuFlotante" style="width: 99%;" runat="server">
                        <tr>
                            <td style="width: 25%">
                                <div style="float: left">
                                    <dx:ASPxTextBox ID="txtRadicado" runat="server" Width="230px" ClientInstanceName="txtRadicado"
                                        NullText="Digite Radicado..." Font-Bold="True" Font-Size="Medium" Height="25px"
                                        AutoPostBack="false" onkeypress="javascript:return ValidaNumero(event);" MaxLength="20">
                                        <ClientSideEvents KeyPress="function(s, e) {
                                                if(e.htmlEvent.keyCode == 13) {
                                                    btnAdicionarRadicado.DoClick();
                                                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                }    
                                            }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnAdicionarRadicado" runat="server" Text="" Width="20px" HorizontalAlign="Center"
                                        Style="display: inline" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="False"
                                        Height="25px" ClientInstanceName="btnAdicionarRadicado">
                                        <ClientSideEvents Click="function(s, e) { 
                                                RegistrarRadicado(s, e);
                                            }"></ClientSideEvents>
                                        <Image Url="../images/keynumber.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                            <td style="width: 20%">
                                <div style="float: left">
                                </div>
                            </td>
                            <td style="width: 25%">
                                <div style="float: left">
                                    <dx:ASPxTextBox ID="txtDesvincularRadicado" runat="server" Width="230px" ClientInstanceName="txtDesvincularRadicado"
                                        NullText="Digite Radicado..." Font-Bold="True" Font-Size="Medium" Height="25px"
                                        AutoPostBack="false">
                                        <ClientSideEvents KeyPress="function(s, e) {
                                                if(e.htmlEvent.keyCode == 13) {
                                                    btnDesvincularRadicado.DoClick();
                                                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                }    
                                            }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnDesvincularRadicado" runat="server" Width="20px" HorizontalAlign="Center"
                                        Style="display: inline" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="False"
                                        Height="25px" ClientInstanceName="btnDesvincularRadicado">
                                        <ClientSideEvents Click="function(s, e) { 
                                                DesvincularRadicado(s, e);
                                            }"></ClientSideEvents>
                                        <Image Url="../images/remove.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                            <td style="width: 25%" align="center">
                                &nbsp;
                            </td>
                            <td valign="middle" style="width: 15%">
                                <dx:ASPxButton ID="btnCrearRuta" runat="server" Text="Crear Ruta" Width="150px" HorizontalAlign="Center"
                                    Style="display: inline" AutoPostBack="False" CausesValidation="False" Height="25px"
                                    ClientEnabled="false" ClientInstanceName="btnCrearRuta">
                                    <ClientSideEvents Click="function(s, e) {
	                                    CrearRuta(s, e);
                                    }"></ClientSideEvents>
                                    <Image Url="../images/trans_small.png">
                                    </Image>
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <a style="cursor: hand; cursor: pointer; margin-left: 3px;" onclick="toggle('bluebar', 'menu');">
                                    <img src="../images/arrow_down2.gif" alt="Ocultar Menú" title="Ocultar Menú" />
                                </a>
                            </td>
                        </tr>
                    </table>
                </div>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
    <div id="menu" style="float: right; width: 2%; position: fixed; overflow: hidden;
        display: none; right: 0px; bottom: 15px">
        <a style="cursor: hand; cursor: pointer;" onclick="toggle('bluebar','menu');">
            <img src="../images/tools-2.png" alt="Mostrar Menú" title="Mostrar Menú" />
        </a>
    </div>
    </form>
</body>
</html>
