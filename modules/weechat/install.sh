set -e
apt install weechat-python python3-websocket

mkdir -p ~/.weechat/python/autoload
curl https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py -o $HOME/.weechat/python/autoload/wee_slack.py
curl https://raw.githubusercontent.com/wee-slack/wee-slack/master/weemoji.json -o $HOME/.weechat/weemoji.json
