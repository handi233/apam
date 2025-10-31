<?php
header('Content-Type: application/json');

include 'koneksi.php';

// Ambil input JSON dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

$nik = $input['nik'] ?? '';
$password = $input['password'] ?? '';

if (empty($nik) || empty($password)) {
    echo json_encode([
        "status" => "error",
        "message" => "NIK dan password wajib diisi"
    ]);
    exit();
}

// Query ke tabel user
$sql = "SELECT * FROM users WHERE nik = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $nik);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    // Cek password 
    if (md5($password) === $user['password']) {
        echo json_encode([
            "status" => "success",
            "message" => "Login berhasil",
            "nik" => $user['nik'],
            "nama" => $user['nama'] ?? ""
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Password salah"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "NIK tidak ditemukan"
    ]);
}

$stmt->close();
$conn->close();
