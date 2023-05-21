<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="acceso.aspx.vb" Inherits="BPColSysOP.acceso" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
      <script src="../include/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="../include/jquery.timers.js" type="text/javascript"></script>
     <script language="javascript" type="text/javascript">

         $().ready(function () {

             $(document).everyTime(3000, function () {

                 $.ajax({
                     type: "POST",
                     url: "acceso.aspx/KeepActiveSession",
                     data: {},
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     async: true,
                     success: VerifySessionState,
                     error: function (XMLHttpRequest, textStatus, errorThrown) {
                         alert(textStatus + ": " + XMLHttpRequest.responseText);
                     }
                 });

             });


         });

         var cantValidaciones = 0;

         function VerifySessionState(result) {

             if (result.d) {
                 //$("#EstadoSession").text("activo");
             }
             else
                 //$("#EstadoSession").text("expiro");

             //$("#cantValidaciones").text(cantValidaciones);
             cantValidaciones++;

         }

         function SessionAbandon() {

             $.ajax({
                 type: "POST",
                 url: "acceso.aspx/SessionAbandon",
                 data: {},
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: true,
                 error: function (XMLHttpRequest, textStatus, errorThrown) {
                     alert(textStatus + ": " + XMLHttpRequest.responseText);
                 }
             });

         }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    </div>
    </form>
</body>
</html>
