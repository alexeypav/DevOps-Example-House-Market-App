# DevOps Example: House Market App

This repository contains an example app demonstrating the use of cloud services, Infrastructure as Code (IaC), containers, and Platform as a Service (PaaS). The app collects data on daily house listings from TradeMe.co.nz and RealEstate.co.nz, stores it in an Azure SQL Database, and displays it on a basic HTML page.

## Components

- **WebApp Frontend**: Serves the user interface.
- **Azure SQL Database**: Stores house listing data.
- **ACI (Azure Container Instances)**: Runs the containerized app.
- **Azure DevOps Pipelines**: Manages the CI/CD process for deploying and maintaining the app.

## Steps to Run

1. **Import Repository**: Clone or import the repository into your Azure DevOps project.
2. **Import Pipelines**: Add the CI/CD pipelines from the `pipelines` directory to your Azure DevOps project.
3. **Create a Storage Account**:
   - Create a Storage Account in your Azure Subscription.
   - Upload the Database Template provided in the `database` directory.
4. **Run Build and Deploy for Terraform**: Execute the Terraform configuration to set up the required infrastructure.
5. **Run Build and Deploy for App**: Deploy the application using the configured pipelines.
6. **Run Container Build**: Build the container image for the ACI deployment.
7. **Schedule ACI Run**:
   - Execute the `RunContainerInstance.ps1` script to run the container instance.
   - *TODO*: Replace the script execution with a Logic App for automated scheduling.

## Potential Improvements

- Automate container scheduling with Azure Logic Apps to enhance operational efficiency.
- Optimize database queries and indexing to improve data retrieval speeds.
- Enhance the WebApp frontend with responsive design and interactive data visualizations.

