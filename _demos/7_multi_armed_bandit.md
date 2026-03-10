---
layout: none
---

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Armed Bandit Tournament</title>
    <style>
        :root {
            --page: #fbf9f4;
            --page-warm: #f1ebdf;
            --forest: #174734;
            --forest-deep: #0f2d21;
            --casino-red: #b33a2b;
            --casino-red-deep: #7a2219;
            --machine-black: #181412;
            --gold: #f1c453;
            --gold-soft: #f7e1a1;
            --cream: #fffdf8;
            --ink: #1b1714;
            --muted: #6a5f53;
            --panel: rgba(255, 255, 255, 0.98);
            --panel-strong: rgba(255, 250, 242, 0.98);
            --shadow: 0 18px 40px rgba(34, 19, 5, 0.08);
            --win: #2a9d5b;
            --loss: #b24334;
            --info: #2d6ea3;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Avenir Next", "Segoe UI", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at top left, rgba(241, 196, 83, 0.14), transparent 22%),
                radial-gradient(circle at top right, rgba(23, 71, 52, 0.06), transparent 24%),
                linear-gradient(180deg, var(--page) 0%, var(--page-warm) 100%);
        }

        .page-shell {
            max-width: 1320px;
            margin: 0 auto;
            padding: 24px 20px 40px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .back-link {
            display: inline-flex;
            text-decoration: none;
        }

        .ghost-button,
        .primary-button,
        .secondary-button,
        .submit-button {
            border: none;
            border-radius: 999px;
            padding: 12px 18px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 700;
            transition: transform 0.18s ease, opacity 0.18s ease, box-shadow 0.18s ease;
        }

        .ghost-button:hover,
        .primary-button:hover,
        .secondary-button:hover,
        .submit-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 22px rgba(10, 18, 14, 0.18);
        }

        .ghost-button {
            background: rgba(255, 255, 255, 0.92);
            color: var(--ink);
            border: 1px solid rgba(27, 23, 20, 0.12);
        }

        .primary-button {
            background: var(--forest);
            color: var(--cream);
        }

        .secondary-button {
            background: rgba(255, 255, 255, 0.94);
            color: var(--forest);
            border: 1px solid rgba(23, 71, 52, 0.22);
        }

        .submit-button {
            background: var(--casino-red);
            color: var(--cream);
        }

        .reset-button {
            padding-inline: 14px;
            background: rgba(255, 255, 255, 0.82);
            color: var(--muted);
            border: 1px solid rgba(27, 23, 20, 0.1);
        }

        button:disabled {
            cursor: not-allowed;
            opacity: 0.48;
            transform: none;
            box-shadow: none;
        }

        .hero {
            display: grid;
            grid-template-columns: minmax(0, 1.2fr) minmax(320px, 0.8fr);
            gap: 20px;
            align-items: stretch;
            margin-bottom: 20px;
        }

        .hero-panel,
        .hero-side,
        .stat-card,
        .machine-card,
        .panel,
        .status-panel {
            background: var(--panel);
            color: var(--ink);
            border: 1px solid rgba(31, 27, 23, 0.06);
            border-radius: 24px;
            box-shadow: var(--shadow);
        }

        .hero-panel {
            padding: 28px;
            position: relative;
            overflow: hidden;
        }

        .hero-panel::after {
            content: "";
            position: absolute;
            inset: auto -70px -70px auto;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(241, 196, 83, 0.28), transparent 70%);
            pointer-events: none;
        }

        .hero-side {
            padding: 24px;
            background: linear-gradient(180deg, var(--panel-strong) 0%, rgba(242, 232, 214, 0.96) 100%);
        }

        .eyebrow {
            margin: 0 0 8px;
            text-transform: uppercase;
            letter-spacing: 0.18em;
            font-size: 12px;
            font-weight: 800;
            color: #6f5c34;
        }

        h1,
        h2,
        h3 {
            font-family: Georgia, "Times New Roman", serif;
            letter-spacing: 0.01em;
        }

        h1 {
            margin: 0 0 12px;
            font-size: clamp(2rem, 3vw, 3.3rem);
            line-height: 1.02;
        }

        .hero-text {
            margin: 0;
            max-width: 750px;
            font-size: 1.05rem;
            line-height: 1.65;
            color: #3d3428;
        }

        .callout-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-top: 20px;
        }

        .callout {
            padding: 14px 16px;
            border-radius: 18px;
            background: rgba(23, 71, 52, 0.08);
        }

        .callout strong {
            display: block;
            margin-bottom: 4px;
        }

        .callout p,
        .hero-side p,
        .hero-side li {
            margin: 0;
            line-height: 1.55;
            color: #3d3428;
        }

        .hero-side h2 {
            margin: 0 0 12px;
            font-size: 1.45rem;
        }

        .hero-side ul {
            margin: 0;
            padding-left: 18px;
        }

        .formula-box {
            margin-top: 16px;
            padding: 14px 16px;
            border-radius: 18px;
            background: rgba(241, 196, 83, 0.18);
            font-family: "SFMono-Regular", Consolas, monospace;
            font-size: 0.92rem;
            line-height: 1.55;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: 1.25fr 1.25fr 1.15fr repeat(4, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 18px;
        }

        .stat-card {
            padding: 16px 18px;
        }

        .stat-card.featured {
            position: relative;
            overflow: hidden;
            border: none;
        }

        .stat-card.featured::after {
            content: "";
            position: absolute;
            inset: auto -20px -40px auto;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.12), transparent 70%);
            pointer-events: none;
        }

        .stat-card.featured.round-card {
            background: linear-gradient(135deg, var(--machine-black) 0%, #2a231f 100%);
            color: var(--cream);
        }

        .stat-card.featured.pulls-card {
            background: linear-gradient(135deg, var(--forest) 0%, #235740 100%);
            color: var(--cream);
        }

        .stat-card.featured.timer-card {
            background: linear-gradient(135deg, var(--casino-red) 0%, #8e2e22 100%);
            color: var(--cream);
        }

        .stat-label {
            font-size: 0.78rem;
            font-weight: 800;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #6f5c34;
        }

        .stat-value {
            margin-top: 8px;
            font-size: clamp(1.35rem, 2vw, 2.15rem);
            font-weight: 800;
            color: #173b2b;
        }

        .stat-note {
            margin-top: 6px;
            color: #5a4c39;
            font-size: 0.92rem;
        }

        .stat-card.featured .stat-label,
        .stat-card.featured .stat-note {
            color: rgba(255, 253, 248, 0.82);
        }

        .stat-card.featured .stat-value {
            font-size: clamp(2rem, 3.4vw, 3.3rem);
            color: var(--cream);
            line-height: 1;
        }

        .stat-card.featured .stat-note {
            font-size: 1rem;
            line-height: 1.45;
            max-width: 20ch;
        }

        .status-panel {
            padding: 18px 20px;
            margin-bottom: 18px;
            display: grid;
            grid-template-columns: minmax(0, 1.2fr) minmax(300px, 0.8fr);
            gap: 18px;
            align-items: stretch;
        }

        .status-main {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .status-eyebrow {
            margin: 0 0 8px;
            font-size: 0.8rem;
            font-weight: 800;
            letter-spacing: 0.11em;
            text-transform: uppercase;
            color: #8a6f2b;
        }

        .status-message {
            font-size: 1.08rem;
            line-height: 1.6;
            color: #2b241d;
            margin-bottom: 14px;
        }

        .progress-track {
            width: 100%;
            height: 14px;
            border-radius: 999px;
            overflow: hidden;
            background: rgba(23, 71, 52, 0.12);
        }

        .progress-fill {
            width: 0;
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #2e8d5a 0%, #f1c453 100%);
            transition: width 0.25s ease;
        }

        .status-side {
            display: grid;
            gap: 12px;
        }

        .status-mini {
            padding: 14px 16px;
            border-radius: 18px;
            background: rgba(23, 71, 52, 0.06);
        }

        .status-mini-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #6f5c34;
        }

        .status-mini-value {
            margin-top: 6px;
            font-size: 1.08rem;
            font-weight: 800;
            color: #173b2b;
        }

        .status-mini-text {
            margin-top: 6px;
            color: #4d4030;
            font-size: 0.92rem;
            line-height: 1.5;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            gap: 18px;
            align-items: end;
            margin-bottom: 14px;
        }

        .section-header h2 {
            margin: 0;
            color: var(--ink);
            font-size: 1.7rem;
        }

        .section-header p {
            margin: 0;
            color: #4f463d;
            max-width: 700px;
            line-height: 1.55;
        }

        .machines-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 18px;
        }

        .machine-card {
            padding: 18px;
            position: relative;
            overflow: hidden;
            background: linear-gradient(180deg, var(--casino-red) 0%, var(--casino-red-deep) 48%, #311613 48%, var(--machine-black) 100%);
            border: 3px solid rgba(241, 196, 83, 0.72);
            box-shadow: 0 18px 34px rgba(76, 25, 16, 0.18);
        }

        .machine-card.best-guess {
            box-shadow: 0 22px 38px rgba(118, 84, 16, 0.26);
        }

        .machine-marquee {
            display: grid;
            grid-template-columns: repeat(10, minmax(0, 1fr));
            gap: 8px;
            margin-bottom: 14px;
        }

        .machine-light {
            height: 12px;
            border-radius: 999px;
            background: var(--gold);
            box-shadow: 0 0 10px rgba(241, 196, 83, 0.9);
            animation: marqueePulse 1.4s infinite ease-in-out;
        }

        .machine-light:nth-child(3n) {
            background: #fff4ca;
        }

        .machine-light:nth-child(2n) {
            animation-delay: 0.35s;
        }

        .machine-light:nth-child(4n) {
            background: #f48c74;
            box-shadow: 0 0 10px rgba(244, 140, 116, 0.86);
            animation-delay: 0.7s;
        }

        .machine-body {
            padding: 14px;
            border-radius: 22px;
            background: linear-gradient(180deg, rgba(255, 245, 227, 0.16) 0%, rgba(255, 255, 255, 0.05) 100%);
            border: 1px solid rgba(255, 229, 163, 0.3);
        }

        .machine-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.76rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            background: rgba(255, 238, 193, 0.18);
            color: var(--gold-soft);
            border: 1px solid rgba(255, 233, 173, 0.26);
        }

        .machine-title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .machine-title {
            margin: 0;
            font-size: 1.35rem;
            color: var(--cream);
        }

        .machine-token {
            padding: 5px 10px;
            border-radius: 999px;
            background: rgba(0, 0, 0, 0.24);
            color: rgba(255, 253, 248, 0.88);
            font-size: 0.82rem;
            font-weight: 700;
        }

        .machine-window {
            padding: 14px;
            border-radius: 18px;
            background: linear-gradient(180deg, #141413 0%, #102a20 100%);
            border: 2px solid rgba(241, 196, 83, 0.5);
            box-shadow: inset 0 0 20px rgba(0, 0, 0, 0.35);
            margin-bottom: 14px;
        }

        .posterior-label {
            margin: 0 0 8px;
            font-size: 0.92rem;
            color: rgba(255, 253, 248, 0.72);
        }

        .posterior-number {
            font-size: 2.2rem;
            font-weight: 800;
            color: #f8f4da;
            line-height: 1;
            margin-bottom: 10px;
            text-shadow: 0 0 10px rgba(241, 196, 83, 0.22);
        }

        .interval-track {
            position: relative;
            height: 14px;
            border-radius: 999px;
            background: rgba(23, 71, 52, 0.12);
            overflow: hidden;
        }

        .interval-range {
            position: absolute;
            top: 0;
            height: 100%;
            border-radius: 999px;
            background: rgba(45, 110, 163, 0.32);
        }

        .mean-fill {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, rgba(42, 157, 91, 0.8) 0%, rgba(241, 196, 83, 0.9) 100%);
        }

        .mean-marker {
            position: absolute;
            top: -3px;
            width: 3px;
            height: 20px;
            border-radius: 999px;
            background: #173b2b;
        }

        .interval-caption {
            margin-top: 8px;
            font-size: 0.88rem;
            color: rgba(255, 253, 248, 0.72);
        }

        .machine-stats {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin-top: 14px;
        }

        .mini-stat {
            padding: 10px 12px;
            border-radius: 14px;
            background: rgba(255, 250, 240, 0.12);
        }

        .mini-stat-label {
            display: block;
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.09em;
            color: rgba(255, 241, 207, 0.72);
        }

        .mini-stat-value {
            margin-top: 6px;
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--cream);
        }

        .history-strip {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 4px;
            margin-top: 14px;
        }

        .history-chip {
            height: 14px;
            border-radius: 999px;
            background: rgba(23, 71, 52, 0.1);
        }

        .history-chip.win {
            background: var(--win);
        }

        .history-chip.loss {
            background: var(--loss);
        }

        .history-chip.empty {
            background: rgba(255, 250, 240, 0.12);
        }

        .machine-footer {
            margin-top: 12px;
            min-height: 2.8em;
            font-size: 0.92rem;
            line-height: 1.45;
            color: rgba(255, 253, 248, 0.84);
        }

        .truth-row {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px dashed rgba(255, 241, 207, 0.32);
            font-size: 0.92rem;
            color: var(--gold-soft);
            font-weight: 700;
        }

        .machine-action {
            width: 100%;
            margin-top: 16px;
            background: linear-gradient(180deg, var(--gold) 0%, #d8a833 100%);
            color: var(--machine-black);
            border: 1px solid rgba(255, 239, 189, 0.44);
        }

        .controls {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 8px;
        }

        .action-hint {
            margin: 0 0 18px;
            color: #4d4030;
            line-height: 1.6;
            font-size: 0.98rem;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.15fr) minmax(320px, 0.85fr);
            gap: 18px;
            margin-bottom: 18px;
        }

        .panel {
            padding: 22px;
        }

        .panel h2 {
            margin: 0 0 14px;
            font-size: 1.5rem;
            color: #173b2b;
        }

        .empty-message {
            margin: 0;
            color: #5a4c39;
            line-height: 1.6;
        }

        .report-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .report-card {
            padding: 14px;
            border-radius: 18px;
            background: rgba(23, 71, 52, 0.06);
        }

        .report-label {
            display: block;
            font-size: 0.74rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #6f5c34;
        }

        .report-value {
            margin-top: 6px;
            font-size: 1.15rem;
            font-weight: 800;
            color: #173b2b;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.96);
        }

        th,
        td {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid rgba(23, 71, 52, 0.08);
        }

        td {
            color: #211912;
            font-weight: 600;
        }

        th {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #6f5c34;
            background: rgba(23, 71, 52, 0.08);
        }

        tbody tr:nth-child(odd) {
            background: rgba(255, 248, 237, 0.95);
        }

        tbody tr:nth-child(even) {
            background: rgba(247, 240, 228, 0.95);
        }

        tbody tr.best-row {
            background: rgba(241, 196, 83, 0.18);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .notes-stack {
            display: grid;
            gap: 12px;
        }

        .note-card {
            padding: 16px;
            border-radius: 18px;
            background: rgba(23, 71, 52, 0.06);
        }

        .note-card h3 {
            margin: 0 0 8px;
            font-size: 1.12rem;
            color: #173b2b;
        }

        .note-card p {
            margin: 0;
            color: #4d4030;
            line-height: 1.6;
        }

        .leaderboard-panel iframe {
            width: 100%;
            height: 400px;
            border: none;
            border-radius: 18px;
            background: white;
        }

        .leaderboard-copy {
            margin-top: 0;
            margin-bottom: 12px;
            color: #4d4030;
            line-height: 1.6;
        }

        .leaderboard-columns {
            margin-bottom: 16px;
            padding: 12px 14px;
            border-radius: 16px;
            background: rgba(23, 71, 52, 0.06);
            color: #4d4030;
            line-height: 1.55;
        }

        @keyframes marqueePulse {
            0%, 100% {
                opacity: 0.42;
                transform: scale(0.92);
            }
            50% {
                opacity: 1;
                transform: scale(1);
            }
        }

        @media (max-width: 1100px) {
            .stats-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .machines-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .dashboard-grid,
            .hero {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 760px) {
            .page-shell {
                padding: 18px 14px 32px;
            }

            .stats-grid,
            .machines-grid,
            .report-grid {
                grid-template-columns: 1fr;
            }

            .top-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .status-panel {
                grid-template-columns: 1fr;
            }

            .callout-grid {
                grid-template-columns: 1fr;
            }

            .machine-stats {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</head>
<body>
    <main class="page-shell">
        <div class="top-bar">
            <a href="/pages/demos.html" class="back-link">
                <button class="ghost-button" type="button">Back to Demos</button>
            </a>
            <button class="reset-button" type="button" id="restart-btn">Reset Tournament</button>
        </div>

        <section class="hero">
            <div class="hero-panel">
                <p class="eyebrow">DSC 40A in-class game</p>
                <h1>Multi-Armed Bandit Tournament</h1>
                <p class="hero-text">
                    Each round has four shuffled slot machines with different hidden payout rates. Your job is to learn quickly, update your beliefs after every pull, and then exploit the strongest machine before the round ends. The leaderboard should rank students by <strong>Skill Score</strong>, which rewards choosing strong machines across the full tournament, not just getting lucky in one round.
                </p>

                <div class="callout-grid">
                    <div class="callout">
                        <strong>Bayesian intuition</strong>
                        <p>Every win adds evidence that a machine might be good. Every loss adds evidence that it might not be. Early on, uncertainty is wide, so a single outcome should move you a little, not all the way.</p>
                    </div>
                    <div class="callout">
                        <strong>Why the old exploit breaks</strong>
                        <p>Arm labels reshuffle every round, and your leaderboard score tracks the quality of the hidden probabilities you chose. Repeating the same button no longer produces a strong score.</p>
                    </div>
                </div>
            </div>

            <div class="hero-side">
                <h2>How scoring works</h2>
                <ul>
                    <li><strong>Round Reward</strong> is the noisy part: how many wins you actually saw in one round.</li>
                    <li><strong>Skill Score</strong> is the main score: how strong your choices were across the tournament.</li>
                    <li>Each round lasts at most five minutes, so you need to explore early and commit before the timer locks the machines.</li>
                </ul>

                <div class="formula-box">
                    Start by treating every machine as a 50/50 guess.<br>
                    Every win nudges your estimate up. Every loss nudges it down.<br>
                    Quick update rule: (wins + 1) / (wins + losses + 2)<br>
                    Example: 3 wins and 1 loss gives 4 / 6 = 66.7%<br>
                    Skill Score = 100 x (sum of true probabilities you chose) / (sum of best available probabilities)
                </div>
            </div>
        </section>

        <section class="stats-grid">
            <div class="stat-card featured round-card">
                <div class="stat-label">Round</div>
                <div class="stat-value" id="round-stat">1 / 6</div>
                <div class="stat-note" id="round-note">Tournament just started</div>
            </div>
            <div class="stat-card featured pulls-card">
                <div class="stat-label">Pulls Left</div>
                <div class="stat-value" id="pulls-left-stat">12</div>
                <div class="stat-note" id="pulls-left-note">Use all 12 before the next round unlocks</div>
            </div>
            <div class="stat-card featured timer-card">
                <div class="stat-label">Time Left</div>
                <div class="stat-value" id="timer-stat">5:00</div>
                <div class="stat-note" id="timer-note">When the timer hits 0, the machines lock</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Machines Tested</div>
                <div class="stat-value" id="sampled-stat">0</div>
                <div class="stat-note">How many different machines you have tried this round</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Round Reward</div>
                <div class="stat-value" id="round-reward-stat">0</div>
                <div class="stat-note" id="round-reward-note">How many wins you got in this round</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Tournament Reward</div>
                <div class="stat-value" id="tournament-reward-stat">0</div>
                <div class="stat-note">How many wins you have across all rounds so far</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Skill Score</div>
                <div class="stat-value" id="skill-score-stat">0.0</div>
                <div class="stat-note">This is the overall leaderboard score</div>
            </div>
        </section>

        <section class="status-panel">
            <div class="status-main">
                <p class="status-eyebrow">What To Do Now</p>
                <div class="status-message" id="status-message">
                    Start by sampling several machines. The wide uncertainty bands show that your prior is still broad.
                </div>
                <div class="progress-track" aria-hidden="true">
                    <div class="progress-fill" id="progress-fill"></div>
                </div>
            </div>
            <div class="status-side">
                <div class="status-mini">
                    <span class="status-mini-label">Submission Code</span>
                    <div class="status-mini-value" id="run-id-pill">MAB-XXXX-XXXX</div>
                    <div class="status-mini-text">This identifies your tournament run. It gets copied together with your final score.</div>
                </div>
                <div class="status-mini">
                    <span class="status-mini-label">Current Best Guess</span>
                    <div class="status-mini-value" id="best-guess-pill">No evidence yet</div>
                    <div class="status-mini-text">Early guesses are weak. Once uncertainty narrows, this becomes more meaningful.</div>
                </div>
            </div>
        </section>

        <section class="section-header">
            <div>
                <h2>Casino Floor</h2>
                <p>
                    Click a machine to pull it. The big number is your current posterior mean. The blue band is a rough plausible range. Wide band means "you still do not know much yet."
                </p>
            </div>
        </section>

        <section class="machines-grid" id="machines-container">
            <!-- Machines rendered by JavaScript -->
        </section>

        <section class="controls">
            <button class="primary-button" type="button" id="start-round-btn">Start Round</button>
            <button class="secondary-button" type="button" id="next-round-btn" disabled>Next Round</button>
            <button class="secondary-button" type="button" id="copy-summary-btn" disabled>Copy Final Submission Line</button>
            <button class="submit-button" type="button" id="submit-btn" disabled>Open Submission Form</button>
        </section>
        <p class="action-hint" id="action-hint">
            Press Start Round to begin the 5:00 timer. Submit unlocks only after Round 6.
        </p>

        <section class="dashboard-grid">
            <div class="panel">
                <h2>Round Report (This Round Only)</h2>
                <div id="round-report">
                    <p class="empty-message">Finish a round to reveal the true machine probabilities, compare your posterior beliefs to reality, and see whether your exploration paid off.</p>
                </div>
            </div>

            <div class="panel">
                <h2>Bayes Coach</h2>
                <div class="notes-stack" id="notes-stack">
                    <!-- Notes rendered by JavaScript -->
                </div>
            </div>
        </section>

        <section class="panel leaderboard-panel">
            <h2>Leaderboard</h2>
            <p class="leaderboard-copy">
                Students submit only after the tournament is complete. The form should record the final <strong>Skill Score</strong>, the raw reward, and the submission code from the copied line.
            </p>
            <div class="leaderboard-columns">
                <strong>Suggested columns for the reset leaderboard:</strong> student name, skill score, raw reward, submission code, and optionally section or timestamp.
            </div>
            <iframe src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQiAvSqrGGicKy8jEBTbBq9lCiODEbedf_5IA4bYoZkt6znsaXT_HEE-ZE1cE8tg7LB3-zOcbajjo-E/pubhtml?gid=1620723654&amp;single=true&amp;widget=true&amp;headers=false" title="Leaderboard"></iframe>
        </section>
    </main>

    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const NUM_MACHINES = 4;
            const ROUNDS_PER_TOURNAMENT = 6;
            const PULLS_PER_ROUND = 12;
            const ROUND_TIME_SECONDS = 5 * 60;
            const SUBMIT_URL = 'https://forms.gle/8g72dNxaEcSra1JN6';
            const ROUND_TEMPLATES = [
                [0.18, 0.31, 0.56, 0.74],
                [0.22, 0.37, 0.48, 0.69],
                [0.15, 0.28, 0.61, 0.72],
                [0.25, 0.34, 0.53, 0.67],
                [0.19, 0.42, 0.47, 0.71],
                [0.12, 0.33, 0.58, 0.76],
                [0.21, 0.39, 0.51, 0.64],
                [0.17, 0.30, 0.55, 0.70]
            ];

            const elements = {
                machinesContainer: document.getElementById('machines-container'),
                roundStat: document.getElementById('round-stat'),
                roundNote: document.getElementById('round-note'),
                pullsLeftStat: document.getElementById('pulls-left-stat'),
                pullsLeftNote: document.getElementById('pulls-left-note'),
                timerStat: document.getElementById('timer-stat'),
                timerNote: document.getElementById('timer-note'),
                sampledStat: document.getElementById('sampled-stat'),
                roundRewardStat: document.getElementById('round-reward-stat'),
                roundRewardNote: document.getElementById('round-reward-note'),
                tournamentRewardStat: document.getElementById('tournament-reward-stat'),
                skillScoreStat: document.getElementById('skill-score-stat'),
                runIdPill: document.getElementById('run-id-pill'),
                bestGuessPill: document.getElementById('best-guess-pill'),
                statusMessage: document.getElementById('status-message'),
                progressFill: document.getElementById('progress-fill'),
                roundReport: document.getElementById('round-report'),
                notesStack: document.getElementById('notes-stack'),
                restartBtn: document.getElementById('restart-btn'),
                startRoundBtn: document.getElementById('start-round-btn'),
                nextRoundBtn: document.getElementById('next-round-btn'),
                copySummaryBtn: document.getElementById('copy-summary-btn'),
                submitBtn: document.getElementById('submit-btn'),
                actionHint: document.getElementById('action-hint')
            };

            let tournament = null;
            let reportRoundIndex = null;
            let latestOutcome = null;
            let roundTimerId = null;

            function createRunId() {
                const seed = new Uint32Array(2);
                window.crypto.getRandomValues(seed);
                const left = seed[0].toString(36).slice(-4).toUpperCase();
                const right = seed[1].toString(36).slice(-4).toUpperCase();
                return `MAB-${left}-${right}`;
            }

            function shuffleArray(items) {
                const copy = [...items];
                for (let i = copy.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [copy[i], copy[j]] = [copy[j], copy[i]];
                }
                return copy;
            }

            function createMachineStat() {
                return {
                    plays: 0,
                    wins: 0,
                    successes: 1,
                    failures: 1
                };
            }

            function createRound(template, roundNumber) {
                const machineProbs = shuffleArray(template);
                const bestProb = Math.max(...machineProbs);
                const bestMachineId = machineProbs.indexOf(bestProb);

                return {
                    roundNumber,
                    machineProbs,
                    bestProb,
                    bestMachineId,
                    pullsLeft: PULLS_PER_ROUND,
                    reward: 0,
                    expectedReward: 0,
                    oracleExpected: 0,
                    skillScore: 0,
                    regret: 0,
                    started: false,
                    finished: false,
                    endReason: null,
                    secondsLeft: ROUND_TIME_SECONDS,
                    deadlineAt: null,
                    stats: Array.from({ length: NUM_MACHINES }, () => createMachineStat()),
                    history: Array.from({ length: NUM_MACHINES }, () => []),
                    actionLog: []
                };
            }

            function createTournament() {
                const chosenTemplates = shuffleArray(ROUND_TEMPLATES).slice(0, ROUNDS_PER_TOURNAMENT);
                return {
                    runId: createRunId(),
                    roundIndex: 0,
                    completed: false,
                    totalReward: 0,
                    totalExpectedReward: 0,
                    totalOracleExpected: 0,
                    rounds: chosenTemplates.map((template, index) => createRound(template, index + 1))
                };
            }

            function getCurrentRound() {
                return tournament.rounds[tournament.roundIndex];
            }

            function formatPercent(value, digits = 1) {
                return `${(value * 100).toFixed(digits)}%`;
            }

            function formatSkill(value) {
                return value.toFixed(1);
            }

            function posteriorSummary(stat) {
                const alpha = stat.successes;
                const beta = stat.failures;
                const mean = alpha / (alpha + beta);
                const variance = (alpha * beta) / (((alpha + beta) ** 2) * (alpha + beta + 1));
                const spread = 1.96 * Math.sqrt(variance);
                return {
                    mean,
                    low: Math.max(0, mean - spread),
                    high: Math.min(1, mean + spread)
                };
            }

            function getRoundSampledCount(round) {
                return round.stats.filter((stat) => stat.plays > 0).length;
            }

            function getExplorationState(round) {
                const sampledCount = getRoundSampledCount(round);
                const pullsTaken = PULLS_PER_ROUND - round.pullsLeft;
                const inExploration = round.started && !round.finished && pullsTaken < NUM_MACHINES && sampledCount < NUM_MACHINES;
                return {
                    sampledCount,
                    pullsTaken,
                    inExploration,
                    remainingRequiredSamples: Math.max(0, NUM_MACHINES - sampledCount)
                };
            }

            function getBestGuess(round) {
                let bestMachineId = 0;
                let bestMean = -1;

                for (let i = 0; i < NUM_MACHINES; i++) {
                    const mean = posteriorSummary(round.stats[i]).mean;
                    if (mean > bestMean) {
                        bestMean = mean;
                        bestMachineId = i;
                    }
                }

                return {
                    bestMachineId,
                    bestMean
                };
            }

            function getMostPlayedMachine(round) {
                let machineId = 0;
                let plays = 0;

                round.stats.forEach((stat, index) => {
                    if (stat.plays > plays) {
                        plays = stat.plays;
                        machineId = index;
                    }
                });

                return { machineId, plays };
            }

            function setStatus(message) {
                elements.statusMessage.textContent = message;
            }

            function isRoundPlayable(round) {
                return round.started && !round.finished && !tournament.completed;
            }

            function formatCountdown(totalSeconds) {
                const minutes = Math.floor(totalSeconds / 60);
                const seconds = totalSeconds % 60;
                return `${minutes}:${seconds.toString().padStart(2, '0')}`;
            }

            function getSecondsRemaining(round) {
                if (round.finished) {
                    return round.secondsLeft;
                }

                if (!round.deadlineAt) {
                    return round.secondsLeft;
                }

                const remaining = Math.ceil((round.deadlineAt - Date.now()) / 1000);
                return Math.max(0, remaining);
            }

            function stopRoundTimer() {
                if (roundTimerId !== null) {
                    window.clearInterval(roundTimerId);
                    roundTimerId = null;
                }
            }

            function startRoundTimer() {
                stopRoundTimer();

                const round = getCurrentRound();
                if (!round.started || round.finished || tournament.completed) {
                    return;
                }

                round.deadlineAt = Date.now() + (round.secondsLeft * 1000);
                roundTimerId = window.setInterval(() => {
                    const activeRound = getCurrentRound();
                    const secondsLeft = getSecondsRemaining(activeRound);
                    activeRound.secondsLeft = secondsLeft;
                    updateStats();

                    if (secondsLeft <= 0) {
                        finishRound('time');
                        updateStats();
                        renderMachines();
                        renderRoundReport();
                        renderNotes();
                    }
                }, 250);
            }

            function getTotalPullsTaken() {
                return tournament.rounds.reduce((sum, round) => sum + round.actionLog.length, 0);
            }

            function updateStats() {
                const round = getCurrentRound();
                const explorationState = getExplorationState(round);
                const sampledCount = explorationState.sampledCount;
                const pullsTakenThisRound = explorationState.pullsTaken;
                const bestGuess = getBestGuess(round);
                const skill = tournament.totalOracleExpected === 0
                    ? 0
                    : (100 * tournament.totalExpectedReward) / tournament.totalOracleExpected;
                const secondsLeft = getSecondsRemaining(round);
                round.secondsLeft = secondsLeft;

                elements.roundStat.textContent = `${round.roundNumber} / ${ROUNDS_PER_TOURNAMENT}`;
                elements.roundNote.textContent = !round.started
                    ? 'Press Start Round to begin the timer.'
                    : round.finished
                    ? (round.endReason === 'time'
                        ? 'Time is up. Review the reveal below.'
                        : 'Round complete. Review the reveal below.')
                    : explorationState.inExploration
                    ? `Exploration phase: sample each machine once. ${explorationState.remainingRequiredSamples} still required.`
                    : 'Use your pulls before the 5:00 timer runs out.';
                elements.pullsLeftStat.textContent = round.pullsLeft;
                elements.pullsLeftNote.textContent = !round.started
                    ? 'Pulls unlock when the round starts.'
                    : round.finished
                    ? (round.endReason === 'time'
                        ? 'Timer expired. Unused pulls are gone.'
                        : 'No pulls remain in this round.')
                    : explorationState.inExploration
                    ? 'Only unplayed machines are available right now.'
                    : 'These are the only pulls you have left this round.';
                elements.timerStat.textContent = formatCountdown(secondsLeft);
                elements.timerNote.textContent = !round.started
                    ? 'Timer begins when you click Start Round'
                    : round.finished
                    ? (round.endReason === 'time'
                        ? 'Machines are locked until you start the next round'
                        : 'You finished before time ran out')
                    : 'When the timer hits 0, the machines lock';
                elements.sampledStat.textContent = sampledCount;
                elements.roundRewardStat.textContent = round.reward;
                elements.roundRewardNote.textContent = round.finished
                    ? (round.endReason === 'time'
                        ? 'Visible reward before the timer expired'
                        : `Visible reward after ${PULLS_PER_ROUND} pulls`)
                    : 'How many wins you have actually seen';
                elements.tournamentRewardStat.textContent = tournament.totalReward;
                elements.skillScoreStat.textContent = formatSkill(skill);
                elements.runIdPill.textContent = tournament.runId;
                elements.bestGuessPill.textContent = sampledCount === 0
                    ? 'No evidence yet. Sample first.'
                    : `Machine ${bestGuess.bestMachineId + 1} looks best at ${formatPercent(bestGuess.bestMean)}`;

                const totalPulls = ROUNDS_PER_TOURNAMENT * PULLS_PER_ROUND;
                const progress = totalPulls === 0 ? 0 : (100 * getTotalPullsTaken()) / totalPulls;
                elements.progressFill.style.width = `${progress}%`;

                if (tournament.completed) {
                    elements.startRoundBtn.textContent = 'Start Round';
                    elements.startRoundBtn.disabled = true;
                    elements.nextRoundBtn.textContent = 'Tournament Complete';
                    elements.nextRoundBtn.disabled = true;
                    elements.copySummaryBtn.disabled = false;
                    elements.submitBtn.disabled = false;
                    elements.actionHint.textContent = 'Tournament finished. First copy the final submission line. Then open the form and paste it there.';
                } else if (!round.started) {
                    elements.startRoundBtn.textContent = `Start Round ${round.roundNumber}`;
                    elements.startRoundBtn.disabled = false;
                    elements.nextRoundBtn.textContent = 'Next Round';
                    elements.nextRoundBtn.disabled = true;
                    elements.copySummaryBtn.disabled = true;
                    elements.submitBtn.disabled = true;
                    elements.actionHint.textContent = 'Press Start Round to begin the 5:00 timer. Until then, the machines stay locked.';
                } else if (round.finished) {
                    elements.startRoundBtn.textContent = 'Start Round';
                    elements.startRoundBtn.disabled = true;
                    elements.nextRoundBtn.textContent = tournament.roundIndex === ROUNDS_PER_TOURNAMENT - 1 ? 'Finish Tournament' : 'Next Round';
                    elements.nextRoundBtn.disabled = false;
                    elements.copySummaryBtn.disabled = true;
                    elements.submitBtn.disabled = true;
                    elements.actionHint.textContent = tournament.roundIndex === ROUNDS_PER_TOURNAMENT - 1
                        ? 'One click remains: finish the tournament to unlock copying and submission.'
                        : 'Review the reveal below, then click Next Round when you are ready.';
                } else {
                    elements.startRoundBtn.textContent = 'Round In Progress';
                    elements.startRoundBtn.disabled = true;
                    elements.nextRoundBtn.textContent = 'Next Round';
                    elements.nextRoundBtn.disabled = true;
                    elements.copySummaryBtn.disabled = true;
                    elements.submitBtn.disabled = true;
                    elements.actionHint.textContent = explorationState.inExploration
                        ? 'First four pulls: sample each machine once. After that, choose freely until time or pulls run out.'
                        : 'Each round lasts 5:00. When time expires, the machines lock and only Next Round advances the game.';
                }
            }

            function renderLights() {
                return Array.from({ length: 10 }, () => '<span class="machine-light"></span>').join('');
            }

            function renderHistory(history) {
                const chips = [];
                for (let i = 0; i < PULLS_PER_ROUND; i++) {
                    if (i < history.length) {
                        chips.push(`<span class="history-chip ${history[i] ? 'win' : 'loss'}"></span>`);
                    } else {
                        chips.push('<span class="history-chip empty"></span>');
                    }
                }
                return chips.join('');
            }

            function renderMachines() {
                const round = getCurrentRound();
                const bestGuess = getBestGuess(round);
                const explorationState = getExplorationState(round);

                elements.machinesContainer.innerHTML = round.stats.map((stat, index) => {
                    const summary = posteriorSummary(stat);
                    const low = summary.low * 100;
                    const high = summary.high * 100;
                    const mean = summary.mean * 100;
                    const latest = round.history[index][round.history[index].length - 1];
                    const latestLabel = stat.plays === 0
                        ? 'No evidence yet. Start with a pull.'
                        : latest
                            ? 'Most recent pull paid out. That should increase your belief, but only a little if the sample is tiny.'
                            : 'Most recent pull missed. A single loss matters less when a machine already has a larger track record.';
                    const isBestGuess = index === bestGuess.bestMachineId;
                    const trueRateMarkup = round.finished
                        ? `<div class="truth-row">True payout rate: ${formatPercent(round.machineProbs[index], 0)}</div>`
                        : '';
                    const isPlayable = isRoundPlayable(round);
                    const needsSample = explorationState.inExploration && stat.plays === 0;
                    const blockedByExploration = explorationState.inExploration && stat.plays > 0;
                    const badgeText = needsSample
                        ? 'Required sample'
                        : blockedByExploration
                            ? 'Wait for all 4 samples'
                            : isBestGuess
                                ? 'Current best guess'
                                : 'Keep testing';
                    const buttonLabel = needsSample
                        ? `Required Pull: Machine ${index + 1}`
                        : `Pull Machine ${index + 1}`;

                    return `
                        <article class="machine-card ${isBestGuess ? 'best-guess' : ''}">
                            <div class="machine-marquee">${renderLights()}</div>
                            <div class="machine-body">
                                <span class="machine-badge">${badgeText}</span>
                                <div class="machine-title-row">
                                    <h3 class="machine-title">Machine ${index + 1}</h3>
                                    <span class="machine-token">${stat.plays} pulls</span>
                                </div>
                                <div class="machine-window">
                                    <p class="posterior-label">Posterior mean</p>
                                    <div class="posterior-number">${formatPercent(summary.mean)}</div>
                                    <div class="interval-track" aria-hidden="true">
                                        <div class="interval-range" style="left: ${low}%; width: ${Math.max(0, high - low)}%;"></div>
                                        <div class="mean-fill" style="width: ${mean}%;"></div>
                                        <div class="mean-marker" style="left: calc(${mean}% - 1.5px);"></div>
                                    </div>
                                    <div class="interval-caption">Plausible range: ${formatPercent(summary.low)} to ${formatPercent(summary.high)}</div>
                                </div>
                                <div class="machine-stats">
                                    <div class="mini-stat">
                                        <span class="mini-stat-label">Plays</span>
                                        <span class="mini-stat-value">${stat.plays}</span>
                                    </div>
                                    <div class="mini-stat">
                                        <span class="mini-stat-label">Wins</span>
                                        <span class="mini-stat-value">${stat.wins}</span>
                                    </div>
                                </div>
                                <div class="history-strip">${renderHistory(round.history[index])}</div>
                                <div class="machine-footer">${latestLabel}</div>
                                ${trueRateMarkup}
                                <button class="primary-button machine-action" type="button" data-machine="${index}" ${(isPlayable && !blockedByExploration) ? '' : 'disabled'}>${buttonLabel}</button>
                            </div>
                        </article>
                    `;
                }).join('');

                elements.machinesContainer.querySelectorAll('[data-machine]').forEach((button) => {
                    button.addEventListener('click', () => {
                        const machineId = Number(button.getAttribute('data-machine'));
                        playMachine(machineId);
                    });
                });
            }

            function renderRoundReport() {
                if (reportRoundIndex === null) {
                    elements.roundReport.innerHTML = '<p class="empty-message">Finish a round to reveal the true machine probabilities, compare your posterior beliefs to reality, and see whether your exploration paid off.</p>';
                    return;
                }

                const round = tournament.rounds[reportRoundIndex];
                const tableRows = round.stats.map((stat, index) => {
                    const summary = posteriorSummary(stat);
                    return `
                        <tr class="${index === round.bestMachineId ? 'best-row' : ''}">
                            <td>Machine ${index + 1}</td>
                            <td>${stat.plays}</td>
                            <td>${stat.wins}</td>
                            <td>${formatPercent(summary.mean)}</td>
                            <td>${formatPercent(round.machineProbs[index], 0)}</td>
                        </tr>
                    `;
                }).join('');

                elements.roundReport.innerHTML = `
                    <p class="empty-message" style="margin-bottom: 16px;">This panel is only for the most recent round. The real leaderboard score is the tournament Skill Score at the top of the page.</p>
                    <div class="report-grid">
                        <div class="report-card">
                            <span class="report-label">This Round Skill</span>
                            <div class="report-value">${formatSkill(round.skillScore)}</div>
                        </div>
                        <div class="report-card">
                            <span class="report-label">This Round Expected Reward</span>
                            <div class="report-value">${round.expectedReward.toFixed(2)}</div>
                        </div>
                        <div class="report-card">
                            <span class="report-label">This Round Oracle Benchmark</span>
                            <div class="report-value">${round.oracleExpected.toFixed(2)}</div>
                        </div>
                        <div class="report-card">
                            <span class="report-label">This Round Expected Regret</span>
                            <div class="report-value">${round.regret.toFixed(2)}</div>
                        </div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Machine</th>
                                <th>Your Pulls</th>
                                <th>Wins</th>
                                <th>Posterior Mean</th>
                                <th>True Rate</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tableRows}
                        </tbody>
                    </table>
                `;
            }

            function renderNotes() {
                const round = getCurrentRound();
                const explorationState = getExplorationState(round);
                const pullsTaken = explorationState.pullsTaken;
                const sampledCount = explorationState.sampledCount;
                const mostPlayed = getMostPlayedMachine(round);
                const concentration = pullsTaken === 0 ? 0 : mostPlayed.plays / pullsTaken;
                const bestGuess = getBestGuess(round);

                let exploreText = 'The first few pulls should go toward learning. If all uncertainty bands are still wide, you have not earned the right to exploit yet.';
                if (!round.started) {
                    exploreText = 'Before you start the round, plan the forced exploration phase. Your first four pulls must cover all four machines, then you can exploit.';
                } else if (explorationState.inExploration) {
                    exploreText = `Exploration phase is active. You still need to sample ${explorationState.remainingRequiredSamples} machine${explorationState.remainingRequiredSamples === 1 ? '' : 's'} before free choice unlocks.`;
                } else if (!round.finished && pullsTaken >= 4 && sampledCount <= 2) {
                    exploreText = `You have sampled only ${sampledCount} machines in ${pullsTaken} pulls. Since the labels reshuffle every round, that is probably too little evidence.`;
                } else if (!round.finished && pullsTaken >= 6 && concentration > 0.65) {
                    exploreText = `Machine ${mostPlayed.machineId + 1} has ${Math.round(concentration * 100)}% of your pulls so far. That can be correct, but only if its posterior mean is clearly ahead and its uncertainty band is no longer wide.`;
                } else if (!round.finished && pullsTaken >= 5 && sampledCount > 0) {
                    exploreText = `Machine ${bestGuess.bestMachineId + 1} currently has the strongest posterior mean at ${formatPercent(bestGuess.bestMean)}. If that machine also has a narrowing uncertainty band, exploiting starts to make sense.`;
                } else if (round.finished) {
                    exploreText = `Round ${round.roundNumber} is done. Compare the posterior means to the revealed true rates below. The goal is not perfect certainty, but a good decision before time runs out.`;
                }

                let updateText = 'A single win should move your belief up, but not too far. With few pulls, the prior still has a lot of weight.';
                if (!round.started) {
                    updateText = 'Nothing has been observed yet in this round. Before you click Start Round, think about how much evidence you want before trusting a machine.';
                } else if (explorationState.inExploration) {
                    updateText = 'During the first four pulls, the point is not to win immediately. The point is to get one data point from every arm so Bayes has something to update.';
                } else if (latestOutcome) {
                    updateText = latestOutcome;
                }

                const mathText = 'If you want a quick by-hand update rule, start every machine at 50%. After w wins and l losses, update it to (w + 1) / (w + l + 2). More wins push the estimate up. More losses push it down.';

                elements.notesStack.innerHTML = `
                    <div class="note-card">
                        <h3>Explore vs exploit</h3>
                        <p>${exploreText}</p>
                    </div>
                    <div class="note-card">
                        <h3>What Bayes is saying</h3>
                        <p>${updateText}</p>
                    </div>
                    <div class="note-card">
                        <h3>If you want a quick update rule</h3>
                        <p>${mathText}</p>
                    </div>
                `;
            }

            function finishRound(reason = 'pulls') {
                const round = getCurrentRound();
                if (round.finished) {
                    return;
                }

                stopRoundTimer();
                round.endReason = reason;
                round.secondsLeft = reason === 'time' ? 0 : getSecondsRemaining(round);
                round.finished = true;
                round.skillScore = round.oracleExpected === 0
                    ? 0
                    : (100 * round.expectedReward) / round.oracleExpected;
                round.regret = round.oracleExpected - round.expectedReward;
                reportRoundIndex = tournament.roundIndex;

                if (tournament.roundIndex === ROUNDS_PER_TOURNAMENT - 1) {
                    tournament.completed = true;
                    setStatus(`Tournament complete. Your final Skill Score is ${formatSkill((100 * tournament.totalExpectedReward) / tournament.totalOracleExpected)}. Copy the final submission line, then open the form.`);
                } else if (reason === 'time') {
                    setStatus(`Time is up for Round ${round.roundNumber}. The machines are locked. Review the reveal, then click Next Round.`);
                } else {
                    setStatus(`Round ${round.roundNumber} complete. The true rates are now revealed so you can compare your posterior beliefs with reality before moving on.`);
                }
            }

            function playMachine(machineId) {
                const round = getCurrentRound();
                if (!isRoundPlayable(round)) {
                    return;
                }

                const isWin = Math.random() < round.machineProbs[machineId];
                const stat = round.stats[machineId];
                stat.plays += 1;
                round.actionLog.push(machineId);
                round.history[machineId].push(isWin);
                round.expectedReward += round.machineProbs[machineId];
                round.oracleExpected += round.bestProb;
                tournament.totalExpectedReward += round.machineProbs[machineId];
                tournament.totalOracleExpected += round.bestProb;
                round.pullsLeft -= 1;

                if (isWin) {
                    stat.wins += 1;
                    stat.successes += 1;
                    round.reward += 1;
                    tournament.totalReward += 1;
                    latestOutcome = `Machine ${machineId + 1} just paid out. The posterior for that arm should rise, but if it has only a few pulls, the uncertainty should still stay wide.`;
                    setStatus(`Machine ${machineId + 1} paid out. Update the posterior, then decide whether that was enough evidence to keep leaning into it.`);
                } else {
                    stat.failures += 1;
                    latestOutcome = `Machine ${machineId + 1} just missed. That lowers the posterior mean, but a single miss should not erase a longer history of success.`;
                    setStatus(`Machine ${machineId + 1} missed. Ask whether this was a meaningful signal or just one noisy observation.`);
                }

                if (round.pullsLeft === 0) {
                    finishRound('pulls');
                }

                updateStats();
                renderMachines();
                renderRoundReport();
                renderNotes();
            }

            function nextRound() {
                if (tournament.completed) {
                    return;
                }

                const round = getCurrentRound();
                if (!round.finished) {
                    setStatus('Finish the current round before moving on.');
                    return;
                }

                tournament.roundIndex += 1;
                latestOutcome = null;
                const next = getCurrentRound();
                setStatus(`Round ${next.roundNumber} is ready. Click Start Round when the class is ready to begin the next 5:00 window.`);
                updateStats();
                renderMachines();
                renderNotes();
            }

            function startRound() {
                if (tournament.completed) {
                    return;
                }

                const round = getCurrentRound();
                if (round.started || round.finished) {
                    return;
                }

                round.started = true;
                round.deadlineAt = null;
                latestOutcome = null;
                setStatus(`Round ${round.roundNumber} started. First, sample each machine once. After that, choose freely until time or pulls run out.`);
                startRoundTimer();
                updateStats();
                renderMachines();
                renderNotes();
            }

            function getSummaryText() {
                const skill = tournament.totalOracleExpected === 0
                    ? 0
                    : (100 * tournament.totalExpectedReward) / tournament.totalOracleExpected;
                const totalPulls = ROUNDS_PER_TOURNAMENT * PULLS_PER_ROUND;
                return `Submission code: ${tournament.runId} | Skill score: ${formatSkill(skill)} | Reward: ${tournament.totalReward}/${totalPulls} | Tournament: ${ROUNDS_PER_TOURNAMENT} rounds`;
            }

            async function copySummary() {
                if (!tournament.completed) {
                    setStatus('Finish the tournament before copying your score summary.');
                    return;
                }

                const summary = getSummaryText();
                try {
                    await navigator.clipboard.writeText(summary);
                    setStatus('Final submission line copied. Open the form and paste it there.');
                } catch (error) {
                    window.prompt('Copy this final submission line:', summary);
                }
            }

            function submitScore() {
                if (!tournament.completed) {
                    setStatus('Finish the tournament before submitting your score.');
                    return;
                }

                window.open(SUBMIT_URL, '_blank', 'noopener,noreferrer');
            }

            function restartTournament() {
                if (tournament && getTotalPullsTaken() > 0 && !tournament.completed) {
                    const shouldReset = window.confirm('Reset this tournament and lose the current run?');
                    if (!shouldReset) {
                        return;
                    }
                }

                tournament = createTournament();
                reportRoundIndex = null;
                latestOutcome = null;
                stopRoundTimer();
                setStatus('New tournament ready. Click Start Round to begin Round 1. The first four pulls must cover all four machines.');
                updateStats();
                renderMachines();
                renderRoundReport();
                renderNotes();
            }

            elements.restartBtn.addEventListener('click', restartTournament);
            elements.startRoundBtn.addEventListener('click', startRound);
            elements.nextRoundBtn.addEventListener('click', nextRound);
            elements.copySummaryBtn.addEventListener('click', copySummary);
            elements.submitBtn.addEventListener('click', submitScore);

            restartTournament();
        });
    </script>
</body>
</html>
