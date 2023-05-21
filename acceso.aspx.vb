Imports EO.Web
Imports System.Web.Services

Partial Public Class acceso
    Inherits System.Web.UI.Page

    Private idUsuario As String
    Private tercero As String
    Private cliente As String
    Private cargo As String
    Private ciudad As String
    Private idCargo As String
    Private idCiudad As String
    Private idCliente As String
    Private idPerfil As String
    Private linea As String
    Private idBodega As String
    Private nombre As String = ""
    Private url As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EO.Web.Runtime.AddLicense( _
          "jvPMiLnN3fCtfMbRs8uud4SOscufWZekscu7mtvosR/4qdzBs/7rotvp3hDt" + _
          "rpmkBxDxrODz/+ihcqW0s8vnqOr4zs3LiL7d5fDCgcTT0/TLfqXH4PihWabC" + _
          "nrWfWZekscufWbPl9Q+frfD09uihjdjm5B/xouemsSHkq+rtABm8W7Cywc2f" + _
          "oeb3BeihhcbL6v/EfL/R4O3Ihbyy1PrMW5ezz7iJWZekscufWZfA8g/jWev9" + _
          "ARC8W8v29hDVotz7s8v1nun3+hrtdpm9v9uhWd/zBB+8W8PT2ATTfrrM3vrB" + _
          "gsPJv+7OhpmkwOmMQ5ekscufWZekzQzjnZf4ChvkdpnRBhfzosfl+BChWe3p" + _
          "Ax7oqOXBs+StaZmk+RryrbSm3frGksvJ1PPMiLnN3fCtfMbRs8uud4SOscuf" + _
          "WZekscu7mtvosR/4qdzBs+7gpdzy9QzxW5f69h3youbyzs24Z6emsRPurOvB" + _
          "s/fOgNDY1u7HhsbG2vfEZ7rT3s2faLWRm8ufWZekscufddjo9cvzsufpzs3C" + _
          "muPw8wzipJmkBxDxrODz/+ihcqW0s8vnqOr4zs3LiL7d5fDCgcTT0/TLfqXH" + _
          "4PihWabCnrWfWZekscufWbPl9Q+frfD09uihesHF6QDvpebl9RDxW5f69h3y" + _
          "oubyzs24Z6emsRPurOvBs/fOgNDY1u7HhsbG2vfEZ7rT3s2faLWRm8ufWZek" + _
          "scufddjo9cvzsufpzs3DotjwABKhWe3pAx7oqOXBs+StaZmk+RryrbSm3frG" + _
          "ksvJ1PPMiLnN3fCtfMbRs8uud4SOscufWZekscu7mtvosR/4qdzBs/7vpeD4" + _
          "BRDxW5f69h3youbyzs24Z6emsRPurOvBs/fOgNDY1u7HhsbG2vfEZ7rT3s2f" + _
          "aLWRm8ufWZekscufddjo9cvzsufpzs3Mmurv9g/EneD4s8v1nun3+hrtdpm9" + _
          "v9uhWd/zBB+8W8PT2ATTfrrM3vrBgsPJv+7OhpmkwOmMQ5ekscufWZekzQzj" + _
          "nZf4ChvkdpnLAxTjW5f69h3youbyzs24Z6emsRPurOvBs/fOgNDY1u7HhsbG" + _
          "2vfEZ7rT3s2faLWRm8ufWZekscufddjo9cvzsufpzs3CqOPzA/vonOLpA82f" + _
          "r9z2BBTup7SmytmvW5fsAB7zdpnQ4PLYjbzH2fjOe8DQ1tnCiMSmsdq9RoGk" + _
          "scufWZeksefgndukBSTvnrSm5BvkpePH+RDipNz2s8v1nun3+hrtdpm9v9uh" + _
          "Wd/zBB+8W8PT2ATTfrrM3vrBgsPJv+7OhpmkwOmMQ5ekscufWZekzQzjnZf4" + _
          "ChvkdpnJ9RTzqOmmsSHkq+rtABm8W7Cywc2foeb3BeihhcbL6v/EfL/R4O3I" + _
          "hbyy1PrMW5ezz7iJWZekscufWZfA8g/jWev9ARC8W8Dx8hLkk+bz/s2fr9z2" + _
          "BBTup7SmytmvW5fsAB7zdpnQ4PLYjbzH2fjOe8DQ1tnCiMSmsdq9RoGkscuf" + _
          "WZeksefgndukBSTvnrSm1Rr2p+Pz8g/kq5mkBxDxrODz/+ihcqW0s8vnqOr4" + _
          "zs3LiL7d5fDCgcTT0/TLfqXH4PihWabCnrWfWZekscufWbPl9Q+frfD09uih" + _
          "f+Pz8h/kq5mkBxDxrODz/+ihcqW0s8vnqOr4zs3LiL7d5fDCgcTT0/TLfqXH" + _
          "4PihWabCnrWfWZekscufWbPl9Q+frfD09uihjOPt9RChWe3pAx7oqOXBs+St" + _
          "aZmk+RryrbSm3frGksvJ1PPMiLnN3fCtfMbRs8uud4SOscufWZekscu7mtvo" + _
          "sR/4qdzBs/Hrsub5Bc2fr9z2BBTup7SmytmvW5fsAB7zdpnQ4PLYjbzH2fjO" + _
          "e8DQ1tnCiMSmsdq9RoGkscufWZeksefgndukBSTvnrSm1g/ordjm/RDLmtnp" + _
          "/c2fr9z2BBTup7SmytmvW5fsAB7zdpnQ4PLYjbzH2fjOe8DQ1tnCiMSmsdq9" + _
          "RoGkscufdabl/RfusLWRm8ufWZfAAB3jnunN/xHuWdvlBRC8W6mzwtqxaai1" + _
          "s8v1nun3+hrtdpm8s8uud4SOscufWbP3+hLtmuv5AxC9gN242hvSr9zd+xrW" + _
          "mrzK2fbPa7/w0ui8dab3+hLtmuv5AxC9RoHAwBfonNzyBBC9RoF14+30EO2s" + _
          "3MKetZ9Zl6TNF+ic3PIEEMidtbfF3rFuqLbI4bN1pvD6DuSn6unaD71GgaSx" + _
          "y5914+30EO2s3OnP566l4Of2GfKe3MKetZ9Zl6TNDOul5vvPuIlZl6Sxy59Z" + _
          "l8DyD+NZ6/0BELxbxOn/IKFZ7ekDHuio5cGz5K1pmaT5GvKttKbd+saSy8nU")

        Session.Timeout = 20
        Session.RemoveAll()
        Session("datos") = True
        idUsuario = Request.QueryString("idusuario")
        tercero = Request.QueryString("tercero")
        cliente = Request.QueryString("cliente")
        cargo = Request.QueryString("cargo")
        ciudad = Request.QueryString("ciudad")
        idCargo = Request.QueryString("idcargo")
        idCiudad = Request.QueryString("idciudad")
        idCliente = Request.QueryString("idcliente")
        idPerfil = Request.QueryString("idperfil")
        linea = Request.QueryString("linea")
        idBodega = Request.QueryString("idbodega")

        Session.Add("usxp001", idUsuario)
        Session.Add("usxp002", tercero)
        Session.Add("usxp003", cliente)
        Session.Add("usxp004", cargo)
        Session.Add("usxp005", ciudad)
        Session.Add("usxp006", idCargo)
        Session.Add("usxp007", idCiudad)
        Session.Add("usxp008", idCliente)
        Session.Add("usxp009", idPerfil)
        Session.Add("usxp010", linea)
        Session.Add("usxp012", idBodega)
        Session.Add("usxp013", idPerfil)

        Select Case CInt(Session("usxp009"))
            Case 7, 10
                nombre = "Devoluciones"
                url = "devoluciones/frames.htm"
            Case 8
                nombre = "Administrador Inventarios"
                url = "inventarios/frames.htm"
            Case 9
                nombre = "Inventarios"
                url = "inventarios/frames_user.htm"
            Case 12
                nombre = "Bodega"
                url = "bodega/frames.htm"
            Case 4, 5, 6, Is > 12
                nombre = "Usuario NotusILS"
                url = "frames.asp"
            Case Else
                Response.Redirect(ConfigurationManager.AppSettings("SITIOBASE") & "contenido.htm")
        End Select
        Session.Add("usxp011", nombre)
        Response.Redirect(url)
    End Sub
    <WebMethod()> _
    Public Shared Function KeepActiveSession() As Boolean

        If HttpContext.Current.Session("datos") IsNot Nothing Then
            Return True
        Else
            Return False
        End If

    End Function
End Class