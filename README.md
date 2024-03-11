# password

`password` is a command line tool that helps generate passwords and check passwords against previous data breaches (https://haveibeenpwned.com/).

I created this projet as a means to learn and experiment with the [Crystal](https://crystal-lang.org/) programming language.

![Password CLI Help Screenshot](https://github.com/andreburgaud/password/assets/6396088/c375ae9d-5c3d-4f1a-bfd2-fcfabc45bf29)

## Usage

Docker is the easiest way to use 'password':

```
docker run --rm -it andreburgaud/password --help
```

## Development

### Requirements

1. [Crystal](https://crystal-lang.org/) needs to be installed on your system.
1. [just](https://github.com/casey/just) is optional but recommended to build the executable.

### Build

To build a local debug version:

```
just build
```

A file named `password` will be generated at the root of the project.

To build a release version:

```
just release
```

You will find a `password` executable file in a subdiretory of the `bin` directory.

## Contributors

- [Andre Burgaud](https://github.com/your-github-user) - creator and maintainer
