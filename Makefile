.PHONY: up setup build run lint fmt test test.watch

up:
	docker-compose up
setup:
	make build

build:
	mix do deps.get + compile

run:
	mix phx.server

lint:
	mix format --check-formatted

fmt:
	mix format

test:
	mix test
