#!/bin/sh

# add opendns DNS (else the ppa's sometimes can't be resolved)
sudo apt -y remove needrestart
sudo apt update -y
sudo apt install resolvconf -y
echo "nameserver 208.67.222.222" | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo add-apt-repository ppa:deadsnakes/ppa -y

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

sudo apt install acl unattended-upgrades snapd zsh git-core keychain mosh gcc gparted ubuntu-drivers-common python3.9 python3.9-dev python3.9-distutils python3-distutils ncdu x11-apps xclip xsel build-essential devscripts debhelper fakeroot locate ffmpeg libsm6 libxext6 parallel curl gnupg lsb-release ca-certificates alsa-base alsa-utils awscli tmux gcc-10 g++-10 -y
sudo updatedb
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.9 get-pip.py
sudo snap install micro --classic
sudo snap install viu-image-viewer --candidate
sudo snap alias viu-image-viewer.viu viu

sudo ubuntu-drivers autoinstall

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
sudo apt install cuda-11-3 libcudnn8 libnccl2 -y

printf "APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Download-Upgradeable-Packages "1";\nAPT::Periodic::AutocleanInterval "7";\nAPT::Periodic::Unattended-Upgrade "7";\n" | sudo tee /etc/apt/apt.conf.d/20auto-upgrades

sudo update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.9 1
sudo chown -R $USER /usr/local/
sudo chown -R $USER /usr/lib/python3/

export PATH=~/.local/bin:/usr/local/cuda/bin:$PATH
python3 -m pip install joblib boost statsmodels wget pyhive psutil isort plotly natsort pandas matplotlib scikit-learn jupyter notebook jupyter_contrib_nbextensions imtools wandb cachetools tensorboard tensorboardX opencv-python pyarrow fastai mypy flake8 pydocstyle pycodestyle autopep8 autoflake black yapf docker-compose Click
python3 -m pip install torch===1.10.0+cu113 torchvision===0.11.1+cu113 torchaudio===0.10.0+cu113 -f https://download.pytorch.org/whl/torch_stable.html

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && sudo ~/vsls-reqs

wget -O azcopy.tar https://aka.ms/downloadazcopy-v10-linux && tar -xvf azcopy.tar && sudo cp -f ./azcopy_linux_amd64_*/azcopy /usr/bin/ && sudo chmod +777 /usr/bin/azcopy

wget -O s5cmd_1.4.0_Linux-64bit.tar.gz https://github.com/peak/s5cmd/releases/download/v1.4.0/s5cmd_1.4.0_Linux-64bit.tar.gz && tar -xvf s5cmd_1.4.0_Linux-64bit.tar.gz && sudo cp -f s5cmd /usr/bin/

sudo mkdir /data && sudo chmod +777 /data && sudo setfacl -Rm d:u::rwx,d:g::rwx,d:o::rwx /data

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

LINE='export PATH=~/.local/bin:/snap/bin:/usr/local/cuda/bin:$PATH'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

LINE='export OMP_NUM_THREADS=24'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

LINE='if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then tmux attach-session -t s || tmux new-session -s s; fi'
grep -xqF -- "$LINE" ~/.bashrc || echo "$LINE" >> ~/.bashrc
grep -xqF -- "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc

LINE='DISABLE_UPDATE_PROMPT="true"'
grep -xqF -- "$LINE" ~/.zshrc || sed  -i "1i $LINE" ~/.zshrc

LINE='plugins=(git zsh-autosuggestions)'
grep -xqF -- "$LINE" ~/.zshrc || sed  -i "1i $LINE" ~/.zshrc

sed -i 's/ZSH_THEME=.*/ZSH_THEME="gallois"/' ~/.zshrc

cp .tmux.conf ~/
cp .ssh/* ~/.ssh/
mkdir ~/.tmux/tmux-resurrect/

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo groupadd docker
sudo gpasswd -a $USER docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list \
   && sudo apt-get update && sudo apt-get install -y nvidia-docker2 && sudo systemctl restart docker

sudo ln -s /usr/bin/gcc-10 /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/g++-10 /usr/local/cuda/bin/g++

# tmux

tmux
~/.tmux/plugins/tpm/scripts/install_plugins.sh
~/.tmux/plugins/tpm/bin/install_plugins
