# Дипломна работа на Иван Иванов 12 Г клас
 BASS - Bulgarian Automated Smart Sonar, IoT сонар-асистент на риболовеца

## Съдържание:

- Електрическа схема
  - Компоненти:
    - Микроконтролер - Seeed Studio XIAO ESP32C3
    - Ултразвуков сензор за измерване на дълбочината на водния стълб - JSN-SR04T
    - Комбиниран сензор за измерване на температурата на въздуха и атмосферното налягане - BME280
    - Изолоран температурен сензор за измерване температурата на водатаDS18B20
      
- Печатна платка
 - Използвана CAD с-ма - KiCad
 - За изработената платка:
    - Два активни слоя
    - Едностранно разположение на компонентите
    - Ширини на пистите - 0.5 мм (сигнални), 1 мм (захранващи)
      
- Управляващ софтуер
  - Взимане на входна информация от сензорите
  - Изпращане на информацията към мобилното устройство (Android телефон)
  
- Приложен софтуер
  - Android приложение, използващо Flutter framework-а за Android Studio
  - Приложението съдържа:
   - Екран за сканиране за различни BLE устройства
   - Режим "сурови данни"
   - Режим "Асистент"
   
- Документация
  - Съдържание:
    - Увод
    - Първа глава - Проучване на съществуващи проекти
    - Втора глава - Основни изисквания и блокови схеми
    - Трета глава - Проектиране на принципна електрическа
    - Четвърта глава - Проектиране на печатна платка
    - Пета глава -  Управляващ и приложен софтуер
    - Шеста глава - Практически резултати
    - Заключение

Файловете на печатната платка, електрическата схема, документацията и софтуера могат да бъдат намерени по-горе в repository-то.
