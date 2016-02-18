#!/usr/bin/env bash
(
cd "$(dirname "$0")"

read -d '' handler <<- EOF
(function(){
    var worker = Elm.worker(Elm.Main);
})();
EOF

elm-package install -y
elm-make --yes --output test.js Test.elm
echo "$handler" >> test.js
node test.js
rm test.js
)
