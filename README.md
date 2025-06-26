# Ballerina Elasticsearch connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-elasticsearch.svg)](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/elasticsearch.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%elasticsearch)

## Overview

[//]: # (TODO: Add overview mentioning the purpose of the module, supported REST API versions, and other high-level details.)

Elastic Cloud is a powerful cloud-hosted Elasticsearch service provided by Elastic, offering scalable search and analytics capabilities with enterprise-grade security and management features.

The `ballerinax/elasticcloud` package offers APIs to connect and interact with Elastic Cloud API endpoints, enabling seamless integration with Elasticsearch deployments, cluster management, security configurations, and data operations.

## Setup guide

[//]: # (TODO: Add detailed steps to obtain credentials and configure the module.)

### Step 1: Sign up for an Elastic Cloud Account

1. Visit the [Elastic Cloud registration page](https://cloud.elastic.co/registration).
2. Fill in your account details including email, password, and organization information.
3. Verify your email address by clicking the verification link sent to your email.
4. Complete your profile setup and accept the terms of service.
5. Choose your subscription plan (you can start with the free trial).

### Step 2: Log in to your Elastic Cloud Account

1. Go to the [Elastic Cloud login page](https://cloud.elastic.co/login).
2. Enter your email and password credentials.
3. You can also sign in using Google, Microsoft, or SSO if configured.

![Elastic Cloud Login](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elasticsearch/refs/heads/main/docs/setup/resources/elastic-cloud-console-login.png)


### Step 3: Access the Elastic Cloud Console

1. After successful login, you will be redirected to the main dashboard.
2. Here you can see your hosted deployments and manage serverless projects.
3. The dashboard shows your deployment status, version, and available actions.

![Elastic Cloud Dashboard](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elasticsearch/refs/heads/main/docs/setup/resources/elastic-cloud-console-dashboard.png)

### Step 3: Create an Elastic Cloud Deployment

1. Open the [Elastic Cloud Console](https://cloud.elastic.co/).
2. Click on "Create deployment" to set up a new Elasticsearch cluster.

![Elastic Cloud Console](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elasticsearch/refs/heads/main/docs/setup/resources/elastic-cloud-console-deployment.png)

3. Choose your deployment configuration:
   - Select your cloud provider (AWS, Google Cloud, or Azure)
   - Choose your region
   - Configure your deployment size and features
4. Click "Create deployment" and wait for it to be ready.

### Step 4: Navigate to Organization Settings

1. From the dashboard, click on "Organization" in the top navigation.
2. Go to the organization management page where you can manage members, contacts, API keys, and security settings.
3. You will see your organization details including the Organization ID.

![Organization Settings](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elasticsearch/refs/heads/main/docs/setup/resources/elastic-cloud-console-organization.png)

### Step 5: Create API Keys

1. In the organization settings, click on the "API keys" tab.
2. You will see a list of existing API keys and can create new ones.
3. Click the "Create API key" button to generate new credentials.

![API Keys Management](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-elasticsearch/refs/heads/main/docs/setup/resources/elastic-cloud-console-api-create.png)

### Step 6: Configure Your API Key

1. In the "Create API key" dialog, provide the following details:
   - **Add name**: Enter a unique name for your API key (e.g., "Ballerina Connector")
   - **Set expiration**: Choose an appropriate expiration period (3 months, 6 months, or 1 year)
   - **Assign roles**: Select appropriate permissions for your use case

2. The API key is specifically for Elastic Cloud APIs and provides access to organization and deployment management.
3. Click "Create API key" to generate your credentials.
4. **Important**: Copy and securely store the generated API key as it won't be shown again.

### Step 7: Set Environment Variables or Create Config.toml

You have two options for configuring your credentials securely:

#### Option A: Set Environment Variables (Recommended for Production)

**For Linux/MacOS:**
```bash
export IS_LIVE_SERVER=true
export ELASTIC_API_KEY="<Your API Key>"
```

**For Windows:**
```cmd
set IS_LIVE_SERVER=true
set ELASTIC_API_KEY=<Your API Key>
```

#### Option B: Create Config.toml File (Good for Development)

Create a `Config.toml` file in your project root directory with the following content:

```toml
# Elastic Cloud Configuration
isLiveServer=true
apiKey = "<Your API Key>"

```

> **Note**: Make sure to add `Config.toml` to your `.gitignore` file to avoid committing sensitive credentials to version control.

## Quickstart

To use the `Elasticsearch` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `elasticcloud` module.

```ballerina
import ballerinax/elastic.elasticcloud;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained credentials in the above steps as follows:

```bash
elasticApiKey = "<Your API Key>"
```

2. Create an `elasticcloud:ApiKeysConfig` with the obtained API key and initialize the connector with it.

```ballerina
configurable string elasticApiKey = ?;

final elasticcloud:Client elasticClient = check new({
    authorization: "ApiKey " + elasticApiKey
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

The `Elasticsearch` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/tree/main/examples/), covering the following use cases:

1. [Deployment](https://github.com/yasithrashan/module-ballerinax-elasticsearch/tree/examples/examples/deloyments) - Create, list, and manage Elasticsearch deployments in your organization.

2. [API key handle](https://github.com/yasithrashan/module-ballerinax-elasticsearch/tree/examples/examples/api-key-handle/) - Create, list, and delete API keys for secure access to Elastic Cloud resources.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`elasticsearch` package](https://central.ballerina.io/ballerinax/elasticsearch/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
