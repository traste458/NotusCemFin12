'------------------------------------------------------------------------------
' <generado automáticamente>
'     Este código fue generado por una herramienta.
'
'     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
'     se vuelve a generar el código. 
' </generado automáticamente>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On


Partial Public Class ConfirmacionServicio
    
    '''<summary>
    '''Control form1.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents form1 As Global.System.Web.UI.HtmlControls.HtmlForm
    
    '''<summary>
    '''Control cpNotificacion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpNotificacion As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control epNotificador.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents epNotificador As Global.BPColSysOP.EncabezadoPagina
    
    '''<summary>
    '''Control hfMedidasVentana.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents hfMedidasVentana As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''Control pnlGeneral.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlGeneral As Global.System.Web.UI.WebControls.Panel
    
    '''<summary>
    '''Control cpGeneral.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpGeneral As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control lblNumRadicado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblNumRadicado As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control lblEjecutor.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblEjecutor As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control lblTipoServicio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblTipoServicio As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control lblNombreCliente.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblNombreCliente As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control lblIdentificacion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblIdentificacion As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control txtDireccion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtDireccion As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control rfvDireccion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvDireccion As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control txtBarrio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtBarrio As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control rfvBarrio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvBarrio As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control lblCiudad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblCiudad As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control rbTelefonoCelular.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rbTelefonoCelular As Global.System.Web.UI.WebControls.RadioButton
    
    '''<summary>
    '''Control rbTelefonoFijo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rbTelefonoFijo As Global.System.Web.UI.WebControls.RadioButton
    
    '''<summary>
    '''Control txtTelefono.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtTelefono As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control txtExtension.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtExtension As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control rfvTelefono.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvTelefono As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control cvTelefono.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cvTelefono As Global.System.Web.UI.WebControls.CustomValidator
    
    '''<summary>
    '''Control hfMaxLength.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents hfMaxLength As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''Control txtPersonaContacto.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtPersonaContacto As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control txtObservacion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtObservacion As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control cpFiltroFecha.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpFiltroFecha As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control dpFechaAgenda.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents dpFechaAgenda As Global.EO.Web.DatePicker
    
    '''<summary>
    '''Control imgLoading.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents imgLoading As Global.System.Web.UI.WebControls.Image
    
    '''<summary>
    '''Control hfFlagFiltroFecha.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents hfFlagFiltroFecha As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''Control lblCuposDisponibles.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblCuposDisponibles As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control rfvFeChaAgendamiento.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvFeChaAgendamiento As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control cpFiltroJornada.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpFiltroJornada As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control ddlJornada.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlJornada As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''Control rfvJornada.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvJornada As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control hfFlagFiltroJornada.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents hfFlagFiltroJornada As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''Control trCorreo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents trCorreo As Global.System.Web.UI.HtmlControls.HtmlTableRow
    
    '''<summary>
    '''Control rblMedoEnvioCH.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rblMedoEnvioCH As Global.System.Web.UI.WebControls.RadioButtonList
    
    '''<summary>
    '''Control rfvrblMedoEnvioCH.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvrblMedoEnvioCH As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control txtCorreoEnvioCH.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtCorreoEnvioCH As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control rfvtxtCorreoEnvioCH.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvtxtCorreoEnvioCH As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control cvtxtCorreoEnvioCH.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cvtxtCorreoEnvioCH As Global.System.Web.UI.WebControls.CustomValidator
    
    '''<summary>
    '''Control cpConfirmar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpConfirmar As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control btnConfirmar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnConfirmar As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''Control btnAdicionarNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnAdicionarNovedad As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''Control dlgNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents dlgNovedad As Global.EO.Web.Dialog
    
    '''<summary>
    '''Control ddlTipoNovedadCall.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlTipoNovedadCall As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''Control RequiredFieldValidator1.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents RequiredFieldValidator1 As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control ddlTipoNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlTipoNovedad As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''Control rfvTipoNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvTipoNovedad As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control txtObservacionNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtObservacionNovedad As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''Control rfvObservacionNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvObservacionNovedad As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control lbRegistrar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lbRegistrar As Global.System.Web.UI.WebControls.LinkButton
    
    '''<summary>
    '''Control lbCerrarPopUp.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lbCerrarPopUp As Global.System.Web.UI.WebControls.LinkButton
    
    '''<summary>
    '''Control pnlInfoReposicion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlInfoReposicion As Global.System.Web.UI.WebControls.Panel
    
    '''<summary>
    '''Control gvListaReferencias.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvListaReferencias As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''Control cpNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpNovedad As Global.EO.Web.CallbackPanel
    
    '''<summary>
    '''Control gvNovedad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvNovedad As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''Control gvListaMsisdn.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvListaMsisdn As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''Control pnlInfoServicioTecnico.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlInfoServicioTecnico As Global.System.Web.UI.WebControls.Panel
    
    '''<summary>
    '''Control gvSerialesPrestamo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvSerialesPrestamo As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''Control gvNovedadST.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvNovedadST As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''Control ldrWait.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ldrWait As Global.BPColSysOP.Loader
End Class
