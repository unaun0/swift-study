# Cocoa Application Layer

Уровень приложений Cocoa в первую очередь отвечает за внешний вид приложений и их реакцию на действия пользователя. Кроме того, многие функции, определяющие пользовательский интерфейс OS X, такие как Центр уведомлений, полноэкранный режим и автоматическое сохранение, реализованы на уровне Cocoa.

![](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/OSX_Technology_Overview/art/osx_architecture-cocoa_2x.png)

## Центр уведомлений

Центр уведомлений позволяет пользователям получать и просматривать уведомления приложений удобным и ненавязчивым способом. Для каждого приложения пользователи могут указать, как они хотят получать уведомления о доставке. Они также могут открыть Центр уведомлений, чтобы просмотреть все доставленные товары.

API-интерфейсы Центра уведомлений, которые помогают настраивать видимые пользователю части элемента уведомления, планировать доставку элементов и узнавать, когда они были доставлены. Вы также можете определить, запустилось ли ваше приложение в результате получения уведомления, и если да, то является ли это уведомление локальным или удалённым (то есть push-уведомлением).

## Game Center - Игровой центр

Игровой центр имеет доступ к той же социальной игровой сети, что и на iOS, и позволяет пользователям отслеживать результаты в таблице лидеров, сравнивать свои игровые достижения, приглашать друзей в игру и запускать многопользовательскую игру с помощью автоматического подбора игроков. Игровой центр состоит из трёх частей:

* Приложение Game Center, в котором пользователи входят в свою учётную запись, находят новые игры и новых друзей, добавляют друзей в свою игровую сеть, а также просматривают списки лидеров и достижения.
* Платформа Game Kit, которая содержит API-интерфейсы, используемые разработчиками для поддержки многопользовательских или пошаговых игр в реальном времени, а также для внедрения других функций Game Center, таких как внутриигровой голосовой чат и доступ к таблице лидеров.
* Онлайн-сервис Game Center, поддерживаемый Apple, который выполняет аутентификацию игроков, предоставляет информацию о рейтингах и достижениях, а также обрабатывает приглашения и автоматически подбирает игроков для многопользовательских игр. Вы взаимодействуете со службой Game Center только косвенно, используя API Game Kit.

В своей игре используйте Game Kit API для публикации результатов и достижений в сервисе Game Center, а также для отображения рейтингов в пользовательском интерфейсе. Вы также можете использовать Game Kit API, чтобы помочь пользователям найти других игроков для совместной игры.

## Sharing - Совместное использование

Сервис обмена обеспечивает единообразный пользовательский интерфейс для обмена контентом между различными типами сервисов. Например, пользователь может захотеть поделиться фотографией, опубликовав её в сообщении в Twitter, прикрепив к электронному письму или отправив другому пользователю Mac с помощью AirDrop.

Используйте класс AppKit NSSharingService для получения информации о доступных сервисах и прямого обмена данными с ними. В результате вы можете отобразить пользовательский интерфейс для представления сервисов. Вы также можете использовать класс NSSharingServicePicker для отображения списка сервисов обмена данными (включая пользовательские сервисы, которые вы определяете), из которых пользователь может выбирать. При использовании сервиса отображается окно обмена данными, предоставляемое системой, где пользователь может оставить комментарий или добавить получателей.

## Resume - Возобновление

Resume — это общесистемное улучшение пользовательского интерфейса, поддерживающее сохранение состояния приложений. Пользователь может выйти из системы или завершить работу операционной системы, а при следующем входе в систему или запуске OS X автоматически перезапускает приложения, которые работали в последний раз, и восстанавливает окна, которые были открыты в последний раз. Если ваше приложение предоставляет необходимую поддержку, вновь открытые окна имеют тот же размер и расположение, что и раньше; кроме того, содержимое окна прокручивается до предыдущей позиции, а выделенные элементы восстанавливаются.

Чтобы обеспечить сохранение приложения, вы также должны реализовать автоматическое и внезапное завершение работы приложения, сохранение пользовательского интерфейса и автоматическое сохранение. 

## Полноэкранный режим

Когда приложение переходит в полноэкранный режим, оно открывает главное окно приложения или документа в отдельном пространстве. При включении полноэкранного режима в меню «Вид» или, если меню «Вид» отсутствует, в меню «Окно» добавляется пункт «Перейти в полноэкранный режим». Когда пользователь выбирает этот пункт меню, главное окно приложения или документа занимает весь экран.

Фреймворк AppKit обеспечивает поддержку настройки внешнего вида и поведения полноэкранных окон. Например, вы можете установить маску стиля окна и реализовать пользовательские анимации при входе и выходе приложения из полноэкранного режима.

