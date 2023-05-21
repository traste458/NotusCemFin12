<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RecepcionSerialesRadicadoCerrado.aspx.vb" Inherits="BPColSysOP.RecepcionSerialesRadicadoCerrado" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Recepción Seriales Radicado Cerrado ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function ProcesarRadicado(s, e) {
            if (ASPxClientEdit.ValidateGroup('vgBuscar')) {
                cpRecepcion.PerformCallback('buscarServicio|' + txtServicio.GetValue());
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46 || tecla == 13);
        }

        function RecibirSerial(s, e) {
            if (txtSerial.GetValue().length > 0) {
                cpRecepcion.PerformCallback('recibirSerial|' + txtSerial.GetValue());
            }
        }

        function Inicializar(s, e) {
            if (txtServicio != undefined && txtServicio.GetEnabled()) {
                txtServicio.Focus();
            }
        }

        function ProcesarCierreNC(s, e) {
            if (txtServicio.GetValue() != null) {
                if (confirm('Se procederá con el cierre definitivo del Radicado. ¿Está seguro que todos los seriales poseen Nota Crédito?')) {
                    cpRecepcion.PerformCallback('cerrarServicio|' + txtServicio.GetValue());
                }
            } else {
                alert('Por favor ingrese el número del radicado.');
            }
        }
    </script>
</head>
<body class="cuerpo2" onload="Inicializar()">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <dx:ASPxCallbackPanel ID="cpRecepcion" runat="server" ClientInstanceName="cpRecepcion">
        <ClientSideEvents EndCallback="function(s, e) {
                if (s.cpMensaje) {
                    $('#divEncabezado').html(s.cpMensaje);
                }
            }" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxRoundPanel ID="rpServicio" runat="server" HeaderText="Servicio en Proceso de Cierre">
                    <PanelCollection>
                        <dx:PanelContent>
                            <table>
                                <tr>
                                    <td>
                                        Número de Radicado:
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtServicio" runat="server" Width="170px" ClientInstanceName="txtServicio"
                                            onkeypress="javascript:return ValidaNumero(event);" MaxLength="15">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" 
                                                ValidationGroup="vgBuscar">
                                                <RequiredField ErrorText="Debe ingresar un número de radicado" 
                                                    IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td align="center">
                                        <dx:ASPxButton ID="btnProcesar" runat="server" Text="Procesar Radicado" Width="200px" ClientInstanceName="btnProcesar"
                                            HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                            <ClientSideEvents Click="function(s, e) {
                                                            ProcesarRadicado(s, e);
                                                        }"></ClientSideEvents>
                                            <Image Url="../images/find.gif">
                                            </Image>
                                        </dx:ASPxButton>
                                    </td>
                                    <td aling="center">
                                        <dx:ASPxButton ID="btnRegistrarNC" runat="server" Text="Registrar NC" Width="200px" ClientInstanceName="btnRegistrarNC"
                                            HorizontalAlign="Center" Style="display: inline" AutoPostBack="False" CausesValidation="False">
                                            <ClientSideEvents Click="function(s, e) {
                                                            ProcesarCierreNC(s, e);
                                                        }"></ClientSideEvents>
                                            <Image Url="../images/note-accept.png">
                                            </Image>
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
                <div style="float: left">
                    <dx:ASPxRoundPanel ID="rpSeriales" runat="server" HeaderText="Recepción Seriales"
                        Style="margin-top: 10px;">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table runat ="server">
                                    <tr id ="trEstado">
                                        <td>
                                            Seleccione Estado:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbEstado" runat="server" Width="250px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbEstado" DropDownStyle="DropDownList" TabIndex="1">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Descripcion" Width="250px" Caption="Descripción" />
                                                </Columns>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAtender">
                                                    <RequiredField IsRequired="True" ErrorText="Seleccione un estado" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Serial:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtSerial" runat="server" Width="170px" ClientInstanceName="txtSerial"
                                                AutoPostBack="false">
                                                <ClientSideEvents KeyPress="function(s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgAtender')){
                                                        if(e.htmlEvent.keyCode == 13) {
                                                            btnRecibirSerial.DoClick();
                                                            ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                        }
                                                    }
                                                }"></ClientSideEvents>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgAtender">
                                                    <RegularExpression ErrorText="El valor ingresado no es un n&#250;mero de serial v&#225;lido"
                                                        ValidationExpression="[1-9][0-9]{0,25}"></RegularExpression>
                                                    <RequiredField IsRequired="True" ErrorText="Ingrese un serial para procesar" />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td align="right">
                                            <dx:ASPxButton ID="btnRecibirSerial" runat="server" Text="Recibir Serial" Width="150px"
                                                ClientInstanceName="btnRecibirSerial" HorizontalAlign="Center" Style="display: inline"
                                                AutoPostBack="False" CausesValidation="False">
                                                <ClientSideEvents Click="function(s, e) {
                                                    if(ASPxClientEdit.ValidateGroup('vgAtender')){
                                                        RecibirSerial(s, e);
                                                    }
                                                }"></ClientSideEvents>
                                                <Image Url="../images/add.png">
                                                </Image>
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
                <div style="float: left; margin-left: 20px; margin-top: 20px;">
                    <dx:ASPxRoundPanel ID="rpDetalleSeriales" runat="server" 
                        HeaderText="Información de Seriales Recibidos">
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxGridView ID="gvInfoSeriales" runat="server" AutoGenerateColumns="False">
                                    <Columns>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Material" VisibleIndex="0"
                                            FieldName="Material">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Referencia" VisibleIndex="1"
                                            FieldName="DescripcionMaterial">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Serial" VisibleIndex="2"
                                            FieldName="Serial">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="MSISDN" VisibleIndex="3"
                                            FieldName="Msisdn">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Caption="Estado" VisibleIndex="4"
                                            FieldName="EstadoSerial">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsPager AlwaysShowPager="True">
                                    </SettingsPager>
                                </dx:ASPxGridView>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </div>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxCallbackPanel>
    </form>
</body>
</html>
