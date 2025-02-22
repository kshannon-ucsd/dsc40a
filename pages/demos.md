---
layout: page
title: 💃 Demos
description: Landing page for in-class demo days.
nav_order: 4
---

# 💃 Demos

{% assign demo_vars = site.data[site.data_folder].demos %}

{% for demo in demo_vars %}
<div class="demos-section">
  {% include demo-display.html demo=demo %}
</div>
{% endfor %}


<!-- 
## 1. [Linear Regression]({{ site.baseurl }}/demos/1_linear_regression)
This is a simple demo showing how loss and the function you are trying to learn with linear regression work together.
Recently rebuilt in javascript... but I first built this in python within a jupyter notebook. You can download my notebook [here](https://ucsd.s3.us-west-2.amazonaws.com/dsc40a/demos/demo_01.ipynb) to dive deeepr.

## 2. [Loss Surface Navigation]({{ site.baseurl }}/demos/2_loss_surfaces)
This demo shows how gradient descent moves through various loss surfaces in 3d and 2d contour maps. It also let's you compare adam to plain gradient descent!

## 3. [Interaction Terms - WIP]({{ site.baseurl }}#)
This demo shows how gradient descent moves through various loss surfaces in 3d and 2d contour maps. It also let's you compare adam to plain gradient descent!

## 4. [Kmeans Clustering Demo]({{ site.baseurl }}/demos/4_kmeans_clustering)
Check out how Kmeans Clustering works!


<!-- https://ucsd.s3.us-west-2.amazonaws.com/dsc40a/demos/demo_02.ipynb -->
<!-- https://ucsd.s3.us-west-2.amazonaws.com/dsc40a/demos/demo_03.ipynb -->
<!-- https://ucsd.s3.us-west-2.amazonaws.com/dsc40a/demos/demo_04.ipynb -->