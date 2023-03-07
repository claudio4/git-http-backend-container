# Git HTTP Backend Container
Git HTTP Backend Container is a fork of ynohat/git-http-backend that provides a simple way to host a Git HTTP server on a container. This project is aimed at users who want to host their Git repositories on a server accessible over HTTP. The main features of this project are its simplicity and support for user authentication.

## Features:
* Simple and easy to set up
* Provides user authentication
* Serve git over HTTP:

## Usage:
To use it you need a folder where you store  your git repositories. To create a new repository, create a subfolder with the name of your new repo in your git folder, go into it and execute
```bash
git init --bare
```
You also need to create a file with your user credentials. You can read more [here](https://www.hostwinds.com/tutorials/create-use-htpasswd).

Now you can launch the container, either by using the included [docker-compose file](/docker-compose.yaml) or by executing:
```bash
docker run -d -p 80:80 -v "/path/to/host/gitdir:/git" -v "/path/to/your/auth/file:/etc/nginx/htpasswd:ro" --user 1000:1000 ghcr.io/claudio4/git-http-backend-container:master
```

You can see that the command above includes the `--user` parameter. It is recommended that you change the `uid` and `gid` for the ones that you use to create your git repositories folder. I really **discourage** the use of the root user for this matter.
