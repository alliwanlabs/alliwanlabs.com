---
layout: page
title: "All Recipes"
permalink: /recipes/
---

# Recipes

Each recipe names a specific kind of work, gives the procedure, shows the data from real applications, and is explicit about where and how it fails. Read [the introduction](/) first if you haven't.

| # | Recipe | Pattern | Substrate |
|---|--------|---------|-----------|
{% assign sorted = site.recipes | sort: "recipe" %}
{% for r in sorted %}| {{ r.recipe }} | [{{ r.title }}]({{ r.url }}) | **{{ r.pattern }}** | {{ r.substrate }} |
{% endfor %}
