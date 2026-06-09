# Voxlang Website

This repository hosts the static website and install scripts for the [Voxlang](https://github.com/sufiytv-dev/Voxlang) programming language.

## Contents

- `index.html` – Landing page with download card and feature highlights
- `docs.html` – Documentation page that fetches Markdown files from the main Voxlang repo
- `changelog.html` – Changelog page that renders `CHANGELOG.md` from the main repo
- `install.ps1` – Windows PowerShell installation script
- `install.sh` – Linux/macOS installation script

## How It Works

- The website is served via **GitHub Pages** (branch `main`, root directory).
- Documentation and changelog content are loaded dynamically from the [main Voxlang repository](https://github.com/sufiytv-dev/Voxlang) using raw GitHub URLs.
- Install scripts download the latest prebuilt binary from the [Releases page](https://github.com/sufiytv-dev/Voxlang/releases) and add it to the user's `PATH`.

## Local Development

You can test the site locally by opening any `.html` file in a browser. No build step required.

## Deployment

Push changes to the `main` branch. GitHub Pages will automatically update the live site at `https://sufiytv-dev.github.io/Voxlang-website` (or your custom domain if configured).

## License

Same as Voxlang – MIT/Apache 2.0.
