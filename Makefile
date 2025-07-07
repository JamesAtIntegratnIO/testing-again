# testing-again Development Makefile
.PHONY: help dev dev-backend dev-frontend dev-backend-inner dev-frontend-inner dev-stop build test clean deploy db-up db-down db-reset db-logs redis-up redis-down redis-remove redis-logs services-up services-down docker-build docker-up docker-down score-generate score-up score-down score-restart score-build score-logs

# Default target
.DEFAULT_GOAL := help

# Project Configuration
PROJECT_NAME=testing-again

# Score.dev Configuration
SCORE_BACKEND=score-backend.yaml
SCORE_FRONTEND=score-frontend.yaml

# Check if we're in Nix environment
define check_nix_env
	if [ -z "$$IN_NIX_SHELL" ] && [ -z "$$NIX_PATH" ]; then \
		echo "⚠️  Not in Nix environment. Entering nix develop..."; \
		if command -v nix >/dev/null 2>&1; then \
			nix develop --command make $(1); \
		else \
			echo "❌ Nix is not installed or not in PATH"; \
			echo "   Please install Nix or run the command manually"; \
			exit 1; \
		fi; \
	else \
		echo "✅ Already in Nix environment or Nix available"; \
		make $(1); \
	fi
endef

help: ## Show this help message
	@echo "🚀 testing-again Development Commands"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "💡 Most commands auto-detect Nix environment and will run 'nix develop' if needed"
	@echo ""
	@echo "📦 Score.dev Commands (Recommended):"
	@echo "  score-up       Start full-stack app using Score.dev + Docker Compose"
	@echo "  score-down     Stop Score.dev services"
	@echo "  score-restart  Restart Score.dev services"
	@echo "  score-generate Generate compose.yaml from Score files"
	@echo ""
	@echo "🔧 Development Commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-nix: ## Check if we're in a Nix environment
	@if [ -n "$$IN_NIX_SHELL" ]; then \
		echo "✅ In Nix shell environment"; \
	elif [ -n "$$NIX_PATH" ]; then \
		echo "✅ Nix is available in PATH"; \
	else \
		echo "❌ Nix environment not detected"; \
		echo "   Run 'nix develop' first or use 'make dev' to enter Nix environment"; \
	fi

nix-shell: ## Enter Nix development environment
	@echo "🐚 Entering Nix development environment..."
	@nix develop

# Development targets
dev: ## Start development environment
	@$(call check_nix_env,dev-inner)

dev-inner:
	@echo "🔧 Starting development environment..."
	@echo "🚀 Starting full-stack development..."
	@$(MAKE) -j2 dev-backend-inner dev-frontend-inner

dev-backend: ## Start backend development
	@$(call check_nix_env,dev-backend-inner)

dev-backend-inner:
	@echo "📦 Installing Go dependencies..."
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go mod download
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go mod tidy
	@echo "🚀 Starting backend server..."
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go run cmd/server/main.go

dev-frontend: ## Start frontend development
	@$(call check_nix_env,dev-frontend-inner)

dev-frontend-inner:
	@echo "📦 Installing frontend dependencies..."
	cd frontend && npm install
	@echo "🚀 Starting frontend server..."
	cd frontend && npm run dev

dev-stop: ## Stop development services
	@echo "🛑 Stopping development services..."
	@echo "✅ Development services stopped"

# Build targets
build: ## Build the application
	@$(call check_nix_env,build-inner)

build-inner:
	@echo "🏗️  Building application..."
	@echo "🏗️  Building full-stack application..."
	@$(MAKE) build-backend
	@$(MAKE) build-frontend

build-backend:
	@echo "🏗️  Building Go backend..."
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go build -o bin/testing-again cmd/server/main.go

build-frontend:
	@echo "📦 Installing frontend dependencies..."
	cd frontend && npm install
	@echo "🏗️  Building frontend..."
	cd frontend && npm run build

# Test targets
test: ## Run tests
	@$(call check_nix_env,test-inner)

test-inner:
	@echo "🧪 Running tests..."
	@$(MAKE) test-backend
	@$(MAKE) test-frontend

