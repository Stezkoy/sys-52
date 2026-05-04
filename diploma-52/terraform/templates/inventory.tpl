[webservers]
neto-web-a.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'
neto-web-b.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'

[zabbix]
neto-zabbix.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'

[elasticsearch]
neto-elasticsearch.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'

[kibana]
neto-kibana.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'

[zabbix_agents:children]
webservers
zabbix
elasticsearch
kibana
bastion

[bastion]
neto-bastion.ru-central1.internal ansible_user=stez ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p stez@${bastion_ip}"'

[all:vars]
ansible_ssh_private_key_file = ${ssh_private_key_path}
ansible_ssh_extra_args = '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'