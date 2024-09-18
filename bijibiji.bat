@echo off
:main
cls
echo =============================
echo   BijiBiji Direct Acces
echo =============================
echo  1. Send Notification
echo  2. Delete All Notifications
echo  3. Tambah Karyawan
echo  4. Upload File
echo  5. Exit
echo.
choice /c 12345 /n /m "Press the number of your choice: "

if errorlevel 5 goto exit
if errorlevel 4 goto uploadFile
if errorlevel 3 goto tambah_karyawan
if errorlevel 2 goto delete_notifications
if errorlevel 1 goto send_notification
goto main

:send_notification
cls
echo Send Notification
set /p message="Enter notification message: "
set /p info="Enter notification info: "

curl -X POST https://bijibiji.site/admin/notifications/sendToAll -d "message=%message%" -d "info=%info%"

pause
goto main

:delete_notifications
cls
echo Deleting All Notifications

curl -X POST https://bijibiji.site/admin/notifications/deleteAll

pause
goto main

:tambah_karyawan
cls
echo Tambah Karyawan
set /p nik="          Masukkan Nik Karyawan              : "
set /p nama="         Masukkan Nama Pegawai              : "
set /p jenis_kelamin="Masukkan Jenis Kelamin             : "
set /p tanggal_masuk="Masukkan Tanggal Masuk (YYYY-MM-DD): "
set /p jabatan="      Masukkan Jabatan                   : "
set /p password="     Masukkan Password                  : "
set /p supervisor="   Masukkan Supervisor                : "

curl -X POST https://bijibiji.site/admin/notifications/tambahDataAksi -d "nik=%nik%" -d "nama_pegawai=%nama%" -d "jenis_kelamin=%jenis_kelamin%" -d "tanggal_masuk=%tanggal_masuk%" -d "jabatan=%jabatan%" -d "hak_akses=2" -d "password=%password%" -d "supervisor=%supervisor%"

pause
goto main

:uploadFile
cls
@echo off
setlocal

:: Menjalankan file chooser menggunakan PowerShell dan menangkap hasilnya
for /f "delims=" %%I in ('powershell -noprofile -command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'RAR Files (*.rar)|*.rar|All Files (*.*)|*.*'; $f.InitialDirectory = [System.IO.Directory]::GetCurrentDirectory(); if ($f.ShowDialog() -eq 'OK') { $f.FileName }"') do (
    set "chosenFile=%%I"
)

:: Mengecek apakah file dipilih
if "%chosenFile%"=="" (
    echo Tidak ada file yang dipilih!
    pause
    goto main
)

:: Meminta input dari pengguna
set /p fileInfo="Masukkan info file (timesheet/slip): "
set /p bulan="Masukkan bulan: "

:: Mendapatkan ukuran file dalam byte
for %%A in ("%chosenFile%") do set fileSize=%%~zA

:: Ukuran chunk upload (dalam byte) - misalnya 1MB
set chunkSize=1048576
set /a totalChunks=(%fileSize% / %chunkSize%)
if %fileSize% lss %chunkSize% set /a totalChunks=1

echo Uploading file...
set /a count=0

:: Mengunggah file ke server menggunakan curl dan memonitor progress
curl -X POST https://bijibiji.site/admin/notifications/upload_and_extract ^
-F "userfile=@%chosenFile%" ^
-F "fileInfo=%fileInfo%" ^
-F "bulan=%bulan%" ^
--progress-bar

:: Menampilkan progress bar
:progress
    set /a count+=1
    set /a percent=(%count% * 100 / %totalChunks%)
    set /p =%percent%<nul
    echo %%%
    timeout /t 1 >nul
    if %count% lss %totalChunks% goto progress

pause

goto main

