#!/usr/bin/env bash
# ./node_modules/.bin/babel app --out-dir build --copy-files -s
# ./node_modules/.bin/browserify build/app.js --debug -o build/app.js

mkdir -p ./build/
cp ./app/*.html ./build/

./node_modules/.bin/browserify app/app.js -t [babelify app] --extension=.jsx --debug -o build/app.js