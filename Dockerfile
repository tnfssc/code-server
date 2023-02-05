FROM ubuntu:jammy

# Install Nala
RUN apt update
RUN apt install --quiet --yes software-properties-common nala

# Install basic dependencies
RUN add-apt-repository --yes ppa:fish-shell/release-3
RUN nala update && nala fetch --auto -y
RUN nala install -y \
  openssh-client \
  build-essential \
  git \
  curl \
  wget \
  fish \
  unzip
RUN nala install -y \
  autoconf \
  bison \
  gettext \
  libgd-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libicu-dev \
  libjpeg-dev \
  libmysqlclient-dev \
  libonig-dev \
  libpng-dev \
  libpq-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libzip-dev \
  openssl \
  pkg-config \
  re2c \
  zlib1g-dev

# Install Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python \
  --install-extension astro-build.astro-vscode \
  --install-extension formulahendry.auto-rename-tag \
  --install-extension jeff-hykin.better-cpp-syntax \
  --install-extension aaron-bond.better-comments \
  --install-extension streetsidesoftware.code-spell-checker \
  --install-extension pranaygp.vscode-css-peek \
  --install-extension Dart-Code.dart-code \
  --install-extension mikestead.dotenv \
  --install-extension tamasfe.even-better-toml \
  --install-extension cschleiden.vscode-github-actions \
  --install-extension codezombiech.gitignore \
  --install-extension eamodio.gitlens \
  --install-extension golang.Go \
  --install-extension ecmel.vscode-html-css \
  --install-extension wix.vscode-import-cost \
  --install-extension Orta.vscode-jest \
  --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
  --install-extension redhat.java \
  --install-extension DavidAnson.vscode-markdownlint \
  --install-extension PKief.material-icon-theme \
  --install-extension PKief.material-product-icons \
  --install-extension unifiedjs.vscode-mdx \
  --install-extension christian-kohler.path-intellisense \
  --install-extension redhat.vscode-xml \
  --install-extension felixfbecker.php-intellisense \
  --install-extension esbenp.prettier-vscode \
  --install-extension Prisma.prisma \
  --install-extension redhat.vscode-commons \
  --install-extension rust-lang.rust-analyzer \
  --install-extension foxundermoon.shell-format \
  --install-extension Divlo.vscode-styled-jsx-languageserver \
  --install-extension Divlo.vscode-styled-jsx-syntax \
  --install-extension svelte.svelte-vscode \
  --install-extension bradlc.vscode-tailwindcss \
  --install-extension Gruntfuggly.todo-tree \
  --install-extension johnsoncodehk.volar \
  --install-extension redhat.vscode-yaml \
  --install-extension stylelint.vscode-stylelint \
  --install-extension ms-azuretools.vscode-docker \
  --install-extension denoland.vscode-deno \
  --install-extension redwan-hossain.skillavid-pure-black \
  --install-extension bierner.markdown-preview-github-styles \
  --install-extension zxh404.vscode-proto3 \
  --install-extension adpyke.codesnap \
  --install-extension oderwat.indent-rainbow \
  --install-extension tabnine.tabnine-vscode

# Change default shell to fish
RUN chsh -s /usr/bin/fish
ENV SHELL /usr/bin/fish
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

# Use shell fish
SHELL ["/usr/bin/fish", "-c"]

# Install asdf-vm
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf
RUN mkdir -p ~/.config/fish/completions
RUN ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
RUN echo -e '\nsource ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
RUN echo -e '\nlegacy_version_file = yes' >> ~/.asdfrc

# Install asdf plugins
RUN asdf plugin add bun && asdf install bun latest && asdf global bun latest
RUN asdf plugin add golang && asdf install golang latest && asdf global golang latest
RUN asdf plugin add nodejs && asdf install nodejs 18.13.0 && asdf global nodejs 18.13.0
RUN asdf plugin add python && asdf install python latest && asdf global python latest
RUN asdf plugin add rust && asdf install rust latest && asdf global rust latest
RUN asdf plugin add rust-analyzer && asdf install rust-analyzer latest && asdf global rust-analyzer latest
RUN asdf reshim

# Configure tools
RUN corepack enable
RUN rustup target add wasm32-unknown-unknown && rustup target add wasm32-wasi
RUN asdf reshim

# Install starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes && mkdir -p ~/.config && starship preset pastel-powerline > ~/.config/starship.toml && echo 'starship init fish | source' >> ~/.config/fish/config.fish

# Copy static files (settings.json, etc.,)
COPY ./settings.json /root/.local/share/code-server/User/settings.json

# Create workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# Start code-server
EXPOSE 8080
CMD [ "code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none" ]
