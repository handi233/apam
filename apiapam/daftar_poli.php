<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'koneksi.php';

// Coba baca raw input (JSON)
$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

// Jika gagal decode JSON, coba baca POST biasa
if ($data === null) {
    $data = $_POST;
}

// Ambil variabel
$users_id = isset($data['users_id']) ? intval($data['users_id']) : 0;
$tgl_daftar = $data['tgl_daftar'] ?? '';
$poli_tujuan = $data['poli_tujuan'] ?? '';
$keluhan = $data['keluhan'] ?? '';

if ($users_id == 0 || empty($tgl_daftar) || empty($poli_tujuan) || empty($keluhan)) {
    echo json_encode(["success" => false, "message" => "Data tidak lengkap", "raw" => $data]);
    exit;
}

$query = "INSERT INTO daftar_poli (users_id, tgl_daftar, poli_tujuan, keluhan)
          VALUES ('$users_id', '$tgl_daftar', '$poli_tujuan', '$keluhan')";

if (mysqli_query($conn, $query)) {
    echo json_encode(["success" => true, "message" => "Pendaftaran berhasil disimpan."]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal menyimpan data.", "error" => mysqli_error($conn)]);
}
