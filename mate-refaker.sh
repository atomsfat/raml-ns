#!/bin/bash
[[ -f "${TM_SUPPORT_PATH}/lib/bash_init.sh" ]] && . "${TM_SUPPORT_PATH}/lib/bash_init.sh"

read -r -d '' script << EOM
  var fs = require('fs');
  var jsf = require('json-schema-faker');
  var schemaTxt = fs.readFileSync('$TM_FILEPATH');
  var schemaJson = JSON.parse(schemaTxt);
  var refFiles = "$(find $TM_DIRECTORY -name "*.json" -not -path "$TM_DIRECTORY/node_modules/*" -not -path "$TM_DIRECTORY/package.json")";
  refFiles = refFiles.split(" ");
  var refs = [];
  refFiles.forEach(function(it){
    var itTxt = fs.readFileSync(it);
    refs.push(JSON.parse(itTxt));
  });
  var fake = jsf(schemaJson, refs);
  process.stdout.write(JSON.stringify(fake, null,2));  
EOM


echo $script > $TM_DIRECTORY/.temp-faker.js

/Users/atomsfat/.nvm/v0.10.33/bin/node $TM_DIRECTORY/.temp-faker.js
