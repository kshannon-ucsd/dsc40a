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
        processEscapes: true
      }
    };
  </script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" defer></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1000px;
      margin: 0 auto;
      padding: 20px;
      line-height: 1.6;
      color: #333;
    }
    h1 { margin-bottom: 0.5rem; }
    h2 {
      margin-top: 3rem;
      padding-top: 2rem;
      border-top: 2px solid #e9ecef;
    }
    .scenario-selector {
      background: hsl(250, 41%, 95%);
      padding: 1rem 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
      display: flex;
      align-items: center;
      gap: 1rem;
      flex-wrap: wrap;
    }
    .scenario-selector label {
      font-weight: 600;
    }
    .scenario-btn {
      background: white;
      border: 2px solid hsl(250, 41%, 35%);
      color: hsl(250, 41%, 35%);
      padding: 8px 16px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      transition: all 0.2s;
    }
    .scenario-btn:hover {
      background: hsl(250, 41%, 90%);
    }
    .scenario-btn.active {
      background: hsl(250, 41%, 35%);
      color: white;
    }
    .back-btn {
      background: hsl(250, 41%, 35%);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }
    .back-btn:hover {
      background: hsl(250, 41%, 45%);
    }
    .plot-container {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      margin: 1.5rem 0;
    }
    .plot-wrapper {
      flex: 1;
      min-width: 300px;
    }
    .callout {
      background: #fff3cd;
      border-left: 4px solid #ffc107;
      padding: 1rem 1.5rem;
      margin: 1.5rem 0;
      border-radius: 0 8px 8px 0;
    }
    .callout.insight {
      background: #d1ecf1;
      border-left-color: #0c5460;
    }
    .callout.question {
      background: #e7e3ff;
      border-left-color: hsl(250, 41%, 35%);
    }
    .math-block {
      background: #f8f9fa;
      padding: 1rem 1.5rem;
      border-radius: 8px;
      margin: 1rem 0;
      overflow-x: auto;
    }
    .encoding-box {
      background: #e9ecef;
      padding: 1rem 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
    }
    .clinical-scenario {
      background: #f8f9fa;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
    }
    .controls {
      background: #f5f5f5;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
    }
    .slider-container {
      margin: 1rem 0;
    }
    .slider-container label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
    }
    .slider-value {
      font-weight: 600;
      margin-left: 0.5rem;
    }
    .generate-btn {
      background: hsl(250, 41%, 35%);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
      margin-top: 1rem;
    }
    .generate-btn:hover {
      background: hsl(250, 41%, 45%);
    }
    .stats-panel {
      background: white;
      padding: 1rem;
      border-radius: 8px;
      margin-top: 1rem;
      border: 1px solid #dee2e6;
    }
    .stats-panel h4 {
      margin: 0 0 0.5rem 0;
      font-size: 0.9rem;
    }
    .stats-panel ul {
      margin: 0;
      padding-left: 1.2rem;
      font-size: 0.9rem;
    }
    .compare-toggle {
      margin-top: 1rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none;">
    <button class="back-btn" style="margin-bottom: 20px;">← Back to Demos</button>
  </a>

  <h1>Understanding Interaction Effects in Clinical Trials</h1>

  <!-- Scenario Selector -->
  <div class="scenario-selector">
    <label>Choose a scenario:</label>
    <button class="scenario-btn active" data-scenario="strong">Strong Interaction</button>
    <button class="scenario-btn" data-scenario="weak">Weak Interaction</button>
    <button class="scenario-btn" data-scenario="none">No Interaction</button>
  </div>

  <!-- Section 1: The Setup -->
  <div class="clinical-scenario">
    <h3>Clinical Trial Scenario: AntiHyp Drug Study</h3>
    <p>
      A clinical trial is studying a new antihypertensive medication (AntiHyp) across different patient groups.
      Researchers want to understand if the drug works differently for male versus female patients.
    </p>
    <p>
      <strong>Variables:</strong>
    </p>
    <ul>
      <li><strong>Treatment</strong>: Drug dosage level (standardized units, ranging from -2 to 2)</li>
      <li><strong>Group</strong>: Patient biological sex</li>
      <li><strong>Response (Y)</strong>: Reduction in blood pressure (mm Hg)</li>
    </ul>
  </div>

  <div class="encoding-box">
    <h3>How We Encode the Categorical Variable</h3>
    <p>
      We code patient group as a number: <strong>Female = -1</strong>, <strong>Male = +1</strong>.
    </p>
    <p>
      This ±1 encoding centers the variable at zero. The benefit: β₀ becomes the overall average response
      (not just the response for one group), and the math for interpreting interactions stays clean.
      You'll see two clusters of points in the plots below—one for each group.
    </p>
  </div>

  <p>Let's look at the raw data. <strong>Do these groups seem to respond differently to treatment?</strong></p>

  <div id="setup-plot" style="width:100%; height:400px;"></div>

  <div class="math-block">
    <p>We want to build a model to predict blood pressure reduction:</p>
    $$Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \text{???}$$
    <p>What should go in place of <strong>???</strong> to capture how treatment effect might differ by group?</p>
  </div>

  <!-- Section 2: No Interaction Model -->
  <h2>First Attempt: Ignoring Interactions</h2>

  <p>Let's start simple and fit a model with just the main effects:</p>

  <div class="math-block">
    $$Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group}$$
  </div>

  <p>
    This model assumes treatment works <em>equally well</em> for both groups.
    The only difference between groups is a vertical shift (β₂ moves one line up or down).
  </p>

  <div class="plot-container">
    <div class="plot-wrapper">
      <h4>Model Fit</h4>
      <div id="no-interaction-fit-plot" style="width:100%; height:350px;"></div>
    </div>
    <div class="plot-wrapper">
      <h4>Residuals</h4>
      <div id="no-interaction-residual-plot" style="width:100%; height:350px;"></div>
    </div>
  </div>

  <div class="callout">
    <strong>Look at the residuals.</strong> If the model fit well, they would scatter randomly around zero.
    Instead, notice how the colors separate—Female residuals trend one direction while Male residuals trend the other.
    The model is <em>systematically wrong</em>. It's missing something.
  </div>

  <!-- Section 3: The Additive Trap -->
  <h2>Second Attempt: Adding an "Interaction" Term</h2>

  <div class="callout question">
    <strong>A colleague suggests:</strong> "We need to account for how Treatment and Group interact.
    Let's add a term that combines them: (Treatment + Group)."
    <br><br>
    <em>What do you think—will this capture the interaction effect?</em>
  </div>

  <div class="math-block">
    $$Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \beta_3(\text{Treatment} + \text{Group})$$
  </div>

  <div class="plot-container">
    <div class="plot-wrapper">
      <h4>Model Fit</h4>
      <div id="additive-fit-plot" style="width:100%; height:350px;"></div>
    </div>
    <div class="plot-wrapper">
      <h4>Residuals</h4>
      <div id="additive-residual-plot" style="width:100%; height:350px;"></div>
    </div>
  </div>

  <p>
    The lines are <strong>still parallel</strong>. The residuals <strong>still show the same pattern</strong>.
    Adding the variables together didn't help. Why?
  </p>

  <div class="math-block">
    <h4>The Problem: Linear Dependence</h4>
    <p>We can rearrange the additive model:</p>
    $$Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \beta_3(\text{Treatment} + \text{Group})$$
    $$= \beta_0 + (\beta_1 + \beta_3)\text{Treatment} + (\beta_2 + \beta_3)\text{Group}$$
    <p>
      The "interaction" term just gets absorbed into the existing coefficients!
      It's mathematically equivalent to the first model—no new information is added.
    </p>
    <p style="font-size: 0.9rem; color: #666;">
      <em>In matrix terms: the column for (Treatment + Group) is a linear combination of existing columns,
      making the design matrix rank-deficient.</em>
    </p>
  </div>

  <!-- Section 4: The Multiplicative Solution -->
  <h2>The Key Insight: Multiplication</h2>

  <p>What if instead of <em>adding</em> Treatment and Group, we <strong>multiply</strong> them?</p>

  <div class="math-block">
    $$Y = \beta_0 + \beta_1 \text{Treatment} + \beta_2 \text{Group} + \beta_3(\text{Treatment} \times \text{Group})$$
  </div>

  <div class="plot-container">
    <div class="plot-wrapper">
      <h4>Model Fit</h4>
      <div id="interactive-fit-plot" style="width:100%; height:350px;"></div>
    </div>
    <div class="plot-wrapper">
      <h4>Residuals</h4>
      <div id="interactive-residual-plot" style="width:100%; height:350px;"></div>
    </div>
  </div>

  <div class="callout insight">
    <strong>Now the lines diverge!</strong> The residuals scatter randomly—no more systematic pattern by group.
    The model finally captures the different treatment effects.
  </div>

  <div class="math-block">
    <h4>Why Multiplication Works</h4>
    <p>The slope of Y with respect to Treatment now <em>depends on the group</em>:</p>
    $$\frac{\partial Y}{\partial \text{Treatment}} = \beta_1 + \beta_3 \cdot \text{Group}$$
    <ul>
      <li>For <strong>Females</strong> (Group = -1): slope = β₁ - β₃</li>
      <li>For <strong>Males</strong> (Group = +1): slope = β₁ + β₃</li>
    </ul>
    <p>
      Multiplication creates a <strong>new piece of information</strong> that cannot be replicated
      by adjusting other coefficients. The product column is linearly independent.
    </p>
  </div>

  <!-- Section 5: Play Zone -->
  <h2>Explore: Build Your Own Interaction</h2>

  <p>
    Now it's your turn. Adjust the sliders to set the <em>true</em> interaction strength and noise level,
    then generate data to see how well the multiplicative model captures it.
  </p>

  <div class="controls">
    <div class="slider-container">
      <label>
        True Interaction Strength (β₃):
        <span id="beta3-value" class="slider-value">2.0</span>
      </label>
      <input type="range" id="beta3-slider" min="-3" max="3" step="0.5" value="2" style="width: 100%;">
    </div>

    <div class="slider-container">
      <label>
        Noise Level (σ):
        <span id="noise-value" class="slider-value">1.5</span>
      </label>
      <input type="range" id="noise-slider" min="0.5" max="3" step="0.25" value="1.5" style="width: 100%;">
    </div>

    <button class="generate-btn" onclick="generatePlaygroundData()">Generate New Data</button>

    <div class="compare-toggle">
      <input type="checkbox" id="compare-toggle">
      <label for="compare-toggle">Show No-Interaction model for comparison</label>
    </div>
  </div>

  <div class="plot-container">
    <div class="plot-wrapper">
      <h4>Model Fit</h4>
      <div id="playground-fit-plot" style="width:100%; height:350px;"></div>
    </div>
    <div class="plot-wrapper">
      <h4>Residuals</h4>
      <div id="playground-residual-plot" style="width:100%; height:350px;"></div>
    </div>
  </div>

  <div class="stats-panel">
    <h4>Model Fit Statistics (Multiplicative Model)</h4>
    <ul>
      <li>R² Score: <span id="r2-value">--</span></li>
      <li>RMSE: <span id="rmse-value">--</span> mm Hg</li>
    </ul>
  </div>

  <script>
    // ==================== PRE-CANNED DATASETS ====================
    // Each scenario has fixed data to ensure consistency across sections

    // Pre-generated datasets computed from: Y = beta0 + beta1*T + beta2*G + beta3*T*G + noise
    // Response values are: true_signal + fixed_noise (so residuals under correct model = just noise)
    const SCENARIOS = {
      strong: {
        // Strong interaction: beta3=2.5 means slopes differ by 5 between groups
        // Female (G=-1): slope = beta1 - beta3 = 3 - 2.5 = 0.5
        // Male (G=1): slope = beta1 + beta3 = 3 + 2.5 = 5.5
        beta0: 10, beta1: 3, beta2: 1, beta3: 2.5,
        female: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 3*t + 1*(-1) + 2.5*t*(-1) = 9 + 0.5*t; then add noise
          noise: [0.3, -0.5, 0.8, -0.2, 1.1, -0.7, 0.4, -0.9, 0.6, -0.3, 0.9, -0.4, 0.2, 0.7, -0.6, 0.5, -0.8, 1.0, -0.5, 0.3, -0.2, 0.8, -0.4, 0.6, -0.7, 0.4, 0.1, -0.3, 0.9, -0.6]
        },
        male: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 3*t + 1*(1) + 2.5*t*(1) = 11 + 5.5*t; then add noise
          noise: [-0.4, 0.6, -0.3, 0.9, -0.5, 0.2, -0.8, 0.5, -0.6, 0.3, -0.2, 0.7, -0.4, 0.8, -0.7, 0.4, -0.3, 0.6, -0.9, 0.2, 0.5, -0.4, 0.7, -0.6, 0.3, -0.5, 0.9, -0.2, 0.4, -0.8]
        }
      },
      weak: {
        // Weak interaction: beta3=0.8 means slopes differ by 1.6 between groups
        // Female (G=-1): slope = 4 - 0.8 = 3.2
        // Male (G=1): slope = 4 + 0.8 = 4.8
        beta0: 10, beta1: 4, beta2: 1.5, beta3: 0.8,
        female: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 4*t + 1.5*(-1) + 0.8*t*(-1) = 8.5 + 3.2*t
          noise: [0.5, -0.8, 0.3, -0.4, 0.9, -0.6, 0.2, -0.5, 0.7, -0.3, 0.6, -0.9, 0.4, -0.2, 0.8, -0.7, 0.3, -0.4, 0.6, -0.5, 0.9, -0.3, 0.5, -0.8, 0.2, -0.6, 0.7, -0.4, 0.3, -0.9]
        },
        male: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 4*t + 1.5*(1) + 0.8*t*(1) = 11.5 + 4.8*t
          noise: [-0.6, 0.4, -0.2, 0.7, -0.5, 0.3, -0.9, 0.6, -0.4, 0.8, -0.3, 0.5, -0.7, 0.2, -0.8, 0.4, -0.5, 0.9, -0.3, 0.6, -0.4, 0.7, -0.6, 0.3, -0.9, 0.5, -0.2, 0.8, -0.7, 0.4]
        }
      },
      none: {
        // No interaction: beta3=0 means both groups have same slope
        // Female (G=-1): slope = 4
        // Male (G=1): slope = 4
        beta0: 10, beta1: 4, beta2: 2, beta3: 0,
        female: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 4*t + 2*(-1) + 0 = 8 + 4*t
          noise: [0.4, -0.6, 0.2, -0.8, 0.5, -0.3, 0.7, -0.4, 0.3, -0.7, 0.6, -0.5, 0.8, -0.2, 0.4, -0.9, 0.3, -0.6, 0.5, -0.4, 0.7, -0.3, 0.9, -0.5, 0.2, -0.8, 0.6, -0.4, 0.3, -0.7]
        },
        male: {
          treatment: [-1.8, -1.5, -1.2, -0.9, -0.6, -0.3, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, -1.6, -1.1, -0.5, 0.1, 0.7, 1.3, 1.7, -1.4, -0.8, -0.2, 0.4, 1.0, 1.6, -1.3, -0.7, 0.2, 0.8],
          // true = 10 + 4*t + 2*(1) + 0 = 12 + 4*t
          noise: [-0.5, 0.3, -0.7, 0.4, -0.2, 0.8, -0.6, 0.5, -0.3, 0.6, -0.8, 0.2, -0.4, 0.7, -0.5, 0.3, -0.9, 0.4, -0.6, 0.8, -0.3, 0.5, -0.7, 0.2, -0.4, 0.6, -0.8, 0.3, -0.5, 0.9]
        }
      }
    };

    let currentScenario = 'strong';
    let playgroundData = null;

    // ==================== UTILITY FUNCTIONS ====================

    function getCurrentData() {
      const scenario = SCENARIOS[currentScenario];
      const { beta0, beta1, beta2, beta3 } = scenario;

      // Compute response from true model: Y = beta0 + beta1*T + beta2*G + beta3*T*G + noise
      const femaleResponse = scenario.female.treatment.map((t, i) =>
        beta0 + beta1 * t + beta2 * (-1) + beta3 * t * (-1) + scenario.female.noise[i]
      );
      const maleResponse = scenario.male.treatment.map((t, i) =>
        beta0 + beta1 * t + beta2 * (1) + beta3 * t * (1) + scenario.male.noise[i]
      );

      return {
        treatment: [...scenario.female.treatment, ...scenario.male.treatment],
        group: [...Array(scenario.female.treatment.length).fill(-1), ...Array(scenario.male.treatment.length).fill(1)],
        response: [...femaleResponse, ...maleResponse],
        params: { beta0, beta1, beta2, beta3 }
      };
    }

    function fitModel(data, modelType) {
      // Simple OLS fit for each model type
      const n = data.treatment.length;
      const params = data.params;

      // For display, we use the true parameters for trend lines
      // and compute residuals based on model type
      let predictions = [];

      if (modelType === 'none') {
        // Y = b0 + b1*treatment + b2*group
        predictions = data.treatment.map((t, i) =>
          params.beta0 + params.beta1 * t + params.beta2 * data.group[i]
        );
      } else if (modelType === 'additive') {
        // Y = b0 + b1*treatment + b2*group + b3*(treatment + group)
        // Equivalent to: b0 + (b1+b3)*treatment + (b2+b3)*group
        predictions = data.treatment.map((t, i) =>
          params.beta0 + params.beta1 * t + params.beta2 * data.group[i]
        );
      } else if (modelType === 'interactive') {
        // Y = b0 + b1*treatment + b2*group + b3*(treatment * group)
        predictions = data.treatment.map((t, i) =>
          params.beta0 + params.beta1 * t + params.beta2 * data.group[i] + params.beta3 * t * data.group[i]
        );
      }

      const residuals = data.response.map((y, i) => y - predictions[i]);

      return { predictions, residuals };
    }

    function calculateStats(data, residuals) {
      const n = data.response.length;
      const mean = data.response.reduce((a, b) => a + b, 0) / n;
      const tss = data.response.reduce((sum, y) => sum + (y - mean) ** 2, 0);
      const rss = residuals.reduce((sum, r) => sum + r ** 2, 0);
      const r2 = 1 - rss / tss;
      const rmse = Math.sqrt(rss / n);
      return { r2, rmse };
    }

    // ==================== PLOTTING FUNCTIONS ====================

    const COLORS = {
      female: '#0066CC',
      male: '#FF8C00'
    };

    function createScatterTrace(data, group, name) {
      const indices = data.group.map((g, i) => g === group ? i : -1).filter(i => i >= 0);
      return {
        x: indices.map(i => data.treatment[i]),
        y: indices.map(i => data.response[i]),
        mode: 'markers',
        name: name,
        marker: { color: group === -1 ? COLORS.female : COLORS.male, size: 8 }
      };
    }

    function createTrendLine(data, group, modelType, name, dash = 'solid') {
      const params = data.params;
      const x = [-2, 2];
      let y;

      if (modelType === 'none' || modelType === 'additive') {
        y = x.map(t => params.beta0 + params.beta1 * t + params.beta2 * group);
      } else {
        y = x.map(t => params.beta0 + params.beta1 * t + params.beta2 * group + params.beta3 * t * group);
      }

      return {
        x: x,
        y: y,
        mode: 'lines',
        name: name,
        line: { color: group === -1 ? COLORS.female : COLORS.male, width: 2, dash: dash }
      };
    }

    function createResidualTrace(data, residuals, group, name) {
      const indices = data.group.map((g, i) => g === group ? i : -1).filter(i => i >= 0);
      return {
        x: indices.map(i => data.treatment[i]),
        y: indices.map(i => residuals[i]),
        mode: 'markers',
        name: name,
        marker: { color: group === -1 ? COLORS.female : COLORS.male, size: 8 }
      };
    }

    const LAYOUT_BASE = {
      margin: { t: 30, r: 30, b: 50, l: 60 },
      showlegend: true,
      legend: { x: 0, y: 1, bgcolor: 'rgba(255,255,255,0.8)' },
      xaxis: { title: 'Treatment Level', range: [-2.2, 2.2] }
    };

    function plotSetup() {
      const data = getCurrentData();
      const traces = [
        createScatterTrace(data, -1, 'Female'),
        createScatterTrace(data, 1, 'Male')
      ];

      Plotly.newPlot('setup-plot', traces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'BP Reduction (mm Hg)' }
      });
    }

    function plotNoInteraction() {
      const data = getCurrentData();
      const fit = fitModel(data, 'none');

      // Fit plot
      const fitTraces = [
        createScatterTrace(data, -1, 'Female'),
        createScatterTrace(data, 1, 'Male'),
        createTrendLine(data, -1, 'none', 'Female fit'),
        createTrendLine(data, 1, 'none', 'Male fit')
      ];

      Plotly.newPlot('no-interaction-fit-plot', fitTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'BP Reduction (mm Hg)' }
      });

      // Residual plot
      const residualTraces = [
        createResidualTrace(data, fit.residuals, -1, 'Female'),
        createResidualTrace(data, fit.residuals, 1, 'Male'),
        { x: [-2, 2], y: [0, 0], mode: 'lines', line: { color: '#999', dash: 'dash' }, showlegend: false }
      ];

      Plotly.newPlot('no-interaction-residual-plot', residualTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'Residual (mm Hg)', zeroline: true }
      });
    }

    function plotAdditive() {
      const data = getCurrentData();
      const fit = fitModel(data, 'additive');

      // Fit plot
      const fitTraces = [
        createScatterTrace(data, -1, 'Female'),
        createScatterTrace(data, 1, 'Male'),
        createTrendLine(data, -1, 'additive', 'Female fit'),
        createTrendLine(data, 1, 'additive', 'Male fit')
      ];

      Plotly.newPlot('additive-fit-plot', fitTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'BP Reduction (mm Hg)' }
      });

      // Residual plot
      const residualTraces = [
        createResidualTrace(data, fit.residuals, -1, 'Female'),
        createResidualTrace(data, fit.residuals, 1, 'Male'),
        { x: [-2, 2], y: [0, 0], mode: 'lines', line: { color: '#999', dash: 'dash' }, showlegend: false }
      ];

      Plotly.newPlot('additive-residual-plot', residualTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'Residual (mm Hg)', zeroline: true }
      });
    }

    function plotInteractive() {
      const data = getCurrentData();
      const fit = fitModel(data, 'interactive');

      // Fit plot
      const fitTraces = [
        createScatterTrace(data, -1, 'Female'),
        createScatterTrace(data, 1, 'Male'),
        createTrendLine(data, -1, 'interactive', 'Female fit'),
        createTrendLine(data, 1, 'interactive', 'Male fit')
      ];

      Plotly.newPlot('interactive-fit-plot', fitTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'BP Reduction (mm Hg)' }
      });

      // Residual plot
      const residualTraces = [
        createResidualTrace(data, fit.residuals, -1, 'Female'),
        createResidualTrace(data, fit.residuals, 1, 'Male'),
        { x: [-2, 2], y: [0, 0], mode: 'lines', line: { color: '#999', dash: 'dash' }, showlegend: false }
      ];

      Plotly.newPlot('interactive-residual-plot', residualTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'Residual (mm Hg)', zeroline: true }
      });
    }

    // ==================== PLAYGROUND ====================

    function normalRandom() {
      let u = 0, v = 0;
      while (u === 0) u = Math.random();
      while (v === 0) v = Math.random();
      return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
    }

    function generatePlaygroundData() {
      const beta3 = parseFloat(document.getElementById('beta3-slider').value);
      const noise = parseFloat(document.getElementById('noise-slider').value);

      const beta0 = 10, beta1 = 4, beta2 = 1.5;

      const treatment = [];
      const group = [];
      const response = [];

      [-1, 1].forEach(g => {
        for (let i = 0; i < 30; i++) {
          const t = -2 + 4 * Math.random();
          const y = beta0 + beta1 * t + beta2 * g + beta3 * t * g + noise * normalRandom();
          treatment.push(t);
          group.push(g);
          response.push(y);
        }
      });

      playgroundData = {
        treatment,
        group,
        response,
        params: { beta0, beta1, beta2, beta3 }
      };

      plotPlayground();
    }

    function plotPlayground() {
      if (!playgroundData) {
        generatePlaygroundData();
        return;
      }

      const data = playgroundData;
      const fit = fitModel(data, 'interactive');
      const stats = calculateStats(data, fit.residuals);
      const showComparison = document.getElementById('compare-toggle').checked;

      // Fit plot
      const fitTraces = [
        createScatterTrace(data, -1, 'Female'),
        createScatterTrace(data, 1, 'Male'),
        createTrendLine(data, -1, 'interactive', 'Female (interaction)'),
        createTrendLine(data, 1, 'interactive', 'Male (interaction)')
      ];

      if (showComparison) {
        fitTraces.push(createTrendLine(data, -1, 'none', 'Female (no interaction)', 'dash'));
        fitTraces.push(createTrendLine(data, 1, 'none', 'Male (no interaction)', 'dash'));
      }

      Plotly.newPlot('playground-fit-plot', fitTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'BP Reduction (mm Hg)' }
      });

      // Residual plot
      const residualTraces = [
        createResidualTrace(data, fit.residuals, -1, 'Female'),
        createResidualTrace(data, fit.residuals, 1, 'Male'),
        { x: [-2, 2], y: [0, 0], mode: 'lines', line: { color: '#999', dash: 'dash' }, showlegend: false }
      ];

      Plotly.newPlot('playground-residual-plot', residualTraces, {
        ...LAYOUT_BASE,
        yaxis: { title: 'Residual (mm Hg)', zeroline: true }
      });

      // Update stats
      document.getElementById('r2-value').textContent = stats.r2.toFixed(3);
      document.getElementById('rmse-value').textContent = stats.rmse.toFixed(2);
    }

    // ==================== EVENT HANDLERS ====================

    function updateAllPlots() {
      plotSetup();
      plotNoInteraction();
      plotAdditive();
      plotInteractive();
    }

    // Scenario selector
    document.querySelectorAll('.scenario-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.scenario-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        currentScenario = btn.dataset.scenario;
        updateAllPlots();
      });
    });

    // Playground sliders (update display only, not data)
    document.getElementById('beta3-slider').addEventListener('input', (e) => {
      document.getElementById('beta3-value').textContent = parseFloat(e.target.value).toFixed(1);
    });

    document.getElementById('noise-slider').addEventListener('input', (e) => {
      document.getElementById('noise-value').textContent = parseFloat(e.target.value).toFixed(2);
    });

    // Comparison toggle
    document.getElementById('compare-toggle').addEventListener('change', plotPlayground);

    // Initialize on load
    window.addEventListener('DOMContentLoaded', () => {
      updateAllPlots();
      generatePlaygroundData();
    });
  </script>
</body>
</html>
