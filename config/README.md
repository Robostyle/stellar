# Stellar ZMK firmware


## Building the firmware

The Stellar keyboard uses [ZMK](https://zmk.dev/) firmware which is powered by the [Zephyr :tm: Project ](https://zephyrproject.org/) Real Time Operating System (RTOS).

There are two ways to build, either through a GitHub action, or with a local toolchain.

### Local builds

To build the firmware, see the instructions under the "Development' section. You need to setup ZMK by following the instructions under "Native" [here](https://zmk.dev/docs/development/local-toolchain/setup/native). This only needs to be done once, if you leave the Python virtual environment, source the virtual environment again. 

The actual instructions to build and flash can be found under the section "Building and Flashing" page [here](https://zmk.dev/docs/development/local-toolchain/build-flash). Since this is an external module, follow the instructions under "Building from `zmk-config` Folder".

The TL;DR is (consult the above documentation if this does not work):

Open Zephyr's Getting Started Guide and follow the instructions under these sections:

- [Select and Update OS](https://docs.zephyrproject.org/3.5.0/develop/getting_started/index.html#select-and-update-os)
- [Install Dependencies](https://docs.zephyrproject.org/3.5.0/develop/getting_started/index.html#install-dependencies), for users not using an Ubuntu based distribution, follow the
instructions on the [Install Linux Host Dependencies](https://docs.zephyrproject.org/3.5.0/develop/getting_started/installation_linux.html) page.

Clone the repository:

`git clone git@github.com:Robostyle/stellar.git`

After cloning, you can make the firmware with:

```bash
make 
```

This will build the firmware and place the output in `firmware`.

### Development

In case you like to modify the code, you can perform incremental builds with:

```bash
make build
```
