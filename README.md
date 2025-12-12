# Self-hosted Gitea on Scaleway

This repository provides infrastructure as code (IaC) to deploy a complete Gitea Git hosting service on Scaleway cloud platform with managed MySQL database.

## 🚀 Scaleway Cloud Deployment (Recommended)

Deploy your Gitea instance on Scaleway with managed MySQL database, automatic scaling, and HTTPS.

### What Gets Deployed

- **Scaleway RDB MySQL 8** - Managed database with automated backups
- **Scaleway Container** - Auto-scaling Gitea service with HTTPS endpoint
- **Secure Configuration** - Separate admin and application credentials
- **Cost Optimized** - Scales to zero when not in use, pay for actual usage

### Prerequisites

1. **Scaleway Account**: Sign up at [scaleway.com](https://scaleway.com)
2. **OpenTofu/Terraform**: Install [OpenTofu](https://opentofu.org/docs/intro/install/) or [Terraform](https://terraform.io/downloads.html)

### Authentication Setup

Get your Scaleway credentials from the [Scaleway Console](https://console.scaleway.com/):

1. **API Keys**: Go to IAM → API Keys
2. **Organization ID**: Found in Organization Settings  
3. **Project ID**: Found in your project dashboard

### Quick Deploy

1. **Configure your credentials:**
   ```bash
   cd gitea/terraform
   cp terraform.tfvars.example terraform.tfvars
   nano terraform.tfvars
   ```

2. **Add your Scaleway credentials and secure passwords:**
   ```hcl
   # Scaleway Authentication
   access_key = "your-scaleway-access-key"
   secret_key = "your-scaleway-secret-key" 
   organization_id = "your-organization-id"
   project_id = "your-project-id"
   
   # Security credentials (generate strong passwords)
   mysql_password = "secure-admin-password-here"
   mysql_app_password = "secure-app-password-here"
   gitea_secret_key = "64-char-secret-key-generate-with-openssl-rand-hex-32"
   ```

3. **Deploy your Gitea infrastructure:**
   ```bash
   make gitea.tofu-init     # Initialize OpenTofu
   make gitea.tofu-plan     # Review deployment plan
   make gitea.tofu-apply    # Deploy infrastructure
   ```

4. **Access your Gitea instance:**
   ```bash
   # Get your Gitea URL
   cd gitea/terraform
   tofu output gitea_url
   ```

### Available Commands

**OpenTofu (Recommended):**
```bash
make gitea.tofu-init     # Initialize OpenTofu
make gitea.tofu-plan     # Plan deployment
make gitea.tofu-apply    # Deploy infrastructure  
make gitea.tofu-destroy  # Destroy infrastructure
```

**Terraform (Alternative):**
```bash
make gitea.tf-init       # Initialize Terraform
make gitea.tf-plan       # Plan deployment
make gitea.tf-apply      # Deploy infrastructure
make gitea.tf-destroy    # Destroy infrastructure
```

### Post-Deployment Setup

1. **Open your Gitea URL** (from `tofu output gitea_url`)
2. **Complete initial setup** - database settings are pre-configured
3. **Create admin account** and configure your Git hosting service
4. **Start using Git** - push repositories, manage users, etc.

## 🏠 Local Development (Docker Compose)

For local development and testing, you can run Gitea with MySQL using Docker Compose.

### Quick Local Setup

1. **Configure environment:**
   ```bash
   cd gittea
   cp .env.example .env
   nano .env  # Set your preferred passwords
   ```

2. **Start services:**
   ```bash
   cd ..  # back to project root
   make gitea.start
   ```

3. **Access locally:**
   - **Gitea Web**: http://localhost:8080
   - **SSH Git**: localhost:2221  
   - **MySQL**: localhost:3306

### Local Commands

```bash
make gitea.start    # Start Gitea and MySQL
make gitea.logs     # View service logs
make gitea.clean    # Stop and remove all data
make help          # Show all commands
```

### Data Persistence

Local data is stored in:
- `gittea/data/` - Gitea repositories and settings
- `gittea/config/` - Gitea configuration files
- Docker volume - MySQL database data

**Note**: For production use, deploy to Scaleway cloud instead of running locally.

## 🛠️ Development & Contributing

### Project Structure

```
gitea/
├── terraform/          # Infrastructure as Code
│   ├── main.tf         # Scaleway resources
│   ├── variables.tf    # Configuration variables
│   ├── outputs.tf      # Deployment outputs
│   └── terraform.tfvars.example
├── docker-compose.yml  # Local development
├── .env.example       # Local environment template
└── init/              # MySQL initialization scripts
```

### Available Make Targets

Run `make help` to see all available commands for both cloud deployment and local development.