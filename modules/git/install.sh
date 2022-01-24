curl -L https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb > delta.deb

sudo dpkg -i delta.deb
sudo mv delta.deb /usr/local/bin

curl -L https://github.com/hobochild/bump/releases/download/0.1.2/bump-linux-amd64 > bump
sudo chmod +x bump
sudo mv /usr/local/bin/

# Install github cli
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh
