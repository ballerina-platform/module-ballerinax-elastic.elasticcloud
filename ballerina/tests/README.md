# Elasticsearch Cloud API Connector Testing

This repository contains a comprehensive testing framework for the Ballerina Elasticsearch Cloud API connector with both mock and live testing capabilities.

## Overview

The testing framework provides two environments:
- **Mock Environment**: Local mock server that simulates Elasticsearch Cloud API responses
- **Live Environment**: Tests against the actual Elasticsearch Cloud API

## Configuration

### Environment Variables Setup

The framework uses environment variables for configuration:

```bash
# For Live Environment Testing
export IS_LIVE_SERVER=true
export ELASTIC_API_KEY="your-live-api-key-here"

# For Mock Environment Testing (default)
export IS_LIVE_SERVER=false
# ELASTIC_API_KEY not required for mock testing
```

### Configuration Parameters

| Environment Variable | Description | Default Value |
|---------------------|-------------|---------------|
| `IS_LIVE_SERVER` | Switch between mock (false) and live (true) testing | `false` |
| `ELASTIC_API_KEY` | Your Elasticsearch Cloud API key | Required for live tests only |

The framework automatically configures:
- **Live Environment**: `https://api.elastic-cloud.com/api/v1`
- **Mock Environment**: `http://localhost:8080/api/v1`
- **Mock API Key**: `test-api-key-12345` (used automatically in mock mode)

## Running Tests

### Mock Environment Testing (Default)

The mock environment is ideal for development and CI/CD pipelines as it doesn't require external dependencies or API keys.

1. **Start the mock service:**
```bash
# Terminal 1: Start mock service
bal run mock_service.bal
```

2. **Run tests in another terminal:**
```bash
# Terminal 2: Run tests (mock environment is default)
bal test --groups mock_tests
```

3. **Verify mock service health:**
```bash
curl http://localhost:8080/api/v1/account
```

Expected response:
```json
{
  "id": "acc_12345",
  "trust": {
    "direct_trust": true,
    "external_trust": false,
    "trustAll": false
  }
}
```

### Live Environment Testing

For testing against the actual Elasticsearch Cloud API:

1. **Set environment variables:**
```bash
export IS_LIVE_SERVER=true
export ELASTIC_API_KEY="your-actual-api-key"
```

2. **Run live tests:**
```bash
bal test --groups live_tests
```

### Running All Tests

To run tests for both environments:

```bash
bal test
```

## Test Groups

The testing framework includes two test groups with conditional execution:

| Test Group | Environment | Description |
|------------|-------------|-------------|
| `mock_tests` | Mock Server | Safe for development, no external dependencies |
| `live_tests` | Elasticsearch Cloud API | Tests against real API, requires valid credentials |

### Test Coverage

The framework includes **12 comprehensive tests** covering all major endpoints:

**Common Tests (Both Environments):**
- ✅ `testAccountEndpoint` - Get account information
- ✅ `testDeploymentsEndpoint` - List deployments
- ✅ `testListOrganizations` - Get organizations

**Environment-Specific Tests:**

**Mock-Only Tests:**
- ✅ `testGetApiKeyByIdMock` - Get API key by ID
- ✅ `testCreateDeploymentMock` - Create deployment
- ✅ `testSearchDeploymentsMock` - Search deployments
- ✅ `testCreateApiKeyMock` - Create API key
- ✅ `testDeleteApiKeyMock` - Delete API key

**Live-Only Tests:**
- ✅ `testGetApiKeyByIdLive` - Error handling for invalid API key
- ✅ `testCreateDeploymentLive` - Deployment creation with validation
- ✅ `testSearchDeploymentsLive` - Live deployment search
- ✅ `testDeleteApiKeyLive` - Delete non-existent API key handling

## Mock Service Endpoints

The mock service provides comprehensive API simulation:

### Account Management
- `GET /api/v1/account` - Returns mock account information

### Deployment Management
- `GET /api/v1/deployments` - List all deployments
- `POST /api/v1/deployments` - Create new deployment
- `POST /api/v1/deployments/_search` - Search deployments

### API Key Management
- `GET /api/v1/users/auth/keys/{keyId}` - Get API key by ID
- `POST /api/v1/users/auth/keys` - Create new API key
- `DELETE /api/v1/users/auth/keys/{keyId}` - Delete API key

