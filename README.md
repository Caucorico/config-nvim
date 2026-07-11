# Neovim Configuration

My Neovim configuration, designed to work cleanly on **immutable / atomic** systems via **Distrobox**.

At the moment, the documented and supported setup is:

- **Host**: Fedora Atomic
- **Dev box**: Fedora via Distrobox

Other variants will come later:

- Debian host
- Debian Distrobox
- other setups as needed

# Installation on Fedora Atomic

## 1. Create the Distrobox

Create a dedicated Fedora box with a separate HOME:

```bash
mkdir -p ~/distroboxes/nvim-home

distrobox create \
  --name nvim-dev \
  --image fedora:latest \
  --home ~/distroboxes/nvim-home
```

Enter the box:

```bash
distrobox enter nvim-dev
```

___

## 2. Install the base dependencies

Inside the Distrobox:
```bash
sudo dnf -y install \
  ninja-build \
  cmake \
  gcc \
  gcc-c++ \
  make \
  gettext \
  curl \
  git \
  python3 \
  glibc-gconv-extra \
  libatomic \
  ccache
```

___

## 3. Install Node.js and npm with nvm

This configuration requires Node.js 25 or newer.

Install `nvm` in the box:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

Load `nvm` in the current shell:
```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

Install the latest version of Node:
```bash
nvm install node
nvm alias default node
nvm use node
hash -r
```

Check:
```bash
node -v
npm -v
```

If needed, update npm after `node` is working:
```bash
nvm install-latest-npm
npm -v
```

___

## 4. Clone this repository on the host

> The repository must be cloned on the Fedora Atomic host, not inside the Distrobox.

```bash
git clone git@github.com:Caucorico/config-nvim.git ~/src/nvim-config
```

Check the actual absolute path:
```bash
realpath ~/src/nvim-config
```

Example output:
```bash
/var/home/my_user/src/nvim-config
```

Keep this path: it will be used for the symbolic link inside the box.

___

## 5. Link the configuration inside the Distrobox

Inside the Distrobox, create `~/.config/nvim` as a symbolic link to the clone located on the host.

```bash
mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
ln -s /var/home/my_user/src/nvim-config ~/.config/nvim
```

Check:
```bash
ls -l ~/.config/nvim
```

___

## 6. Build Neovim inside the Distrobox

This configuration is intended for a manually built version of Neovim.

```bash
git clone https://github.com/neovim/neovim.git ~/src/neovim
cd ~/src/neovim

make distclean
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$HOME/.local"
make install
```

Check:
```bash
~/.local/bin/nvim --version
```

Optionally, add this to your shell inside the Distrobox to use the compiled version by default:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

___

# Update

## Update the configuration

From the host:
```bash
cd ~/src/nvim-config
git pull
```

Since the box points to this repository through a symbolic link, the configuration is updated immediately.

## Update the compiled Neovim

Inside the Distrobox:
```bash
cd ~/src/neovim
git fetch origin --prune --tags --force
git switch --detach stable
make distclean
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$HOME/.local"
make install
```

## Update Node.js

Inside the Distrobox:
```bash
nvm install node
nvm alias default node
nvm use node
hash -r
```

___

# Install the runtime dependencies required by the Strudel plugin

`strudel.nvim` uses **Puppeteer** to launch a bundled Chromium instance.
Inside the Distrobox, Chromium needs additional system libraries to start correctly,
and audio support must be present for sound output to work.

Install the required packages:

```bash
sudo dnf install -y \
  dbus-libs \
  nss \
  nspr \
  atk \
  at-spi2-atk \
  cups-libs \
  mesa-libgbm \
  alsa-lib \
  pango \
  cairo \
  libX11 \
  libXcomposite \
  libXdamage \
  libXext \
  libXfixes \
  libXrandr \
  libXScrnSaver \
  libXtst \
  libxkbcommon \
  pulseaudio-libs \
  alsa-plugins-pulseaudio
```

These dependencies were needed to fix issues such as:

- missing shared libraries when Chromium starts (`libnss3.so`, `libdbus-1.so.3`, etc.)
- no audio output from Strudel even though the browser launches correctly

Optional but useful for audio debugging inside the box:

```bash
sudo dnf install -y pulseaudio-utils alsa-utils
```

Useful test commands:

```bash
pactl info
paplay /usr/share/sounds/alsa/Front_Center.wav
```

If `paplay` works, the Distrobox can already reach the host audio server correctly.
