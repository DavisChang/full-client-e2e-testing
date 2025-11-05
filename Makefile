.PHONY: bootstrap lint test-web test-android test-windows test-mac test-journeys clean compose-up compose-down compose-health

bootstrap:
	python -m venv .venv
	. .venv/bin/activate && pip install -r requirements.txt
	npm install

lint:
	npx robotidy --check tests resources
	npx robocop tests resources

test-web:
	robot --variable ENV:dev --variable PLATFORM:web --variable USER_ROLE:standard -d reports/dev-web tests/web

test-android:
	robot --variable ENV:dev --variable PLATFORM:android --variable USER_ROLE:standard -d reports/dev-android tests/android

test-windows:
	robot --variable ENV:dev --variable PLATFORM:windows -d reports/dev-windows tests/windows

test-mac:
	robot --variable ENV:dev --variable PLATFORM:mac -d reports/dev-mac tests/mac

test-journeys:
	robot --variable ENV:dev --variable USER_ROLE:standard -d reports/dev-journeys tests/journeys

clean:
	rm -rf reports/*

compose-up:
	docker compose up -d

compose-down:
	docker compose down

compose-health:
	python tools/compose-healthcheck.py
