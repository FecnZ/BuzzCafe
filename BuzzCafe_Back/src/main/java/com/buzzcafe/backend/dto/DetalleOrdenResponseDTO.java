package com.buzzcafe.backend.dto;

import lombok.Data;

@Data
public class DetalleOrdenResponseDTO {
    private Long id;
    private String nombreProducto;
    private Integer cantidad;
    private Double precioUnitario;
    private Double subtotal;
}
