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

import ballerina/io;
import ballerinax/elastic.elasticcloud;

configurable string elasticApiKey = ?;

public function main() returns error? {
    elasticcloud:ApiKeysConfig config = {
        authorization: "ApiKey " + elasticApiKey
    };

    elasticcloud:Client elasticClient = check new (config);
    io:println("Elastic Cloud client initialized");

    elasticcloud:DeploymentCreateRequest newDeploymentRequest = {
        name: "ballerina-example-deployment",
        region: "gcp-asia-south1",
        version: "8.17.0"
    };

    elasticcloud:CreateDeploymentQueries queries = {
        template_id: "gcp-general-purpose"
    };

    elasticcloud:DeploymentCreateResponse createdDeployment = check elasticClient->/deployments.post(newDeploymentRequest, queries = queries);
    io:println(`Deployment created: ${createdDeployment.id}`);

    elasticcloud:DeploymentsListResponse deploymentsList = check elasticClient->/deployments();
    io:println(`Found ${deploymentsList.deployments.length()} deployment(s)`);

    if deploymentsList.deployments.length() == 0 {
        io:println("No deployments found in your account.");
        return;
    }

    foreach elasticcloud:DeploymentsListingData deployment in deploymentsList.deployments {
        io:println(`- ID: ${deployment.id}`);

        string? name = deployment.name;
        io:println(`  Name: ${name != "" ? name : "N/A"}`);

        string? aliasValue = check deployment["alias"].ensureType();
        io:println(`  Alias: ${aliasValue != "" ? aliasValue : "N/A"}`);
    }

    elasticcloud:SearchRequest searchRequest = {
        size: 10
    };

    elasticcloud:DeploymentsSearchResponse searchResults = check elasticClient->/deployments/_search.post(searchRequest);
    io:println(`Search found ${searchResults.returnCount} deployment(s)`);

    if searchResults.returnCount > 0 {
        foreach elasticcloud:DeploymentSearchResponse deployment in searchResults.deployments {
            io:println(`- ID: ${deployment.id}`);

            string name = deployment.name;
            io:println(`  Name: ${name}`);

            boolean healthy = deployment.healthy;
            io:println(`  Healthy: ${healthy}`);

        }
    } else {
        io:println("No deployments found matching the search criteria.");
    }

    elasticcloud:SearchRequest allDeploymentsSearch = {};
    elasticcloud:DeploymentsSearchResponse allSearchResults = check elasticClient->/deployments/_search.post(allDeploymentsSearch);
    io:println(`Search API returned ${allSearchResults.returnCount} deployment(s)`);

    if allSearchResults.returnCount > 0 {
        foreach elasticcloud:DeploymentSearchResponse deployment in allSearchResults.deployments {
            io:println(`- ID: ${deployment.id}`);

            string name = deployment.name;
            io:println(`  Name: ${name}`);

            boolean healthy = deployment.healthy;
            io:println(`  Healthy: ${healthy}`);
        }
    }
}
