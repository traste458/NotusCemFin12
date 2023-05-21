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


Partial Public Class ConsultaServiciosSiembra

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
    '''Control rpFiltros.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpFiltros As Global.DevExpress.Web.ASPxRoundPanel

    '''<summary>
    '''Control txtidServicio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtidServicio As Global.DevExpress.Web.ASPxMemo

    '''<summary>
    '''Control cmbEstado.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbEstado As Global.DevExpress.Web.ASPxComboBox

    '''<summary>
    '''Control dateFechaInicio.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents dateFechaInicio As Global.DevExpress.Web.ASPxDateEdit

    '''<summary>
    '''Control dateFechaFin.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents dateFechaFin As Global.DevExpress.Web.ASPxDateEdit

    '''<summary>
    '''Control cmbGerencia.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbGerencia As Global.DevExpress.Web.ASPxComboBox

    '''<summary>
    '''Control cmbCoordinador.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbCoordinador As Global.DevExpress.Web.ASPxComboBox

    '''<summary>
    '''Control cmbConsultor.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cmbConsultor As Global.DevExpress.Web.ASPxComboBox

    '''<summary>
    '''Control btnFiltrar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnFiltrar As Global.DevExpress.Web.ASPxButton

    '''<summary>
    '''Control btnQuitarFiltro.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnQuitarFiltro As Global.DevExpress.Web.ASPxButton

    '''<summary>
    '''Control cbFormatoExportar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents cbFormatoExportar As Global.DevExpress.Web.ASPxComboBox

    '''<summary>
    '''Control rpResultadoServicios.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rpResultadoServicios As Global.DevExpress.Web.ASPxRoundPanel

    '''<summary>
    '''Control gvServicios.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvServicios As Global.DevExpress.Web.ASPxGridView

    '''<summary>
    '''Control gveServicios.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gveServicios As Global.DevExpress.Web.ASPxGridViewExporter

    '''<summary>
    '''Control pcVerDetalle.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pcVerDetalle As Global.DevExpress.Web.ASPxPopupControl

    '''<summary>
    '''Control gvMateriales.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvMateriales As Global.DevExpress.Web.ASPxGridView

    '''<summary>
    '''Control pcProgramarRecoleccion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pcProgramarRecoleccion As Global.DevExpress.Web.ASPxPopupControl

    '''<summary>
    '''Control gvSeriales.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvSeriales As Global.DevExpress.Web.ASPxGridView

    '''<summary>
    '''Control btnCrearRecolecion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnCrearRecolecion As Global.DevExpress.Web.ASPxButton
End Class
