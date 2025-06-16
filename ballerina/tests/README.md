# Elasticsearch Cloud API Connector Testing

This repository contains comprehensive testing framework for the Ballerina Elasticsearch Cloud API connector.

## Running Tests

### Prerequisites

You need an API key from Elasticsearch Cloud to run tests against the live API.
To obtain this, refer to the [Elastic Cloud API Documentation](https://www.elastic.co/guide/en/cloud/current/ec-api-authentication.html).

### Running Tests

There are two test environments for running the Elasticsearch connector tests. The default test environment is the mock server for Elasticsearch Cloud API. The other test environment is the actual Elasticsearch Cloud API.

You can run the tests in either of these environments and each has its own compatible set of tests.

#### Test Groups

| Environment | Test Group | Description |
|-------------|------------|-------------|
| `mock_tests` | Mock server for Elasticsearch Cloud API | Default Environment |
| `live_tests` | Elasticsearch Cloud API | Live API Environment |

### Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `environment` variable is set to `mock` before initiating the tests.
This environment variable can be configured within the `Config.toml` file located in the tests directory or specified as an environmental variable.

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory with the following content:

```toml
apiKey = "test-api-key-12345"
environment = "mock"
baseUrl = "http://localhost:8080"
testPrefix = "test_"
port = 8080
validApiKey = "test-api-key-12345"
```

#### Using Environment Variables

Alternatively, you can set your configuration as environment variables:

**If you are using Linux or Mac:**
```bash
export ELASTICSEARCH_ENVIRONMENT=mock
export ELASTICSEARCH_API_KEY=test-api-key-12345
export ELASTICSEARCH_BASE_URL=http://localhost:8080
```

**If you are using Windows:**
```cmd
setx ELASTICSEARCH_ENVIRONMENT mock
setx ELASTICSEARCH_API_KEY test-api-key-12345
setx ELASTICSEARCH_BASE_URL http://localhost:8080
```

Then, run the following commands to start the mock service and run tests:

```bash
# Terminal 1: Start mock service
bal run tests/mock_service.bal

# Terminal 2: Run tests
bal test
```

### Running Tests Against Elasticsearch Cloud Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials:

```toml
apiKey = "<your-elasticsearch-cloud-api-key>"
environment = "production"
baseUrl = "https://api.elastic-cloud.com/api/v1"
testPrefix = "test_"
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:

**If you are using Linux or Mac:**
```bash
export ELASTICSEARCH_ENVIRONMENT=production
export ELASTICSEARCH_API_KEY="<your-elasticsearch-cloud-api-key>"
export ELASTICSEARCH_BASE_URL="https://api.elastic-cloud.com/api/v1"
```

**If you are using Windows:**
```cmd
setx ELASTICSEARCH_ENVIRONMENT production
setx ELASTICSEARCH_API_KEY <your-elasticsearch-cloud-api-key>
setx ELASTICSEARCH_BASE_URL https://api.elastic-cloud.com/api/v1
```

Then, run the following command to run the tests:

```bash
bal test
```

### Getting Your Elasticsearch Cloud API Key

1. **Sign up for Elastic Cloud:** Go to [https://cloud.elastic.co](https://cloud.elastic.co)
2. **Create a free trial account** (14 days, no credit card required)
3. **Navigate to API Keys:** 
   - Click your avatar in the upper right corner
   - Choose "Organization"
   - Go to the "API Keys" tab
4. **Generate API Key:**
   - Click "Create API Key"
   - Give it a name and set permissions
   - **Copy the key immediately** (you can't see it again!)

### Test Configuration Options

You can also run tests with command-line overrides:

```bash
# Test against sandbox environment
bal test -e environment=sandbox -e apiKey=your-sandbox-key

# Test with custom base URL
bal test -e baseUrl=https://your-custom-endpoint.com

# Run specific test
bal test --tests testAccountEndpoint
```

### Available Test Endpoints

The test suite covers the following Elasticsearch Cloud API endpoints:

- `GET /account` - Account Information
- `GET /deployments` - List Deployments  
- `GET /deployments/templates` - Deployment Templates
- `GET /users/auth/keys` - API Keys Management
- `GET /organizations` - Organization Information

### Security Notes

⚠️ **Important Security Considerations:**

1. **Never commit real API keys** to version control
2. **Use environment variables** for sensitive data in CI/CD
3. **Add Config.toml to .gitignore** if it contains real credentials
4. **Start with mock environment** for development and testing
5. **Use sandbox/trial** before production testing

### Troubleshooting

#### Common Issues

- **Port 8080 already in use:** Change the port in `Config.toml`
- **Connection refused:** Ensure mock service is running before tests
- **401 Unauthorized:** Check your API key configuration
- **404 Not Found:** Verify endpoint URLs are correct

#### Health Check

To verify the mock service is running:

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

### Project Structure

```
elasticsearch-connector/
├── Ballerina.toml
└── tests/
    ├── Config.toml          # Test configuration
    ├── test.bal            # Test suite (8 comprehensive tests)
    └── mock_service.bal    # Mock Elasticsearch Cloud API service
```

### Contributing

1. **Always test with mock service first**
2. **Add new test cases for new endpoints**
3. **Follow the existing pattern for authentication and error handling**
4. **Update this README when adding new features**

For more information about the Elasticsearch Cloud API, visit the [official documentation](https://www.elastic.co/guide/en/cloud/current/ec-restful-api.html).