# **Elastic Cloud API Key Management**

This use case demonstrates how the Elastic Cloud API can be utilized to manage API keys programmatically. The example involves a sequence of actions that leverage the Elastic Cloud API to automate API key management:

- Creating a new API key with descriptive information
- Listing all existing API keys in the account
- Deleting the created API key to demonstrate cleanup

## **Prerequisites**

### **1. Setup Elastic Cloud account**
Create an Elastic Cloud account and generate an API key with appropriate permissions for API key management.

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