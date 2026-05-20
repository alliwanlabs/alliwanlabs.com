# alliwanlabs.com

Source for the Al Liwan Labs website. Published target: [alliwanlabs.com](https://alliwanlabs.com).

## What's here

- `index.md` — landing page (the introduction essay)
- `_recipes/` — recipe collection, one file per recipe
- `_config.yml` — Jekyll site config
- `Gemfile` — Ruby/Jekyll dependencies
- `CNAME` — apex domain mapping for GitHub Pages

## Local development

```sh
bundle install
bundle exec jekyll serve
```

Then open <http://localhost:4000>.

## Source of truth

This is the **publish-ready** version of the content. The working substrate (with vault references, WikiLinks, task IDs, internal paths) lives in `~/Documents/Claude/Projects/Recipe_Library/`. Edits to recipe content should be made there first, then propagated here with internal references stripped.

## Status

Private repository. Not yet published. Initial structure 2026-05-20.
