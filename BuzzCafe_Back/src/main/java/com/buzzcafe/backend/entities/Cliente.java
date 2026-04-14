package com.buzzcafe.backend.entities;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "CLIENTES")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cliente {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "client_seq")
    @SequenceGenerator(name = "client_seq", sequenceName = "CLIENT_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String nombre;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "rfid_uid", unique = true)
    private String rfidId; // ID único de su tarjeta

    @Column(nullable = false)
    private Double saldo = 0.0;

    @Column(name = "puntos", nullable = false)
    private Integer puntosFidelidad = 0;
}
