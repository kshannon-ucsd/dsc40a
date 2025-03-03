---
layout: none
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Interactive Polynomial Regression Regularization</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/plotly.js/2.24.1/plotly.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" defer></script>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      line-height: 1.6;
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
      transition: background-color 0.2s;
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
    .slider-container {
      margin: 10px 0;
    }
    .slider-span {
      margin-left: 8px;
      font-weight: 600;
    }
    .stats-panel {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 4px;
      margin-top: 10px;
      font-size: 0.9em;
    }
    .metric-box {
      padding: 10px;
      margin: 5px 0;
      background: white;
      border-radius: 4px;
      box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    .model-summary {
      background: #fff;
      padding: 1.5rem;
      border-radius: 8px;
      margin: 1.5rem 0;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .updated-value {
      transition: color 0.5s;
      color: #FF0000;
    }
    .explanation-container {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .explanation-box {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 4px;
      font-size: 0.95em;
    }
    @media (max-width: 768px) {
      .explanation-container {
        grid-template-columns: 1fr;
      }
    }
    .coefficient-table {
      width: 100%;
      border-collapse: collapse;
      margin: 1rem 0;
    }
    .coefficient-table th, .coefficient-table td {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid #eee;
    }
    .coefficient-table th {
      background: #f8f9fa;
      font-weight: 500;
    }
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
    <button style="margin-bottom: 20px;">← Back to Demos</button>
  </a>

  <h1>Interactive Polynomial Regression Regularization</h1>
  <p>
    This interactive demo illustrates how regularization helps to control model complexity in polynomial regression. 
    Adjust the sliders to see how the polynomial degree, regularization strength (λ), and data noise affect the model's fit.
  </p>

  <!-- Controls -->
  <div class="controls">
    <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
      <div class="slider-container">
        <label for="degree-slider">Polynomial Degree:</label><br>
        <input type="range" id="degree-slider" min="1" max="22" value="15" step="1">
        <span id="degree-value" class="slider-span">15</span>
      </div>
      
      <div class="slider-container">
        <label for="lambda-slider">Regularization Strength (λ):</label><br>
        <input type="range" id="lambda-slider" min="-7" max="2" value="-7" step="0.1">
        <span id="lambda-value" class="slider-span">1.0000e-7</span>
      </div>
      
      <div class="slider-container">
        <label for="noise-slider">Noise Level:</label><br>
        <input type="range" id="noise-slider" min="0" max="2" value="0.5" step="0.1">
        <span id="noise-value" class="slider-span">0.5</span>
      </div>
      
      <div class="slider-container">
        <label for="samples-slider">Number of Samples:</label><br>
        <input type="range" id="samples-slider" min="5" max="50" value="15" step="1">
        <span id="samples-value" class="slider-span">15</span>
      </div>
    </div>

    <!-- Regularization Type Selection -->
    <div style="margin-top: 1rem;">
      <label>Regularization Type:</label>
      <label style="margin-right: 1.5rem;">
        <input type="radio" name="reg-type" value="ridge" checked> Ridge (L2)
      </label>
      <label style="margin-right: 1.5rem;">
        <input type="radio" name="reg-type" value="lasso"> Lasso (L1)
      </label>
      <label>
        <input type="radio" name="reg-type" value="none"> Unregularized
      </label>
    </div>

    <button id="generate-btn" style="margin-top: 1rem;">Generate New Data</button>
    <button id="reset-btn" style="margin-top: 1rem;">Reset</button>
  </div>

  <!-- Plots -->
  <div class="plot-container">
    <!-- Main Fit Plot -->
    <div class="plot-wrapper">
      <h2>Model Fit Visualization</h2>
      <div id="fit-plot" style="width:100%; height:400px;"></div>
    </div>
    <!-- Weight Distribution Plot -->
    <div class="plot-wrapper">
      <h2>Coefficient Magnitudes</h2>
      <div id="weight-plot" style="width:100%; height:400px;"></div>
    </div>
  </div>

  <!-- Learning Curves -->
  <div class="plot-container">
    <div class="plot-wrapper full-width">
      <h2>Training and Validation Error</h2>
      <div id="learning-curve-plot" style="width:100%; height:400px;"></div>
    </div>
  </div>
  
  <!-- Model Summary -->
  <div class="model-summary">
    <h3>Model Performance</h3>
    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
      <div style="flex: 1; min-width: 300px;">
        <div id="stats-display" class="stats-panel">
          <!-- Model statistics will be populated by JavaScript -->
        </div>
      </div>
      <div style="flex: 1; min-width: 300px;">
        <table class="coefficient-table" id="coefficient-table">
          <thead>
            <tr>
              <th>Coefficient</th>
              <th>Value</th>
              <th>Term</th>
            </tr>
          </thead>
          <tbody>
            <!-- Coefficients will be populated by JavaScript -->
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Explanation Section -->
  <div class="plot-container">
    <div class="plot-wrapper full-width">
      <h2>Understanding Regularization</h2>
      
      <div class="explanation-container">
        <!-- Left side: Math explanation -->
        <div class="explanation-box">
          <h3>Mathematical Formulation</h3>
          
          <p>
            In polynomial regression, we fit a model of the form:
          </p>
          <p>
            $$f(x) = w_0 + w_1x + w_2x^2 + \ldots + w_nx^n$$
          </p>
          
          <p>
            <strong>Loss Functions:</strong>
          </p>
          <p>
            <strong>Unregularized:</strong>
            $$\mathcal{L} = \sum_{i=1}^{m} (y_i - f(x_i))^2 $$
          </p>
          
          <p>
            <strong>Ridge Regularization (L2):</strong>
            $$\mathcal{L} = \sum_{i=1}^{m} (y_i - f(x_i))^2 + \lambda \sum_{j=1}^{n} w_j^2 $$
          </p>
          
          <p>
            <strong>Lasso Regularization (L1):</strong>
            $$\mathcal{L} = \sum_{i=1}^{m} (y_i - f(x_i))^2 + \lambda \sum_{j=1}^{n} |w_j| $$
          </p>
          
          <p>
            The regularization parameter λ controls the strength of the penalty. Higher values enforce stronger regularization, resulting in smaller coefficients.
          </p>
        </div>
        
        <!-- Right side: Conceptual explanation -->
        <div class="explanation-box">
          <h3>Key Concepts</h3>
          
          <p>
            <strong>Why Regularization Matters:</strong>
          </p>
          <ul>
            <li><strong>Overfitting:</strong> High-degree polynomials can perfectly fit training data but generalize poorly</li>
            <li><strong>Variance-Bias Tradeoff:</strong> Regularization increases bias but reduces variance</li>
            <li><strong>Numerical Stability:</strong> Prevents exploding coefficients and improves conditioning</li>
          </ul>
          
          <p>
            <strong>Comparing Regularization Types:</strong>
          </p>
          <ul>
            <li><strong>Ridge (L2):</strong> Shrinks all coefficients toward zero, but rarely to exactly zero</li>
            <li><strong>Lasso (L1):</strong> Promotes sparsity by forcing some coefficients to exactly zero (feature selection)</li>
            <li><strong>No Regularization:</strong> Fits the data as closely as possible, potentially overfitting</li>
          </ul>
          
          <p>
            <strong>Try it:</strong> Increase the polynomial degree and observe how unregularized models start to overfit. Then increase λ to see how regularization smooths the curve and stabilizes predictions.
          </p>
        </div>
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

    // Generate synthetic polynomial data
    function generateData(numSamples, noise) {
      // Use a more complex true function that will be hard to fit
      const trueFunction = x => 0.5 * x * x + 0.3 * Math.sin(2 * x);
      
      // Generate unequally spaced points to make fitting harder
      const X = [];
      for (let i = 0; i < numSamples; i++) {
        // Add more points in the middle and fewer at the edges
        const t = Math.random();
        const x = -3 + 6 * t;
        X.push(x);
      }
      
      // Sort X values
      X.sort((a, b) => a - b);
      
      // Generate y values (true function plus noise)
      const yTrue = X.map(x => trueFunction(x));
      const y = yTrue.map(y_i => y_i + noise * normalRandom());
      
      return { X, y, yTrue };
    }

    // Create polynomial feature matrix
    function createPolyFeatures(X, degree) {
      const n = X.length;
      const X_poly = Array(n).fill().map(() => Array(degree + 1).fill(0));
      
      for (let i = 0; i < n; i++) {
        for (let j = 0; j <= degree; j++) {
          X_poly[i][j] = Math.pow(X[i], j);
        }
      }
      
      return X_poly;
    }

    // Transpose a matrix
    function transpose(matrix) {
      return matrix[0].map((_, colIndex) => matrix.map(row => row[colIndex]));
    }

    // Matrix multiplication
    function matrixMultiply(A, B) {
      const result = Array(A.length).fill().map(() => Array(B[0].length).fill(0));
      
      for (let i = 0; i < A.length; i++) {
        for (let j = 0; j < B[0].length; j++) {
          for (let k = 0; k < A[0].length; k++) {
            result[i][j] += A[i][k] * B[k][j];
          }
        }
      }
      
      return result;
    }

    // Vector addition
    function addVectors(v1, v2) {
      return v1.map((val, i) => val + v2[i]);
    }

    // Fit polynomial with regularization using normal equations
    function fitPolynomial(X, y, degree, lambda, regType) {
      // Create polynomial features
      const X_poly = createPolyFeatures(X, degree);
      
      // Transpose for matrix operations
      const X_polyT = transpose(X_poly);
      
      // Calculate X^T * X
      const XTX = matrixMultiply(X_polyT, X_poly);
      
      // Create identity matrix for regularization (not needed directly but helpful to understand the code)
      const identity = Array(degree + 1).fill().map((_, i) => 
        Array(degree + 1).fill(0).map((_, j) => i === j ? 1 : 0));
      
      // Add regularization to XTX for normal equations
      const regularizedXTX = XTX.map((row, i) => {
        if (regType === 'none') return row;
        
        return row.map((val, j) => {
          if (i === j) {
            // Don't regularize bias term (w0) for ridge regression
            if (i === 0 && regType === 'ridge') return val;
            return val + lambda;
          }
          return val;
        });
      });
      
      // Calculate X^T * y for normal equations
      const XTy = matrixMultiply(X_polyT, y.map(val => [val])).map(row => row[0]);
      
      // Solve normal equations: (X^T * X + λI) * w = X^T * y
      const weights = solveNormalEquations(regularizedXTX, XTy);
      
      // Apply L1 regularization (Lasso) separately
      // This is a simplified approach - real Lasso uses more sophisticated methods
      if (regType === 'lasso' && lambda > 0) {
        return weights.map((w, i) => {
          if (i === 0) return w; // Don't shrink bias term
          
          // Soft thresholding
          const shrinkage = Math.min(Math.abs(w), lambda / 2);
          return w > 0 ? w - shrinkage : w + shrinkage;
        });
      }
      
      return weights;
    }

    // Solve normal equations using Cholesky decomposition for numerical stability
    function solveNormalEquations(A, b) {
      const n = A.length;
      
      // Do Cholesky decomposition: A = L * L^T
      // This is more stable than direct inversion for well-conditioned matrices
      const L = Array(n).fill().map(() => Array(n).fill(0));
      
      for (let i = 0; i < n; i++) {
        for (let j = 0; j <= i; j++) {
          let sum = 0;
          
          if (j === i) {
            for (let k = 0; k < j; k++) {
              sum += L[j][k] * L[j][k];
            }
            L[j][j] = Math.sqrt(Math.max(A[j][j] - sum, 1e-10)); // Ensure positive for numerical stability
          } else {
            for (let k = 0; k < j; k++) {
              sum += L[i][k] * L[j][k];
            }
            L[i][j] = (A[i][j] - sum) / L[j][j];
          }
        }
      }
      
      // Forward substitution to solve L * y = b
      const y = Array(n).fill(0);
      for (let i = 0; i < n; i++) {
        let sum = 0;
        for (let j = 0; j < i; j++) {
          sum += L[i][j] * y[j];
        }
        y[i] = (b[i] - sum) / L[i][i];
      }
      
      // Backward substitution to solve L^T * x = y
      const x = Array(n).fill(0);
      for (let i = n - 1; i >= 0; i--) {
        let sum = 0;
        for (let j = i + 1; j < n; j++) {
          sum += L[j][i] * x[j];
        }
        x[i] = (y[i] - sum) / L[i][i];
      }
      
      return x;
    }

    // Calculate predictions
    function predict(X, weights, degree) {
      const X_poly = createPolyFeatures(X, degree);
      return X_poly.map(row => 
        row.reduce((sum, val, i) => sum + val * weights[i], 0)
      );
    }

    // Calculate MSE
    function calculateMSE(actual, predicted) {
      return actual.reduce((sum, val, i) => 
        sum + Math.pow(val - predicted[i], 2), 0) / actual.length;
    }

    // Calculate L2 norm (sum of squares) of weights
    function calculateL2Norm(weights) {
      return weights.reduce((sum, w) => sum + w * w, 0);
    }

    // Calculate L1 norm (sum of absolute values) of weights
    function calculateL1Norm(weights) {
      return weights.reduce((sum, w) => sum + Math.abs(w), 0);
    }

    // Main application code
    document.addEventListener('DOMContentLoaded', function() {
      let data = generateData(15, 0.5);
      let initialData = JSON.parse(JSON.stringify(data)); // Deep copy for reset
      updateAll();
      
      // Event listeners for sliders
      document.getElementById('degree-slider').addEventListener('input', e => {
        document.getElementById('degree-value').textContent = e.target.value;
        updateAll();
      });
      
      document.getElementById('lambda-slider').addEventListener('input', e => {
        const lambdaValue = Math.pow(10, parseFloat(e.target.value));
        document.getElementById('lambda-value').textContent = lambdaValue.toExponential(4);
        updateAll();
      });
      
      document.getElementById('noise-slider').addEventListener('input', e => {
        document.getElementById('noise-value').textContent = e.target.value;
      });
      
      document.getElementById('samples-slider').addEventListener('input', e => {
        document.getElementById('samples-value').textContent = e.target.value;
      });
      
      // Event listeners for radio buttons
      document.querySelectorAll('input[name="reg-type"]').forEach(radio => {
        radio.addEventListener('change', updateAll);
      });
      
      // Event listener for generate button
      document.getElementById('generate-btn').addEventListener('click', () => {
        const numSamples = parseInt(document.getElementById('samples-slider').value);
        const noise = parseFloat(document.getElementById('noise-slider').value);
        data = generateData(numSamples, noise);
        initialData = JSON.parse(JSON.stringify(data)); // Deep copy for reset
        updateAll();
      });
      
      // Event listener for reset button
      document.getElementById('reset-btn').addEventListener('click', () => {
        data = JSON.parse(JSON.stringify(initialData)); // Restore from initial data
        
        // Reset sliders to default values
        document.getElementById('degree-slider').value = 8;
        document.getElementById('degree-value').textContent = 8;
        
        document.getElementById('lambda-slider').value = 0;
        document.getElementById('lambda-value').textContent = "1.00";
        
        document.getElementById('noise-slider').value = 0.5;
        document.getElementById('noise-value').textContent = 0.5;
        
        document.getElementById('samples-slider').value = 15;
        document.getElementById('samples-value').textContent = 15;
        
        // Reset radio to Ridge
        document.querySelector('input[name="reg-type"][value="ridge"]').checked = true;
        
        updateAll();
      });
      
      // Main update function
      function updateAll() {
        const degree = parseInt(document.getElementById('degree-slider').value);
        const lambda = Math.pow(10, parseFloat(document.getElementById('lambda-slider').value));
        const regType = document.querySelector('input[name="reg-type"]:checked').value;
        
        // Fit model
        const weights = fitPolynomial(data.X, data.y, degree, lambda, regType);
        
        // Generate smooth curve for plotting
        const xSmooth = Array.from({length: 100}, (_, i) => -4 + (8 * i / 99));
        const yPred = predict(xSmooth, weights, degree);
        const yPredTrain = predict(data.X, weights, degree);
        
        // Calculate metrics
        const trainMSE = calculateMSE(data.y, yPredTrain);
        console.log(trainMSE);
        console.log(Math.sqrt(trainMSE))
        const trueMSE = calculateMSE(data.X.map(x => 0.5 * x * x + 0.3 * Math.sin(2 * x)), yPredTrain);
        const l2Norm = calculateL2Norm(weights.slice(1)); // Exclude bias term
        const l1Norm = calculateL1Norm(weights.slice(1)); // Exclude bias term
        
        // Update plots
        updateFitPlot(data.X, data.y, xSmooth, yPred, data.X.map(x => x * x));
        updateWeightPlot(weights);
        updateLearningCurvePlot(degree, lambda, regType);
        updateStats(trainMSE, trueMSE, l2Norm, l1Norm);
        updateCoefficients(weights);
      }
      
      // Update fit plot
      function updateFitPlot(X, y, xSmooth, yPred, yTrue) {
        // Calculate true function for smooth line
        const xTrueSmooth = Array.from({length: 100}, (_, i) => -4 + (8 * i / 99));
        const yTrueSmooth = xTrueSmooth.map(x => 0.5 * x * x + 0.3 * Math.sin(2 * x));
        
        const dataTrace = {
          x: X,
          y: y,
          mode: 'markers',
          type: 'scatter',
          name: 'Training Data',
          marker: {
            color: 'blue',
            size: 8
          }
        };
        
        const trueTrace = {
          x: xTrueSmooth,
          y: yTrueSmooth,
          mode: 'lines',
          type: 'scatter',
          name: 'True Function',
          line: {
            dash: 'dot',
            color: 'green',
            width: 2
          }
        };
        
        const predTrace = {
          x: xSmooth,
          y: yPred,
          mode: 'lines',
          type: 'scatter',
          name: 'Model Prediction',
          line: {
            color: 'red',
            width: 3
          }
        };
        
        // Get current λ and degree for title
        const lambda = Math.pow(10, parseFloat(document.getElementById('lambda-slider').value));
        const degree = parseInt(document.getElementById('degree-slider').value);
        const regType = document.querySelector('input[name="reg-type"]:checked').value;
        
        let titleText = `Polynomial Regression (Degree ${degree})`;
        if (regType !== 'none') {
          titleText += `, ${regType === 'ridge' ? 'Ridge' : 'Lasso'} λ=${lambda.toExponential(4)}`;
        }
        
        Plotly.newPlot('fit-plot', [dataTrace, trueTrace, predTrace], {
          title: titleText,
          xaxis: { title: 'X', range: [-4, 4] },
          yaxis: { title: 'Y', range: [-2, 10] }
        });
      }
      
      // Update weight plot
      function updateWeightPlot(weights) {
        const weightTrace = {
          x: Array.from({length: weights.length}, (_, i) => `w${i}`),
          y: weights,
          type: 'bar',
          marker: {
            color: weights.map(w => w >= 0 ? 'rgba(50, 171, 96, 0.7)' : 'rgba(219, 64, 82, 0.7)'),
            line: {
              color: weights.map(w => w >= 0 ? 'rgba(50, 171, 96, 1.0)' : 'rgba(219, 64, 82, 1.0)'),
              width: 1
            }
          }
        };
        
        Plotly.newPlot('weight-plot', [weightTrace], {
          title: 'Model Coefficients',
          xaxis: { title: 'Coefficient' },
          yaxis: { title: 'Value' }
        });
      }
      
      // Update learning curve plot
      function updateLearningCurvePlot(degree, lambda, regType) {
        const degreesRange = Array.from({length: 15}, (_, i) => i + 1);
        const trainErrors = [];
        const valErrors = [];
        
        // Generate validation data (more points for better generalization assessment)
        const valData = generateData(50, 0.5);
        
        // Calculate errors for each degree
        degreesRange.forEach(d => {
          const w = fitPolynomial(data.X, data.y, d, lambda, regType);
          const trainPred = predict(data.X, w, d);
          const valPred = predict(valData.X, w, d);
          
          trainErrors.push(calculateMSE(data.y, trainPred));
          valErrors.push(calculateMSE(valData.y, valPred));
        });
        
        const trainTrace = {
          x: degreesRange,
          y: trainErrors,
          mode: 'lines+markers',
          type: 'scatter',
          name: 'Training Error',
          line: { color: 'blue' }
        };
        
        const valTrace = {
          x: degreesRange,
          y: valErrors,
          mode: 'lines+markers',
          type: 'scatter',
          name: 'Validation Error',
          line: { color: 'red' }
        };
        
        // Add vertical line at current degree
        const currentDegreeTrace = {
          x: [degree, degree],
          y: [0, Math.max(...trainErrors, ...valErrors) * 1.1],
          mode: 'lines',
          type: 'scatter',
          name: 'Current Degree',
          line: {
            color: 'black',
            width: 2,
            dash: 'dash'
          }
        };
        
        Plotly.newPlot('learning-curve-plot', [trainTrace, valTrace, currentDegreeTrace], {
          title: 'Training and Validation Error vs Polynomial Degree',
          xaxis: { 
            title: 'Polynomial Degree',
            tickmode: 'linear',
            tick0: 1,
            dtick: 1
          },
          yaxis: { 
            title: 'Mean Squared Error',
            rangemode: 'tozero'
          }
        });
      }
      
      // Update statistics
      function updateStats(trainMSE, trueMSE, l2Norm, l1Norm) {
        const regType = document.querySelector('input[name="reg-type"]:checked').value;
        const lambda = Math.pow(10, parseFloat(document.getElementById('lambda-slider').value));
        const degree = parseInt(document.getElementById('degree-slider').value);
        
        // Calculate additional metrics
        const trainRMSE = Math.sqrt(trainMSE);
        const trueRMSE = Math.sqrt(trueMSE);
        
        // Determine if model is likely overfitting
        const overfit = (trainMSE < 0.1 && trueMSE > 0.5) || 
                       (l2Norm > 100) || 
                       (degree > 5 && regType === 'none');
        
        const statsDiv = document.getElementById('stats-display');
        statsDiv.innerHTML = `
          <div class="metric-box">
            <strong>Training RMSE:</strong> ${trainRMSE.toFixed(4)}
          </div>
          <div class="metric-box">
            <strong>True Function RMSE:</strong> ${trueRMSE.toFixed(4)}
          </div>
          <div class="metric-box">
            <strong>Coefficient L2 Norm:</strong> ${l2Norm.toFixed(4)}
          </div>
          <div class="metric-box">
            <strong>Coefficient L1 Norm:</strong> ${l1Norm.toFixed(4)}
          </div>
          <div class="metric-box">
            <strong>Regularization:</strong> ${regType === 'none' ? 'None' : 
              regType === 'ridge' ? 'Ridge (L2)' : 'Lasso (L1)'}
          </div>
          <div class="metric-box">
            <strong>Lambda (λ):</strong> ${lambda.toExponential(4)}
          </div>
          ${overfit ? `
          <div class="metric-box" style="background: #ffebee; border-left: 3px solid #f44336;">
            <strong>Warning:</strong> Model likely overfitting! Training error is very low but true error remains high.
          </div>` : ''}
        `;
      }
      
      // Update coefficient table
      function updateCoefficients(weights) {
        const tbody = document.getElementById('coefficient-table').getElementsByTagName('tbody')[0];
        tbody.innerHTML = '';
        
        weights.forEach((w, i) => {
          const tr = document.createElement('tr');
          
          const termCell = document.createElement('td');
          termCell.textContent = `w${i}`;
          
          const valueCell = document.createElement('td');
          valueCell.textContent = w.toFixed(4);
          valueCell.className = Math.abs(w) < 0.0001 ? 'updated-value' : '';
          
          const descCell = document.createElement('td');
          descCell.textContent = i === 0 ? 'Intercept' : 
            i === 1 ? 'x' : `x^${i}`;
          
          tr.appendChild(termCell);
          tr.appendChild(valueCell);
          tr.appendChild(descCell);
          tbody.appendChild(tr);
        });
      }
    });
  </script>
</body>
</html>