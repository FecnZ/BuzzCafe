package com.buzzcafe.backend.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.buzzcafe.backend.dto.ProductoCajeroDTO;
import com.buzzcafe.backend.services.ProductCajeroService;

@RestController
@RequestMapping("/api/cajero")
public class CajeroController {

    private final ProductCajeroService productCajeroService;

    public CajeroController(ProductCajeroService service) {
        this.productCajeroService = service;
    }

    @GetMapping("/consulta")
    public List<ProductoCajeroDTO> consulta() {
        return productCajeroService.consulta();
    }
}