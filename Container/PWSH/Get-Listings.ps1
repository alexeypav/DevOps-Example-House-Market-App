
function Execute-SqlQuery ($ConnectionString, $SQLQuery) {
    $datatable = New-Object System.Data.DataTable

    $connection = New-Object System.Data.SQLClient.SQLConnection
    $connection.ConnectionString = $ConnectionString
    $connection.Open()

    $command = New-Object System.Data.SQLClient.SQLCommand
    $command.Connection = $connection
    $command.CommandText = $SQLQuery
    $command.CommandTimeout = 0

    $reader = $command.ExecuteReader()
    $datatable.Load($reader)
    $connection.Close()

    return $datatable
}


$sql_server_connection_string = "Data Source=tcp:$env:dbServert;Initial Catalog=$env:db;User Id=$env:dbUser;Password=$env:dbPassword"

$date = get-date -Format "yyyy-MM-dd"

"Processing RENZ"

$uri = "https://platform.realestate.co.nz/search/v1/listings?filter%5Bcategory%5D%5B0%5D=res_sale&filter%5Bregion%5D%5B0%5D=35&page%5BgroupBy%5D=latest&page%5Blimit%5D=20&page%5Boffset%5D=1"

$resultAK = Invoke-RestMethod -Method get -Uri $uri

$uri = "https://platform.realestate.co.nz/search/v1/listings?filter%5Bcategory%5D%5B0%5D=res_sale&page%5BgroupBy%5D=latest&page%5Blimit%5D=20"

$resultNZ = Invoke-RestMethod -Method get -Uri $uri

$resultNZ 

$resultAK

$totalTodayAKCount = 0
$page = 0

do {
    
    $count = 0

    $result = (Invoke-RestMethod -Method Get -Uri "https://platform.realestate.co.nz/search/v1/listings?filter%5Bcategory%5D%5B0%5D=res_sale&filter%5Bregion%5D%5B0%5D=35&page%5BgroupBy%5D=latest&page%5Blimit%5D=20&page%5Boffset%5D=$page")

    $result.data.attributes.'published-date' | ForEach-Object { if ( ([datetime]$_).ToString("yyyy-MM-dd") -eq $date) { $count += 1 } }

    "Page: $($page/20 + 1)"

    $totalTodayAKCount += $count

    $page += 20


}while ($count -eq 20)


$totalTodayCount = 0
$page = 0

do {
    
    $count = 0

    $result = (Invoke-RestMethod -Method Get -Uri "https://platform.realestate.co.nz/search/v1/listings?filter%5Bcategory%5D%5B0%5D=res_sale&page%5BgroupBy%5D=latest&page%5Blimit%5D=20&page%5Boffset%5D=$page")

    #$result.data.attributes.'created-date' | ForEach-Object {if( ([datetime]$_).ToString("yyyy-MM-dd") -eq $date){$count += 1}}
    $result.data.attributes.'published-date' | ForEach-Object { if ( ([datetime]$_).ToString("yyyy-MM-dd") -eq $date) { $count += 1 } }

    "Page: $($page/20 + 1)"

    $totalTodayCount += $count

    $page += 20


}while ($count -eq 20)

$totalListings = $resultNZ.meta.totalResults

$totalListingsAK = $resultAK.meta.totalResults

$totalTodayCount
$totalTodayAKCount

"Listings Today:  $totalTodayAKCount"

$dateToday = $dateToday
$totalListings = $totalListings
$totalTodaycount = $totalTodaycount
$totalListingsAK = $totalListingsAK
$totalTodayAKCount = $totalTodayAKCount

$data = [pscustomobject] @{
    
    'Date'          = $date
    'NZTotal'       = $totalListings
    'NZToday'       = $totalTodaycount
    'AucklandTotal' = $totalListingsAK
    'AucklandToday' = $totalTodayAKCount
}

$data | fl *

"Uploading Data..."

