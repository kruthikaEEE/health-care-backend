# PowerShell script to test patient registration

$testPatient = @{
    firstName = "Jane"
    lastName = "Smith"
    email = "jane.smith@test.com"
    password = "SecurePass123!"
    dateOfBirth = "1992-08-20"
    gender = "female"
    phone = "+1987654321"
    address = @{
        street = "456 Oak Avenue"
        city = "Los Angeles"
        state = "CA"
        zipCode = "90001"
        country = "USA"
    }
} | ConvertTo-Json -Depth 10

Write-Host "🧪 Testing Patient Registration..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Test Data:" -ForegroundColor Yellow
Write-Host $testPatient
Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Gray
Write-Host ""

try {
    Write-Host "📝 Registering new patient..." -ForegroundColor Yellow
    
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/register/patient" `
        -Method POST `
        -Body $testPatient `
        -ContentType "application/json" `
        -UseBasicParsing
    
    Write-Host "✅ Registration Successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host ""
    
    $responseData = $response.Content | ConvertFrom-Json
    
    if ($responseData.success) {
        Write-Host ("=" * 60) -ForegroundColor Green
        Write-Host "✅ USER SUCCESSFULLY ADDED TO MONGODB ATLAS!" -ForegroundColor Green
        Write-Host ("=" * 60) -ForegroundColor Green
        Write-Host ""
        Write-Host "User Details:" -ForegroundColor Cyan
        Write-Host "- ID: $($responseData.user.id)" -ForegroundColor White
        Write-Host "- Name: $($responseData.user.firstName) $($responseData.user.lastName)" -ForegroundColor White
        Write-Host "- Email: $($responseData.user.email)" -ForegroundColor White
        Write-Host "- Phone: $($responseData.user.phone)" -ForegroundColor White
        Write-Host "- Date of Birth: $($responseData.user.dateOfBirth)" -ForegroundColor White
        Write-Host "- Gender: $($responseData.user.gender)" -ForegroundColor White
        Write-Host ""
        Write-Host "🔑 JWT Token Generated: $($responseData.token.Substring(0, 50))..." -ForegroundColor Yellow
    }
    
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    
    if ($statusCode) {
        Write-Host "❌ Registration Failed!" -ForegroundColor Red
        Write-Host "Status Code: $statusCode" -ForegroundColor Red
        
        try {
            $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "Error: $($errorResponse.error)" -ForegroundColor Red
            
            if ($errorResponse.error -like "*already exists*") {
                Write-Host ""
                Write-Host "💡 Note: This email is already registered. The user exists in MongoDB Atlas!" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Cannot connect to server" -ForegroundColor Red
        Write-Host "Make sure the server is running on http://localhost:8080" -ForegroundColor Yellow
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
