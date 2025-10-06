# My First Automated CI/CD Pipeline

![CI/CD Workflow Status](https://github.com/shivamchaubey027/automated-pipeline/actions/workflows/deploy.yml/badge.svg)

Building applications has always been a challenge for me, particularly when it comes to deployment. The traditional approach I used to follow was tedious: manually containerizing the application, SSHing into an EC2 server, and pushing everything manually. This process was not only slow and repetitive but also didn't go well as projects grew in complexity.

That's when I finally thought of CI/CD pipelines. I realized this was exactly what I needed to automate the entire production deployment process, eliminating the manual work and potential for human error.

---

## Architecture Overview
 
The pipeline I built follows a straightforward workflow that begins with a simple `git push` and ends with the application running in production. Here's how the entire system works:


## Infrastructure Setup with Terraform

Before automating deployments, I needed to establish a solid foundation. Instead of manually configuring AWS resources through the console, I used Terraform to define everything as Infrastructure as Code (IaC). This approach ensures reproducibility and makes the entire setup version-controlled.

The Terraform configuration provisions the following components:

* **VPC** - Creates an isolated network environment for the application
* **Public subnet** - Defines the network segment where the EC2 instance resides  
* **EC2 instance** - The compute resource that hosts the containerized application
* **ECR repository** - A private Docker registry for storing application images
* **Security Groups** - Network access control rules that restrict traffic to authorized sources only

## Application Containerization

The Node.js application is packaged using Docker with a multi-stage Dockerfile approach. This strategy keeps the final production image lightweight while ensuring consistent runtime behavior across different environments.

## Automated Deployment Pipeline

The core automation is handled by a GitHub Actions workflow defined in `deploy.yml`. This workflow executes whenever code is pushed to the repository and performs the following steps:

### Build and Push Phase
1. Builds a new Docker image incorporating the latest code changes
2. Tags the image appropriately for versioning
3. Pushes the image to the private ECR repository

### Deployment Phase  
1. Establishes a secure SSH connection to the EC2 instance
2. Pulls the newly built image from ECR
3. Stops the currently running container
4. Starts a new container with the updated image
5. Verifies the deployment was successful

## Results

This setup has changed my development workflow completely. What used to be a manual, error-prone process taking several minutes now happens automatically within seconds of pushing code. The entire "Git Push to Production" pipeline eliminates the operational overhead and allows me to focus on building features rather than managing deployments.

The combination of Infrastructure as Code, containerization, and automated CI/CD has made my development process significantly more reliable and efficient.
