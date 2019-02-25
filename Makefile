IMAGE_NAME=registry.gitlab.com/deqode/vodix/vodix-rails-app
PATCH_NUM=7
TAG=staging-0.0.${PATCH_NUM}

build:
	docker build . -t ${IMAGE_NAME}:${TAG}

run-postgres:
	docker run --name postgres -e POSTGRES_PASSWORD=postgres -d --network temp postgres

run-rails:
	docker run -d -p 3000:3000 --network temp ${IMAGE_NAME}:${TAG}
