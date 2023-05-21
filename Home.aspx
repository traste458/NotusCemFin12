<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Home.aspx.vb" Inherits="BPColSysOP.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notus ILS</title>
    <meta content='width=device-width, initial-scale=1.0, shrink-to-fit=no' name='viewport' />
    <link rel="shortcut icon" href="~/images/favicon.ico" type="image/x-icon" />
    <link rel="icon" href="~/images/favicon.ico" type="image/x-icon" />

    <!-- Fonts and icons -->
    <script src="bootstrap4content/layout/js/plugin/webfont/webfont.min.js"></script>
    <script>
        WebFont.load({
            google: { "families": ["Open+Sans:300,400,600,700"] },
            custom: { "families": ["Flaticon", "Font Awesome 5 Solid", "Font Awesome 5 Regular", "Font Awesome 5 Brands"], urls: ['bootstrap4content/layout/css/fonts.css'] },
            active: function () {
                sessionStorage.fonts = true;
            }
        });
    </script>

    <!-- CSS Files -->
    <link href="bootstrap4content/bootstrap.min.css" rel="stylesheet" />
    <link href="bootstrap4content/layout/css/azzara.css" rel="stylesheet" />
    <link href="bootstrap4content/jquery.toast.min.css" rel="stylesheet" />

    <script src="Scripts/jquery.min.js"></script>
    <script src="Scripts/popper.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery.toast.min.js"></script>
    <script src="Scripts/auxiliar.js"></script>

    <script type="text/javascript">
        var toastConfirmacion;

        $(document).ready(function () {
            CambiarAltoFrame();

            $(window).resize(function () {
                CambiarAltoFrame();
            });

            InicializarEventoFrame();
        });

        function CambiarAltoFrame() {
            var winHeight = $(window).height();
            //alert(winHeight - 100);
            $("#cpFrame_frmMain").height(winHeight - 60);
        }

        function InicializarEventoFrame() {
            $("#cpFrame_frmMain").on('load', function () {
                LoadingPanel.Hide();
            });
        }

    
        function CargarMenu(src) {
            
            LoadingPanel.Show();
            HabilitarODeshabilitarLinks(false);

            $("#cpFrame_frmMain").attr("src", src);

            setTimeout(function () { HabilitarODeshabilitarLinks(true); }, 1500);
        }

        function HabilitarODeshabilitarLinks(habilitar) {            
            $("a[href*='CargarMenu']").each(function () {
                if (habilitar) {
                    $(this).unbind("click");
                } else {
                    $(this).click(function (e) {
                        e.preventDefault();
                    });
                }
            });
        }

        function ConfirmarLogout() {
            toastConfirmacion = $.toast({
                heading: 'Confirmación',
                text: 'Realmente desea cerrar la sesión?<br/><br/><a class="btn btn-secondary" href="#" onclick="CerrarSesion();">&nbspSi&nbsp</a>&nbsp;&nbsp;<a class="btn btn-secondary" href="#" onclick="toastConfirmacion.reset();">&nbspNo&nbsp</a>',
                showHideTransition: 'fade',
                hideAfter: false,
                position: 'top-center',
                icon: 'warning',
                loaderBg: '#5f368d'
            })

        }

        function CerrarSesion() {
            window.location = "Login.aspx";
        }

        function solonumeros(e) {
        var key = window.event ? e.which : e.keyCode;
        if (key < 48 || key > 57) {
            e.preventDefault();
        }
    } 


    </script>
    <style type="text/css">
        span.texto-grande {
            font-size: 8px;
            color: #ffffff;
        }

        #txtIrMenu {
            min-width: 60px !important;
            width: 80px !important;
        }

        #btnCambiarPassword {
            color: white !important;            
        }
        #btnCancelarCambiarPassword {
            color: white !important;            
        }

        #btnBuscar{
            color: white !important;            
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <!--
			Tip 1: You can change the background color of the main header using: data-background-color="blue | purple | light-blue | green | orange | red"
		-->
            <div class="main-header" data-background-color="purple">
                <!-- Logo Header -->
                <div class="logo-header">

                    <a href="Home.aspx" class="logo">
                        <img src="bootstrap4content/layout/img/LogoNotus.png" alt="navbar brand" class="navbar-brand" />
                    </a>
                    <button class="navbar-toggler sidenav-toggler ml-auto" type="button" data-toggle="collapse" data-target="collapse" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon">
                            <i class="fa fa-bars"></i>
                        </span>
                    </button>
                    <button type="button" class="topbar-toggler more"><i class="fa fa-ellipsis-v"></i></button>
                    <div class="navbar-minimize">
                        <button type="button" class="btn btn-minimize btn-rounded">
                            <i class="fa fa-bars"></i>
                        </button>
                    </div>
                </div>
                <!-- End Logo Header -->
                <!-- Navbar Header -->
                
                <nav class="navbar navbar-header navbar-expand-lg">


                    <div class="container-fluid">
                        <div class="nav-search">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" class="btn btn-search pr-1" />                                                                                       
                                </div>
                                <div class="">
                                    <asp:TextBox ID="txtIrMenu" runat="server" class="form-control" placeholder="Ir ..." onkeypress="solonumeros(event);" MaxLength="6"></asp:TextBox>                                    
                                </div>

                            </div>
                        </div>



                        <div class="collapse navbar-collapse" id="navbarsExampleDefault">
                            <ul class="navbar-nav ml-auto">
                                <li class="nav-item">
                                    <a class="nav-link " href="#"><i class="fa fa-calendar"></i>
                                        <span id="fechaSesion2" runat="server" class="texto-tm"></span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link " href="#"><i class="fa fa-briefcase"></i>
                                        <span id="perfilUsuario2" runat="server" class="texto-tm"></span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="#"><i class="fa fa-book"></i>
                                        <span id="infoIp2" runat="server" class="texto-tm"></span>
                                    </a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link" href="#" aria-haspopup="true" aria-expanded="false">
                                        <span id="nombreUsuario2" runat="server" class="texto-tm"></span>
                                    </a>
                                </li>
                            </ul>
                        </div>



                        <ul class="navbar-nav topbar-nav ml-md-auto align-items-center">
                            <li class="nav-item dropdown hidden-caret">
                                <a class="dropdown-toggle profile-pic" data-toggle="dropdown" href="#" aria-expanded="false">
                                    <div class="avatar-sm">
                                        <img src="bootstrap4content/layout/img/avatar.jpg" alt="..." class="avatar-img rounded-circle" />
                                    </div>
                                </a>
                                <ul class="dropdown-menu dropdown-user animated fadeIn">
                                    <li>
                                        <div class="user-box">
                                            <!-- <div class="avatar-lg"><img src="bootstrap4content/layout/img/profile.jpg" alt="image profile" class="avatar-img rounded"></div> -->
                                            <div class="u-text">
                                                <!-- <a href="profile.html" class="btn btn-rounded btn-danger btn-sm">View Profile</a> -->
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="dropdown-divider"></div>
                                        <!-- <a class="dropdown-item" href="#">My Profile</a> -->
                                        <!-- <a class="dropdown-item" href="#">My Balance</a> -->
                                        <!-- <a class="dropdown-item" href="#">Inbox</a> -->
                                        <!-- <div class="dropdown-divider"></div> -->
                                        <a class="dropdown-item" href="#" onclick="MostrarCambioPassword();">Cambiar Password</a>
                                        <div class="dropdown-divider"></div>
                                        <a class="dropdown-item" href="#" onclick="ConfirmarLogout();">Cerrar Sesión</a>
                                    </li>
                                </ul>
                            </li>

                        </ul>


                    </div>



                </nav>
                <!-- End Navbar -->
            </div>

            <!-- Sidebar -->
            <div class="sidebar">

                <div class="sidebar-background"></div>
                <div class="sidebar-wrapper scrollbar-inner">
                    <div class="sidebar-content">
                        <div style="display: none;">
                            <div>
                                <a href="#" aria-expanded="true">
                                    <span id="nombreUsuario1" runat="server"></span>
                                    <span id="perfilUsuario1" runat="server" class="user-level"></span>
                                    <span id="infoIp1" class="user-level" runat="server"></span>
                                    <span>
                                        <span class="caret"></span>
                                    </span>
                                </a>

                                <div class="clearfix"></div>
                                <%--<div class="collapse in" id="collapsePerfil">
                                    <ul class="nav">
                                        <li>
                                            <a href="#">
                                                <span>IP: </span>&nbsp;<span id="infoIp1" runat="server" class="link-collapse"></span>
                                            </a>
                                        </li>
                                        <li>
                                            <span>Fecha: </span>&nbsp;<span id="infoFecha1" runat="server" class="link-collapse"></span>
                                        </li>
                                        <li>
										<a href="#settings">
											<span class="link-collapse">Settings</span>
										</a>
									</li>
                                    </ul>
                                </div>--%>
                            </div>
                        </div>
                        <asp:Repeater ID="rptMenu" runat="server">
                            <HeaderTemplate>
                                <ul class="nav">
                                    <li class="nav-section">
                                        <span class="sidebar-mini-icon">
                                            <i class="">Menú</i>
                                        </span>
                                        <h4 class="text-section">Menú</h4>
                                    </li>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li class="nav-item">
                                    <a data-toggle="collapse" href="#IdMenu_<%# DataBinder.Eval(Container.DataItem, "IdMenu") %>">
                                        <%--<i class="fas fa-bookmark"></i>--%>
                                        <p><%# DataBinder.Eval(Container.DataItem, "Menu") %></p>
                                        <span class="caret"></span>
                                    </a>
                                    <div class="collapse" id="IdMenu_<%# DataBinder.Eval(Container.DataItem, "IdMenu") %>">
                                        <asp:Repeater ID="rptMenusHijos" runat="server">
                                            <HeaderTemplate>
                                                <ul class="nav nav-collapse">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <li>
                                                    <a href="#" onclick="javascript: CargarMenu('<%# DataBinder.Eval(Container.DataItem, "Url") %>');">
                                                        <span class="sub-item"><strong><%# DataBinder.Eval(Container.DataItem, "IdMenu") %></strong> - <%# DataBinder.Eval(Container.DataItem, "Nombre") %></span>
                                                    </a>
                                                </li>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </ul>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>
                        <br />
                        <br />
                        <span style="color: white">&nbsp;&nbsp;&nbsp;Diseñado por: José Vélez Correa</span>
                    </div>
                </div>
            </div>
            <!-- End Sidebar -->

            <div class="main-panel">
                <div class="content">
                    <%--<div class="page-inner"></div>--%>
                    <dx:ASPxCallbackPanel ID="cpFrame" ClientInstanceName="cpFrame" runat="server" Width="100%">
                        <SettingsLoadingPanel Enabled="False" Delay="0"></SettingsLoadingPanel>
                        <PanelCollection>
                            <dx:PanelContent>
                                <iframe id="frmMain" style="background-color: white; border: 0px; width: 100%; height: 650px" runat="server" src="Valores.aspx"></iframe>
                            </dx:PanelContent>
                        </PanelCollection>                
                    </dx:ASPxCallbackPanel>
                    
                    <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="true"></dx:ASPxLoadingPanel>
                    <!-- <div class="page-header"> -->
                    <!-- <h4 class="page-title">Dashboard</h4> -->
                    <!-- <div class="btn-group btn-group-page-header ml-auto"> -->
                    <!-- <button type="button" class="btn btn-light btn-round btn-page-header-dropdown dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> -->
                    <!-- <i class="fa fa-ellipsis-h"></i> -->
                    <!-- </button> -->
                    <!-- <div class="dropdown-menu"> -->
                    <!-- <div class="arrow"></div> -->
                    <!-- <a class="dropdown-item" href="#">Action</a> -->
                    <!-- <a class="dropdown-item" href="#">Another action</a> -->
                    <!-- <a class="dropdown-item" href="#">Something else here</a> -->
                    <!-- <div class="dropdown-divider"></div> -->
                    <!-- <a class="dropdown-item" href="#">Separated link</a> -->
                    <!-- </div> -->
                    <!-- </div> -->
                    <!-- </div> -->
                </div>
            </div>
        </div>
       
        
        <dx:BootstrapPopupControl ID="pcCambiarPassword" ClientInstanceName="pcCambiarPassword" runat="server"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="450px" CloseAction="CloseButton"
            Modal="True" HeaderText="Cambiar Contraseña" AllowResize="True" AllowDragging="True" ShowFooter="True">
            <ContentCollection>
                <dx:ContentControl>
                    <dx:BootstrapCallbackPanel ID="cpCambioPassword" ClientInstanceName="cpCambioPassword" runat="server">
                        <ClientSideEvents EndCallback="ProcesarFinCallbackCambioPassword" />
                        <ContentCollection>
                            <dx:ContentControl>
                                <dx:BootstrapFormLayout ID="bflDatosPassword" ClientInstanceName="bflDatosPassword" runat="server">
                                    <Items>
                                        <dx:BootstrapLayoutItem Caption="Contraseña Actual" ColSpanLg="12" ColSpanMd="12" ColSpanXl="12">
                                            <ContentCollection>
                                                <dx:ContentControl>

                                                    <dx:BootstrapTextBox ID="txtPasswordActual" ClientInstanceName="txtPasswordActual" runat="server" Password="True">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithText">
                                                            <RequiredField IsRequired="true" ErrorText="Contraseña Actual Requerida" />
                                                        </ValidationSettings>
                                                    </dx:BootstrapTextBox>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:BootstrapLayoutItem>
                                        <dx:BootstrapLayoutItem Caption="Nueva Contraseña" ColSpanLg="12" ColSpanMd="12" ColSpanXl="12">
                                            <ContentCollection>
                                                <dx:ContentControl>
                                                    <dx:BootstrapTextBox ID="txtNuevoPassword" ClientInstanceName="txtNuevoPassword" runat="server" Password="True">
                                                        <ClientSideEvents Init="ObtenerActualComplejidadPassword" KeyUp="ObtenerActualComplejidadPassword" Validation="OnValidacionPassword" />
                                                        <ValidationSettings ErrorDisplayMode="ImageWithText">
                                                            <RequiredField IsRequired="true" ErrorText="Nueva Contraseña Requerida" />
                                                        </ValidationSettings>
                                                    </dx:BootstrapTextBox>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:BootstrapLayoutItem>
                                        <dx:BootstrapLayoutItem Caption="Confirmar Contraseña" ColSpanLg="12" ColSpanMd="12" ColSpanXl="12">
                                            <ContentCollection>
                                                <dx:ContentControl>
                                                    <dx:BootstrapTextBox ID="txtConfirmarPassword" ClientInstanceName="txtConfirmarPassword" runat="server" Password="True">
                                                        <ClientSideEvents Validation="OnValidacionPassword" />
                                                        <ValidationSettings ErrorDisplayMode="ImageWithText">
                                                            <RequiredField IsRequired="true" ErrorText="Confirmación de Contraseña Requerida" />
                                                        </ValidationSettings>
                                                    </dx:BootstrapTextBox>
                                                </dx:ContentControl>
                                            </ContentCollection>
                                        </dx:BootstrapLayoutItem>
                                    </Items>
                                </dx:BootstrapFormLayout>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:BootstrapCallbackPanel>
                </dx:ContentControl>
            </ContentCollection>

            <FooterTemplate>
                <dx:BootstrapButton class="btn btn-ttc" ID="btnCambiarPassword" ClientInstanceName="btnCambiarPassword" AutoPostBack="false" UseSubmitBehavior="false" runat="server" Text="Modificar" ClientIDMode="Static">
                    <ClientSideEvents Click="CambiarPassword" />
                </dx:BootstrapButton>
                &nbsp;&nbsp;&nbsp;
               <dx:BootstrapButton ID="btnCancelarCambiarPassword" ClientInstanceName="btnCancelarCambiarPassword" AutoPostBack="false" UseSubmitBehavior="false" runat="server" Text="Cancelar" ClientIDMode="Static">
                   <ClientSideEvents Click="OnBtnCancelarCambiarPasswordPopUpClick" />
               </dx:BootstrapButton>
            </FooterTemplate>
        </dx:BootstrapPopupControl>


    </form>

    <!-- jQuery UI -->
    <script src="bootstrap4content/layout/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
    <script src="bootstrap4content/layout/js/plugin/jquery-ui-touch-punch/jquery.ui.touch-punch.min.js"></script>

    <!-- jQuery Scrollbar -->
    <script src="bootstrap4content/layout/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>

    <!-- Moment JS -->
    <%--<script src="bootstrap4content/layout/js/plugin/moment/moment.min.js"></script>--%>

    <!-- Bootstrap Notify -->
    <script src="bootstrap4content/layout/js/plugin/bootstrap-notify/bootstrap-notify.min.js"></script>

    <!-- Bootstrap Toggle -->
    <script src="bootstrap4content/layout/js/plugin/bootstrap-toggle/bootstrap-toggle.min.js"></script>

    <!-- Sweet Alert -->
    <script src="bootstrap4content/layout/js/plugin/sweetalert/sweetalert.min.js"></script>

    <!-- Azzara JS -->
    <script src="bootstrap4content/layout/js/ready.js"></script>
</body>
</html>