$query = "IF NOT EXISTS (SELECT * FROM DataRENZ WHERE Date = '$date')

        INSERT INTO DataRENZ (Date,NZTotal,NZToday,AucklandTotal,AucklandToday)
        Values('$date',$totalListings,$totalTodaycount,$totalListingsAK,$totalTodayAKCount)

        ELSE
		BEGIN
            UPDATE DataRENZ
            SET NZTotal = '$totalListings', NZToday = '$totalTodaycount' ,AucklandTotal = '$totalListingsAK',AucklandToday = '$totalTodayAKCount'
            WHERE Date = '$date'
            END
        "

Execute-SqlQuery -ConnectionString $sql_server_connection_string -SQLQuery $query


"Processing Trade Me"

$html = invoke-restmethod "https://www.trademe.co.nz/Browse/Property/RegionListings.aspx?sort_order=expiry_desc&cid=3399"

$match1 = $html.tostring() -split "[`r`n]" | select-string "LV_listingTableHeader_headerColumnListView" | select -Last 1 | Out-String

$totalListings = $match1.Substring(178, 5)

if ($totalListings -like "*more*") { $totalListings = 32000 }

$totalListings

$html = invoke-restmethod "https://www.trademe.co.nz/Browse/Property/RegionListings.aspx?sort_order=expiry_desc&cid=3399&134=1"

$match2 = $html.tostring() -split "[`r`n]" | select-string "LV_listingTableHeader_headerColumnListView" | select -Last 1 | Out-String

$totalListingsAK = $match2.Substring(178, 5)

$totalListingsAK

$totalTodayAKCount = 0
$page = 1

do {

    $html = (Invoke-Restmethod -Uri "https://www.trademe.co.nz/Browse/Property/RegionListings.aspx?sort_order=expiry_desc&cid=3399&134=1&page=$page")

    $match2 = $html.tostring() -split "[`r`n]" | select-string "Listed Today" 

    $count = $match2.count

    "Page: $page, Listings $count"

    $totalTodayAKCount += $count

    $page ++


}while ($count -eq 24)

$totalTodayAKCount

$totalTodayCount = 0
$page = 1

do {

    $html = (Invoke-Restmethod -Uri "https://www.trademe.co.nz/Browse/Property/RegionListings.aspx?sort_order=expiry_desc&cid=5748&page=$page")

    $match2 = $html.tostring() -split "[`r`n]" | select-string "Listed Today" 

    $count = $match2.count

    "Page: $page, Listings $count"

    $totalTodayCount += $count

    $page ++



}while ($count -eq 24)

"Listings Today:  $totalTodayAKCount"

$date = get-date -Format "yyyy-MM-dd"

$dateToday = $dateToday
$totalListings = $totalListings
$totalTodaycount = $totalTodaycount
$totalListingsAK = $totalListingsAK
$totalTodayAKCount = $totalTodayAKCount

$data = [pscustomobject] @{
    
    'Date'          = $date
    'NZTotal'       = $totalListings
    'NZToday'       = $totalTodaycount
    'AucklandTotal' = $totalListingsAK
    'AucklandToday' = $totalTodayAKCount
}

$data

"Uplodaing Data..."

$query = "IF NOT EXISTS (SELECT * FROM DataTradeMe WHERE Date = '$date')

        INSERT INTO DataTradeMe (Date,NZTotal,NZToday,AucklandTotal,AucklandToday)
        Values('$date',$totalListings,$totalTodaycount,$totalListingsAK,$totalTodayAKCount)

        ELSE
		BEGIN
            UPDATE DataTradeMe
            SET NZTotal = '$totalListings', NZToday = '$totalTodaycount' ,AucklandTotal = '$totalListingsAK',AucklandToday = '$totalTodayAKCount'
            WHERE Date = '$date'
            END
        "

Execute-SqlQuery -ConnectionString $sql_server_connection_string -SQLQuery $query

"Done, waiting 15 minutes..."