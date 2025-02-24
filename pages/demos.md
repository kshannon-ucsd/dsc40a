---
layout: page
title: 💃 Demos
description: Landing page for in-class demo days.
nav_order: 4
---

# 💃 Demos

{% assign demo_vars = site.data.demos %}

{% for demo in demo_vars %}
<div class="demos-section">
  {% include demo-display.html demo=demo %}
</div>
{% endfor %}
