---
layout: none
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Understanding Interaction Effects in Clinical Trials</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/plotly.js/2.24.1/plotly.min.js"></script>
  <script>
    window.MathJax = {
      tex: {
        inlineMath: [['\\(', '\\)']],
        displayMath: [['\\[', '\\]'], ['$$', '$$']],
        processEscapes: true,
        macros: {
          boldmath: ['\\boldsymbol{#1}', 1]
        },
        packages: {'[+]': ['ams', 'boldsymbol']}
      },
      loader: {
        load: ['[tex]/ams', '[tex]/boldsymbol']
      }
    };
  </script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" defer></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    .controls {
      margin-top: 20px;
      background: #f5f5f5;
      padding: 20px;
      border-radius: 8px;
    }
    .plot-container {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      margin: 20px 0;
    }
    .plot-wrapper {
      flex: 1;
      min-width: 300px;
      background: white;
      padding: 15px;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .full-width {
      flex: 0 0 100%;
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
      background: #45a049;
    }
    .slider-container {
      margin-bottom: 15px;
    }
    .slider-span {
      margin-left: 8px;
      font-weight: 600;
      transition: color 3s;
    }
    .slider-span.updated {
      color: #FF0000;
      transition: none;
    }
    .math-block {
      margin: 1.5rem 0;
      padding: 1rem;
      background: #f8f9fa;
      border-radius: 4px;
    }
    .model-summary {
      background: #fff;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      display: flex;
      flex-wrap: wrap;
      gap: 2rem;
    }
    .coefficient-table {
      flex: 1;
      min-width: 300px;
      border-collapse: collapse;
      margin: 0;
      font-size: 0.9rem;
    }
    .coefficient-table th, .coefficient-table td {
      padding: 0.5rem;
      text-align: left;
      border-bottom: 1px solid #dee2e6;
    }
    .coefficient-table th {
      background: #f8f9fa;
      font-size: 0.85rem;
    }
    .model-stats {
      flex: 1;
      min-width: 300px;
      font-size: 0.9rem;
    }
    .model-equation {
      flex: 0 0 100%;
      font-size: 0.9rem;
      margin-top: 1rem;
    }
    .explanation {
      margin: 1rem 0;
      line-height: 1.6;
    }
    .clinical-scenario {
      background: #e9ecef;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
    }
    .model-summary {
      background: #fff;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .coefficient-table {
      width: 100%;
      border-collapse: collapse;
      margin: 1rem 0;
    }
    .coefficient-table th, .coefficient-table td {
      padding: 0.5rem;
      text-align: left;
      border-bottom: 1px solid #dee2e6;
    }
    .coefficient-table th {
      background: #f8f9fa;
    }
    .updated-value, .stat-value {
      transition: color 3s;
    }
    .updated-value .stat-value {
      color: #FF0000;
    }
    .coefficient-value {
      transition: color 3s;
    }
    .coefficient-value.updated {
      color: #FF0000;
    }
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
    <button style="margin-bottom: 20px;">← Back to Demos</button>
  </a>
  
  <h1>Understanding Interaction Effects in Clinical Trials</h1>
  
  <div class="clinical-scenario">
    <h2>Clinical Trial Scenario: AntiHyp Drug Study</h2>
    <p>
      Consider a clinical trial studying a new antihypertensive medication (AntiHyp) across different patient groups.
      The trial aims to understand how the drug's effectiveness varies between male and female patients,
      potentially revealing important interaction effects that could inform personalized treatment approaches.
    </p>
    <p>
      Key Variables:
      <ul>
        <li><strong>Treatment (x₁)</strong>: Drug dosage level (standardized units)</li>
        <li><strong>Patient Group (x₂)</strong>: Biological sex (coded as -1 for female, 1 for male)</li>
        <li><strong>Outcome (Y)</strong>: Reduction in blood pressure (mm Hg)</li>
      </ul>
    </p>
  </div>

  <!-- Controls -->
  <div class="controls">
    <h3>Study Parameters</h3>
    <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
      <!-- Sample Size -->
      <div class="slider-container">
        <label for="sample-size-slider">Sample Size (per group):</label><br>
        <input type="range" id="sample-size-slider" min="10" max="100" step="5" value="30">
        <span id="sample-size-value" class="slider-span">30</span>
      </div>
      
      <!-- Effect Sizes -->
      <div class="slider-container">
        <label for="baseline-effect-slider">Baseline Effect (β₁):</label><br>
        <input type="range" id="baseline-effect-slider" min="-10" max="10" step="0.5" value="5">
        <span id="baseline-effect-value" class="slider-span">5.00</span>
      </div>
      
      <div class="slider-container">
        <label for="group-effect-slider">Group Effect (β₂):</label><br>
        <input type="range" id="group-effect-slider" min="-5" max="5" step="0.5" value="2">
        <span id="group-effect-value" class="slider-span">2.00</span>
      </div>
      
      <div class="slider-container">
        <label for="interaction-slider">True Interaction Strength (β₃):</label><br>
        <input type="range" id="interaction-slider" min="-5" max="5" step="0.5" value="0">
        <span id="interaction-value" class="slider-span">0.00</span>
      </div>

      <!-- Noise Level -->
      <div class="slider-container">
        <label for="noise-slider">Noise Level (σ):</label><br>
        <input type="range" id="noise-slider" min="0" max="5" step="0.1" value="1">
        <span id="noise-value" class="slider-span">1.00</span>
      </div>
    </div>

    <!-- Model Type Selection -->
    <div style="margin-top: 1rem;">
      <label>Model Type:</label>
      <label style="margin-right: 1.5rem;">
        <input type="radio" name="model-type" value="no-interaction" checked> No Interactions
      </label>
      <label style="margin-right: 1.5rem;">
        <input type="radio" name="model-type" value="additive"> Additive Effects Model
      </label>
      <label>
        <input type="radio" name="model-type" value="interactive"> Interaction Effects Model
      </label>
    </div>

    <button onclick="regenerateData()" style="margin-top: 1rem;">Generate New Data</button>
  </div>

  <!-- Model Summary -->
  <div class="model-summary">
    <!-- Left Column: Coefficients -->
    <div style="flex: 1; min-width: 300px;">
      <h4 style="font-size: 0.9rem; margin-bottom: 0.5rem;">Model Coefficients</h4>
      <table class="coefficient-table" id="coefficient-table">
        <thead>
          <tr>
            <th>Parameter</th>
            <th>Estimate</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <!-- Will be populated by JavaScript -->
        </tbody>
      </table>
    </div>

    <!-- Right Column: Stats and Equation -->
    <div style="flex: 1; min-width: 300px;">
      <!-- Model Statistics -->
      <div class="model-stats" id="model-stats">
        <!-- Will be populated by JavaScript -->
      </div>

      <!-- Model Equation -->
      <div class="model-equation" id="model-equation">
        <!-- Will be populated by JavaScript -->
      </div>
    </div>
  </div>

  <!-- Plots -->
  <div class="plot-container">
    <!-- Treatment Effect Plot -->
    <div class="plot-wrapper">
      <h2>Treatment Effect by Patient Group</h2>
      <div id="effect-plot" style="width:100%; height:400px;"></div>
    </div>
    <!-- Residual Plot -->
    <div class="plot-wrapper">
      <h2>Individual Responses and Model Fit</h2>
      <div id="residual-plot" style="width:100%; height:400px;"></div>
    </div>
  </div>

  <!-- Clinical Interpretation -->
  <div class="plot-container">
    <div class="plot-wrapper full-width">
      <h2>Clinical Interpretation</h2>
      
      <div style="display: flex; gap: 20px; flex-wrap: wrap;">
        <div class="math-block" style="flex: 1; min-width: 300px;">
          <h3>Key Insights</h3>
          <ul>
            <li><strong>Parallel Lines (No Interaction):</strong> Treatment effectiveness is consistent across groups</li>
            <li><strong>Non-parallel Lines (Interaction Present):</strong> Treatment effectiveness varies by group</li>
            <li><strong>Crossing Lines:</strong> Possible reversal of treatment effect between groups</li>
          </ul>
        </div>

        <div class="math-block" style="flex: 1; min-width: 300px;">
          <h3>Clinical Implications</h3>
          <ul>
            <li>Strong interactions suggest the need for group-specific dosing guidelines</li>
            <li>Weak interactions support uniform treatment protocols</li>
            <li>Negative interactions may indicate contraindications for certain groups</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <!-- Educational Content -->
  <div class="plot-container">
    <!-- Left Column -->
    <div class="plot-wrapper">
      <h2>Understanding Treatment Effects</h2>
      
      <div class="math-block">
        <h3>No Interaction Model</h3>
        $$
        Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group}
        $$
        <p>
          In this model, the treatment effect (β₁) remains constant across patient groups.
          The lines representing different groups remain parallel, indicating that the treatment
          works equally well regardless of patient characteristics.
        </p>
      </div>

      <div class="math-block">
       <h3>Interactive Model</h3>
       $$
        Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \beta_3(\text{Treatment} \times \text{Group})
       $$
       <p>
         Here, the treatment effect varies by group: \(\frac{\partial Y}{\partial \text{Treatment}} = \beta_1 + \beta_3 \text{Group}\).
         Non-parallel lines indicate that the treatment's effectiveness differs between groups,
         suggesting the need for personalized dosing strategies.
       </p>
     </div>

     <div class="math-block">
       <h3>Additive "Interactive" Model</h3>
       $$
       Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \beta_3(\text{Treatment} + \text{Group})
       $$
       <p>
         This model demonstrates why simply adding terms linearly cannot capture true interaction effects.
         The treatment effect remains constant: \(\frac{\partial Y}{\partial \text{Treatment}} = \beta_1 + \beta_3\),
         independent of the patient group. The lines remain parallel because adding terms linearly
         only shifts the intercept and slope uniformly across groups, unlike true interactions
         which allow for group-specific treatment effects.
       </p>
     </div>
    </div>

    <!-- Right Column -->
    <div class="plot-wrapper">
      <h2>Linear Algebra Perspective</h2>
      
      <div class="math-block">
        <h3>Matrix Form of the Models</h3>
        
        <p>Let's examine how these models look in matrix form for \(n\) observations, where \(x_1\) represents Treatment and \(x_2\) represents Group:</p>
        
        <h4>1. No Interaction Model</h4>
        \[
        \begin{pmatrix} y_1 \\ y_2 \\ \vdots \\ y_n \end{pmatrix} =
        \begin{pmatrix}
        1 & x_{1,1} & x_{2,1} \\
        1 & x_{1,2} & x_{2,2} \\
        \vdots & \vdots & \vdots \\
        1 & x_{1,n} & x_{2,n}
        \end{pmatrix}
        \begin{pmatrix} \beta_0 \\ \beta_1 \\ \beta_2 \end{pmatrix}
        \]
        
        <h4>2. Multiplicative Interaction</h4>
        \[
        \begin{pmatrix} y_1 \\ y_2 \\ \vdots \\ y_n \end{pmatrix} =
        \begin{pmatrix}
        1 & x_{1,1} & x_{2,1} & x_{1,1}x_{2,1} \\
        1 & x_{1,2} & x_{2,2} & x_{1,2}x_{2,2} \\
        \vdots & \vdots & \vdots & \vdots \\
        1 & x_{1,n} & x_{2,n} & x_{1,n}x_{2,n}
        \end{pmatrix}
        \begin{pmatrix} \beta_0 \\ \beta_1 \\ \beta_2 \\ \beta_3 \end{pmatrix}
        \]
        
        <h4>3. Additive "Interaction"</h4>
        \[
        \begin{pmatrix} y_1 \\ y_2 \\ \vdots \\ y_n \end{pmatrix} =
        \begin{pmatrix}
        1 & x_{1,1} & x_{2,1} & (x_{1,1}+x_{2,1}) \\
        1 & x_{1,2} & x_{2,2} & (x_{1,2}+x_{2,2}) \\
        \vdots & \vdots & \vdots & \vdots \\
        1 & x_{1,n} & x_{2,n} & (x_{1,n}+x_{2,n})
        \end{pmatrix}
        \begin{pmatrix} \beta_0 \\ \beta_1 \\ \beta_2 \\ \beta_3 \end{pmatrix}
        \]
      </div>

      <div class="math-block">
        <h3>Design Matrix Properties</h3>
        
        <p>The design matrix \(\mathbf{X}\) in each model reveals important properties:</p>

        <h4>Normal Equations</h4>
        <p>The optimal coefficients \(\boldsymbol{\beta}\) are found by solving:</p>
        \[
        (\mathbf{X}^\top\mathbf{X})\boldsymbol{\beta} = \mathbf{X}^\top\mathbf{y}
        \]
        
        <h4>Linear Independence Analysis</h4>
        <p>For the additive "interaction" model:</p>
        <ul>
          <li>The fourth column is a linear combination of columns 2 and 3:
            \[\mathbf{x}_4 = \mathbf{x}_2 + \mathbf{x}_3\]
          </li>
          <li>This makes \(\mathbf{X}^T\mathbf{X}\) singular (determinant = 0)</li>
          <li>The model is not identifiable: multiple \(\boldsymbol{\beta}\) values give the same predictions</li>
          <li>This explains why the additive "interaction" maintains parallel lines: it's mathematically equivalent to adjusting \(\beta_1\) and \(\beta_2\)</li>
        </ul>
        
        <p>In contrast, for the multiplicative interaction model:</p>
        <ul>
          <li>The interaction term \(\mathbf{x}_1 * \mathbf{x}_2\) creates a linearly independent column</li>
          <li>\(\mathbf{X}^T\mathbf{X}\) is invertible (assuming sufficient variation in the data)</li>
          <li>A unique solution exists for \(\boldsymbol{\beta}\)</li>
          <li>This allows for truly different slopes between groups</li>
        </ul>
      </div>
    </div>
  </div>

  <script>
    // Utility Functions
    function normalRandom() {
      let u = 0, v = 0;
      while(u === 0) u = Math.random();
      while(v === 0) v = Math.random();
      return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
    }

    function generateData() {
      const sampleSize = parseInt(document.getElementById('sample-size-slider').value);
      const beta1 = parseFloat(document.getElementById('baseline-effect-slider').value);
      const beta2 = parseFloat(document.getElementById('group-effect-slider').value);
      const beta3 = parseFloat(document.getElementById('interaction-slider').value);
      const noise = parseFloat(document.getElementById('noise-slider').value);
      const modelType = document.querySelector('input[name="model-type"]:checked').value;

      const data = {
        treatment: [],
        group: [],
        response: []
      };

      // Generate data for each group
      [-1, 1].forEach(group => {
        for (let i = 0; i < sampleSize; i++) {
          const treatment = -2 + 4 * Math.random(); // Treatment from -2 to 2
          let response = 10 + beta1 * treatment + beta2 * group;
          
          if (modelType === 'interactive') {
            response += beta3 * treatment * group;
          } else if (modelType === 'additive') {
            response += beta3 * (treatment + group);
          }
          
          response += noise * normalRandom();
          
          data.treatment.push(treatment);
          data.group.push(group);
          data.response.push(response);
        }
      });

      return data;
    }

    function updatePlots() {
      const data = generateData();
      
      // Effect Plot
      const femaleData = {
        x: [],
        y: [],
        mode: 'markers',
        name: 'Female Patients',
        marker: {
          color: '#0066CC',
          symbol: 'circle',
          size: 6
        }
      };
      
      const maleData = {
        x: [],
        y: [],
        mode: 'markers',
        name: 'Male Patients',
        marker: {
          color: '#FF8C00',
          symbol: 'circle',
          size: 6
        }
      };

      for (let i = 0; i < data.treatment.length; i++) {
        if (data.group[i] === -1) {
          femaleData.x.push(data.treatment[i]);
          femaleData.y.push(data.response[i]);
        } else {
          maleData.x.push(data.treatment[i]);
          maleData.y.push(data.response[i]);
        }
      }

      // Add trend lines
      const beta1 = parseFloat(document.getElementById('baseline-effect-slider').value);
      const beta2 = parseFloat(document.getElementById('group-effect-slider').value);
      const beta3 = parseFloat(document.getElementById('interaction-slider').value);
      const modelType = document.querySelector('input[name="model-type"]:checked').value;

      const x = [-2, 2];
      const femaleLine = {
        x: x,
        y: x.map(x => 10 + beta1 * x + beta2 * (-1) +
          (modelType === 'interactive' ? beta3 * x * (-1) :
           modelType === 'additive' ? beta3 * (x + (-1)) : 0)),
        mode: 'lines',
        name: 'Female Trend',
        line: { dash: 'dot', color: '#0066CC' }
      };

      const maleLine = {
        x: x,
        y: x.map(x => 10 + beta1 * x + beta2 * 1 +
          (modelType === 'interactive' ? beta3 * x * 1 :
           modelType === 'additive' ? beta3 * (x + 1) : 0)),
        mode: 'lines',
        name: 'Male Trend',
        line: { dash: 'dot', color: '#FF8C00' }
      };

      Plotly.newPlot('effect-plot', [femaleData, maleData, femaleLine, maleLine], {
        title: 'Treatment Effect by Patient Group',
        xaxis: { title: 'Treatment Level' },
        yaxis: { title: 'Blood Pressure Reduction (mm Hg)' }
      });

      // Residual Plot
      const residuals = data.response.map((y, i) => {
        const x = data.treatment[i];
        const group = data.group[i];
        const predicted = 10 + beta1 * x + beta2 * group +
          (modelType === 'interactive' ? beta3 * x * group :
           modelType === 'additive' ? beta3 * (x + group) : 0);
        return y - predicted;
      });

      const residualTrace = {
        x: data.treatment,
        y: residuals,
        mode: 'markers',
        marker: {
          color: data.group.map(g => g === -1 ? '#0066CC' : '#FF8C00'),
          size: 8, //g => g === -1 ? 8 : 12,
          symbol: 'circle' //g => g === -1 ? 'circle' : 'star'
        },
        type: 'scatter'
      };

      Plotly.newPlot('residual-plot', [residualTrace], {
        title: 'Residuals vs Treatment Level',
        xaxis: { title: 'Treatment Level' },
        yaxis: { title: 'Residual (mm Hg)' }
      });

      // Update model summary
      updateModelSummary();
    }

    function updateModelSummary() {
      const beta0 = 10;
      const beta1 = parseFloat(document.getElementById('baseline-effect-slider').value);
      const beta2 = parseFloat(document.getElementById('group-effect-slider').value);
      const beta3 = parseFloat(document.getElementById('interaction-slider').value);
      const modelType = document.querySelector('input[name="model-type"]:checked').value;

      // Update coefficient table
      const coefficientTable = document.getElementById('coefficient-table').getElementsByTagName('tbody')[0];
      
      // Store previous values to check for changes
      const oldValues = Array.from(coefficientTable.getElementsByClassName('coefficient-value'))
        .map(el => el.textContent);
      
      coefficientTable.innerHTML = `
        <tr>
          <td>β₀ (Intercept)</td>
          <td class="coefficient-value">${beta0.toFixed(2)}</td>
          <td>Baseline blood pressure reduction</td>
        </tr>
        <tr>
          <td>β₁ (Treatment)</td>
          <td class="coefficient-value">${beta1.toFixed(2)}</td>
          <td>Main effect of treatment</td>
        </tr>
        <tr>
          <td>β₂ (Group)</td>
          <td class="coefficient-value">${beta2.toFixed(2)}</td>
          <td>Main effect of patient group</td>
        </tr>
        ${(modelType === 'interactive' || modelType === 'additive') ? `
        <tr>
          <td>β₃ (${modelType === 'interactive' ? 'Interaction' : 'Additive Term'})</td>
          <td class="coefficient-value">${beta3.toFixed(2)}</td>
          <td>${modelType === 'interactive' ? 'Treatment × Group interaction' : 'Treatment + Group linear combination'}</td>
        </tr>
        ` : ''}
      `;

      // Add animation to changed coefficient values
      const newValues = Array.from(coefficientTable.getElementsByClassName('coefficient-value'));
      newValues.forEach((el, i) => {
        if (!oldValues[i] || el.textContent !== oldValues[i]) {
          el.classList.add('updated');
          setTimeout(() => {
            el.classList.remove('updated');
          }, 3000);
        }
      });

      // Update model equation
      const modelEquation = document.getElementById('model-equation');
      modelEquation.innerHTML = `
        $$
        \\hat{Y} = ${beta0.toFixed(1)} ${beta1 >= 0 ? '+' : ''} ${beta1.toFixed(1)}\\text{(Treatment)} 
        ${beta2 >= 0 ? '+' : ''} ${beta2.toFixed(1)}\\text{(Group)}
        ${modelType === 'interactive' ? `${beta3 >= 0 ? '+' : ''} ${beta3.toFixed(1)}\\text{(Treatment × Group)}` :
          modelType === 'additive' ? `${beta3 >= 0 ? '+' : ''} ${beta3.toFixed(1)}\\text{(Treatment + Group)}` : ''}
        $$
      `;

      // Trigger MathJax to process new equations
      if (window.MathJax) {
        MathJax.typesetPromise && MathJax.typesetPromise();
      }

      // Calculate and update model statistics
      const data = generateData();
      const stats = calculateModelStats(data);
      updateModelStats(stats);
    }

    function calculateModelStats(data) {
      const n = data.treatment.length;
      const beta1 = parseFloat(document.getElementById('baseline-effect-slider').value);
      const beta2 = parseFloat(document.getElementById('group-effect-slider').value);
      const beta3 = parseFloat(document.getElementById('interaction-slider').value);
      const modelType = document.querySelector('input[name="model-type"]:checked').value;

      let predicted = data.treatment.map((x, i) => 
        10 + beta1 * x + beta2 * data.group[i] +
        (modelType === 'interactive' ? beta3 * x * data.group[i] :
         modelType === 'additive' ? beta3 * (x + data.group[i]) : 0)
      );

      let residuals = data.response.map((y, i) => y - predicted[i]);
      let rss = residuals.reduce((sum, r) => sum + r * r, 0);
      let tss = data.response.map(y => y - data.response.reduce((a, b) => a + b) / n)
                            .reduce((sum, d) => sum + d * d, 0);
      let r2 = 1 - (rss / tss);

      return {
        r2: r2,
        rmse: Math.sqrt(rss / n),
        n: n
      };
    }

    function updateModelStats(stats) {
      const modelType = document.querySelector('input[name="model-type"]:checked').value;
      const statsDiv = document.getElementById('model-stats');
      
      // Add animation class to stats
      statsDiv.classList.add('updated-value');
      setTimeout(() => {
        statsDiv.classList.remove('updated-value');
      }, 3000);

      statsDiv.innerHTML = `
       <h4>Model Fit Statistics</h4>
       <ul>
         <li>Model Type: ${
           modelType === 'interactive' ? 'Interactive Effects' :
           modelType === 'additive' ? 'Additive Model' :
           'No Interaction'
         }</li>
         <li class="stat-value">R² Score: ${stats.r2.toFixed(3)}</li>
         <li class="stat-value">RMSE: ${stats.rmse.toFixed(2)} mm Hg</li>
         <li>Sample Size: ${stats.n} patients</li>
       </ul>
      `;
    }

    function regenerateData() {
      updatePlots();
    }

    // Initialize everything when DOM is ready
    window.addEventListener('DOMContentLoaded', () => {
      // Initialize plots and model summary
      updatePlots();

      // Set up slider event listeners
      ['sample-size', 'baseline-effect', 'group-effect', 'interaction', 'noise'].forEach(param => {
        const slider = document.getElementById(`${param}-slider`);
        const value = document.getElementById(`${param}-value`);
        
        slider.addEventListener('input', () => {
          // Update value with animation
          const newValue = parseFloat(slider.value).toFixed(2);
          value.style.color = '#FF0000';
          value.textContent = newValue;
          
          // Reset color after delay
          setTimeout(() => {
            value.style.transition = 'color 3s';
            value.style.color = '#000000';
            // Remove transition after it completes to prepare for next change
            setTimeout(() => {
              value.style.transition = 'none';
            }, 3000);
          }, 50);
          
          updatePlots();
        });
      });

      // Set up model type radio buttons
      document.querySelectorAll('input[name="model-type"]').forEach(radio => {
        radio.addEventListener('change', updatePlots);
      });
    });
  </script>
</body>
</html>