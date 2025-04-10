---
layout: none
---

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Armed Bandit Demo</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .description {
            text-align: center;
            margin-bottom: 30px;
            color: #7f8c8d;
        }
        .stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            background-color: #fff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2980b9;
        }
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
        }
        .machines-container {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        .machine {
            width: 220px;
            background-color: white;
            border-radius: 15px;
            padding: 15px;
            margin: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            text-align: center;
        }
        .machine:hover {
            transform: translateY(-5px);
        }
        .machine-title {
            font-weight: bold;
            margin-bottom: 10px;
            color: #34495e;
        }
        .machine-image {
            width: 120px;
            height: 120px;
            margin: 0 auto 15px;
            background-color: #ecf0f1;
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .machine-stats {
            margin-top: 15px;
            font-size: 14px;
        }
        .distribution-bar {
            height: 20px;
            background-color: #ecf0f1;
            border-radius: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            overflow: hidden;
            position: relative;
        }
        .distribution-fill {
            height: 100%;
            background-color: #3498db;
            width: 0%;
            transition: width 0.5s;
        }
        .true-distribution-fill {
            height: 100%;
            background-color: #e74c3c;
            width: 0%;
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
            transition: opacity 0.5s;
        }
        .buttons-container {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }
        button {
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        button:hover {
            opacity: 0.9;
        }
        .reveal-btn {
            background-color: #9b59b6;
            color: white;
        }
        .new-attempt-btn {
            background-color: #2ecc71;
            color: white;
        }
        .reset-btn {
            background-color: #e74c3c;
            color: white;
        }
        .leaderboard {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .leaderboard h2 {
            text-align: center;
            margin-top: 0;
            color: #2c3e50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ecf0f1;
        }
        th {
            background-color: #f9f9f9;
            color: #2c3e50;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .pull-animation {
            animation: pull 1s;
        }
        .result-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 40px;
            font-weight: bold;
            opacity: 0;
            pointer-events: none;
        }
        .win {
            background-color: rgba(46, 204, 113, 0.7);
            color: white;
        }
        .lose {
            background-color: rgba(231, 76, 60, 0.7);
            color: white;
        }
        .show-result {
            animation: showResult 1.5s;
        }
        /* New styles for probability distribution */
        .probability-distribution {
            margin-top: 10px;
            height: 60px;
            position: relative;
        }
        .distribution-points {
            display: flex;
            justify-content: space-between;
            height: 30px;
            position: relative;
        }
        .distribution-point {
            width: 2px;
            background-color: #3498db;
            margin: 0 1px;
            position: absolute;
            bottom: 0;
        }
        .history-bar {
            display: flex;
            height: 20px;
            margin-top: 5px;
            border-radius: 4px;
            overflow: hidden;
        }
        .history-win {
            height: 100%;
            background-color: #2ecc71;
            width: 8px;
            margin: 0 1px;
        }
        .history-lose {
            height: 100%;
            background-color: #e74c3c;
            width: 8px;
            margin: 0 1px;
        }
        @keyframes pull {
            0% { transform: translateY(0); }
            50% { transform: translateY(10px); }
            100% { transform: translateY(0); }
        }
        @keyframes showResult {
            0% { opacity: 0; }
            30% { opacity: 1; }
            70% { opacity: 1; }
            100% { opacity: 0; }
        }
    </style>
</head>
<body>
    <a href="/pages/demos.html" style="text-decoration: none; margin-bottom: 20px; display: inline-block;">
        <button style="background-color: indigo; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer;">← Back to Demos</button>
    </a>
    <h1>Multi-Armed Bandit Demo</h1>
    <p class="description">Try to maximize your reward by choosing which slot machine to play. Each machine has a different probability of success (25%, 40%, 55%, and 60%), but they're shuffled for each attempt!</p>


    
    <div class="stats">
        <div class="stat-item">
            <div class="stat-value" id="attempts-left">50</div>
            <div class="stat-label">Attempts Left</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="total-reward">0</div>
            <div class="stat-label">Total Reward</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="best-machine">?</div>
            <div class="stat-label">Best Machine</div>
        </div>
    </div>
    
    <div class="machines-container" id="machines-container">
        <!-- Machines will be generated by JavaScript -->
    </div>
    
    <div class="buttons-container">
        <button class="new-attempt-btn" id="new-attempt-btn">Start New Attempt</button>
       <button style="margin-right: 30px; margin-left: 30px;" class="reset-btn" id="reset-btn">Reset All</button>
        <a href="https://forms.gle/8g72dNxaEcSra1JN6" target="_blank" style="text-decoration: none;">
      <button style="background-color: indigo; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer;">
        Submit Score!
      </button>
    </a>
    </div>
    
        
    <div style="display: flex; justify-content: center;">
      <div class="leaderboard" style="width: 80%; max-width: 800px;">
        <h2 style="text-align: center;">Leaderboard</h2>
        <iframe src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQiAvSqrGGicKy8jEBTbBq9lCiODEbedf_5IA4bYoZkt6znsaXT_HEE-ZE1cE8tg7LB3-zOcbajjo-E/pubhtml?gid=1620723654&amp;single=true&amp;widget=true&amp;headers=false" style="width: 100%; height: 400px; border: none;"></iframe>
      </div>
    </div>


    <script>
        // Configuration
        const NUM_MACHINES = 4;
        const MAX_ATTEMPTS = 50;
        const FIXED_PROBS = [0.25, 0.40, 0.55, 0.60]; // Fixed probabilities
        
        // Game state
        let machineProbs = [];
        let machineStats = [];
        let machineHistory = [];
        let attemptsLeft = MAX_ATTEMPTS;
        let totalReward = 0;
        let attemptCounter = 0;
        let leaderboard = [];
        
        // Initialize game
        function initGame() {
            // Shuffle the fixed probabilities
            machineProbs = [...FIXED_PROBS];
            shuffleArray(machineProbs);
            
            // Initialize machine statistics (for Bayesian updating)
            machineStats = [];
            machineHistory = [];
            for (let i = 0; i < NUM_MACHINES; i++) {
                machineStats.push({
                    successes: 1,  // Start with a prior of 1 success
                    failures: 1,   // Start with a prior of 1 failure
                    plays: 0
                });
                machineHistory.push([]);
            }
            
            // Reset game state
            attemptsLeft = MAX_ATTEMPTS;
            totalReward = 0;
            
            // Update UI
            updateStats();
            renderMachines();
        }
        
        // Fisher-Yates shuffle algorithm
        function shuffleArray(array) {
            for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [array[i], array[j]] = [array[j], array[i]];
            }
            return array;
        }
        
        // Create SVG slot machine
        function createSlotMachineSVG() {
            return `
            <svg width="120" height="120" viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
                <!-- Machine body -->
                <rect x="10" y="10" width="100" height="90" rx="5" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
                
                <!-- Display screen -->
                <rect x="20" y="20" width="80" height="40" rx="3" fill="#ecf0f1" stroke="#7f8c8d" stroke-width="1"/>
                
                <!-- Symbols in screen -->
                <text x="35" y="45" font-family="Arial" font-size="16" fill="#e74c3c">7</text>
                <text x="55" y="45" font-family="Arial" font-size="16" fill="#f39c12">$</text>
                <text x="75" y="45" font-family="Arial" font-size="16" fill="#2ecc71">★</text>
                
                <!-- Lever -->
                <rect x="90" y="50" width="5" height="40" rx="2" fill="#e74c3c"/>
                <circle cx="92" cy="50" r="8" fill="#e74c3c"/>
                
                <!-- Bottom tray -->
                <rect x="30" y="80" width="60" height="15" rx="3" fill="#2c3e50"/>
            </svg>
            `;
        }
        
        // Render machines
        function renderMachines() {
            const container = document.getElementById('machines-container');
            container.innerHTML = '';
            
            for (let i = 0; i < NUM_MACHINES; i++) {
                const machine = document.createElement('div');
                machine.classList.add('machine');
                
                const estimatedProb = machineStats[i].successes / (machineStats[i].successes + machineStats[i].failures);
                const playCount = machineStats[i].plays;
                
                machine.innerHTML = `
                    <div class="machine-title">Machine ${i + 1}</div>
                    <div class="machine-image" data-machine="${i}">
                        ${createSlotMachineSVG()}
                        <div class="result-overlay" id="result-${i}"></div>
                    </div>
                    <div class="machine-stats">
                        <div>Plays: <span id="plays-${i}">${playCount}</span></div>
                        <div>Estimated Success: <span id="est-prob-${i}">${(estimatedProb * 100).toFixed(1)}%</span></div>
                        <div class="distribution-bar">
                            <div class="distribution-fill" id="est-fill-${i}" style="width: ${estimatedProb * 100}%"></div>
                        </div>
                        <div>Probability Distribution:</div>
                        <div class="probability-distribution" id="dist-${i}"></div>
                        <div class="history-bar" id="history-${i}"></div>
                    </div>
                `;
                
                container.appendChild(machine);
                
                // Add click handler
                const machineImg = machine.querySelector('.machine-image');
                machineImg.addEventListener('click', () => playMachine(i));
                
                // Render initial probability distribution
                renderProbabilityDistribution(i);
            }
        }
        
        // Render probability distribution for a machine
        function renderProbabilityDistribution(machineId) {
            const distContainer = document.getElementById(`dist-${machineId}`);
            distContainer.innerHTML = '';
            
            const historyContainer = document.getElementById(`history-${machineId}`);
            historyContainer.innerHTML = '';
            
            // Beta distribution parameters
            const alpha = machineStats[machineId].successes;
            const beta = machineStats[machineId].failures;
            
            // Draw probability distribution
            const numPoints = 50;
            const distPoints = document.createElement('div');
            distPoints.classList.add('distribution-points');
            
            // Simple way to approximate a Beta distribution
            for (let i = 0; i < numPoints; i++) {
                const p = i / (numPoints - 1);
                
                // Beta PDF approximation (not mathematically accurate but visually helpful)
                // This gives a curve that peaks at the estimated probability
                const estimatedProb = alpha / (alpha + beta);
                const variance = (alpha * beta) / ((alpha + beta) ** 2 * (alpha + beta + 1));
                const stdDev = Math.sqrt(variance);
                
                // Simplified "bell curve" based on distance from estimated probability
                const height = Math.exp(-((p - estimatedProb) ** 2) / (2 * (stdDev ** 2 + 0.01)));
                
                const point = document.createElement('div');
                point.classList.add('distribution-point');
                point.style.height = `${height * 30}px`;
                point.style.left = `${p * 100}%`;
                
                distPoints.appendChild(point);
            }
            
            distContainer.appendChild(distPoints);
            
            // Draw history of plays
            const history = machineHistory[machineId];
            for (const result of history) {
                const historyPoint = document.createElement('div');
                historyPoint.classList.add(result ? 'history-win' : 'history-lose');
                historyContainer.appendChild(historyPoint);
            }
        }
        
        // Play a machine
        function playMachine(machineId) {
            if (attemptsLeft <= 0) {
                alert("No attempts left! Start a new attempt or reset.");
                return;
            }
            
            // Animate pull
            const machineImg = document.querySelector(`.machine-image[data-machine="${machineId}"]`);
            machineImg.classList.add('pull-animation');
            setTimeout(() => {
                machineImg.classList.remove('pull-animation');
            }, 1000);
            
            // Determine if win or lose
            const isWin = Math.random() < machineProbs[machineId];
            
            // Update statistics
            if (isWin) {
                machineStats[machineId].successes++;
                totalReward++;
            } else {
                machineStats[machineId].failures++;
            }
            
            machineStats[machineId].plays++;
            machineHistory[machineId].push(isWin);
            attemptsLeft--;
            
            // Show result
            const resultOverlay = document.getElementById(`result-${machineId}`);
            resultOverlay.textContent = isWin ? '+1' : '0';
            resultOverlay.classList.add(isWin ? 'win' : 'lose');
            resultOverlay.classList.add('show-result');
            setTimeout(() => {
                resultOverlay.classList.remove('show-result');
                resultOverlay.classList.remove('win');
                resultOverlay.classList.remove('lose');
            }, 1500);
            
            // Update UI
            updateStats();
            updateMachineStats(machineId);
        }
        
        // Update machine statistics display
        function updateMachineStats(machineId) {
            const plays = document.getElementById(`plays-${machineId}`);
            const estProb = document.getElementById(`est-prob-${machineId}`);
            const estFill = document.getElementById(`est-fill-${machineId}`);
            
            const stat = machineStats[machineId];
            const estimatedProb = stat.successes / (stat.successes + stat.failures);
            
            plays.textContent = stat.plays;
            estProb.textContent = `${(estimatedProb * 100).toFixed(1)}%`;
            estFill.style.width = `${estimatedProb * 100}%`;
            
            // Update probability distribution
            renderProbabilityDistribution(machineId);
        }
        
        // Update game statistics
        function updateStats() {
            document.getElementById('attempts-left').textContent = attemptsLeft;
            document.getElementById('total-reward').textContent = totalReward;
            
            // Find the machine with the highest estimated probability
            let bestMachineId = 0;
            let bestProb = 0;
            
            // Show the estimated best machine based on observed results
            for (let i = 0; i < NUM_MACHINES; i++) {
                const estimatedProb = machineStats[i].successes / (machineStats[i].successes + machineStats[i].failures);
                if (estimatedProb > bestProb) {
                    bestProb = estimatedProb;
                    bestMachineId = i;
                }
            }
            
            document.getElementById('best-machine').textContent = `${bestMachineId + 1} (${(bestProb * 100).toFixed(1)}%)`;
        }
        
        // Start new attempt
        function startNewAttempt() {
            // Save current attempt to leaderboard
            if (attemptsLeft < MAX_ATTEMPTS) {  // Only if game has been played
                // Find the actual machine with the highest probability 
                // (for leaderboard tracking purposes, but not revealed to user)
                let bestMachineId = 0;
                let bestProb = 0;
                for (let i = 0; i < NUM_MACHINES; i++) {
                    if (machineProbs[i] > bestProb) {
                        bestProb = machineProbs[i];
                        bestMachineId = i;
                    }
                }
                
                attemptCounter++;
                
                // Calculate success rate (how many times the best machine was played)
                const bestMachinePlays = machineStats[bestMachineId].plays;
                const successRate = ((bestMachinePlays / (MAX_ATTEMPTS - attemptsLeft)) * 100).toFixed(1);
            }
            
            // Start new game
            initGame();
        }
        
        // Reset everything
        function resetAll() {
            attemptCounter = 0;
            leaderboard = [];
            
            initGame();
        }
        
        // Update leaderboard display
       
        
        // Set up event listeners
        document.getElementById('new-attempt-btn').addEventListener('click', startNewAttempt);
        document.getElementById('reset-btn').addEventListener('click', resetAll);
        
        // Initialize game on load
        window.addEventListener('DOMContentLoaded', initGame);
    </script>
    
</body>
</html>
