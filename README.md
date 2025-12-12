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
   make docker
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
make docker
# or
make gitea

# View logs for all services
make logs

# Stop and clean up everything (removes data!)
make clean

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

## Next Steps

- Complete Gitea initial setup via web interface
- Create Terraform configurations for Scaleway deployment
- Set up CI/CD pipelines
- Add additional services (e.g., reverse proxy, monitoring)