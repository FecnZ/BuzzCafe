package com.buzzcafe.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.buzzcafe.backend.dto.ProductoCajeroDTO;
import com.buzzcafe.backend.repositories.ProductRepository;
import com.buzzcafe.backend.mappers.ProductMapper;

@Service
public class ProductCajeroService {
    final private ProductRepository productRepository;

    public ProductCajeroService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductoCajeroDTO> consulta() {
        return productRepository.findAll().stream()
                .map(ProductMapper::toCajeroDTO)
                .toList();

    }

}
