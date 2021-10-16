/* Записи единиц ТОНА
require(1 nano == 1); require(1 nanoton == 1); require(1 nTon == 1);
require(1 ton == 1e9 nanoton); require(1 Ton == 1e9 nanoton);
require(1 micro == 1e-6 ton); require(1 microton == 1e-6 ton);
require(1 milli == 1e-3 ton); require(1 milliton == 1e-3 ton);
require(1 kiloton == 1e3 ton); require(1 kTon == 1e3 ton);
require(1 megaton == 1e6 ton); require(1 MTon == 1e6 ton);
require(1 gigaton == 1e9 ton); require(1 GTon == 1e9 ton);

TvmCell - специфический тип
    Операторы: ==, !=
    Методы:
        .depth() -  depth = 1 + максимальная глубина ячейки; иначе 0
        .dataSize(uint n) - Возвращает количество отдельных ячеек, 
                            биты данных в отдельных ячейках и ссылки 
                            на ячейки в отдельных ячейках. Если количество 
                            отдельных ячеек превышает n+1, то возникает исключение 
                            переполнения ячейки (8).
        .dataSizeQ(uint n)
        .toSlice()        - Преобразует ячейку в срез (slice)


vector (type) - хранит значения одного и того же типа
    1. Эффективнее массива динамического размера
    2. имеет срок службы выполнения смарт-контракта, поэтому он не может быть ни передан, 
       ни возвращен в качестве параметра вызова внешней функции, ни сохранен в переменной состояния.
    3. Имеет ограниченную длину 65025 values (основан на TVM Tuple)
    # vector(uint) vect;
    Методы:
        .push(obj) - добавить в конец вектора
        .pop() - возвращает последний элемент и удаляет его из вектора
        .length() - длина вектора
        .empty() - возвращает bool пустой или нет


// ============= Типы данных =========================== //
// Integer
uintN и intN - беззнаковые и знаковые целые числа 
где N - число от 8 до 256 с шагом 8, обозначают количество битов. 
uint и int по умолчанию аналогичны uint256 и int256 соответственно.

Оперторы как в JS: +, -, *, /, %, **
    bitSize(int x) - вычисляет наименьшее значение c ≥ 0, так что x вписывается 
                в c-разрядное целое число со знаком (−2^(c−1) ≤ x < 2^(c−1)).
    ubitSize(uint x)- u Bitesize вычисляет наименьшее значение c = 0 таким образом, 
                чтобы x вписывалось в c-разрядное целое число без знака (0 ≤ x < 2^c).



// Array
uint[] arr; - создание массива заданного типа данных
uint16[num_elements] arr; - указываем явно число эелементов в массиве
Методы:
    .empty() - bool пустой/не пустой
    .push(Type obj) - вставить в конец - постоянная цена газа
    .pop() - взять последний элемент и удалить - кол-во газа зависит от размера удаляемого элемента, 
            лучше юзать delete для больших элементов
    .length() - длина



// Bytes
byte oneByte = "a"; - 1 байт
несколько байт, аналогичен byte[], но по другому кодируется
bytes myBytes = "asdsad" - инифиализирован строкой
bytes myBytes2 = hex"01239abf" - инициализирован 16ричными данными

Методы:
    .empty() - bool
    .[uint from:uint to] - slice - байты в диапазоне [from,to)
    .length
    .toSlice - преобразует bytes в TvmSlice
    .dataSize(uint n)
    .append(bytes tail) - конкатенация
    

// String - может требовать  больше байт, чем bytes
string long = "0123456789";
string a = long.substr(1, 2); // a = "12"
string b = long.substr(6); // b = "6789"

Методы:
    .empty() - boolean isEmpty
    .byteLength() - байтовая длина
    .substr(uint from [, uint count]) - посдтрока в диапазоне [from,to), где to = from + count
    .append(string tail) - добавляет строку в конец
    .find(bytes1 symbol)/find(string substr) - Ищет символ (или подстроку) в строке и 
                                               возвращает индекс первого (find) или 
                                               последнего (findLast) вхождения. 
                                               Если такого символа в строке нет, возвращается 
                                               пустое необязательное значение.
 !!! Требует много Газа!!!
 stoi(string inputStr) - uint/bool - преобразует из str в int
                                     inpStr - десятичный формат
                                     inpStr = 0x... - переведет в 16 формат           


// Struct
struct structClassName {
    uint age;
    string name;
    string surname;
}
structClassName myStruct = structClassName(2, "Islon","Lambo")
uint age = myStruct.age;

function f() pure public {
    MyStruct s = MyStruct(1, -1, address(2));
    (uint a, int b, address c) = s.unpack();
}


// Mapping

mapping(KeyType => ValueType) - аналог словарей в Pythone
В качестве типа ключа могут использоваться адрес, байты, строка, bool, контракт, перечисление, 
фиксированные байты, целочисленные и структурные типы. Тип структуры может использоваться в качестве
типа ключа только в том случае, если он содержит только целочисленные, логические, фиксированные
 байты или типы перечисления и соответствует ~1023 битам. Пример сопоставления, которое имеет 
 структуру в качестве ключевого типа:

# struct Point {
    uint x;
    uint y;
    uint z;
}

mapping(Point => address) map;
Point p = Point(x, y, z);
map[p] = addr;

Объявление:
mapping(string => string) assocArr;
assocArr["IdNum 42"] = "Islon Lambo";



// Address
адрес представляет различные типы адресов TVM: addr_node, addr_extern, addr_std и addr_var. 

address(adr_val) - Создает адрес типа addr_std с нулевой цепочкой работы и заданным значением адреса.
или uint point
address addrStd = point.addressmakeAddrStd( workchainId,  address_value) - Создает адрес типа addr_std с 
                                                                                   заданным идентификатором рабочей цепочки
                                                                                    workchainId и значением address_value.
                        .addressmakeAddrExtern( addrNumber,  bitCnt)
                        .addressmakeAddrNone()
address.wid - Возвращает  workchainId of addr_std или addr_var. Создает исключение "ошибка проверки диапазона" 
                (код ошибки равен 5) для других типов адресов.
address.value - Возвращает значение адреса addr_std или addr_var, если addr_var имеет 256-разрядное значение адреса.
address(this).balance - возвращает баланс этого контракта
address(this).currencies - Возвращает валюты на балансе этого контракта.


// =============Специфические структуры управления=============== //

// Удобный аналог for (for -- of)
for ( range_declaration : range_expression ) {loop_statement}
# for (uint val : arr) { // iteration over array
    sum += val;
}

// Цикл repeat() - Цикл повторения вычисляет выражение только один раз. Это выражение должно иметь целочисленный тип без знака.
# require(a == 10, 101)
repeat (a) {
    a += 2;
}

// delete
при использовании delete элементы функция
присваивает начальные (нулевые значения). 
Для чисел = 0, либо статич массивов одинаковой длины 
с начальными значениями, либо дин. массив нелувой длины
Т.е. при удалении просто происходит пробел в массиве, длина массива не меняется
Если предполагается удаление, лучше юзать mapping  


*/