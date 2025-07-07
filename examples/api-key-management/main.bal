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

configurable string apiKey = ?;

public function main() returns error? {
    elasticcloud:ApiKeysConfig config = {
        authorization: "ApiKey " + apiKey
    };

    elasticcloud:Client elasticClient = check new (config);
    io:println("Elastic Cloud client initialized");

    elasticcloud:CreateApiKeyRequest newKeyRequest = {
        description: "API key created from Ballerina"
    };
    elasticcloud:ApiKeyResponse createdKey = check elasticClient->/users/auth/keys.post(newKeyRequest);
    io:println(`API key created: ${createdKey.id}`);
    if createdKey.'key is string {
        io:println(`API Key: ${createdKey.'key ?: "N/A"}`);
        io:println("Save this API key - it won't be shown again!");
    }

    elasticcloud:ApiKeysResponse allKeys = check elasticClient->/users/auth/keys();
    io:println(`Found ${allKeys.keys.length()} API key(s)`);

    foreach elasticcloud:ApiKeyResponse keyItem in allKeys.keys {
        io:println(`- ID: ${keyItem.id}`);
        io:println(`  Description: ${keyItem.description}`);
        io:println(`  Created: ${keyItem.creationDate}`);
        if keyItem.expirationDate is string {
            io:println(`  Expires: ${keyItem.expirationDate ?: "N/A"}`);
        }
    }

    elasticcloud:EmptyResponse _ = check elasticClient->/users/auth/keys/[createdKey.id].delete();
    io:println("API key deleted successfully.");

    elasticcloud:ApiKeysResponse allKeysNew = check elasticClient->/users/auth/keys();
    io:println(`Found ${allKeysNew.keys.length()} API key(s) after deletion`);

    foreach elasticcloud:ApiKeyResponse keyItem in allKeysNew.keys {
        io:println(`- ID: ${keyItem.id}`);
        io:println(`  Description: ${keyItem.description}`);
        io:println(`  Created: ${keyItem.creationDate}`);
        if keyItem.expirationDate is string {
            io:println(`  Expires: ${keyItem.expirationDate ?: "N/A"}`);
        }
    }
}
