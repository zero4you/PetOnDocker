# PetOnDocker
Необходимы установленные Terraform и Ansible.

Находясь в домашней директории своего пользователя, клонируем репозиторий.

Развёртывание серверов:
- Переходим в PetOnDocker/cloud-terraform
- Иициализруем провайдер terraform init
- Запускаем сервера terraform apply (предварительно посмотрев план terraform plan)

Развёртывание приложения и системы его автоматической сборки:
- Запускаем командой ansible all -m <название модуля>
