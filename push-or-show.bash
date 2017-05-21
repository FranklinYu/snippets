#!/bin/bash

set -o errexit -o pipefail -o nounset

repository=$1
tag=${2:-latest}

if [ $SEMAPHORE_THREAD_RESULT = passed ]; then
	echo 'vendor/bundle/' >> .dockerignore
	docker-cache restore
	docker build --tag $repository:$tag . | cat
	docker push $repository | cat
	docker-cache snapshot
else
	tail log/production.log
fi
