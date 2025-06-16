import ballerina/http;

// Mock service configuration
configurable int port = 8080;
configurable string validApiKey = "test-api-key-12345";

// Mock Elasticsearch Cloud API Service
service /api/v1 on new http:Listener(port) {

    // GET /account - Account Information
    resource function get account(http:Request req) returns json|http:Response {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return createErrorResponse(401, "Missing Authorization header");
        }
        
        if !isValidApiKey(authHeader) {
            return createErrorResponse(401, "Invalid API key");
        }
        
        return {
            "id": "acc_12345",
            "name": "Test Account",
            "email": "test@example.com",
            "organization_id": "org_67890",
            "level": "standard",
            "created_at": "2024-01-15T10:30:00Z",
            "updated_at": "2024-06-16T08:45:00Z",
            "status": "active"
        };
    }

    // GET /deployments - List Deployments
    resource function get deployments(http:Request req) returns json|http:Response {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return createErrorResponse(401, "Missing Authorization header");
        }
        
        if !isValidApiKey(authHeader) {
            return createErrorResponse(401, "Invalid API key");
        }
        
        return {
            "deployments": [
                {
                    "id": "dep_11111",
                    "name": "test-elasticsearch-cluster",
                    "region": "gcp-us-west1",
                    "version": "8.15.0",
                    "status": "started",
                    "created_at": "2024-06-01T12:00:00Z",
                    "elasticsearch": {
                        "version": "8.15.0",
                        "endpoint": "https://test-cluster.es.gcp-us-west1.elastic.co:9243"
                    },
                    "kibana": {
                        "version": "8.15.0",
                        "endpoint": "https://test-cluster.kb.gcp-us-west1.elastic.co:9243"
                    }
                },
                {
                    "id": "dep_22222",
                    "name": "dev-elasticsearch-cluster",
                    "region": "gcp-us-central1",
                    "version": "8.14.0",
                    "status": "started",
                    "created_at": "2024-05-15T09:30:00Z",
                    "elasticsearch": {
                        "version": "8.14.0",
                        "endpoint": "https://dev-cluster.es.gcp-us-central1.elastic.co:9243"
                    }
                }
            ],
            "total_count": 2
        };
    }

    // GET /deployments/templates - Deployment Templates
    resource function get deployments/templates(http:Request req, string? region) returns json|http:Response {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return createErrorResponse(401, "Missing Authorization header");
        }
        
        if !isValidApiKey(authHeader) {
            return createErrorResponse(401, "Invalid API key");
        }
        
        if region is () {
            return createErrorResponse(400, "Missing required parameter: region");
        }
        
        json templatesData;
        if region == "gcp-us-west1" {
            templatesData = [
                {
                    "id": "tpl_general_purpose",
                    "name": "General Purpose",
                    "description": "Balanced CPU and memory for general workloads",
                    "region": "gcp-us-west1",
                    "instance_configurations": [
                        {
                            "id": "gcp.data.highio.1",
                            "name": "High I/O",
                            "resource": "memory",
                            "size": {
                                "min": 1024,
                                "max": 65536
                            }
                        }
                    ]
                },
                {
                    "id": "tpl_search_optimized",
                    "name": "Search Optimized",
                    "description": "Optimized for search workloads",
                    "region": "gcp-us-west1",
                    "instance_configurations": [
                        {
                            "id": "gcp.data.search.1",
                            "name": "Search Optimized",
                            "resource": "memory",
                            "size": {
                                "min": 2048,
                                "max": 131072
                            }
                        }
                    ]
                }
            ];
        } else {
            templatesData = [
                {
                    "id": "tpl_basic",
                    "name": "Basic Template",
                    "description": "Basic template for " + region,
                    "region": region,
                    "instance_configurations": [
                        {
                            "id": "basic.data.1",
                            "name": "Basic Configuration",
                            "resource": "memory",
                            "size": {
                                "min": 1024,
                                "max": 32768
                            }
                        }
                    ]
                }
            ];
        }
        
        return templatesData;
    }

    // GET /users/auth/keys - Get API Keys
    resource function get users/auth/keys(http:Request req) returns json|http:Response {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return createErrorResponse(401, "Missing Authorization header");
        }
        
        if !isValidApiKey(authHeader) {
            return createErrorResponse(401, "Invalid API key");
        }
        
        return {
            "keys": [
                {
                    "id": "key_11111",
                    "name": "Test API Key",
                    "creation_date": "2024-06-01T10:00:00Z",
                    "last_used": "2024-06-16T14:30:00Z",
                    "permissions": [
                        "deployment:read",
                        "deployment:write",
                        "organization:read"
                    ],
                    "status": "active"
                },
                {
                    "id": "key_22222",
                    "name": "Development Key",
                    "creation_date": "2024-05-15T15:30:00Z",
                    "last_used": "2024-06-15T09:15:00Z",
                    "permissions": [
                        "deployment:read"
                    ],
                    "status": "active"
                }
            ],
            "total_count": 2
        };
    }

    // GET /organizations - List Organizations
    resource function get organizations(http:Request req) returns json|http:Response {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        if authHeader is http:HeaderNotFoundError {
            return createErrorResponse(401, "Missing Authorization header");
        }
        
        if !isValidApiKey(authHeader) {
            return createErrorResponse(401, "Invalid API key");
        }
        
        return {
            "organizations": [
                {
                    "id": "org_67890",
                    "name": "Test Organization",
                    "billing_email": "billing@testorg.com",
                    "created_at": "2024-01-01T00:00:00Z",
                    "updated_at": "2024-06-16T12:00:00Z",
                    "subscription": {
                        "level": "standard",
                        "status": "active"
                    }
                }
            ],
            "total_count": 1
        };
    }

    // Catch-all for non-existent endpoints
    resource function get [string... paths](http:Request req) returns http:Response {
        string path = "/" + string:'join("/", ...paths);
        return createErrorResponse(404, "Endpoint not found: " + path);
    }

    // Health check endpoint
    resource function get health() returns json {
        return {
            "status": "healthy",
            "service": "Mock Elasticsearch Cloud API",
            "version": "1.0.0"
        };
    }
}

// Validate API key
function isValidApiKey(string authHeader) returns boolean {
    string expectedAuth = "ApiKey " + validApiKey;
    return authHeader == expectedAuth;
}

// Create error response
function createErrorResponse(int statusCode, string message) returns http:Response {
    http:Response response = new;
    response.statusCode = statusCode;
    
    json errorBody = {
        "error": {
            "type": "api_error",
            "message": message
        }
    };
    
    response.setJsonPayload(errorBody);
    response.setHeader("Content-Type", "application/json");
    
    return response;
}

// Main function to start the mock service
public function main() returns error? {
    // Service will automatically start and stay running
}