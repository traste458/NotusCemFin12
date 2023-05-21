<%@ Register NameSpace="Anthem" Assembly="Anthem" TagPrefix="Anthem"%>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="cambiodeFecha.aspx.vb" Inherits="BPColSysOP.cambiodeFecha" %>
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
		    if(document.getElementById('cpFechaNueva').value!="")
		    { if(confirm("¿ Desea cambiar la Fecha (Usuario): "+ document.getElementById('lblFecha').innerHTML +" por la fecha : "+ document.getElementById('cpFechaNueva').value +" ?"))
		      { document.getElementById('Guardar').value=1
		      }else{
		       document.getElementById('Guardar').value=0
		      }
		    }else
		     { alert("Error: Seleccione una fecha, para el realizar el cambio")
		       document.getElementById('Guardar').value=0
		     }
		   }
		</script>
	</HEAD>
	<body class="cuerpo">
		<font face="Arial, Helvetica, sans-serif" color="black" size="4"><b>Cambiar Fecha de 
				Venta</b></font>
		<hr>
		<form id="Form1" method="post" runat="server">
			<table class="tabla" width="90%">
				<tr>
					<td><asp:hyperlink id="hlRegresar" runat="server" Font-Bold="True">Regresar</asp:hyperlink><br>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center"><anthem:label id="lblError" runat="server" Font-Bold="True" ForeColor="Red" AutoUpdateAfterCallBack="True"></anthem:label><anthem:label id="lblExito" runat="server" Font-Bold="True" ForeColor="Blue" AutoUpdateAfterCallBack="True"></anthem:label></td>
				</tr>
			</table>
			<br>
			<br>
			<table class="tabla" style="WIDTH: 376px; HEIGHT: 53px">
				<tr>
					<td class="celdaTitulo" style="WIDTH: 215px">Factura No.:</td>
					<td class="celdaNormal" width="200"><asp:label id="lblFactura" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Identificación Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIdentificacion" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Nombres Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblNombre" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Apellidos Cliente:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblApellidos" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">IMEI:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblImei" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">ICCID (Sim):</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblIccid" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">MSISDN:</TD>
					<TD class="celdaNormal" width="200"><asp:label id="lblMin" runat="server"></asp:label></TD>
				</TR>
				<tr>
					<td class="celdaTitulo" style="WIDTH: 215px">
						<div>Plan:</div>
					</td>
					<td class="celdaNormal" width="200"><asp:label id="lblPlan" runat="server"></asp:label></td>
				</tr>
				<TR>
					<TD class="celdaTitulo" style="WIDTH: 215px">Fecha (Usuario):</TD>
					<TD class="celdaNormal" width="200"><anthem:label id="lblFecha" runat="server" AutoUpdateAfterCallBack="True"></anthem:label></TD>
				</TR>
				<tr>
					<td class="celdaTitulo" style="WIDTH: 215px">
						<div>Nueva Fecha:</div>
					</td>
					<td>
						<ew:calendarpopup id="cpFechaNueva" runat="server" Width="154px" UpperBoundDate="2020-12-12" Nullable="True"
							ToolTip="Seleccione la Nueva Fecha" CellSpacing="0px" ImageUrl="images/calbtn.gif" CellPadding="2px"
							ClearDateText="Limpiar Fecha" GoToTodayText="Fecha Actual:" NullableLabelText="Seleccione una Fecha">
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
						</ew:calendarpopup>
					</td>
				</tr>
			</table>
			<input type="hidden" id="Guardar" runat="server" style="WIDTH: 16px; HEIGHT: 22px" size="1"
				NAME="Guardar">
			<br>
			<br>
			<anthem:Button ID="continuar" Runat="server" CssClass="boton" Text="Cambiar Fecha" AutoUpdateAfterCallBack="True"></anthem:Button>
		</form>
	</body>
</HTML>
