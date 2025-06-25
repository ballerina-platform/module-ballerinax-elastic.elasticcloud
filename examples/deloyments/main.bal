import ballerina/log;
import ballerinax/elastic.elasticcloud;

configurable string elasticApiKey = ?;

public function main() returns error? {
    elasticcloud:ApiKeysConfig config = {
        authorization: "ApiKey " + elasticApiKey
    };

    elasticcloud:Client elasticClient = check new (config);
    log:printInfo("Elastic Cloud client initialized");

    elasticcloud:DeploymentCreateRequest newDeploymentRequest = {
        name: "ballerina-example-deployment",
        region: "gcp-asia-south1",
        version: "8.17.0"
    };

    elasticcloud:CreateDeploymentQueries queries = {
        template_id: "gcp-general-purpose"
    };

    log:printInfo("Creating new deployment...");
    elasticcloud:DeploymentCreateResponse createdDeployment = check elasticClient->/deployments.post(newDeploymentRequest, queries = queries);
    log:printInfo("Deployment created successfully!");
    log:printInfo("Deployment ID: " + createdDeployment.id);
    if createdDeployment.name is string {
        log:printInfo("Deployment Name: " + (createdDeployment.name != "" ? createdDeployment.name : "N/A"));
    }

    log:printInfo("Fetching all deployments...");
    elasticcloud:DeploymentsListResponse deploymentsList = check elasticClient->/deployments();
    log:printInfo("Found " + deploymentsList.deployments.length().toString() + " deployment(s)");

    if deploymentsList.deployments.length() == 0 {
        log:printInfo("No deployments found in your account.");
        return;
    }

    log:printInfo("Your Deployments:");
    foreach elasticcloud:DeploymentsListingData deployment in deploymentsList.deployments {
        log:printInfo("- ID: " + deployment.id);
        if deployment.name is string {
            log:printInfo("  Name: " + (deployment.name != "" ? deployment.name : "N/A"));
        }
        if deployment["alias"] is string {
            log:printInfo("  Alias: " + (<string>deployment["alias"] != "" ? <string>deployment["alias"] : "N/A"));
        }
        if deployment["healthy"] is boolean {
            log:printInfo("  Healthy: " + (<boolean>deployment["healthy"]).toString());
        }
        if deployment["region"] is string {
            log:printInfo("  Region: " + (<string>deployment["region"] != "" ? <string>deployment["region"] : "N/A"));
        }
        if deployment["cloudProvider"] is string {
            log:printInfo("  Cloud Provider: " + (<string>deployment["cloudProvider"] != "" ? <string>deployment["cloudProvider"] : "N/A"));
        }
    }

    log:printInfo("Searching for deployments with 'ballerina' in the name...");
    elasticcloud:SearchRequest searchRequest = {
        size: 10
    };

    elasticcloud:DeploymentsSearchResponse searchResults = check elasticClient->/deployments/_search.post(searchRequest);
    log:printInfo("Search found " + searchResults.returnCount.toString() + " deployment(s)");

    if searchResults.returnCount > 0 {
        log:printInfo("Search Results:");
        foreach elasticcloud:DeploymentSearchResponse deployment in searchResults.deployments {
            log:printInfo("- ID: " + deployment.id);
            if deployment.name is string {
                log:printInfo("  Name: " + deployment.name);
            }
            if deployment.healthy is boolean {
                log:printInfo("  Healthy: " + deployment.healthy.toString());
            }
        }
    } else {
        log:printInfo("No deployments found matching the search criteria.");
    }

    log:printInfo("Searching for all deployments using search API...");
    elasticcloud:SearchRequest allDeploymentsSearch = {};
    elasticcloud:DeploymentsSearchResponse allSearchResults = check elasticClient->/deployments/_search.post(allDeploymentsSearch);
    log:printInfo("Search API returned " + allSearchResults.returnCount.toString() + " deployment(s)");

    if allSearchResults.returnCount > 0 {
        log:printInfo("All Deployments (via search):");
        foreach elasticcloud:DeploymentSearchResponse deployment in allSearchResults.deployments {
            log:printInfo("- ID: " + deployment.id);
            if deployment.name is string {
                log:printInfo("  Name: " + deployment.name);
            }
            if deployment.healthy is boolean {
                log:printInfo("  Healthy: " + deployment.healthy.toString());
            }
            if deployment["region"] is string {
                log:printInfo("  Region: " + (<string>deployment["region"]));
            }
        }
    }
}