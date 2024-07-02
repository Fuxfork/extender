#!/bin/bash -e

TARGET_DIR=$1
if [[ -z ${TARGET_DIR} ]]; then
	echo "Missing target dir"
	exit 1
fi

# realpath: brew install coreutils
if [ ! -d "${TARGET_DIR}" ]; then
	mkdir -p ${TARGET_DIR}
fi

export TARGET_DIR=$(realpath ${TARGET_DIR})

echo "Rebuilding and running standalone local extender from ${TARGET_DIR}"

if [ -f "${TARGET_DIR}/current/service.sh" ]; then
	echo "Stopping server"
	${TARGET_DIR}/current/service.sh stop ${TARGET_DIR}
fi

if [ ! -z ${DM_DEBUG_JOB_FOLDER} ] && [ -d ${DM_DEBUG_JOB_FOLDER} ]; then
	echo "Removing job folder"
	rm -rf ${DM_DEBUG_JOB_FOLDER}
fi

if [ ! -z ${DM_DEBUG_JOB_FOLDER} ]; then
	echo "Creating job folder"
	mkdir -p ${DM_DEBUG_JOB_FOLDER}
fi

echo "Building server"
./server/scripts/build-standalone.sh -xtest

echo "Running server"
./server/scripts/run-standalone-local.sh ${TARGET_DIR}
tail -f ${TARGET_DIR}/logs/stdout.log
