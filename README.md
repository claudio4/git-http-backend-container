A dead simple git smart-http server using nginx as a frontend. No authentication, push is free-for-all.

Usage:

```
docker run -d -p 4080:80 -v /path/to/host/gitdir:/git ynohat/git-http-backend
```

Unauthenticated push will not work unless you enable it in repositories:

```
cd /path/to/host/gitdir
git init --bare test.git
cd test.git
git config http.receivepack true
```