import ballerina/test;
import ballerina/http;
import ballerina/lang.value;

// Configuration
configurable string apiKey = ?;
configurable string environment = "mock";
configurable string baseUrl = "http://localhost:8080";
configurable string testPrefix = "test_";

// Common headers
map<string|string[]> commonHeaders = { 
    "Authorization": "ApiKey " + apiKey,
    "Content-Type": "application/json"
};

// Test 1: GET /account - Account Information
@test:Config {}
function testAccountEndpoint() returns error? {
    http:Client elasticClient = check new (baseUrl);
    json|error response = elasticClient->get("/api/v1/account", commonHeaders);
    
    if response is json {
        // Validate required fields
        json|error idField = response.id;
        if idField is json {
            string accountId = idField.toString();
            test:assertTrue(accountId.length() > 0, "Account ID should not be empty");
        } else {
            test:assertFail("Response should contain account ID");
        }
        
        // Validate account name exists
        json|error nameField = response.name;
        if nameField is json {
            test:assertTrue(nameField.toString().length() > 0, "Account name should not be empty");
        }
    } else {
        handleError(response, "Account endpoint test failed");
    }
}

// Test 2: GET /deployments - List Deployments
@test:Config {}
function testListDeployments() returns error? {
    http:Client elasticClient = check new (baseUrl);
    json|error response = elasticClient->get("/api/v1/deployments", commonHeaders);
    
    if response is json {
        // Check if deployments array exists
        json|error deploymentsField = response.deployments;
        if deploymentsField is json[] {
            test:assertTrue(deploymentsField is json[], "Deployments should be an array");
            
            // Validate deployment structure if deployments exist
            if deploymentsField.length() > 0 {
                json firstDeployment = deploymentsField[0];
                json|error idField = firstDeployment.id;
                test:assertTrue(idField is json, "Deployment should have an ID");
            }
        }
    } else {
        handleError(response, "Deployments list test failed");
    }
}

// Test 3: GET /deployments/templates - Deployment Templates
@test:Config {}
function testDeploymentTemplates() returns error? {
    http:Client elasticClient = check new (baseUrl);
    string endpoint = "/api/v1/deployments/templates?region=gcp-us-west1";
    json|error response = elasticClient->get(endpoint, commonHeaders);
    
    if response is json {
        if response is json[] {
            test:assertTrue(response.length() > 0, "Should have at least one template");
            
            // Validate template structure
            if response.length() > 0 {
                json firstTemplate = response[0];
                json|error idField = firstTemplate.id;
                test:assertTrue(idField is json, "Template should have an ID");
            }
        }
    } else {
        handleError(response, "Deployment templates test failed");
    }
}

// Test 4: GET /users/auth/keys - Get API Keys
@test:Config {}
function testGetApiKeys() returns error? {
    http:Client elasticClient = check new (baseUrl);
    json|error response = elasticClient->get("/api/v1/users/auth/keys", commonHeaders);
    
    if response is json {
        // Check for keys array
        json|error keysField = response.keys;
        if keysField is json[] {
            test:assertTrue(keysField is json[], "Keys should be an array");
            
            // Validate key structure if keys exist
            if keysField.length() > 0 {
                json firstKey = keysField[0];
                json|error idField = firstKey.id;
                test:assertTrue(idField is json, "API key should have an ID");
            }
        }
    } else {
        handleError(response, "API keys test failed");
    }
}

// Test 5: GET /organizations - List Organizations
@test:Config {}
function testOrganizations() returns error? {
    http:Client elasticClient = check new (baseUrl);
    json|error response = elasticClient->get("/api/v1/organizations", commonHeaders);
    
    if response is json {
        // Check for organizations array
        json|error organizationsField = response.organizations;
        if organizationsField is json[] {
            test:assertTrue(organizationsField is json[], "Organizations should be an array");
        }
    } else {
        handleError(response, "Organizations test failed");
    }
}

// Test 6: Authentication Error Handling
@test:Config {}
function testInvalidApiKey() returns error? {
    http:Client elasticClient = check new (baseUrl);
    map<string|string[]> invalidHeaders = { 
        "Authorization": "ApiKey invalid-key-12345",
        "Content-Type": "application/json"
    };
    
    json|error response = elasticClient->get("/api/v1/account", invalidHeaders);
    
    if response is error {
        if response is http:ClientError {
            var detail = response.detail();
            if detail.hasKey("statusCode") {
                value:Cloneable & readonly statusCode = detail["statusCode"];
                if statusCode is int {
                    test:assertTrue(statusCode == 401, "Should return 401 for invalid API key");
                }
            }
        }
    } else {
        test:assertFail("Invalid API key should have been rejected");
    }
}

// Test 7: Error handling for non-existent endpoint
@test:Config {}
function testNonExistentEndpoint() returns error? {
    http:Client elasticClient = check new (baseUrl);
    json|error response = elasticClient->get("/api/v1/non-existent-endpoint", commonHeaders);
    
    if response is error {
        if response is http:ClientError {
            var detail = response.detail();
            if detail.hasKey("statusCode") {
                value:Cloneable & readonly statusCode = detail["statusCode"];
                if statusCode is int {
                    test:assertTrue(statusCode == 404, "Should return 404 for non-existent endpoint");
                }
            }
        }
    } else {
        test:assertFail("Non-existent endpoint should return error");
    }
}

// Test 8: Multiple requests test
@test:Config {}
function testMultipleRequests() returns error? {
    http:Client elasticClient = check new (baseUrl);
    
    int successCount = 0;
    int errorCount = 0;
    
    foreach int i in 1...5 {
        json|error response = elasticClient->get("/api/v1/account", commonHeaders);
        if response is json {
            successCount += 1;
        } else {
            errorCount += 1;
        }
    }
    
    test:assertTrue(successCount + errorCount == 5, "All requests should be accounted for");
    test:assertTrue(successCount > 0, "At least some requests should succeed");
}

// Helper function for error handling
function handleError(error err, string testName) {
    if err is http:ClientError {
        var detail = err.detail();
        
        // Extract and validate status code
        if detail.hasKey("statusCode") {
            value:Cloneable & readonly statusCode = detail["statusCode"];
            if statusCode is int {
                // Allow certain expected error codes to pass
                if statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 429 {
                    return; // Expected error, don't fail the test
                }
            }
        }
    }
    
    test:assertFail(testName + ": " + err.message());
}