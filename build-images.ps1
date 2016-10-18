
$scriptPath = Split-Path $script:MyInvocation.MyCommand.Path
 
Write-Host "Current script directory is $scriptPath" -ForegroundColor Yellow

$pubFolderToDelete = $scriptPath + "\pub"
remove-item -path $pubFolderToDelete -Force -Recurse -ErrorAction SilentlyContinue
#cmd /c "rd /s pub" /q

# *** WebMVC image ***
$webPathToJson = $scriptPath + "\src\Web\WebMVC\project.json"
Write-Host "webPathToJson is $webPathToJson" -ForegroundColor Yellow
$webPathToPub = $scriptPath + "\pub\webMVC"
Write-Host "webPathToPub is $webPathToPub" -ForegroundColor Yellow

Write-Host "Restore Dependencies just in case as it is needed to run dotnet publish" -ForegroundColor Blue
dotnet restore $webPathToJson
dotnet build $webPathToJson
dotnet publish $webPathToJson -o $webPathToPub

#*** Catalog service image ***
$catalogPathToJson = $scriptPath + "\src\Services\Catalog\Catalog.API\project.json"
Write-Host "catalogPathToJson is $catalogPathToJson" -ForegroundColor Yellow
$catalogPathToPub = $scriptPath + "\pub\catalog"
Write-Host "catalogPathToPub is $catalogPathToPub" -ForegroundColor Yellow

Write-Host "Restore Dependencies just in case as it is needed to run dotnet publish" -ForegroundColor Blue
dotnet restore $catalogPathToJson
dotnet build $catalogPathToJson
dotnet publish $catalogPathToJson -o $catalogPathToPub

#*** Ordering service image ***
$orderingPathToJson = $scriptPath + "\src\Services\Ordering\Ordering.API\project.json"
Write-Host "orderingPathToJson is $orderingPathToJson" -ForegroundColor Yellow
$orderingPathToPub = $scriptPath + "\pub\ordering"
Write-Host "orderingPathToPub is $orderingPathToPub" -ForegroundColor Yellow

Write-Host "Restore Dependencies just in case as it is needed to run dotnet publish" -ForegroundColor Blue
dotnet restore $orderingPathToJson
dotnet build $orderingPathToJson
dotnet publish $orderingPathToJson -o $orderingPathToPub

#*** Basket service image ***
$basketPathToJson = $scriptPath + "\src\Services\Basket\Basket.API\project.json"
Write-Host "basketPathToJson is $orderingPathToJson" -ForegroundColor Yellow
$basketPathToPub = $scriptPath + "\pub\basket"
Write-Host "basketPathToPub is $basketPathToPub" -ForegroundColor Yellow

Write-Host "Restore Dependencies just in case as it is needed to run dotnet publish" -ForegroundColor Blue
dotnet restore $basketPathToJson
dotnet build $basketPathToPub
dotnet publish $basketPathToJson -o $basketPathToPub

docker build -t eshop/web $webPathToPub
docker build -t eshop/catalog.api $catalogPathToPub
docker build -t eshop/ordering.api $orderingPathToPub
docker build -t eshop/basket.api $basketPathToPub