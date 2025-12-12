# Self-hosted Services on Scaleway

This repository contains the infrastructure as code (IaC) for self-hosting services on Scaleway.

## Local Development with Docker Compose

### Gitea Git Service with MySQL

This docker-compose setup provides a complete Gitea Git service with MySQL 8.0 database backend.

#### Quick Start

1. **Navigate to the gitea directory and copy the environment file:**
   ```bash
   cd gittea
   cp .env.example .env
   ```

2. **Edit the `.env` file** with your preferred database credentials:
   ```bash
   nano .env
   ```

3. **Start the services:**
   ```bash
   cd .. # back to project root
   make gitea.start
   ```

4. **Access Gitea:**
   - Open http://localhost:8080 in your browser
   - Follow the initial setup wizard
   - Database settings will be pre-configured

#### Services

**Gitea Server:**
- **Web Interface:** http://localhost:8080
- **SSH Git Access:** localhost:2221
- **Rootless container** for security

**MySQL Database:**
- **Host:** localhost:3306
- **Database:** selfhosted (or as configured in .env)
- **Username:** selfhosted_user (or as configured in .env)
- **Password:** As set in .env file

#### Features

- **Gitea 1.25.2** rootless container
- **MySQL 8.0** with persistent data storage
- **Health checks** to ensure database is ready
- **Environment variable** configuration
- **Initialization scripts** support in `gittea/init/`
- **Persistent data** for both Gitea and MySQL
- **Custom network** for service communication

#### Useful Commands

**Using Make (Recommended):**
```bash
# Start Gitea and MySQL services
make gitea.start

# View logs for all services
make gitea.logs

# Stop and clean up everything (removes data!)
make gitea.clean

# Show available commands
make help
```

**Direct Docker Compose (from gittea/ directory):**
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes (WARNING: This will delete your data)
docker-compose down -v
```

#### Adding MySQL Initialization Scripts

Place any `.sql` files in the `gittea/init/` directory. These will be executed in alphabetical order when the MySQL container starts for the first time.

#### Data Persistence

- **Gitea data:** Stored in `gittea/data/`
- **Gitea config:** Stored in `gittea/config/`
- **MySQL data:** Stored in Docker volume `mysql_data`

## Scaleway Deployment with Terraform

Deploy a managed MySQL database on Scaleway cloud infrastructure.

### Prerequisites

1. **Scaleway Account**: Sign up at [scaleway.com](https://scaleway.com)
2. **Terraform**: Install from [terraform.io](https://terraform.io/downloads.html)
3. **Scaleway CLI** (optional): Install with `brew install scw` (macOS)

### Authentication Setup

You'll need your Scaleway credentials from the [Scaleway Console](https://console.scaleway.com/):

1. **API Keys**: Go to IAM → API Keys
2. **Organization ID**: Found in Organization Settings
3. **Project ID**: Found in your project dashboard

#### Option 1: Configure in terraform.tfvars (Recommended)
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your actual credentials
```

#### Option 2: Environment Variables
```bash
export SCW_ACCESS_KEY="your-access-key"
export SCW_SECRET_KEY="your-secret-key"
export SCW_DEFAULT_ORGANIZATION_ID="your-organization-id"
export SCW_DEFAULT_PROJECT_ID="your-project-id"
```

#### Option 3: Scaleway CLI
```bash
scw init
```

### Deployment Steps

1. **Copy and configure variables:**
   ```bash
   cd gittea/terraform
   cp terraform.tfvars.example terraform.tfvars
   nano terraform.tfvars
   ```

2. **Configure credentials and passwords** in `terraform.tfvars`:
   ```hcl
   # Add your Scaleway credentials
   access_key = "your-scaleway-access-key"
   secret_key = "your-scaleway-secret-key" 
   organization_id = "your-organization-id"
   project_id = "your-project-id"
   
   # Set a secure MySQL password
   mysql_password = "your-very-secure-password-here"
   ```

3. **Initialize and deploy:**
   ```bash
   make gitea.tf-init     # Initialize Terraform
   make gitea.tf-plan     # Review deployment plan
   make gitea.tf-apply    # Deploy infrastructure
   ```

### Terraform Commands

**Using Make (Recommended):**
```bash
# Initialize Terraform
make gitea.tf-init

# Plan deployment
make gitea.tf-plan

# Deploy infrastructure
make gitea.tf-apply

# Destroy infrastructure
make gitea.tf-destroy
```

**Direct Terraform (from gittea/terraform/ directory):**
```bash
cd gittea/terraform
terraform init
terraform plan
terraform apply
terraform destroy
```

### Infrastructure Details

The Terraform configuration creates:

- **Scaleway RDB MySQL 8 Instance** with:
  - `DB-DEV-S` node type (configurable)
  - 20GB SSD storage
  - Daily backups (7-day retention)
  - High availability disabled (for cost optimization)

- **Database and Users**:
  - Initial database: `selfhosted`
  - Admin user: `admin`
  - Application user: `selfhosted_user`

- **Outputs**:
  - Database endpoint and port
  - Connection strings
  - User credentials

### Connecting Your Application

After deployment, update your application configuration with the Terraform outputs:

```bash
# Get connection details
cd gittea/terraform
terraform output mysql_endpoint
terraform output mysql_port
terraform output mysql_connection_string
```

### Cost Optimization

- **Development**: Use `DB-DEV-S` (smallest instance)
- **Production**: Consider `DB-GP-XS` or larger based on needs
- **Backups**: Adjust retention period in `terraform.tfvars`

## Next Steps

- Complete Gitea initial setup via web interface
- Connect Gitea to Scaleway MySQL database
- Set up CI/CD pipelines
- Add additional services (e.g., reverse proxy, monitoring)
- Configure domain and SSL certificates