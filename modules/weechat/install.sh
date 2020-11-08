set -e
apt install weechat-python python3-websocket

mkdir -p ~/.weechat/python/autoload
cd ~/.weechat/python
curl -O https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py
ln -s ../wee_slack.py autoload