Вы включаете и управляете поддержкой полноэкранного режима с помощью методов NSApplication и NSWindow классов и NSWindowDelegate Protocol протокола.

## Cocoa Auto Layout

Это система, основанная на правилах, предназначенная для реализации рекомендаций по макету, описанных в Руководстве по пользовательскому интерфейсу OS X. Она выражает более широкий класс взаимосвязей и более интуитивно понятна в использовании, чем пружины и стойки.

Использование автоматической компоновки приносит вам ряд преимуществ:

* Локализация осуществляется только за счет замены строк, вместо того чтобы также изменять макеты
* Зеркальное отображение элементов пользовательского интерфейса для языков, в которых текст читается справа налево, таких как иврит и арабский
* Улучшенное распределение ответственности между объектами на уровнях представления и контроллера.
Объект представления обычно лучше всего знает о своём стандартном размере и расположении внутри родительского представления и относительно других представлений. Контроллер может переопределить эти значения, если требуется что-то нестандартное.

Сущности, которые вы используете для определения макета, — это объекты Objective-C, называемые ограничениями. Вы определяете ограничения, комбинируя атрибуты, такие как передний, задний, левый, правый, верхний, нижний, ширина и высота, которые определяют взаимосвязь между элементами пользовательского интерфейса. (Передний и задний атрибуты аналогичны левому и правому, но они более выразительны, поскольку автоматически отражают ограничение в среде с письмом справа налево.) Кроме того, вы можете назначить ограничениям уровни приоритета, чтобы определить наиболее важные для выполнения ограничения.

Вы можете использовать Interface Builder для добавления и редактирования ограничений для вашего интерфейса. Если вам нужен больший контроль, вы можете работать с ограничениями программно.

## Всплывающие окна

Это представление, отображающее дополнительный контент, связанный с существующим контентом на экране. AppKit предоставляет NSPopoverкласс для поддержки всплывающих окон. AppKit автоматически позиционирует всплывающее окно относительно представления, содержащего существующий контент, — так называемого представления позиционирования— и перемещает всплывающее окно, когда перемещается представление позиционирования.

Вы настраиваете внешний вид и поведение всплывающего окна, в том числе определяете, какие действия пользователя приводят к закрытию всплывающего окна. А реализовав соответствующий метод делегата, вы можете настроить всплывающее окно так, чтобы оно отделялось и становилось отдельным окном, когда пользователь перетаскивает его.

## Конфигурация программного обеспечения

Программы OS X обычно используют файлы списков свойств (также известные как файлы plist) для хранения данных конфигурации. Список свойств — это текстовый или двоичный файл, используемый для управления словарем пар «ключ-значение». Приложения используют особый тип файла списка свойств, называемый информационным списком свойств (Info.plist) файлом, для передачи ключевых атрибутов приложения — таких как название приложения, уникальная идентификационная строка и информация о версии — в систему. Приложения также используют файлы списков свойств для хранения пользовательских настроек или других пользовательских конфигурационных данных.

Преимущество файлов списков свойств заключается в том, что их легко редактировать и изменять вне среды выполнения вашего приложения. Xcode включает встроенный редактор списков свойств для редактирования Info.plist файла вашего приложения. Чтобы узнать больше о файлах списков свойств и ключах, которые вы в них вводите, см. Руководство по настройке среды выполнения и Справочник по ключам списков свойств. Чтобы узнать, как редактировать файл списка свойств в Xcode, см. Редактирование ключей и значений.

В вашем приложении вы можете программно считывать и записывать файлы списков свойств, используя возможности как Core Foundation, так и Cocoa. 

## Специальные возможности

Доступность — это успешный доступ к информации и информационным технологиям для миллионов людей с ограниченными возможностями или особыми потребностями. OS X предоставляет множество встроенных функций и вспомогательных технологий, которые помогают пользователям с особыми потребностями пользоваться Mac. OS X также предоставляет разработчикам программного обеспечения функции, необходимые для создания приложений, доступных для всех пользователей.

Приложения, использующие интерфейсы Cocoa, автоматически получают значительную поддержку специальных возможностей. Например, приложения получают следующую бесплатную поддержку:

* Функции масштабирования позволяют пользователям увеличивать размер экранных элементов.
* Залипающие клавиши позволяют пользователям нажимать клавиши последовательно, а не одновременно для использования сочетаний клавиш.
* Клавиши мыши позволяют пользователям управлять мышью с помощью цифровой клавиатуры.
* Режим полного доступа к клавиатуре позволяет пользователям выполнять любые действия с помощью клавиатуры, а не мыши.
* Распознавание речи позволяет пользователям произносить команды, а не вводить их.
* Функция преобразования текста в речь позволяет считывать текст пользователям с ограниченными возможностями по зрению.
* VoiceOver предоставляет функции разговорного пользовательского интерфейса для помощи пользователям с ослабленным зрением.

