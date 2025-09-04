# My First Automated CI/CD Pipeline

![CI/CD Workflow Status](https://github.com/shivamchaubey027/automated-pipeline/actions/workflows/deploy.yml/badge.svg)

It has always been an issue for me while building an application. The old way—manually containerizing it, SSHing into the EC2 server, and pushing it on there—is slow, repetitive, and just doesn't scale. I learned about CI/CD pipelines as a way to automate the whole process of getting an application into production.

---

## How It Works

The whole process is like a Rube Goldberg machine that starts with a simple `git push`.

### 1. Building the Field (Infrastructure as Code with Terraform)

First, you have to build the entire infrastructure without clicking a single button on the AWS website. I used Terraform to define everything as code. This is like asking for an empty ground, putting up a fence, and building roads before any of the real work starts. The Terraform code automatically provisions:

* A **VPC** (our private field on AWS).
* A public **subnet** (the specific plot of land for our server).
* An **EC2 instance** (the server that will host the application).
* An **ECR repository** (a private place to keep our Docker images).
* **Security Groups** (the security guards who only let the right traffic in).

### 2. Packaging the App (Containerization with Docker)

The Node.js application is packaged into a lightweight, consistent container using a **multi-stage Dockerfile**. This ensures the app runs the same way everywhere and keeps the final image small and secure.

### 3. The Automation Brain (The `deploy.yml` Workflow)

This is where the magic happens. A GitHub Actions workflow file (`deploy.yml`) acts as the brain for the whole operation. Once you `git push` your code, it kicks off a series of automated steps:

* **Build & Push:** It builds a new Docker image from the latest code and pushes it to our private ECR repository.
* **Deploy:** It then securely SSHes into the EC2 instance, pulls the new image from ECR, stops the old container, and starts the new one, making the update live instantly.

The result is a complete "Git Push to Production" pipeline. Now, instead of a painful manual process, I can deploy new features just by pushing my code.
