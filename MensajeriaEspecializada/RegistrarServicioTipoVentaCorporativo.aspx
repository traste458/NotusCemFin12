<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarServicioTipoVentaCorporativo.aspx.vb"
    Inherits="BPColSysOP.RegistrarServicioTipoVentaCorporativo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Src="../ControlesDeUsuario/EncabezadoPagina.ascx" TagName="EncabezadoPagina"
    TagPrefix="uc1" %>
<%@ Register Src="~/ControlesDeUsuario/SelectorDirecciondv.ascx" TagName="AddressSelector"
    TagPrefix="as" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.:: Registro de Servicio Corporativo ::.</title>
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet" />
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">

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

        function EjecutarCallbackGeneral(s, e, parametro, valor) {
            if (ASPxClientEdit.AreEditorsValid()) {
                LoadingPanel.Show();
                cpGeneral.PerformCallback(parametro + ':' + valor);
            }
        }

        function ValidaNumero(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }

        function soloLetras(e) {
            tecla = (document.all) ? e.keyCode : e.which;
            if (tecla == 8 || tecla == 32) return true;
            patron = /[A-Za-zñÑ]/;
            te = String.fromCharCode(tecla);
            return patron.test(te);
        }

        function MostrarErrores() {
            gvErrores.PerformCallback('erroresRegistro');
            EvaluarSeleccion();
            TamanioVentana();
            dialogoErrores.SetSize(myWidth * 0.7, myHeight * 0.65);
            dialogoErrores.ShowWindow();
        }

        function VerEjemplo1(ctrl) {
            window.location.href = 'Plantillas/EjemploMinesEquipoSim.xlsx';
        }

        function VerEjemplo2(ctrl) {
            window.location.href = 'Plantillas/EjemploMinesSoloSim.xlsx';
        }

        function Editar(element, key) {
            TamanioVentana();
            dialogoEditarMin.PerformCallback('Inicial:' + key)
            dialogoEditarMin.SetSize(myWidth * 0.5, myHeight * 0.3);
            dialogoEditarMin.ShowWindow();
        }

        function LimpiaFormulario(s, e) {
            if (confirm("¿Realmente desea limpiar los campos del formulario?")) {
                ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
                EjecutarCallbackGeneral(s, e, 'CancelarRegistro');
                rblTipoSolicitud.SetSelectedIndex(0);
                rblClienteClaro.SetSelectedIndex(0);
            }
        }

        function LimpiarControles() {
            ASPxClientEdit.ClearEditorsInContainerById('formPrincipal');
            rblTipoSolicitud.SetSelectedIndex(0);
            rblClienteClaro.SetSelectedIndex(0);
        }

        function DescargarDocumento(idDoc) {
            window.location.href = 'DescargaDocumento.aspx?id=' + idDoc + '&flag=1';
        }

        function EditarDocumento(element, key) {
            TamanioVentana();
            dialogoEditar.PerformCallback('Inicial:' + key)
            dialogoEditar.SetSize(myWidth * 0.6, myHeight * 0.4);
            dialogoEditar.ShowWindow();
        }

        function EliminarDocumento(element, key) {
            if (confirm("Esta seguro que desea eliminar el documento seleccionado?")) {
                gvDatos.PerformCallback('Eliminar:' + key);
            }
        }

        function SeleccionarODesmarcarTodo(ctrl, targetName) {
            $('#formPrincipal input[type="checkbox"]').each(function () {
                if (!$(this).attr("disabled"))
                    $(this).attr("checked", ctrl.checked);
            });
        }

        function ValidarSeleccion(s, e) {
            var cantidad = 0;
            var lista = new Array();

            $('#formPrincipal input[type="checkbox"]').each(function () {
                if ($(this).attr("checked")) {
                    var row = $(this).parent("span").parent("td");
                    var idDocumento = row.find('span');
                    if (idDocumento.attr('class')) {
                        lista[cantidad] = idDocumento.attr('class');
                        cantidad = cantidad + 1;
                    }

                }
            });
            if (cantidad > 0) {
                if (confirm('¿Realmente desea eliminar: [' + cantidad + '] ítems seleccionados?')) {
                    gvMateriales.PerformCallback('Eliminar:' + lista);
                }
            } else { alert('Debe seleccionar por lo menos un registro.'); }
        }

        function EvaluarSeleccion() {
            var valor = cmbTipoIdentificacion.GetText()
            if (valor.indexOf('NIT') != -1) {
                $('#divNombreRep').css('visibility', 'hidden');
                $('#divTelefonoRep').css('visibility', 'hidden');
                txtNombreRepresentante.SetEnabled(true);
                txtTelefonoFijo.SetEnabled(true);
            } else {
                $('#divNombreRep').css('visibility', 'visible');
                $('#divTelefonoRep').css('visibility', 'visible');
                txtNombreRepresentante.SetEnabled(false);
                txtTelefonoFijo.SetEnabled(false);
            }
            txtIdentificacionCliente.Focus();
        }

        var pageVisitedFlags = [false, false, false];
        var pageIndexToValidateOnPageControlEndCallback = -1;

        function OnSumbitButtonClick(s, e) {
            var tabPageCount = PageControl.GetTabCount();
            var valor = 0;
            for (var i = 0; i < tabPageCount; i++) {
                PageControl.SetActiveTab(PageControl.GetTab(i));
                if (!ValidatePage(i)) {
                    return;
                    valor = 1;
                } else {
                    PageControl.SetActiveTab(PageControl.GetTab(0));
                    valor = 0;
                }
            }
            if (valor == 0) {
                EjecutarCallbackGeneral(s, e, 'RegistrarServicio');
            }
        }

        function ValidatePage(pageIndex) {
            var editorsContainerId = "tblContainer" + pageIndex;
            return ASPxClientEdit.ValidateEditorsInContainerById(editorsContainerId);
        }

        function Procesar() {
            var valor = hdIdServicio.Get("valor");
            if (valor == 0) {
                gvMateriales.PerformCallback('cargaInicial');
            } else {
                gvErrores.PerformCallback();
                TamanioVentana();
                dialogoErrores.SetSize(myWidth * 0.6, myHeight * 0.6);
                dialogoErrores.ShowWindow();
            }
            LoadingPanel.Hide();
        }

        function ProcesarEspecial() {
            var valor = hdIdServicio.Get("valor");
            if (valor == 0) {
                gvDatos.PerformCallback("CargueDocumentos");
                alert("Documentos Cargados Satisfactoriamente.");
            }
            LoadingPanel.Hide();
        }

    </script>
