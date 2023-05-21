<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LecturaSerialesOrden.aspx.vb"
    Inherits="BPColSysOP.LecturaSerialesOrden" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>consultarSeriales</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <link href="../include/styleBACK.css" type="text/css" rel="stylesheet">
    <script src="../include/jquery-1.js" type="text/javascript"></script>
    <script src="../include/animatedcollapse.js" type="text/javascript"></script>
    <link media="all" href="../include/widget02.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
        animatedcollapse.addDiv('imagenEjemplo', 'fade=1,height=140px')
        animatedcollapse.init()
    </script>

    <style>
        .fila
        {
            font-weight: bold;
            font-size: 16px;
        }
        .style1
        {
            width: 200px;
        }
    </style>

    <script language="javascript" type="text/javascript">
        //Expresion regular para validar la estructura del serial, que debe tener caracteres numericos.
        var expresionEstructuraSerial = /^[0-9]+$/
        function validarTeclaPresionada(evento) {
            var codigoTeclaPresionada; //Variable para almacenar el codigo de la tecla presionada
            if (window.event)  //Para el caso de IE
            {
                codigoTeclaPresionada = evento.keyCode //Almacenamos el codigo de la tecla presionada
            } else {
                if (evento.which) //Para otros navegadores diferentes al IE.
                {
                    codigoTeclaPresionada = evento.which
                }
            }
            return (codigoTeclaPresionada) //Devolvemos el codigo de la teclaPresionada
        }

        /*
        * Las validaciones que aplicamos al serial del lado del cliente son de longitud y
        * de estructura debido a que todos los caracteres del serial deben ser numericos.
        */
        function validacionesSerial(serial) {
            //Validamos que el serial no sea vacio.
            if (serial == "") {
                alert("Debe digitar el Serial, Por favor ");
                return (false);
            }


            //Validamos que todos los caracteres del serial sean numericos.
            if (!expresionEstructuraSerial.test(serial)) {
                alert("Serial contiene Caracteres  " +
		                   "no Validos, no se Registra");
                return (false);
            }

            return (true);
        }

        //Funcion para registrar el serial en el pediddo
        function registrarSerial(serial) {
            try {
                Anthem_InvokePageMethod("registrarSerial", [serial], function(result) {
                    var etiqueta = document.getElementById("lblEtiquetaBorrado").innerHTML

                    if (result.value == true) {
                        ocultar.style.display = 'block'
                        mensaje = " Registrado Exitosamente";
                        color = 'blue';

                        desplegarMensaje(mensaje, color);
                        //Mostramos el ultimo serial leido.
                        document.getElementById("ultimoleido").innerHTML = "Último Serial Leído: " + serial;
                        document.getElementById("ultimoEliminado").innerHTML = ""
                        //Actualizamos la cantidad leida.
                        //document.getElementById("lblCantidadLeida").innerHTML = parseInt(document.getElementById("lblCantidadLeida").innerHTML,10) + 1;
                    }
                    else {
                        ocultar.style.display = 'none'
                        Continuar.style.display = 'block'
                        document.getElementById("divDespliegeMensaje").innerHTML = ''
                    }
                });
            } catch (e) {
                alert(e.message);
            }
        }

        //Funcion para registrar el serial en el pediddo
        function eliminarSerial(serial) {
            if (confirm("Desea Eliminar el serial: \n" + serial)) {
                try {
                    Anthem_InvokePageMethod("eliminarSerial", [serial], function(result) {
                        var etiqueta = document.getElementById("lblEtiquetaBorrado").innerHTML
                        if (result.value > 0) {

                            mensaje = "El Serial fue Eliminado Exitosamente";
                            color = 'blue';
                            desplegarMensaje(mensaje, color);
                            //Mostramos el ultimo serial eliminado.
                            document.getElementById("ultimoEliminado").innerHTML = "Último Serial Eliminado: " + serial;
                            document.getElementById("ultimoleido").innerHTML = ""
                            //Actualizamos la cantidad leida.
                            //document.getElementById("lblCantidadLeida").innerHTML = parseInt(document.getElementById("lblCantidadLeida").innerHTML,10) - result.value;
                        } else {
                            if (result.value == 0) {
                                mensaje = "El serial:" + serial + " no Existe en la Orden "
                                color = 'red';
                                desplegarMensaje(mensaje, color);
                            }
                        }

                    });
                } catch (e) {
                    alert(e.message);

                }
            }
        }
        function limpiar(obj) {
            obj.value = ""
        }
        //Función para desplegar los mensajes de notificación de error o exito en los seriales.
        function desplegarMensaje(mensaje, color) {
            document.getElementById("divDespliegeMensaje").innerHTML = mensaje
            document.getElementById("divDespliegeMensaje").style.color = color;
            document.getElementById("divDespliegeMensaje").style.display = 'block';
        }

        function animacion(nombre) {
            if (document.getElementById('ejemploRef').innerText == '(Ver Seriales de la Orden)') {
                document.getElementById('ejemploRef').innerText = '(Ocultar Seriales de la Orden)'
            }
            else {
                document.getElementById('ejemploRef').innerText = '(Ver Seriales de la Orden)'
            }
            animatedcollapse.toggle(nombre);

        }
        function OcultarMensaje() {
            document.getElementById("divDespliegeMensaje").style.display = 'none';
        }
    </script>

