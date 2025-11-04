<?php
include 'koneksi.php';

$isi = $_POST['isi'] ?? '';

if (empty($isi)) {
  echo json_encode(["success" => false, "message" => "Isi saran tidak boleh kosong."]);
  exit;
}

$sql = "INSERT INTO saran (isi) VALUES (?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $isi);

if ($stmt->execute()) {
  echo json_encode(["success" => true, "message" => "Saran berhasil dikirim."]);
} else {
  echo json_encode(["success" => false, "message" => "Gagal menyimpan saran."]);
}
?>
