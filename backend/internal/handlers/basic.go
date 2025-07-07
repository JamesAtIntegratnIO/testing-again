package handlers

import (
    "net/http"
    
    

    "github.com/gin-gonic/gin"
)

// HealthCheck returns the health status of the application
func HealthCheck(deps Dependencies) gin.HandlerFunc {
    return func(c *gin.Context) {
        status := map[string]string{
            "status":  "ok",
            "service": "testing-again",
        }

        

        

        c.JSON(http.StatusOK, status)
    }
}

// Welcome returns a welcome message
func Welcome(deps Dependencies) gin.HandlerFunc {
    return func(c *gin.Context) {
        response := SuccessResponse{
            Success: true,
            Message: "Welcome to testing-again",
            Data: map[string]interface{}{
                "version": "1.0.0",
                "service": "testing-again",
            },
        }

        deps.Logger.Info("Welcome endpoint accessed")
        c.JSON(http.StatusOK, response)
    }
}


