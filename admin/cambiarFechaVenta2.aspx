<%@ Page Language="vb" AutoEventWireup="false" Codebehind="cambiarFechaVenta2.aspx.vb" Inherits="BPColSysOP.cambiarFechaVenta2" culture="es-CO" uiCulture="es-CO" %>
<%@ Register TagPrefix="ew" Namespace="eWorld.UI" Assembly="eWorld.UI, Version=1.9.0.0, Culture=neutral, PublicKeyToken=24d65337282035f2" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>cambiarFechaVenta2</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="style.css" type="text/css" rel="stylesheet">
		<script language="javascript" type="text/javascript">
		  function validacion(){
		    
		    if(document.getElementById("cpFechaNueva").value==""){
		      document.getElementById("divImagen").style.display="none";
		      alert("Escoja la Fecha por la cual desea reemplazar la Fecha Actual, Por Favor");
		      document.getElementById("cpFechaNueva").focus();
		      return(false);
		    }
		  
		    document.getElementById("divImagen").style.display="none";
		    if(!confirm("Realmente desea Cambiar la Fecha?")){
		      return(false);
		    }
		    document.getElementById("divImagen").style.display="block";
		  }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambiar Fecha de 
				Venta</b></font>
		<hr>
		<form id="Form1" onsubmit="return validacion();" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" NavigateUrl="cambiarFechaVenta.aspx" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<TR>
					<TD>
						<DIV id="divImagen" style="DISPLAY: none"><IMG src="images/loader.gif"><font face="arial" size="2"><b>
									Cambiando Fecha...</b></font><br>
							<br>
						</DIV>
					</TD>
				</TR>
				<tr>
					<td align="center"><asp:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red"></asp:label><asp:label id="lblRes" runat="server" Font-Bold="True" ForeColor="Blue"></asp:label></td>
				</tr>
			</table>
			<table class="tabla">
				<tr>
					<td class="celdaTitulo">Factura No.:</td>
					<td class="celdaNormal" width="200"><asp:label id="lblFactura" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo">Identificación Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIdentificacion" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Nombres Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblNombre" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Apellidos Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblApellidos" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">IMEI:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblImei" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">ICCID (Sim):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIccid" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">MSISDN:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblMin" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Fecha (Usuario):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblFecha" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo">Fecha Nueva:</TD>
					<TD class="celdaNormal" width="200"><ew:calendarpopup id="cpFechaNueva" runat="server" Width="80px" NullableLabelText="Seleccione una Fecha"
							GoToTodayText="Fecha Actual:" ClearDateText="Limpiar Fecha" CellPadding="2px" ImageUrl="images/calbtn.gif" CellSpacing="0px" ToolTip="Seleccione la Nueva Fecha"
							Nullable="True" UpperBoundDate="2007-01-11">
							<WeekdayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></WeekdayStyle>
							<MonthHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" Font-Bold="True" ForeColor="White" BackColor="Navy"></MonthHeaderStyle>
							<OffMonthStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Gray"
								BackColor="AntiqueWhite"></OffMonthStyle>
							<ButtonStyle ForeColor="White" BackColor="Navy"></ButtonStyle>
							<GoToTodayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></GoToTodayStyle>
							<TodayDayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="LightGoldenrodYellow"></TodayDayStyle>
							<DayHeaderStyle Font-Size="XX-Small" Font-Names="Verdana" BackColor="LightSteelBlue"></DayHeaderStyle>
							<WeekendStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="LightGray"></WeekendStyle>
							<SelectedDateStyle ForeColor="Black" BackColor="Yellow"></SelectedDateStyle>
							<ClearDateStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></ClearDateStyle>
							<HolidayStyle Font-Size="XX-Small" Font-Names="Verdana,Helvetica,Tahoma,Arial" ForeColor="Black"
								BackColor="White"></HolidayStyle>
						</ew:calendarpopup></TD>
				</TR>
				<TR>
					<TD colSpan="2"><FONT face="arial" color="blue" size="2">*</FONT> <FONT size="1">Campo 
							Obligatorio</FONT>
						<BR>
					</TD>
				</TR>
				<tr>
					<td colSpan="2"><br>
						<br>
						<asp:button id="btnContinuar" runat="server" Text="Cambiar" CssClass="boton"></asp:button><INPUT id="hTransaccion" style="WIDTH: 16px; HEIGHT: 22px" type="hidden" size="1" name="hTransaccion"
							runat="server"></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
