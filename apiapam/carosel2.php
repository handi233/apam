<?php
header('Content-Type: application/json');
include 'koneksi.php';

$sql = "SELECT image FROM settings2 where id = 2"; // nama tabel di database
$result = $conn->query($sql);

$images = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $images[] = ["image" => $row["image"]];
    }
}

echo json_encode($images);
$conn->close();
