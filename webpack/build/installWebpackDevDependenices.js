#!/usr/bin/env node

/*
 * resolve devDenpendices writen in webpack.config.js like require('xxx') and 'yyy-loader'
 * then use 'npm install -save-dev xxx yyy-loader' to install them
 */

const fs = require('fs');
const path = require('path');
const exec = require('child_process').exec;

const webpackConfigPath = process.argv[2] ? path.resolve(process.argv[2]) : path.resolve(__dirname, 'webpack.config.js');

fs.readFile(webpackConfigPath, 'utf8', (err, data) => {
    if (err) {
        console.log(err);
        return;
    }
    data = data.replace(/[\n\r\t]/gi, '');

    let rPlugin = /require\(["']([\w-]+)["']\)/gi
    let rLoader = /["']([\w-]+-loader)["']/gi
    let arr;
    let plugins = new Set();
    let loaders = new Set();
    while((arr = rPlugin.exec(data))) {
        plugins.add(arr[1]);
    }
    plugins = [...plugins].join(' ');

    while((arr = rLoader.exec(data))) {
        loaders.add(arr[1]);
    }
    loaders = [...loaders].join(' ');

    let cmd = `npm install --save-dev ${loaders} ${plugins}`;
    console.log(cmd);
    console.log('installing ...');
    exec(cmd, (err, stdout, stderr) => {
        if (err) {
            console.log(err);
        } else {
            console.log('done !');
        }
    });
});
