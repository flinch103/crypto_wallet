IMAGE_NAME=registry.gitlab.com/deqode/vodix/vodix-rails-app
DEPLOYMENT_NAME=vodix-app

get-patch:
	$(eval PATCH_NUM = $(shell kubectl get deployment ${DEPLOYMENT_NAME} -o=jsonpath="{.spec.template.spec.containers[1].image}" | rev | cut -d"." -f1 | rev))

increment-patch:
	$(eval PATCH_NUM=$(shell expr $(PATCH_NUM) + 1 ))

evaluate-tag:
	$(eval TAG=staging-0.0.${PATCH_NUM})

pull:
	git pull origin master

build:
	docker build . -t ${IMAGE_NAME}:${TAG}

push-tag:
	git tag ${TAG}
	git push origin ${TAG}

run-postgres:
	docker run --name postgres -e POSTGRES_PASSWORD=postgres -d --network temp postgres

run-rails:
	docker run -d -p 3000:3000 --network temp ${IMAGE_NAME}:${TAG}

push:
	docker push ${IMAGE_NAME}:${TAG}

update-image-rails-app:
	kubectl set image deployment vodix-app rails-app=${IMAGE_NAME}:${TAG}

ls:
	kubectl get po

deploy: get-patch increment-patch evaluate-tag pull push-tag build push update-image-rails-app ls
