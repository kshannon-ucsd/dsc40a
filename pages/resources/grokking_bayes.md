---
layout: none
title: Grokking Bayes'
has_children: false
parent: 📚 Resources
nav_order: 1
permalink: /resources/grokking-bayes
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Grokking Bayes' Theorem</title>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" defer></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      background-color: #f5f5f5;
      color: #333;
      line-height: 1.6;
    }
    h1 {
      color: #2c3e50;
      text-align: center;
      margin-bottom: 30px;
    }
    h2 {
      color: hsl(250, 41%, 35%);
      margin-top: 30px;
      border-bottom: 1px solid #eee;
      padding-bottom: 5px;
    }
    .visualization {
      margin: 30px 0;
      text-align: center;
    }
    .visualization svg {
      max-width: 100%;
      height: auto;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      background-color: black;
      border-radius: 8px;
    }
    .question {
      font-weight: bold;
      background-color: #f0f7fc;
      padding: 15px;
      border-left: 4px solid hsl(250, 41%, 35%);
      margin: 20px 0;
      border-radius: 4px;
    }
    details {
      margin-bottom: 20px;
    }
    summary {
      font-weight: bold;
      cursor: pointer;
      padding: 10px;
      background-color: #f0f7fc;
      border-left: 4px solid hsl(250, 41%, 35%);
      border-radius: 4px;
    }
    details[open] summary {
      margin-bottom: 10px;
    }
    details[open] {
      padding: 10px;
      background-color: #eafaf1;
      border-left: 4px solid #2ecc71;
      border-radius: 4px;
    }
    button {
      background: hsl(250, 41%, 35%);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
      margin-right: 10px;
    }
    button:hover {
      background: hsl(250, 41%, 45%);
    }
    blockquote {
      background-color: #f9f9f9;
      border-left: 4px solid #ddd;
      margin: 20px 0;
      padding: 10px 20px;
    }
    .formula {
      text-align: center;
      padding: 15px;
      background-color: #f9f9f9;
      border-radius: 4px;
      margin: 20px 0;
    }
    .plot-wrapper {
      background: white;
      padding: 15px;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      margin: 20px 0;
    }
  </style>