test-backend:
	@echo "🧪 Running backend tests..."
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go test -v ./...

test-frontend:
	@echo "🧪 Running frontend tests..."
	cd frontend && npm test

# Clean target
clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	rm -rf frontend/node_modules frontend/dist frontend/build
	rm -rf backend/node_modules backend/dist backend/build
	rm -rf backend/bin/ backend/.go-cache backend/.go-mod-cache
	cd backend && GOCACHE=$$(pwd)/.go-cache GOMODCACHE=$$(pwd)/.go-mod-cache go clean

# Score.dev Commands (Recommended)
score-build: ## Build Docker images for Score.dev
	@echo "🐳 Building Docker images for Score.dev..."
	@docker build -t testing-again/backend:latest ./backend
	@docker build -t testing-again/frontend:latest ./frontend
	@echo "✅ Docker images built successfully"

score-generate: ## Generate compose.yaml from Score files
	@echo "📋 Generating compose.yaml from Score files..."
	@score-compose init --no-sample || true
	@score-compose generate $(SCORE_BACKEND) --publish 8080:8080
	@score-compose generate $(SCORE_FRONTEND) --publish 3000:3000
	@echo "✅ Generated compose.yaml from Score files"

score-up: ## Start full-stack app using Score.dev + Docker Compose
	@echo "🚀 Starting testing-again with Score.dev..."
	@make score-build
	@make score-generate
	@docker compose up -d
	@echo ""
	@echo "✅ testing-again is running!"
	@echo "🌐 Frontend: http://localhost:3000"
	@echo "🔧 Backend:  http://localhost:8080"
	@echo "📊 Health:   http://localhost:8080/health"

score-down: ## Stop Score.dev services
	@echo "🛑 Stopping Score.dev services..."
	@docker compose down
	@echo "✅ Services stopped"

score-restart: ## Restart Score.dev services
	@echo "🔄 Restarting Score.dev services..."
	@make score-down
	@make score-up

score-logs: ## View logs from Score.dev services
	@echo "📋 Viewing service logs..."
	@docker compose logs -f

# Legacy Score.dev targets (deprecated)
score-generate-legacy: ## Generate deployment manifests using Score (deprecated)
	@echo "📊 Generating deployment manifests..."
	@if [ -f "score.yaml" ]; then \
		echo "🎯 Generating Docker Compose from score.yaml..."; \
		score-compose generate score.yaml; \
		echo "🎯 Generating Kubernetes from score.yaml..."; \
		score-k8s generate score.yaml; \
	fi
	@if [ -f "score-backend.yaml" ]; then \
		echo "🎯 Generating Docker Compose from score-backend.yaml..."; \
		score-compose generate score-backend.yaml; \
		echo "🎯 Generating Kubernetes from score-backend.yaml..."; \
		score-k8s generate score-backend.yaml; \
	fi
	@if [ -f "score-frontend.yaml" ]; then \
		echo "🎯 Generating Docker Compose from score-frontend.yaml..."; \
		score-compose generate score-frontend.yaml; \
		echo "🎯 Generating Kubernetes from score-frontend.yaml..."; \
		score-k8s generate score-frontend.yaml; \
	fi
	@echo "✅ Deployment manifests generated"

# Docker targets (legacy)
docker-build: ## Build Docker images (legacy)
	@echo "🐳 Building Docker images..."
	docker build -t testing-again-backend:latest ./backend
	docker build -t testing-again-frontend:latest ./frontend
	@echo "✅ Docker images built"

docker-up: ## Start application with Docker Compose (legacy)
	@echo "🐳 Starting application with Docker Compose..."
	@$(MAKE) score-generate-legacy
	docker-compose up -d
	@echo "✅ Application started"

docker-down: ## Stop Docker Compose (legacy)
	@echo "🐳 Stopping Docker Compose..."
	docker-compose down
	@echo "✅ Application stopped"

# Deploy target
deploy: ## Deploy application
	@echo "🚀 Deploying application..."
	@$(MAKE) build
	@$(MAKE) score-generate
	@echo "✅ Application deployed"
