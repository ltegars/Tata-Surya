async function checkCanvas() {
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
                        const mv = document.getElementById('mv-mars');
                        const canvas = mv.shadowRoot.querySelector('canvas');
                        const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
                        return {
                            mvRect: mv.getBoundingClientRect(),
                            canvasWidth: canvas ? canvas.width : 0,
                            canvasHeight: canvas ? canvas.height : 0,
                            canvasStyle: canvas ? canvas.getAttribute('style') : null,
                            loaded: mv.loaded,
                            paused: mv.paused,
                            currentTime: mv.currentTime
                        };
                    })()
                `,
                returnByValue: true
            }
        }));
    };

    ws.onmessage = (e) => {
        const d = JSON.parse(e.data);
        console.log('Canvas Details:\n', JSON.stringify(d.result.result.value, null, 2));
        ws.close();
    };
}
checkCanvas();
