package com.buzzcafe.backend.config;

import com.buzzcafe.backend.entities.DetalleOrden;
import com.buzzcafe.backend.entities.EstadoOrden;
import com.buzzcafe.backend.entities.Orden;
import com.buzzcafe.backend.entities.Producto;
import com.buzzcafe.backend.entities.Usuario;
import com.buzzcafe.backend.repositories.UserRepository;
import com.buzzcafe.backend.repositories.ProductRepository;
import com.buzzcafe.backend.repositories.OrdenRepository;

import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataConfig {

        @Bean
        CommandLineRunner loadData(UserRepository repository, ProductRepository prodRepo,
                        OrdenRepository orderRepo, PasswordEncoder passwordEncoder) {
                return args -> {
                        // 1. Usuarios (Agregamos uno de cocina para tu tablet)
                        repository.save(new Usuario(null, "admin", passwordEncoder.encode("1234"), "Fernando Admin",
                                        com.buzzcafe.backend.entities.RolUsuario.ADMIN, true));
                        repository.save(new Usuario(null, "chef", passwordEncoder.encode("1234"), "Juan Cocina",
                                        com.buzzcafe.backend.entities.RolUsuario.COCINA, true));
                        repository.save(new Usuario(null, "cajero", passwordEncoder.encode("1234"), "Sam Cajero",
                                        com.buzzcafe.backend.entities.RolUsuario.CAJERO, true));

                        // 2. Productos
                        Producto espresso = prodRepo
                                        .save(new Producto(null, "Espresso", "Café puro", 35.0, 50, "Bebidas", true));
                        prodRepo.save(new Producto(null, "Capuccino", "Leche cremosa", 48.0, 30, "Bebidas", true));

                        // 3. Una orden lista para que la reciba la cocina
                        Orden nuevaOrden = new Orden();
                        nuevaOrden.setVendedor(repository.findAll().get(0));
                        nuevaOrden.setTotal(35.0);
                        nuevaOrden.setEstado(EstadoOrden.PENDIENTE);

                        DetalleOrden detalle = new DetalleOrden();
                        detalle.setOrden(nuevaOrden);
                        detalle.setProducto(espresso);
                        detalle.setCantidad(1);
                        detalle.setPrecioUnitario(35.0);

                        nuevaOrden.setDetalles(List.of(detalle));
                        orderRepo.save(nuevaOrden);

                        System.out.println("--- Datos de prueba cargados: Usuario 'chef1' listo para la tablet ---");
                };
        }
}