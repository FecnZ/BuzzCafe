package com.buzzcafe.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrdenResponseDTO {
    private Long id;
    private LocalDateTime fecha;
    private Double total;
    private String nombreVendedor;
    private List<DetalleOrdenResponseDTO> detalles;
}
