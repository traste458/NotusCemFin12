<%
if session("usxp001") ="" then %>

<script language="JavaScript" type="text/jscript">
    alert("ERROR: Su Sesion ha vencido por superar el tiempo de inactividad en el Sistema. Por favor ingrese de nuevo.");
    /*if(window.name!="Top"){
    window.top.location.href= "../contenido.htm";
    }else{*/
    var arrayDatos = new Array();
    arrayDatos = document.location.toString().split("/");
    window.top.location.href = "/" + arrayDatos[3] + "/login.asp";
    //}
</script>

<%
end if
%>
