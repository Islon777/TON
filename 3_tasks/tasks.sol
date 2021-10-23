
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/*
    3.2. "Список задач"
        Структура (см лекцию по типам данных)
            - название дела
            - время добавления (см helloWorld)
            - флаг выполненности дела (bool)
        Структуру размещаем в сопоставление int8 => struct (см лекцию по типам данных)
        должны быть доступны опции:
            - добавить задачу (должен в сопоставление заполняться последовательный целочисленный ключ)
            - получить количество открытых задач (возвращает число)
            - получить список задач
            - получить описание задачи по ключу
            - удалить задачу по ключу
            - отметить задачу как выполненную по ключу  

*/



contract tasks {

    struct taskItem {
        string taskName;
        uint32 timeStamp;
        bool finishFlg;
    }

    mapping(int8 => taskItem) public taskList;

    int8 public taskCount = 0; // для подсчета добавленных задач
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);

        tvm.accept();

    }

    // Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    // Function adds task into taskList by input "taskName"
    function task_add(string taskName) public checkOwnerAndAccept {
        // Add in mapping (similar to dictionary Python)
        ++taskCount;
		taskList[taskCount] = taskItem(taskName, now, false);  // key - integer index in the order of addition
	}
    
    // Function returns the number of unfinished (current) tasks
    function task_current() public checkOwnerAndAccept returns (uint8) {
        uint8 tasksNum = 0;
        if (taskList.empty()) {
                tasksNum = 0;
        } else {
            for ((int8 key, taskItem value) : taskList) {
                if (value.finishFlg) {
                    tasksNum += 1;
                }  
            } 
        }
        return tasksNum;   
	}

    // Function returns all tasks
    function task_view() public checkOwnerAndAccept returns (string[]){
        string[] taskArray;
        if (taskList.empty()) {
            revert(106, "Tasks not founded"); // error if task List is empty
        } else {
            for ((int8 key, taskItem value) : taskList) {
                taskArray.push(value.taskName);
            }
        }
        return taskArray;
	}

    // Function retunrs task info by input "taskKey"
    function task_info(int8 taskKey) public checkOwnerAndAccept returns (taskItem){
        require(!taskList.empty(), 112, "taskList is empty");  // Chek for taskList isn't empty
        if (taskList.exists(taskKey)) {
            return taskList[taskKey];
        } else {
            revert(103, "Invalid taskKey - task isn't exist");
        }   
	}

    // Function delete task by input "taskKey"
    function task_delete(int8 taskKey) public checkOwnerAndAccept {
        require(!taskList.empty(), 112, "taskList is empty");  // Chek for taskList isn't empty     
        if (taskList.exists(taskKey)) {
            delete taskList[taskKey];
        } else {
            revert(103, "Invalid taskKey - task isn't exist");
        }
	}

    // Function finish task by input "taskKey"
    function task_finish(int8 taskKey) public checkOwnerAndAccept {
        require(!taskList.empty(), 112, "taskList is empty");  // Chek for taskList isn't empty       
        if (taskList.exists(taskKey)) {
            taskList[taskKey].finishFlg = true;
        } else {
            revert(103, "Invalid taskKey - task isn't exist");
        }
	}

}
