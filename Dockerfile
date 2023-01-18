FROM ubuntu:jammy

RUN apt update
RUN apt install --quiet --yes software-properties-common nala
RUN add-apt-repository --yes ppa:fish-shell/release-3
RUN nala update && nala fetch --auto -y
RUN nala install -y \
  openssh-client \
  build-essential \
  git \
  curl \
  wget \
  python3 \
  python3-pip \
  golang \
  fish \
  unzip

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
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
  --install-extension mongodb.mongodb-vscode \
  --install-extension Equinusocio.vsc-community-material-theme \
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
  --install-extension ZixuanChen.vitest-explorer \
  --install-extension redhat.vscode-yaml \
  --install-extension stylelint.vscode-stylelint \
  --install-extension ms-azuretools.vscode-docker \
  --install-extension denoland.vscode-deno \
  --install-extension redwan-hossain.skillavid-pure-black

RUN chsh -s /usr/bin/fish
ENV SHELL /usr/bin/fish
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

RUN /usr/bin/fish --command "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
RUN /usr/bin/fish --command "fisher install jorgebucaran/nvm.fish"
RUN /usr/bin/fish --command "nvm install 18"
RUN /usr/bin/fish --command 'echo "set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths" >> ~/.config/fish/config.fish'
RUN /usr/bin/fish --command "curl -fsSL https://starship.rs/install.sh | sh -s -- --yes && mkdir -p ~/.config && starship preset pastel-powerline > ~/.config/starship.toml && echo 'starship init fish | source' >> ~/.config/fish/config.fish"

COPY ./settings.json /root/.local/share/code-server/User/settings.json
RUN mkdir /workspace
WORKDIR /workspace
EXPOSE 8080
CMD [ "code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none" ]
