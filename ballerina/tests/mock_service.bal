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
import ballerina/log;
import ballerina/time;
import ballerina/uuid;

service /api/v1 on new http:Listener(9000) {
    resource function get account() returns AccountResponse {
        return {
            "id": "acc_12345",
            "trust": {
                "direct_trust": true,
                "external_trust": false,
                "trustAll": false
            }
        };
    }

    resource function get deployments() returns DeploymentsListResponse {
        return {
            deployments: [
                {
                    id: "dep_001",
                    name: "production-cluster",
                    resources: []
                },
                {
                    id: "dep_002",
                    name: "test-cluster",
                    resources: []
                }
            ]
        };
    }

    resource function get users/auth/keys/[string keyId]() returns ApiKeyResponse {
        return {
            id: keyId,
            description: "This is a test API key",
            creationDate: ""
        };
    }

    resource function post users/auth/keys(@http:Payload json payload) returns json|http:Response|error {
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
            "api_key": "elastic_api_key_" + uuid:createType4AsString()
        };
        return apiKeyResponse;
    }

    resource function get organizations() returns json|http:Response {
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

    resource function post deployments(@http:Payload json payload) returns DeploymentCreateResponse|http:Response {
        json|error nameJson = payload.name;
        if nameJson is error || nameJson is () {
            return createErrorResponse(400, "Deployment name is required");
        }
        string deploymentName = nameJson.toString();
        if deploymentName == "" {
            return createErrorResponse(400, "Deployment name is required");
        }
        json|error aliasJson = payload.alias;
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

    resource function post deployments/_search(@http:Payload json payload) returns DeploymentsSearchResponse|http:Response {
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

    resource function delete users/auth/keys/[string keyId]() returns json|http:Response {
        if keyId == "" {
            return createErrorResponse(400, "API Key ID is required");
        }

        json deleteResponse = {
            "found": true,
            "invalidated": true
        };
        return deleteResponse;
    }
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

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
}
