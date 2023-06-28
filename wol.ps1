
$jsonPath = $PSScriptRoot + "\MacAddress.json"
$jsonData =(Get-Content $jsonPath | ConvertFrom-Json)
Write-Host ($jsonData.mac_address)

$macAddr=[byte[]]($jsonData.mac_address.split("-") | ForEach-Object{[Convert]::ToInt32($_, 16)});
$magicPacket=([byte[]](@(0xff)*6)) + $macAddr * 16;

$udpClient=new-object System.Net.Sockets.UdpClient;
$udpClient.Connect("255.255.255.255", 9);
$udpClient.Send($magicPacket, $magicPacket.Length)|out-null;
$udpClient.Close();

Write-Output "Send MagicPacket.";