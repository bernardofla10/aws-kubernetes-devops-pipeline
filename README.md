# AWS Kubernetes DevOps Pipeline

End-to-end DevOps project focused on building and automating a cloud-native infrastructure and application delivery workflow using **AWS, Terraform, Docker, GitHub Actions, Kubernetes and Argo CD**.

This repository follows the implementation of a complete DevOps architecture, starting from Infrastructure as Code and evolving into CI/CD, GitOps, HTTPS automation and Kubernetes observability.

## Project Goals

The main goal of this project is to understand and implement a complete DevOps workflow covering:

* Infrastructure as Code with Terraform
* Cloud infrastructure on AWS
* Automated infrastructure deployment with GitHub Actions
* Secure promotion of third-party container artifacts
* Container image storage with Amazon ECR
* Trivy vulnerability gates, SBOMs and artifact attestations
* Kubernetes workloads
* Continuous Integration pipelines
* GitOps and Continuous Delivery with Argo CD
* HTTPS certificates with Cert-Manager and Let's Encrypt
* Kubernetes monitoring with Prometheus and Grafana

## Architecture

The project will evolve toward the following workflow:

```text
Developer
    |
    | git push
    v
 GitHub
    |
    +-------------------------------+
    |                               |
    v                               v
Infrastructure Pipeline       Application Pipeline
 GitHub Actions                GitHub Actions
    |                               |
 Terraform                   Pinned OCI Image
    |                               |
    v                         Security Gate
   AWS                              |
    |                               v
    |                    Amazon ECR + Attestations
    |                               |
    +---------------+---------------+
                    |
                    v
               Kubernetes
                    |
                    v
                 Argo CD
                    |
                    v
               Application
                    |
              Ingress / TLS
                    |
                    v
                  HTTPS
```

The Kubernetes environment will also include an observability stack:

```text
Kubernetes
    |
    v
Prometheus
    |
    v
Grafana
```

## Technologies

The project will use:

* **AWS**
* **Terraform**
* **Git**
* **GitHub**
* **GitHub Actions**
* **Docker**
* **Amazon ECR**
* **Kubernetes**
* **Amazon EKS**
* **Argo CD**
* **Cert-Manager**
* **Let's Encrypt**
* **Prometheus**
* **Grafana**

## Project Roadmap

The project is divided into seven stages.

### 1. Architecture and Project Overview

* Understand the complete DevOps architecture
* Understand the responsibilities of each technology
* Separate infrastructure, CI, CD and observability workflows

### 2. Infrastructure as Code with Terraform

* Configure Terraform
* Provision AWS infrastructure
* Configure networking and permissions
* Provision the Kubernetes environment
* Create required AWS resources

### 3. Infrastructure CI/CD

* Create GitHub Actions workflows
* Automate Terraform execution
* Validate infrastructure changes
* Deploy infrastructure to AWS automatically

### 4. Application CI

* Pin the upstream Vaultwarden image by platform-specific digest
* Block promotion on fixable HIGH or CRITICAL vulnerabilities
* Authenticate to AWS through GitHub OIDC without static access keys
* Promote the exact approved artifact to immutable Amazon ECR tags
* Generate a CycloneDX SBOM and OCI provenance/SBOM attestations

### 5. Kubernetes and GitOps

* Deploy workloads to Kubernetes
* Configure Argo CD
* Implement GitOps
* Configure Ingress
* Configure Cert-Manager
* Generate HTTPS certificates with Let's Encrypt

### 6. Observability

* Install the Kubernetes monitoring stack
* Configure Prometheus
* Configure Grafana
* Monitor cluster resources and workloads

### 7. Project Review

* Review the complete architecture
* Validate the CI/CD workflow
* Review DevOps concepts and best practices
* Document lessons learned and possible improvements

## CI/CD Flow

### Infrastructure

```text
Terraform Code
      |
      v
    GitHub
      |
      v
GitHub Actions
      |
      v
Terraform Plan / Apply
      |
      v
     AWS
```

### Application

```text
Pinned Upstream Image
       |
       v
     GitHub
       |
       v
 GitHub Actions
       |
       v
 Security Gate
       |
       v
 CycloneDX SBOM
       |
       v
  Amazon ECR
       |
       v
 OCI Attestations
```

### Continuous Delivery

```text
Git Repository
      |
      v
    Argo CD
      |
      v
 Kubernetes
      |
      v
 Application
```

## Repository Structure

The repository structure will evolve throughout the project.

```text
aws-kubernetes-devops-pipeline/
│
├── terraform/
│
├── app/
│   └── upstream-image.json
│
├── kubernetes/
│
├── .github/
│   └── workflows/
│
├── docs/
│
└── README.md
```

## Learning Objectives

By the end of this project, the goal is to understand how to:

* Provision cloud infrastructure using Infrastructure as Code
* Automate infrastructure deployments
* Safely promote immutable third-party container images
* Generate and attach supply-chain metadata to OCI artifacts
* Deploy applications to Kubernetes
* Implement CI/CD pipelines
* Apply GitOps principles
* Manage HTTPS certificates automatically
* Monitor Kubernetes workloads and infrastructure

## Author

**Bernardo de Castro**

Computer Engineering student at the Military Institute of Engineering (IME).

Focused on DevOps, Platform Engineering, Cloud Infrastructure and Backend Systems.
