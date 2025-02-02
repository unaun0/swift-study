# Согласованность

Swift имеет встроенную поддержку для структурированного написания асинхронного и параллельного кода. 

В Swift есть два ключевых понятия:

* __Асинхронность (`async`/`await`)__ – позволяет выполнять задачи без блокировки основного потока.

* __Параллельность (`async let`)__ – позволяет запускать несколько задач одновременно, если ресурсы позволяют.

## 1️⃣ Асинхронность в Swift

Асинхронность означает, что код может приостанавливаться и возобновляться без блокировки основного потока.

### 🔹 Как это работает?

Когда Swift встречает `await`, он приостанавливает выполнение функции и даёт другим задачам выполняться.
Когда операция завершается, Swift возобновляет выполнение с того места, где она была приостановлена.

```
func fetchData() async -> String {
    print("⏳ Загружаем данные...")
    await sleep(2) // Симуляция ожидания 2 секунды
    return "📦 Данные загружены!"
}

func process() async {
    let result = await fetchData()
    print(result)
}
```

1. `fetchData()` вызывается внутри `process()`.
2. Когда код доходит до `await sleep(2)`, функция приостанавливается, но поток освобождается для других задач.
3. Через 2 секунды задача возобновляется, и результат возвращается.

⏳ __Главное: `async` не создаёт новый поток, а просто позволяет программе не зависать в ожидании.__

## 2️⃣ Параллельность с async let

__Асинхронность ≠ параллельность.__

__Асинхронность__ — это способ ожидания, а __параллельность__ — это выполнение нескольких задач одновременно.

```
func loadImage() async -> String {
    await sleep(2) // Симуляция загрузки 2 секунды
    return "🖼 Картинка загружена!"
}

func loadData() async -> String {
    await sleep(3) // Симуляция загрузки 3 секунды
    return "📄 Данные загружены!"
}

func process() async {
    async let image = loadImage()
    async let data = loadData()
    
    let result1 = await image
    let result2 = await data

    print(result1)
    print(result2)
}
```

1. `async let image = loadImage()` запускает `loadImage()`, но не ждёт её завершения.
2. `async let data = loadData()` тоже запускает `loadData()`.
3. Код выполняется дальше, пока не дойдёт до `await image` и `await data`.
4. Когда обе задачи завершены, их результаты сохраняются.

⏳ __Обе задачи выполняются параллельно.__

## 3️⃣ Что под капотом?

* `async` и `await` работают через планировщик задач (`Task Executor`).

* `async let` создаёт независимые задачи, которые выполняются на разных потоках, если возможно.

* Swift использует пул потоков (`Thread Pool`), а не создаёт новый поток для каждой задачи.

### 📌 Итог

__Асинхронность (`async`/`await`)__ – задачи ждут завершения, но не блокируют поток.

__Параллельность (`async let`)__ – задачи выполняются одновременно на разных потоках.

## 🚀 Асинхронные последовательности в Swift (AsyncSequence)

Иногда нам не нужно сразу получать весь массив данных, а хочется обрабатывать элементы по одному по мере их поступления.

Для этого в Swift есть асинхронные последовательности (`AsyncSequence`), которые позволяют получать элементы постепенно.

### 🔹 Как работает for await?

В обычном `for-in` цикле мы сразу получаем весь массив:

```
let numbers = [1, 2, 3, 4, 5]

for number in numbers {
    print(number)
}
```

Но если данные приходят не сразу (например, из интернета или файла), такой подход неподходящий.

Вместо этого мы можем использовать `for await`, который ждёт каждый элемент по мере поступления.

```
import Foundation

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line) // Выводит строку, когда она поступает
}
```

1. `handle.bytes.lines` — это асинхронная последовательность строк.

2. `for try await line in handle.bytes.lines` читает по одной строке за раз.

3. Код ждёт (`await`), когда появится следующая строка.

### Как сделать свою AsyncSequence?

Допустим, у нас есть поток фотографий из галереи.
Мы хотим получать их по одной и обрабатывать по мере загрузки.

```
struct PhotoStream: AsyncSequence {
    typealias Element = String // Каждая "фотография" — это строка

    struct AsyncIterator: AsyncIteratorProtocol {
        var index = 0
        let photos = ["📷 Photo 1", "📷 Photo 2", "📷 Photo 3"]

        mutating func next() async -> String? {
            guard index < photos.count else { return nil }
            await sleep(1) // Симуляция задержки загрузки
            defer { index += 1 }
            return photos[index]
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator()
    }
}

// Используем нашу асинхронную последовательность
func fetchPhotos() async {
    let stream = PhotoStream()

    for await photo in stream {
        print("Загружена: \(photo)")
    }
}
await fetchPhotos()
```

