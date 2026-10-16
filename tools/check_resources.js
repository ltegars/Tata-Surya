async function getResources() {
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
        const res = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const entries = performance.getEntriesByType('resource').map(r => r.name);
                    const mv = document.getElementById('mv-mars');
                    return {
                        resources: entries,
                        modelIsVisible: mv ? mv.modelIsVisible : null,
                        currentGLTF: Boolean(mv && mv.currentGLTF)
                    };
                })()
            `,
            returnByValue: true
        });
        console.log('Resources:\n', JSON.stringify(res.result.value, null, 2));

        ws.close();
    };
}
getResources().catch(console.error);
