[🇬🇧 English](README.en.md)
# Wstęp
Plansza testowa trybów znakowych i graficznych na PC x86 i kompatybilnych kart.
Program służy do testowania sprzętowych i programowych generatorów znakowych dostępnych dla różnych trybów kart znakowych i graficznych.
Plansza testowa składa się z tabeli 8x32 lub 16x16 napisów "Test", na każdy z nich nałożony jest inny atrybut znaku (od 0 do 0xFF).
# Sposób użycia
Kod źródłowy należy zassemblować,
```
nasm graf.asm -o image.bin
```
a następnie wgrać na nośnik rozruchowy.
```
sudo dd if=image.img of=/dev/sdX bs=4M status=progress conv=fsync
```
Po zbootowaniu testowanego komputera powinien wyświetlić się obraz testowy.
Po naciśnięciu dowolnego klawisza nastąpi wybranie kolejnego trybu znakowego lub graficznego.
W przypadku trybów graficznych program testuje programowy generator znakowy zawarty w VBIOS karty.
Jeśli karta wyświetla znaki niepoprawnie bądź wcale, oznacza to brak możliwości użycia programowego generatora znaków w danym trybie.
# Wyniki testu
## Przewidywane dla 100% kart poprawnie działające tryby znakowe z generatorem sprzętowym
Są to zalecane tryby znakowe, które należy stosować oczekując poprawnego i standardowego działania na różnych modelach sprzętu.
- 0x02 (80x25 znaków, 16 kolorów lub skala szarości)
- 0x03 (80x25 znaków, 16 kolorów)

## Tryby znakowe z generatorem sprzętowym działające poprawnie na większości kart
Niektóre nowsze karty (np. GTX1660 SUPER) nie obsługują tych trybów.
- 0x00 (40x25 znaków, 16 kolorów lub skala szarości)
- 0x01 (40x25 znaków, 16 kolorów)
- 0x07 (80x25 znaków, 3 odcienie szarości)

## Tryby graficzne z generatorem programowym (w wielu przypadkach test wykazał że ich używalność jest ograniczona):
- 0x04 (40x25 znaków, 4 kolory)
- 0x05 (40x25 znaków, 4 kolory)
- 0x06 (80x25, czarno-biały)

Ograniczenia są spowodowane głównie artefaktami przy przewijaniu tekstu w pionie, brakiem czyszczenia ekranu i różnym zachowaniem funkcji obsługi (funkcje przerwania INT 0x10).

W pozostałych trybach, w większości graficznych (z pominięciem trybów 0x80 i wzwyż oraz trybów VESA) test wykazał niemal całkowity brak używalności.
Główne powody niezdatności do użytku generatorów programowych VBIOS:
- Ograniczona powtarzalność pomiędzy modelami kart
- Brak implementacji obsługi danego trybu
- Różnice wizualne uniemożliwiające określenie standardowego zachowania danego trybu dla wielu urządzeń
- Możliwe braki w zestawie znaków, bądź znaki wyświetlane niepoprawnie
- Skrajnie niewydajna programowa obsługa generatora (kopiowanie znaków z VRAM przez CPU do innego miejsca w VRAM)