#### 🔍 Как это работает?

`PhotoStream` — это `AsyncSequence`, которое выдаёт фото по одной.

`AsyncIterator` содержит индекс текущего фото и метод `next()`, который:
* ждёт (`await sleep(1)`)
* возвращает фото, если оно ещё есть
* увеличивает индекс

Цикл `for await photo in stream` получает фото по мере загрузки.

## 🔥 Задачи и группы задач в Swift

Swift позволяет выполнять разные части кода параллельно, используя задачи (`Task`) и группы задач (`TaskGroup`).

### 🚀 Что такое задача (`Task`)?

__Задача__ — это отдельный фрагмент работы, который выполняется асинхронно.

#### 🔹 Простой пример

```
Task {
    print("Начало задачи")
    try await Task.sleep(nanoseconds: 2_000_000_000) // Ждём 2 секунды
    print("Конец задачи")
}
print("Этот код выполняется сразу!")
```

#### 💡 Как это работает?

1. `Task {}` запускает асинхронную задачу.
2. `Task.sleep()` задерживает выполнение только внутри задачи.
3. Программа не ждёт завершения задачи и продолжает работать.

#### Вывод в консоли

```
Этот код выполняется сразу!
Начало задачи
Конец задачи
```

### 🎯 Группы задач (`TaskGroup`)

Иногда нужно запустить много задач, но неизвестно их точное количество.
Для этого удобно использовать группы задач (`TaskGroup`).

#### 🔹 Пример: загрузка списка фотографий

```
func loadPhoto(name: String) async -> String {
    try? await Task.sleep(nanoseconds: 1_000_000_000) // Ждём 1 сек
    return "📷 \(name) загружена"
}

let photoNames = ["photo1.jpg", "photo2.jpg", "photo3.jpg"]

await withTaskGroup(of: String.self) { taskGroup in
    for name in photoNames {
        taskGroup.async {
            await loadPhoto(name: name)
        }
    }
}
```

#### 📌 Что здесь происходит?

1. Создаётся группа задач `withTaskGroup(of: String.self)`.
2. Каждая задача внутри `taskGroup.async` выполняется параллельно.
3. Все задачи запускаются одновременно и программа ждёт их завершения.

### 🔥 Неструктурированные задачи (`async {}` и `asyncDetached {}`)

Обычно задачи связаны друг с другом (иерархия).
Но иногда нужна полная независимость — для этого есть `async {}` и `asyncDetached {}`.

🔹 Пример: `async {}` (задача привязана к текущему коду)

```
let task = async {
    return await loadPhoto(name: "photo.jpg")
}

let result = await task
print(result)
```
✅ `async {}` выполняется внутри текущего окружения.

🔹 Пример: `asyncDetached {}` (полностью отдельная задача)

```
let detachedTask = asyncDetached {
    return await loadPhoto(name: "photo.jpg")
}

let result = await detachedTask
print(result)
```

✅ `asyncDetached {}` работает полностью независимо.

❌ Но мы сами должны следить за его завершением и отменой.

### ⚡ Отмена задачи (`Task.cancel()`)

Иногда нужно остановить выполнение задачи.

Swift использует кооперативную модель отмены: задача сама проверяет, была ли она отменена.

#### 🔹 Пример отмены задачи

```
let task = Task {
    for i in 1...5 {
        if Task.isCancelled {
            print("Задача отменена ❌")
            return
        }
        print("Работаем... \(i)")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    print("Задача завершена ✅")
}

Task {
    try await Task.sleep(nanoseconds: 2_000_000_000)
    task.cancel()
}
```

#### 📌 Как это работает?

1. Задача `task` выполняет 5 шагов работы.
2. Вторая `Task` ждёт 2 секунды, а потом вызывает `task.cancel()`.
3. Задача проверяет `Task.isCancelled` и останавливает выполнение.

__Вывод__

```
Работаем... 1
Работаем... 2
Задача отменена ❌
```

