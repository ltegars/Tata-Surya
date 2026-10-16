async function getErrors() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('test_mars_viewer.html'));
    const ws = new WebSocket(tab.webSocketDebuggerUrl);

    let id = 1;
    function send(method, params = {}) {
        return new Promise(r => {
            const curId = id++;
            const h = (e) => {
                const d = JSON.parse(e.data);
                if (d.id === curId) {
                    ws.removeEventListener('message', h);
                    r(d.result);
                }
            };
            ws.addEventListener('message', h);
            ws.send(JSON.stringify({ id: curId, method, params }));
        });
    }

    ws.onopen = async () => {
        // Evaluate window.errors or try to load mars.glb using THREE.GLTFLoader inside model-viewer or window
        const evalRes = await send('Runtime.evaluate', {
            expression: `
                (async () => {
                    const mv = document.getElementById('mv-mars');
                    const symbols = Object.getOwnPropertySymbols(mv);
                    // Find internal scene / error
                    const result = {};
                    for (const s of symbols) {
                        try {
                            const val = mv[s];
                            if (val && typeof val === 'object') {
                                if (val.currentGLTF) result.currentGLTF = 'exists';
                                if (val.error) result.error = val.error.toString();
                            }
                        } catch(e) {}
                    }
                    return {
                        result,
                        status: document.getElementById('mars-status').innerText
                    };
                })()
            `,
            awaitPromise: true,
            returnByValue: true
        });
        console.log('Eval result:\n', JSON.stringify(evalRes.result.value, null, 2));

        ws.close();
    };
}
getErrors().catch(console.error);
