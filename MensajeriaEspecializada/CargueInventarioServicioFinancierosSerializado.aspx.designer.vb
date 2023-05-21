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


Partial Public Class CargueInventarioServicioFinancierosSerializado
    
    '''<summary>
    '''Control formPrincipal.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents formPrincipal As Global.System.Web.UI.HtmlControls.HtmlForm
    
    '''<summary>
    '''Control miEncabezado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents miEncabezado As Global.BPColSysOP.EncabezadoPagina
    
    '''<summary>
    '''Control cpGeneral.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cpGeneral As Global.DevExpress.Web.ASPxCallbackPanel
    
    '''<summary>
    '''Control callback.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents callback As Global.DevExpress.Web.ASPxCallback
    
    '''<summary>
    '''Control pcConsulta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pcConsulta As Global.DevExpress.Web.ASPxPageControl
    
    '''<summary>
    '''Control ContentControl1.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ContentControl1 As Global.DevExpress.Web.ContentControl
    
    '''<summary>
    '''Control rpAdministradorInventario.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpAdministradorInventario As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control txtCedulaCliente.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtCedulaCliente As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control cmbBodega.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbBodega As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control cmbMaterialSerial.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbMaterialSerial As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control txtSerial.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtSerial As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control btnGuardar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnGuardar As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control btnLimpiar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnLimpiar As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control ContentControl2.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ContentControl2 As Global.DevExpress.Web.ContentControl
    
    '''<summary>
    '''Control rpAdminInventarioMasivo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpAdminInventarioMasivo As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control fuArchivo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents fuArchivo As Global.System.Web.UI.WebControls.FileUpload
    
    '''<summary>
    '''Control lblObligatorio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblObligatorio As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''Control revArchivo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revArchivo As Global.System.Web.UI.WebControls.RegularExpressionValidator
    
    '''<summary>
    '''Control rfvArchivo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvArchivo As Global.System.Web.UI.WebControls.RequiredFieldValidator
    
    '''<summary>
    '''Control lbVerArchivo.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lbVerArchivo As Global.System.Web.UI.WebControls.LinkButton
    
    '''<summary>
    '''Control btnUpload.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnUpload As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control pcErrores.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pcErrores As Global.DevExpress.Web.ASPxPopupControl
    
    '''<summary>
    '''Control pccError.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pccError As Global.DevExpress.Web.PopupControlContentControl
    
    '''<summary>
    '''Control cbFormatoExportar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cbFormatoExportar As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control gvErrores.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvErrores As Global.DevExpress.Web.ASPxGridView
    
    '''<summary>
    '''Control gveErrores.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gveErrores As Global.DevExpress.Web.ASPxGridViewExporter
    
    '''<summary>
    '''Control rpAdministrador.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpAdministrador As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control cmbBodegasFinancieros.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbBodegasFinancieros As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control cmbMaterialTipoServicio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbMaterialTipoServicio As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control txtSerialTiposervicio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtSerialTiposervicio As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control btnGuardars.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnGuardars As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control btnLimpiars.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnLimpiars As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control LoadingPanel.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents LoadingPanel As Global.DevExpress.Web.ASPxLoadingPanel
End Class
