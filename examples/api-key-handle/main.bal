import ballerina/io;
import ballerinax/elastic.elasticcloud;

configurable string elasticApiKey = ?;

public function main() returns error? {
    elasticcloud:ApiKeysConfig config = {
        authorization: "ApiKey " + elasticApiKey
    };

    elasticcloud:Client elasticClient = check new (config);
    io:println("Elastic Cloud client initialized");

    elasticcloud:CreateApiKeyRequest newKeyRequest = {
        description: "API key created from Ballerina example for Delete API Key"
    };
    io:println("Creating new API key...");
    elasticcloud:ApiKeyResponse createdKey = check elasticClient->/users/auth/keys.post(newKeyRequest);
    io:println("API key created successfully!");
    io:println("Key ID: " + createdKey.id);
    if createdKey.'key is string {
        io:println("API Key: " + (createdKey.'key ?: "N/A"));
        io:println("Save this API key - it won't be shown again!");
    }

    io:println("\nFetching all API keys...");
    elasticcloud:ApiKeysResponse allKeys = check elasticClient->/users/auth/keys();
    io:println("Found " + allKeys.keys.length().toString() + " API key(s)");

    io:println("\nYour API Keys:");
    foreach elasticcloud:ApiKeyResponse keyItem in allKeys.keys {
        io:println("- ID: " + keyItem.id);
        io:println("  Description: " + keyItem.description);
        io:println("  Created: " + keyItem.creationDate);
        if keyItem.expirationDate is string {
            io:println("  Expires: " + (keyItem.expirationDate ?: "N/A"));
        }
        io:println();
    }

    io:println("Deleting the created API key...");
    elasticcloud:EmptyResponse _ = check elasticClient->/users/auth/keys/[createdKey.id].delete();
    io:println("API key deleted successfully.");

    io:println("\nFetching all API keys after deletion...");
    elasticcloud:ApiKeysResponse allKeysNew = check elasticClient->/users/auth/keys();
    io:println("Found " + allKeysNew.keys.length().toString() + " API key(s)");

    io:println("\nYour API Keys:");
    foreach elasticcloud:ApiKeyResponse keyItem in allKeysNew.keys {
        io:println("- ID: " + keyItem.id);
        io:println("  Description: " + keyItem.description);
        io:println("  Created: " + keyItem.creationDate);
        if keyItem.expirationDate is string {
            io:println("  Expires: " + (keyItem.expirationDate ?: "N/A"));
        }
        io:println();
    }
}
