-- 	===DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL===

SET SQL_SAFE_UPDATES = 0; /* For Flexibility */
CREATE DATABASE horizon_airDB;
USE horizon_airDB;

CREATE TABLE bandara (
	ID_Bandara  INT AUTO_INCREMENT PRIMARY KEY,
    Nama 		VARCHAR(255),
    Kota 		VARCHAR(255),
    Negara 		VARCHAR(255),
    Kode_iata 	CHAR(3) UNIQUE
);

INSERT INTO bandara (Nama, Kota, Negara, Kode_iata)
VALUES  ("Soekarno-Hatta", "Jakarta"  , "Indonesia", "CGK"),
		("Ngurah Rai"    , "Denpasar" , "Indonesia", "DPS"),
        ("Changi"        , "Singapore", "Singapore", "SIN"),
        ("Haneda"        , "Tokyo"    , "Japan"    , "HND");
-- SELECT * FROM bandara;

CREATE TABLE bagasi (
	ID_Bagasi   INT AUTO_INCREMENT PRIMARY KEY,
    Berat 	    INT,
    Ukuran 	    VARCHAR(5),
    Warna 	    VARCHAR(255),
    Jenis       VARCHAR(255)
);

INSERT INTO bagasi (Berat, Ukuran, Warna, Jenis)
VALUES  (20, "M", "Hitam", "Koper" ),
		(15, "S", "Merah", "Ransel"),
        (25, "L", "Biru" , "Koper" ),
        (10, "S", "Hijau", "Ransel");
        
-- SELECT * FROM bagasi;

CREATE TABLE maskapai (
	ID_Maskapai 	    CHAR(6) PRIMARY KEY,
    Nama 			    VARCHAR(255),
    Negara_Asal 		VARCHAR(255)
);

INSERT INTO maskapai 
VALUES	("SQ456", "Singapore Airlines", "Singapore"),
        ("JL789", "Japan Airlines"    , "Japan"    ),
		("QZ987", "AirAsia"           , "Malaysia" );
        
-- SELECT * FROM maskapai;

