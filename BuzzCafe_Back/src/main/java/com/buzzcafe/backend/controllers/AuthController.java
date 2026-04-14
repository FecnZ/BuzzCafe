package com.buzzcafe.backend.controllers;

import com.buzzcafe.backend.dto.LoginRequest;
import com.buzzcafe.backend.services.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest datos) {
        return ResponseEntity.ok(authService.login(datos));
    }
}
