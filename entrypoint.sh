#!/bin/sh
#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
# entrypoint.sh designed around integrating gcsfuse into the container.
# The primary focus is proper cleanup so that if there are remaining files
# to be uploaded the orchestrator (kubernetes, docker, etc..) will wait.

#
# Mount google cloud storage bucket
#
gcsfuse -o nonempty streaming-platform-vod-01 /storage-bucket

#
# If there are anymore arguments passed to the entrypoint,
# invoke the sh shell and pass the value as a command string.
#
# You can perform a SIGTERM/whatever on the process(es) that are
# launched next so that this script will then continue to the 
# blocks below. (i.e.: pkill somescript)
#
/bin/sh -c "$@"

#
# The only way for the shell interpreter to have gotten to this 
# point would be if the subcommand has exited.
#
# This is a good place to perform cleanup without having to worry
# about lifecycle hooks at the orchestration level (kubernets, docker, etc).
#

#
# Wait until directory is empty indicating that there are no
# remaining files to be uploaded.
#

# Use the environment variable DATA_DIR or replace the path here.
DIR=$DATA_DIR

echo "Waiting for $DIR to be empty..."

until [ "$(echo "$DIR/"*)" = "$DIR/*" ]
do 

    echo -n .
    sleep 2

done

#
# Gracefully un-mount the gcsfuse storage bucket.
#
echo && echo "Un-mounting gcsfuse mounts.."
fusermount -u /storage-bucket