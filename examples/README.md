# Examples

The `ballerinax/elasticsearch` connector provides practical examples illustrating usage in various scenarios.

1. [Manage Deployment](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/tree/main/examples/deployment-management) - Create, list, and manage Elasticsearch deployments in your organization.

2. [API key Management](https://github.com/ballerina-platform/module-ballerinax-elasticsearch/tree/main/examples/api-key-management/) - Create, list, and delete API keys for secure access to Elastic Cloud resources.

## Prerequisites

### **1. Setup Elastic Cloud account**
Create an Elastic Cloud account and generate an API key with appropriate permissions for API key management.

### **2. Configuration**
Create a `Config.toml` file in the example's root directory and provide your Elastic Cloud API key configuration as follows:

```toml
elasticApiKey = "<Your-Elastic-API-Key>"
```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
