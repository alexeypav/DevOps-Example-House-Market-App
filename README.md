# DevOps-Example-House-Market-App
Example of an app that uses Cloud/IAC/Container/PaaS

This gets data from TradeMe.co.nz and RealEstate.co.nz on number of daily house listings into a SQL Database, and displays the data on a basic HTML page.

WebApp Frontend

Azure SQL Database

ACI container

Pipelines are made for AzureDevops

Steps to run:

Import Repo

Import Pipelines

Create a Storage Account in Azure Subscription and upload the Database Template (TO DO make sql script)

Run Build and Deploy for Terraform

Run Build and Deploy for App

Run Container Build

Schedule ACI run - (RunContainerInstance.ps1) - TO DO make logic app for this
