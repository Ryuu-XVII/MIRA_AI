# 🤖 Mira AI

Mira AI is an interactive, desktop-style AI companion built with **React 19**, **TypeScript**, and **Vite**. It pairs an ambient 3D HUD interface with a local **Node.js Express Bridge** (`mira-bridge.cjs`) that routes prompts to an **LM Studio** local server (or local Llama fallback) and provides neural text-to-speech with **Kokoro TTS**.

---

## ✨ Features

- **Futuristic 3D Ambient Visuals**: Built with `@react-three/fiber`, `@react-three/drei`, and `@react-three/postprocessing` for high-performance particle fields, bloom, and dynamic audio-reactive visuals.
- **LM Studio LLM Integration**: Connects to LM Studio's OpenAI-compatible local server (`http://localhost:1234`) with fallback to local `node-llama-cpp` routines.
- **Local Speech & TTS**: High-quality local voice synthesis using **Kokoro-JS** (`af_bella` voice with PCM WAV streaming and PowerShell playback) alongside Web Speech API recognition.
- **Multimodal & Perception Ready**: Integrated support for `@mediapipe/tasks-vision` and `@mlc-ai/web-llm` for browser-based vision and local WebGPU inference.
- **Time-Aware Conversational Core**: Dynamic greetings tuned to your current time of day and persistent state via **Zustand** and **IndexedDB** (`idb`).
- **One-Click Windows Launcher**: [`mira.bat`](file:///c:/Users/adnaa/.gemini/antigravity-ide/scratch/MIRA_AI/mira.bat) script to check LM Studio port status (`:1234`), clean orphan Node processes, and start the system automatically.

---

## 🧰 Tech Stack

### Frontend & UI
- **Framework**: React 19, Vite 7, TypeScript 5
- **3D & Animation**: Three.js (`v0.182`), `@react-three/fiber`, `@react-three/drei`, `@react-three/postprocessing`
- **State & Storage**: Zustand, IndexedDB (`idb`)

### AI Brain & Bridge Server
- **Bridge Backend**: Node.js, Express, CORS, `body-parser` (running on port `3002`)
- **LLM Engine**: LM Studio Local Server (Port `1234` default)
- **Neural TTS**: Kokoro-JS (`kokoro-js` with ONNX models in `public/models/kokoro`)
- **Vision & Local WebGPU**: `@mediapipe/tasks-vision`, `@mlc-ai/web-llm`

---

## 🚀 Getting Started

### Prerequisites

1. **Node.js**: v18.0 or higher.
2. **LM Studio**: Download and install [LM Studio](https://lmstudio.ai/).
   - Open LM Studio, load your preferred model (e.g., `qwen2.5`, `llama3`, `mistral`).
   - Start the **Local Server** on port `1234` (`http://localhost:1234`).

---

### Installation

Clone the repository and install all dependencies:

```bash
git clone https://github.com/Ryuu-XVII/MIRA_AI.git
cd MIRA_AI
npm install
```

---

### Running MIRA AI

#### Option A: One-Click Windows Batch File (Recommended)

Double-click or run from Command Prompt / PowerShell:

```cmd
.\mira.bat
```

This will:
1. Verify if LM Studio Local Server is running on port `1234`.
2. Terminate any orphan Node background processes.
3. Launch both the Express Bridge server (Port `3002`) and Vite Dev server (Port `5173`) concurrently.
4. Open `http://localhost:5173` in your default browser.

#### Option B: npm Start

Run concurrently via npm:

```bash
npm start
```

#### Option C: Separate Terminals

```bash
# Terminal 1: Start the Local Bridge (Port 3002) & Kokoro TTS
npm run bridge

# Terminal 2: Start the Vite Dev Server (Port 5173)
npm run dev
```

---

## 🛠️ Available Scripts

| Command | Description |
| :--- | :--- |
| `npm start` | Launches both `mira-bridge.cjs` and Vite frontend concurrently |
| `npm run dev` | Starts Vite dev server (`http://localhost:5173`) |
| `npm run bridge` | Starts Express bridge server (`http://localhost:3002`) |
| `npm run build` | Compiles TypeScript and builds production bundles |
| `npm run preview` | Previews the static production build |
| `npm run lint` | Runs ESLint checks across the project |

---

## 🧭 Project Architecture

```
MIRA_AI/
├── bridge/
│   └── mira-bridge.cjs          # Express bridge server, LM Studio proxy, Kokoro TTS handler
├── public/
│   └── models/kokoro/          # Quantized ONNX weights for Kokoro TTS engine
├── src/
│   ├── components/
│   │   ├── Overlay/            # HUD panels, status indicators, chat input
│   │   └── Visuals/            # Three.js 3D particle fields & post-processing canvas
│   ├── hooks/
│   │   └── useMira.ts          # Core orchestration hook (Brain, Speech, TTS)
│   ├── services/
│   │   ├── brain/              # BrainService (communicates with Bridge on port 3002)
│   │   ├── voice/              # VoiceService (speech recognition & TTS routing)
│   │   ├── perception/         # MediaPipe vision & frame processing
│   │   └── memory/             # MemoryService with IndexedDB persistence
│   ├── state/
│   │   └── useStore.ts         # Global Zustand store
│   ├── App.tsx                 # Main layout component
│   └── main.tsx                # App bootstrap & diagnostic logging
├── mira.bat                    # One-click Windows startup script
└── package.json                # Dependencies and scripts
```

---

## 📄 License

This project is open-source and licensed under the [MIT License](LICENSE).



