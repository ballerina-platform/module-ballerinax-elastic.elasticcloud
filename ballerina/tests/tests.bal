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

import ballerina/os;
import ballerina/test;
import ballerina/uuid;
import ballerina/http;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string apiKey = isLiveServer ? os:getEnv("ELASTIC_API_KEY") : "test-api-key-12345";
configurable string serviceUrl = isLiveServer ? "https://api.elastic-cloud.com/api/v1" : "http://localhost:9000/api/v1";

ApiKeysConfig apiKeyConfig = {
    authorization: "ApiKey " + apiKey
};

ConnectionConfig config = {};
final Client elasticClient = check new Client(apiKeyConfig, config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAccountEndpoint() returns error? {
    AccountResponse response = check elasticClient->/account();
    test:assertTrue(response?.id !is "");
    test:assertTrue(response?.id.length() > 0, "Account ID should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeploymentsEndpoint() returns error? {
    DeploymentsListResponse response = check elasticClient->/deployments();
    test:assertTrue(response.deployments is DeploymentsListingData[], msg = "Expected deployments field in response");
}

@test:Config {
    enable: isLiveServer,
    groups: ["live_tests"]
}
isolated function testGetApiKeyByIdLive() returns error? {
    ApiKeyResponse|error response = elasticClient->/users/auth/keys/["invalid-key-id"]();
    if response is http:ApplicationResponseError {
        test:assertEquals(response.detail().statusCode, http:STATUS_NOT_FOUND);
    } else {
        test:assertFail("Expected error for invalid API key ID");
    }
}

@test:Config {
    enable: !isLiveServer,
    groups: ["mock_tests"]
}
isolated function testGetApiKeyByIdMock() returns error? {
    ApiKeyResponse response = check elasticClient->/users/auth/keys/["test-key-123"]();
    test:assertEquals(response.id, "test-key-123", msg = "Expected API Key ID does not match");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListOrganizations() returns error? {
    OrganizationList orgList = check elasticClient->/organizations();
    test:assertTrue(orgList.organizations is Organization[], msg = "Expected organizations field in response");
}

@test:Config {
    enable: isLiveServer,
    groups: ["live_tests"]
}
isolated function testCreateDeploymentLiveSuccess() returns error? {
    DeploymentCreateRequest createRequest = {
        name: "test-deployment"
    };
    DeploymentCreateResponse response = check elasticClient->/deployments.post(createRequest, validate_only = true);
    test:assertTrue(response.name.length() > 0, "Deployment name should not be empty");
}


@test:Config {
    enable: !isLiveServer,
    groups: ["mock_tests"]
}
isolated function testCreateDeploymentMock() returns error? {
    DeploymentCreateRequest createRequest = {
        name: "test-deployment"
    };
    DeploymentCreateResponse response = check elasticClient->/deployments.post(createRequest);
    test:assertTrue(response.name.length() > 0, "Deployment name should not be empty");
}

@test:Config {
    enable: isLiveServer,
    groups: ["live_tests"]
}
isolated function testSearchDeploymentsLive() returns error? {
    SearchRequest searchRequest = {};
    DeploymentsSearchResponse|error response = elasticClient->/deployments/_search.post(searchRequest);
    if response is DeploymentsSearchResponse {
        test:assertTrue(response.returnCount >= 0, "Return count should be non-negative");
    } else {
        // COULD BE IMPROVED: If you expect specific HTTP errors, check status codes
        test:assertFail("Unexpected error: " + response.toString());
    }
}

@test:Config {
    enable: !isLiveServer,
    groups: ["mock_tests"]
}
isolated function testSearchDeploymentsMock() returns error? {
    SearchRequest searchRequest = {};
    DeploymentsSearchResponse response = check elasticClient->/deployments/_search.post(searchRequest);
    test:assertTrue(response.returnCount >= 0, "Return count should be non-negative");
}

@test:Config {
    enable: !isLiveServer,
    groups: ["mock_tests"]
}
isolated function testCreateApiKeyMock() returns error? {
    CreateApiKeyRequest minimalRequest = {
        "name": "minimal-test-key",
        "description": "Minimal test API key"
    };
    ApiKeyResponse response = check elasticClient->/users/auth/keys.post(minimalRequest);
    test:assertTrue(response is ApiKeyResponse, "API Key should be created successfully");
}

@test:Config {
    enable: isLiveServer,
    groups: ["live_tests"]
}
isolated function testDeleteApiKeyLive() returns error? {
    string keyIdToDelete = "non-existent-key-" + uuid:createType1AsString();
    var response = elasticClient->/users/auth/keys/[keyIdToDelete].delete();
    if response is http:ApplicationResponseError {
        test:assertEquals(response.detail().statusCode, http:STATUS_NOT_FOUND);
    } else {
        test:assertFail("Expected 404 for non-existent key");
    }
}

@test:Config {
    enable: !isLiveServer,
    groups: ["mock_tests"]
}
isolated function testDeleteApiKeyMock() returns error? {
    string keyIdToDelete = "test-key-123";
    EmptyResponse response = check elasticClient->/users/auth/keys/[keyIdToDelete].delete();
    test:assertTrue(response is EmptyResponse, "API Key should be deleted successfully");
}