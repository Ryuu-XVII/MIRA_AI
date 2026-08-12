# Mira AI

Mira AI is an experimental desktop-style AI companion interface built with React, TypeScript, and Vite. It pairs a 3D-driven ambient HUD interface with a local Node.js bridge backend that routes requests to local LLMs (LM Studio local server) with automatic fallback capabilities.

## 🚀 Key Features

- **Futuristic 3D HUD & Terminal**: Ambient Three.js particle field with dynamic reactivity and bloom visual effects via `@react-three/fiber` and `@react-three/drei`.
- **Local AI Brain & Fallback**: Dual-layer LLM backend bridge connecting to LM Studio local server endpoint with fallback to local PS-Engine / Node Llama CPP routines.
- **Time-Aware Assistant & Voice Synthesis**: Dynamic time-of-day greetings and integrated speech synthesis (`VoiceService`) and speech recognition.
- **One-Click Startup Script**: Cleaned batch launcher (`mira.bat`) that checks process cleanup and launches the application concurrently.
- **State Management**: Powered by Zustand for responsive UI status updates and conversation context tracking.

## 🧰 Tech Stack

- **Frontend**: React 18, Vite, TypeScript, TailwindCSS
- **Visuals & 3D**: Three.js, `@react-three/fiber`, `@react-three/drei`
- **State**: Zustand
- **Backend / Bridge**: Node.js, Express, CORS, LM Studio Local Server API (`http://localhost:1234`), `node-llama-cpp`

## 🚀 Quick Start

### Prerequisites

- Node.js (v18+)
- [LM Studio](https://lmstudio.ai/) (Local Inference Server enabled on `http://localhost:1234`)

### Installation

Install all frontend and bridge dependencies:

```bash
npm install
```

### Running the App

To launch the full system (process cleanup, frontend + bridge):

```cmd
.\mira.bat
```

Alternatively, run via npm:

```bash
npm start
```

If you prefer running services in separate terminals:

```bash
# Terminal 1: Bridge Server (Port 3001)
npm run bridge

# Terminal 2: Vite Dev Server (Port 5173)
npm run dev
```

### Production Build

Build static artifacts:

```bash
npm run build
```

Preview production build:

```bash
npm run preview
```

## 🧭 Project Structure

```
├── bridge/                # Local backend bridge server (mira-bridge.cjs)
├── public/                # Static assets & 3D models
├── src/
│   ├── components/        # UI Overlays, HUD panels, and 3D Visuals
│   ├── hooks/             # Custom React hooks (useMira.ts)
│   ├── services/          # Brain, Voice, Memory, and Perception services
│   ├── state/             # Zustand global state store
│   └── App.tsx            # App container & main layout
├── mira.bat               # Windows automated startup script
└── README.md
```

## 📄 License

MIT License


