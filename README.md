# Mira AI

Mira AI is an experimental desktop-style AI companion interface built with React, TypeScript, and Vite. It pairs a 3D-driven frontend with a local LLM bridge backend for native model inference, GPU-aware startup, and immersive visual feedback.

## 🚀 What this project is

- A **Web-based AI assistant UI** with a futuristic HUD and chat terminal.
- A **local model bridge** architecture using `node-llama-cpp` for native inference.
- A **Three.js visual layer** with bloom and particle field effects via `@react-three/fiber`.
- A **GPU detection and monitoring layer** for better local performance awareness.
- Built with **Zustand** state management, modular services, and clean component composition.

## ⚡ Highlights

- 3D ambient scene rendered in React with interactive camera control
- AI brain initialization and model loading through a local bridge service
- Streaming assistant messages displayed in a stylized terminal
- Local analytics and diagnostics integrated at startup
- Support for voice and multimodal flows through service scaffolding

## 🧰 Main technologies

- `react` / `react-dom`
- `vite`
- `typescript`
- `three`, `@react-three/fiber`, `@react-three/drei`
- `zustand`
- `node-llama-cpp`
- `express`, `cors`, `body-parser`

## 🚀 Development

Install dependencies:

```bash
npm install
```

Run the local app and backend bridge together:

```bash
npm start
```

If you want to run them separately:

```bash
npm run dev
npm run bridge
```

Build for production:

```bash
npm run build
```

Preview the production build locally:

```bash
npm run preview
```

Lint the repository:

```bash
npm run lint
```

## 🧭 Project structure

- `src/App.tsx` — main application layout and UI composition
- `src/main.tsx` — app bootstrap, diagnostics, and cache cleanup
- `src/state/useStore.ts` — global app state and message history
- `src/services/brain/BrainService.ts` — local AI bridge orchestration and model control
- `src/components/Overlay` — HUD, status panels, and control deck
- `src/components/Visuals` — 3D particle scene and visual effects

## 💡 Notes

- This repo is built as a local prototype and currently runs in development mode with a local bridge backend.
- `npm start` launches both the frontend and the model bridge concurrently.
- The app uses a private package setup and is not configured for npm publishing.

## 📄 License

Add a license file or choose your preferred open source license for this project.
