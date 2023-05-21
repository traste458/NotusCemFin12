<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="BPColSysOP.Login" %>
<%@ Register Assembly="DevExpress.Web.Bootstrap.v18.1, Version=18.1.17.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Notus ILS - Login</title>
    <link rel="shortcut icon" href="~/images/favicon.ico" type="image/x-icon" />
    <link rel="icon" href="~/images/favicon.ico" type="image/x-icon" />

    <link href="bootstrap4content/bootstrap.min.css" rel="stylesheet" />
    <link href="bootstrap4content/fonts/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="bootstrap4content/fonts/iconic/css/material-design-iconic-font.min.css" rel="stylesheet" />
    <link href="bootstrap4content/util.css" rel="stylesheet" />
    <link href="bootstrap4content/login-main.css" rel="stylesheet" />
    <script src="include/jquery-1.min.js"></script>
    <script src="Scripts/popper.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnIngresar").attr("class", "login100-form-btn");
        });

        function MostrarError(titulo, msg) {
            $("#tituloError").html("<strong>" + titulo + "</strong>");
            $("#mensajeError").text(msg);

            $("#dangerAlert").show();
            setTimeout(function () { $("#dangerAlert").hide() }, 15000);
        }

        function MostrarSuccess(titulo, msg) {
            $("#tituloSuccess").html("<strong>" + titulo + "</strong>");
            $("#mensajeSuccess").text(msg);

            $("#successAlert").show();
            setTimeout(function () { $("#successAlert").hide() }, 15000);
        }

        function ProcesarButtonClick(s, e) {
            var formularioValido = ValidarFormulario(s.name);

            if (formularioValido) {
                LoadingPanel.Show();
                e.processOnServer = true;
                setTimeout(function () { LoadingPanel.Hide() }, 15000);
            }
        }
    </script>
</head>
<body>
   <div class="container-login100">
        <div class="wrap-login100 p-l-55 p-r-55 p-t-40 p-b-30" id="mainPanel">
            <form id="form1" runat="server" class="login100-form validate-form">               
                <div class="flex-c">
                    <a href="#" class="login-logo">
                        <img src="images/LogoNotus.png" alt="Notus" />
                    </a>
                </div>
                <div class="row" style="width: 100%">
                    <br />
                    <div id="dangerAlert" class="alert alert-danger alert-dismissible collapse" style="width: 100%" role="alert">
                        <span id="tituloError"></span>
                        <br />
                        <span id="mensajeError"></span>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div id="successAlert" class="alert alert-success alert-dismissible collapse" style="width: 100%" role="alert">
                        <span id="tituloSuccess"></span>
                        <br />
                        <span id="mensajeSuccess"></span>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
                <div class="wrap-input100 validate-input m-b-15" data-validate="Usuario Requerido">
                    <input class="input100" type="text" runat="server" id="txtUsuario" name="txtUsuario" placeholder="Usuario" />
                    <span class="focus-input100"></span>
                </div>

                <div class="wrap-input100 validate-input m-b-25" data-validate="Password Requerido">
                    <input class="input100" type="password" runat="server" id="txtPassword" name="txtPassword" placeholder="Password" />
                    <span class="focus-input100"></span>
                </div>

                <div class="container-login100-form-btn">
                    <dx:BootstrapButton ID="btnIngresar" ClientInstanceName="btnIngresar" runat="server" AutoPostBack="true" OnClick="btnIngresar_Click" Text="Ingresar">
                        <CssClasses Control="login100-form-btn" />
                        <ClientSideEvents Click="ProcesarButtonClick" />
                    </dx:BootstrapButton>
                </div>
                <div style="text-align:center">
                    <asp:LinkButton runat="server" ID="lbRecuperarContrasena" Text="Recuperar Contraseña" Font-Bold="True" Style="color: #446eb5"> 
                    </asp:LinkButton>
                </div>
                <div>
                    <dx:ASPxPopupControl ID="pcCaptcha" runat="server" CloseAction="None" HeaderText="Verificación: escriba el código que aparece a continuación"
                        Modal="True" PopupHorizontalAlign="WindowCenter"
                        PopupVerticalAlign="WindowCenter" ShowCloseButton="False" AllowDragging="True">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <dx:ASPxCaptcha ID="captcha" runat="server" ClientInstanceName="captcha">
                                    <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                        <RequiredField IsRequired="True" ErrorText="Dato requerido" />
                                    </ValidationSettings>
                                    <RefreshButton Text="Mostrar otro código">
                                    </RefreshButton>
                                    <TextBox LabelText="Escriba el código mostrado:" />
                                </dx:ASPxCaptcha>
                                <br />
                                <table width="100%">
                                    <tr>
                                        <td align="right">
                                            <dx:ASPxButton ID="btnConfirmar" runat="server" Text="Continuar" AutoPostBack="false" OnClick="btnConfirmar_Click">
                                                <ClientSideEvents Click="ProcesarButtonClick" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                <div>
                  <dx:ASPxPopupControl ID="PopRecuperarContrasena" runat="server" CloseAction="CloseButton" HeaderText="Recuperación De Contraseña"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ShowOnPageLoad="false">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <dx:ASPxRoundPanel ID="RpRecuperarContrasena" runat="server" BackColor="#DDC4F2" ShowHeader="false" View="GroupBox">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <asp:PasswordRecovery ID="recuperarContrasena" OnVerifyingUser="recuperarContrasena_VerifyingUser" QuestionLabelText="Por favor ingrese su identificación para recuperar la contraseña"
                                                UserNameLabelText="No. Identificación ó Usuario" MembershipProvider="textboxInformacion" runat="server" BackColor="#E4E0E8" BorderPadding="4" Font-Names="Verdana"
                                                Font-Size="0.9em" ForeColor="#666666" Height="136px" Width="500px">
                                                <TextBoxStyle Font-Size="0.8em" />
                                                <SubmitButtonStyle BackColor="#432D58" BorderColor="Maroon" BorderStyle="Solid" BorderWidth="1px" Font-Bold="True" Font-Names="Verdana" Font-Size="X-Small" ForeColor="White" />
                                                <TitleTextStyle BackColor="#432D58" Font-Bold="True" Font-Names="Verdana" Font-Size="Small" ForeColor="White" />
                                            </asp:PasswordRecovery>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxRoundPanel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </div>
                  <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" EnableViewState="false" ContainerElementID="mainPanel" Modal="true"></dx:ASPxLoadingPanel>
            </form>
        </div>

    </div>
    <script src="Scripts/login-main.js"></script>
    <script type="text/javascript">
        document.getElementById("txtUsuario").focus();
    </script>
</body>
</html>
