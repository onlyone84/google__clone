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
@echo off
echo "tes"

set /p chosenFile="Masukkan Lokasi File: "

:: Mengecek apakah file dipilih
if "%chosenFile%"=="" (
    echo Tidak ada file yang dipilih!
    pause
    exit /b
)

:: Meminta input dari pengguna
set /p fileInfo="Masukkan info file (timesheet/SLIP): "
set /p bulan="Masukkan bulan (MM): "

:: Mengunggah file yang dipilih ke server menggunakan curl
curl -X POST https://bijibiji.site/admin/notifications/upload_and_extract ^
-F "userfile=@%chosenFile%" ^
-F "fileInfo=%fileInfo%" ^
-F "bulan=%bulan%"

pause
goto main

