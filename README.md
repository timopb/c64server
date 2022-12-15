# Minimal Telnet Server Docker Image (for use with CCGMS on C64)

**DISCLAIMER:** Telnet is highly insecure. All traffic from and to the telnet
server is transmitted in plaintext. Telnet servers and clients should only
be operated in an isolated enviornment (i.e. your personal home network). 
Be aware that everything you type into your telnet client can potentially be 
intercepted by anyone on the same network. Don't blame me, I told you!

Features:
- Customizable set of packages
- Dedicated (Non-Root) Telnet User
- Handles Backspace signal of C64 properly
- Optimized for 40 columns: Simple prompt and uncluttered login messages

## Building the docker image

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
Also providing a hostname makes the login prompt look a bit nicer.

```sh
docker run \
    --name c64server_1 \
    -d \
    -h server \
    -p 1541:23 \
    -v /some/folder/data:/home/c64 \
    c64server:latest
```

## Connecting to the the server from your C64
1. Plug the wifi modem into the userport of the C64. Follow the instructions on the modem manual to connect it to your wifi.
2. Switch your modem into telnet mode and disable PET MCTerm Translation. Note: Not ever modem may support this. I hope yours does.
```
atnet1
atpet=0
```
Persist these settings in nvram if you don't want to issue the commands everytime you reboot your C64:
```
at&w
```
3. Tell the modem to "dial" a telnet connection to your server
```
atdt ip_or_hostname_of_your_server:port
```
4. Login with the user and password you specified when building the docker image
5. Profit!

## FAQ
### Why Debian?
I picked Debian because it is widely available for all kind of platforms, including Raspberry PI where my c64 telnet server is running on

### Why not Alpine, it's so much smaller?
The telnet deamon from the busybox-extras package didn't work particularly well with CCGMS on the C64

### Is this ready to be used in production?
Seek a doctor and get professional help. Whatever you got there, have it treated!