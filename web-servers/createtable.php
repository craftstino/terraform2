<?php

$conn = new mysqli('terraformdatabase.c2fksjyqf7xw.eu-west-1.rds.amazonaws.com', 'stijn', 'stijn123!');

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

//Creating database

$sql = "CREATE DATABASE CloudComputing;";

if ($conn->query($sql) === TRUE) {
	echo "De query werd succesvol uitgevoerd";
} 
else {
	echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->select_db("CloudComputing");

//creating table
	
$sql = "CREATE TABLE professions (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(255),
    profession varchar(255),
    PRIMARY KEY (id));";

if ($conn->query($sql) === TRUE) {
	echo "De query werd succesvol uitgevoerd";
} 
else {
	echo "Error: " . $sql . "<br>" . $conn->error;
}

	
$conn->close(); 

?>