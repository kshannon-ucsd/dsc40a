---
layout: none
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Interactive Gradient Descent</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/plotly.js/2.24.1/plotly.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" defer></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    .scenario-selector {
      background: hsl(250, 41%, 95%);
      padding: 1rem 1.5rem;
      border-radius: 8px;
      margin: 1rem 0;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      flex-wrap: wrap;
    }
    .scenario-selector label {
      font-weight: 600;
      margin-right: 0.5rem;
    }
    .scenario-btn {
      background: white;
      border: 2px solid hsl(250, 41%, 35%);
      color: hsl(250, 41%, 35%);
      padding: 6px 12px;
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
    .controls {
      margin-top: 10px;
      background: #f5f5f5;
      padding: 15px 20px;
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
    button:disabled {
      background: #ccc;
      cursor: not-allowed;
    }
    label {
      display: inline-block;
      margin: 0.5rem 0 0.25rem;
      font-weight: 500;
    }
    .slider-span {
      margin-left: 8px;
      font-weight: 600;
    }
    .status-display {
      display: inline-flex;
      gap: 1.5rem;
      margin-left: 20px;
      font-size: 14px;
    }
    .compare-toggle {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      margin-top: 0.5rem;
      padding: 8px 12px;
      background: #e7e3ff;
      border-radius: 4px;
      width: fit-content;
    }
    .legend-item {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      margin-right: 1rem;
      font-size: 13px;
    }
    .legend-dot {
      width: 12px;
      height: 12px;
      border-radius: 50%;
    }
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none;">
    <button style="margin-bottom: 15px;">← Back to Demos</button>
  </a>
  <h1>Interactive Gradient Descent</h1>
  <p>
    Explore how gradient descent navigates loss surfaces. Try the <strong>pre-set scenarios</strong> below
    to see different behaviors: divergence, getting trapped in local minima, escaping saddle points,
    and smooth convergence. Toggle <strong>"Compare: Adam"</strong> to see how adaptive optimizers differ.
  </p>

  <!-- Scenario Selector -->
  <div class="scenario-selector">
    <label>Scenarios:</label>
    <button class="scenario-btn" data-scenario="divergence">Divergence</button>
    <button class="scenario-btn" data-scenario="local-min">Local Min Trap</button>
    <button class="scenario-btn" data-scenario="saddle">Saddle Escape</button>
    <button class="scenario-btn" data-scenario="convergence">Convergence</button>
    <button class="scenario-btn" data-scenario="custom">Custom</button>
  </div>
  <div id="scenario-description" style="background: #f8f9fa; padding: 0.75rem 1rem; border-radius: 4px; margin-bottom: 0.5rem; font-size: 14px; color: #555; display: none;">
    <strong id="scenario-name"></strong>: <span id="scenario-text"></span>
  </div>

  <!-- Controls -->
  <div class="controls">
    <div style="display: flex; gap: 2rem; flex-wrap: wrap; align-items: flex-end;">
      <!-- Start X -->
      <div>
        <label for="startx-slider">Start X:</label><br>
        <input type="range" id="startx-slider" min="-5" max="5" step="0.1" value="3">
        <span id="startx-value" class="slider-span">3.00</span>
      </div>
      <!-- Start Y -->
      <div>
        <label for="starty-slider">Start Y:</label><br>
        <input type="range" id="starty-slider" min="-5" max="5" step="0.1" value="2">
        <span id="starty-value" class="slider-span">2.00</span>
      </div>
      <!-- Learning Rate -->
      <div>
        <label for="lr-slider">Learning Rate:</label><br>
        <input type="range" id="lr-slider" min="-5" max="1.0" step="0.25" value="-1.5">
        <span id="lr-value" class="slider-span">3.2e-2</span>
      </div>
      <!-- Function Selection -->
      <div>
        <label>Function:</label><br>
        <label style="font-weight: normal; margin-right: 1rem;">
          <input type="radio" name="func-select" value="himmelblau"> Himmelblau
        </label>
        <label style="font-weight: normal;">
          <input type="radio" name="func-select" value="sixhump" checked> N-Hump Camel
        </label>
      </div>
    </div>

    <!-- Compare Toggle -->
    <div class="compare-toggle">
      <input type="checkbox" id="compare-check" />
      <label for="compare-check" style="margin: 0; font-weight: 600;">Compare: Adam</label>
      <span id="legend" style="margin-left: 1rem; display: none;">
        <span class="legend-item"><span class="legend-dot" style="background: #e74c3c;"></span> GD</span>
        <span class="legend-item"><span class="legend-dot" style="background: #3498db;"></span> Adam</span>
      </span>
    </div>

    <!-- Buttons + Status -->
    <div style="margin-top: 1rem; display: flex; align-items: center; flex-wrap: wrap;">
      <button id="start-btn">Start</button>
      <button id="pause-btn">Pause</button>
      <button id="step-btn">Step</button>
      <button id="reset-btn">Reset</button>
      <div class="status-display">
        <span id="epoch-display">Epoch: 0</span>
        <span id="loss-display">Loss: --</span>
      </div>
    </div>
  </div>

  <!-- Plots -->
  <div class="plot-container">
    <!-- 3D Surface -->
    <div class="plot-wrapper">
      <h2>3D Surface</h2>
      <div id="surface-plot" style="width:100%; height:400px;"></div>
    </div>
    <!-- 2D Contour -->
    <div class="plot-wrapper">
      <h2>2D Contour</h2>
      <div id="contour-plot" style="width:100%; height:400px;"></div>
    </div>
  </div>
  <!-- Loss Over Time -->
  <div class="plot-wrapper">
    <div style="display: flex; justify-content: space-between; align-items: center;">
      <h2 style="margin: 0;">Loss vs. Epoch</h2>
      <label style="font-size: 14px; font-weight: normal;">
        <input type="checkbox" id="log-scale-check"> Log scale
      </label>
    </div>
    <div id="loss-plot" style="width:100%; height:400px;"></div>
  </div>


<div class="plot-container" markdown="1">
  <div class="plot-wrapper">
    <h3>Adam vs. Plain Gradient Descent</h3>
    
    In <b>plain gradient descent</b>, each update subtracts the gradient scaled by a 
    single learning rate \(\alpha\):

    $$
    \theta_{t+1} \;=\; \theta_t \;-\; \alpha \,\nabla_\theta J(\theta_t)
    $$

    <p>
      <ul>
        <li><strong>\(\theta_t\)</strong>: The parameter vector (e.g., the weights of your model) at iteration \(t\).</li>
        <li><strong>\(\alpha\)</strong>: The learning rate or step size.</li>
        <li><strong>\(\nabla_\theta J(\theta_t)\)</strong>: The gradient of the loss function with respect to the parameters at iteration \(t\). This gradient indicates the direction in which \(J\) increases most rapidly.</li>
        <li><strong>\(J(\theta_t)\)</strong>: The loss (or cost) function evaluated at \(\theta_t\).</li>
      </ul>
    </p>

    <p>
      <b>What does Momentum add?</b><br><br>
      Unlike in plain gradient descent, with Momentum, we introduce 
      a “velocity” \(v_t\) that accumulates past gradients:

      $$
      v_t \;=\; \mu \,v_{t-1} \;+\; \alpha \,\nabla_{\theta}J(\theta_t), 
      \quad
      \theta_{t+1} \;=\; \theta_t \;-\; v_t
      $$

      <ul>
        <li><strong>\(v_t\)</strong> is the current velocity (a rolling average of gradients).</li>
        <li><strong>\(v_{t-1}\)</strong> is the velocity from the previous step.</li>
        <li><strong>\(\mu\)</strong> (often around 0.9) is the momentum factor, controlling how much 
            of the past velocity we retain.</li>
        <li><strong>\(\alpha\)</strong> is now multiplied into the velocity rather than directly into \(\nabla_{\theta} J(\theta_t)\).</li>
      </ul>

      This way, if gradients keep pointing in the same direction, 
      \(v_t\) grows, speeding us along. If they fluctuate, \(v_t\) smooths out the noise 
      by averaging recent steps instead of reacting only to the current gradient.
    </p>

    <p>
      <b>What about RMSProp?</b>
    </p>

    <p>
      It adapts the learning rate by tracking how big or small gradients typically are for 
      each parameter. If gradients are large, RMSProp shrinks the step size; if they are small, 
      it enlarges the step. In simpler terms:

      $$
      \text{Adaptive Step Size} \;\approx\; \frac{1}{\sqrt{\text{rolling average of }(\nabla_{\theta} J(\theta))^2}}
      $$
      
      <p>
        <ul>
          <li><strong>\(\nabla_\theta J(\theta_t)\)</strong>: As above, this is the gradient of the loss function at the current parameters.</li>
          <li><strong>Rolling Average of Squared Gradients</strong>: A moving average that tracks the squared values of the gradients. This average is used to adapt the learning rate for each parameter dynamically.</li>
        </ul>
      </p>

      That means parameters with consistently big gradients slow down, 
      while those with small gradients speed up.
    </p>


    <p>
      <b>Adam (Adaptive Moment Estimation)</b> extends this by tracking two moving averages 
      of the gradients:
      1. A “first moment” (numerator) which acts like momentum—an exponential average of 
         gradients that can help smooth out noise.
      2. A “second moment” comes  from RMSProp (denominator) that tracks the average of squared gradients, 
         adjusting the effective learning rate so steep directions get smaller updates.

      The update roughly looks like:
      $$
      \theta_{t+1}
      \;\approx\;
      \theta_t
      \;-\;
      \frac{\alpha \,\text{(avg gradient)}}{\sqrt{\text{(avg of gradient}^2)} + \epsilon}
      $$

      The numerator tells you which direction to move, the denominator tells you how much, and the learning rate sets the pace.
      Finally, \(\epsilon\) is a small constant (often around \(10^{-8}\)) to avoid dividing by 
      zero and ensure stable updates. Adam automatically tunes step sizes for each 
      parameter dimension. In practice (high dimmensional spaces), this often converges faster and is more tolerant 
      of tricky or noisy gradients.
    </p>
  </div>
</div>



  <script>
    // ==================== SCENARIOS ====================
    const SCENARIOS = {
      divergence: {
        name: "Divergence",
        description: "Watch what happens when the learning rate is too high. The optimizer overshoots, bounces wildly, and loss explodes instead of decreasing.",
        startX: 2.0,
        startY: 2.0,
        lr: 0.5,
        func: "sixhump"
      },
      "local-min": {
        name: "Local Min Trap",
        description: "The optimizer settles into a local minimum that isn't the global best. Once trapped, it can't escape without a larger learning rate or momentum.",
        startX: -3.5,
        startY: 3.0,
        lr: 0.1,
        func: "sixhump"
      },
      saddle: {
        name: "Saddle Escape",
        description: "Starting near a saddle point where gradients are small. Plain GD crawls slowly; Adam's momentum helps escape faster. Toggle 'Compare: Adam' to see the difference.",
        startX: 0.1,
        startY: 0.1,
        lr: 0.05,
        func: "sixhump"
      },
      convergence: {
        name: "Convergence",
        description: "A well-tuned learning rate leads to smooth, steady descent toward a minimum. This is what good optimization looks like.",
        startX: 3.0,
        startY: 3.0,
        lr: 0.1,
        func: "sixhump"
      },
      custom: {
        name: "Custom",
        description: "Experiment with your own starting point and learning rate. Try to find settings that converge, diverge, or get stuck.",
        startX: 3.0,
        startY: 2.0,
        lr: 0.032,
        func: "sixhump"
      }
    };

    let currentScenario = "custom";
    const LOSS_THRESHOLD = 1000; // Auto-stop if loss exceeds this

    // ==================== FUNCTIONS ====================
    function himmelblau(x, y) {
      return Math.pow(x*x + y - 11, 2) + Math.pow(x + y*y - 7, 2);
    }
    function gradHimmelblau(x, y) {
      const dfdx = 2*(x*x + y - 11)*(2*x) + 2*(x + y*y - 7);
      const dfdy = 2*(x*x + y - 11)       + 2*(x + y*y - 7)*(2*y);
      return [dfdx, dfdy];
    }

    function sixHumpCamelModified(x, y) {
      return 0.5 + 0.1 * (x * x + y * y)
             + 0.55 * Math.sin(x) * Math.sin(y)
             + 0.2 * Math.cos(x - 5.0 * y);
    }
    function gradSixHumpCamelModified(x, y) {
      const dfdx = 0.2 * x + 0.55 * Math.cos(x) * Math.sin(y) - 0.2 * Math.sin(x - 5.0 * y);
      const dfdy = 0.2 * y + 0.55 * Math.sin(x) * Math.cos(y) + 1.0 * Math.sin(x - 5.0 * y);
      return [dfdx, dfdy];
    }

    let currentFunction = "sixhump";

    function f(x, y) {
      return currentFunction === "himmelblau" ? himmelblau(x, y) : sixHumpCamelModified(x, y);
    }
    function gradf(x, y) {
      return currentFunction === "himmelblau" ? gradHimmelblau(x, y) : gradSixHumpCamelModified(x, y);
    }

    // ==================== SURFACE GRID ====================
    function generateSurfaceGrid() {
      const steps = 60;
      const xMin = -5, xMax = 5;
      const yMin = -5, yMax = 5;
      const xs = [], ys = [];
      for (let i = 0; i < steps; i++) {
        xs.push(xMin + i*(xMax - xMin)/(steps-1));
        ys.push(yMin + i*(yMax - yMin)/(steps-1));
      }
      const Z = [];
      for (let j = 0; j < ys.length; j++) {
        const row = [];
        for (let i = 0; i < xs.length; i++) {
          row.push(f(xs[i], ys[j]));
        }
        Z.push(row);
      }
      return { x: xs, y: ys, z: Z };
    }

    // ==================== ADAM OPTIMIZER ====================
    class AdamOptimizer {
      constructor(lr = 0.01, beta1 = 0.9, beta2 = 0.999, epsilon = 1e-8) {
        this.lr = lr;
        this.beta1 = beta1;
        this.beta2 = beta2;
        this.epsilon = epsilon;
        this.m_x = 0; this.m_y = 0;
        this.v_x = 0; this.v_y = 0;
        this.t = 0;
      }
      step(x, y, grad) {
        this.t += 1;
        this.m_x = this.beta1 * this.m_x + (1 - this.beta1) * grad[0];
        this.m_y = this.beta1 * this.m_y + (1 - this.beta1) * grad[1];
        this.v_x = this.beta2 * this.v_x + (1 - this.beta2) * (grad[0]*grad[0]);
        this.v_y = this.beta2 * this.v_y + (1 - this.beta2) * (grad[1]*grad[1]);
        const m_hat_x = this.m_x / (1 - Math.pow(this.beta1, this.t));
        const m_hat_y = this.m_y / (1 - Math.pow(this.beta1, this.t));
        const v_hat_x = this.v_x / (1 - Math.pow(this.beta2, this.t));
        const v_hat_y = this.v_y / (1 - Math.pow(this.beta2, this.t));
        return [
          x - this.lr * (m_hat_x / (Math.sqrt(v_hat_x) + this.epsilon)),
          y - this.lr * (m_hat_y / (Math.sqrt(v_hat_y) + this.epsilon))
        ];
      }
    }

    // ==================== GLOBAL STATE ====================
    let surfaceData = generateSurfaceGrid();

    // Starting point (for marker)
    let startX = 3.0, startY = 2.0;

    // GD state
    let gdPathX = [], gdPathY = [], gdPathLoss = [];
    let gdX = 3.0, gdY = 2.0;

    // Adam state (for comparison)
    let adamPathX = [], adamPathY = [], adamPathLoss = [];
    let adamX = 3.0, adamY = 2.0;
    let adamOptimizer = null;

    let epoch = 0;
    let isRunning = false;
    let intervalHandle = null;

    function getLearningRate() {
      const text = document.getElementById("lr-value").textContent;
      return parseFloat(text);
    }

    function isCompareMode() {
      return document.getElementById("compare-check").checked;
    }

    function isLogScale() {
      return document.getElementById("log-scale-check").checked;
    }

    // ==================== PLOTS ====================
    function initPlots() {
      Plotly.newPlot("surface-plot", [{
        x: surfaceData.x, y: surfaceData.y, z: surfaceData.z,
        type: "surface", colorscale: "Viridis"
      }], {
        scene: { xaxis: { title: "x" }, yaxis: { title: "y" }, zaxis: { title: "f(x,y)" } },
        margin: { l: 0, r: 0, b: 0, t: 0 }
      });

      Plotly.newPlot("contour-plot", [{
        x: surfaceData.x, y: surfaceData.y, z: surfaceData.z,
        type: "contour", colorscale: "RdBu", contours: { showlines: false }
      }], {
        xaxis: { title: "x" }, yaxis: { title: "y" }
      });

      Plotly.newPlot("loss-plot", [{
        x: [0], y: [f(gdX, gdY)], mode: "lines+markers", name: "GD", line: { color: "#e74c3c" }
      }], {
        xaxis: { title: "Epoch" }, yaxis: { title: "Loss" }
      });
    }

    function updatePlots() {
      const compare = isCompareMode();
      const gdColor = "#e74c3c";
      const adamColor = "#3498db";
      const startColor = "#27ae60"; // Green for starting point

      // 3D Surface
      const traces3D = [{
        x: surfaceData.x, y: surfaceData.y, z: surfaceData.z,
        type: "surface", colorscale: "Viridis", showscale: false
      }];

      // Starting point marker
      traces3D.push({
        x: [startX], y: [startY], z: [f(startX, startY)],
        mode: "markers", type: "scatter3d",
        marker: { color: startColor, size: 8, symbol: "circle" },
        name: "Start", showlegend: true
      });

      // GD path
      const gdZ = gdPathX.map((xx, i) => f(xx, gdPathY[i]));
      traces3D.push({
        x: gdPathX, y: gdPathY, z: gdZ,
        mode: "lines", type: "scatter3d",
        line: { color: gdColor, width: 4 }, name: "GD"
      });
      traces3D.push({
        x: [gdX], y: [gdY], z: [f(gdX, gdY)],
        mode: "markers", type: "scatter3d",
        marker: { color: gdColor, size: 6 }, name: "GD Current", showlegend: false
      });

      // Adam path (if comparing)
      if (compare) {
        const adamZ = adamPathX.map((xx, i) => f(xx, adamPathY[i]));
        traces3D.push({
          x: adamPathX, y: adamPathY, z: adamZ,
          mode: "lines", type: "scatter3d",
          line: { color: adamColor, width: 4 }, name: "Adam"
        });
        traces3D.push({
          x: [adamX], y: [adamY], z: [f(adamX, adamY)],
          mode: "markers", type: "scatter3d",
          marker: { color: adamColor, size: 6 }, name: "Adam Current", showlegend: false
        });
      }

      Plotly.react("surface-plot", traces3D, {
        scene: { xaxis: { title: "x" }, yaxis: { title: "y" }, zaxis: { title: "f(x,y)" } },
        margin: { l: 0, r: 0, b: 0, t: 0 },
        showlegend: true
      });

      // 2D Contour
      const traces2D = [{
        x: surfaceData.x, y: surfaceData.y, z: surfaceData.z,
        type: "contour", colorscale: "RdBu", contours: { showlines: false }, showscale: false
      }];

      // Starting point marker
      traces2D.push({
        x: [startX], y: [startY], mode: "markers",
        marker: { color: startColor, size: 12, symbol: "circle", line: { color: "white", width: 2 } },
        name: "Start", showlegend: true
      });

      traces2D.push({
        x: gdPathX, y: gdPathY, mode: "lines",
        line: { color: gdColor, width: 2 }, name: "GD"
      });
      traces2D.push({
        x: [gdX], y: [gdY], mode: "markers",
        marker: { color: gdColor, size: 10 }, name: "GD Current", showlegend: false
      });

      if (compare) {
        traces2D.push({
          x: adamPathX, y: adamPathY, mode: "lines",
          line: { color: adamColor, width: 2 }, name: "Adam"
        });
        traces2D.push({
          x: [adamX], y: [adamY], mode: "markers",
          marker: { color: adamColor, size: 10 }, name: "Adam Current", showlegend: false
        });
      }

      Plotly.react("contour-plot", traces2D, {
        xaxis: { title: "x" }, yaxis: { title: "y" },
        showlegend: true
      });

      // Loss plot
      const useLog = isLogScale();
      const lossTraces = [{
        x: Array.from(gdPathLoss.keys()), y: gdPathLoss,
        mode: "lines+markers", name: "GD", line: { color: gdColor }, marker: { color: gdColor }
      }];

      if (compare) {
        lossTraces.push({
          x: Array.from(adamPathLoss.keys()), y: adamPathLoss,
          mode: "lines+markers", name: "Adam", line: { color: adamColor }, marker: { color: adamColor }
        });
      }

      Plotly.react("loss-plot", lossTraces, {
        xaxis: { title: "Epoch" },
        yaxis: { title: "Loss", type: useLog ? "log" : "linear" },
        showlegend: compare
      });
    }

    // ==================== SIMULATION ====================
    function doStep() {
      const lr = getLearningRate();
      const compare = isCompareMode();

      // GD step
      const gradGD = gradf(gdX, gdY);
      gdX = gdX - lr * gradGD[0];
      gdY = gdY - lr * gradGD[1];
      const gdLoss = f(gdX, gdY);
      gdPathX.push(gdX);
      gdPathY.push(gdY);
      gdPathLoss.push(gdLoss);

      // Adam step (if comparing)
      if (compare && adamOptimizer) {
        const gradAdam = gradf(adamX, adamY);
        [adamX, adamY] = adamOptimizer.step(adamX, adamY, gradAdam);
        adamPathX.push(adamX);
        adamPathY.push(adamY);
        adamPathLoss.push(f(adamX, adamY));
      }

      epoch++;
      updatePlots();
      updateStatus();

      // Auto-stop if loss diverges
      if (gdLoss > LOSS_THRESHOLD || !isFinite(gdLoss)) {
        pauseSimulation();
        document.getElementById("loss-display").textContent = `Loss: DIVERGED! (>${LOSS_THRESHOLD})`;
      }
    }

    function updateStatus() {
      const gdLoss = f(gdX, gdY);
      document.getElementById("epoch-display").textContent = `Epoch: ${epoch}`;
      if (isCompareMode()) {
        const adamLoss = f(adamX, adamY);
        document.getElementById("loss-display").textContent =
          `GD: ${gdLoss.toFixed(4)} | Adam: ${adamLoss.toFixed(4)}`;
      } else {
        document.getElementById("loss-display").textContent = `Loss: ${gdLoss.toFixed(4)}`;
      }
    }

    function startSimulation() {
      if (isRunning) return;
      isRunning = true;
      document.getElementById("start-btn").textContent = "Running...";
      document.getElementById("start-btn").disabled = true;
      intervalHandle = setInterval(doStep, 500);
    }

    function pauseSimulation() {
      isRunning = false;
      if (intervalHandle) clearInterval(intervalHandle);
      document.getElementById("start-btn").textContent = "Resume";
      document.getElementById("start-btn").disabled = false;
    }

    function stepSimulation() {
      if (isRunning) pauseSimulation();
      doStep();
    }

    function resetSimulation() {
      pauseSimulation();
      epoch = 0;

      // Store starting point for marker
      startX = parseFloat(document.getElementById("startx-value").textContent);
      startY = parseFloat(document.getElementById("starty-value").textContent);
      const lr = getLearningRate();

      // Reset GD
      gdX = startX;
      gdY = startY;
      gdPathX = [gdX];
      gdPathY = [gdY];
      gdPathLoss = [f(gdX, gdY)];

      // Reset Adam
      adamX = startX;
      adamY = startY;
      adamPathX = [adamX];
      adamPathY = [adamY];
      adamPathLoss = [f(adamX, adamY)];
      adamOptimizer = new AdamOptimizer(lr);

      document.getElementById("start-btn").textContent = "Start";
      document.getElementById("start-btn").disabled = false;
      updatePlots();
      updateStatus();
    }

    // ==================== SCENARIO HANDLING ====================
    function applyScenario(scenarioKey) {
      const scenario = SCENARIOS[scenarioKey];
      if (!scenario) return;

      currentScenario = scenarioKey;

      // Update UI to reflect scenario
      document.getElementById("startx-slider").value = scenario.startX;
      document.getElementById("startx-value").textContent = scenario.startX.toFixed(2);

      document.getElementById("starty-slider").value = scenario.startY;
      document.getElementById("starty-value").textContent = scenario.startY.toFixed(2);

      // Learning rate (convert to log scale for slider)
      const lrLog = Math.log10(scenario.lr);
      document.getElementById("lr-slider").value = lrLog;
      document.getElementById("lr-value").textContent = scenario.lr.toExponential(1);

      // Function
      currentFunction = scenario.func;
      document.querySelector(`input[name="func-select"][value="${scenario.func}"]`).checked = true;
      surfaceData = generateSurfaceGrid();

      // Update active button
      document.querySelectorAll(".scenario-btn").forEach(btn => btn.classList.remove("active"));
      document.querySelector(`.scenario-btn[data-scenario="${scenarioKey}"]`).classList.add("active");

      // Show scenario description
      const descEl = document.getElementById("scenario-description");
      document.getElementById("scenario-name").textContent = scenario.name;
      document.getElementById("scenario-text").textContent = scenario.description;
      descEl.style.display = "block";

      resetSimulation();
    }

    // ==================== DOM READY ====================
    window.addEventListener("DOMContentLoaded", () => {
      initPlots();

      // Scenario buttons
      document.querySelectorAll(".scenario-btn").forEach(btn => {
        btn.addEventListener("click", () => applyScenario(btn.dataset.scenario));
      });

      // Sliders
      const sxSlider = document.getElementById("startx-slider");
      sxSlider.addEventListener("input", () => {
        document.getElementById("startx-value").textContent = parseFloat(sxSlider.value).toFixed(2);
        if (currentScenario !== "custom") {
          currentScenario = "custom";
          document.querySelectorAll(".scenario-btn").forEach(b => b.classList.remove("active"));
          document.querySelector('.scenario-btn[data-scenario="custom"]').classList.add("active");
        }
      });

      const sySlider = document.getElementById("starty-slider");
      sySlider.addEventListener("input", () => {
        document.getElementById("starty-value").textContent = parseFloat(sySlider.value).toFixed(2);
        if (currentScenario !== "custom") {
          currentScenario = "custom";
          document.querySelectorAll(".scenario-btn").forEach(b => b.classList.remove("active"));
          document.querySelector('.scenario-btn[data-scenario="custom"]').classList.add("active");
        }
      });

      const lrSlider = document.getElementById("lr-slider");
      lrSlider.addEventListener("input", () => {
        const val = parseFloat(lrSlider.value);
        const actualLR = Math.pow(10, val);
        document.getElementById("lr-value").textContent = actualLR.toExponential(1);
        if (currentScenario !== "custom") {
          currentScenario = "custom";
          document.querySelectorAll(".scenario-btn").forEach(b => b.classList.remove("active"));
          document.querySelector('.scenario-btn[data-scenario="custom"]').classList.add("active");
        }
      });

      // Function selection
      document.querySelectorAll('input[name="func-select"]').forEach(elem => {
        elem.addEventListener("change", (e) => {
          currentFunction = e.target.value;
          surfaceData = generateSurfaceGrid();
          resetSimulation();
        });
      });

      // Compare toggle
      document.getElementById("compare-check").addEventListener("change", (e) => {
        document.getElementById("legend").style.display = e.target.checked ? "inline" : "none";
        resetSimulation();
      });

      // Log scale toggle
      document.getElementById("log-scale-check").addEventListener("change", () => {
        updatePlots();
      });

      // Control buttons
      document.getElementById("start-btn").addEventListener("click", startSimulation);
      document.getElementById("pause-btn").addEventListener("click", pauseSimulation);
      document.getElementById("step-btn").addEventListener("click", stepSimulation);
      document.getElementById("reset-btn").addEventListener("click", resetSimulation);

      // Initialize with convergence scenario as a good default
      applyScenario("convergence");
    });
  </script>
</body>
</html>