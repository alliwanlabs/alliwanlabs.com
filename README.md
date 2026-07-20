# alliwanlabs.com

Source for the Al Liwan Labs corporate website. The live site is published at
[alliwanlabs.com](https://alliwanlabs.com).

Al Liwan Labs is a wholly owned entity of Al Liwan Group in Abu Dhabi. This
repository holds the public information site. That covers the landing page, the
announcement, and the about, mission, terms, and privacy pages.

## How the site is built and published

The site is a [Jekyll](https://jekyllrb.com) site served through
[GitHub Pages](https://docs.github.com/pages).

- GitHub Pages builds directly from the `main` branch at the repository root.
- Every push to `main` triggers a new build and deploy. There is no separate
  deploy step to run.
- The `CNAME` file maps the custom domain `alliwanlabs.com`. GitHub Pages serves
  the site over HTTPS.
- The build uses the plugins listed in `_config.yml`: `jekyll-feed`,
  `jekyll-seo-tag`, and `jekyll-sitemap`.

The `Gemfile` pins the versions used for local preview. GitHub Pages runs its own
supported build environment, so the `Gemfile` is for the local workflow described
below.

## Run it locally

You need Ruby and Bundler installed.

1. Install the dependencies:

   ```sh
   bundle install
   ```

2. Start the local server:

   ```sh
   bundle exec jekyll serve
   ```

3. Open <http://localhost:4000> in a browser.

Jekyll rebuilds the site when you save a file, so a browser refresh shows your
edits.

## Repository layout

| Path | Purpose |
|------|---------|
| `index.html` | Landing page. Standalone HTML with an animated background and links to the announcement and newsletter. |
| `about.md`, `announcement.md`, `mission.md`, `terms.md`, `privacy.md` | Corporate content pages. Each uses the `labs-page` layout. |
| `_layouts/labs-page.html` | Layout for the corporate content pages. Renders the top bar, page title, body, and footer. |
| `_config.yml` | Jekyll configuration: site title, description, theme, plugins, and the `recipes` collection. |
| `_includes/header.html` | Shared header include. |
| `styles.css` | Global stylesheet. It imports the design tokens from `tokens/`. |
| `tokens/` | CSS design tokens: colors, typography, spacing, elevation, and fonts. |
| `assets/` | Logo and image files, including the social card. |
| `CNAME` | Custom domain for GitHub Pages. |
| `Gemfile` | Ruby dependencies for the local preview. |
| `recipes.md`, `_recipes/` | The `recipes` Jekyll collection, rendered under `/recipes/`. |
| `robots.txt`, `llms.txt` | Crawler and language-model guidance files. |

## Edit or add a page

The corporate pages are Markdown files with a YAML front matter block at the top.
To edit one, change its Markdown body and keep the front matter intact.

To add a new corporate page, create a Markdown file with a front matter block.
The front matter sets the layout, title, description, and URL path. For example:

```yaml
---
layout: labs-page
title: Page Title
description: One-sentence summary for search engines and social cards.
permalink: /page-url/
---
```

Write the page body in Markdown below the front matter. Link to it from the top
bar and footer in `_layouts/labs-page.html` if it should appear in navigation.

The landing page is `index.html` rather than Markdown, because it carries its own
layout and the animated background. Edit that file directly to change the landing
page.

## Publishing a change

1. Commit your change to a branch and open a pull request.
2. Merge the pull request into `main`.
3. GitHub Pages builds `main` and deploys it to
   [alliwanlabs.com](https://alliwanlabs.com) within a few minutes.
