package com.buzzcafe.backend.repositories;

import com.buzzcafe.backend.entities.EstadoOrden;
import com.buzzcafe.backend.entities.Orden;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrdenRepository extends JpaRepository<Orden, Long> {
    List<Orden> findByEstadoOrderByFechaAsc(EstadoOrden estado);
}
