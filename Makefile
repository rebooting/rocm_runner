shell:
	docker exec -it automatic bash -c ". /python/venv/bin/activate bash && bash"
make root-shell:
	docker exec -it automatic --user 0 bash
run:
	docker run --user 1000 --name automatic \
		--device /dev/kfd --device /dev/dri --group-add video \
		-v /dev/kfd:/dev/kfd --group-add render -v /dev/dri:/dev/dri \
		-p 7860:7860 \
		-p 7865:7865 \
		--security-opt seccomp=unconfined \
		--mount type=volume,source=pvenv,destination=/python \
		--mount type=volume,source=homecache,destination=/home \
		-d \
		-v $(CURDIR)/scratch:/app/scratch local/automatic sleep infinity

restore:
	docker exec -it automatic bash -c "cd /python && python3 -m venv venv "
kill:
	docker kill automatic | true
	docker rm automatic

clean:
	docker system prune -f
build:
	docker build -t local/automatic  -f automatic.dockerfile .

volume-up:
	docker volume create pvenv|true
	docker volume create homecache|true

	# docker run --rm --name tmp \
	# 	-v pvenv:/python -ti local/automatic bash -c "mkdir -p /python/venv &&  chown -R 1000:1000 /python"
volume-down:
	docker volume rm pvenv
	docker volume rm homecache
volume-verify:
	docker run --rm -v pvenv:/python -ti local/automatic bash -c "ls -l /python"