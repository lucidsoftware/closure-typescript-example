# closure-typescript-example
An example of using the Google Closure Compiler with TypeScript, Tsickle, and Clutz.

## Usage
To run the provided example, run `make` or `make run` at the root of the project. `make help` lists all available make targets.

## Dependencies
* Linux or Mac OSX
* Make
* Java
* npm

All other dependencies will be downloaded and installed locally in the project when you run make.

The project has been tested on Ubuntu 14.04.

## Docker
A docker container exists for this repository. It contains a copy of the repository with `make deps` already run.

In order to run the docker container,
```
docker pull jjudd/closure-typescript-example
docker run -i -t jjudd/closure-typescript-example
```

Then you can

```
cd closure-typescript-example
make run
````