</head>
<body>
  <a href="/index.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
    <button style="margin-bottom: 20px;">← Back to Home</button>
  </a>

  <h1>Grokking Bayes' Theorem</h1>

  <p>This guide walks through a practical example that illustrates Bayes' theorem using a college major scenario. Let's explore how our intuition can sometimes lead us astray and how Bayes' theorem helps us reason correctly about probabilities.</p>

  <h2>The Problem Statement</h2>

  <p>Consider the following description of a person named Ahmed:</p>

  <blockquote>
    <p>Ahmed is outgoing and confident.</p>
  </blockquote>

  <div class="question">
    <p><strong>Question 1:</strong> Based solely on this description, which seems more likely?</p>
    <ul>
      <li>Ahmed is a communications major</li>
      <li>Ahmed is a STEM major</li>
    </ul>
    <p>Take a moment to think about your intuitive answer before proceeding.</p>
  </div>

  <h2>Examining Our Intuition</h2>

  <p>Many people intuitively choose "communications major" because the description seems to match stereotypical traits we associate with students in communications programs. This is using what psychologists call the <strong>representativeness heuristic</strong> - judging probability by how well something matches our mental prototype.</p>

  <div class="question">
    <p><strong>Question 2:</strong> What critical information are we missing when we make this judgment if we were to disregard his description?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>We're missing the base rates - how common communications majors and STEM majors are in the college population. This is crucial information for making an accurate probability assessment.</p>
  </details>

  <h2>Adding Base Rates</h2>

  <p>In many colleges and universities, STEM majors significantly outnumber communications majors:</p>
  <ul>
    <li>Approximately 15% of students are communications majors</li>
    <li>Approximately 85% of students are STEM majors</li>
  </ul>

  <p>This means STEM majors are roughly 5-6 times more common than communications majors in the overall student population.</p>

  <div class="question">
    <p><strong>Question 3:</strong> How should this information affect our probability estimate?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>This drastically changes the calculation. Even if the description matches communications majors better, we need to account for the fact that we're much more likely to randomly select a STEM major than a communications major from the student population.</p>
  </details>

  <h2>Visualizing the Problem</h2>

  <p>Let's represent our student population as a grid where:</p>
  <ul>
    <li>Communications majors are represented in orange (a smaller portion on the left)</li>
    <li>STEM majors are represented in blue (the much larger remaining portion)</li>
  </ul>

  <div class="visualization">
    <!-- First Visualization: Population Distribution -->
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 1000" width="800" height="1000">
      <!-- Background -->
      <rect width="800" height="1000" fill="black" />
      
      <!-- Title -->
      <text x="400" y="40" font-family="Arial" font-size="24" fill="white" text-anchor="middle">The Communications vs. STEM Major Problem</text>
      
      <!-- First Visualization: Population Distribution -->
      <text x="400" y="80" font-family="Arial" font-size="18" fill="white" text-anchor="middle">Base Rates in College Population</text>
      
      <rect x="100" y="110" width="600" height="240" fill="#111" stroke="#333" stroke-width="1" />
      
      <!-- Communications section (smaller slice) -->
      <rect x="100" y="110" width="120" height="240" fill="#E67E22" />
      <text x="160" y="100" font-family="Arial" font-size="14" fill="white" text-anchor="middle">30</text>
      <text x="160" y="230" font-family="Arial" font-size="14" fill="white" text-anchor="middle" transform="rotate(-90, 160, 230)">Communications (15%)</text>
      
      <!-- STEM section (larger portion) -->
      <rect x="220" y="110" width="480" height="240" fill="#3498DB" />
      <text x="460" y="100" font-family="Arial" font-size="14" fill="white" text-anchor="middle">170</text>
      <text x="460" y="230" font-family="Arial" font-size="14" fill="white" text-anchor="middle" transform="rotate(-90, 460, 230)">STEM (85%)</text>
      
      <!-- People icons (simplified representation) -->
      <g opacity="0.7">
        <!-- Communications -->
        <text x="120" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="140" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="160" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="180" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="200" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        
        <!-- A few sample STEM students (would be many more in reality) -->
        <text x="240" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="270" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="300" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="330" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <text x="360" y="150" font-family="Arial" font-size="12" fill="white" text-anchor="middle">👤</text>
        <!-- More STEM students would be displayed across the grid -->
      </g>
      
      <!-- Second Visualization: Matching the Description -->
      <text x="400" y="390" font-family="Arial" font-size="18" fill="white" text-anchor="middle">Students Matching "Outgoing and Confident" Description</text>
    
      <rect x="100" y="420" width="600" height="240" fill="#111" stroke="#333" stroke-width="1" />
      
      <!-- Communications section with highlighting -->
      <rect x="100" y="420" width="120" height="240" fill="#E67E22" opacity="0.4" />
      <!-- 70% of communications majors match -->
      <rect x="100" y="420" width="120" height="168" fill="#F39C12" />
      <text x="175" y="505" font-family="Arial" font-size="14" fill="white" text-anchor="end">70%</text>

      <!-- STEM section with highlighting -->
      <rect x="220" y="420" width="480" height="240" fill="#3498DB" opacity="0.4" />
      <!-- 30% of STEM majors match -->
      <rect x="220" y="420" width="480" height="72" fill="#2980B9" />
      <text x="460" y="460" font-family="Arial" font-size="14" fill="white" text-anchor="middle">30%</text>
      <line x1="460" y1="410" x2="460" y2="420" stroke="white" stroke-width="1" />
      
      <!-- Annotation for number of people matching -->
      <text x="160" y="410" font-family="Arial" font-size="14" fill="white" text-anchor="middle">21</text>
      <text x="460" y="410" font-family="Arial" font-size="14" fill="white" text-anchor="middle">51</text>
            
      <!-- Third Visualization: Bayes Calculation -->
      <rect x="150" y="700" width="500" height="80" fill="#222" stroke="#444" stroke-width="2" />
      <text x="400" y="745" font-family="Arial" font-size="20" fill="white" text-anchor="middle">
        P(<tspan fill="#F39C12">Comm</tspan> given <tspan fill="#66CCCC">description</tspan>) = 
        <tspan fill="#F39C12">21</tspan> / (<tspan fill="#F39C12">21</tspan> + <tspan fill="#2980B9">51</tspan>) ≈ 29.2%
      </text>
      
      <!-- Final simplified grid showing the subset of people who match the description -->
      <text x="400" y="820" font-family="Arial" font-size="18" fill="white" text-anchor="middle">Students Who Match the Description</text>
      
      <rect x="230" y="850" width="340" height="80" fill="#111" stroke="#333" stroke-width="1" />
      
      <!-- Communications majors who match -->
      <rect x="230" y="850" width="100" height="80" fill="#F39C12" />
      <text x="280" y="890" font-family="Arial" font-size="18" fill="black" text-anchor="middle">21</text>
      
      <!-- STEM majors who match -->
      <rect x="330" y="850" width="240" height="80" fill="#2980B9" />
      <text x="450" y="890" font-family="Arial" font-size="18" fill="black" text-anchor="middle">51</text>
      
      <!-- Caption explaining the key insight -->
      <text x="400" y="960" font-family="Arial" font-size="16" fill="white" text-anchor="middle">
        Even though a higher percentage of Communications majors match the description (70% vs 30%),
      </text>
      <text x="400" y="980" font-family="Arial" font-size="16" fill="white" text-anchor="middle">
        there are still more STEM majors who match because STEM majors are much more common.
      </text>
    </svg>
  </div>

  <div class="question">
    <p><strong>Question 4:</strong> If we were to randomly select a student from this population, what is the probability they would be a communications major?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>About 15%. In our simplified visualization, we're showing 30 communications majors out of a total of 200 students (30 communications + 170 STEM).</p>
  </details>

  <h2>Accounting for the Description</h2>

  <p>Now let's consider how well the description matches each major:</p>
  <ul>
    <li>Suppose about 70% of communications majors are outgoing and confident (21 out of our 30 communications majors)</li>
    <li>Suppose only about 30% of STEM majors are outgoing and confident (51 out of our 170 STEM majors)</li>
  </ul>

  <p>We can visualize this by highlighting the portion of each group that matches the description, as shown in the middle section of our visualization.</p>

  <div class="question">
    <p><strong>Question 5:</strong> Even though a higher percentage of communications majors match the description, why might there still be more STEM majors who match it?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>Because STEM majors greatly outnumber communications majors in the total population. In this case, even though only 30% of STEM majors match the description compared to 70% of communications majors, the absolute number is still larger: 51 STEM majors vs. 21 communications majors.</p>
  </details>

  <h2>Calculating with Bayes' Theorem</h2>

  <p>Let's use the numbers from our visualization:</p>
  <ul>
    <li>We have 30 communications majors in our population</li>
    <li>We have 170 STEM majors</li>
    <li>70% of communications majors (21 people) match the description</li>
    <li>30% of STEM majors (51 people) match the description</li>
  </ul>

  <div class="question">
    <p><strong>Question 6:</strong> Among students matching the description, how many are communications majors and how many are STEM majors?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>21 communications majors and 51 STEM majors match the description.</p>
  </details>

  <div class="question">
    <p><strong>Question 7:</strong> What is the probability that someone matching the description is a communications major?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>$$P(\text{Comm} | \text{Description}) = \frac{21}{21 + 51} = \frac{21}{72} \approx 29.2\%$$</p>
    <p>Even though the description matches communications majors at a higher rate, the probability is still only about 29% that Ahmed is a communications major.</p>
  </details>

  <p>As shown in the visualization, even though the description is more representative of communications majors, there are still many more STEM majors who match it simply because STEM majors are so much more common.</p>

  <h2>Formalizing with Bayes' Theorem</h2>

  <p>Bayes' theorem provides the mathematical framework for this kind of reasoning:</p>

  <div class="formula">
    <p>$$P(A|B) = \frac{P(B|A) \times P(A)}{P(B)}$$</p>
  </div>

  <p>Where:</p>
  <ul>
    <li>$$P(A|B)$$ is the probability of A given B has occurred (posterior)</li>
    <li>$$P(B|A)$$ is the probability of B given A (likelihood)</li>
    <li>$$P(A)$$ is the probability of A (prior)</li>
    <li>$$P(B)$$ is the probability of B (evidence)</li>
  </ul>

  <p>For our problem:</p>
  <div class="formula">
    <p>$$P(\text{Comm} | \text{Description}) = \frac{P(\text{Description} | \text{Comm}) \times P(\text{Comm})}{P(\text{Description})}$$</p>
    <p>$$P(\text{Comm} | \text{Description}) = \frac{0.7 \times 0.15}{(0.7 \times 0.15) + (0.3 \times 0.85)} = \frac{0.105}{0.36} \approx 29.2\%$$</p>
  </div>

  <div class="question">
    <p><strong>Question 8:</strong> If the description matched 90% of communications majors but still only 30% of STEM majors, how would that change our result?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>$$P(\text{Comm} | \text{Description}) = \frac{0.9 \times 0.15}{(0.9 \times 0.15) + (0.3 \times 0.85)} = \frac{0.135}{0.39} \approx 34.6\%$$</p>
    <p>The probability increases, but it's still more likely that Ahmed is a STEM major.</p>
  </details>

  <h2>The Heart of Bayes' Theorem</h2>

  <p>The fundamental insight of Bayesian reasoning is that we need to consider both:</p>
  <ol>
    <li>How likely each hypothesis is to begin with (prior probabilities)</li>
    <li>How well the evidence fits each hypothesis (likelihoods)</li>
  </ol>

  <div class="visualization">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="800" height="500">
      <!-- Background -->
      <rect width="800" height="500" fill="black" />
      
      <!-- Title -->
      <text x="400" y="40" font-family="Arial" font-size="24" fill="white" text-anchor="middle">The Heart of Bayes' Theorem</text>
      
      <!-- First panel: All possibilities -->
      <g transform="translate(50, 100)">
        <text x="100" y="-20" font-family="Arial" font-size="18" fill="white" text-anchor="middle">All possibilities</text>
        
        <!-- Rectangle representing all possibilities -->
        <rect x="0" y="0" width="200" height="250" fill="#333" stroke="#555" stroke-width="2" />
        
        <!-- Communications section -->
        <rect x="0" y="0" width="30" height="250" fill="#F39C12" />
        
        <!-- STEM section -->
        <rect x="30" y="0" width="170" height="250" fill="#2980B9" />
        
        <!-- Icons at bottom -->
        <text x="15" y="280" font-family="Arial" font-size="20" fill="#F39C12" text-anchor="middle">🎤</text>
        <text x="115" y="280" font-family="Arial" font-size="20" fill="#2980B9" text-anchor="middle">🔬</text>
      </g>
      
      <!-- Second panel: All possibilities fitting the evidence -->
      <g transform="translate(300, 100)">
        <text x="100" y="-30" font-family="Arial" font-size="18" fill="white" text-anchor="middle">All possibilities</text>
        <text x="100" y="-10" font-family="Arial" font-size="18" fill="#66CCCC" text-anchor="middle">fitting the description</text>
        
        <!-- Rectangle representing space of possibilities -->
        <rect x="0" y="0" width="200" height="250" fill="#333" stroke="#555" stroke-width="2" />
        
        <!-- Communications section - partially highlighted -->
        <rect x="0" y="0" width="30" height="250" fill="#111" />
        <rect x="0" y="0" width="30" height="175" fill="#F39C12" />
        
        <!-- STEM section - partially highlighted -->
        <rect x="30" y="0" width="170" height="250" fill="#111" />
        <rect x="30" y="0" width="170" height="75" fill="#2980B9" />
        
        <!-- Icons at bottom -->
        <text x="15" y="280" font-family="Arial" font-size="20" fill="#F39C12" text-anchor="middle">🎤</text>
        <text x="115" y="280" font-family="Arial" font-size="20" fill="#2980B9" text-anchor="middle">🔬</text>
      </g>
      
      <!-- Third panel: The probability formula -->
      <g transform="translate(550, 100)">
        <text x="90" y="-30" font-family="Arial" font-size="18" fill="white" text-anchor="middle">P</text>
        <text x="99" y="-30" font-family="Arial" font-size="18" fill="#F39C12" text-anchor="middle">(</text>
        <text x="129" y="-30" font-family="Arial" font-size="18" fill="#F39C12" text-anchor="middle">Comm</text>
        <text x="180" y="-30" font-family="Arial" font-size="18" fill="white" text-anchor="middle">given</text>
        <text x="145" y="-10" font-family="Arial" font-size="18" fill="#66CCCC" text-anchor="middle">description</text>
        <text x="192" y="-10" font-family="Arial" font-size="18" fill="#F39C12" text-anchor="middle">)</text>
        
        <!-- Dashed box to represent the calculation -->
        <rect x="0" y="0" width="200" height="250" fill="none" stroke="#FFF" stroke-width="2" stroke-dasharray="5,5" />
        
        <!-- Numerator - Communications majors who match -->
        <rect x="50" y="50" width="100" height="30" fill="#F39C12" />
        
        <!-- Dividing line -->
        <line x1="30" y1="130" x2="170" y2="130" stroke="white" stroke-width="2" />
        
        <!-- Denominator parts -->
        <rect x="30" y="160" width="40" height="30" fill="#F39C12" />
        <text x="75" y="175" font-family="Arial" font-size="20" fill="white" text-anchor="middle">+</text>
        <rect x="90" y="160" width="80" height="30" fill="#2980B9" />
      </g>
      
      <!-- Explanation text at bottom -->
      <text x="400" y="400" font-family="Arial" font-size="20" fill="white" text-anchor="middle">
        If this line of reasoning, where seeing new evidence restricts the space of possibilities, makes
      </text>
      <text x="400" y="430" font-family="Arial" font-size="20" fill="white" text-anchor="middle">
        sense to you, then congratulations! You understand the heart of Bayes' theorem.
      </text>
    </svg>
  </div>

  <p>As shown in the visualization:</p>
  <ul>
    <li>The left panel shows all possibilities with their original distribution</li>
    <li>The middle panel shows how the evidence restricts the space of possibilities</li>
    <li>The right panel shows how we calculate the final probability within that restricted space</li>
  </ul>

  <div class="question">
    <p><strong>Question 9:</strong> Why is it incorrect to only consider how well the description matches each major?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>Because we'd be ignoring the base rates - how common each major is in the student population. This leads to the base rate fallacy, where we overemphasize the matching characteristics and undervalue the prior probabilities.</p>
  </details>

  <h2>Real-World Applications</h2>

  <p>Bayes' theorem is crucial in many real-world scenarios:</p>

  <div class="question">
    <p><strong>Question 10:</strong> How might this type of reasoning be relevant when interpreting personality test results?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>When a personality test suggests someone has traits often associated with a certain profession or personality type, we should consider not just how well the traits match the stereotype, but also how common that profession or personality type is in the general population.</p>
  </details>

  <div class="question">
    <p><strong>Question 11:</strong> How could Bayesian reasoning help with making predictions about student success in different programs?</p>
  </div>

  <details>
    <summary>Click for answer</summary>
    <p>When trying to predict which program a student might succeed in based on their traits, we should consider both how well their traits match successful students in each program AND how many students succeed in each program overall. A program with higher overall success rates might be a better bet even if another program seems to match their traits slightly better.</p>
  </details>

  <h2>Conclusion</h2>

  <p>The communications/STEM major example highlights a common error in probabilistic reasoning - ignoring base rates. Bayes' theorem provides a formal framework for combining prior knowledge with new evidence to reach more accurate conclusions.</p>

  <p>Remember:</p>
  <ul>
    <li>Intuition often focuses on how well evidence matches our hypotheses</li>
    <li>Proper Bayesian reasoning requires also considering how common each hypothesis is to begin with</li>
    <li>When base rates are extreme, they can outweigh even strong evidence to the contrary</li>
  </ul>

  <div class="question">
    <p><strong>Final Question:</strong> Can you think of a situation in your own life where you might have fallen prey to the base rate fallacy? How could you apply Bayesian reasoning to avoid this error in the future?</p>
  </div>

  <script>
    // Make all summary elements function as toggles for their parent details
    document.addEventListener('DOMContentLoaded', function() {
      const details = document.querySelectorAll('details');
      details.forEach(detail => {
        const summary = detail.querySelector('summary');
        summary.addEventListener('click', function(e) {
          e.preventDefault();
          detail.open = !detail.open;
        });
      });
    });
  </script>
  <h5>Acknowledgment:</h5>
<div>Images are inspired by 3Blue 1Brown</div>
</body>
</html>