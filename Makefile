.PHONY: docker gitea clean logs help

# Default target
help:
	@echo "Available commands:"
	@echo "  make docker    - Start Gitea and MySQL services"
	@echo "  make gitea     - Start Gitea and MySQL services (alias for docker)"
	@echo "  make logs      - Follow logs for all services"
	@echo "  make clean     - Stop and remove all containers and volumes"
	@echo "  make help      - Show this help message"

# Start Docker services
docker: gitea

# Start Gitea services
gitea:
	@echo "Starting Gitea and MySQL services..."
	cd gittea && docker-compose up -d
	@echo "Services are starting up..."
	@echo "Gitea will be available at http://localhost:8080"
	@echo "MySQL is available at localhost:3306"
	@echo "Run 'make logs' to view logs"

# View logs
logs:
	@echo "Following logs for all services..."
	cd gittea && docker-compose logs -f

# Clean up Docker resources
clean:
	@echo "Stopping and removing containers..."
	cd gittea && docker-compose down
	@echo "Removing volumes (this will delete all data)..."
	cd gittea && docker-compose down -v
	@echo "Cleanup complete."