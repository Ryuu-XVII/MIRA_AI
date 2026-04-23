import { getLlama } from "node-llama-cpp";

(async () => {
    console.log("TEST: Attempting to load Llama with gpu: 'vulkan'...");
    try {
        const llama = await getLlama({ gpu: "vulkan" });
        console.log("TEST: SUCCESS! Llama loaded.");
        console.log("TEST: Gpu Support:", llama._supportsGpuOffloading);
        console.log("TEST: Build Type:", llama._buildType);
        console.log("TEST: GPU Info:", await llama.getGpuVramInfo());
    } catch (e) {
        console.error("TEST: FAILED to load Llama.");
        console.error(e);
    }
})();
