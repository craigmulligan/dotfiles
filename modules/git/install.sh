curl -L https://github.com/dandavison/delta/releases/download/0.4.4/git-delta_0.4.4_amd64.deb > delta.deb

sudo dpkg -i delta.deb
sudo mv delta.deb /usr/local/bin
