.PHONY: gitea.start gitea.logs gitea.clean gitea.tofu-init gitea.tofu-plan gitea.tofu-apply gitea.tofu-destroy gitea.tf-init gitea.tf-plan gitea.tf-apply gitea.tf-destroy help

# Default target
help:
	@echo "Available Gitea commands:"
	@echo "  Local Development:"
	@echo "    make gitea.start       - Start Gitea and MySQL services"
	@echo "    make gitea.logs        - Follow logs for all services"
	@echo "    make gitea.clean       - Stop and remove all containers and volumes"
	@echo ""
	@echo "  OpenTofu Deployment:"
	@echo "    make gitea.tofu-init   - Initialize OpenTofu"
	@echo "    make gitea.tofu-plan   - Plan OpenTofu deployment"
	@echo "    make gitea.tofu-apply  - Apply OpenTofu configuration"
	@echo "    make gitea.tofu-destroy - Destroy OpenTofu resources"
	@echo ""
	@echo "  Terraform Deployment:"
	@echo "    make gitea.tf-init     - Initialize Terraform"
	@echo "    make gitea.tf-plan     - Plan Terraform deployment"
	@echo "    make gitea.tf-apply    - Apply Terraform configuration"
	@echo "    make gitea.tf-destroy  - Destroy Terraform resources"
	@echo ""
	@echo "    make help             - Show this help message"

# Start Gitea services
gitea.start:
	@echo "Starting Gitea and MySQL services..."
	cd gitea && docker-compose up -d
	@echo "Services are starting up..."
	@echo "Gitea will be available at http://localhost:8080"
	@echo "MySQL is available at localhost:3306"
	@echo "Run 'make gitea.logs' to view logs"

# View logs
gitea.logs:
	@echo "Following logs for all services..."
	cd gitea && docker-compose logs -f

# Clean up Docker resources
gitea.clean:
	@echo "Stopping and removing containers..."
	cd gitea && docker-compose down
	@echo "Removing volumes (this will delete all data)..."
	cd gitea && docker-compose down -v
	@echo "Cleanup complete."

# OpenTofu commands
gitea.tofu-init:
	@echo "Initializing OpenTofu..."
	cd gitea/terraform && tofu init

gitea.tofu-plan:
	@echo "Planning OpenTofu deployment..."
	cd gitea/terraform && tofu plan

gitea.tofu-apply:
	@echo "Applying OpenTofu configuration..."
	cd gitea/terraform && tofu apply --auto-approve

gitea.tofu-destroy:
	@echo "Destroying OpenTofu resources..."
	cd gitea/terraform && tofu destroy --auto-approve

# Terraform commands
gitea.tf-init:
	@echo "Initializing Terraform..."
	cd gitea/terraform && terraform init

gitea.tf-plan:
	@echo "Planning Terraform deployment..."
	cd gitea/terraform && terraform plan

gitea.tf-apply:
	@echo "Applying Terraform configuration..."
	cd gitea/terraform && terraform apply --auto-approve

gitea.tf-destroy:
	@echo "Destroying Terraform resources..."
	cd gitea/terraform && terraform destroy --auto-approve