<?php
header("Content-Type: application/json");
include 'koneksi.php'; // koneksi ke database

// Ambil data dari request
$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(['status' => false, 'message' => 'Data tidak valid']);
    exit;
}

$id_users = $data['id_users'] ?? null;
$old_password = $data['old_password'] ?? '';
$new_password = $data['new_password'] ?? '';

// Pastikan semua field terisi
if (!$id_users || !$old_password || !$new_password) {
    echo json_encode(['status' => false, 'message' => 'Data tidak lengkap']);
    exit;
}

// Ambil password dari database
$stmt = $conn->prepare("SELECT password FROM users WHERE id_users = ?");
$stmt->bind_param("i", $id_users);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['status' => false, 'message' => 'User tidak ditemukan']);
    exit;
}

$row = $result->fetch_assoc();

// Cek password lama (MD5 saja)
$old_hashed = md5($old_password);
if ($old_hashed !== $row['password']) {
    echo json_encode(['status' => false, 'message' => 'Password lama salah']);
    exit;
}

// Hash password baru (MD5)
$new_hashed = md5($new_password);

// Update password baru ke database
$update = $conn->prepare("UPDATE users SET password = ? WHERE id_users = ?");
$update->bind_param("si", $new_hashed, $id_users);

if ($update->execute()) {
    echo json_encode(['status' => true, 'message' => 'Password berhasil diubah']);
} else {
    echo json_encode(['status' => false, 'message' => 'Gagal mengubah password']);
}

$conn->close();
