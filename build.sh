#!/bin/sh
# Build di Linux/WSL: sudo apt install mono-mcs binutils-mingw-w64-x86-64
set -e
mkdir -p out
# 1) add-in (DLL)
mcs -target:library -out:out/SC_by_chandraoktya.dll -platform:anycpu -nowarn:1591,0168,0219 \
  -r:System.Windows.Forms.dll -r:System.Drawing.dll -r:System.Core.dll -r:Microsoft.CSharp.dll \
  -resource:src/Ribbon.xml,Ribbon.xml src/Connect.cs src/Engine.cs src/SetupDialog.cs
# 2) resource Windows (ikon, manifest asInvoker, version info)
(cd installer && x86_64-w64-mingw32-windres --preprocessor=./pp.sh -O res app.rc -o app.res)
# 3) installer (WinForms) dengan add-in + aset tertanam
mcs -target:winexe -out:out/SC_by_chandraoktya_Setup.exe -platform:anycpu -nowarn:1591 \
  -r:System.Windows.Forms.dll -r:System.Drawing.dll \
  -win32res:installer/app.res \
  -resource:out/SC_by_chandraoktya.dll,payload.dll \
  -resource:installer/donation_qr.png,donation_qr.png \
  -resource:installer/ui_logo.jpg,ui_logo.jpg \
  -resource:installer/app_icon.png,app_icon.png \
  installer/Setup.cs
echo "Selesai: out/SC_by_chandraoktya_Setup.exe"
