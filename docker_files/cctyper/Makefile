NAME=cctyper
TAG:=$(shell /bin/date +%Y%m%d%H%M%S)
REGISTRY=458432034220.dkr.ecr.us-west-2.amazonaws.com/$(NAME)

all: build push run

build:
	docker image build -t $(NAME):$(TAG) --no-cache --pull -f Dockerfile .
	docker image tag $(NAME):$(TAG) $(REGISTRY):$(TAG)
	docker image tag $(NAME):$(TAG) $(REGISTRY):latest

push:
	docker image push $(REGISTRY):$(TAG)
	echo "$(REGISTRY):$(TAG)" > LATEST

latest:
	docker image push $(REGISTRY):latest

run:
	docker container run --rm $(NAME):$(TAG) $(NAME) -h