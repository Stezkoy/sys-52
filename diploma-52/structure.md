- **VPC `neto-vpc`** (10.10.0.0/16)  
  - **Публичная подсеть `neto-public-subnet`** (10.10.1.0/24, зона `ru-central1-a`)  
    - Bastion-хост (`neto-bastion`) – публичный IP, единственная точка входа по SSH.  
    - Сервер Zabbix (`neto-zabbix`) – публичный IP, веб-интерфейс :80.  
    - Kibana (`neto-kibana`) – публичный IP, порт :5601.  
    - Application Load Balancer (`neto-alb`) – публичный IP, слушает :80, проксирует на веб-серверы.  
  - **Приватная подсеть `neto-private-a`** (10.10.101.0/24, зона `ru-central1-a`)  
    - Веб-сервер 1 (`neto-web-a`).  
    - Elasticsearch (`neto-elasticsearch`).  
  - **Приватная подсеть `neto-private-b`** (10.10.102.0/24, зона `ru-central1-b`)  
    - Веб-сервер 2 (`neto-web-b`).  


├── terraform/  
│   ├── provider.tf  
│   ├── variables.tf  
│   ├── locals.tf
│   ├── network.tf            VPC, подсети, bastion, NAT  
│   ├── security.tf           все группы безопасности  
│   ├── compute.tf            все виртуальные машины  
│   ├── alb.tf                Application Load Balancer  
│   ├── backup.tf             расписание снапшотов  
│   ├── inventory.tf          генерация ansible inventory  
│   ├── outputs.tf  
│   ├── templates/  
│   │   └── inventory.tpl  
│   └── ansible/  
│       ├── inventory.ini     генерируется Terraform  
│       ├── templates/        шаблоны для Ansible  
│       └── playbooks/  
│           ├── webserver.yml  
│           ├── zabbix-server.yml  
│           ├── zabbix-agent.yml  
│           ├── elasticsearch.yml  
│           ├── kibana.yml  
│           └── filebeat.yml  
└── README.md  
  
terraform init  
terraform apply  
  
cd ansible  
ansible-playbook -i inventory.ini playbooks/webserver.yml  
ansible-playbook -i inventory.ini playbooks/zabbix-server.yml  
ansible-playbook -i inventory.ini playbooks/zabbix-agent.yml  
ansible-playbook -i inventory.ini playbooks/elasticsearch.yml  
ansible-playbook -i inventory.ini playbooks/kibana.yml  
ansible-playbook -i inventory.ini playbooks/filebeat.yml  