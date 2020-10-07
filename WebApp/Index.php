<?php

//All Table Style, for the 4 tables
$tableStyle = 'class="table table-striped  table-sm table-light table-bordered" style="font-size: 12px; "';
	
date_default_timezone_set('NZ');

$date = date("Y-m-d");


	
	
	$serverName = "$(sqlServer)"; //serverName\instanceName

$connectionInfo = array( "Database"=>"($dbName)", "UID"=>"$(dbUserName)", "PWD"=>"$(dbPassword)");
$conn = sqlsrv_connect( $serverName, $connectionInfo);

if( $conn ) {
     //echo "Connection established.<br />";
}else{
     echo "Connection could not be established.<br />";
     die( print_r( sqlsrv_errors(), true));
}
	
$sql = "SELECT TOP 1000 * FROM DataRENZ ORDER BY Date DESC";

$result = sqlsrv_query( $conn, $sql);

$renzResults = array();

while( $row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC) ) {
	array_push($renzResults,$row);
}

$sql = "SELECT TOP 1000 * FROM DataTradeMe ORDER BY Date DESC";

$result = sqlsrv_query( $conn, $sql);

$tmResults = array();

while( $row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC) ) {
	array_push($tmResults,$row);
}
	
	sqlsrv_close($conn) ; 


//var_dump($renzResults);
//var_dump($tmResults);


?>






<!doctype html>
<html lang="en">
  <head>
		<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-147707020-1"></script>
	<script>
	  window.dataLayer = window.dataLayer || [];
	  function gtag(){dataLayer.push(arguments);}
	  gtag('js', new Date());

	  gtag('config', 'UA-147707020-1');
	</script>

	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','GTM-5QJXPRW');</script>
	<!-- End Google Tag Manager -->
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

    <!-- Main Styles -->
    <link rel="stylesheet" href="css/main.css">
	
	<!-- Auto Refresh -->
	<!-- <meta http-equiv="refresh" content="10" > -->

    <title>Property Listing Stats NZ</title>
</head>

<body>
	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5QJXPRW"
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->
    <div class="container">
        <div class="page-header">
            <h1 class="text-center" >Property Listing Stats</h1>
        </div>
    </div>
    <div id="main" class="container-fluid">
        <div class="modal-body row ">
            <div class="col-md-6 ">
                
                <h2>TradeMe.co.nz</h2>
                <div class="row">
                    <div class="col">
                        
                        <div class="">

                            <table  <?php echo $tableStyle; ?>>
							  <tr>
								<th>Date</th>
								<th>NZ Listed This Day</th> 
								<th>NZ Listed Total</th>
								<th>Auckland Listed This Day</th>
								<th>Auckland Listed Total</th>
							  </tr>
								<?php
								foreach($tmResults as $result) {
									
									$dateShow = ($result['Date']->format('Y-m-d'));
									
									if($date == $dateShow){
										
										$dateShow = "Today";
									}	
									
									echo	"<tr><td>". $dateShow  ."</td><td>".$result['NZToday']."</td><td>".$result['NZTotal']."</td><td>".$result['AucklandToday']."</td><td>".$result['AucklandTotal']."</td></tr>";

								}
								?>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 ">
                
                <h2>RealEstate.co.nz</h2>
                <div class="row">
                    <div class="col">
                        
                        <div class="">
                            <table <?php echo $tableStyle; ?>>
							  <tr>
								<th>Date</th>
								<th>NZ Listed This Day</th> 
								<th>NZ Listed Total</th>
								<th>Auckland Listed This Day</th>
								<th>Auckland Listed Total</th>
								</tr>
								<?php
								foreach($renzResults as $result) {
									
									$dateShow = ($result['Date']->format('Y-m-d'));
									
									if($date == $dateShow){
										
										$dateShow = "Today";
									}	
									
									echo	"<tr><td>". $dateShow  ."</td><td>".$result['NZToday']."</td><td>".$result['NZTotal']."</td><td>".$result['AucklandToday']."</td><td>".$result['AucklandTotal']."</td></tr>";

								}
								?>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="footer">
        <div class="container text-center">
    <p class="credit"><?php echo date("D M d, Y G:i");?></p>
	<br>
	<p>© 2019</p> 
        </div>
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>