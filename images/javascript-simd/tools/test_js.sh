#!/bin/bash -ex
cd bin
npm install --production
#npm test
node --experimental-wasm-simd tests.js
