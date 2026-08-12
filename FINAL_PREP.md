# 🏁 Mira AI: Launch Guide

The application is built completely with React, TypeScript, Vite, and Three.js (React Three Fiber).

### 1. Neural Core & HUD
The UI features a futuristic desktop interface:
- **Particle Field / Neural Core**: Renders ambient 3D visual effects using `@react-three/fiber` and `@react-three/postprocessing`.
- **System Monitor & Control Deck**: Real-time telemetry, memory buffer indicators, and control shortcuts.
- **Neural Feed Stream**: Real-time streaming assistant feed and interactive prompt terminal.

### 2. Running Mira AI:
Run the following command from the project root:

```bash
npm start
```

This launches both the local LLM bridge server and the React frontend concurrently.

