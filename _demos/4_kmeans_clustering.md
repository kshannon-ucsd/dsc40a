---
layout: none
---

<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>K-means Clustering Interactive Demo</title>
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
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
      gap: 8px;
      font-size: 0.9em;
    }
    .cluster-inactive {
      color: #999;
    }
    .cluster-stat {
      padding: 8px;
      border-radius: 4px;
      background: #fff;
      box-shadow: 0 1px 2px rgba(0,0,0,0.05);
      transition: all 0.3s ease;
    }
    .cluster-stat.active {
      border-left: 3px solid #4CAF50;
    }
    .iteration-badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 12px;
      background: #e9ecef;
      border-radius: 4px;
      font-weight: 500;
      margin-left: 20px;
    }
    .converged {
      color: #28a745;
      font-weight: 500;
      margin-left: 10px;
    }
    .elbow-section {
      display: grid;
      grid-template-columns: 1.2fr 0.8fr;
      gap: 20px;
      align-items: start;
    }
    .elbow-explanation {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 4px;
      font-size: 0.95em;
    }
    .elbow-explanation h3 {
      margin-top: 0;
      color: #2c3e50;
    }
    .centroid-movement {
      position: absolute;
      pointer-events: none;
      opacity: 0.6;
      stroke: red;
      stroke-width: 2;
    }
    @media (max-width: 768px) {
      .elbow-section {
        grid-template-columns: 1fr;
      }
    }
    .coordinate {
      font-family: monospace;
      font-size: 0.9em;
      color: #666;
    }
  </style>
