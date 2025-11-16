<?php
include 'koneksi.php';

$result = $conn->query("SELECT * FROM list_kamar ORDER BY nama_kamar,sisa_kamar");
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
