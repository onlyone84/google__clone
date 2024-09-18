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
:: Script untuk upload file RAR melalui curl

set "url=https://bijibiji.site/admin/notifications/upload_and_extract"  :: Ganti dengan URL controller CodeIgniter kamu
set /p filepath="Masukkan Lokasi File: "

echo Memeriksa file: %filepath%

:: Periksa apakah file ada
if not exist "%filepath%" (
    echo File RAR tidak ditemukan!
    pause
    exit /b 1
)

echo Mengunggah file: %filepath% ke %url%

:: Mengunggah file menggunakan curl
curl -X POST "%url%" -F "userfile=@%filepath%" -H "Content-Type: multipart/form-data"

:: Jika berhasil atau gagal
if %errorlevel% neq 0 (
    echo Gagal mengunggah file.
) else (
    echo Berhasil mengunggah file.
)

pause
goto main


