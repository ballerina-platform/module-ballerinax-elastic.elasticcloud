_Author_:  @yasithrashan \
_Created_: 2025-06-20 \
_Updated_: 2025-06-20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Elasticsearch. 
The OpenAPI specification is obtained from (TODO: Add source link).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. **Added Global Security Configuration**
   - **Issue**: Original spec had empty security array `"security": []` which indicated no authentication required
   - **Sanitization**: Updated to `"security": [{"apiKey": []}]` to enforce API key authentication globally
   - **Reason**: Ensures Ballerina client generator creates proper authentication handling code
   - **Impact**: Auto-generates `ApiKeysConfig` and authorization header management

2. **Security Definitions Validation**
   - **Issue**: Verified existing `securityDefinitions` section was properly configured
   - **Status**: Already correct - defines `apiKey` as header-based authentication via `Authorization` header
   - **No changes needed**: Configuration was valid

3. **Authentication Header Format**
   - **Verified**: API expects `Authorization: ApiKey <api_key_value>` format
   - **Status**: Compatible with generated client code
   - **Usage**: `authorization: "ApiKey " + apiKey` in client configuration

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
