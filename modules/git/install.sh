curl -L https://github.com/dandavison/delta/releases/download/0.4.4/git-delta_0.4.4_amd64.deb > delta.deb

sudo dpkg -i delta.deb
sudo mv delta.deb /usr/local/bin

curl -L https://github.com/hobochild/bump/releases/download/0.1.2/bump-linux-amd64 > bump
sudo chmod +x bump
sudo mv /usr/local/bin/
