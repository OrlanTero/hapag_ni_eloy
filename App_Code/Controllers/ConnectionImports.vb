Imports Microsoft.VisualBasic
Imports HapagDB

' This is a helper file to import the Connection class for all controllers
Public Module ConnectionImports
    Public Function GetConnection() As Connection
        Return New Connection()
    End Function
End Module 