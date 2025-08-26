@echo off
echo Building Flutter app...
flutter build windows --release

echo Uploading to server...
scp build\windows\x64\runner\Release\tauzero.exe user@your-server.com:/var/www/tauzero/tauzero-latest.exe

echo Updating version info...
echo {"version": "1.0.%date:~6,4%%date:~3,2%%date:~0,2%", "download_url": "https://your-server.com/tauzero/tauzero-latest.exe", "changelog": "Auto-build %date% %time%"} > version.json
scp version.json user@your-server.com:/var/www/tauzero/

echo Deploy complete!
pause


@REM {
@REM   "version": "1.0.5",
@REM   "download_url": "https://your-server.com/tauzero/tauzero-latest.exe",
@REM   "changelog": "Исправлены баги с треками"
@REM }