### Organization Management
- `GET /api/v1/organizations` - List organizations

## Getting Your Elasticsearch Cloud API Key

1. **Sign up for Elastic Cloud:** Visit [https://cloud.elastic.co](https://cloud.elastic.co)
2. **Create an account:** Free trial available (14 days, no credit card required)
3. **Navigate to API Keys:**
   - Click your profile avatar (upper right)
   - Select "Organization"
   - Go to "API Keys" tab
4. **Generate API Key:**
   - Click "Create API Key"
   - Provide a name and set appropriate permissions
   - **Copy the key immediately** (cannot be retrieved later)
5. **Set environment variable** with your new API key:
   ```bash
   export ELASTIC_API_KEY="your-api-key-here"
   ```

## Advanced Testing Options

### Running Specific Tests

```bash
# Run only account endpoint test
bal test --tests testAccountEndpoint

# Run only mock environment tests
bal test --groups mock_tests

# Run only live environment tests
bal test --groups live_tests
```

### Custom Port Configuration

The mock service runs on port 8080 by default. If this port is in use, you can modify the `httpListener` port in `mock_service.bal`:

```ballerina
listener http:Listener httpListener = new (8081); // Change port here
```

### Debug Mode

Enable debug logging for detailed test execution information:

```bash
bal test --debug
```

## Project Structure

```
elasticsearch-connector/
├── Ballerina.toml
├── mock_service.bal         # Mock Elasticsearch Cloud API service
├── test.bal                 # Comprehensive test suite (12 tests)
└── README.md               # This documentation
```

## Security Best Practices

⚠️ **Important Security Guidelines:**

1. **Never commit real API keys** to version control
2. **Use environment variables** for sensitive configuration
3. **Start with mock environment** for development
4. **Validate permissions** on API keys before live testing
5. **Use least-privilege principle** for API key permissions

### Environment Variables in CI/CD

For GitHub Actions or similar CI/CD systems:

```yaml
env:
  IS_LIVE_SERVER: false  # Use mock for CI/CD
  # Don't set ELASTIC_API_KEY for security
```

## Troubleshooting

### Common Issues

**Mock Service Issues:**
- **Port already in use:** Change port in `mock_service.bal`
- **Service not responding:** Ensure mock service is running before tests
- **Connection refused:** Check if localhost:8080 is accessible

**Live API Issues:**
- **401 Unauthorized:** Verify your API key is correct and active
- **403 Forbidden:** Check API key permissions
- **402 Payment Required:** Live API may require active subscription for certain operations

### Test Debugging

The test framework provides conditional execution and detailed error handling:

```bash
# View test execution details
bal test --observability-included

# Check specific test results
bal test --tests testAccountEndpoint --debug
```

### Health Checks

**Mock Service Health Check:**
```bash
curl -X GET http://localhost:8080/api/v1/account
```

**Live API Connectivity Check:**
```bash
curl -X GET https://api.elastic-cloud.com/api/v1/account \
  -H "Authorization: ApiKey your-api-key"
```

## Error Handling

The framework includes comprehensive error handling:

- **Mock Environment**: Simulates realistic API responses and errors
- **Live Environment**: Handles real API errors gracefully (401, 402, 403, 404)
- **Conditional Testing**: Tests automatically skip based on environment
- **Graceful Degradation**: Live tests handle subscription-related errors

## Contributing

When contributing to this testing framework:

1. **Test with mock environment first** for development
2. **Add corresponding tests** for both environments when possible
3. **Follow existing authentication patterns** using environment variables
4. **Update documentation** for new test cases
5. **Ensure backward compatibility** with existing configurations

## API Documentation

For detailed information about the Elasticsearch Cloud API:
- [Official API Documentation](https://www.elastic.co/guide/en/cloud/current/ec-restful-api.html)
- [Authentication Guide](https://www.elastic.co/guide/en/cloud/current/ec-api-authentication.html)
- [API Reference](https://www.elastic.co/guide/en/cloud/current/ec-api-reference.html)

## License

This testing framework follows the same license as the main Ballerina Elasticsearch Cloud connector project.