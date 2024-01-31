ssh arch@`terraform output -raw instance_ip_addr` 'bash -s' < init.sh
