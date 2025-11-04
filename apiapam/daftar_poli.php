<?php
header('Content-Type: application/json');
include 'koneksi.php';

// Ambil data JSON dari request
$data = json_decode(file_get_contents("php://input"), true);

$users_id = $data['users_id'] ?? '';
$tanggal_daftar = $data['tanggal_daftar'] ?? '';
$keluhan = $data['keluhan'] ?? '';
$status = $data['status'] ?? 'Pending';

// Cek data lengkap
if ($users_id && $tanggal_daftar && $keluhan) {
    // Prepared statement untuk mencegah SQL Injection
    $stmt = $conn->prepare("INSERT INTO daftar_poli (users_id, tanggal_daftar, keluhan, status) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("isss", $users_id, $tanggal_daftar, $keluhan, $status);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Berhasil daftar"]);
    } else {
        echo json_encode(["error" => "Gagal daftar: " . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["error" => "Data tidak lengkap"]);
}

$conn->close();
