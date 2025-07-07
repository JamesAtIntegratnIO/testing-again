package main

import (
    "context"
    "os"
    "os/signal"
    "syscall"
    "time"

    "testing-again/internal/config"
    
    
    "testing-again/internal/server"
    "testing-again/internal/logger"
)

func main() {
    // Initialize logger
    logger := logger.New()
    logger.Info("Starting testing-again server")

    // Load configuration
    cfg, err := config.Load()
    if err != nil {
        logger.Fatalf("Failed to load configuration: %v", err)
    }

    // Initialize database
    

    
    // Initialize server
    srv := server.New(server.Config{
        Port:   cfg.Server.Port,
        Logger: logger,
        
        
    })

    // Start server
    if err := srv.Start(); err != nil {
        logger.Fatalf("Failed to start server: %v", err)
    }

    // Wait for interrupt signal to gracefully shutdown
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    logger.Info("Shutting down server...")

    // Graceful shutdown with timeout
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    if err := srv.Shutdown(ctx); err != nil {
        logger.Errorf("Server forced to shutdown: %v", err)
    }

    logger.Info("Server exited")
}
