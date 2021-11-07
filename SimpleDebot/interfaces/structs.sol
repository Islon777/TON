pragma ton-solidity >= 0.35.0;
struct Purchase {       // Описание покупки
        
        uint32 id;      // Идентификатор/номер
        string name;    // Название предмета
        uint32 count;   // Требуемое количество
        uint64 timstamp;// Время внесения покупки в список
        bool isBought;  // Флаг: куплена или нет
        uint32 sum;     // Общая стоимость
    }

struct PurchaseSummary { // Статистика по покупкам

        uint32 paid;         // Оплачено предметов (покупок)         
        uint32 unpaid;       // Не оплачено предметов (покупок)
        uint64 totalSum;     // Общая стоимость всех оплаченных покупок
}