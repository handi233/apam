<?php
header('Content-Type: application/json');

$koneksi = mysqli_connect("localhost", "root", "", "apamapk");

// Cek koneksi
if (!$koneksi) {
    echo json_encode(["error" => "Koneksi gagal"]);
    exit;
}

// Ambil data dari tabel
$query = mysqli_query($koneksi, "SELECT logo FROM settings LIMIT 1");
$data = mysqli_fetch_assoc($query);

// Hanya kirim JSON (tanpa teks tambahan)
echo json_encode($data);
