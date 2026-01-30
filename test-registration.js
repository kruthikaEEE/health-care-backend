// Test script to register a patient and verify MongoDB Atlas connection
const axios = require('axios');

const API_URL = 'http://localhost:8080/api';

// Test patient data
const testPatient = {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@test.com',
    password: 'SecurePass123!',
    dateOfBirth: '1990-05-15',
    gender: 'male',
    phone: '+1234567890',
    address: {
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA'
    }
};

async function testRegistration() {
    console.log('🧪 Testing Patient Registration...\n');
    console.log('Test Data:', JSON.stringify(testPatient, null, 2));
    console.log('\n' + '='.repeat(60) + '\n');

    try {
        // Test 1: Register a new patient
        console.log('📝 Registering new patient...');
        const response = await axios.post(`${API_URL}/auth/register/patient`, testPatient);

        console.log('✅ Registration Successful!\n');
        console.log('Response Status:', response.status);
        console.log('Response Data:', JSON.stringify(response.data, null, 2));

        if (response.data.success) {
            console.log('\n' + '='.repeat(60));
            console.log('✅ USER SUCCESSFULLY ADDED TO MONGODB ATLAS!');
            console.log('='.repeat(60));
            console.log('\nUser Details:');
            console.log('- ID:', response.data.user.id);
            console.log('- Name:', `${response.data.user.firstName} ${response.data.user.lastName}`);
            console.log('- Email:', response.data.user.email);
            console.log('- Phone:', response.data.user.phone);
            console.log('- Date of Birth:', response.data.user.dateOfBirth);
            console.log('- Gender:', response.data.user.gender);
            console.log('\n🔑 JWT Token Generated:', response.data.token.substring(0, 50) + '...');
        }

    } catch (error) {
        if (error.response) {
            console.log('❌ Registration Failed!');
            console.log('Status:', error.response.status);
            console.log('Error:', JSON.stringify(error.response.data, null, 2));

            if (error.response.data.error && error.response.data.error.includes('already exists')) {
                console.log('\n💡 Note: This email is already registered. Try with a different email.');
            }
        } else if (error.request) {
            console.log('❌ No response from server');
            console.log('Make sure the server is running on http://localhost:8080');
        } else {
            console.log('❌ Error:', error.message);
        }
    }
}

// Run the test
testRegistration();
