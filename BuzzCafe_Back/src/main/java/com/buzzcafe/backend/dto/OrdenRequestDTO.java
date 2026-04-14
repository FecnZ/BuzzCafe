package com.buzzcafe.backend.dto;

import lombok.Data;
import java.util.List;

@Data
public class OrdenRequestDTO {
    private Long vendedorId;
    private List<ItemOrdenDTO> items;

    @Data
    public static class ItemOrdenDTO {
        private Long productoId;
        private Integer cantidad;
    }
}