package com.buzzcafe.backend.entities;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

@Entity
@Table(name = "ORDENES")
@Data
public class Orden {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "order_seq")
    @SequenceGenerator(name = "order_seq", sequenceName = "ORDER_SEQ", allocationSize = 1)
    private Long id;

    private LocalDateTime fecha;
    private Double total;

    // AGREGAMOS ESTO:
    @Enumerated(EnumType.STRING)
    private EstadoOrden estado = EstadoOrden.PENDIENTE; // Por defecto nace pendiente

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private Usuario vendedor;

    @Column(name = "cliente_id", nullable = true)
    private Long clienteId; // Opcional, reservado para futuras implementaciones de Cliente

    @JsonManagedReference
    @OneToMany(mappedBy = "orden", cascade = CascadeType.ALL)
    private List<DetalleOrden> detalles;

    @PrePersist
    protected void onCreate() {
        this.fecha = LocalDateTime.now();
    }
}