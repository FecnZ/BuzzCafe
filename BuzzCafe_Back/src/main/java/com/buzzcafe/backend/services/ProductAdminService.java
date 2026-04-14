package com.buzzcafe.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.buzzcafe.backend.dto.ProductoAdminDTO;
import com.buzzcafe.backend.entities.Producto;
import com.buzzcafe.backend.repositories.ProductRepository;
import com.buzzcafe.backend.mappers.ProductMapper;

@Service
public class ProductAdminService {
    final private ProductRepository productRepository;

    public ProductAdminService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductoAdminDTO> consulta() {
        return productRepository.findAll().stream()
                .map(ProductMapper::toAdminDTO)
                .toList();
    }

    public ProductoAdminDTO insertar(ProductoAdminDTO p) {
        Producto producto = ProductMapper.toProducto(p);
        productRepository.save(producto);
        return ProductMapper.toAdminDTO(producto);
    }
}
