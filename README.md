# OSidorenkov_infra

## Настройка сквозного подключения к удаленному хосту через Bastion

* Открыть ~/.ssh/config
* Добавить содрежимое:
```
##########  OTUS  ##########
Host bastion
	HostName 35.205.94.11
	Port 22
	User appuser
	IdentityFile ~/.ssh/appuser

Host someinternalhost
	ProxyCommand ssh -q bastion nc -q0 10.132.0.3 22

##########  OTUS  ##########
```
* Подключение к удаленному хост, не имеющего внешний ip адрес(someinternalhost)
```
ssh appuser@someinternalhost
```

### Конфигурация подключения
Хост bastion, IP: 35.205.94.11, внутр. IP: 10.132.0.2
Хост: someinternalhost, внутр. IP: 10.132.0.3 


Homework 06
------
### 1. Самостоятельная работа
Созданы скрипты: 
  * install_ruby.sh 
  * install_mongodb.sh
  * deploy.sh

Скрипты сделаны исполняемыми. Работы скриптов проверена.

### 2. Дополнительное задание №1. 
Создан startup_script.sh. За основу взяты выше описанные скрипты.  
Для того чтобы запустить инстанс с этим скриптом, использовались несколько методов:  
  * Передать скрипт локально в команду создания инстанса:
  ```
  gcloud compute instances create reddit-app  \
  --boot-disk-size=10GB   \
  --image-family ubuntu-1604-lts  \ 
  --image-project=ubuntu-os-cloud   
  --machine-type=g1-small \   
  --tags puma-server   \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup_script.sh
  ```
  * Использовать скрипт через URL, например:  
  Создаем _bucket_:  
  `gsutil mb gs://ossidorenkov-infra/`  
  Загружаем скрипт:  
  `gsutil cp ./startup_script.sh gs://ossidorenkov-infra`  
  Проверяем:
  ```
  gsutil ls gs://ossidorenkov-infra
  gs://ossidorenkov-infra/startup_script.sh
  ```
  Команда создания инстанса с последющим использованием скрипта через URL:
  ```
  gcloud compute instances create reddit-app  \
  --boot-disk-size=10GB   \
  --image-family ubuntu-1604-lts  \ 
  --image-project=ubuntu-os-cloud   
  --machine-type=g1-small \   
  --tags puma-server   \
  --restart-on-failure \
  --metadata startup-script-url=gs://ossidorenkov-infra/startup_script.sh
  ```

### 3. Дополнительное задание №2. 
* Удаление правила fw через gcloud:  
`gcloud compute firewall-rules delete default-puma-server`
* Создание праивала fw через gcloud:
```
gcloud compute firewall-rules create default-puma-server \
--direction=INGRESS \
--description=default-puma-server \
--allow=TCP:9292  \
--network=default \
--target-tags puma-server \
--priority=1000

```


Homework 07
------
### 1. Самостоятельная работа
1. Создан файл с переменными variables.json, добавлен в `.gitignore`. Для примера представлен файл variables.example.json.  
2. Исследованы опции builder, добавлены переменные в variables.json(а также в variables.example.json).  

### 2. Дополнительное задание №1. 
Создан шаблон для образа reddit-full. За основу взят шаблон ubuntu16.json. Добавлено:  
  * Деплой приложения
  * Копирование заранее созданного systemd скрипта в образ. Добавление сервиса в автозагрузку.

### 3. Дополнительное задание №2. 
Создан скрипт _create-reddit-vm.sh_:
```
gcloud compute instances create reddit-app  \
--boot-disk-size=10GB   \
--image-family reddit-full  \
--image-project=infra-190310  \
--machine-type=f1-micro \
--tags puma-server   \
--restart-on-failure
```

