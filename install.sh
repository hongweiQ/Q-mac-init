#! /bin/bash

# oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install
brew install git
brew install wget
brew install ack
brew install autojump
brew install tree

echo '[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh' >> ~/.zshrc
source ~/.zshrc

# vim
curl -L https://bit.ly/janus-bootstrap | bash

# prepare folders
mkdir -p ~/workspace/{github,gitlab,myproject}

# ssh-keygen 
ssh-keygen -f id_rsa -t rsa -N ''
cat << EOF > ~/.ssh/config
Host *
  UseKeychain yes
Host test1
  HostName test.myproject.com
  User op
  IdentityFile ~/.ssh/op.pem
Host test2
	HostName test2
	User	op
	ProxyCommand ssh op@xxx.xxx.xxx.xxx nc %h %p
  IdentityFile ~/.ssh/op.pem
EOF

# node version manager - nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
# NVM New verison have fix this bug.
#echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
#echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
source ~/.zshrc
nvm install stable
nvm alias default stable
nvm use stable
npm install --global yrm --registry=https://registry.npm.taobao.org
yrm use cnpm
npm i -g yarn
npm i -g lazyclone

cd ~/workspace/myproject
npm init -yes
npm install webpack --save-dev
npm install webpack-dev-server --save-dev
npm install babel-loader babel-core babel-preset-es2015 --save-dev
npm install eslint eslint-loader --save-dev
npm install pre-commit --save-dev

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

cat << EOF > ~/workspace/myproject/.eslintrc.json
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

cat << EOF > ~/workspace/myproject/webpack.config.js
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
          presets: ['es2015']
        }
      }
    ]
  }
}
EOF

cat << EOF > ~/workspace/myproject/prod.webpack.config.js
var devConfig = require("./webpack.config.js");
var prodConfig = devConfig;
  prodConfig.output = {
    path: "dist",
    filename: "bundle.js"
  };
module.exports = prodConfig;
EOF
