#! /bin/bash

# Install oh my zsh.
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install brew.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install git/wget/ack/autojump/tree.
brew install git
brew install wget
brew install ack
brew install autojump
brew install tree

echo '[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh' >> ~/.zshrc
source ~/.zshrc

# Install vim integrated development environment.
curl -L https://bit.ly/janus-bootstrap | bash

# Prepare folders.
mkdir -p ~/workspace/{github,gitlab,nodejsStarterKit}

# Create ssh key pair and config file.
ssh-keygen -f id_rsa -t rsa -N ''
cat << EOF > ~/.ssh/config
Host *
  UseKeychain yes
Host test1
  HostName test.nodejsStarterKit.com
  User dev
  IdentityFile ~/.ssh/dev.pem
Host test2
	HostName test2
	User	dev
	ProxyCommand ssh dev@xxx.xxx.xxx.xxx nc %h %p
  IdentityFile ~/.ssh/dev.pem
EOF

# Install nvm.
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
# NVM New verison have fix this bug.
#echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
#echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
source ~/.zshrc

# Install nodejs/yrm/yarn/lazyclone
nvm install stable
nvm alias default stable
nvm use stable
npm install --global yrm --registry=https://registry.npm.taobao.org
yrm use cnpm
npm i -g yarn
npm i -g lazyclone

# Create project
cd ~/workspace/nodejsStarterKit
mkdir src bin
git init
cat << EOF >.gitignore
# debugging logs
*.log
# project dependencies
node_modules
# OSX folder attributes
.DS_Store
# temporary files
*.tmp
*~
EOF
npm set init-author-name 'hongwei qian'
npm set init-author-email 'hongweiq@hotmail.com'
npm set init-author-url 'https://github.com/hongweiQ'
npm set init-license 'MIT'
npm init -y

# Install ESLint
npm install eslint eslint-loader eslint-plugin-react --save-dev
# eslint --init
cat << EOF > ~/workspace/nodejsStarterKit/.eslintrc.json
{
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true,
        "node": true
    },
    "extends": "eslint:recommended",
    "parserOptions": {
        "ecmaFeatures": {
            "experimentalObjectRestSpread": true,
            "jsx": true
        },
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ]
    }
}
EOF

# Install Babel
npm install babel-loader babel-core babel-preset-es2015 babel-preset-es2016 babel-preset-es2017 --save-dev

# setting up webpack
npm install webpack webpack-dev-server --save-dev
npm i -g webpack webpack-dev-server
cat << EOF > ~/workspace/nodejsStarterKit/webpack.config.js
module.exports = {
  entry:__dirname + '/src/index.js',                     // 唯一打包入口文件
  output: {
    path: __dirname + '/bin',          // 打包后文件存放的地方
    filename: 'bundle.js'              // 打包后输出文件的文件名
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "eslint-loader"
      },
      {
        test: /\.js$/,                              // 匹配打包文件后缀名的正则
        exclude: /(node_modules|bower_components)/, // 这些文件夹不用打包
        loader: 'babel-loader',
        query: {
          presets: ['es2016']
        }
      }
    ]
  }
}
EOF

# Pre Commit hook
npm install pre-commit --save-dev
#vim package.json
#  "scripts": {
#    "start": "webpack-dev-server",
#    "test": "webpack"
#  },
#  "pre-commit": [
#    "test"
#  ]

cat << EOF > ~/workspace/nodejsStarterKit/prod.webpack.config.js
var devConfig = require("./webpack.config.js");
var prodConfig = devConfig;
  prodConfig.output = {
    path: "bin",
    filename: "bundle.js"
  };
module.exports = prodConfig;
EOF

# reference：
# http://voidcanvas.com/setup-javascript-project-environment-with-webpack-eslint-babel-git/
# https://github.com/i5ting/i5ting-mac-init
