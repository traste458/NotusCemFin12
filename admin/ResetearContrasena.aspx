<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ResetearContrasena.aspx.vb" Inherits="BPColSysOP.ResetearContrasena" %>

<!DOCTYPE html>
<%@ Register Src="~/ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina" TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Cambiar Contraseña</title>
    <link href="~/include/styleBACK.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css" />
    <link rel="shortcut icon" href="~/images/favicon.ico" type="image/x-icon" />
    <link rel="icon" href="~/images/favicon.ico" type="image/x-icon" />

    <link href="css/vinculos.css" rel="stylesheet" />
    <link href="include/styleBACK.css" rel="stylesheet" />
    <link href="bootstrap4content/bootstrap.min.css" rel="stylesheet" />
    <link href="bootstrap4content/jquery.toast.min.css" rel="stylesheet" />

    <script src="Scripts/jquery.min.js"></script>
    <script src="Scripts/popper.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery.toast.min.js"></script>
    <script src="Scripts/auxiliar.js"></script>

    <style type="text/css">
        A:link, A:visited {
            text-decoration: none;
            color: #FFFFFF;
            font-size: 7pt;
            font-family: verdana
        }

        A:active, A:hover {
            text-decoration: none;
            color: #FFC726;
            font-size: 7pt;
            font-family: verdana
        }

        .MenuCenter > tr > td {
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript">

</script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <div style="width: 100%; text-align: center">
            <table style="width: 50%; margin: 0 auto; font-family: Arial; font-size: small">
                <tr>
                    <td>                       
                    <img src="../images/LogoNotus.png" />
                </tr>

                <tr>
                    <td style="color: Red; font-weight: bold">
                        <asp:Literal ID="textoError" runat="server" EnableViewState="False"></asp:Literal></td>
                </tr>
                <tr>
                    <td>
                        <fieldset>
                            <div id="mainPanel">
                                <table style="width: 100%; background-color: #f5f5f5">
                                    <tr>
                                        <td style="display: table-cell; text-align: center">
                                            <br />
                                            <table align="center" style="border: 1px; border-color: black; border-style: solid">
                                                <tr>
                                                    <td>

                                                        <dx:ASPxRoundPanel ID="RpRecuperarContrasena" runat="server" BackColor="#DDC4F2" ShowHeader="false" View="GroupBox" Width="100%">
                                                            <PanelCollection>
                                                                <dx:PanelContent>
                                                                    <dx:ASPxRoundPanel ID="RpCambioDeContrasenaIngresoPrimeraVez" runat="server" BackColor="#DDC4F2" ShowHeader="false" View="GroupBox">
                                                                        <PanelCollection>
                                                                            <dx:PanelContent>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td forecolor="#883485" font-bold="True" font-size="12px" style="color: darkblue; font-weight: bold; text-align: right">Nueva Contraseña *:</td>
                                                                                        <td>
                                                                                            <dx:ASPxTextBox ID="txtNuevaContrasena" runat="server" Width="170px" Password="true"></dx:ASPxTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td forecolor="#883485" font-bold="True" font-size="12px" style="color: darkblue; font-weight: bold; text-align: right">Confirme Contraseña *:</td>
                                                                                        <td>
                                                                                            <dx:ASPxTextBox ID="txtConfirmarContrasena" runat="server" Width="170px" Password="true"></dx:ASPxTextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <caption>
                                                                                        <br />
                                                                                        <tr>
                                                                                            <td></td>
                                                                                            <td>
                                                                                                <dx:ASPxButton ID="btnContrasena" runat="server" AutoPostBack="False" Text="Cambiar Contraseña">
                                                                                                </dx:ASPxButton>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </caption>
                                                                                </table>
                                                                                <asp:Label ID="lblMessage" runat="server" />
                                                                            </dx:PanelContent>
                                                                        </PanelCollection>
                                                                    </dx:ASPxRoundPanel>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxRoundPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </fieldset>
                        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" EnableViewState="false" ContainerElementID="mainPanel" Modal="true"></dx:ASPxLoadingPanel>
                    </td>
                </tr>
        </div>
    </form>
</body>
</html>
