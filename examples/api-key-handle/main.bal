import ballerina/log;
import ballerinax/elastic.elasticcloud;

configurable string elasticApiKey = ?;

public function main() returns error? {
    elasticcloud:ApiKeysConfig config = {
        authorization: "ApiKey " + elasticApiKey
    };

    elasticcloud:Client elasticClient = check new (config);
    log:printInfo("Elastic Cloud client initialized");

    elasticcloud:CreateApiKeyRequest newKeyRequest = {
        description: "API key created from Ballerina example for Delete API Key"
    };
    elasticcloud:ApiKeyResponse createdKey = check elasticClient->/users/auth/keys.post(newKeyRequest);
    log:printInfo("API key created: " + createdKey.id);
    if createdKey.'key is string {
        log:printInfo("API Key: " + (createdKey.'key ?: "N/A"));
        log:printInfo("Save this API key - it won't be shown again!");
    }

    elasticcloud:ApiKeysResponse allKeys = check elasticClient->/users/auth/keys();
    log:printInfo("Found " + allKeys.keys.length().toString() + " API key(s)");

    foreach elasticcloud:ApiKeyResponse keyItem in allKeys.keys {
        log:printInfo("- ID: " + keyItem.id);
        log:printInfo("  Description: " + keyItem.description);
        log:printInfo("  Created: " + keyItem.creationDate);
        if keyItem.expirationDate is string {
            log:printInfo("  Expires: " + (keyItem.expirationDate ?: "N/A"));
        }
    }

    elasticcloud:EmptyResponse _ = check elasticClient->/users/auth/keys/[createdKey.id].delete();
    log:printInfo("API key deleted successfully.");

    elasticcloud:ApiKeysResponse allKeysNew = check elasticClient->/users/auth/keys();
    log:printInfo("Found " + allKeysNew.keys.length().toString() + " API key(s) after deletion");

    foreach elasticcloud:ApiKeyResponse keyItem in allKeysNew.keys {
        log:printInfo("- ID: " + keyItem.id);
        log:printInfo("  Description: " + keyItem.description);
        log:printInfo("  Created: " + keyItem.creationDate);
        if keyItem.expirationDate is string {
            log:printInfo("  Expires: " + (keyItem.expirationDate ?: "N/A"));
        }
    }
}
