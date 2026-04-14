package com.buzzcafe.backend.entities;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "DETALLES_ORDEN")
@Data
public class DetalleOrden {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "detail_seq")
    @SequenceGenerator(name = "detail_seq", sequenceName = "DETAIL_SEQ", allocationSize = 1)
    private Long id;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "orden_id") // La llave foránea en la base de datos
    private Orden orden; // Este es el nombre que usa 'mappedBy'

    @ManyToOne
    @JoinColumn(name = "producto_id")
    private Producto producto;

    private Integer cantidad;
    private Double precioUnitario;

    private String notas;
}