package com.buzzcafe.backend.mappers;

import com.buzzcafe.backend.dto.ProductoAdminDTO;
import com.buzzcafe.backend.dto.ProductoCajeroDTO;
import com.buzzcafe.backend.entities.Producto;

public class ProductMapper {

    public static ProductoCajeroDTO toCajeroDTO(Producto p) {
        return new ProductoCajeroDTO(
                p.getNombre(),
                p.getStock(),
                p.getPrecio());
    }

    public static ProductoAdminDTO toAdminDTO(Producto p) {
        return new ProductoAdminDTO(
                p.getId(),
                p.getNombre(),
                p.getDescripcion(),
                p.getPrecio(),
                p.getStock(),
                p.getCategoria(),
                p.getActivo());
    }

    public static Producto toProducto(ProductoAdminDTO p) {
        return new Producto(
                p.id(),
                p.nombre(),
                p.descripcion(),
                p.precio(),
                p.stock(),
                p.categoria(),
                p.activo() != null ? p.activo() : true);

    }

}