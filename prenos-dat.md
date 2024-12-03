---
layout: default
title: Přenos dat
permalink: /prenos-dat.html
---

# Přenos dat ze DHT22 senzoru pomocí Arduina do počítače

Cílem této práce je popsat proces přenosu dat z DHT22 senzoru do počítače prostřednictvím mikrokontroléru Arduino. Arduino Uno využívá k přenosu dat do počítáče protokol UART (Universal Asynchronous Receiver/Transmitter) a pomocí integrovaného obvodu CH340 konvertuje UART na protokol USB (Universal Serial Bus). Samotný senzor používá pro přenos dat nestandartní jednovodičový protokol.

V rámci tohoto procesu bude nejprve popsána metoda čtení dat ze senzoru DHT22 pomocí knihovny Arduino, která umožňuje dekódování digitálních signálů z výstupu senzoru. Následně se zaměříme na popis sériového přenosu těchto dat do počítače, kde budou hodnoty teploty a vlhkosti zobrazeny v reálném čase.

## Zdrojový kód

```c++
// Knihovna pro práci se senzory DHT.
#include "DHT.h"

// Konstrukce dht objektu. První parametr udává pin pro datový přenos, druhý typ senzoru.
DHT dht(8, DHT22);


// Proměnná pro vlhkost.
float humidity;

// Proměnná pro teplotu.
float temperature;

// Funkce které jsou na arduinu volány před začátkem hlavní smyčky.
void setup() {
  // Přepnutí pinu na interní pullup rezistor.
  pinMode(8, INPUT_PULLUP);

  // Nastavení seriového přenosu na 9600 baud.
  Serial.begin(9600);

  // Inicializace dht objektu pro čtení senzoru.
  dht.begin();
}

// Hlavní smyčka
void loop() {
  // Čtení vlhkosti ze senzoru.
  humidity = dht.readHumidity();

  // Čtení teploty ze senzoru.
  temperature = dht.readTemperature();

  // Výpis hodnot na seriovou linku.
  Serial.print("Vlhkost: ");                
  Serial.print(humidity);
  Serial.print(" %, Teplota: ");
  Serial.print(temperature);
  Serial.println(" Celsius");

  // Pětisekundové čekání.
  delay(5000);
}
```

## Přenos dat ze senzoru DHT22

Senzor DHT22 měří teplotu a vlhokost a pro přenos dat používá jeden datový vodič. Má 4 piny, ale poslední není potřeba připojovat. Tyto 4 piny jsou:

- VCC - napájení v rozsahu 3,3 až 5,5 voltů.
- DATA - pin pro přenos dat
- GND - zemnící pin.
- NC (Not Connected) nebo další GND - nepoužívaný pin.

### Proces měření a přenos dat

Po zapnutí napajení senzor provede inicializaci. Před zahájením měření musí Arduino poslat krátký pulz na pin DATA, aby spustil měření. Senzor komunikkuje pomocí specifického protokolu, který zahrnuje následující kroky:

- Arduino pošle alespoň milisekundu dlouhý pulz.
- Mezi 20 a 40 mikrosekundami senzor odpoví 80 mikrosekundovým pulzem s 80 mikrosekundovou pauzou.
- Senzor přenáší data po 40 bitech
- Každý bit je reprezentován 50 mikrosekund dlouhým pulzem a 26 až 28 mikrosekund dlouhou pauzou, která značí logickou 0. Pokud je pauza 70 mikrosekund, značí to logickou 1.
- Je 16 bitů pro reprezentaci teploty
- Je přeneseno 16 bitů pro reprezentaci vlhkosti
- 8 bitů pro kontrolní součet

První bit teploty je znaménkový. Hodnota se poté musí vydělit 10ti. Vlhkost je v procentech, také se ale musí vydělit 10ti. Kontrolní součet je hodnota, která vznikne postupným sčítáním příchozích dat po 8mi bitech. Bere se jen 8 nejméně vyznamných bitů. Pokud kontrolní součet nesedí, nastala chyba při přenosu.

## UART

Asynchronní komunikační protokol, který přenáší data seriově po bitech. Rychlost přenosu je předem definovaná pomocí baud rate, neboli bitů za sekund. Protokol využívá dva vodiče, jeden pro odesílání, druhý pro přijmaní. Průběh přenosu je jednoduchý:

- Je poslán start bit, který signalizuje začátek přenosu.
- Je poslán předem dohodnutý počet bitů.
- Je poslán stop bit, který indikuje ukončení přenosu.
- Pokud je nastaven paritní bit, příjmač pomocí něho kontroluje správnost dat.

Všechny parametry jsou předem dohodnuté. Signál je také jednoduchý, vysoký pro logickou 1 a nízký pro logickou 0. Několik po sobě jdoucích stejných logických signálů je rozlišeno díký známé rychlosti přenosu.

## CH340

Integrovaný obvod, který převádí UART na USB protokol. CH340 je detekován v počítači jako USB zařízení. Ovladač operačního systému poté umožnuje komunikaci s integrovaným obvodem jako se seriovým portem. USB je mnohem složitější protokol než UART. K přenášení využívá pakety. Každý paket může obsahovat kontrolní informace jako CRC (cyklická redudanční kontrola), což zajištuje detekci dat. Samotný signál USB je přenášen pomocí změny signálu pro logickou 0 a bezezměny logickou 1. Změny signálu pro každou logickou 0 zajištují synchronizaci.

Na vysoké úrovni má USB třídy. CH340 má vlastní implementaci a tedy třídu vendor specific, ale pro seriový přenos se může využívat CDC (Commnication Device Class) s podtřídou ACM (Abstract Control Model). Zařízení podporující tuto třídu by měli fungovat podobně jako tradiční RS-232 porty.