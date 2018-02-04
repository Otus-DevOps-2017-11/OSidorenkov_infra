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

Homework 08
------
### 1. Самостоятельная работа
1. Добавлена переменная для определения приватного ключа:  
`private_key_path = "~/.ssh/appuser"`

2. Определение зоны по умолчанию в файле _variables.tf_:
```
variable "zone" {
  type        = "string"
  description = "Zone"
  default     = "europe-west1-b"
}
```

3. Команда `terraform fmt` приводит все конфиги terraform в красивый вид.

4. Создан _terraform.tfvars.example_.

### 2. Дополнительное задание №1. 
* Изменен пользователь на **appuser3**. Применил изменения. В итоге добавился новый пользователь на хост. Старый пользователь остался, но публичный ключ у него стерся, так что доступ по ssh к нему пропал.

* Добавлены пользователи в область metadata, каждый новый юзер добавляется через `\n`:
```
    sshKeys = "appuser:${file(var.public_key_path)}\nappuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}\nappuser3:${file(var.public_key_path)}"

```
Добавилсь новые пользователи, ко все есть доступ по ssh.

* После того как был добавлен новый пользовтель и ключ, а после применены изменения через `terraform apply`, внесенные руками данные из интерфейса были удалены.


Homework 09
------
В данном дз проведена работа над декомпозицией конфигурации terraform. Разбивка на модули, их подключение через основной файл.

Проверена работа фаервола, при указании своего IP адреса и наоборот.

Удалены неактуальные файлы из основной директории, так как они переехали модулями в директории на уровень ниже.

Отформатированы файлы конфигураций terraform.


Homework 10
------
Создан инвентори файл в виде json:
```json
{
  "app": {
    "hosts": {
      "appserver": {
        "ansible_host": "35.195.249.7"
      }
    } 
  },
  "db": {
    "hosts": {
      "dbserver": {
        "ansible_host": "35.205.72.189"
      }
    }
  }
}
```

Проверяем: 

`ansible all -i inventory.json -m command -a uptime`
```
appserver | SUCCESS | rc=0 >>
 19:03:35 up  9:06,  1 user,  load average: 0.00, 0.00, 0.00

dbserver | SUCCESS | rc=0 >>
 19:03:35 up  9:06,  1 user,  load average: 0.00, 0.00, 0.00
 ```


Homework 10
------
* Создание ansible playbooks

* Были созданы ansible playbooks для развертывания приложения и настройки базы данных

* Так же был переделан провижининг в packer со скриптов на ansible

#### Задание со звездочкой

*Найдено два варианта dynamic inventory для GCP:*

```
 - gce.py(описан в документации ansible http://docs.ansible.com/ansible/latest/guide_gce.html)
 - terraform-inventory (https://github.com/adammck/terraform-inventory)
```
terraform-inventory у меет работать не только с GCP.
Для установки можно воспользоваться уже скомпилированными файлами или скомпилировать самим.
Для использования terraform-inventory нужно указать переменную окружения TF_STATE, в которой нужно прописать путь до папки с terraform или путь до tfstate файла. 
terraform-inventory умеет работать с remote state.

```bash
ansible-playbook --inventory-file=/path/to/terraform-inventory site.yml
```

