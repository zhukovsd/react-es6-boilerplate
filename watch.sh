#!/usr/bin/env bash

watchify app/app.js -t [babelify app] --extension=.jsx --debug -o build/app.js -v &
browser-sync start --server build --files build/app.js --port 3000 --reload-delay 100 &

wait