| Механизм                | Что делает? | Когда использовать? | Запускает задачи параллельно? | Требует `await`? | Можно отменить? | Пример |
|-------------------------|------------|---------------------|-----------------------------|----------------|----------------|--------|
| **`async`/`await`** | Выполняет асинхронный код последовательно | Когда нужен **простой** асинхронный код | ❌ Нет | ✅ Да | ❌ Нет | ```let result = await fetchData()``` |
| **`async let`** | Запускает **независимые** задачи параллельно | Когда **несколько задач** можно выполнить одновременно | ✅ Да | ✅ Да (при получении результата) | ❌ Нет | ```async let a = load1(); async let b = load2(); let res1 = await a``` |
| **`Task {}`** | Запускает **новую** асинхронную задачу | Когда нужен **асинхронный код в синхронной среде** | ✅ Да | ✅ Да | ✅ Да (`task.cancel()`) | ```let task = Task { ... }``` |
| **`TaskGroup`** | Запускает **динамическое** количество задач | Когда **количество задач заранее неизвестно** | ✅ Да | ✅ Да | ✅ Да (все задачи в группе) | ```await withTaskGroup { group in group.async { ... } }``` |
| **`async {}`** | Создаёт **неструктурированную** задачу | Когда нужна **гибкость**, но с контролем выполнения | ✅ Да | ✅ Да | ✅ Да | ```let task = async { return await someTask() }``` |
| **`asyncDetached {}`** | Запускает **полностью независимую** задачу | Когда нужно, чтобы задача **не зависела от текущего контекста** | ✅ Да | ✅ Да | ✅ Да | ```let task = asyncDetached { return await work() }``` |

## Акторы

Акторы в Swift — это специальный тип объектов, которые обеспечивают безопасный доступ к своему состоянию в многозадачном коде. Они похожи на классы, но с одним важным отличием: акторы обеспечивают изоляцию данных. Это означает, что только одна задача (или поток выполнения) может одновременно работать с данными актора, предотвращая таким образом конкурентные условия (`race conditions`).

### Основные характеристики акторов

* __Ссылочный тип:__ как и классы, акторы являются ссылочными типами. Это значит, что когда вы передаете актор в другую часть программы, вы передаете ссылку на него, а не его копию.

* __Изоляция данных:__ данные внутри актора могут изменяться только одной задачей в определенный момент времени. Это предотвращает параллельные изменения данных, что делает работу с многозадачностью безопасной.

* __Необходимость использования `await` для доступа:__ так как доступ к данным актора может быть асинхронным (например, когда другая задача работает с этим актором), для взаимодействия с его состоянием нужно использовать ключевое слово `await`. Это указывает на возможную точку приостановки, пока другая задача не завершит свою работу с данным актором.

### Пример актора

```
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
    
    func update(with measurement: Int) {
        measurements.append(measurement)
        if measurement > max {
            max = measurement
        }
    }
}
```

Здесь мы создаем актор `TemperatureLogger`, который хранит температуру и может обновлять максимальную температуру. Этот актор использует `private(set)` для ограничения доступа к максимальной температуре, чтобы только методы внутри актора могли её изменять.

### Использование акторов 

Для того чтобы работать с актером, нам нужно использовать `await` при обращении к его свойствам или методам, так как доступ может быть асинхронным:

```
let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
print(await logger.max)  // 25
```

Доступ к свойствам актора, например `max`, происходит с использованием `await`, потому что актор может быть занят другой задачей в момент вашего обращения.

### Ошибка при доступе без `await`

Если вы попробуете обратиться к свойствам актора без `await`, это приведет к ошибке компиляции:

```
print(logger.max)  // Ошибка
```

Это происходит потому, что доступ к данным актора должен быть синхронизирован через асинхронный вызов (`await`). Это часть изоляции актора — Swift гарантирует, что доступ к его данным будет безопасным и последовательным.

#### Почему это важно?

Использование акторов помогает избежать распространенных ошибок многозадачности, таких как конкурентные условия. В многозадачных приложениях, где несколько потоков или задач могут работать с одними и теми же данными, акторы обеспечивают, чтобы только одна задача работала с данными в каждый момент времени, предотвращая неконсистентные состояния.

## Grand Central Dispatch (GCD)

__Grand Central Dispatch (GCD)__ — это низкоуровневая технология многозадачности в iOS и macOS, которая позволяет управлять асинхронным выполнением задач, распределением работы между потоками и синхронизацией. GCD позволяет эффективно использовать многозадачность и многоядерность, минимизируя сложность работы с потоками вручную.

### Основные концепции и компоненты GCD

