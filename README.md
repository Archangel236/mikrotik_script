# mikrotik_script
Название SIM в первом слоту
:global upname "Kyivstar";

Название SIM в втором слоту
:global downname "Life";

Определит название роутера установленного в system->identity
:global rname [/system identity get name];

Определяем какой слот в данный момент активен
:global currentslot [/system routerboard modem get sim-slot];

Время для инициализации SIM
:global inittimeout "60";

Время для регистрации сим карты в сети
:global connecttimeout "60";

Минимальный уровень сигнала

>= -70 dBm	Excellent	Strong signal with maximum data speeds

-70 dBm to -85 dBm	Good	Strong signal with good data speeds

-86 dBm to -100 dBm	Fair	Fair but useful, fast and reliable data speeds may be attained, but marginal data with drop-outs is possible

< -100 dBm	Poor	Performance will drop drastically

-110 dBm	No signal	Disconnection



:global minsignallevel "-110";

Переменная определит текущий уровень сигнала далее в скрипте
:global currentsignallevel;

Включить уведомления в telegram , необходима регистрация бота
:global notification "1";

Полученный token созданного бота
:global telegrambotid "botid";

Ваш telegramid что бы бот мог присылать вам уведомления (Узнать можно у данного бота @getmyid_bot)
:global telegramclientid "clientid";

Включить проверку интернета через ping
:global ping "1";

Хост 1 для проверки ping
:global pingip "1.1.1.1";

Хост 2 для проверки ping
:global pingipcontrol "8.8.8.8";

Количество пакетов отправленных на пинг
:global pingcount "5";

Количество %успешного пинга
:global pingminpackage "30";

Включить функцию смены SIM карты
:global changesim "1";

Включить вывод лога скрипта в лог mikrotik
:global logging "1";

Префикс для лога, что бы удобнее искать информацию
:global prefixlog ">>> ";
