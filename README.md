# Docker SBT

Create an sbt docker image which can easily be used to build your projects.

Run `./build.sh` to build several versions, with a tag for each sbt and scala version combination.

Use `./sbt.sh` as an easy way of building a project with docked sbt. eg.

```
sbt.sh --scala 2.10.6 --sbt 0.13.12 -- clean test
```
