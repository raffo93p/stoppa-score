#!/bin/bash
flutter build web --release --base-href "/stoppa-score-demo/"
cd ./build/web
git remote add origin git@github.com:raffo93p/stoppa-score-demo.git
cd ../..