CREATE TABLE penumpang (
	NIK 			CHAR(16) PRIMARY KEY,
    Nama 			VARCHAR(255),
    Tanggal_Lahir 	DATE,
    Alamat 			VARCHAR(255),
    No_Telepon 		VARCHAR(13),
    Jenis_Kelamin 	CHAR(1),
    Kewarnegaraan 	VARCHAR(255),
    ID_Bagasi 		INT,
    FOREIGN KEY(ID_Bagasi) REFERENCES bagasi(ID_Bagasi)
	    ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO penumpang
VALUES  ("3201123456789012", "Budi Santoso", "1990-04-15", "Jl. Merdeka No.1"     , "081234567890" , "L", "Indonesia", 1),
		("3302134567890123", "Siti Aminah" , "1985-08-20", "Jl. Kebangsaan No.2"  , "081298765432" , "P", "Indonesia", 2),
        ("3403145678901234", "John Tanaka" , "1992-12-05", "Shibuya, Tokyo"       , "080123456789" , "L", "Japan"    , 3),
        ("3504156789012345", "Li Wei"      , "1995-03-10", "Orchard Rd, Singapore", "0658123456789", "L", "Singapore", 4);

-- SELECT * FROM penumpang;

CREATE TABLE pesawat (
	ID_Pesawat 				CHAR(6) PRIMARY KEY,
    Model 					VARCHAR(255),
    Kapasitas 				INT,
    Tahun_Produksi 			CHAR(4),
    Status_Pesawat 			VARCHAR(50),
    ID_Maskapai 			CHAR(6),
    FOREIGN KEY(ID_Maskapai) REFERENCES maskapai(ID_Maskapai)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO pesawat
VALUES  ("PKABC1", "Boeing 737" , 180, "2018", "Aktif"          , "GA123"),
		("PKDEF2", "Airbus A320", 150, "2020", "Aktif"          , "SQ456"),
        ("PKGHI3", "Boeing"     , 250, "2019", "Dalam Perawatan", "JL789"),
        ("PKJKL4", "Airbus A330", 280, "2021", "Aktif"          , "QZ987");

-- SELECT * FROM pesawat;

CREATE TABLE penerbangan (
	ID_Penerbangan			CHAR(6) PRIMARY KEY,
    Waktu_Keberangkatan		DATETIME,
    Waktu_Sampai			DATETIME,
    Status_Penerbangan		VARCHAR(50),
    ID_Pesawat				CHAR(6),
    FOREIGN KEY(ID_Pesawat) REFERENCES pesawat(ID_Pesawat)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO penerbangan 
VALUES  ("FL0001", "2024-12-15 10:00:00", "2024-12-15 12:30:00", "Jadwal" , "PKABC1"),
		("FL0002", "2024-12-16 08:00:00", "2024-12-16 10:45:00", "Jadwal" , "PKDEF2"),
        ("FL0003", "2024-12-17 14:00:00", "2024-12-17 16:30:00", "Ditunda", "PKGHI3"),
        ("FL0004", "2024-12-18 18:00:00", "2024-12-18 20:30:00", "Jadwal" , "PKJKL4");
        
-- SELECT * FROM penerbangan;

CREATE TABLE bandara_penerbangan (
	Bandara_ID			INT,
    Penerbangan_ID		VARCHAR(10),
    PRIMARY KEY(Bandara_ID, Penerbangan_ID),
    FOREIGN KEY(Bandara_ID) REFERENCES bandara(ID_Bandara)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(Penerbangan_ID) REFERENCES penerbangan(ID_Penerbangan)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO bandara_penerbangan
VALUES  (1, "FL0001"),
		(2, "FL0002"),
        (3, "FL0003"),
        (4, "FL0004");
        
-- SELECT * FROM bandara_penerbangan;

CREATE TABLE tiket (
	ID_Tiket				CHAR(6) PRIMARY KEY,
    Nomor_Kursi				CHAR(3),
    Harga					INT,
    Waktu_Pembelian			DATETIME,
    Kelas_Penerbangan		VARCHAR(50),
    NIK_Penumpang			CHAR(16),
    ID_Penerbangan			CHAR(6),
    FOREIGN KEY(NIK_Penumpang) REFERENCES penumpang(NIK)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(ID_Penerbangan) REFERENCES penerbangan(ID_Penerbangan)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO tiket
VALUES  ("TIK001", "12A", 1200000, "2024-11-01 08:00:00", "Ekonomi", "3201123456789012", "FL0001"),
		("TIK002", "14B", 1500000, "2024-11-02 09:30:00", "Bisnis" , "3302134567890123", "FL0002"),
		("TIK003", "16C", 2000000, "2024-11-03 10:15:00", "Ekonomi", "3403145678901234", "FL0003"),
        ("TIK004", "18D", 1000000, "2024-11-04 11:45:00", "Ekonomi", "3504156789012345", "FL0004");
--         
-- SELECT * FROM tiket;

-- Query masing-masing table
-- SELECT * FROM bandara;
-- SELECT * FROM bagasi;
-- SELECT * FROM maskapai;
-- SELECT * FROM penumpang;
-- SELECT * FROM pesawat;
-- SELECT * FROM penerbangan;
-- SELECT * FROM bandara_penerbangan;
-- SELECT * FROM tiket;

/* 3. Karena sistem penerbangan ingin menambah data baru tentang penumpangnya, tambahkan kolom email yang bertipe data varchar pada tabel penumpang. */
ALTER TABLE penumpang
ADD Email VARCHAR(255);

-- SELECT * FROM penumpang;

/* 4. Ubah tipe data pada kolom jenis di tabel bagasi menjadi maksimal 50 character */

ALTER TABLE bagasi
MODIFY COLUMN jenis VARCHAR(50);

-- SELECT * FROM bagasi;

/* 5. Karena kode IATA pada setiap bandara unik, tambahkan primary key pada kolom kode IATA di tabel bandara. */

ALTER TABLE bandara
DROP PRIMARY KEY,
ADD PRIMARY KEY (ID_Bandara, Kode_iata);
-- SELECT * FROM bandara;

/* 6. Karena dirasa tidak diperlukan, hapus kembali kolom email pada tabel penumpang. */

ALTER TABLE penumpang
DROP COLUMN Email;

-- SELECT * FROM penumpang;

-- 	===DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL======DDL===


--  ===DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML===

/* 7. Penerbangan dengan ID "FL0001" mengalami perubahan jadwal. Waktu keberangkatan baru adalah tanggal 2024-12-15 pukul 11:00:00, dan waktu sampai menjadi pukul 2024-12-15 pukul 13:30:00. Perbarui data di tabel Penerbangan dengan jadwal baru ini. */

UPDATE penerbangan
SET Waktu_Keberangkatan = "2024-12-15 11:00:00"
WHERE ID_Penerbangan = "FL0001";

UPDATE penerbangan 
SET Waktu_Sampai = "2024-12-15 13:30:00"
WHERE ID_Penerbangan = "FL0001";

-- SELECT * FROM penerbangan;

/* 8. Penumpang bernama Siti Aminah dengan NIK 3302134567890123 memperbarui nomor teleponnya menjadi 081223344556. Ubah nomor teleponnya di tabel Penumpang.*/

UPDATE penumpang
SET No_Telepon = "081223344556"
WHERE NIK = "3302134567890123";

-- SELECT * FROM penumpang;

/* 9. Pesawat dengan ID PKGHI3, yang saat ini berstatus "Dalam Perawatan," kini sudah aktif untuk beroperasi. Perbarui status pesawat tersebut menjadi "Aktif" di tabel Pesawat. */

UPDATE pesawat
SET Status_Pesawat = "Aktif"
WHERE ID_Pesawat = "PKGHI3";

-- SELECT * FROM pesawat;

/* 10. Penumpang bernama Li Wei dengan NIK 3504156789012345 membatalkan tiketnya untuk penerbangan dengan ID FL0004. Hapus data tiket milik Li Wei dari tabel Tiket.*/

DELETE FROM penumpang
WHERE NIK = "3504156789012345";

-- SELECT * FROM tiket;
-- SELECT * FROM penumpang;

/* 11. Bagasi dengan ID 2, yang memiliki berat 15 kg, ukuran "S," dan berwarna merah, 
hilang di area bandara. Hapus data bagasi ini dari tabel Bagasi. */

DELETE FROM bagasi
WHERE ID_Bagasi = 2;

-- SELECT * FROM bagasi;

/* 12. Maskapai memutuskan untuk membatalkan penerbangan dengan status "Ditunda" karena alasan operasional. Hapus data penerbangan dengan status "Ditunda" di tabel Penerbangan. */

DELETE FROM penerbangan
WHERE Status_Penerbangan = "Ditunda";

-- SELECT * FROM penerbangan;

--  ===DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML======DML===