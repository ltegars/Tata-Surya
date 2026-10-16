const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function renderFrame() {
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
        console.log('Connected');

        // Enable focus and page active emulation in Chrome!
        await send('Emulation.setFocusEmulationEnabled', { enabled: true });
        await send('Page.bringToFront');

        // Check model viewer properties and dismiss poster
        const r = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const mv = document.getElementById('mv-mars');
                    if (mv.dismissPoster) mv.dismissPoster();
                    return {
                        loaded: mv.loaded,
                        modelIsVisible: mv.modelIsVisible,
                        currentTime: mv.currentTime
                    };
                })()
            `,
            returnByValue: true
        });
        console.log('Before wait:', r.result.value);

        await wait(2000);

        const r2 = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const mv = document.getElementById('mv-mars');
                    return {
                        loaded: mv.loaded,
                        modelIsVisible: mv.modelIsVisible,
                        statusText: document.getElementById('mars-status').innerText
                    };
                })()
            `,
            returnByValue: true
        });
        console.log('After wait:', r2.result.value);

        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('rendered_mars_visible.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved rendered_mars_visible.png');

        ws.close();
    };
}
renderFrame().catch(console.error);
