package handlers

import (
    "testing-again/internal/logger"
    
    
)

// Dependencies holds all handler dependencies
type Dependencies struct {
    Logger logger.Logger
    
    
}

// Response represents a standard API response
type Response struct {
    Success bool        `json:"success"`
    Message string      `json:"message,omitempty"`
    Data    interface{} `json:"data,omitempty"`
    Error   string      `json:"error,omitempty"`
}

// ErrorResponse represents an error response
type ErrorResponse struct {
    Success bool   `json:"success"`
    Error   string `json:"error"`
    Code    int    `json:"code"`
}

// SuccessResponse represents a success response
type SuccessResponse struct {
    Success bool        `json:"success"`
    Message string      `json:"message,omitempty"`
    Data    interface{} `json:"data,omitempty"`
}
