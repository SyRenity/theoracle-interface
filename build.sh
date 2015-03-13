#!/bin/bash

source .env
browserify --extension .coffee --entry script/new.coffee | uglifyjs --mangle --compress warnings=false > compiled/new.js
browserify --extension .coffee --entry script/manage.coffee | uglifyjs --mangle --compress warnings=false > compiled/manage.js

