<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RetransmintirRutaOfficetrack.aspx.vb" Inherits="BPColSysOP.RetransmintirRutaOfficetrack" %>

<!DOCTYPE html>
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Retransmitir id ruta Officetrack</title>
     <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.min.js" type="text/javascript"></script>
    <script src="../include/FuncionesJS.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">

        <div>
            <dx:ASPxCallbackPanel runat="server" ID="cpPanel" ClientInstanceName="cpPanel">
                <ClientSideEvents EndCallback="function(s, e) {
                                $('#divEncabezado').html(s.cpMensaje);
                                loading.Hide();
                               
                            }" />
                <PanelCollection>
                    <dx:PanelContent>
                        <div id="divEncabezado">
                            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
                        </div>
                        <dx:ASPxRoundPanel ID="rpDatos" runat="server" HeaderText="Información" Width="50%"
                            ClientInstanceName="rpDatos">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table >
                                        <tr>
                                            <td>idRuta:
                                            </td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtidRuta" runat="server" NullText="idRuta..." Width="100px">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip"
                                                        ValidationGroup="vgCerrar">
                                                        <RegularExpression ErrorText="el idruta es un valor numerico"
                                                            ValidationExpression="^\s*\d+(\,\d{1,2})?\s*$" />
                                                        <RequiredField ErrorText="El idRuta es requerido" IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </td>

                                       
                                            <td >
                                                <dx:ASPxButton ID="btnTransmitir" runat="server" AutoPostBack="False"
                                                    ClientEnabled="true" ClientInstanceName="btnTransmitir" Text="Retransmitir Ruta "
                                                    Width="150px">
                                                    <ClientSideEvents Click="function(s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgCerrar')) {
                                                        cpPanel.PerformCallback();
                                                        loading.Show();
                                                    }
                                            }" />
                                                    <Image Url="../images/save_all.png">
                                                    </Image>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" Modal="true" ClientInstanceName="loading"></dx:ASPxLoadingPanel>
    </form>
</body>
</html>
