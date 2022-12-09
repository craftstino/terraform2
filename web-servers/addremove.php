<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
  </head>
  <body>

    <div class="container">
		<form method="post">
		<div class="container">
			<div class="row">
				<div class="col"><img src="https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/eekhoorn" width="100"></div>
				<div class="col"><h1>Beroepen</h1></div>
			</div>
		</div>
		<br><br>
		<div class="alert alert-info">
			<?php

			include("connect.php");

			if(isset($_POST["verzenden"])){
				
				$name 		= mysqli_real_escape_string($conn,$_POST["name"]);
				$profession = mysqli_real_escape_string($conn,$_POST["profession"]);
				
				$sql = "INSERT INTO professions (name, profession) 
									VALUES ('".$name."', '".$profession."')";

				if ($conn->query($sql) === TRUE) {
					echo "De record werd succesvol toegevoegd aan de tabel";
				} 
				else {
					echo "Error: " . $sql . "<br>" . $conn->error;
				}
				
			}

			if(isset($_POST["verwijderen"])){
				
				$id 		= mysqli_real_escape_string($conn,$_POST["id"]);
				
				$sql = "DELETE FROM professions WHERE id=$id";

				if ($conn->query($sql) === TRUE) {
					echo "De record werd succesvol verwijderd uit de tabel";
				} 
				else {
					echo "Error: " . $sql . "<br>" . $conn->error;
				}
				
			}

			?>
		  </div>
		  <div class="form-group">
			<label for="name">Naam</label>
			<input type="text" class="form-control" name="name" id="name" aria-describedby="nameHelp" placeholder="Naam invoeren">
			<small id="nameHelp" class="form-text text-muted">Vul hier je naam in.</small>
		  </div>
		  <div class="form-group">
			<label for="name">Beroep</label>
			<input type="text" class="form-control" name="profession" id="profession" aria-describedby="profHelp" placeholder="Beroep invoeren">
			<small id="profHelp" class="form-text text-muted">Vul hier je beroep in.</small>
		  </div>
		  <input type="submit" name="verzenden" class="btn btn-primary" value="Verzenden">
		</form>
		
		
		<table class="table">
		<thead>
		  <tr>
			<th>Naam</th>
			<th>Beroep</th>
			<th></th>
		  </tr>
		</thead>
		<tbody>
		<?php
		
		$sql = "SELECT * FROM professions";
		$res = mysqli_query($conn,$sql);
		while($row = mysqli_fetch_array($res)){
			
		?>
				<tr>
					<td><?php echo $row["name"]; ?></td>
					<td><?php echo $row["profession"]; ?></td>
					<td><form method='post'><input type="hidden" name="id" value="<?php echo $row["id"]; ?>"><input type='submit' name='verwijderen' value='verwijderen' class="btn btn-danger"></form></td>
				</tr>
		<?php
		
		} 
		
		?>
		</tbody>
		</table>

		
	</div>
	
	<?php $conn->close(); ?>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"></script>
  </body>
</html>