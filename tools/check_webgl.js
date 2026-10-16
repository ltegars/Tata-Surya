async function checkWebGL() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('test_mars_viewer.html'));
    const ws = new WebSocket(tab.webSocketDebuggerUrl);

    ws.onopen = () => {
        ws.send(JSON.stringify({
            id: 1,
            method: 'Runtime.evaluate',
            params: {
                expression: `
                    (() => {
                        const canvas = document.createElement('canvas');
                        const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
                        if (!gl) return { webgl: false };
                        const debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
                        return {
                            webgl: true,
                            version: gl.getParameter(gl.VERSION),
                            vendor: debugInfo ? gl.getParameter(debugInfo.UNMASKED_VENDOR_WEBGL) : 'unknown',
                            renderer: debugInfo ? gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL) : 'unknown'
                        };
                    })()
                `,
                returnByValue: true
            }
        }));
    };

    ws.onmessage = (e) => {
        const d = JSON.parse(e.data);
        console.log('WebGL Info:', JSON.stringify(d.result.result.value, null, 2));
        ws.close();
    };
}
checkWebGL();
