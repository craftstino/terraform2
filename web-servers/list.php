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

			?>
		
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
					<td></td>
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