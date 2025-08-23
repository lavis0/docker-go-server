# Docker Server Basics

The Deployment Process
- The developer (you) writes some new code
- The developer commits the code to Git
- The developer pushes a new branch to GitHub
- The developer opens a pull request to the main branch
- A teammate reviews the PR and approves it (if it looks good)
- The developer merges the pull request
- Upon merging, an automated script, perhaps a Github action, is started
- The script builds the code (if it's a compiled language)
- The script builds a new docker image with the latest program
- The script pushes the new image to Docker Hub
- The server that runs the containers, perhaps a Kubernetes cluster, is told there is a new version
- The k8s cluster pulls down the latest image
- The k8s cluster shuts down old containers as it spins up new containers of the latest image

## Some commands used

Generally, just using a `--help` flag gives you all the information you need, but here are a few of the common commands.

### `docker run`
This is perhaps the most versatile command, and it has many flags to control how your container starts.

*   `--rm`: Automatically remove the container when it exits. This is super handy for temporary containers you don't need to keep around.
    ```bash
    docker run --rm my_image
    ```
*   `-p <host_port>:<container_port>`: Publish a container's port(s) to the host. This allows you to access services running inside the container from your host machine.
    ```bash
    docker run -p 8080:80 my_web_app
    ```
*   `-v <host_path>:<container_path>`: Mount a volume. This allows you to share files or directories between your host machine and the container, ensuring data persists even if the container is removed.
    ```bash
    docker run -v /my/host/data:/app/data my_app
    ```
*   `--env <KEY>=<VALUE>` or `-e <KEY>=<VALUE>`: Set environment variables inside the container. Very useful for configuration.
    ```bash
    docker run -e MY_SETTING=true my_app
    ```
*   `--detach` or `-d`: Run container in the background and print container ID. This lets your terminal return immediately so you can continue working.
    ```bash
    docker run -d my_server_app
    ```

### `docker build`
When you're crafting your Docker images, these flags come in handy:

*   `-t <name>:<tag>`: Tag the image with a name and optional tag. This makes your images easy to find and reference. If you don't provide a tag, `latest` is used by default.
    ```bash
    docker build -t my_backend:v1.0 .
    ```
*   `--no-cache`: Do not use cache when building the image. Sometimes you want to ensure a fresh build, ignoring any cached layers.
    ```bash
    docker build --no-cache .
    ```
*   `--pull`: Always attempt to pull a newer version of the base image. This ensures your base image is up-to-date.
    ```bash
    docker build --pull .
    ```

### `docker network`
While `docker network` has its own subcommands (like `create`, `ls`, `inspect`), when used with `docker run`, the `--network` flag is the most common. Other flags typically apply to the `docker network` *subcommands* themselves, rather than being passed directly to `docker network`.

For example, when creating a network:

*   `docker network create --driver <driver_name>`: Specify the network driver. Common ones include `bridge` (default) and `host`.
    ```bash
    docker network create --driver bridge my_custom_network
    ```

### `docker push`
When sending your images to a registry:

*   `--all-tags`: Push all tags of an image repository. If you have multiple tags for the same image, this pushes them all.
    ```bash
    docker push --all-tags my_repo/my_image
    ```

### `docker image` (or `docker images`)
For managing your local images:

*   `docker image ls --filter "reference=<pattern>"`: Filter images based on a pattern (e.g., repository name).
    ```bash
    docker image ls --filter "reference=ubuntu"
    ```
*   `docker image rm -f <image_id>` or `docker image rm --force <image_id>`: Force removal of one or more images. Useful if an image is in use by a stopped container.
    ```bash
    docker image rm -f my_old_image
    ```

### `docker ps`
For listing containers:

*   `-s` or `--size`: Display total file sizes. This shows the virtual size of the container and its actual size on disk.
    ```bash
    docker ps -s
    ```
*   `-f "status=exited"` or `--filter "status=exited"`: Filter containers by status. You can filter by many criteria like `name`, `status`, `ancestor` (image name), etc.
    ```bash
    docker ps -a -f "status=exited"
    ```

### `docker stats`
For monitoring:

*   `--no-stream`: Do not stream stats and just pull the current stats. Useful for getting a snapshot without continuous updates.
    ```bash
    docker stats --no-stream
    ```

### `docker logs`
For checking container output:

*   `-f` or `--follow`: Follow log output. This will stream new logs as they are generated, like `tail -f`.
    ```bash
    docker logs -f my_app_container
    ```
*   `--tail <number>`: Output the specified number of `latest` lines. Useful for just seeing the end of a long log file.
    ```bash
    docker logs --tail 100 my_app_container
    ```
*   `--since <timestamp_or_duration>`: Show logs since a specific timestamp or relative duration (e.g., `10m` for 10 minutes, `1h` for 1 hour).
    ```bash
    docker logs --since 30m my_app_container
    ```
