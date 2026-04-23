import './diagnostics'

// Force clear Cache API on boot to remove any HTML-cached-as-JSON 
if ('caches' in window) {
  caches.keys().then(names => {
    for (const name of names) {
      caches.delete(name);
    }
  });
}

// Clear IndexedDB for WebLLM
if ('indexedDB' in window) {
  indexedDB.databases().then(dbs => {
    dbs.forEach(db => {
      if (db.name && (db.name.includes('web-llm') || db.name.includes('tvmjs'))) {
        console.log(`[CACHE-CLEAR] Deleting IndexedDB: ${db.name}`);
        indexedDB.deleteDatabase(db.name);
      }
    });
  });
}

// Global error capture for bridge
window.addEventListener('unhandledrejection', (event) => {
  fetch('http://localhost:3001/log', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    mode: 'no-cors',
    body: JSON.stringify({ type: 'GLOBAL-PROMISE-REJECTION', message: event.reason?.message || String(event.reason), details: event.reason?.stack })
  });
});

import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
