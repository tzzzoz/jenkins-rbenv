set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=tzzzoz
# image name
IMAGE=jenkins-rbenv
docker build -t $USERNAME/$IMAGE:latest .
