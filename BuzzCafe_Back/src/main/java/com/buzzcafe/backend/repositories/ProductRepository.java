package com.buzzcafe.backend.repositories;

import com.buzzcafe.backend.entities.Producto;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Producto, Long> {
    List<Producto> findAll();
    List<Producto> findByActivoTrue();
}