#### Очереди (Queues)

__Очереди__ — это структуры данных, которые управляют выполнением задач в многозадачной среде. GCD использует очереди для распределения работы между потоками.

Очереди бывают двух типов:

* __Последовательные очереди (Serial Queues):__ выполняют задачи по одной за раз. Это гарантирует, что задачи будут выполнены в том порядке, в котором они были добавлены в очередь. Когда одна задача завершится, следующая начнется.

```
let serialQueue = DispatchQueue(label: "com.example.serialQueue")
serialQueue.async {
    print("Задача 1")
}
serialQueue.async {
    print("Задача 2")
}
```

В данном примере задачи будут выполнены последовательно: сначала "Задача 1", потом "Задача 2".

* __Параллельные очереди (Concurrent Queues):__ могут выполнять несколько задач одновременно. Очередь сама решает, когда и какие задачи выполнить в зависимости от доступных потоков.

```
let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
concurrentQueue.async {
    print("Задача 1")
}
concurrentQueue.async {
    print("Задача 2")
}
```

Здесь задачи могут быть выполнены параллельно.

#### Основные операции

`async`: позволяет запустить задачу асинхронно, не блокируя текущий поток выполнения. Задача будет выполнена в очереди, но выполнение основного потока (например, пользовательского интерфейса) не будет заблокировано.

```
DispatchQueue.global(qos: .background).async {
    // Фоновая задача
    print("Фоновая задача")
}
```

`sync`: блокирует текущий поток до тех пор, пока задача не завершится. Это используется, когда нужно дождаться выполнения задачи, прежде чем продолжить выполнение программы.

```
DispatchQueue.global(qos: .background).sync {
    print("Синхронная задача")
}
```

В этом случае текущий поток будет заблокирован до тех пор, пока задача не завершится.

`after`: операция, которая позволяет отложить выполнение задачи на определенное время.

```
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    print("Задача выполнена через 2 секунды")
}
```

В этом примере задача будет выполнена через 2 секунды после вызова.

#### Приоритет задач (QoS - Quality of Service)

Каждая задача в GCD может иметь приоритет, который определяет, как она будет распланирована в системе. GCD использует понятие качества обслуживания (QoS), чтобы управлять приоритетом задач. QoS делится на несколько уровней:

* `.userInteractive`: высокий приоритет, используется для задач, которые должны быть выполнены немедленно, например, обновление интерфейса пользователя.

* `.userInitiated`: задачи, которые требуются немедленно, но не так срочно, как `.userInteractive`.

* `.default`: cтандартный приоритет.

* `.utility`: задачи с низким приоритетом, такие как загрузка данных в фоновом режиме.

* `.background`: очень низкий приоритет для длительных задач.

```
DispatchQueue.global(qos: .userInitiated).async {
    // Задача с высоким приоритетом
    print("Важная задача")
}
```

#### Группы задач (Dispatch Groups)

Dispatch Group позволяет вам группировать несколько асинхронных задач и получить уведомление о завершении всех этих задач. Это полезно, когда вам нужно выполнить несколько параллельных задач и обработать результат только после того, как все они завершатся.

```
let group = DispatchGroup()

DispatchQueue.global().async(group: group) {
    // Первая асинхронная задача
    print("Задача 1")
}

DispatchQueue.global().async(group: group) {
    // Вторая асинхронная задача
    print("Задача 2")
}

group.notify(queue: .main) {
    print("Все задачи завершены")
}
```

В этом примере задачи 1 и 2 выполняются асинхронно. Как только обе задачи завершатся, выполнится блок в `notify`, который сообщает, что все задачи завершены.

#### Проблемы с блокировками и дедлоками

Хотя GCD очень мощный и гибкий инструмент, важно правильно управлять синхронизацией, чтобы избежать дедлоков и блокировок:

* Не используйте `sync` на главном потоке, так как это может заблокировать его и привести к зависаниям.

* Используйте очереди и группы задач правильно, чтобы задачи выполнялись параллельно, а не блокировали друг друга.

### Преимущества GCD

* __Эффективность:__ GCD автоматически управляет потоками и ядрами процессора, эффективно распределяя задачи.
* __Простота:__ GCD делает асинхронное программирование более простым и удобным, чем ручное управление потоками.
* __Безопасность:__ GCD гарантирует, что задачи будут выполнены безопасно и эффективно, избегая гонок и других проблем многозадачности.
