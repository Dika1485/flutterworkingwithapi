<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutterworkingwithapi";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Koneksi ke database gagal: " . $conn->connect_error);
}
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
    // Mengambil data mahasiswa
    $sql = "SELECT * FROM mahasiswa";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $mahasiswa = array();
        while ($row = $result->fetch_assoc()) {
            $mahasiswa[] = $row;
        }
        echo json_encode($mahasiswa);
    }
    else {
        echo "Data mahasiswa kosong.";
    }
}
if ($method === "POST") {
    // Menambahkan data mahasiswa
    $data = json_decode(file_get_contents("php://input"), true);
    $nama = $data["nama"];
    $jurusan = $data["jurusan"];
    $sql = "INSERT INTO mahasiswa (nama, jurusan) VALUES ('$nama', '$jurusan')";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "PUT") {
    // Memperbarui data mahasiswa
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $nama = $data["nama"];
    $jurusan = $data["jurusan"];
    $sql = "UPDATE mahasiswa SET nama='$nama', jurusan='$jurusan' WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = "berhasil";
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "DELETE") {
    // Menghapus data mahasiswa
    $id = $_GET["id"];
    $sql = "DELETE FROM mahasiswa WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
    }
    else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
?>