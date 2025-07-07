## Overview


Elastic Cloud is a powerful cloud-hosted Elasticsearch service provided by Elastic, offering scalable search and analytics capabilities with enterprise-grade security and management features.

The `ballerinax/elastic.elasticcloud` package offers APIs to connect and interact with Elastic Cloud API endpoints, enabling seamless integration with Elasticsearch deployments, cluster management, security configurations, and data operations.

## Setup guide

### Step 1: Sign up for an Elastic Cloud account

1. Visit the [Elastic Cloud registration page](https://cloud.elastic.co/registration).
2. Fill in your account details including email, password, and organization information.
3. Verify your email address by clicking the verification link sent to your email.
4. Complete your profile setup and accept the terms of service.
5. Choose your subscription plan (you can start with the free trial).

### Step 2: Log in to your Elastic Cloud account

1. Go to the [Elastic Cloud login page](https://cloud.elastic.co/login).
2. Enter your email and password credentials.
3. You can also sign in using Google, Microsoft, or SSO if configured.

![Elastic Cloud Login](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-console-login.png)


### Step 3: Access the Elastic Cloud console

1. After successful login, you will be redirected to the main dashboard.
2. Here you can see your hosted deployments and manage serverless projects.
3. The dashboard shows your deployment status, version, and available actions.

![Elastic Cloud Dashboard](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-console-dashboard.png)

### Step 3: Create an Elastic Cloud deployment

1. Open the [Elastic Cloud Console](https://cloud.elastic.co/).
2. Click on "Create deployment" to set up a new Elasticsearch cluster.

![Elastic Cloud Console](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-console-deployment.png)

3. Choose your deployment configuration:
   - Select your cloud provider (AWS, Google Cloud, or Azure)
   - Choose your region
   - Configure your deployment size and features
4. Click "Create deployment" and wait for it to be ready.

![Elastic Cloud Create Deployment](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-create-deployment.png)

### Step 4: Navigate to Organization settings

1. From the dashboard, click on "Organization" in the top navigation.
2. Go to the organization management page where you can manage members, contacts, API keys, and security settings.
3. You will see your organization details including the Organization ID.

![Organization Settings](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-console-organization.png)

### Step 5: Create API keys

1. In the organization settings, click on the "API keys" tab.
2. You will see a list of existing API keys and can create new ones.
3. Click the "Create API key" button to generate new credentials.

![API Keys Management](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-console-api-create.png)

### Step 6: Configure Your API key

1. In the "Create API key" dialog, provide the following details:
   - **Add name**: Enter a unique name for your API key (e.g., "Ballerina Connector")
   - **Set expiration**: Choose an appropriate expiration period (3 months, 6 months, or 1 year)
   - **Assign roles**: Select appropriate permissions for your use case

2. The API key is specifically for Elastic Cloud APIs and provides access to organization and deployment management.
3. Click "Create API key" to generate your credentials.

![Generate API Key](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/refs/heads/main/docs/setup/resources/elastic-cloud-generate-api-key.png)

4. **Important**: Copy and securely store the generated API key as it won't be shown again.

### Step 7: Set environment variables or create Config.toml

You have an option for configuring your credentials securely:

#### Create Config.toml file

Create a `Config.toml` file in your project root directory with the following content:

```toml
# Elastic Cloud Configuration
apiKey = "<Your API Key>"
```

> **Note**: Make sure to add `Config.toml` to your `.gitignore` file to avoid committing sensitive credentials to version control.

## Quickstart

To use the `Elasticcloud` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `elasticcloud` module.

```ballerina
import ballerinax/elastic.elasticcloud;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained credentials in the above steps as follows:

```bash
apiKey = "<Your API Key>"
```

2. Create an `elasticcloud:ApiKeysConfig` with the obtained API key and initialize the connector with it.

```ballerina
configurable string apiKey = ?;

final elasticcloud:Client elasticClient = check new({
    authorization: "ApiKey " + apiKey
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a deployment

```ballerina
public function main() returns error? {
    elasticcloud:DeploymentCreateRequest newDeploymentRequest = {
        name: "my-ballerina-deployment",
        region: "gcp-asia-south1",
        version: "8.17.0"
    };

    elasticcloud:CreateDeploymentQueries queries = {
        template_id: "gcp-general-purpose"
    };

    elasticcloud:DeploymentCreateResponse deployment = check elasticClient->/deployments.post(
        newDeploymentRequest,
        queries = queries
    );
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Elasticcloud` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/tree/main/examples/), covering the following use cases:

1. [**Manage Deployment**](https://github.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/tree/main/examples/deployment-management) - Create, list, and manage Elasticsearch deployments in your organization.

2. [**API key Management**](https://github.com/ballerina-platform/module-ballerinax-elastic.elasticcloud/tree/main/examples/api-key-management/) - Create, list, and delete API keys for secure access to Elastic Cloud resources.
