<?php
header('Content-Type: application/json'); 
include 'koneksi.php';

// Nama kolom tabel
$sql = "SELECT nama_rs FROM settings WHERE id_set = 1";

$result = $conn->query($sql);

// Pengecekan query
if (!$result) {
    echo json_encode(["error" => "Query failed: " . $conn->error], JSON_UNESCAPED_UNICODE);
    exit;
}

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
} else {
    echo json_encode(["nama_rs" => "No data found"], JSON_UNESCAPED_UNICODE);
}

$conn->close();
?>
