#!/bin/bash
[ ! -d "tmp" ] && mkdir -p "tmp"
[ ! -f "tmp/dudect.zip" ] && curl -L https://github.com/oreparaz/dudect/zipball/1c2d60e/ --output tmp/dudect.zip
[ ! -f "tmp/dudect.zip" ] && printf "Failed downloading dudect \n" && exit 1

if ! unzip "tmp/dudect.zip" -d "tmp/"; then
    printf "Failed extracting dudect zip \n" && exit 1
fi

mv tmp/oreparaz-dudect-1c2d60e/src src/dudect/
mv tmp/oreparaz-dudect-1c2d60e/inc src/dudect/

rm src/dudect/inc/donna.h src/dudect/inc/rijndael-alg-fst.h
rm -rf tmp/oreparaz-dudect-1c2d60e
rm tmp/dudect.zip
