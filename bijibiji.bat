@echo off
:login
cls
echo ==============================
echo           Login Systemntnt
echo ==============================
set /p nik="     Masukkan NIK     : "
set /p password="Masukkan Password: "

:: Melakukan pengecekan login ke server menggunakan curl dan menangkap token
curl -X POST https://bijibiji.site/admin/notifications/login -d "nik=%nik%" -d "password=%password%" --silent --show-error --output login_response.txt

:: Mengecek apakah login_response.txt ada dan membaca hasil login
if exist login_response.txt (
    for /f "tokens=*" %%a in (login_response.txt) do set "response=%%a"
    del login_response.txt
) else (
    echo Gagal mendapatkan respons dari server.
    pause
    goto login
)

:: Cek apakah login berhasil atau gagal
echo %response% | findstr /i "success" >nul
if %errorlevel%==0 (
    cls
    echo Login berhasil!
    echo.
    pause
    goto main
) else (
    cls
    echo Login gagal: Nik atau Password salah!
    pause
    goto login
)

:main
cls
echo =============================
echo    BijiBiji Direct Acces    
echo =============================
echo  1. Send Notification
echo  2. Delete All Notifications
echo  3. Tambah Karyawan
echo  4. Update Data Karyawan
echo  5. Upload File
echo  6. Exit
echo.
choice /c 123456 /n /m "Press the number of your choice: "

if errorlevel 6 goto exit
if errorlevel 5 goto uploadFile
if errorlevel 4 goto update
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
echo =====================
echo   Select File Info
echo =====================
echo 1. Timesheet
echo 2. Slip Gaji
echo 3. Rooster
echo 4. Laporan HeadCount
echo 5. Exit

choice /c 1234 /n /m "Press the number of your choice: "

if errorlevel 5 exit
if errorlevel 4 set fileInfo="laporanhc"
if errorlevel 3 set fileInfo="rooster"
if errorlevel 2 set fileInfo="slip"
if errorlevel 1 set fileInfo="timesheet"

echo File Info: %fileInfo%
::input_bulan
set /p bulan="Masukkan bulan (1-12): "

:: Validate input to ensure it's numeric and within range
if "%bulan%"=="" (
    echo Bulan tidak boleh kosong. Silakan coba lagi.
    goto input_bulan
)

for /f "delims=0123456789" %%a in ("%bulan%") do (
    echo Input tidak valid. Silakan masukkan angka.
    goto input_bulan
)

if %bulan% lss 1 (
    echo Bulan tidak valid. Harus antara 1 dan 12.
    goto input_bulan
) else if %bulan% gtr 12 (
    echo Bulan tidak valid. Harus antara 1 dan 12.
    goto input_bulan
)

cls
echo Mengunggah file...

:: Mengunggah file ke server menggunakan curl dan menangkap respons dari server
curl -X POST https://bijibiji.site/admin/notifications/upload_and_extract ^
-F "userfile=@%chosenFile%" ^
-F "fileInfo=%fileInfo%" ^
-F "bulan=%bulan%" ^
--silent --show-error --output response.txt
cls
:: Menampilkan output dari respons yang diterima dari server
if exist response.txt (
    type response.txt
    del response.txt
) else (
    echo Gagal mendapatkan respons dari server.
)

echo.
pause
goto main

:update
cls
@echo off
setlocal
echo Tambah Karyawan
set /p nik="          Masukkan Nik Karyawan              : "
set /p jabatan="      Masukkan Jabatan                   : "
set /p password="     Masukkan Password                  : "

curl -X POST https://bijibiji.site/admin/notifications/updateDataAksi -d "nik=%nik%" -d "jabatan=%jabatan%" -d "password=%password%"

echo.
pause
goto main

:exit
exit
pause
