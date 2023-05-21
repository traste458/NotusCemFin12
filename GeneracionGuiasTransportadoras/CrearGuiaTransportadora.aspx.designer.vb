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


Partial Public Class CrearGuiaTransportadora
    
    '''<summary>
    '''Control form1.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents form1 As Global.System.Web.UI.HtmlControls.HtmlForm
    
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
    '''Control rpInfoAgente.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpInfoAgente As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control cmbTipoAsignacion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbTipoAsignacion As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control lblBodegaOrigen.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblBodegaOrigen As Global.DevExpress.Web.ASPxLabel
    
    '''<summary>
    '''Control cmbBodegaOrigen.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbBodegaOrigen As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control lblTipoBodegaDestino.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblTipoBodegaDestino As Global.DevExpress.Web.ASPxLabel
    
    '''<summary>
    '''Control cmbTipoBodegaDestino.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbTipoBodegaDestino As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control lblBodegaDestino.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblBodegaDestino As Global.DevExpress.Web.ASPxLabel
    
    '''<summary>
    '''Control cmbBodegaDestino.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbBodegaDestino As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control cmbTransportadora.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbTransportadora As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control cmbRangoGuias.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbRangoGuias As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control txtRadicado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtRadicado As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control btnAgregarRadicado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnAgregarRadicado As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control btnLimpiar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnLimpiar As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control rpRadicados.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpRadicados As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control gvDatos.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvDatos As Global.DevExpress.Web.ASPxGridView
    
    '''<summary>
    '''Control rpGenerar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpGenerar As Global.DevExpress.Web.ASPxRoundPanel
    
    '''<summary>
    '''Control txtpopValorDeclarado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtpopValorDeclarado As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control txtpopContenido.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtpopContenido As Global.DevExpress.Web.ASPxMemo
    
    '''<summary>
    '''Control txtCantidad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtCantidad As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control txtPeso.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtPeso As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control txtVolumen.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtVolumen As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control lblnumBolsaSeguridad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblnumBolsaSeguridad As Global.DevExpress.Web.ASPxLabel
    
    '''<summary>
    '''Control txtnumBolsaSeguridad.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtnumBolsaSeguridad As Global.DevExpress.Web.ASPxTextBox
    
    '''<summary>
    '''Control lblMedioTransporte.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblMedioTransporte As Global.DevExpress.Web.ASPxLabel
    
    '''<summary>
    '''Control ddlMedioTransporte.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlMedioTransporte As Global.DevExpress.Web.ASPxComboBox
    
    '''<summary>
    '''Control btnGenerarGuia.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnGenerarGuia As Global.DevExpress.Web.ASPxButton
    
    '''<summary>
    '''Control LoadingPanel.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents LoadingPanel As Global.DevExpress.Web.ASPxLoadingPanel
End Class
