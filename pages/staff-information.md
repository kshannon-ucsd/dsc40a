---
layout: default
title: COGS 8 Staff
has_children: false
nav_order: 3
permalink: /staff-info/
---

{% assign variables = site.data[site.data_folder].variables %}
{% assign course_calendar = site.data[site.data_folder].course_calendar %}

# Staff Information

## Current Staff

**Instructor** <br/> {{ variables.instructor.name }} - [{{ variables.instructor.email }}](mailto:{{ variables.instructor.email }})

**Teaching Assistants (TAs)**
{% for ta in variables.teaching_assistants %} <br/> {{ ta.name }} - [{{ ta.email }}](mailto:{{ ta.email }}) {% endfor %}

**Instructional Assistants (IAs)**
{% for ia in variables.instructional_assistants %} <br/> {{ ia.name }} - [{{ ia.email }}](mailto:{{ ia.email }}) {% endfor %}


## Office Hours & Zoom Info

<table style="table-layout: fixed; text-align: center; width: 100%;">
    <thead>
        <tr class="header">
            <th style="width: 25%;"> Staff </th>
            <th style="width: 25%;"> Day & Time </th>
            <th style="width: 25%;"> Location </th>
            <th style="width: 12.5%;"> Link </th>
            <th style="width: 12.5%;"> Pass </th>
        </tr>
    </thead>
    <tbody>
        {% for oh in variables.instructor.office_hours %}
        <tr>
            <td> {{ variables.instructor.name }} </td>
            <td> {{ oh.day }} {{ oh.time }} </td>
            <td> {{ oh.location }} </td>
            <td> <a href='{{ oh.zoom_link }}' target="_blank" rel="noopener">Join &#x2197;</a> </td>
            <td> {% if oh.zoom_pw %} {{ oh.zoom_pw }} {% endif %} </td>
        </tr>
        {% endfor %}
        {% for row in variables.teaching_assistants %}
            {% for oh in row.office_hours %}
            <tr>
                <td> {{ row.name }} </td>
                <td> {{ oh.day }} {{ oh.time }} </td>
                <td> {{ oh.location }} </td>
                <td> <a href='{{ oh.zoom_link }}' target="_blank" rel="noopener">Join &#x2197;</a> </td>
                <td> {% if oh.zoom_pw %} {{ oh.zoom_pw }} {% endif %} </td>
            </tr>
            {% endfor %}
        {% endfor %}
        {% for row in variables.instructional_assistants %}
            {% for oh in row.office_hours %}
            <tr>
                <td> {{ row.name }} </td>
                <td> {{ oh.day }} {{ oh.time }} </td>
                <td> {{ oh.location }} </td>
                <td> <a href='{{ oh.zoom_link }}' target="_blank" rel="noopener">Join &#x2197;</a> </td>
                <td> {% if oh.zoom_pw %} {{ oh.zoom_pw }} {% endif %} </td>
            </tr>
            {% endfor %}
        {% endfor %}
    </tbody>
</table>

<!-- TODO: add this functionality -->

<!-- ## Past Staff

**Instructor** <br/> {{ variables.instructor.name }} - [{{ variables.instructor.email }}](mailto:{{ variables.instructor.email }})

**Teaching Assistants (TAs)**
{% for ta in variables.teaching_assistants %} <br/> {{ ta.name }} - [{{ ta.email }}](mailto:{{ ta.email }}) {% endfor %}

**Instructional Assistants (IAs)**
{% for ia in variables.instructional_assistants %} <br/> {{ ia.name }} - [{{ ia.email }}](mailto:{{ ia.email }}) {% endfor %} -->