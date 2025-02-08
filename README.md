# lovevery-devops-exercise

## Build Application
### 1. Build Docker Image
To build the Docker image for this application, run the following command:

```sh
docker build -t devops_exercise:<environment> .
```

This will create a Docker image for the specified environment.

> **Note:** This exercise was tested with `minikube` without using a real container registry. To ensure proper functionality, the deployment is configured with `pullPolicy: Never`. The images must be built locally using the Minikube Docker configuration:
> 
> ```sh
> eval $(minikube docker-env)
> ```

### 2. Deploy Application to Kubernetes

#### Step 1: Navigate to the Terraform directory
Go to the Terraform directory corresponding to the environment you want to deploy:

```sh
cd terraform/envs/<environment>/
```

#### Step 2: Configure Credentials
Set the required `Kubernetes` and `AWS` credentials in the `providers.tf` file.

#### Step 3: Initial Deployment
If this is the first deployment of the environment:

1. Run Terraform with the `-target` flag to create the AWS Secrets Manager secret:

    ```sh
    terraform apply -target=module.main.aws_secretsmanager_secret.env
    ```

2. Create a `secrets.json` file with all necessary secrets:

    ```json
    {
        "SECRET_KEY_BASE": "1a2b3c4d",
        "SECRET": "S3CR3T VALU3"
    }
    ```

3. Upload the `secrets.json` content to AWS Secrets Manager:

    ```sh
    awslocal secretsmanager put-secret-value --secret-id "devops-exercise-<environment>/env" --secret-string file://secrets.json
    ```

#### Step 4: Deploy the Application
Run the following command to deploy the application to the Kubernetes cluster:

```sh
terraform apply
```

---

## Terraform State Management
The Terraform code in this repository is structured to be executed from `terraform/envs/<environment>/`, allowing each environment to have its own `providers.tf` and `backend.tf` files.

This setup ensures that each environment can maintain its Terraform state file separately by hosting the `S3 Bucket` in the appropriate AWS account. This approach enables complete resource isolation in a multi-account AWS architecture while using the same Terraform manifest files across all environments.

---

## Secrets and Variables Management
This project uses **AWS Secrets Manager** to handle sensitive variables securely. The Terraform configuration is responsible for creating the secret in **AWS Secrets Manager**, but the secret's content must be manually populated.

Once the secret is created and populated, Terraform retrieves the data and creates a **Kubernetes Secret**, making the necessary credentials available to the running application.

---

## Monitoring the Application
To effectively monitor this infrastructure, it is highly recommended to integrate an external tool for Application Performance Monitoring (APM), such as:
- **DataDog**
- **NewRelic**
- **OpenTelemetry**

These tools can track important application-level metrics, such as:
- **Apdex Score** (User Satisfaction Index)
- **Transaction Time**
- **Throughput** (Requests per second)
- **Error Rate** (Exceptions, Failures)

For infrastructure monitoring, you can use **Prometheus** and **Grafana** or integrate with tools like **DataDog** and **NewRelic** to monitor:
- **CPU Usage**
- **Memory Utilization**
- **Kubernetes Events**
- **Custom Metrics**

This monitoring strategy ensures visibility into both application performance and infrastructure health.
