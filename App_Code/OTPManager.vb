Imports System.Web

''' <summary>
''' Utility class for managing OTP verification using session storage
''' </summary>
Public Class OTPManager
    ' Session keys
    Private Const OTP_KEY As String = "UserOTP"
    Private Const OTP_EMAIL_KEY As String = "UserOTPEmail"
    Private Const OTP_EXPIRY_KEY As String = "UserOTPExpiry"
    Private Const OTP_ATTEMPTS_KEY As String = "UserOTPAttempts"
    Private Const USER_DATA_KEY As String = "UserRegistrationData"
    
    ' Configuration
    Private Const OTP_EXPIRY_MINUTES As Integer = 15
    Private Const MAX_OTP_ATTEMPTS As Integer = 3
    
    ''' <summary>
    ''' Generates and sends a new OTP to the specified email
    ''' </summary>
    ''' <param name="email">Email address to send OTP to</param>
    ''' <returns>Boolean indicating success or failure</returns>
    Public Shared Function GenerateAndSendOTP(ByVal email As String) As Boolean
        Try
            ' Generate a new OTP
            Dim otp As String = EmailSender.GenerateOTP()
            
            ' Store OTP in session with expiry time
            HttpContext.Current.Session(OTP_KEY) = otp
            HttpContext.Current.Session(OTP_EMAIL_KEY) = email
            HttpContext.Current.Session(OTP_EXPIRY_KEY) = DateTime.Now.AddMinutes(OTP_EXPIRY_MINUTES)
            HttpContext.Current.Session(OTP_ATTEMPTS_KEY) = 0
            
            ' Send OTP email
            Return EmailSender.SendOTPEmail(email, otp)
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("OTP generation error: " & ex.Message)
            Return False
        End Try
    End Function
    
    ''' <summary>
    ''' Verifies if the provided OTP matches the stored OTP
    ''' </summary>
    ''' <param name="otp">OTP to verify</param>
    ''' <returns>Boolean indicating if OTP is valid</returns>
    Public Shared Function VerifyOTP(ByVal otp As String) As Boolean
        Try
            ' Check if OTP session variables exist
            If HttpContext.Current.Session(OTP_KEY) Is Nothing OrElse 
               HttpContext.Current.Session(OTP_EXPIRY_KEY) Is Nothing Then
                Return False
            End If
            
            ' Get stored OTP and expiry time
            Dim storedOTP As String = HttpContext.Current.Session(OTP_KEY).ToString()
            Dim expiryTime As DateTime = CType(HttpContext.Current.Session(OTP_EXPIRY_KEY), DateTime)
            Dim attempts As Integer = CType(HttpContext.Current.Session(OTP_ATTEMPTS_KEY), Integer)
            
            ' Increment attempts
            HttpContext.Current.Session(OTP_ATTEMPTS_KEY) = attempts + 1
            
            ' Check if OTP is expired
            If DateTime.Now > expiryTime Then
                ClearOTPData()
                Return False
            End If
            
            ' Check if max attempts exceeded
            If attempts >= MAX_OTP_ATTEMPTS Then
                ClearOTPData()
                Return False
            End If
            
            ' Check if OTP matches
            If storedOTP = otp Then
                Return True
            End If
            
            Return False
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("OTP verification error: " & ex.Message)
            Return False
        End Try
    End Function
    
    ''' <summary>
    ''' Clears OTP data from session
    ''' </summary>
    Public Shared Sub ClearOTPData()
        HttpContext.Current.Session.Remove(OTP_KEY)
        HttpContext.Current.Session.Remove(OTP_EMAIL_KEY)
        HttpContext.Current.Session.Remove(OTP_EXPIRY_KEY)
        HttpContext.Current.Session.Remove(OTP_ATTEMPTS_KEY)
    End Sub
    
    ''' <summary>
    ''' Gets the email associated with the current OTP
    ''' </summary>
    ''' <returns>Email address or empty string if not found</returns>
    Public Shared Function GetOTPEmail() As String
        If HttpContext.Current.Session(OTP_EMAIL_KEY) IsNot Nothing Then
            Return HttpContext.Current.Session(OTP_EMAIL_KEY).ToString()
        End If
        Return String.Empty
    End Function
    
    ''' <summary>
    ''' Stores user registration data in session for later use
    ''' </summary>
    ''' <param name="userData">Dictionary containing user registration data</param>
    Public Shared Sub StoreUserData(ByVal userData As Dictionary(Of String, String))
        HttpContext.Current.Session(USER_DATA_KEY) = userData
    End Sub
    
    ''' <summary>
    ''' Retrieves stored user registration data from session
    ''' </summary>
    ''' <returns>Dictionary containing user data or null if not found</returns>
    Public Shared Function GetUserData() As Dictionary(Of String, String)
        If HttpContext.Current.Session(USER_DATA_KEY) IsNot Nothing Then
            Return CType(HttpContext.Current.Session(USER_DATA_KEY), Dictionary(Of String, String))
        End If
        Return Nothing
    End Function
    
    ''' <summary>
    ''' Clears user registration data from session
    ''' </summary>
    Public Shared Sub ClearUserData()
        HttpContext.Current.Session.Remove(USER_DATA_KEY)
    End Sub
    
    ''' <summary>
    ''' Gets remaining OTP validation attempts
    ''' </summary>
    ''' <returns>Number of remaining attempts</returns>
    Public Shared Function GetRemainingAttempts() As Integer
        If HttpContext.Current.Session(OTP_ATTEMPTS_KEY) IsNot Nothing Then
            Dim attempts As Integer = CType(HttpContext.Current.Session(OTP_ATTEMPTS_KEY), Integer)
            Return Math.Max(0, MAX_OTP_ATTEMPTS - attempts)
        End If
        Return 0
    End Function
    
    ''' <summary>
    ''' Gets the OTP expiry time
    ''' </summary>
    ''' <returns>DateTime of OTP expiry or DateTime.MinValue if not found</returns>
    Public Shared Function GetOTPExpiry() As DateTime
        If HttpContext.Current.Session(OTP_EXPIRY_KEY) IsNot Nothing Then
            Return CType(HttpContext.Current.Session(OTP_EXPIRY_KEY), DateTime)
        End If
        Return DateTime.MinValue
    End Function
    
    ''' <summary>
    ''' Checks if OTP has expired
    ''' </summary>
    ''' <returns>Boolean indicating if OTP has expired</returns>
    Public Shared Function IsOTPExpired() As Boolean
        Dim expiryTime As DateTime = GetOTPExpiry()
        If expiryTime = DateTime.MinValue Then
            Return True
        End If
        Return DateTime.Now > expiryTime
    End Function
    
    ''' <summary>
    ''' Gets remaining time in seconds before OTP expires
    ''' </summary>
    ''' <returns>Seconds remaining or 0 if expired</returns>
    Public Shared Function GetRemainingTimeInSeconds() As Integer
        Dim expiryTime As DateTime = GetOTPExpiry()
        If expiryTime = DateTime.MinValue Then
            Return 0
        End If
        
        Dim remainingTime As TimeSpan = expiryTime - DateTime.Now
        If remainingTime.TotalSeconds <= 0 Then
            Return 0
        End If
        
        Return CInt(remainingTime.TotalSeconds)
    End Function
End Class 