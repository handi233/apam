<?php
header('Content-Type: application/json');
include 'koneksi.php';

// Ambil semua notifikasi yang status = 1 (enum=1)
$sql = "SELECT id_user, pesan AS message, status FROM notifikasi WHERE status = '1'";

$result = $conn->query($sql);

$notif = array();

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $notif[] = array(
            "id_user" => (int)$row['id_user'],
            "title" => "Notifikasi Baru",
            "message" => $row['message'],
            "status" => (int)$row['status']
        );
    }
} else {
    echo json_encode([
        "error" => true,
        "message" => "Query gagal: " . $conn->error
    ]);
    exit;
}

echo json_encode($notif);
