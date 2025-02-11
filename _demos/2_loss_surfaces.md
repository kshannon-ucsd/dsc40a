---
layout: none
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Himmelblau Interactive (GD + Adam)</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/plotly.js/2.24.1/plotly.min.js"></script>
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
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
    <button style="margin-bottom: 20px;">← Back to Demos</button>
  </a>
  <h1>Interactive Gradient Descent</h1>
  <p>
    Himmelblau’s function has multiple local minima—see how different <strong>start points</strong>,
    <strong>learning rates</strong>, or <strong>Adam</strong> can lead you to different local or global minima
    (or get "semi-stuck" near a saddle). If you have trouble with Himmelblau's (because it is very simple and has only 4 global minima, 
    with no local, but a nice saddle point), I have created a more complex (n-hump camel)
    loss surface with multiple local minima where you can see how these gradient descent traverses a more complex loss surfaces. 
  </p>

  <!-- Controls -->
  <div class="controls">
    <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
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
      <!-- Adam Toggle -->
      <div style="margin-top: 1.5rem;">
        <input type="checkbox" id="adam-check" />
        <label for="adam-check">Use Adam</label>
      </div>
    </div>
    <!-- Function Selection Radio Buttons -->
    <div style="margin-top: 1rem;">
      <label>Select Function:</label>
      <label style="margin-right: 1.0rem;"><input type="radio" name="func-select" value="himmelblau" checked> Himmelblau</label>
      <label><input type="radio" name="func-select" value="sixhump"> Modified N-Hump Camel</label>
    </div>
    <!-- Buttons + Status -->
    <div style="margin-top: 1rem;">
      <button id="start-btn">Start</button>
      <button id="stop-btn">Stop</button>
      <button id="reset-btn">Reset</button>
      <span id="epoch-display" style="margin-left: 20px;">Epoch: 0</span>
      <span id="loss-display" style="margin-left: 20px;">Loss: --</span>
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
    <h2>Loss vs. Epoch</h2>
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
    // 1) Himmelblau's Function & Gradient
    // https://www.sfu.ca/~ssurjano/index.html for the math and r code
    // https://www.sfu.ca/~ssurjano/optimization.html
    function himmelblau(x, y) {
      // f(x,y) = (x^2 + y - 11)^2 + (x + y^2 - 7)^2
      return Math.pow(x*x + y - 11, 2) + Math.pow(x + y*y - 7, 2);
    }
    function gradHimmelblau(x, y) {
      // partial derivs...
      const dfdx = 2*(x*x + y - 11)*(2*x) + 2*(x + y*y - 7);
      const dfdy = 2*(x*x + y - 11)       + 2*(x + y*y - 7)*(2*y);
      return [dfdx, dfdy];
    }

    function sixHumpCamelModified(x, y) {
      return 0.5 + 0.1 * (x * x + y * y) //0.5 to ensure no non negative loss
             + 0.55 * Math.sin(x) * Math.sin(y)
             + 0.2 * Math.cos(x - 5.0 * y);
    }
    function gradSixHumpCamelModified(x, y) {
      // For f(x,y) = 0.1*(x²+y²) + 0.55*sin(x)*sin(y) + 0.2*cos(x-5y):
      // ∂/∂x: 0.2*x + 0.55*cos(x)*sin(y) - 0.2*sin(x-5y)
      // ∂/∂y: 0.2*y + 0.55*sin(x)*cos(y) + 1.0*sin(x-5y)    (since d/dy cos(x-5y) = 5*sin(x-5y))
      const dfdx = 0.2 * x + 0.55 * Math.cos(x) * Math.sin(y) - 0.2 * Math.sin(x - 5.0 * y);
      const dfdy = 0.2 * y + 0.55 * Math.sin(x) * Math.cos(y) + 1.0 * Math.sin(x - 5.0 * y);
      return [dfdx, dfdy];
    }

    // Global function selector and wrappers
    let currentFunction = "himmelblau"; // default function

    function f(x, y) {
      if (currentFunction === "himmelblau") {
        return himmelblau(x, y);
      } else if (currentFunction === "sixhump") {
        return sixHumpCamelModified(x, y);
      }
    }

    function gradf(x, y) {
      if (currentFunction === "himmelblau") {
        return gradHimmelblau(x, y);
      } else if (currentFunction === "sixhump") {
        return gradSixHumpCamelModified(x, y);
      }
    }

    // 2) Generate a grid for [-5,5] to visualize using the selected function
    function generateSurfaceGrid() {
      const steps = 60;
      const xMin = -5, xMax = 5;
      const yMin = -5, yMax = 5;

      const xs = [];
      const ys = [];
      for (let i = 0; i < steps; i++) {
        xs.push(xMin + i*(xMax - xMin)/(steps-1));
        ys.push(yMin + i*(yMax - yMin)/(steps-1));
      }

      const Z = [];
      for (let j=0; j<ys.length; j++) {
        const row = [];
        for (let i=0; i<xs.length; i++) {
          row.push( f(xs[i], ys[j]) );
        }
        Z.push(row);
      }
      return { x: xs, y: ys, z: Z };
    }

    // 3) Minimal Adam with bias correction
    class AdamOptimizer {
      constructor(lr=0.01, beta1=0.9, beta2=0.999, epsilon=1e-8) {
        this.lr = lr;
        this.beta1 = beta1;
        this.beta2 = beta2;
        this.epsilon = epsilon;
        this.m_x = 0;  // first moment x
        this.m_y = 0;  // first moment y
        this.v_x = 0;  // second moment x
        this.v_y = 0;  // second moment y
        this.t = 0;    // time step
      }
      step(x, y, grad) {
        // grad = [dfdx, dfdy]
        this.t += 1;
        this.m_x = this.beta1 * this.m_x + (1 - this.beta1) * grad[0];
        this.m_y = this.beta1 * this.m_y + (1 - this.beta1) * grad[1];
        this.v_x = this.beta2 * this.v_x + (1 - this.beta2) * (grad[0]*grad[0]);
        this.v_y = this.beta2 * this.v_y + (1 - this.beta2) * (grad[1]*grad[1]);

        const m_hat_x = this.m_x / (1 - Math.pow(this.beta1, this.t));
        const m_hat_y = this.m_y / (1 - Math.pow(this.beta1, this.t));
        const v_hat_x = this.v_x / (1 - Math.pow(this.beta2, this.t));
        const v_hat_y = this.v_y / (1 - Math.pow(this.beta2, this.t));

        const x_new = x - this.lr * ( m_hat_x / (Math.sqrt(v_hat_x) + this.epsilon) );
        const y_new = y - this.lr * ( m_hat_y / (Math.sqrt(v_hat_y) + this.epsilon) );
        return [x_new, y_new];
      }
    }

    // 4) Global state
    let surfaceData = generateSurfaceGrid();

    let pathX = [];
    let pathY = [];
    let pathLoss = [];
    let xParam = 3.0, yParam = 2.0;  // set at reset
    let epoch = 0;
    let isRunning = false;
    let intervalHandle = null;
    let adam = null;

    // Helpers
    function getLearningRate() {
      return parseFloat(document.getElementById("lr-value").textContent);
    }

    // 5) Initialize Plots
    function initPlots() {
      // 3D surface
      Plotly.newPlot("surface-plot", [
        {
          x: surfaceData.x,
          y: surfaceData.y,
          z: surfaceData.z,
          type: "surface",
          colorscale: "Viridis"
        }
      ], {
        scene: {
          xaxis: { title: "x" },
          yaxis: { title: "y" },
          zaxis: { title: "f(x,y)" }
        },
        margin: {l:0, r:0, b:0, t:0}
      });

      // 2D contour
      Plotly.newPlot("contour-plot", [
        {
          x: surfaceData.x,
          y: surfaceData.y,
          z: surfaceData.z,
          type: "contour",
          colorscale: "RdBu",
          contours: { showlines: false }
        }
      ], {
        xaxis: {title: "x"},
        yaxis: {title: "y"}
      });

      // Loss vs epoch
      Plotly.newPlot("loss-plot", [
        {
          x: [0],
          y: [f(xParam, yParam)],
          mode: "lines+markers",
          name: "Loss"
        }
      ], {
        xaxis: { title: "Epoch" },
        yaxis: { title: "Loss" }
      });
    }

    // 6) One iteration
    function doStep() {
      const grad = gradf(xParam, yParam);

      if (adam) {
        [xParam, yParam] = adam.step(xParam, yParam, grad);
      } else {
        const lr = getLearningRate();
        xParam = xParam - lr * grad[0];
        yParam = yParam - lr * grad[1];
      }

      epoch++;
      const lossVal = f(xParam, yParam);
      pathX.push(xParam);
      pathY.push(yParam);
      pathLoss.push(lossVal);

      // update plots
      updatePlots();

      // UI
      document.getElementById("epoch-display").textContent = `Epoch: ${epoch}`;
      document.getElementById("loss-display").textContent = `Loss: ${lossVal.toFixed(4)}`;
    }

    // 7) Update Plotly
    function updatePlots() {
      // 3D with path line
      const surfaceTrace = {
        x: surfaceData.x,
        y: surfaceData.y,
        z: surfaceData.z,
        type: "surface",
        colorscale: "Viridis"
      };
      const pathZ = pathX.map((xx, i) => f(xx, pathY[i]));
      const pathLine3D = {
        x: pathX,
        y: pathY,
        z: pathZ,
        mode: "lines",
        type: "scatter3d",
        line: { color: "red", width: 4 },
        name: "Path"
      };
      const current3D = {
        x: [xParam],
        y: [yParam],
        z: [f(xParam, yParam)],
        mode: "markers",
        type: "scatter3d",
        marker: { color: "red", size: 6, symbol: "x" },
        name: "Current"
      };
      Plotly.react("surface-plot", [surfaceTrace, pathLine3D, current3D]);

      // 2D
      const contourTrace = {
        x: surfaceData.x,
        y: surfaceData.y,
        z: surfaceData.z,
        type: "contour",
        colorscale: "RdBu",
        contours: { showlines: false }
      };
      const pathLine2D = {
        x: pathX,
        y: pathY,
        mode: "lines",
        line: { color: "red", width: 2 },
        name: "Path"
      };
      const current2D = {
        x: [xParam],
        y: [yParam],
        mode: "markers",
        marker: { color: "red", size: 8, symbol: "x" },
        name: "Current"
      };
      Plotly.react("contour-plot", [contourTrace, pathLine2D, current2D]);

      // Loss
      const lossTrace = {
        x: Array.from(pathLoss.keys()),
        y: pathLoss,
        mode: "lines+markers",
        name: "Loss"
      };
      Plotly.react("loss-plot", [lossTrace], {
        xaxis: { title: "Epoch" },
        yaxis: { title: "Loss" }
      });
    }

    // 8) Animation
    function startSimulation() {
      if (isRunning) return;
      isRunning = true;
      intervalHandle = setInterval(doStep, 1000); // 1 second per step
    }
    function stopSimulation() {
      isRunning = false;
      if (intervalHandle) clearInterval(intervalHandle);
    }
    function resetSimulation() {
      stopSimulation();
      epoch = 0;

      // read user-chosen start coords
      xParam = parseFloat(document.getElementById("startx-value").textContent);
      yParam = parseFloat(document.getElementById("starty-value").textContent);

      pathX = [xParam];
      pathY = [yParam];
      const initLoss = f(xParam, yParam);
      pathLoss = [initLoss];

      // check Adam
      if (document.getElementById("adam-check").checked) {
        const lr = getLearningRate();
        adam = new AdamOptimizer(lr);
      } else {
        adam = null;
      }

      document.getElementById("epoch-display").textContent = "Epoch: 0";
      document.getElementById("loss-display").textContent = `Loss: ${initLoss.toFixed(4)}`;
      updatePlots();
    }

    // 9) DOM ready
    window.addEventListener("DOMContentLoaded", () => {
      initPlots();
      resetSimulation();

      // Start X slider
      const sxSlider = document.getElementById("startx-slider");
      sxSlider.addEventListener("input", () => {
        const val = parseFloat(sxSlider.value);
        document.getElementById("startx-value").textContent = val.toFixed(2);
      });
      sxSlider.dispatchEvent(new Event("input"));

      // Start Y slider
      const sySlider = document.getElementById("starty-slider");
      sySlider.addEventListener("input", () => {
        const val = parseFloat(sySlider.value);
        document.getElementById("starty-value").textContent = val.toFixed(2);
      });
      sySlider.dispatchEvent(new Event("input"));

      // Learning rate slider
      const lrSlider = document.getElementById("lr-slider");
      lrSlider.addEventListener("input", () => {
        // from e.g. -1.5 => 10^-1.5
        const val = parseFloat(lrSlider.value);
        const actualLR = Math.pow(10, val);
        document.getElementById("lr-value").textContent = actualLR.toExponential(1);
      });
      lrSlider.dispatchEvent(new Event("input"));

      // Function selection radio buttons
      document.querySelectorAll('input[name="func-select"]').forEach((elem) => {
        elem.addEventListener("change", (e) => {
          currentFunction = e.target.value;
          surfaceData = generateSurfaceGrid();
          resetSimulation();
        });
      });

      // Buttons
      document.getElementById("start-btn").addEventListener("click", startSimulation);
      document.getElementById("stop-btn").addEventListener("click", stopSimulation);
      document.getElementById("reset-btn").addEventListener("click", resetSimulation);
    });
  </script>
</body>
</html>