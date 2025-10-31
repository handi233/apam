<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Konfigurasi koneksi database
include 'koneksi.php';

// Query ambil data gambar dari tabel
$sql = "SELECT image FROM settings2"; // sesuai nama tabel dan kolom 
$result = $conn->query($sql);

$banners = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $banners[] = [
            "image" => $row['image']
        ];
    }
}

// Kembalikan hasil sebagai JSON
echo json_encode($banners, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);

$conn->close();
