<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AlistamientoSerialesSiembra.aspx.vb"
    Inherits="BPColSysOP.AlistamientoSerialesSiembra" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoServicioTipoSiembra.ascx" TagName="EncabezadoSiembra"
    TagPrefix="es" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Alistamiento de Seriales SIEMBRA ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
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
            if (txtMin != undefined && txtMin.GetEnabled()) {
                txtMin.Focus();
            }
        }

        function RegistrarMin(s, e) {
            if (txtMin.GetValue().length > 0) {
                cpLectura.PerformCallback('min|' + txtMin.GetValue());
            }
        }

        function RegistrarSerial(s, e) {
            if (txtLecturaSerial.GetValue().length > 0) {
                cpLectura.PerformCallback('registrar|' + txtLecturaSerial.GetValue());
            }
        }

        function DesvincularSerialPar(serial) {
            if (confirm('¿Realmente desea desvincular el serial?')) {
                cpLectura.PerformCallback('desvincular|' + serial);
            }
        }

        function DesvincularSerial(s, e) {
            if (txtDesvincularSerial.GetValue().length > 0) {
                if (confirm('¿Realmente desea desvincular el serial?')) {
                    cpLectura.PerformCallback('desvincular|' + txtDesvincularSerial.GetValue());
                }
            }
        }

        function ConstrolFinMateriales(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
            }
        }

        function Despachar(s, e) {
            cpLectura.PerformCallback('despachar|');
        }

        function VisualizarNovedades(s, e) {
            dialogoNovedades.SetSize(myWidth * 0.5, myHeight * 0.6);
            dialogoNovedades.SetVisible(true);
            gvNovedades.PerformCallback();
        }

        function ControlFinNovedad(s, e) {
            cmbTipoNovedad.SetValue(null);
            memoObservacionesNovedad.SetText(null);
            if (s.cpMensajeRespuesta == '0') {
                btnDespachar.SetEnabled(false);
            }
        }

        function AdicionarNovedad(s, e) {
            gvNovedades.PerformCallback('registrar');
        }

        function GestionarNovedad(key) {
            setTimeout("window.location='PoolNovedades.aspx?idServicio=" + key + "'", 50);
        }

        function ControlFinLectura(s, e) {
            if (s.cpMensaje) {
                $('#divEncabezado').html(s.cpMensaje);
            }

            gvMins.Refresh();
        }

        function CierreDeFormato(s, e) {
            setTimeout("window.location='PoolServiciosNew.aspx?resOk=true&codRes=3'", 50);
        }
    </script>
