# CMD üzerinden derleme

Bu paket, mevcut Visual Studio 2010 / Qt4 projesini `cmd.exe` üzerinden derlemek için üç script içerir:

- `build.bat` - projeyi derler.
- `package.bat` - oluşan `.exe` dosyasını ve Qt DLL dosyalarını `dist\` klasörüne kopyalar.
- `clean.bat` - derleme çıktılarını temizler.

## Gerekenler

1. Visual Studio 2010, C++ bileşenleriyle birlikte.
2. Qt 4.x, Visual Studio 2010/MSVC ile derlenmiş sürüm.
3. Boost. Projede varsayılan yol `C:\boost_1_49_0`; farklı klasör kullanıyorsanız `BOOST_ROOT` ayarlayın.

## Kullanım

`cmd.exe` açın, proje klasörüne girin ve ortam değişkenlerini ayarlayın:

```bat
set QTDIR=C:\Qt\4.8.7-msvc2010
set BOOST_ROOT=C:\boost_1_49_0
```

Release derlemek için:

```bat
build.bat Release
```

Debug derlemek için:

```bat
build.bat Debug
```

Çalıştırılabilir paketi hazırlamak için:

```bat
package.bat Release
```

Sonuç:

```text
dist\OpcodeFinder.exe
```

## Notlar

- Proje yalnızca `Win32` hedefi tanımlıyor.
- `build.bat`, `VS100COMNTOOLS` üzerinden Visual Studio 2010 ortamını yüklemeye çalışır.
- `QTDIR\bin\moc.exe`, `uic.exe` ve `rcc.exe` bulunmazsa derleme durur.
- Boost Regex için Boost kütüphanesinin derlenmiş `.lib` dosyaları gerekir. Genellikle `BOOST_ROOT\stage\lib` ya da `BOOST_ROOT\lib32-msvc-10.0` kullanılır.