</head>
<body class="cuerpo2">
    <form id="formPrincipal" runat="server">
        <div id="divEncabezado">
            <uc1:EncabezadoPagina ID="miEncabezado" runat="server" />
        </div>
        <dx:ASPxCallbackPanel ID="cpGeneral" runat="server">
            <ClientSideEvents EndCallback="function(s,e){ 
            $('#divEncabezado').html(s.cpMensaje);
            LoadingPanel.Hide();
            if (s.cpResultado != null) {
                if (s.cpResultado == 10) {
                    MostrarErrores();
                }
                if (s.cpResultado == 20) {
                    LimpiarControles();
                }
            }
        }"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxHiddenField ID="hdIdServicio" runat="server" ClientInstanceName="hdIdServicio"></dx:ASPxHiddenField>
                    <dx:ASPxRoundPanel ID="rpRegistro" runat="server" HeaderText="Registro Servicio" Width="90%" Theme="SoftOrange">
                        <PanelCollection>
                            <dx:PanelContent>
                                <table>
                                    <tr>
                                        <td>
                                            <dx:ASPxPageControl ID="pcAsociadosCampania" runat="server" ActiveTabIndex="2" Width="100%" ClientInstanceName="PageControl">
                                                <TabPages>
                                                    <dx:TabPage Text="Información de Cabecera">
                                                        <TabImage Url="../images/NewProcess.png"></TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl ID="ContentControl1" runat="server">
                                                                <table id="tblContainer0" width="100%">
                                                                    <tr>
                                                                        <td align="left" class="field">Fecha Solicitud:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxDateEdit ID="dateFechaSolicitud" runat="server" Width="150px" ClientInstanceName="dateFechaSolicitud" ClientEnabled="false">
                                                                            </dx:ASPxDateEdit>
                                                                        </td>
                                                                        <td align="left" class="field">Ciudad de Entrega:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbCiudadEntrega" runat="server" DropDownStyle="DropDownList"
                                                                                ValueField="idCiudad" ValueType="System.String" TextFormatString="{0} ({1})"
                                                                                IncrementalFilteringMode="Contains" Width="250px" TabIndex="1">
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="nombreCiudad" Caption="Ciudad" Width="200px" />
                                                                                    <dx:ListBoxColumn FieldName="nombreDepartamento" Caption="Departamento" Width="200px" />
                                                                                </Columns>
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField ErrorText="La ciudad es requerida" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                        <td align="left" class="field">Nombre del Cliente:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtNombreEmpresa" runat="server" NullText="Nombre del cliente..."
                                                                                Width="250px" TabIndex="2" onkeypress="return soloLetras(event)">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                                    <RequiredField ErrorText="El nombre de la empresa es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Tipo Identificación
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbTipoIdentificacion" runat="server" DropDownStyle="DropDownList"
                                                                                ValueField="idTipo" ValueType="System.Int32" TextFormatString="{0} ({1})" ClientInstanceName="cmbTipoIdentificacion"
                                                                                IncrementalFilteringMode="Contains" Width="250px" TabIndex="3">
                                                                                <ClientSideEvents SelectedIndexChanged="function (s, e){
                                                                            EvaluarSeleccion();
                                                                            }" />
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="idTipo" Caption="Id" Width="50px" />
                                                                                    <dx:ListBoxColumn FieldName="descripcion" Caption="Tipo" Width="200px" />
                                                                                </Columns>
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField ErrorText="La ciudad es requerida" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                        <td align="left" class="field">Número Identificación:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtIdentificacionCliente" runat="server" MaxLength="10" NullText="Identificación..."
                                                                                onkeypress="javascript:return ValidaNumero(event);" Width="200px" TabIndex="4" ClientInstanceName="txtIdentificacionCliente">
                                                                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                                    ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField ErrorText="La identificación es requerida" IsRequired="True" />
                                                                                    <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td align="left" class="field">Nombre Representante Legal:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtNombreRepresentante" runat="server" NullText="Nombre Representante Legal..." ClientEnabled="false"
                                                                                Width="250px" TabIndex="5" onkeypress="return soloLetras(event)" ClientInstanceName="txtNombreRepresentante">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                                    <RequiredField IsRequired="True" ErrorText="El nombre del representante es requerido"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                            <div id="divNombreRep" style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px; visibility: visible">
                                                                                <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Exlusivo tipo identificación NIT."
                                                                                    CssClass="comentario" Width="150px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Teléfono Fijo:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtTelefonoFijo" runat="server" NullText="Número fijo del representante..." ClientEnabled="false"
                                                                                Width="250px" TabIndex="6" onkeypress="javascript:return ValidaNumero(event);" ClientInstanceName="txtTelefonoFijo">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                                    <RequiredField ErrorText="El teléfono fjo de la empresa es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                            <div id="divTelefonoRep" style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px; visibility: visible">
                                                                                <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="Exlusivo tipo identificación NIT."
                                                                                    CssClass="comentario" Width="150px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </td>
                                                                        <td align="left" class="field">Numero Cédula Representante:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtIdentificacionRepresentante" runat="server" MaxLength="15" TabIndex="7"
                                                                                NullText="Cédula Representante..." onkeypress="javascript:return ValidaNumero(event);" Width="200px">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                                    <RequiredField IsRequired="True" ErrorText="El tel&#233;fono m&#243;vil es requerido"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td align="left" class="field">Teléfono Representante:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtTelefonoMovilRepresentante" runat="server" MaxLength="10" NullText="Número Celular Representante..."
                                                                                onkeypress="javascript:return ValidaNumero(event);" Width="200px" TabIndex="8">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                                    <RequiredField IsRequired="True" ErrorText="El tel&#233;fono m&#243;vil es requerido"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Nombre persona autorizada:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtPersonaAutorizada" runat="server" NullText="Nombre Persona Autorizada..." Width="250px"
                                                                                TabIndex="9" onkeypress="return soloLetras(event)">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                                    <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td align="left" class="field">Número Cédula Autorizado:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtIdentificacionAutorizado" runat="server" MaxLength="15" NullText="Cédula Autorizado..."
                                                                                onkeypress="javascript:return ValidaNumero(event);" Width="200px" TabIndex="10">
                                                                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                                                    ErrorText="Valor incorrecto" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                                    <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td align="left" class="field">Cargo Persona Autorizada:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtCargoPersonaAutorizada" runat="server" NullText="Cargo Persona Autorizada..." Width="250px"
                                                                                TabIndex="11" onkeypress="return soloLetras(event)">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[a-zA-Z,;:\.\*\!\¡\?\¿\b\sáéíóúÁÉÍÓÚñÑ\-\#]+\s*$" />
                                                                                    <RequiredField ErrorText="El nombre de la persona autorizada es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Teléfono Celular:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtTelefonoAutorizado" runat="server" NullText="Número Celular Autorizado..." Width="250px" TabIndex="12">
                                                                                <MaskSettings Mask="3000000000"></MaskSettings>
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                                                    <RequiredField ErrorText="El teléfono fjo de la empresa es requerido" IsRequired="True" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                        <td align="left" class="field">Gerencia:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbGerencia" runat="server" ClientInstanceName="cmbGerencia"
                                                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idGerencia"
                                                                                Width="200px" TabIndex="13">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                                                    ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField IsRequired="True" ErrorText="La Gerencia es requerida"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                        <td align="left" class="field">Coordinador:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbCoordinador" runat="server" ClientInstanceName="cmbCoordinador"
                                                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="IdTercero"
                                                                                Width="250px" TabIndex="14">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                                                    ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField IsRequired="True" ErrorText="La Gerencia es requerida"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Consultor:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbConsultor" runat="server" ClientInstanceName="cmbConsultor"
                                                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="IdTercero"
                                                                                ValueType="System.Int32" Width="250px" ClientEnabled="false" TabIndex="15">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                                                    ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField IsRequired="True" ErrorText="El Consultor es requerido"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                        <td align="left" class="field">Cliente Claro:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxRadioButtonList ID="rblClienteClaro" runat="server" RepeatDirection="Horizontal"
                                                                                ClientInstanceName="rblClienteClaro" Font-Size="XX-Small" Height="10px" TabIndex="16">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Si" Value="1" Selected="true" />
                                                                                    <dx:ListEditItem Text="No" Value="0" />
                                                                                </Items>
                                                                                <Border BorderStyle="None"></Border>
                                                                            </dx:ASPxRadioButtonList>
                                                                        </td>
                                                                        <td align="left" class="field">Forma Pago:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbFormaPago" runat="server" ClientInstanceName="cmbFormaPago"
                                                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idFormaPago"
                                                                                Width="250px" TabIndex="17">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                                                    ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField IsRequired="True" ErrorText="La forma de pago es requerida"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Dirección:
                                                                        </td>
                                                                        <td>
                                                                            <as:AddressSelector ID="memoDireccion" runat="server" />
                                                                        </td>
                                                                        <td align="left" class="field">Observaciones Dirección:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxMemo ID="memoObservacionDireccion" runat="server" NullText="Información adicional a la dirección..."
                                                                                Rows="2" Width="250px" TabIndex="18">
                                                                            </dx:ASPxMemo>
                                                                        </td>
                                                                        <td align="left" class="field">Barrio:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtBarrio" runat="server" NullText="Barrio del Cliente..." Width="200px" TabIndex="19">
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgRegistrar" SetFocusOnError="true">
                                                                                    <RequiredField IsRequired="True" ErrorText="El barrio es requerido"></RequiredField>
                                                                                </ValidationSettings>
                                                                            </dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Observaciones:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxMemo ID="memoObservaciones" runat="server" NullText="Observaciones..." Rows="2"
                                                                                Width="250px" TabIndex="20">
                                                                            </dx:ASPxMemo>
                                                                        </td>
                                                                        <td class="field">Soportes Pago:
                                                                        </td>
                                                                        <td>
                                                                            <asp:FileUpload ID="fuPago" runat="server" />
                                                                            <div style="margin-top: 5px; margin-bottom: 5px;">
                                                                                <dx:ASPxButton ID="btnPago" runat="server" ClientInstanceName="btnPago"
                                                                                    Text="" Theme="SoftOrange" AutoPostBack="true" Width="30px" Height="10px">
                                                                                    <ClientSideEvents Click="function (s, e){
                                                                                LoadingPanel.Show(); 
                                                                            }" />
                                                                                    <Image Url="~/images/upload.png" Height="5px" Width="15px"></Image>
                                                                                </dx:ASPxButton>
                                                                            </div>
                                                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Procesar Archivo."
                                                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </td>
                                                                        <td class="field">Portación:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxRadioButtonList ID="rblPortacion" runat="server" RepeatDirection="Horizontal"
                                                                                ClientInstanceName="rblPortacion" Font-Size="XX-Small" Height="10px" TabIndex="16">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Si" Value="1" />
                                                                                    <dx:ListEditItem Text="No" Value="0" Selected="true" />
                                                                                </Items>
                                                                                <Border BorderStyle="None"></Border>
                                                                            </dx:ASPxRadioButtonList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Detalle Materiales">
                                                        <TabImage Url="../images/list_num.png"></TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl>
                                                                <table>
                                                                    <tr>
                                                                        <td align="left" class="field">Tipo Solicitud
                                                                        </td>
                                                                        <td align="right">
                                                                            <dx:ASPxRadioButtonList ID="rblTipoSolicitud" runat="server" ClientInstanceName="rblTipoSolicitud"
                                                                                RepeatDirection="Horizontal">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Equipo / Equipo y Sim" Value="1" Selected="true" />
                                                                                    <dx:ListEditItem Text="Solo Sim" Value="2" />
                                                                                </Items>
                                                                                <Border BorderStyle="None" />
                                                                            </dx:ASPxRadioButtonList>
                                                                        </td>
                                                                        <td align="left" class="field">Seleccione un Archivo:
                                                                        </td>
                                                                        <td>
                                                                            <asp:FileUpload ID="fuArchivo" runat="server" />
                                                                            <div style="margin-top: 5px; margin-bottom: 5px;">
                                                                                <dx:ASPxButton ID="btnUpload" runat="server" ClientInstanceName="btnUpload" CssClass="submit"
                                                                                    Text="" Theme="SoftOrange" AutoPostBack="true" Width="30px" Height="10px">
                                                                                    <ClientSideEvents Click="function (s, e){ LoadingPanel.Show(); }" />
                                                                                    <Image Url="~/images/upload.png" Height="5px" Width="15px"></Image>
                                                                                </dx:ASPxButton>
                                                                            </div>
                                                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Procesar Archivo."
                                                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <a href="javascript:void(0);" id="VerEjemplo" onclick="javascript:VerEjemplo1($(this));"
                                                                                    class="style2"><span class="style3">(Ver Archivo Ejemplo Equipo Sim)</span></a>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <a href="javascript:void(0);" id="A1" onclick="javascript:VerEjemplo2($(this));"
                                                                                    class="style2"><span class="style3">(Ver Archivo Ejemplo Solo Sim)</span></a>
                                                                            </div>
                                                                        </td>
                                                                        <td class="field" align="left">Soportes Precio Especial:
                                                                        </td>
                                                                        <td>
                                                                            <asp:FileUpload ID="fuEspecial" runat="server" />
                                                                            <div style="margin-top: 5px; margin-bottom: 5px;">
                                                                                <dx:ASPxButton ID="btnEspecial" runat="server" ClientInstanceName="btnEspecial"
                                                                                    Text="" Theme="SoftOrange" AutoPostBack="true" Width="30px" Height="10px">
                                                                                    <ClientSideEvents Click="function (s, e){
                                                                                    LoadingPanel.Show(); 
                                                                                }" />
                                                                                    <Image Url="~/images/upload.png" Height="5px" Width="15px"></Image>
                                                                                </dx:ASPxButton>
                                                                            </div>
                                                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                                                <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="Procesar Archivo."
                                                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                                                </dx:ASPxLabel>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" class="field">Bodega Servicio:
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox ID="cmbBodega" runat="server" ClientInstanceName="cmbBodega" Width="200px"
                                                                                IncrementalFilteringMode="Contains" DropDownStyle="DropDownList" ValueField="idbodega">
                                                                                <ClientSideEvents SelectedIndexChanged="function (s,e){
                                                                                hdIdServicio.Set('idBodega',cmbBodega.GetValue());
                                                                                }" />
                                                                                <Columns>
                                                                                    <dx:ListBoxColumn FieldName="idbodega" Caption="Id" Width="20px" Visible="false" />
                                                                                    <dx:ListBoxColumn FieldName="bodega" Caption="Nombre" Width="300px" />
                                                                                </Columns>
                                                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="vgCrea">
                                                                                    <RequiredField ErrorText="Información Requerida" IsRequired="true" />
                                                                                </ValidationSettings>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <dx:ASPxRoundPanel ID="rdResultado" runat="server" HeaderText="Materiales del Servicio"
                                                                                ClientInstanceName="rdResultado" Theme="SoftOrange">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent>
                                                                                        <dx:ASPxGridView ID="gvMateriales" runat="server" AutoGenerateColumns="False" Font-Size="Small"
                                                                                            ClientInstanceName="gvMateriales" KeyFieldName="msisdn" Theme="SoftOrange">
                                                                                            <ClientSideEvents EndCallback="function(s,e){ 
                                                                                            $('#divEncabezado').html(s.cpMensaje);
                                                                                            LoadingPanel.Hide();
                                                                                            dialogoEditarMin.Hide();
                                                                                        }"></ClientSideEvents>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn Caption="Msisdn" FieldName="msisdn" VisibleIndex="1"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Material" FieldName="materialEquipo" VisibleIndex="2"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Descripción" FieldName="subproducto" VisibleIndex="3"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Precio Especial" FieldName="precioEspecial" VisibleIndex="4"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Valor Unitario" FieldName="precioUnitario" VisibleIndex="5"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Requiere Sim" FieldName="requiereSim" VisibleIndex="6"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Tipo SIM" FieldName="tipoSim" VisibleIndex="7"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Cuenta" FieldName="codigoCuenta" VisibleIndex="8"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Plan" FieldName="nombrePlan" VisibleIndex="9"
                                                                                                    Visible="true">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataColumn Caption="Eliminar" VisibleIndex="10">
                                                                                                    <HeaderCaptionTemplate>
                                                                                                        <asp:CheckBox ID="chkSeleccionarTodo" runat="server" AutoPostBack="false" onclick="SeleccionarODesmarcarTodo(this,'chkSeleccion');" />
                                                                                                        <asp:Panel ID="pnlPicking" runat="server" Style="display: inline">
                                                                                                            <dx:ASPxImage ID="imgEliminar" runat="server" ImageUrl="../images/error.png" ClientInstanceName="imgEliminar" ToolTip="Eliminar" Cursor="pointer">
                                                                                                                <ClientSideEvents Click="function (s, e){
                                                                                                                ValidarSeleccion(s, e);
                                                                                                            }" />
                                                                                                            </dx:ASPxImage>
                                                                                                        </asp:Panel>
                                                                                                    </HeaderCaptionTemplate>
                                                                                                    <DataItemTemplate>
                                                                                                        <asp:CheckBox ID="chkSeleccion" runat="server" OnInit="Chk_Init" CssClass="{0}" />
                                                                                                    </DataItemTemplate>
                                                                                                </dx:GridViewDataColumn>
                                                                                                <dx:GridViewDataTextColumn Caption="Opciones" ReadOnly="True" ShowInCustomizationForm="True"
                                                                                                    VisibleIndex="9">
                                                                                                    <DataItemTemplate>
                                                                                                        <dx:ASPxHyperLink runat="server" ID="lnkEliminar" ImageUrl="../images/DxEdit.png"
                                                                                                            Cursor="pointer" ToolTip="Actualizar Detalle" OnInit="Link_Init">
                                                                                                            <ClientSideEvents Click="function(s, e) { Editar(this, {0}); }" />
                                                                                                        </dx:ASPxHyperLink>
                                                                                                    </DataItemTemplate>
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <Settings ShowFooter="false" ShowHeaderFilterButton="true" />
                                                                                            <SettingsPager PageSize="10">
                                                                                                <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                                                                <PageSizeItemSettings ShowAllItem="True" Visible="True">
                                                                                                </PageSizeItemSettings>
                                                                                            </SettingsPager>
                                                                                            <Settings ShowHeaderFilterButton="True"></Settings>
                                                                                            <SettingsText Title="Detalle Materiales Servicio" EmptyDataRow="No se encontraron mines asociados al servicio que esta registrando."
                                                                                                CommandEdit="Editar"></SettingsText>
                                                                                        </dx:ASPxGridView>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxRoundPanel>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Documentos Cargados">
                                                        <TabImage Url="../images/documents_stack.png"></TabImage>
                                                        <ContentCollection>
                                                            <dx:ContentControl>
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <dx:ASPxGridView ID="gvDatos" runat="server" AutoGenerateColumns="False" Width="100%"
                                                                                ClientInstanceName="gvDatos" KeyFieldName="idRegistro" Theme="SoftOrange">
                                                                                <ClientSideEvents EndCallback="function(s,e){ 
                                                                                $('#divEncabezado').html(s.cpMensaje);
                                                                                LoadingPanel.Hide();
                                                                            }"></ClientSideEvents>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="0" FieldName="idRegistro"
                                                                                        ReadOnly="True">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Nombre del Documento" ShowInCustomizationForm="True"
                                                                                        VisibleIndex="1" FieldName="nombreDocumento">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Nombre del Archivo" ShowInCustomizationForm="True"
                                                                                        VisibleIndex="2" FieldName="nombreArchivo">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Fecha de Recepción" ShowInCustomizationForm="True"
                                                                                        VisibleIndex="4" FieldName="fechaRecepcion">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataColumn Caption="Opciones" VisibleIndex="6">
                                                                                        <DataItemTemplate>
                                                                                            <dx:ASPxHyperLink runat="server" ID="lnkVer" ImageUrl="~/images/pdf.png" Cursor="pointer"
                                                                                                ToolTip="Descargar Archivo" OnInit="LinkDoc_Init">
                                                                                                <ClientSideEvents Click="function(s, e) { DescargarDocumento({0}) }" />
                                                                                            </dx:ASPxHyperLink>
                                                                                            <dx:ASPxHyperLink runat="server" ID="lnkEditar" ImageUrl="../images/DxMarker.png"
                                                                                                Cursor="pointer" ToolTip="Editar Documento" OnInit="LinkDoc_Init">
                                                                                                <ClientSideEvents Click="function(s, e) { EditarDocumento (this, {0}); }" />
                                                                                            </dx:ASPxHyperLink>
                                                                                            <dx:ASPxHyperLink runat="server" ID="lnk" ImageUrl="../images/error.png"
                                                                                                Cursor="pointer" ToolTip="Eliminar Documento" OnInit="LinkDoc_Init">
                                                                                                <ClientSideEvents Click="function(s, e) { EliminarDocumento (this, {0}); }" />
                                                                                            </dx:ASPxHyperLink>
                                                                                        </DataItemTemplate>
                                                                                        <CellStyle HorizontalAlign="Center">
                                                                                        </CellStyle>
                                                                                    </dx:GridViewDataColumn>
                                                                                </Columns>
                                                                                <SettingsBehavior AutoExpandAllGroups="True" EnableCustomizationWindow="True"></SettingsBehavior>
                                                                                <Settings VerticalScrollableHeight="300" />
                                                                                <SettingsPager PageSize="50">
                                                                                    <PageSizeItemSettings Visible="true" ShowAllItem="true" />
                                                                                </SettingsPager>
                                                                                <Settings ShowGroupPanel="false"></Settings>
                                                                                <Settings ShowHeaderFilterButton="True"></Settings>
                                                                                <Settings ShowTitlePanel="True" ShowHeaderFilterBlankItems="False"></Settings>
                                                                                <SettingsText Title="B&#250;squeda General de Documentos" EmptyDataRow="No se encontraron datos acordes con los filtros de b&amp;uacute;squeda" CommandEdit="Editar"></SettingsText>
                                                                            </dx:ASPxGridView>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                </TabPages>
                                            </dx:ASPxPageControl>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <dx:ASPxImage ID="imgRegistro" runat="server" ImageUrl="../images/DxConfirm32.png"
                                                ToolTip="Registrar" ClientInstanceName="imgRegistro" Cursor="pointer" TabIndex="22">
                                                <ClientSideEvents Click="function(s, e){
                                                OnSumbitButtonClick();
                                            }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="imgBorrar" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Borrar Filtros"
                                                ClientInstanceName="imgBorrar" Cursor="pointer" TabIndex="23">
                                                <ClientSideEvents Click="function(s, e){
                                                LimpiaFormulario(s, e);
                                            }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxButton ID="btnSubmit" runat="server" Text="Submit" Width="60px" CausesValidation="False"
                                                UseSubmitBehavior="False" ClientInstanceName="btnSubmit" ClientVisible="false">
                                                <ClientSideEvents Click="OnSumbitButtonClick" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                    <dx:ASPxPopupControl ID="dialogoEditar" runat="server" ClientInstanceName="dialogoEditar"
                        HeaderText="Editar Documento Servicio Mensajeria" AllowDragging="true" Width="400px" Height="180px"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        ScrollBars="Auto" CloseAction="CloseButton" Theme="SoftOrange">
                        <ClientSideEvents EndCallback="function (s, e){
                            $('#divEncabezado').html(s.cpMensaje);
                        }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="pccModificaDocumento">
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td class="field" align="left">Id Documento:
                                        </td>
                                        <td>
                                            <dx:ASPxLabel ID="lblIdDocumento" runat="server" ClientInstanceName="lblIdDocumento"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Medium">
                                            </dx:ASPxLabel>
                                        </td>
                                        <td class="field" align="left">Nombre Documento:
                                        </td>
                                        <td>
                                            <dx:ASPxLabel ID="lblNombreDocumento" runat="server" ClientInstanceName="lblNombreDocumento"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Small">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field" align="left">Nombre Archivo:
                                        </td>
                                        <td colspan="3">
                                            <dx:ASPxLabel ID="lblNombreArchivo" runat="server" ClientInstanceName="lblNombreArchivo"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Small">
                                            </dx:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Seleccione Archivo:
                                        </td>
                                        <td>
                                            <asp:FileUpload ID="fuActualizar" runat="server" />
                                            <div style="margin-top: 5px; margin-bottom: 5px;">
                                                <dx:ASPxButton ID="btnActualizar" runat="server" ClientInstanceName="btnActualizar"
                                                    Text="" Theme="SoftOrange" AutoPostBack="true" Width="30px" Height="10px">
                                                    <ClientSideEvents Click="function (s, e){
                                                        dialogoEditar.Hide();
                                                        LoadingPanel.Show(); 
                                                    }" />
                                                    <Image Url="~/images/upload.png" Height="5px" Width="15px"></Image>
                                                </dx:ASPxButton>
                                            </div>
                                            <div style="margin-left: 5px; margin-bottom: 5px; margin-top: 5px;">
                                                <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="Procesar Archivo."
                                                    CssClass="comentario" Width="80px" Font-Size="XX-Small" Font-Bold="False" Font-Italic="True"
                                                    Font-Names="Arial" Font-Overline="False" Font-Strikeout="False">
                                                </dx:ASPxLabel>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <dx:ASPxPopupControl ID="dialogoEditarMin" runat="server" ClientInstanceName="dialogoEditarMin"
                        HeaderText="Editar Msisdn Servicio Mensajeria" AllowDragging="true"
                        Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        ScrollBars="Auto" CloseAction="CloseButton" Theme="SoftOrange">
                        <ClientSideEvents EndCallback="function (s, e){
                            $('#divEncabezado').html(s.cpMensaje);
                        }" />
                        <ContentCollection>
                            <dx:PopupControlContentControl ID="PopupControlContentControl1">
                                <table cellpadding="1" width="100%">
                                    <tr>
                                        <td class="field" align="left">Msisdn:
                                        </td>
                                        <td>
                                            <dx:ASPxLabel ID="lblMsisdn" runat="server" ClientInstanceName="lblMsisdn"
                                                Font-Bold="True" Font-Italic="True" Font-Overline="False" Font-Size="Medium">
                                            </dx:ASPxLabel>
                                        </td>
                                        <td class="field" align="left">Precio Especial:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbPrecio" runat="server" ValueType="System.Int32" Width="150px">
                                                <Items>
                                                    <dx:ListEditItem Text="Si" Value="1" />
                                                    <dx:ListEditItem Text="No" Value="2" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field" align="left">Valor Unitario:
                                        </td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtValorUnitario" runat="server" MaxLength="8" NullText="Valor Unitario..."
                                                onkeypress="javascript:return ValidaNumero(event);" Width="150px">
                                                <ValidationSettings CausesValidation="True" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip"
                                                    ErrorText="Valor incorrecto" ValidationGroup="vgActualizar">
                                                    <RegularExpression ErrorText="Los caracteres ingresados no son validos" ValidationExpression="^\s*[0-9]+\s*$" />
                                                    <RequiredField IsRequired="True" ErrorText="La identificaci&#243;n es requerida"></RequiredField>
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </td>
                                        <td class="field" align="left">Región:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbRegion" runat="server" ClientInstanceName="cmbRegion" ValueType="System.Int32"
                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idRegion" Width="150px">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idRegion" Width="10%" Caption="Id." />
                                                    <dx:ListBoxColumn FieldName="codigo" Width="70%" Caption="Región" />
                                                </Columns>
                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                    ValidationGroup="vgActualizar">
                                                    <RequiredField IsRequired="True" ErrorText="La región es requerida"></RequiredField>
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr id="trEquipo" runat="server">
                                        <td class="field" align="left">Material:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbMaterial" runat="server" Width="150px" IncrementalFilteringMode="Contains"
                                                ClientInstanceName="cmbMaterial" DropDownStyle="DropDownList" ValueType="System.String" ValueField="Material"
                                                CallbackPageSize="25" EnableCallbackMode="true" FilterMinLength="3">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Material" Width="70px" Caption="Material" />
                                                    <dx:ListBoxColumn FieldName="ReferenciaCliente" Width="300px" Caption="Referencia" />
                                                </Columns>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td class="field" align="left">Requiere SIM:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbRequiereSIM" runat="server" ValueType="System.Int32" Width="150px">
                                                <Items>
                                                    <dx:ListEditItem Text="Si" Value="1" />
                                                    <dx:ListEditItem Text="No" Value="2" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr id="trSim" runat="server">
                                        <td class="field" align="left">Tipo SIM:
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox ID="cmbTipoSim" runat="server" ClientInstanceName="cmbTipoSim" ValueType="System.Int32"
                                                DropDownWidth="300px" IncrementalFilteringMode="Contains" ValueField="idClase" Width="150px">
                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="idClase" Width="10%" Caption="Id." />
                                                    <dx:ListBoxColumn FieldName="nombre" Width="70%" Caption="Tipo" />
                                                </Columns>
                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorText="Valor incorrecto"
                                                    ValidationGroup="vgActualizar">
                                                    <RequiredField IsRequired="True" ErrorText="El Tipo de Sim es requerido"></RequiredField>
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="4">
                                            <dx:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="../images/DxAdd32.png"
                                                ToolTip="Actualizar" ClientInstanceName="imgRegistro" Cursor="pointer" TabIndex="20">
                                                <ClientSideEvents Click="function(s, e){
                                                    if(ASPxClientEdit.ValidateGroup('vgActualizar')){
                                                        LoadingPanel.Show();
                                                        var msisdn = lblMsisdn.GetValue();
                                                        gvMateriales.PerformCallback('EditarMin:' + msisdn);
                                                        }        
                                                }" />
                                            </dx:ASPxImage>
                                            <dx:ASPxImage ID="ASPxImage2" runat="server" ImageUrl="../images/DxCancel32.png" ToolTip="Cancelar"
                                                ClientInstanceName="imgBorrar" Cursor="pointer" TabIndex="10">
                                                <ClientSideEvents Click="function(s, e){
                                                    dialogoEditarMin.Hide();
                                                }" />
                                            </dx:ASPxImage>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPopupControl ID="pcErrores" runat="server" ClientInstanceName="dialogoErrores" ScrollBars="Auto"
            HeaderText="Resultado Proceso" AllowDragging="true" Width="400px" Height="180px"
            Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" Theme="SoftOrange">
            <ContentCollection>
                <dx:PopupControlContentControl ID="pccError" runat="server">
                    <dx:ASPxRoundPanel ID="rpLogErrores" runat="server" HeaderText="Log de Errores" Theme="SoftOrange">
                        <HeaderTemplate>
                            <dx:ASPxImage ID="headerImage" runat="server" ImageUrl="../images/MSExcel.png" Cursor="pointer"
                                ImageAlign="Right" ToolTip="Descargar Archivo">
                                <ClientSideEvents Click="function (s,e){
                                    btnReporte.DoClick();
                                }" />
                            </dx:ASPxImage>
                        </HeaderTemplate>
                        <PanelCollection>
                            <dx:PanelContent>
                                <dx:ASPxButton ID="btnReporte" runat="server" ClientInstanceName="btnReporte" ClientVisible="false"
                                    UseSubmitBehavior="False" OnClick="btnXlsxExport_Click">
                                </dx:ASPxButton>
                                <dx:ASPxGridView ID="gvErrores" runat="server" AutoGenerateColumns="true" ClientInstanceName="gvErrores"
                                    Theme="SoftOrange">
                                    <SettingsPager PageSize="20">
                                    </SettingsPager>
                                </dx:ASPxGridView>
                                <dx:ASPxGridViewExporter ID="gveErrores" runat="server" GridViewID="gvErrores">
                                </dx:ASPxGridViewExporter>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxRoundPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
            Modal="true">
        </dx:ASPxLoadingPanel>
    </form>
</body>
</html>
