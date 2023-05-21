Imports System.Collections
Imports System.IO
Imports ICSharpCode.SharpZipLib.Zip
Imports ICSharpCode.SharpZipLib.Checksums

Namespace Compresor
    Public NotInheritable Class ZipUtil
        Private Sub New()
        End Sub

        Public Shared Function ComprimirArchivo(ByVal rutaEntrada As String, ByVal password As String, Optional ByVal comentario As String = Nothing) As Boolean
            Dim crc As New Crc32()

            Try
                Dim oZipStream As New ZipOutputStream(File.Create(Path.ChangeExtension(rutaEntrada, "zip")))

                If password IsNot Nothing AndAlso Not String.IsNullOrEmpty(password) Then
                    oZipStream.Password = password
                End If

                ' 0 - store only to 9 - means best compression
                oZipStream.SetLevel(9)

                Dim fs As FileStream = File.OpenRead(rutaEntrada)
                Dim buffer As Byte() = New Byte(fs.Length - 1) {}

                fs.Read(buffer, 0, buffer.Length)

                Dim entry As New ZipEntry(ZipEntry.CleanName(rutaEntrada))

                entry.DateTime = DateTime.Now

                If Not String.IsNullOrEmpty(comentario) Then
                    entry.Comment = comentario
                End If

                entry.ZipFileIndex = 1
                entry.Size = fs.Length
                fs.Close()
                crc.Reset()
                crc.Update(buffer)
                entry.Crc = crc.Value
                oZipStream.PutNextEntry(entry)
                oZipStream.Write(buffer, 0, buffer.Length)
                oZipStream.Finish()
                oZipStream.Close()
                Return True
            Catch ex As Exception

            End Try

            Return False
        End Function


        Public Shared Sub ComprimirCarpeta(ByVal inputFolderPath As String, ByVal outputPathAndFile As String, ByVal password As String)
            Dim ar As ArrayList = GenerarListaArchivos(inputFolderPath)
            ' generate file list
            Dim TrimLength As Integer = (Directory.GetParent(inputFolderPath)).ToString().Length
            ' find number of chars to remove     // from orginal file path
            TrimLength += 1
            'remove '\'
            Dim ostream As FileStream
            Dim obuffer As Byte()
            Dim outPath As String = inputFolderPath & "\" & outputPathAndFile
            Dim oZipStream As New ZipOutputStream(File.Create(outPath))
            ' create zip stream
            If password IsNot Nothing AndAlso password <> String.Empty Then
                oZipStream.Password = password
            End If
            oZipStream.SetLevel(9)
            ' maximum compression
            Dim oZipEntry As ZipEntry
            For Each Fil As String In ar
                ' for each file, generate a zipentry
                oZipEntry = New ZipEntry(Fil.Remove(0, TrimLength))
                oZipStream.PutNextEntry(oZipEntry)

                If Not Fil.EndsWith("/") Then
                    ' if a file ends with '/' its a directory
                    ostream = File.OpenRead(Fil)
                    obuffer = New Byte(ostream.Length - 1) {}
                    ostream.Read(obuffer, 0, obuffer.Length)
                    oZipStream.Write(obuffer, 0, obuffer.Length)
                End If
            Next
            oZipStream.Finish()
            oZipStream.Close()
        End Sub


        Private Shared Function GenerarListaArchivos(ByVal Dir As String) As ArrayList
            Dim fils As New ArrayList()
            Dim Empty As Boolean = True
            For Each file As String In Directory.GetFiles(Dir)
                ' add each file in directory
                fils.Add(file)
                Empty = False
            Next

            If Empty Then
                If Directory.GetDirectories(Dir).Length = 0 Then
                    ' if directory is completely empty, add it
                    fils.Add(Dir & "/")
                End If
            End If

            For Each dirs As String In Directory.GetDirectories(Dir)
                ' recursive
                For Each obj As Object In GenerarListaArchivos(dirs)
                    fils.Add(obj)
                Next
            Next
            Return fils
            ' return file list
        End Function


        Public Shared Sub DescomprimirCarpeta(ByVal zipPathAndFile As String, ByVal outputFolder As String, ByVal password As String, ByVal deleteZipFile As Boolean)
            Dim s As New ZipInputStream(File.OpenRead(zipPathAndFile))
            If password IsNot Nothing AndAlso password <> [String].Empty Then
                s.Password = password
            End If
            Dim theEntry As ZipEntry
            Dim tmpEntry As String = [String].Empty
            While (InlineAssignHelper(theEntry, s.GetNextEntry())) IsNot Nothing
                Dim directoryName As String = outputFolder
                Dim fileName As String = Path.GetFileName(theEntry.Name)
                ' create directory 
                If directoryName <> "" Then
                    Directory.CreateDirectory(directoryName)
                End If
                If fileName <> [String].Empty Then
                    If theEntry.Name.IndexOf(".ini") < 0 Then
                        Dim fullPath As String = (directoryName & "\") + theEntry.Name
                        fullPath = fullPath.Replace("\ ", "\")
                        Dim fullDirPath As String = Path.GetDirectoryName(fullPath)
                        If Not Directory.Exists(fullDirPath) Then
                            Directory.CreateDirectory(fullDirPath)
                        End If
                        Dim streamWriter As FileStream = File.Create(fullPath)
                        Dim size As Integer = 2048
                        Dim data As Byte() = New Byte(2047) {}
                        While True
                            size = s.Read(data, 0, data.Length)
                            If size > 0 Then
                                streamWriter.Write(data, 0, size)
                            Else
                                Exit While
                            End If
                        End While
                        streamWriter.Close()
                    End If
                End If
            End While
            s.Close()
            If deleteZipFile Then
                File.Delete(zipPathAndFile)
            End If
        End Sub
        Private Shared Function InlineAssignHelper(Of T)(ByRef target As T, ByVal value As T) As T
            target = value
            Return value
        End Function
    End Class
End Namespace

