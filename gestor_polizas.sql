DROP DATABASE IF EXISTS gestor_polizas;
CREATE DATABASE gestor_polizas
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE gestor_polizas;

CREATE TABLE cliente (
  id_cliente   INT AUTO_INCREMENT,
  nombre       VARCHAR(80)  NOT NULL,
  apellidos    VARCHAR(120) NOT NULL,
  telefono     VARCHAR(20)  NOT NULL,
  correo       VARCHAR(120) NOT NULL,
  direccion    VARCHAR(200) NULL,
  tipo_cliente ENUM('FISICA','MORAL') NOT NULL DEFAULT 'FISICA',
  CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
  CONSTRAINT uq_cliente_correo UNIQUE (correo)
) ENGINE=InnoDB;

CREATE TABLE marca (
  id_marca     INT AUTO_INCREMENT,
  nombre_marca VARCHAR(60) NOT NULL,
  CONSTRAINT pk_marca PRIMARY KEY (id_marca),
  CONSTRAINT uq_marca_nombre UNIQUE (nombre_marca)
) ENGINE=InnoDB;

CREATE TABLE aseguradora (
  id_aseguradora INT AUTO_INCREMENT,
  nombre         VARCHAR(100) NOT NULL,
  telefono       VARCHAR(20)  NULL,
  correo         VARCHAR(120) NULL,
  CONSTRAINT pk_aseguradora PRIMARY KEY (id_aseguradora),
  CONSTRAINT uq_aseguradora_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE cobertura (
  id_cobertura   INT AUTO_INCREMENT,
  nombre         VARCHAR(100) NOT NULL,
  descripcion    VARCHAR(255) NULL,
  suma_asegurada DECIMAL(12,2) NOT NULL DEFAULT 0,
  condiciones    TEXT NULL,
  CONSTRAINT pk_cobertura PRIMARY KEY (id_cobertura),
  CONSTRAINT uq_cobertura_nombre UNIQUE (nombre),
  CONSTRAINT chk_cobertura_suma CHECK (suma_asegurada >= 0)
) ENGINE=InnoDB;

CREATE TABLE usuario (
  id_usuario      INT AUTO_INCREMENT,
  nombre_usuario  VARCHAR(50)  NOT NULL,
  contrasena_hash VARCHAR(255) NOT NULL,
  rol ENUM('ADMINISTRADOR','AGENTE_VENTAS',
           'PERSONAL_ADMINISTRATIVO','DIRECCION')
      NOT NULL DEFAULT 'PERSONAL_ADMINISTRATIVO',
  estado_cuenta ENUM('ACTIVA','INACTIVA')
      NOT NULL DEFAULT 'ACTIVA',
  CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT uq_usuario_nombre UNIQUE (nombre_usuario)
) ENGINE=InnoDB;


CREATE TABLE vehiculo (
  id_vehiculo      INT AUTO_INCREMENT,
  id_cliente       INT NOT NULL,
  id_marca         INT NOT NULL,
  modelo           VARCHAR(60) NOT NULL,
  anio             YEAR NOT NULL,
  color            VARCHAR(30) NULL,
  placas           VARCHAR(15) NOT NULL,
  numero_serie_vin VARCHAR(30) NOT NULL,
  CONSTRAINT pk_vehiculo PRIMARY KEY (id_vehiculo),
  CONSTRAINT uq_vehiculo_placas UNIQUE (placas),
  CONSTRAINT uq_vehiculo_vin UNIQUE (numero_serie_vin),
  CONSTRAINT chk_vehiculo_anio CHECK (anio BETWEEN 1950 AND 2100),
  CONSTRAINT fk_vehiculo_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vehiculo_marca FOREIGN KEY (id_marca)
    REFERENCES marca (id_marca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE poliza (
  id_poliza         INT AUTO_INCREMENT,
  id_cliente        INT NOT NULL,
  id_vehiculo       INT NULL,
  id_aseguradora    INT NOT NULL,
  numero_poliza     VARCHAR(40) NOT NULL,
  fecha_inicio      DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  estado ENUM('ACTIVA','PROXIMA_A_VENCER','VENCIDA',
              'CANCELADA','RENOVADA')
         NOT NULL DEFAULT 'ACTIVA',
  prima DECIMAL(12,2) NOT NULL DEFAULT 0,
  CONSTRAINT pk_poliza PRIMARY KEY (id_poliza),
  CONSTRAINT uq_poliza_numero UNIQUE (numero_poliza),
  CONSTRAINT chk_poliza_fechas
    CHECK (fecha_vencimiento > fecha_inicio),
  CONSTRAINT chk_poliza_prima CHECK (prima >= 0),
  CONSTRAINT fk_poliza_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente (id_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_poliza_vehiculo FOREIGN KEY (id_vehiculo)
    REFERENCES vehiculo (id_vehiculo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_poliza_aseguradora
    FOREIGN KEY (id_aseguradora)
    REFERENCES aseguradora (id_aseguradora)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE poliza_cobertura (
  id_poliza_cobertura INT AUTO_INCREMENT,
  id_poliza           INT NOT NULL,
  id_cobertura        INT NOT NULL,
  limite_contratado   DECIMAL(12,2) NULL,
  CONSTRAINT pk_poliza_cob PRIMARY KEY (id_poliza_cobertura),
  CONSTRAINT uq_poliza_cobertura
    UNIQUE (id_poliza, id_cobertura),
  CONSTRAINT fk_pc_poliza FOREIGN KEY (id_poliza)
    REFERENCES poliza (id_poliza)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pc_cobertura FOREIGN KEY (id_cobertura)
    REFERENCES cobertura (id_cobertura)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pago (
  id_pago     INT AUTO_INCREMENT,
  id_poliza   INT NOT NULL,
  fecha_pago  DATE NOT NULL,
  monto       DECIMAL(12,2) NOT NULL,
  metodo_pago ENUM('EFECTIVO','TARJETA',
                   'TRANSFERENCIA','OTRO')
              NOT NULL DEFAULT 'TRANSFERENCIA',
  referencia  VARCHAR(60) NULL,
  estado_pago ENUM('PAGADO','PENDIENTE','CANCELADO')
              NOT NULL DEFAULT 'PAGADO',
  CONSTRAINT pk_pago PRIMARY KEY (id_pago),
  CONSTRAINT chk_pago_monto CHECK (monto > 0),
  CONSTRAINT fk_pago_poliza FOREIGN KEY (id_poliza)
    REFERENCES poliza (id_poliza)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO marca (nombre_marca) VALUES
  ('Nissan'), ('Toyota'), ('Volkswagen'),
  ('Chevrolet'), ('Ford');

INSERT INTO cobertura (nombre, descripcion, suma_asegurada)
VALUES
  ('Responsabilidad Civil',
   'Daños a terceros en sus bienes y personas', 500000.00),
  ('Daños Materiales',
   'Daños al vehículo asegurado', 300000.00),
  ('Robo Total',
   'Robo total del vehículo asegurado', 300000.00),
  ('Gastos Médicos Ocupantes',
   'Gastos médicos de los ocupantes', 100000.00),
  ('Asistencia Vial',
   'Grúa y asistencia en el camino', 20000.00);

INSERT INTO usuario (nombre_usuario, contrasena_hash, rol)
VALUES ('admin', '2502001',
        'ADMINISTRADOR');

        SHOW TABLES;