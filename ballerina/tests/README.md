# Elasticsearch Cloud API Connector Testing

This repository contains a comprehensive testing framework for the Ballerina Elasticsearch Cloud API connector with both mock and live testing capabilities.

## Overview

The testing framework provides two environments:
- **Mock Environment**: Local mock server that simulates Elasticsearch Cloud API responses
- **Live Environment**: Tests against the actual Elasticsearch Cloud API

## Configuration

### Config.toml Setup

Create a `Config.toml` file in your project root with the following structure:

```toml
# Set to false for mock testing, true for live testing
useLiveEnvironment = false

# Live Elasticsearch Cloud API configuration
liveApiKey = "your-live-api-key-here"
liveBaseUrl = "https://api.elastic-cloud.com"

# Mock service configuration
mockApiKey = "test-api-key-12345"
mockBaseUrl = "http://localhost:8080"

# Mock service settings
validApiKey = "test-api-key-12345"
port = 8080
```

### Configuration Parameters

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `useLiveEnvironment` | Switch between mock (false) and live (true) testing | `false` |
| `liveApiKey` | Your Elasticsearch Cloud API key | Required for live tests |
| `liveBaseUrl` | Elasticsearch Cloud API base URL | `https://api.elastic-cloud.com` |
| `mockApiKey` | API key for mock testing | `test-api-key-12345` |
| `mockBaseUrl` | Mock service base URL | `http://localhost:8080` |
| `validApiKey` | Valid API key for mock service | `test-api-key-12345` |
| `port` | Port for mock service | `8080` |

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
# Terminal 2: Run tests
bal test --groups mock_tests
```

3. **Verify mock service health:**
```bash
curl http://localhost:8080/api/v1/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "Mock Elasticsearch Cloud API",
  "version": "1.0.0"
}
```

### Live Environment Testing

For testing against the actual Elasticsearch Cloud API:

1. **Update Config.toml:**
```toml
useLiveEnvironment = true
liveApiKey = "your-actual-api-key"
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

The testing framework includes two test groups:

| Test Group | Environment | Description |
|------------|-------------|-------------|
| `mock_tests` | Mock Server | Safe for development, no external dependencies |
| `live_tests` | Elasticsearch Cloud API | Tests against real API, requires valid credentials |

### Test Coverage

Both environments test the following endpoints:

**Common Tests (Both Environments):**
- `GET /account` - Account Information
- `GET /deployments` - List Deployments
- `GET /deployments/templates` - Deployment Templates
- `GET /users/auth/keys` - API Keys Management
- `GET /organizations` - Organization Information
- Authentication error handling
- Non-existent endpoint handling

**Mock-Only Tests:**
- Multiple concurrent requests test
- Comprehensive error scenario testing

**Live-Only Tests:**
- API connectivity verification
- Single request validation
- Real-world authentication testing

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
5. **Update Config.toml** with your new API key

## Environment Variables Alternative

Instead of Config.toml, you can use environment variables:

**Linux/Mac:**
```bash
export BALLERINA_USE_LIVE_ENVIRONMENT=true
export BALLERINA_LIVE_API_KEY="your-api-key"
export BALLERINA_LIVE_BASE_URL="https://api.elastic-cloud.com"
```

**Windows:**
```cmd
setx BALLERINA_USE_LIVE_ENVIRONMENT true
setx BALLERINA_LIVE_API_KEY your-api-key
setx BALLERINA_LIVE_BASE_URL https://api.elastic-cloud.com
```

## Advanced Testing Options

### Running Specific Tests

```bash
# Run only account endpoint test
bal test --tests testAccountEndpoint

# Run only authentication tests
bal test --tests testInvalidApiKey

# Run only mock environment tests
bal test --groups mock_tests
```

### Custom Port Configuration

If port 8080 is in use, modify the `port` value in Config.toml:

```toml
port = 8081
mockBaseUrl = "http://localhost:8081"
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
├── Config.toml              # Configuration file
├── mock_service.bal         # Mock Elasticsearch Cloud API service
└── test.bal                 # Comprehensive test suite (10 tests)
```

## Security Best Practices

⚠️ **Important Security Guidelines:**

1. **Never commit real API keys** to version control
2. **Add Config.toml to .gitignore** when using real credentials
3. **Use environment variables** in CI/CD pipelines
4. **Start with mock environment** for development
5. **Validate permissions** on API keys before live testing
6. **Use least-privilege principle** for API key permissions

### Example .gitignore Entry

```gitignore
# Keep Config.toml out of version control if it contains real credentials
Config.toml

# But you might want to include a template
!Config.toml.template
```

## Troubleshooting

### Common Issues

**Mock Service Issues:**
- **Port already in use:** Change `port` in Config.toml
- **Service not responding:** Ensure mock service is running before tests
- **Connection refused:** Check if localhost:8080 is accessible

**Live API Issues:**
- **401 Unauthorized:** Verify your API key is correct and active
- **403 Forbidden:** Check API key permissions
- **Rate limiting:** Space out requests or use mock environment for development

### Test Debugging

The test framework provides detailed logging:

```bash
# View test execution details
bal test --observability-included

# Check specific test results
bal test --tests testAccountEndpoint --debug
```

### Health Checks

**Mock Service Health Check:**
```bash
curl -X GET http://localhost:8080/api/v1/health
```

**Live API Connectivity Check:**
```bash
curl -X GET https://api.elastic-cloud.com/api/v1/account \
  -H "Authorization: ApiKey your-api-key"
```

## Contributing

When contributing to this testing framework:

1. **Test with mock environment first** for development
2. **Add corresponding tests** for both environments when possible
3. **Follow existing authentication patterns**
4. **Update documentation** for new test cases
5. **Ensure backward compatibility** with existing configurations

## API Documentation

For detailed information about the Elasticsearch Cloud API:
- [Official API Documentation](https://www.elastic.co/guide/en/cloud/current/ec-restful-api.html)
- [Authentication Guide](https://www.elastic.co/guide/en/cloud/current/ec-api-authentication.html)
- [API Reference](https://www.elastic.co/guide/en/cloud/current/ec-api-reference.html)

## License

This testing framework follows the same license as the main Ballerina Elasticsearch Cloud connector project.