Несмотря на то, что Cocoa интегрирует поддержку специальных возможностей в свои API, вам всё равно может понадобиться предоставить более подробную информацию о ваших окнах и элементах управления. Раздел «Специальные возможности» в инспекторе Xcode Identity позволяет легко предоставить пользовательскую информацию о специальных возможностях элементов пользовательского интерфейса в вашем приложении. Или вы можете использовать соответствующие интерфейсы специальных возможностей для изменения настроек программно.

## AppleScript

OS X использует AppleScript в качестве основного языка для создания сценариев для приложений. С помощью AppleScript пользователи могут писать сценарии, объединяющие функции нескольких приложений, для которых можно создавать сценарии.

При разработке новых приложений следует учитывать поддержку AppleScript на ранних этапах. Ключом к хорошему дизайну, поддерживающему AppleScript, является выбор подходящей модели данных для вашего приложения. Дизайн должен не только соответствовать целям вашего приложения, но и упрощать работу с вашим контентом для разработчиков AppleScript. После выбора модели данных вы можете реализовать код событий Apple, необходимый для поддержки сценариев.

## Spotlight

Spotlight предоставляет расширенные возможности поиска для приложений. Сервер Spotlight собирает метаданные из документов и других важных пользовательских файлов и включает эти метаданные в индекс для поиска. Finder использует эти метаданные, чтобы предоставлять пользователям более актуальную информацию об их файлах. Например, помимо указания названия файла JPEG, Finder может также указать его ширину и высоту в пикселях.

Разработчики приложений используют Spotlight двумя разными способами. Во-первых, вы можете искать атрибуты и содержимое файлов с помощью API поиска Spotlight. Во-вторых, если ваше приложение определяет собственные форматы файлов, вы должны включать в эти форматы любую соответствующую информацию о метаданных и предоставлять плагин для импорта Spotlight, чтобы возвращать эти метаданные в Spotlight.

## Ink Services

Обеспечивает распознавание рукописного текста для приложений, поддерживающих текстовые системы Cocoa и WebKit, а также любую текстовую систему, поддерживающую методы ввода. Автоматическая поддержка доступна для текста и рукописных жестов (которые определяются на панели Ink). Платформа Ink предлагает несколько функций, которые вы можете использовать в своих приложениях, в том числе следующие:

* Программное включение или отключение распознавания рукописного ввода
* Прямой доступ к чернильным данным
* Поддержка либо отложенного признания, либо признания по требованию
* Поддержка прямого манипулирования текстом с помощью жестов

Функция Ink Services реализована с помощью фреймворка Ink (Ink.framework). Фреймворк Ink предназначен не только для разработчиков приложений для конечных пользователей. Разработчики аппаратного обеспечения также могут использовать его для реализации решения по распознаванию рукописного текста для нового устройства ввода. Вы также можете использовать фреймворк Ink для реализации собственной модели коррекции, чтобы предоставить пользователям список альтернативных интерпретаций рукописных данных.

Ink Framework является подсистемой Carbon.framework; вы должны ссылаться на него напрямую с помощью основного фреймворка, а не с помощью Ink.framework.

## Фреймворки

### Cocoa Umbrella Framework

Импортирует основные фреймворки Objective-C для разработки приложений: AppKit, Foundation и Core Data.

#### AppKit

Eдинственный фреймворк из трёх, который на самом деле находится на уровне Cocoa.

#### Foundation

Классы фреймворка Foundation (который находится на уровне Core Services) реализуют управление данными, доступ к файлам, уведомления о процессах, сетевое взаимодействие и другие низкоуровневые функции. AppKit напрямую зависит от Foundation, поскольку многие его методы и функции либо принимают экземпляры классов Foundation в качестве параметров, либо возвращают экземпляры в качестве значений.

#### Core Data

Классы фреймворка Core Data (который также находится на уровне Core Services) управляют моделью данных приложения на основе шаблона проектирования «Модель-представление-контроллер». Хотя Core Data не является обязательным для разработки приложений, он рекомендуется для приложений, работающих с большими наборами данных.
 
### AppKit

AppKit — это ключевая платформа для приложений Cocoa. Классы в платформе AppKit реализуют пользовательский интерфейс (UI) приложения, включая окна, диалоговые окна, элементы управления, меню и обработку событий. Они также обеспечивают большую часть поведения, необходимого для корректной работы приложения, включая управление меню, управление окнами, управление документами, диалоговые окна «Открыть» и «Сохранить», а также поведение буфера обмена (Clipboard).

