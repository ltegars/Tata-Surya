async function reloadAndCheck() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:50280'));
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
        console.log('Connected. Reloading page...');
        await send('Page.reload', { ignoreCache: true });
        console.log('Waiting 5s for page to load scripts...');
        await new Promise(r => setTimeout(r, 5000));

        const r = await send('Runtime.evaluate', {
            expression: 'Boolean(customElements.get("model-viewer"))',
            returnByValue: true
        });
        console.log('Is <model-viewer> defined in customElements now?', r.result.value);

        ws.close();
    };
}
reloadAndCheck();
