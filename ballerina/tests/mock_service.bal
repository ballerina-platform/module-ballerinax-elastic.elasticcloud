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
import ballerina/time;
import ballerina/uuid;

service /api/v1 on new http:Listener(9000) {
    resource function get account() returns AccountResponse {
        return {
            id: "acc_12345",
            trust: {
                trustAll: false
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

    resource isolated function post users/auth/keys(CreateApiKeyRequest payload) returns ApiKeyResponse {
        string keyId = "key_" + uuid:createType4AsString().substring(0, 8);
        ApiKeyResponse response = {
            id: keyId,
            description: payload.description,
            creationDate: time:utcNow().toString()
        };
        return response;
    }

    resource function get organizations() returns OrganizationList|error {
        OrganizationList organizationsResponse = {
            organizations: [
                {
                    id: "org_001",
                    name: "Test Organization 1"
                },
                {
                    id: "org_002",
                    name: "Test Organization 2"
                }
            ]
        };
        return organizationsResponse;
    }

    resource function post deployments(DeploymentCreateRequest payload) returns DeploymentCreateResponse|error {
    string? deploymentName = payload.name;

    if deploymentName is () || deploymentName == "" {
        return error("Deployment name is required and cannot be empty");
    }

    string? alias = payload.alias;
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

    resource function post deployments/_search(SearchRequest payload) returns DeploymentsSearchResponse|error {
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

    resource function delete users/auth/keys/[string keyId]() returns json|http:BadRequest {
        if keyId == "" {
            return <http:BadRequest>{
                body: {
                    message: "Key ID is required"
                }
            };
        }
        json deleteResponse = {
            "found": true,
            "invalidated": true
        };
        return deleteResponse;
    }
}