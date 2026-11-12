CREATE DATABASE Kooliraamatukogu;
GO

USE Kooliraamatukogu;
GO

-- 1. Raamat
CREATE TABLE raamat (
    raamat_id INT IDENTITY(1,1) PRIMARY KEY,
    pealkiri NVARCHAR(150) NOT NULL
);

-- 2. Autor
CREATE TABLE autor (
    autor_id INT IDENTITY(1,1) PRIMARY KEY,
    nimi NVARCHAR(100) NOT NULL
);

-- 3. Teema
CREATE TABLE teema (
    teema_id INT IDENTITY(1,1) PRIMARY KEY,
    nimi NVARCHAR(100) NOT NULL
);

-- 4. Opilane
CREATE TABLE opilane (
    opilane_id INT IDENTITY(1,1) PRIMARY KEY,
    nimi NVARCHAR(100) NOT NULL,
    klass NVARCHAR(20) NOT NULL
);

-- 5. Eksemplar
CREATE TABLE eksemplar (
    eksemplar_id INT IDENTITY(1,1) PRIMARY KEY,
    raamat_id INT NOT NULL,
    inventarinumber NVARCHAR(30) NOT NULL UNIQUE,

    FOREIGN KEY (raamat_id)
    REFERENCES raamat(raamat_id)
);

-- 6. Raamat_autor
CREATE TABLE raamat_autor (
    raamat_id INT NOT NULL,
    autor_id INT NOT NULL,

    PRIMARY KEY (raamat_id, autor_id),

    FOREIGN KEY (raamat_id)
    REFERENCES raamat(raamat_id),

    FOREIGN KEY (autor_id)
    REFERENCES autor(autor_id)
);

-- 7. Raamat_teema
CREATE TABLE raamat_teema (
    raamat_id INT NOT NULL,
    teema_id INT NOT NULL,

    PRIMARY KEY (raamat_id, teema_id),

    FOREIGN KEY (raamat_id)
    REFERENCES raamat(raamat_id),

    FOREIGN KEY (teema_id)
    REFERENCES teema(teema_id)
);

-- 8. Laenutus
CREATE TABLE laenutus (
    laenutus_id INT IDENTITY(1,1) PRIMARY KEY,
    eksemplar_id INT NOT NULL,
    opilane_id INT NOT NULL,
    laenutatud DATE NOT NULL,
    tahtaeg DATE NOT NULL,
    tagastatud DATE NULL,

    FOREIGN KEY (eksemplar_id)
    REFERENCES eksemplar(eksemplar_id),

    FOREIGN KEY (opilane_id)
    REFERENCES opilane(opilane_id),

    CHECK (tahtaeg >= laenutatud),
    CHECK (tagastatud IS NULL OR tagastatud >= laenutatud)
);
GO

USE Kooliraamatukogu;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

USE Kooliraamatukogu;
GO

CREATE UNIQUE INDEX UX_laenutus_aktiivne
ON laenutus(eksemplar_id)
WHERE tagastatud IS NULL;
GO

SELECT
    OBJECT_NAME(parent_object_id) AS Tabel,
    name AS Seose_nimi,
    OBJECT_NAME(referenced_object_id) AS Seotud_tabel
FROM sys.foreign_keys
ORDER BY Tabel;