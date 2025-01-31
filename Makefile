UID	:= $(shell id -u)
GID	:= $(shell id -g)


up: .env galaxy/venv pulsar/venv
	docker-compose up

up-d: .env galaxy/venv pulsar/venv
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose restart galaxy-web galaxy-job pulsar

.env:
	sh ./.env.in

galaxy/venv:
	bash ./galaxy/init.sh

pulsar/venv:
	bash ./pulsar/init.sh

pulsar-galaxy-lib:
	bash ./galaxy/pulsar-galaxy-lib.sh

clean:
	rm -f .env
	rm -rf galaxy/venv galaxy/database pulsar/venv pulsar/var
	git checkout -- galaxy/database/README pulsar/var/README
	docker-compose rm -sf
	docker rmi -f galaxy-pulsar-dev:pulsar galaxy-pulsar-dev:galaxy-job galaxy-pulsar-dev:galaxy-web

.PHONY: clean up up-d down pulsar-galaxy-lib