</head>
<body>
  <a href="/pages/demos.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
    <button style="margin-bottom: 20px;">← Back to Demos</button>
  </a>

  <h1>Interactive K-means Clustering</h1>
  
  <!-- Main Controls -->
  <div class="controls">
    <div style="display: flex; gap: 2rem; flex-wrap: wrap;">
      <div class="slider-container">
        <label for="clusters-slider">Number of Clusters (K):</label>
        <input type="range" id="clusters-slider" min="2" max="12" value="5" step="1">
        <span id="clusters-value" class="slider-span">5</span>
      </div>
      <div class="slider-container">
        <label for="noise-slider">Noise Level:</label>
        <input type="range" id="noise-slider" min="0.1" max="3" value="1.0" step="0.1">
        <span id="noise-value" class="slider-span">1.0</span>
      </div>
      <div class="slider-container">
        <label for="data-clusters-slider">Data Clusters:</label>
        <input type="range" id="data-clusters-slider" min="2" max="10" value="5" step="1">
        <span id="data-clusters-value" class="slider-span">5</span>
      </div>
    </div>
    <div style="margin-top: 1rem;">
      <button id="start-btn">Start</button>
      <button id="stop-btn">Stop</button>
      <button id="reset-btn">Reset</button>
      <button id="new-data-btn">Generate New Data</button>
    </div>
  </div>

  <!-- Main Plots -->
  <div class="plot-container">
    <div class="plot-wrapper">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Cluster Visualization</h2>
        <span class="iteration-badge">
          <span id="iteration-display">Iteration: 0</span>
          <span id="converged-badge" class="converged" style="display: none;">✓ Converged</span>
        </span>
      </div>
      <div id="cluster-plot"></div>
    </div>
    <div class="plot-wrapper">
      <h2>Cluster Statistics</h2>
      <div id="stats-display" class="stats-panel"></div>
    </div>
  </div>

  <!-- Elbow Method Section -->
  <div class="plot-container" markdown="0">
    <div class="plot-wrapper">
      <div class="elbow-section">
        <div>
          <h2>Elbow Method Analysis</h2>
          <div id="elbow-plot"></div>
        </div>
        <div class="elbow-explanation">
          <h3>Understanding the Elbow Method</h3>
          <p>
            The elbow method helps determine the optimal number of clusters (K) by analyzing how the 
            Sum of Squared Errors (SSE) changes with different K values.
          </p>
          <p>
            <strong>Key Points:</strong>
          </p>
          <ul>
            <li>As K increases, SSE naturally decreases</li>
            <li>The "elbow" appears where adding more clusters gives diminishing returns</li>
            <li>This point often indicates a good balance between model complexity and fit</li>
          </ul>
          <p>
            <strong>Try it:</strong> Generate new data to see how the elbow curve changes. Look for 
            where the curve starts to level off - this often suggests a reasonable choice for K.
          </p>
        </div>
      </div>
    </div>
  </div>

  <script>
    // Core K-means implementation
    class KMeans {
      constructor(k = 5) {
        this.k = k;
        this.centroids = null;
        this.previousCentroids = null;
        this.labels = null;
        this.iteration = 0;
        this.convergenceThreshold = 0.0001;
      }

      // Generate synthetic data with clear clusters
      generateSyntheticData(n_samples = 1000, noise = 1.0, n_clusters = 5) {
        const centers = [
          [-5, -5], [0, 5], [5, -3], [-3, 3], [5, 5],
          [-2, 0], [2, 2], [-4, 4], [4, -4], [0, -5]
        ].slice(0, n_clusters);
        
        let data = [];
        const samplesPerCluster = Math.floor(n_samples / centers.length);
        
        centers.forEach(center => {
          for (let i = 0; i < samplesPerCluster; i++) {
            data.push([
              center[0] + this.randn() * noise,
              center[1] + this.randn() * noise
            ]);
          }
        });

        // Shuffle the data
        for (let i = data.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [data[i], data[j]] = [data[j], data[i]];
        }

        return data;
      }

      // Helper: Generate random normal numbers
      randn() {
        let u = 0, v = 0;
        while (u === 0) u = Math.random();
        while (v === 0) v = Math.random();
        return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
      }

      // Initialize centroids
      initializeCentroids(data) {
        // Randomly select k points as initial centroids
        const n = data.length;
        this.centroids = [];
        const indices = new Set();
        
        while (indices.size < this.k) {
          indices.add(Math.floor(Math.random() * n));
        }
        
        Array.from(indices).forEach(idx => {
          this.centroids.push([...data[idx]]);
        });
        
        this.previousCentroids = null;
      }

      // Assign points to nearest centroid
      assignLabels(data) {
        this.labels = data.map(point => {
          let minDist = Infinity;
          let label = 0;
          
          this.centroids.forEach((centroid, i) => {
            const dist = this.euclideanDistance(point, centroid);
            if (dist < minDist) {
              minDist = dist;
              label = i;
            }
          });
          
          return label;
        });
      }

      // Update centroid positions
      updateCentroids(data) {
        this.previousCentroids = this.centroids.map(c => [...c]);
        const newCentroids = Array(this.k).fill().map(() => [0, 0]);
        const counts = Array(this.k).fill(0);
        
        data.forEach((point, i) => {
          const label = this.labels[i];
          newCentroids[label][0] += point[0];
          newCentroids[label][1] += point[1];
          counts[label]++;
        });
        
        this.centroids = newCentroids.map((centroid, i) => {
          if (counts[i] === 0) return this.previousCentroids[i];
          return [
            centroid[0] / counts[i],
            centroid[1] / counts[i]
          ];
        });
      }

      // Check for convergence
      hasConverged() {
        if (!this.previousCentroids) return false;
        
        return this.centroids.every((centroid, i) => {
          const prev = this.previousCentroids[i];
          return this.euclideanDistance(centroid, prev) < this.convergenceThreshold;
        });
      }

      // Calculate SSE (Sum of Squared Errors)
      calculateSSE(data) {
        return data.reduce((sum, point, i) => {
          return sum + this.euclideanDistance(point, this.centroids[this.labels[i]]) ** 2;
        }, 0);
      }

      // Helper: Calculate Euclidean distance
      euclideanDistance(p1, p2) {
        return Math.sqrt(
          (p1[0] - p2[0]) ** 2 + 
          (p1[1] - p2[1]) ** 2
        );
      }

      // Perform one iteration
      step(data) {
        this.assignLabels(data);
        this.updateCentroids(data);
        this.iteration++;
        return {
          labels: this.labels,
          converged: this.hasConverged()
        };
      }
    }

    // Visualization Manager
    class KMeansViz {
      constructor() {
        this.kmeans = new KMeans(5);
        this.data = null;
        this.isRunning = false;
        this.intervalHandle = null;
        
        this.initializeData();
        this.setupEventListeners();
        this.initializePlots();
        this.calculateElbowCurve();
      }

      initializeData() {
        this.data = this.kmeans.generateSyntheticData(1000, 1.0, 5);
        this.kmeans.initializeCentroids(this.data);
        this.updatePlots();
      }

      setupEventListeners() {
        document.getElementById('clusters-slider').addEventListener('input', (e) => {
          const value = parseInt(e.target.value);
          document.getElementById('clusters-value').textContent = value;
          this.kmeans.k = value;
          this.reset();
        });

        document.getElementById('noise-slider').addEventListener('input', (e) => {
          const value = parseFloat(e.target.value);
          document.getElementById('noise-value').textContent = value.toFixed(1);
        });

        document.getElementById('data-clusters-slider').addEventListener('input', (e) => {
          const value = parseInt(e.target.value);
          document.getElementById('data-clusters-value').textContent = value;
        });

        document.getElementById('start-btn').addEventListener('click', () => this.start());
        document.getElementById('stop-btn').addEventListener('click', () => this.stop());
        document.getElementById('reset-btn').addEventListener('click', () => this.reset());
        document.getElementById('new-data-btn').addEventListener('click', () => {
          const noise = parseFloat(document.getElementById('noise-slider').value);
          const clusters = parseInt(document.getElementById('data-clusters-slider').value);
          this.data = this.kmeans.generateSyntheticData(1000, noise, clusters);
          this.kmeans.initializeCentroids(this.data);
          this.calculateElbowCurve();
          this.updatePlots();
        });
      }

      initializePlots() {
        // Initialize main cluster plot
        Plotly.newPlot('cluster-plot', [{
          x: this.data.map(d => d[0]),
          y: this.data.map(d => d[1]),
          mode: 'markers',
          type: 'scatter',
          name: 'Data Points'
        }], {
          title: 'K-means Clustering',
          xaxis: { title: 'X' },
          yaxis: { title: 'Y' },
          showlegend: true
        });

        // Initialize elbow plot
        Plotly.newPlot('elbow-plot', [{
          x: [],
          y: [],
          mode: 'lines+markers',
          type: 'scatter',
          name: 'SSE vs K',
          line: { color: '#1f77b4' },
          marker: { size: 8 }
        }], {
          title: 'Elbow Method Analysis',
          xaxis: { 
            title: 'Number of Clusters (K)',
            tickmode: 'linear',
            tick0: 1,
            dtick: 1
          },
          yaxis: { 
            title: 'Sum of Squared Errors (SSE)',
            rangemode: 'tozero'
          },
          showlegend: false
        });
      }

      updatePlots() {
        const colors = this.kmeans.labels || Array(this.data.length).fill(0);
        
        // Update main cluster plot
        Plotly.react('cluster-plot', [
          {
            x: this.data.map(d => d[0]),
            y: this.data.map(d => d[1]),
            mode: 'markers',
            type: 'scatter',
            name: 'Data Points',
            marker: { 
              color: colors,
              colorscale: 'Viridis',
              size: 6
            }
          },
          {
            x: this.kmeans.centroids.map(c => c[0]),
            y: this.kmeans.centroids.map(c => c[1]),
            mode: 'markers',
            type: 'scatter',
            name: 'Cluster Centers',
            marker: {
              symbol: 'x',
              size: 12,
              color: 'red',
              line: { width: 2 }
            }
          }
        ], {
          title: 'K-means Clustering',
          xaxis: { title: 'X' },
          yaxis: { title: 'Y' },
          showlegend: true
        });

        // Update statistics
        this.updateStats();
        document.getElementById('iteration-display').textContent = 'Iteration: ' + this.kmeans.iteration;
      }

      updateStats() {
        const statsDiv = document.getElementById('stats-display');
        const counts = Array(12).fill(0); // Always show all 12 possible clusters
        
        if (this.kmeans.labels) {
          this.kmeans.labels.forEach(label => counts[label]++);
        }

        let html = '';
        counts.forEach((count, i) => {
          const isActive = i < this.kmeans.k;
          const className = isActive ? 'cluster-stat active' : 'cluster-stat cluster-inactive';
          const centroid = isActive ? this.kmeans.centroids[i] : null;
          
          html += `
            <div class="${className}">
              <strong>Cluster ${i + 1}</strong><br>
              Size: ${isActive ? count : '--'}
              ${centroid ? `<br><span class="coordinate">(${centroid[0].toFixed(2)}, ${centroid[1].toFixed(2)})</span>` : ''}
            </div>
          `;
        });

        statsDiv.innerHTML = html;
      }

      calculateElbowCurve() {
        const maxK = 12;
        const sseValues = [];
        
        for (let k = 1; k <= maxK; k++) {
          const kmeans = new KMeans(k);
          kmeans.initializeCentroids(this.data);
          
          // Run for a fixed number of iterations
          for (let i = 0; i < 10; i++) {
            kmeans.step(this.data);
          }
          
          sseValues.push(kmeans.calculateSSE(this.data));
        }

        // Update elbow plot
        Plotly.react('elbow-plot', [{
          x: Array.from({length: maxK}, (_, i) => i + 1),
          y: sseValues,
          mode: 'lines+markers',
          type: 'scatter',
          name: 'SSE vs K',
          line: { color: '#1f77b4' },
          marker: { size: 8 }
        }], {
          title: 'Elbow Method Analysis',
          xaxis: { 
            title: 'Number of Clusters (K)',
            tickmode: 'linear',
            tick0: 1,
            dtick: 1
          },
          yaxis: { 
            title: 'Sum of Squared Errors (SSE)',
            rangemode: 'tozero'
          },
          showlegend: false
        });
      }

      start() {
        if (this.isRunning) return;
        this.isRunning = true;
        document.getElementById('converged-badge').style.display = 'none';
        this.intervalHandle = setInterval(() => {
          const result = this.kmeans.step(this.data);
          this.updatePlots();
          
          if (result.converged) {
            document.getElementById('converged-badge').style.display = 'inline';
            this.stop();
          }
        }, 1000); // 1 second delay
      }

      stop() {
        this.isRunning = false;
        if (this.intervalHandle) {
          clearInterval(this.intervalHandle);
        }
      }

      reset() {
        this.stop();
        this.kmeans.iteration = 0;
        this.kmeans.initializeCentroids(this.data);
        this.kmeans.labels = null;
        document.getElementById('converged-badge').style.display = 'none';
        this.updatePlots();
      }
    }

    // Initialize when DOM is ready
    window.addEventListener('DOMContentLoaded', () => {
      const viz = new KMeansViz();
    });
  </script>

  <!-- Educational Content -->
  <div class="plot-container" markdown="0">
  <div class="plot-wrapper">
    <h2>Algorithm Execution</h2>
    <h3>A. Initialization</h3>
    <p>
      Start with randomly chosen centroids \(\mu_1\), \(\mu_2\), ..., \(\mu_k\).
    </p>
    <h3>B. Iteration</h3>
    <ol>
      <li>
        <strong>Assignment Step</strong>: For each point \(\,x_i\,\), calculate \(\,d(x_i, \mu_j)^2\,\) for all \(\,j\,\) and assign \(\,x_i\,\) to the cluster with the smallest distance.
      </li>
      <li>
        <strong>Update Step</strong>: For each cluster \(\,j\,\), recalculate \(\,\mu_j\,\) as the mean of all points assigned to it.
      </li>
      <li>
        <strong>SSE Calculation</strong>: Calculate the new SSE after the update.
      </li>
      <li>
        <strong>Convergence Check</strong>: If SSE hasn't significantly decreased or max iterations reached, stop. Otherwise, go back to step 1.
      </li>
    </ol>
    <h2>Mathematical Foundations</h2>
    <h3>A. Dataset Representation</h3>
    <p>
      Let \(\,X = \{x_1, x_2, ..., x_n\}\) be our dataset, where each \(\,x_i\,\) is a \(\,d\)-dimensional vector.
    </p>
    <h3>B. Squared Euclidean Distance</h3>
    <p>
      The distance between two points \(\,x = (x_1, ..., x_m)\) and \(\,y = (y_1, ..., y_m)\) is calculated as:
    </p>
    <p>
      $$d(x,y)^2 = \sum_{j=1}^m (x_j - y_j)^2 = \|x - y\|_2^2$$
    </p>
    <p>
      This distance is used in the assignment step to determine the nearest centroid for each point.
    </p>
    <h3>C. Sum of Squared Errors (SSE)</h3>
    <p>
      The objective function to be minimized is:
    </p>
    <p>
      $$SSE = \sum_{i=1}^n \sum_{j=1}^k w^{(i,j)} \|\mathbf{X}^{(i)} - \boldsymbol{\mu}^{(j)}\|_2^2$$
    </p>
    <p>Where:</p>
    <ul>
      <li>\(n\) is the number of data points</li>
      <li>\(k\) is the number of clusters</li>
      <li>\(w^{(i,j)}\) is a binary weight function (1 if point \(i\) is in cluster \(j\), 0 otherwise)</li>
      <li>\(X^{(i)}\) is the \(i\)-th data point (vector)</li>
      <li>\(\mu^{(j)}\) is the centroid of the \(j\)-th cluster (vector)</li>
    </ul>
  </div>
</div>
</body>
</html>