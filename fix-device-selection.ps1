# VS Code Device Selection Fix Script
Write-Host "Fixing VS Code device selection infinite loading..." -ForegroundColor Green

# 1. Force kill VS Code and all related processes
Write-Host "Step 1: Force closing VS Code..." -ForegroundColor Yellow
Get-Process -Name "*Code*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process -Name "*flutter*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process -Name "*dart*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# 2. Clean VS Code workspace and extension data
Write-Host "Step 2: Cleaning VS Code extension data..." -ForegroundColor Yellow
$vsCodePaths = @(
    "$env:APPDATA\Code\User\workspaceStorage",
    "$env:APPDATA\Code\logs",
    "$env:APPDATA\Code\CachedExtensions\dart-code*",
    "$env:USERPROFILE\.vscode\extensions\.obsolete"
)

foreach ($path in $vsCodePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Cleaned: $path" -ForegroundColor Gray
    }
}

# 3. Update VS Code settings with absolute paths
Write-Host "Step 3: Updating VS Code settings with absolute paths..." -ForegroundColor Yellow
$absoluteFlutterPath = (Resolve-Path ".fvm\flutter_sdk").Path.Replace('\', '/')
$settings = @{
    "cmake.sourceDirectory" = "D:/Work/Repos/exachanger_get_app/windows"
    "dart.flutterSdkPath" = $absoluteFlutterPath
    "dart.sdkPath" = "$absoluteFlutterPath/bin/cache/dart-sdk"
    "dart.checkForSdkUpdates" = $false
    "dart.enableSdkFormatter" = $true
    "dart.flutterSdkPaths" = @($absoluteFlutterPath)
    "dart.analysisServerFolding" = $false
    "dart.enableCompletionCommitCharacters" = $false
    "dart.previewLsp" = $true
    "dart.maxLogLineLength" = 2000
    "dart.flutterDaemonLogFile" = "`${workspaceFolder}/.vscode/flutter-daemon.log"
    "dart.extensionLogFile" = "`${workspaceFolder}/.vscode/dart-extension.log"
    "dart.allowAnalytics" = $false
    "dart.analysisExcludedFolders" = @("build", ".dart_tool", ".packages")
    "terminal.integrated.env.windows" = @{
        "PATH" = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$absoluteFlutterPath/bin;`${env:PATH}"
        "FLUTTER_ROOT" = $absoluteFlutterPath
        "DART_SDK" = "$absoluteFlutterPath/bin/cache/dart-sdk"
    }
    "dart.env" = @{
        "PATH" = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;$absoluteFlutterPath/bin;`${env:PATH}"
        "FLUTTER_ROOT" = $absoluteFlutterPath
        "DART_SDK" = "$absoluteFlutterPath/bin/cache/dart-sdk"
    }
}

# Ensure .vscode directory exists
if (!(Test-Path ".vscode")) {
    New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
}

# Write settings to file
$settings | ConvertTo-Json -Depth 3 | Set-Content ".vscode\settings.json" -Encoding UTF8
Write-Host "  ✓ Updated settings.json with absolute paths" -ForegroundColor Green

# 4. Test Flutter SDK directly
Write-Host "Step 4: Testing Flutter SDK..." -ForegroundColor Yellow
try {
    $devices = & "$absoluteFlutterPath\bin\flutter.bat" devices --machine 2>&1
    Write-Host "  ✓ Flutter devices command working" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Flutter devices command failed: $_" -ForegroundColor Red
    exit 1
}

# 5. Create launch configuration for direct device access
Write-Host "Step 5: Creating launch configurations..." -ForegroundColor Yellow
$launchConfig = @{
    "version" = "0.2.0"
    "configurations" = @(
        @{
            "name" = "Flutter (Chrome)"
            "request" = "launch"
            "type" = "dart"
            "program" = "lib/main.dart"
            "deviceId" = "chrome"
            "flutterMode" = "debug"
            "flutterSdkPath" = $absoluteFlutterPath
        },
        @{
            "name" = "Flutter (Edge)"
            "request" = "launch"
            "type" = "dart"
            "program" = "lib/main.dart"
            "deviceId" = "edge"
            "flutterMode" = "debug"
            "flutterSdkPath" = $absoluteFlutterPath
        },
        @{
            "name" = "Flutter (Windows)"
            "request" = "launch"
            "type" = "dart"
            "program" = "lib/main.dart"
            "deviceId" = "windows"
            "flutterMode" = "debug"
            "flutterSdkPath" = $absoluteFlutterPath
        }
    )
}

$launchConfig | ConvertTo-Json -Depth 4 | Set-Content ".vscode\launch.json" -Encoding UTF8
Write-Host "  ✓ Created launch.json with direct device configurations" -ForegroundColor Green

Write-Host "`n🎉 Device selection fix completed!" -ForegroundColor Green
Write-Host "`n📋 Critical Steps - Do these IN ORDER:" -ForegroundColor Cyan
Write-Host "1. Keep VS Code CLOSED for now" -ForegroundColor White
Write-Host "2. Wait 10 seconds" -ForegroundColor White
Write-Host "3. Open VS Code" -ForegroundColor White
Write-Host "4. IMMEDIATELY go to Command Palette (Ctrl+Shift+P)" -ForegroundColor White
Write-Host "5. Type 'Flutter: Change SDK' and select it" -ForegroundColor White
Write-Host "6. Navigate to and select: $absoluteFlutterPath" -ForegroundColor Yellow
Write-Host "7. Wait for extension to reload completely" -ForegroundColor White
Write-Host "8. Run 'Dart: Restart Analysis Server' from Command Palette" -ForegroundColor White
Write-Host "9. Open lib/main.dart" -ForegroundColor White
Write-Host "10. Check device selection dropdown" -ForegroundColor White
Write-Host "`n💡 Alternative: Use the launch configurations in the Run panel" -ForegroundColor Cyan
