async function getConsoleMessages() {
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
        const shadow = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const mv = document.getElementById('mv-mars');
                    if (!mv) return 'no mv';
                    return {
                        shadowHTML: mv.shadowRoot.innerHTML,
                        attributes: Array.from(mv.attributes).map(a => a.name + '=' + a.value),
                        symbols: Object.getOwnPropertySymbols(mv).map(s => s.toString())
                    };
                })()
            `,
            returnByValue: true
        });
        console.log('Attributes:', shadow.result.value.attributes);
        console.log('Shadow HTML:\n', shadow.result.value.shadowHTML);

        ws.close();
    };
}
getConsoleMessages().catch(console.error);
