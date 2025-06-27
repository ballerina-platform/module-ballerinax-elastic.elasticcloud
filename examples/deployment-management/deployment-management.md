# **Elastic Cloud Deployment Management**

This use case demonstrates how the Elastic Cloud API can be utilized to manage deployments programmatically. The example involves a sequence of actions that leverage the Elastic Cloud API to automate deployment management:

- Creating a new deployment with specified configuration
- Listing all existing deployments in the account
- Searching deployments using various criteria

## **Prerequisites**

### **1. Setup Elastic Cloud account**
Create an Elastic Cloud account and generate an API key with appropriate permissions for deployment management.

### **2. Configuration**
Create a `Config.toml` file in the example's root directory and provide your Elastic Cloud API key configuration as follows:

```toml
elasticApiKey = "<Your-Elastic-API-Key>"
```

## **Run the example**

Execute the following command to run the example:

```bash
bal run
```