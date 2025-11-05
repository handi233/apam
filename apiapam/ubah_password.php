<?php
include 'koneksi.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = trim($_POST['user_id'] ?? '');
    $old_password = trim($_POST['old_password'] ?? '');
    $new_password = trim($_POST['new_password'] ?? '');

    $old_password_md5 = md5($old_password);



    error_log("User ID: $user_id, Old Password MD5: $old_password_md5");

    $query = "SELECT * FROM users WHERE id_users = '$user_id' AND TRIM(password) = '$old_password_md5'";

    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $new_password_md5 = md5($new_password);
        $update = "UPDATE users SET password = '$new_password_md5' WHERE id_users = '$user_id'";

        if (mysqli_query($conn, $update)) {
            echo json_encode(["success" => true, "message" => "Password berhasil diubah"]);
        } else {
            echo json_encode(["success" => false, "message" => "Gagal mengubah password"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Password lama salah, silahkan ulangi lagi"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Metode tidak valid"]);
}
