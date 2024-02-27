VERSION := "0.1.0"
APP := "password"
DOCKER_IMAGE := "andreburgaud" / APP
RUNTIME := os() + "-" + arch()

alias c := clean
#alias t := test
alias b := build
alias r := release
alias d := dist
alias db := docker-build
alias ds := docker-scout
alias dp := docker-push

# Default recipe (this list)
default:
    @just --list

# Build debug
build:
    crystal build -o {{APP}} src/main.cr

# Build release
release: clean
    -mkdir -p bin/{{RUNTIME}}
    crystal build --release --no-debug -o bin/{{RUNTIME}}/{{APP}} src/main.cr
    strip bin/{{RUNTIME}}/{{APP}}

# Dist
dist: release
    -mkdir dist
    zip -j dist/{{APP}}_{{RUNTIME}}_{{VERSION}}.zip bin/{{RUNTIME}}/{{APP}}

# Remove generated files
clean:
    -rm {{APP}}
    -rm -rf bin/{{RUNTIME}}

docker-build:
    docker build -t {{DOCKER_IMAGE}}:latest .
    docker tag {{DOCKER_IMAGE}}:latest {{DOCKER_IMAGE}}:{{VERSION}}

# Docker scout (container image security scan)
docker-scout:
    docker scout cves andreburgaud/{{APP}}:{{VERSION}}

# Push showcert docker image to docker hub
docker-push: docker-build
    docker push docker.io/{{DOCKER_IMAGE}}:{{VERSION}}
    docker tag {{DOCKER_IMAGE}}:{{VERSION}} docker.io/{{DOCKER_IMAGE}}:latest
    docker push docker.io/{{DOCKER_IMAGE}}:latest
