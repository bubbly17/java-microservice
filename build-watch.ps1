
$projectFolder = (Get-Location).Path
$sourceFolder = Join-Path $projectFolder "src\main\java\com\example"
$sourceFile = Join-Path $sourceFolder "App.java"
$releaseFolder = Join-Path $projectFolder "releases"

New-Item -ItemType Directory -Force -Path $releaseFolder | Out-Null

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $sourceFolder
$watcher.Filter = "App.java"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true

$version = 1

Write-Host "Watching App.java for changes..."
Write-Host "Save App.java to create a new JAR."
Write-Host "Press Ctrl+C to stop."

while ($true) {
    $change = $watcher.WaitForChanged("Changed")

    Start-Sleep -Milliseconds 1000

    Write-Host "`nChange detected. Building..."

    mvn clean package

    if ($LASTEXITCODE -eq 0) {
        $jarFile = Join-Path $projectFolder "target\java-microservice.jar"

        if (Test-Path $jarFile) {
            $newName = "java-microservice-v$version.jar"
            $destination = Join-Path $releaseFolder $newName

            Copy-Item $jarFile $destination

            Write-Host "Created: $destination"
            $version++
        }
        else {
            Write-Host "JAR file was not found."
        }
    }
    else {
        Write-Host "Build failed. Fix the error and save App.java again."
    }
}
