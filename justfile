VERSION := "0.1.0"
APP := "password"
RUNTIME := os() + "-" + arch()

alias c := clean
#alias t := test
alias b := build
alias r := release
alias d := dist

# Default recipe (this list)
default:
    @just --list

# Build debug
build:
    crystal build -o {{APP}} src/main.cr

# Build release
release: clean
    -mkdir -p bin/{{RUNTIME}}
    crystal build --release -o bin/{{RUNTIME}}/{{APP}} src/main.cr
    strip bin/{{RUNTIME}}/{{APP}}

# Dist
dist: release
    -mkdir dist
    zip -j dist/{{APP}}_{{RUNTIME}}_{{VERSION}}.zip bin/{{RUNTIME}}/{{APP}}

# Remove generated files
clean:
    -rm {{APP}}
    -rm -rf bin/{{RUNTIME}}

