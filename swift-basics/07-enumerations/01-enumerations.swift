/*
Перечисления
*/

// Перечисления в Swift - типы “первого класса”.
// Они обладают особенностями, которые обычно поддерживаются классами, например, 
// вычисляемые свойства, для предоставления дополнительной информации о текущем значении перечисления,
// методы экземпляра для дополнительной функциональности, относящейся к значениям, которые предоставляет перечисление.

// Перечисления так же могут объявлять инициализаторы для предоставления начального значения элементам. 
// Они так же могут быть расширены для наращивания своей функциональности над её начальной реализацией. 
// Могут соответствовать протоколам для обеспечения стандартной функциональности.

// Синтаксис перечислений

enum SomeEnumeration {
    //здесь будет объявление перечисления
}

// Пример с четырьмя сторонами света

enum CompassPoint {
    case north
    case south
    case east
    case west
}

// Значения, объявленные в перечислении (north, south, east, и west), называются кейсами перечисления.
// Кейсам перечисления не присваиваются целочисленные значения по умолчанию при их создании.

// Множественные значения члена перечисления могут записываться в одну строку, разделяясь между собой запятой
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// Каждое объявление перечисления объявляет и новый тип. 
// Как и остальные типы в Swift, их имена (к примеру CompassPoint и Planet) должны начинаться с заглавной буквы.

var directionToHead = CompassPoint.west

directionToHead = .east

// Тип directionToHead уже известен, так что вы можете не указывать тип, присваивая значения. 
// Так делается для хорошо читаемого кода, когда работаете с явно указанными типами значений перечисления.

/*
Использование перечислений с инструкцией switch
*/

switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
}

// оператор switch должен быть исчерпывающим, когда рассматриваются члены перечисления. 
// Если мы пропустим case .west, то код не скомпилируется, так как не рассматривается полный перечень членов CompassPoint. 
