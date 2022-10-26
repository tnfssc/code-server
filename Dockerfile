# My testing-space

FROM ubuntu:jammy

RUN apt update && apt install nala -y
RUN nala update && nala fetch --auto -y
RUN nala install -y \
  build-essential \
  git \
  curl \
  wget \
  python3 \
  python3-pip \
  rustc \
  cargo \
  golang

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN for i in "ms-python.python" "astro-build.astro-vscode" "formulahendry.auto-rename-tag" "jeff-hykin.better-cpp-syntax" "aaron-bond.better-comments" "streetsidesoftware.code-spell-checker" "pranaygp.vscode-css-peek" "Dart-Code.dart-code" "mikestead.dotenv" "janisdd.vscode-edit-csv" "EditorConfig.EditorConfig" "Tobermory.es6-string-html" "dbaeumer.vscode-eslint" "tamasfe.even-better-toml" "cschleiden.vscode-github-actions" "codezombiech.gitignore" "eamodio.gitlens" "golang.Go" "ecmel.vscode-html-css" "wix.vscode-import-cost" "Orta.vscode-jest" "ms-kubernetes-tools.vscode-kubernetes-tools" "redhat.java" "DavidAnson.vscode-markdownlint" "PKief.material-icon-theme" "PKief.material-product-icons" "unifiedjs.vscode-mdx" "mongodb.mongodb-vscode" "Equinusocio.vsc-community-material-theme" "christian-kohler.path-intellisense" "redhat.vscode-xml" "felixfbecker.php-intellisense" "esbenp.prettier-vscode" "Prisma.prisma" "redhat.vscode-commons" "rust-lang.rust" "foxundermoon.shell-format" "Divlo.vscode-styled-jsx-languageserver" "Divlo.vscode-styled-jsx-syntax" "svelte.svelte-vscode" "bradlc.vscode-tailwindcss" "Gruntfuggly.todo-tree" "johnsoncodehk.volar" "ZixuanChen.vitest-explorer" "redhat.vscode-yaml" "stylelint.vscode-stylelint"; do code-server --install-extension $i; done
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes && mkdir -p ~/.config && starship preset pastel-powerline > ~/.config/starship.toml && echo 'eval "$(starship init bash)"' >> ~/.bashrc

COPY ./settings.json /root/.local/share/code-server/User/settings.json
RUN mkdir /workspace
WORKDIR /workspace
EXPOSE 8080
CMD [ "code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none" ]