</head>
<body class="cuerpo2" onload="Inicializar()">
    <form id="formPrincipal" runat="server">
    <div id="divEncabezado">
        <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
    </div>
    <es:EncabezadoSiembra runat="server" ID="esEncabezado" />
    <div style="float: left; margin-top: 10px; margin-right: 10px;">
        <dx:ASPxRoundPanel ID="rpMins" runat="server" HeaderText="Información de MSISDN">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gvMins" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvMins"
                        KeyFieldName="MSISDN">
                        <ClientSideEvents EndCallback="function(s, e) {
                                ConstrolFinMateriales(s, e);
                            }"></ClientSideEvents>
                        <Columns>
                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="MSISDN"
                                Caption="MSISDN">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="1" FieldName="NombrePlan"
                                Caption="Plan">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="2" FieldName="FechaDevolucion"
                                Caption="Fecha Devolución">
                                <PropertiesTextEdit DisplayFormatString="{0:d}">
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="2" FieldName="CantidadMaterial"
                                Caption="Cantidad Total Materiales">
                                <CellStyle HorizontalAlign="Center" Font-Bold="True" Font-Size="Medium">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="3" FieldName="CantidadMaterialLeida"
                                Caption="Cantidad Materiales Leidos">
                                <CellStyle HorizontalAlign="Center" Font-Bold="True" Font-Size="Medium">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsDetail ShowDetailRow="True" ExportMode="All"></SettingsDetail>
                        <Templates>
                            <DetailRow>
                                <dx:ASPxGridView ID="gvDetalle" runat="server" ClientInstanceName="gvDetalle" KeyFieldName="Serial"
                                    Width="100%" OnBeforePerformDataSelect="gvDetalle_DataSelect">
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="Serial" Caption="Serial" ShowInCustomizationForm="True"
                                            VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn Caption="Opc." VisibleIndex="10" Width="40px">
                                            <DataItemTemplate>
                                                <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/Delete-32.png"
                                                    Cursor="pointer" ToolTip="Desvincular Serial" OnInit="Link_InitDetalle">
                                                    <ClientSideEvents Click="function(s, e) { DesvincularSerialPar('{0}'); }" />
                                                </dx:ASPxHyperLink>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                    <Settings ShowFooter="false" />
                                </dx:ASPxGridView>
                            </DetailRow>
                        </Templates>
                    </dx:ASPxGridView>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
    </div>
    <div style="clear: both; margin-bottom: 30px;">
    </div>
    <%--Dialogo de novedades--%>
    <dx:ASPxPopupControl ID="pcNovedades" runat="server" AllowDragging="True" ClientInstanceName="dialogoNovedades"
        HeaderText="Gestión de Novedades" Modal="True" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter">
        <ContentCollection>
            <dx:PopupControlContentControl ID="pccNovedad" runat="server">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            Tipo Novedad:
                        </td>
                        <td>
                            <dx:ASPxComboBox ID="cmbTipoNovedad" runat="server" ClientInstanceName="cmbTipoNovedad"
                                DropDownWidth="600px" IncrementalFilteringMode="Contains" ValueField="idTipoNovedad"
                                ValueType="System.Int32" Width="300px">
                                <ClientSideEvents EndCallback="function(s, e) { 
                                            s.SetSelectedIndex(-1);     
                                        }" />
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                    ValidationGroup="vgRegistrarNovedad">
                                    <RequiredField ErrorText="El tipo de novedad es requerido" IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Observación:
                        </td>
                        <td>
                            <dx:ASPxMemo ID="memoObservacionesNovedad" runat="server" NullText="Observaciones..."
                                Rows="3" Width="400px" ClientInstanceName="memoObservacionesNovedad">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText=""
                                    ValidationGroup="vgRegistrarNovedad">
                                    <RequiredField ErrorText="La observación es requerida" IsRequired="true" />
                                </ValidationSettings>
                            </dx:ASPxMemo>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxButton ID="btnAdicionarNovedad" runat="server" HorizontalAlign="Center" Style="display: inline"
                                Text="Adicionar" ValidationGroup="vgRegistrarNovedad" Width="150px" AutoPostBack="false">
                                <ClientSideEvents Click="function(s, e) {
                                        if(ASPxClientEdit.ValidateGroup('vgRegistrarNovedad')) {
                                            AdicionarNovedad(s, e);
                                        }
                                    }" />
                                <Image Url="../images/add.png">
                                </Image>
                            </dx:ASPxButton>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <dx:ASPxPanel ID="pnlNovedades" runat="server" ScrollBars="Auto" Height="250px">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxGridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" KeyFieldName="IdNovedad"
                                            ClientInstanceName="gvNovedades" Width="100%">
                                            <ClientSideEvents EndCallback="function(s, e) {
                                                ControlFinNovedad(s, e);
                                            }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="IdNovedad" ReadOnly="True" ShowInCustomizationForm="True"
                                                    VisibleIndex="0" Caption="Id">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="IdServicioMensajeria" ReadOnly="True" ShowInCustomizationForm="True"
                                                    VisibleIndex="0" Caption="IdServicio" Visible="false">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Estado" ShowInCustomizationForm="True" VisibleIndex="1"
                                                    Caption="Estado Novedad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="TipoNovedad" ShowInCustomizationForm="True"
                                                    VisibleIndex="2" Caption="Tipo de Novedad">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Observacion" ShowInCustomizationForm="True"
                                                    VisibleIndex="3" Caption="Observación">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn FieldName="FechaRegistro" ShowInCustomizationForm="True"
                                                    VisibleIndex="4" Caption="Fecha de Registro">
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataColumn Caption="Opc." VisibleIndex="10" Width="40px">
                                                    <DataItemTemplate>
                                                        <dx:ASPxHyperLink runat="server" ID="lnkGestionar" Text="Gestionar" Cursor="pointer"
                                                            ToolTip="Gestionar Novedad" OnInit="Link_InitNovedad">
                                                            <ClientSideEvents Click="function(s, e) { GestionarNovedad('{0}'); }" />
                                                        </dx:ASPxHyperLink>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                        </dx:ASPxGridView>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxPanel>
                        </td>
                    </tr>
                </table>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <%--Menú Flotante--%>
    <div id="bluebar" class="menuFlotante">
        <b class="rtop"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4">
        </b></b>
        <dx:ASPxCallbackPanel ID="cpLectura" runat="server" ClientInstanceName="cpLectura">
            <ClientSideEvents EndCallback="function(s, e) {
                ControlFinLectura(s, e);
            }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxPopupControl ID="pcDocumentoCierre" runat="server" HeaderText="Formato de Préstamo - SIEMBRA"
                        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="True"
                        ClientInstanceName="dialogoDocumentos" ContentUrl="" Height="600px" Modal="True"
                        Width="800px" CloseAction="CloseButton" BackColor="White">
                        <ClientSideEvents CloseUp="function(s, e) { CierreDeFormato(s, e); }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <table id="tblMenuFlotante" style="width: 99%;" runat="server">
                        <tr>
                            <td style="width: 20%">
                                <div style="float: left">
                                    <dx:ASPxTextBox ID="txtMin" runat="server" Width="150px" ClientInstanceName="txtMin"
                                        NullText="Digite MSISDN..." Font-Bold="True" Font-Size="Medium" Height="25px"
                                        AutoPostBack="false" onkeypress="javascript:return ValidaNumero(event);" MaxLength="10">
                                        <ClientSideEvents KeyPress="function(s, e) {
                                                if(e.htmlEvent.keyCode == 13) {
                                                    btnAdicionarMin.DoClick();
                                                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                }    
                                            }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnAdicionarMin" runat="server" Text="" Width="20px" HorizontalAlign="Center"
                                        Style="display: inline" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="False"
                                        Height="25px" ClientInstanceName="btnAdicionarMin">
                                        <ClientSideEvents Click="function(s, e) { 
                                                RegistrarMin(s, e);
                                            }"></ClientSideEvents>
                                        <Image Url="../images/keynumber.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                            <td style="width: 20%">
                                <div style="float: left">
                                    <dx:ASPxTextBox ID="txtLecturaSerial" runat="server" Width="170px" ClientInstanceName="txtLecturaSerial"
                                        NullText="Digite Serial..." Font-Bold="True" Font-Size="Medium" Height="25px"
                                        AutoPostBack="false">
                                        <ClientSideEvents KeyPress="function(s, e) {
                                                if(e.htmlEvent.keyCode == 13) {
                                                    btnRegistrarSerial.DoClick();
                                                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                }    
                                            }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnRegistrarSerial" runat="server" Text="" Width="20px" HorizontalAlign="Center"
                                        Style="display: inline" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="False"
                                        Height="25px" ClientInstanceName="btnRegistrarSerial">
                                        <ClientSideEvents Click="function(s, e) { 
                                                RegistrarSerial(s, e);
                                            }"></ClientSideEvents>
                                        <Image Url="../images/add.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                            <td style="width: 20%">
                                <div style="float: left">
                                    <dx:ASPxTextBox ID="txtDesvincularSerial" runat="server" Width="170px" ClientInstanceName="txtDesvincularSerial"
                                        NullText="Digite Serial..." Font-Bold="True" Font-Size="Medium" Height="25px"
                                        AutoPostBack="false">
                                        <ClientSideEvents KeyPress="function(s, e) {
                                                if(e.htmlEvent.keyCode == 13) {
                                                    btnDesvincularSerial.DoClick();
                                                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                                                }    
                                            }"></ClientSideEvents>
                                    </dx:ASPxTextBox>
                                </div>
                                <div style="float: left">
                                    <dx:ASPxButton ID="btnDesvincularSerial" runat="server" Width="20px" HorizontalAlign="Center"
                                        Style="display: inline" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="False"
                                        Height="25px" ClientInstanceName="btnDesvincularSerial">
                                        <ClientSideEvents Click="function(s, e) { 
                                                DesvincularSerial(s, e);
                                            }"></ClientSideEvents>
                                        <Image Url="../images/remove.png">
                                        </Image>
                                    </dx:ASPxButton>
                                </div>
                            </td>
                            <td style="width: 25%" align="center">
                                <dx:ASPxButton ID="btnNovedad" runat="server" Text="Novedades" Width="150px" HorizontalAlign="Center"
                                    Style="display: inline" AutoPostBack="false">
                                    <ClientSideEvents Click="function(s, e) {
                                        VisualizarNovedades(s, e);
                                    }"></ClientSideEvents>
                                    <Image Url="../images/comment_add.png">
                                    </Image>
                                </dx:ASPxButton>
                            </td>
                            <td valign="middle" style="width: 15%">
                                <dx:ASPxButton ID="btnDespachar" runat="server" Text="Despachar" Width="100px" HorizontalAlign="Center"
                                    Style="display: inline" AutoPostBack="False" CausesValidation="False" Height="25px"
                                    ClientEnabled="false" ClientInstanceName="btnDespachar">
                                    <ClientSideEvents Click="function(s, e) {
	                                    Despachar(s, e);
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </div>
    <div id="menu" style="float: right; width: 2%; position: fixed; overflow: hidden;
        display: none; right: 0px; bottom: 15px">
        <a style="cursor: hand; cursor: pointer;" onclick="toggle('bluebar','menu');">
            <img src="../images/tools-2.png" alt="Mostrar Menú" title="Mostrar Menú" />
        </a>
    </div>
    </form>
</body>
</html>
