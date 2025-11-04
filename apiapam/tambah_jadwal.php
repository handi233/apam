<?php
include 'db_connect.php';

$nama_dokter = $_POST['nama_dokter'] ?? '';
$spesialis   = $_POST['spesialis'] ?? '';
$hari        = $_POST['hari'] ?? '';
$jam_mulai   = $_POST['jam_mulai'] ?? '';
$jam_selesai = $_POST['jam_selesai'] ?? '';

if (!$nama_dokter || !$spesialis || !$hari || !$jam_mulai || !$jam_selesai) {
  echo json_encode(["success" => false, "message" => "Semua field wajib diisi."]);
  exit;
}

$sql = "INSERT INTO jadwal_dokter (nama_dokter, spesialis, hari, jam_mulai, jam_selesai)
        VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $nama_dokter, $spesialis, $hari, $jam_mulai, $jam_selesai);

if ($stmt->execute()) {
  echo json_encode(["success" => true, "message" => "Jadwal dokter berhasil ditambahkan."]);
} else {
  echo json_encode(["success" => false, "message" => "Gagal menambahkan jadwal."]);
}
?>