</head>
<body class="cuerpo2" ms_positioning="GridLayout" onload="if(document.Form1.hddLongitud.value == 1){document.Form1.tbxSerialaLeer.focus();}">
    <form id="Form1" method="post" runat="server">
    <font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Órdenes de Lectura</b></font>
    <hr>
    <asp:HyperLink ID="hlRegresar" runat="server">Regresar</asp:HyperLink>
    <div align="center">
        <input id="hLinea" style="width: 19px; height: 22px" type="hidden" size="1" name="hLinea"
            runat="server"><anthem:Label ID="lblError" runat="server" Font-Names="Arial" AutoUpdateAfterCallBack="True"
                ForeColor="Red" Font-Bold="True"></anthem:Label>
        <anthem:Label ID="lblRes" runat="server" Font-Names="Arial" AutoUpdateAfterCallBack="True"
            ForeColor="Blue" Font-Bold="True"></anthem:Label></div>
    <div id="divDespliegeMensaje" style="display: none; font-weight: bold; font-size: 40px;
        font-family: arial" align="center">
    </div>
    <div id="ocultar">
        <table>
            <tr>
                <td>
                    <table class="tabla">
                        <tr>
                            <td colspan="2">
                                <asp:Label ID="lblTitulo" Font-Bold="True" runat="server" Font-Size="Small"></asp:Label><br>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label1" runat="server">Número de Orden:</asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblIdOrden" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label2" runat="server">Descripción Orden:</asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblOrden" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label3" runat="server">Fecha de Creación:</asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblFecha" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label4" runat="server">Nombre del CAC:</asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblCAC" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label5" runat="server"> Cantidad Pedida:</asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblCantidad" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="tdRemisiones1">
                                <asp:Label ID="Label6" runat="server"> Cantidad Leída</asp:Label>
                            </td>
                            <td>
                                <anthem:Label ID="lblCantidadLeida" AutoUpdateAfterCallBack="True" runat="server"></anthem:Label>
                            </td>
                        </tr>
                       </table>
                </td>
                <td width="100" >
                </td>
                <td valign="top">
                    <table width="100%" class="tabla">
                        <tr>
                            <td valign="top">
                                <a id="ejemploRef" name="ejemploRef" href="javascript:animacion('imagenEjemplo')"
                                    style="display: inline"><font color="#0000ff">(Ver Seriales de la Orden)</font></a>
                            </td>
                            <td>
                                <div id="imagenEjemplo" style="display: none; overflow: auto; -moz-background-clip: -moz-initial;
                                    -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial"
                                    name="imagenEjemplo" align="center">
                                    <anthem:DataGrid ID="dgSerial" runat="server" AutoUpdateAfterCallBack="True" CssClass="tabla"
                                        AutoGenerateColumns="False" UpdateAfterCallBack="True">
                                        <AlternatingItemStyle BackColor="LightYellow"></AlternatingItemStyle>
                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                        <Columns>
                                            <asp:BoundColumn DataField="Serial" HeaderText="Serial"></asp:BoundColumn>
                                        </Columns>
                                    </anthem:DataGrid></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
        <br>
        <table width="100%">
            <tr>
                <td colspan="2">
                    <hr />
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="lblEtiquetaLectura" ForeColor="RoyalBlue" Font-Bold="True" runat="server"
                        Text="Serial" Font-Size="16px">Leer Serial</asp:Label>
                </td>
                <td>
                    <input onkeypress="if (validarTeclaPresionada(event) == 13) {if(validacionesSerial(this.value)){ registrarSerial(this.value);limpiar(this) }}"
                        id="tbxSerialaLeer" type="text" maxlength="18" name="tbxSerialaLeer" runat="server">
                    &nbsp;<span id="ultimoleido" style="font-weight: bold; font-size: 14px; color: red"
                        runat="server"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <hr>
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="lblEtiquetaBorrado" ForeColor="RoyalBlue" Font-Bold="True" runat="server"
                        Text="Serial" Font-Size="16px">Borrar Serial</asp:Label>
                </td>
                <td>
                    <input onkeypress="if (validarTeclaPresionada(event) == 13) {if(validacionesSerial(this.value)){eliminarSerial(this.value);limpiar(this)}}"
                        id="tbxSerialaBorrar" type="text" maxlength="18" name="tbxSerialaBorrar" runat="server">
                    &nbsp;<span id="ultimoEliminado" style="font-weight: bold; font-size: 14px; color: red"
                        runat="server"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                        <br>
                        <anthem:LinkButton ID="lbCerrar" AutoUpdateAfterCallBack="True" ForeColor="#0000C0"
                            runat="server" BorderStyle="Outset" CssClass="botonWB" Visible="False" PreCallBackFunction="OcultarMensaje()"><img src='../images/edit.gif' border="0" />Cerrar Orden</anthem:LinkButton></div>
                    <input id="hddLongitud" type="hidden" name="hddLongitud" runat="server">
                </td>
            </tr>
        </table>
    </div>
    <div id="Continuar" style="display: none" align="center">
        <a onclick="ocultar.style.display='block'; Continuar.style.display='none';Anthem_InvokePageMethod('refrescar',0);document.getElementById('divDespliegeMensaje').innerHTML = '';&#13;&#10;&#9;&#9;&#9;divDespliegeMensaje.style.display= 'none';&#13;&#10;&#9;&#9;&#9;tbxSerialaLeer.focus();"
            href="javascript:void(0);"><font color="blue" size="2"><b>Continuar Leyendo</b></font></a></div>
    </form>
</body>
</html>
