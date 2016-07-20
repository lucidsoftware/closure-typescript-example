# closure-typescript-example
An example of using the Google Closure Compiler with Angular 2, TypeScript,
Tsickle, and Clutz.

## Usage
To run the provided example, run `make run` at the root of the project. `make
help` lists available make targets.

## Dependencies
* Linux or Mac OSX
* Make
* Java
* npm
* python (for SimpleHTTPServer)

All other dependencies will be downloaded and installed locally in the project
when you run make.

The project has been tested on Ubuntu 14.04.

### Custom built dependencies
This project builds Closure compilable versions of Angular and its dependencies
and transitive dependencies. These include RxJS and symbol-observable.

The changes which make this possible have not been committed upstream. Discussion
around these changes can be found at https://github.com/angular/angular/issues/8550.
The discussion is not exhaustive. If you have any questions, the build process and
changes to the code are the best documentation.

## Docker
A Docker container exists for this repository. To see the project in action,
just run the Docker container and go to localhost:8000.

In order to run the docker container,
```
docker pull jjudd/closure-typescript-example
docker run -t -i -p 8000:8000 --net=host jjudd/closure-typescript-example
```

Then open a browser and go to `localhost:8000`. This loads the example in
compiled mode.

To switch between compiled and uncompiled, go to

```
localhost:8000/index.html?compiled=1
localhost:8000/index.html?compiled=0
```

If you want to play around with the source in the container, you can launch
the container as follows

```
docker run -t -i -p 8000:8000 --net=host jjudd/closure-typescript-example /bin/bash
```
