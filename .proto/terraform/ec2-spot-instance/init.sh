sudo apt update
sudo apt install docker maven default-jdk docker.io awscli mysql-client-core-8.0 python3 ipython3 python3-pip jupyter-core
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
sudo systemctl start docker
sudo usermod -aG docker $USER
#docker run -e MYSQL_DATABASE=dev_cadreon_amp -e MYSQL_USER=cad_amp_api -e MYSQL_PASSWORD=cad_amp_api -e MYSQL_ROOT_PASSWORD=cad_amp_api -p 3306:3306 -d mysql:5.7
#docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.10.1
