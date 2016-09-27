var path = require('path');

var nameToPath = {};
var pathRequires = {};

goog = {};
goog.addDependency = function(file, provides, requires) {
    file = './closure-library/closure/goog/'+file
    file = '/'+path.relative('./',file);
    provides.forEach(function(p) {
        nameToPath[p] = file;
    });

    pathRequires[file] = requires;
};

require('./bin/deps.js');

var deps = {};
for(var file in pathRequires) {
    deps[file] = [];

    pathRequires[file].forEach(function(dep) {
        if(deps[file].indexOf(nameToPath[dep]) == -1) {
            deps[file].push(nameToPath[dep]);
        }
    });
}

var root = nameToPath[process.argv[2]];
var leaf = nameToPath[process.argv[3]];
console.log(root);
console.log(leaf);

var visited = {};

//Find every path from root down to leaf
function checkDeps(child, depPath) {
    if(visited[child] || (child === undefined)) {
        return;
    }
    visited[child] = true;

    deps[child].forEach(function(dep) {
        if(dep == leaf) {
            console.log(depPath.concat([dep]));
        } else {
            checkDeps(dep, depPath.concat([dep]));
        }
    });
}

checkDeps(root, [root]);
