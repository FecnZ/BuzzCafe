package com.buzzcafe.backend.controllers;

import java.util.List;

import org.apache.catalina.connector.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import com.buzzcafe.backend.dto.ProductoAdminDTO;
import org.springframework.web.bind.annotation.RestController;

import com.buzzcafe.backend.mappers.ProductMapper;
import com.buzzcafe.backend.repositories.ProductRepository;
import com.buzzcafe.backend.services.ProductAdminService;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private ProductAdminService productAdminService;

    public AdminController(ProductAdminService productAdminService) {
        this.productAdminService = productAdminService;
    }

    @GetMapping("/products")
    List<ProductoAdminDTO> consulta() {
        return productAdminService.consulta();
    }

    @PostMapping("/products")
    ResponseEntity<?> insertarProducto(@RequestBody ProductoAdminDTO datos) {
        return ResponseEntity.status(HttpStatus.CREATED).body(productAdminService.insertar(datos));

    }
}
