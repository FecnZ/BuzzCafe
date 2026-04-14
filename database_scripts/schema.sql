-- 1. LIMPIEZA (Opcional: borrar tablas si ya existen)
-- DROP TABLE DETALLES_ORDEN;
-- DROP TABLE ORDENES;
-- DROP TABLE PRODUCTOS;
-- DROP TABLE USUARIOS;
-- DROP TABLE CLIENTES;

-- 2. SECUENCIAS
CREATE SEQUENCE USER_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CLIENT_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE PROD_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ORDER_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE DETAIL_SEQ START WITH 1 INCREMENT BY 1;

-- 3. TABLA: USUARIOS (Para el Login)
CREATE TABLE USUARIOS (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    nombre_completo VARCHAR2(100),
    role VARCHAR2(20) NOT NULL, -- ADMIN, CAJERO, COCINA
    active NUMBER(1) DEFAULT 1 -- 1 para true, 0 para false
);

-- 4. TABLA: CLIENTES (Para fidelización)
CREATE TABLE CLIENTES (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE,
    rfid_uid VARCHAR2(50) UNIQUE, -- Para el sistema de tarjetas
    saldo NUMBER(10,2) DEFAULT 0,
    puntos NUMBER DEFAULT 0
);

-- 5. TABLA: PRODUCTOS (Inventario)
CREATE TABLE PRODUCTOS (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(255),
    precio NUMBER(10,2) NOT NULL,
    stock NUMBER NOT NULL,
    categoria VARCHAR2(50)
);

-- 6. TABLA: ORDENES (El encabezado del pedido)
CREATE TABLE ORDENES (
    id NUMBER PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total NUMBER(10,2) NOT NULL,
    estado VARCHAR2(50) NOT NULL, -- PENDIENTE, PREPARANDO, LISTO, ENTREGADO
    user_id NUMBER NOT NULL, -- Relación con Usuario
    cliente_id NUMBER,           -- Relación con Cliente (opcional)
    CONSTRAINT fk_orden_vendedor FOREIGN KEY (user_id) REFERENCES USUARIOS(user_id),
    CONSTRAINT fk_orden_cliente FOREIGN KEY (cliente_id) REFERENCES CLIENTES(id)
);

-- 7. TABLA: DETALLES_ORDEN (Los productos de cada pedido)
CREATE TABLE DETALLES_ORDEN (
    id NUMBER PRIMARY KEY,
    orden_id NUMBER NOT NULL,
    producto_id NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    notas VARCHAR2(255),
    CONSTRAINT fk_det_orden FOREIGN KEY (orden_id) REFERENCES ORDENES(id),
    CONSTRAINT fk_det_prod FOREIGN KEY (producto_id) REFERENCES PRODUCTOS(id)
);

-----------------------------------------------------------
-- 8. DATOS DE PRUEBA (Para que pruebes el Login y la Cocina)
-----------------------------------------------------------

-- Usuarios iniciales
INSERT INTO USUARIOS (user_id, username, password, nombre_completo, role, active) 
VALUES (USER_SEQ.NEXTVAL, 'admin', '1234', 'Fernando Admin', 'ADMIN', 1);

INSERT INTO USUARIOS (user_id, username, password, nombre_completo, role, active) 
VALUES (USER_SEQ.NEXTVAL, 'cocina1', '1234', 'Chef Juan', 'COCINA', 1);

-- Productos
INSERT INTO PRODUCTOS (id, nombre, descripcion, precio, stock) 
VALUES (PROD_SEQ.NEXTVAL, 'Espresso', 'Café puro e intenso', 35.0, 100);

INSERT INTO PRODUCTOS (id, nombre, descripcion, precio, stock) 
VALUES (PROD_SEQ.NEXTVAL, 'Dona Chocolate', 'Dona glaseada', 25.0, 50);

-- Una Orden de prueba para que aparezca en la tablet de cocina
INSERT INTO ORDENES (id, fecha, total, estado, user_id, cliente_id)
VALUES (ORDER_SEQ.NEXTVAL, CURRENT_TIMESTAMP, 60.0, 'PENDIENTE', 1, NULL);

-- Detalles de esa orden (1 Espresso y 1 Dona)
INSERT INTO DETALLES_ORDEN (id, orden_id, producto_id, cantidad, precio_unitario)
VALUES (DETAIL_SEQ.NEXTVAL, 1, 1, 1, 35.0);

INSERT INTO DETALLES_ORDEN (id, orden_id, producto_id, cantidad, precio_unitario)
VALUES (DETAIL_SEQ.NEXTVAL, 1, 2, 1, 25.0);

COMMIT;