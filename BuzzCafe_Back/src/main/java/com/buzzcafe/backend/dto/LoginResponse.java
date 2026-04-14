package com.buzzcafe.backend.dto;

public record LoginResponse(
        String username,
        String nombreCompleto,
        String role,
        String token) {

}