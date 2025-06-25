// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/io;
import ballerina/time;
import ballerina/uuid;

listener http:Listener httpListener = new (9000);

http:Service mockService = service object {
    resource function get api/v1/account() returns AccountResponse|http:Response {
        AccountResponse response = {
            "id": "acc_12345",
            "trust": {
                "direct_trust": true,
                "external_trust": false,
                "trustAll": false
            }
        };
        return response;
    }

    resource function get api/v1/deployments() returns json|http:Response {
        json deploymentsResponse = {
            deployments: [
                {
                    "id": "dep_001",
                    "name": "production-cluster",
                    "region": "us-west",
                    "status": "running",
                    "resources": []
                },
                {
                    "id": "dep_002",
                    "name": "test-cluster",
                    "region": "eu-central",
                    "status": "stopped",
                    "resources": []
                }
            ]
        };
        return deploymentsResponse;
    }

    resource function get api/v1/users/auth/keys/[string keyId]() returns json|http:Response {
        json apiKey = {
            "id": keyId,
            "name": "My test key",
            "description": "This is a test API key",
            "user_id": "user_001",
            "creation_date": "2023-01-01T00:00:00Z",
            "expiration_date": "2025-01-01T00:00:00Z"
        };
        return apiKey;
    }

    resource function post api/v1/users/auth/keys(@http:Payload json payload) returns json|http:Response|error {
        string keyId = "key_" + uuid:createType4AsString().substring(0, 8);
        string keyName = payload.name is string ? (check payload.name).toString() : "Unnamed Key";
        string? description = payload.description is string ? (check payload.description).toString() : ();
        string? expirationDate = payload.expiration_date is string ? (check payload.expiration_date).toString() : ();
        json apiKeyResponse = {
            "id": keyId,
            "name": keyName,
            "description": description,
            "user_id": "user_001",
            "creation_date": time:utcToString(time:utcNow()),
            "expiration_date": expirationDate,
            "api_key": "elastic_api_key_" + uuid:createType4AsString() // Mock API key value
        };
        return apiKeyResponse;
    }

    resource function get api/v1/organizations() returns json|http:Response {
        json organizationsResponse = {
            "organizations": [
                {
                    "id": "org_001",
                    "name": "Test Organization 1",
                    "type": "standard",
                    "created_at": "2023-01-01T00:00:00Z",
                    "updated_at": "2023-06-01T00:00:00Z"
                },
                {
                    "id": "org_002",
                    "name": "Test Organization 2",
                    "type": "enterprise",
                    "created_at": "2023-02-01T00:00:00Z",
                    "updated_at": "2023-06-15T00:00:00Z"
                }
            ],
            "next_page": null
        };
        return organizationsResponse;
    }

    resource function post api/v1/deployments(http:Request request) returns DeploymentCreateResponse|http:Response {
        json|error payloadJson = request.getJsonPayload();
        if payloadJson is error {
            return createErrorResponse(400, "Invalid JSON payload");
        }
        json|error nameJson = payloadJson.name;
        if nameJson is error || nameJson is () {
            return createErrorResponse(400, "Deployment name is required");
        }
        string deploymentName = nameJson.toString();
        if deploymentName == "" {
            return createErrorResponse(400, "Deployment name is required");
        }
        json|error aliasJson = payloadJson.alias;
        string? alias = aliasJson is string ? aliasJson : ();
        string deploymentId = "dep_" + deploymentName.toLowerAscii() + "_123";
        DeploymentCreateResponse response = {
            created: true,
            name: deploymentName,
            alias: alias,
            id: deploymentId,
            resources: [
                {
                    id: "res_001",
                    kind: "elasticsearch",
                    region: "us-west-1",
                    refId: "main-elasticsearch"
                }
            ]
        };
        return response;
    }

    resource function post api/v1/deployments/_search(http:Request req) returns DeploymentsSearchResponse|http:Response {
        json|error payloadJson = req.getJsonPayload();
        if payloadJson is error {
            return createErrorResponse(400, "Invalid JSON payload");
        }
        DeploymentsSearchResponse response = {
            deployments: [
                {
                    id: "dep_001",
                    name: "production-cluster",
                    resources: {
                        apm: [],
                        appsearch: [],
                        elasticsearch: [],
                        enterpriseSearch: [],
                        integrationsServer: [],
                        kibana: []
                    },
                    healthy: false
                },
                {
                    id: "dep_002",
                    name: "test-cluster",
                    resources: {
                        apm: [],
                        appsearch: [],
                        elasticsearch: [],
                        enterpriseSearch: [],
                        integrationsServer: [],
                        kibana: []
                    },
                    healthy: false
                }
            ],
            returnCount: 2,
            matchCount: 2
        };
        return response;
    }

    resource function delete api/v1/users/auth/keys/[string keyId]() returns json|http:Response {
        if keyId == "" {
            return createErrorResponse(400, "API Key ID is required");
        }
        json deleteResponse = {
            "found": true,
            "invalidated": true
        };
        return deleteResponse;
    }
};

function init() returns error? {
    if isLiveServer {
        io:println("Running against live server, skipping mock service initialization.");
        return;
    }
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}

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