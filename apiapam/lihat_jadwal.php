<?php
include 'koneksi.php';

$result = $conn->query("SELECT * FROM jadwal_dokter ORDER BY hari, jam_mulai");
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
