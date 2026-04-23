
const BRIDGE_LOG_URL = 'http://localhost:3001/log';

async function remoteLog(type: string, message: string, details?: any) {
    try {
        await fetch(BRIDGE_LOG_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            mode: 'no-cors', // Use no-cors to avoid preflight issues for logs
            body: JSON.stringify({ type, message, details })
        });
    } catch (e) {
        // Silent fail for logs
    }
}

// Intercept global fetch
const originalFetch = window.fetch;
(window as any).fetch = async (input: RequestInfo | URL, init?: RequestInit) => {
    const url = typeof input === 'string' ? input : (input as Request).url;

    // Skip logging our own diagnostic logs to avoid infinite loops
    if (url.includes(':3001/log')) return originalFetch(input, init);

    // --- LOCAL VOICE REDIRECTOR ---
    // kokoro-js hardcodes the huggingface URL for voice profiles.
    // We redirect these to our local public folder for 100% offline support.
    if (url.includes('huggingface.co') && url.includes('/voices/') && url.endsWith('.bin')) {
        const voiceName = url.split('/').pop();
        const localUrl = `/models/kokoro/voices/${voiceName}`;
        console.log(`[VOICE-REDIRECT] Rerouting remote voice fetch: ${voiceName} -> ${localUrl}`);
        return originalFetch(localUrl, init);
    }

    // remoteLog('FETCH-REQ', `Fetching: ${url}`); // Disabled for now to reduce overhead

    try {
        const response = await originalFetch(input, init);
        return response;
    } catch (error: any) {
        // remoteLog('FETCH-ERROR', `Fetch failed for: ${url}`, { error: error.message });
        throw error;
    }
};

console.log("[DIAGNOSTICS] Fetch interceptor active.");
remoteLog('INFO', "Mira Diagnostics initialized in browser.");

export { };
