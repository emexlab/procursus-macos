# removal of bootstrap
if [ -d /opt/procursus ]; then
    killall Sileo > /dev/null 2>&1
    export PATH=$PATH:/opt/procursus/bin
    sudo apt-get remove sileo -y
    sudo rm -rf /opt/procursus
    rm $HOME/.zshrc
    exit 0
fi

# creating tmp folder
if [ -d ~/protmp ]; then
    rm -rf ~/protmp 
fi
mkdir ~/protmp

# cloning and making zstd
git clone https://github.com/facebook/zstd.git
mv zstd ~/protmp/zstd
make -j4 -C ~/protmp/zstd

# downloading procursus
curl -O https://apt.procurs.us/bootstraps/big_sur/bootstrap-darwin-arm64.tar.zst
mv bootstrap-darwin-arm64.tar.zst ~/protmp/bootstrap.tar.zst

# uncompressing bootstrap into raw tar
~/protmp/zstd/zstd -d ~/protmp/bootstrap.tar.zst

# uncompress bootstrap initially
sudo tar -xpf ~/protmp/bootstrap.tar -C /

# exporting path
export PATH=$PATH:/opt/procursus/bin
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install sileo -y

# zshrc
echo "export PATH=$PATH:/opt/procursus/bin" > $HOME/.zshrc

# launching sileo
open /opt/procursus/Applications/Sileo.app
rm -rf ~/protmp
