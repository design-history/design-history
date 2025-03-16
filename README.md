# Design history

A service that helps you build a design history.

## 🚧 Under active construction 🚧

This project isn't ready to see yet; we're building it in the open. Don't
expect much.

## Setup

Set up your environment keys:

```bash
cp .env.example .env
vim .env     # Fill in missing API keys
```

Standard Rails 7 / Ruby 3 project. Example:

```bash
asdf install # Install optimal ruby/nodejs/etc versions, see .tool-versions
pg_ctl start # If not already running postgres

bin/setup    # bundle / yarn / database setup

bin/dev      # Local development on http://localhost:3000
bin/lint     # Run linters
bin/test     # Run tests
```

### Testing subdomains locally

You'll need to append these entries to your `/etc/hosts`:

```bash
127.0.0.1	app.local
127.0.0.1	this.app.local
```

or

```bash
127.0.0.1	[sub domain of local design history].app.local
```

### Intellisense

[solargraph](https://github.com/castwide/solargraph) is bundled as part of the
development dependencies. You need to [set it up for your
editor](https://github.com/castwide/solargraph#using-solargraph), and then run
this command to index your local bundle (re-run if/when we install new
dependencies and you want completion):

```sh
bin/bundle exec yard gems
```

You'll also need to configure your editor's `solargraph` plugin to
`useBundler`:

```diff
+  "solargraph.useBundler": true,
```

### Licence

[AGPLv3](LICENSE).
