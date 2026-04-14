package com.buzzcafe.backend.dto;

public record ProductoAdminDTO(

                Long id,
                String nombre,
                String descripcion,
                Double precio,
                Integer stock,
                String categoria

) {
}
