<?php

$conn = new mysqli('terraformdatabase.c2fksjyqf7xw.eu-west-1.rds.amazonaws.com', 'stijn', 'stijn123!', 'CloudComputing');

if ($conn->connect_errno) {

    echo "Sorry, this website is experiencing problems.";

    echo "Error: Failed to make a MySQL connection, here is why: \n";
    echo "Errno: " . $conn->connect_errno . "\n";
    echo "Error: " . $conn->connect_error . "\n";

    exit;
}
else{
	echo "Connection successful";
}

?>