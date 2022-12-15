# Telnet Server for C64

Minimal Telnet Server Image for usage with CCGMS and C64.

Features:
- Customizable set of packages
- Dedicated (Non-Root) Telnet User
- Handles Backspace signal of C64 properly
- Optimized for 40 columns: Simple prompt and uncluttered login messages

## Building the container

The container can be customized during build with the following arguments

| Name                | Required | Description |
|---------------------|----------|-------------|
| ADDITIONAL_PACKAGES | No       | Additional packages to be installed during build |
| USER                | Yes      | Name of the user to create during build |
| PASSWORD            | Yes      | Password of the user |

Example:
```sh
#!/bin/sh
docker build \
    --build-arg ADDITIONAL_PACKAGES="toot telnet ssh ed" \
    --build-arg USER=c64 \
    --build-arg PASSWORD=1541 \
    -t c64server:latest .
```

## Running the container
To prevent data loss when the container is recreated I recommend to mount the users home folder as a volume to some local folder.
Also providing a hostname makes the login look a bit nicer.

```sh
docker run \
    --name c64server_1 \
    -d \
    -h server \
    -p 1541:23 \
    -v /some/folder/data:/home/c64 \
    c64server:latest
```

## FAQ
### Why Debian?
I picked Debian because it is widely available for all kind of platforms, including Raspberry PI where my c64 telnet server is running on

### Why not Alpine?
The telnet deamon from the busybox-extras package didn't work particularly well with CCGMS on the C64

### Is this ready to be used in production?
Seek a doctor and get professional help. Whatever you got there, have it treated!