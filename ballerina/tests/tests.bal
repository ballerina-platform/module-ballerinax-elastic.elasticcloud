import ballerina/io;
import ballerina/os;
import ballerina/test;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string apiKey = isLiveServer ? os:getEnv("ELASTIC_API_KEY") : "test-api-key-12345";
configurable string serviceUrl = isLiveServer ? "https://api.elastic-cloud.com/api/v1" : "http://localhost:8080/api/v1";

ApiKeysConfig apiKeyConfig = {
    authorization:"ApiKey "+ apiKey
};

ConnectionConfig config = {};
final Client elasticClient = check new Client(apiKeyConfig, config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAccountEndpoint() returns error? {
    io:println(isLiveServer ? "Running against live server" : "Running against mock server");

    // map<string|string[]> headers = {};

    // if isLiveServer {
    //     headers["Authorization"] = "ApiKey " + apiKey;
    // }

    AccountResponse response = check elasticClient->/account();
    test:assertTrue(response?.id !is "");
    test:assertTrue(response?.id.length() > 0, "Account ID should not be empty");
}
