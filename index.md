---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: 🏠 Home
layout: home
nav_exclude: false
nav_order: 1
---

{% assign course_vars = site.data[site.data_folder].course %}
{% assign staff_vars = site.data[site.data_folder].staff %}
{% assign calendar = site.data[site.data_folder].calendar %}
<!-- Fall quarter starts in Week 0 while the other quarters start in Week 1 -->
{% assign offset_week = 1 %}
{% if site.data_folder contains "fa" %}
    {% assign offset_week = 0 %}
{% endif %}

# {{ site.tagline }}

{: .mb-2 }
{{ site.description }} <span title="https://jarv.is/" class="wave">👋</span>
{: .fs-6 .fw-300 }


<div class="staffer">
  {% if staff_vars[0].photo %}
  <img class="staffer-image" src="{{ staff_vars[0].photo | relative_url }}" alt="">
  {% endif %}
  <div>
    <h3 class="staffer-name">
      {% if staff_vars[0].website %}
      <a href="{{ staff_vars[0].website }}">{{ staff_vars[0].name }}</a>
      {% else %}
      {{ staff_vars[0].name }}
      {% endif %}
      {% if staff_vars[0].pronouns %}
      <div class="staffer-pronouns"><b>{{ staff_vars[0].pronouns }}</b></div>
      {% endif %}
    </h3>
    <p>
    {% if staff_vars[0].email %}
    <a href="mailto:{{ staff_vars[0].email }}">{{ staff_vars[0].email }}</a>
    {% endif %}
    {% if staff_vars[0].type %}
    • {{ staff_vars[0].type }}
    {% endif %}
    {% if staff_vars[0].lecture %}
    <p><b>Lecture(s)</b>: {{ staff_vars[0].lecture }}</p>
    {% endif %}
    </p>
  </div>
</div>

{{ course_vars.quarter }}
{: .md-badge-purple }

{{ course_vars.building }}
{: .md-badge-purple }

{{ course_vars.timings }}
{: .md-badge-purple }

{{ "{: ." + course_vars.announcement.color + " }" }}
**{{ course_vars.announcement.text }}**

{% for week in calendar %}
    <div class="module">
    <h3 class="module-header" id="{{ week.title | slugify }}">{{ week.title }}</h3>
    <dl class="module-days">
        {% for day in week %}
        <dt class="module-day main">{{ day.date | date: '%a %b %e' }}</dt>
        {% for event in day.events %}
            {% if event.markdown_content %}
            <dd class="module-event{% if forloop.first %} main{% endif %}">
                {{ event.markdown_content | markdownify }}
            </dd>
            {% else %}
            <dd class="module-event{% if forloop.first %} main{% endif %}">
                <p>
                <strong class="label label-{{ event.type }}">
                    {{ event.name }}
                </strong>
                {% if event.url %}
                    <a href="{{ event.url }}">{{ event.title }}</a>
                {% else %}
                    {{ event.title }}
                {% endif %}
                {%- if event.type == "lecture" -%}
                    {%- if event.blank -%}
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <small><a href="{{ event.blank }}"><button type="button" class="btn btn-info">🌗 blank</button></a></small>
                    {%- endif -%}
                    {%- if event.filled -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.filled }}"><button type="button" class="btn btn-info">📝 filled</button></a></small>
                    {%- endif -%}
                    {%- if event.code -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.code }}"><button type="button" class="btn btn-info">💻 code</button></a></small>
                    {%- endif -%}
                    {%- if event.animations -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.animations }}"><button type="button" class="btn btn-info">🧮 animations</button></a></small>
                    {%- endif -%}
                    {%- if event.podcast -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.podcast }}"><button type="button" class="btn btn-info">🎥 podcast</button></a></small>
                    {%- endif -%}
                    {%- if event.faqs -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.faqs }}"><button type="button" class="btn btn-info">🙋 FAQs</button></a></small>
                    {%- endif -%}
                {%- endif -%}
                {%- if event.type == "hw" or event.type == "disc" -%}
                    {%- if event.problems -%}
                    <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <small><a href="{{ event.problems }}"><button type="button" class="btn btn-info">📄 problems</button></a></small>
                    {%- endif -%}
                    {%- if event.template -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.template }}"><button type="button" class="btn btn-info">🍃 template</button></a></small>
                    {%- endif -%}
                    {%- if event.walkthrough -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.walkthrough }}"><button type="button" class="btn btn-info">🎥 walkthrough</button></a></small>
                    {%- endif -%}
                    {%- if event.solutions -%}
                    <small>&nbsp;&nbsp;<a href="{{ event.solutions }}"><button type="button" class="btn btn-info">📝 solutions</button></a></small>
                    {%- endif -%}
                {%- endif -%}
                </p>
                <p>
                <!-- 
                {%- if event.filled and event.podcast -%}
                    <span> | </span>
                {%- endif -%} -->
                <!-- {%- if event.podcast and event.reading -%}
                    <span> | </span>
                {%- endif -%} -->
                <!-- {%- if event.reading -%}
                    {{ event.reading | markdownify | remove: '<p>' | remove: '</p>' }}
                {%- endif -%} -->
                </p>
                <!-- {{ event | first | markdownify }} {{ event | last | markdownify }} -->
            </dd>
            {% endif %}
        {% endfor %}
        {% endfor %}
    </dl>
    {% assign content_strip = content | strip %}
    {% if content_strip != "" %}
    <div class="module-body">
        <small>{{ content }}</small>
    </div>
    </div>
{% endfor %}