Помимо классов для окон, меню, обработки событий и широкого спектра представлений и элементов управления, в AppKit есть классы для управления окнами и данными, а также классы для шрифтов, цветов, изображений и графических операций. Большое подмножество классов составляет текстовую систему Cocoa, описанную в разделе «Текст, типографика и шрифты». Другие классы AppKit поддерживают управление документами, печать и такие сервисы, как проверка орфографии, справка, речь, а также операции с буфером обмена и перетаскивание.

Приложения могут использовать многие функции, которые делают работу с OS X такой интуитивно понятной, продуктивной и приятной. К таким функциям относятся следующие:

* __Жесты__. Пользователи ценят возможность использовать плавные и интуитивно понятные мультисенсорные жесты для взаимодействия с OS X. Классы AppKit позволяют легко внедрить эти жесты в ваше приложение и обеспечить более удобный зум без перерисовки содержимого. Например, NSScrollView включает встроенную поддержку интеллектуального жеста масштабирования (то есть двойного касания двумя пальцами на трекпаде). Если вы предоставите семантическую разметку содержимого, NSScrollView может интеллектуально увеличивать содержимое под указателем. Вы также можете использовать этот класс для реагирования на жест поиска (то есть на нажатие тремя пальцами на трекпад). Чтобы узнать больше о поддержке жестов, которую NSScrollView предоставляет, см. Справочник по классу NSScrollView.
* __Пространства__. Пространства позволяют пользователю объединять окна в группы и переключаться между группами, чтобы не загромождать рабочий стол. AppKit поддерживает совместное использование окон в разных пространствах с помощью атрибутов поведения коллекции в окне. Информацию о настройке этих атрибутов см. в Справочнике по классу NSWindow.
* __Быстрое переключение между пользователями__. С помощью этой функции несколько пользователей могут совместно использовать доступ к одному компьютеру без выхода из системы. Сессия одного пользователя может продолжать работать, пока другой пользователь входит в систему и получает доступ к компьютеру. Чтобы поддерживать быстрое переключение между пользователями, убедитесь, что ваше приложение не делает ничего, что может повлиять на другую версию приложения, работающую в другом сеансе. Чтобы узнать, как реализовать такое поведение, см. разделы о программировании в многопользовательской среде.

Xcode включает в себя Interface Builder — редактор пользовательского интерфейса, содержащий библиотеку объектов AppKit, таких как элементы управления, представления и объекты-контроллеры. С его помощью вы можете создавать большую часть пользовательского интерфейса (включая большую часть его поведения) графически, а не программно. С добавлением привязок Cocoa и Core Data вы также можете реализовать большую часть остальной части приложения графически.

### Game Kit

Платформа Game Kit (GameKit.framework) предоставляет API, которые позволяют вашему приложению участвовать в Game Center. Например, вы можете использовать классы Game Kit для отображения таблиц лидеров в вашей игре и предоставления пользователям возможности делиться своими внутриигровыми достижениями и играть в многопользовательские игры.

### Preference Panes

Платформа Preference Panes (PreferencePanes.framework) позволяет создавать плагины, содержащие пользовательский интерфейс для настройки параметров приложения. Во время выполнения приложение «Системные настройки» (или ваше приложение) может динамически загружать плагин и отображать пользовательский интерфейс настроек для пользователей. В «Системных настройках» каждый значок в разделе «Показать все» представляет собой отдельный плагин панели настроек. Обычно плагины панелей настроек используются, когда в приложении нет собственного пользовательского интерфейса или он очень ограничен, но нуждается в настройке. В таких случаях вы создаёте как плагин, так и код для конкретного приложения, который считывает и записывает настройки.

### Screen Saver

Фреймворк Screen Saver (ScreenSaver.framework) содержит классы для создания динамически загружаемых пакетов, реализующих экранные заставки. Пользователи могут выбрать экранную заставку на панели «Рабочий стол и экранная заставка» в приложении «Системные настройки». Screen Saver помогает реализовать экранную заставку, а также просматривать и управлять настройками экранной заставки.

### Security Interface

Фреймворк Security Interface (SecurityInterface.framework) содержит классы, предоставляющие элементы пользовательского интерфейса для программ, реализующих функции безопасности, такие как авторизация, доступ к цифровым сертификатам и доступ к элементам в связках ключей. Существуют классы для создания пользовательских представлений и стандартных элементов управления безопасностью, для создания панелей и листов для представления и редактирования сертификатов, для редактирования настроек связки ключей, а также для представления и выбора идентификаторов.
