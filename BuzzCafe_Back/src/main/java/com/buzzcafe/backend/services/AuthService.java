package com.buzzcafe.backend.services;

import com.buzzcafe.backend.dto.LoginRequest;
import com.buzzcafe.backend.dto.LoginResponse;
import com.buzzcafe.backend.security.JwtUtils;
import com.buzzcafe.backend.security.MainUser;

import org.springframework.security.core.Authentication;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    final private AuthenticationManager authenticationManager;
    final private JwtUtils jwtUtils;

    public AuthService(AuthenticationManager authenticationManager, JwtUtils jwtUtils) {
        this.authenticationManager = authenticationManager;
        this.jwtUtils = jwtUtils;
    }

    public LoginResponse login(LoginRequest datos) {
        var authCredentials = new UsernamePasswordAuthenticationToken(
                datos.username(),
                datos.password());

        Authentication authResult = authenticationManager.authenticate(authCredentials);
        MainUser principal = (MainUser) authResult.getPrincipal();
        String token = jwtUtils.generarToken(principal);

        return new LoginResponse(
                principal.getUsername(),
                principal.getNombreCompleto(),
                principal.getAuthorities().iterator().next().getAuthority(),
                token);
    }

}
