const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testClickCard() {
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

    function sendRaw(method, params = {}) {
        ws.send(JSON.stringify({ id: id++, method, params }));
    }

    async function click(x, y) {
        console.log(`Clicking (${x}, ${y})`);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseMoved', x, y });
        await wait(60);
        sendRaw('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', buttons: 1, clickCount: 1 });
        await wait(100);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', buttons: 0, clickCount: 1 });
    }

    ws.onopen = async () => {
        console.log('Connected');
        await send('Emulation.setFocusEmulationEnabled', { enabled: true });
        await send('Page.bringToFront');

        // Click directly on the Jelajah 3D card at x=206, y=853
        await click(206, 853);
        await wait(4000);

        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('step_after_card_click.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved step_after_card_click.png');

        // Check if model-viewer is in DOM
        const check = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const mv = document.querySelector('model-viewer');
                    return {
                        hasMv: Boolean(mv),
                        src: mv ? mv.getAttribute('src') : null,
                        loaded: mv ? mv.loaded : null,
                        modelIsVisible: mv ? mv.modelIsVisible : null
                    };
                })()
            `,
            returnByValue: true
        });
        console.log('Check result:', JSON.stringify(check.result.value, null, 2));

        ws.close();
    };
}
testClickCard().catch(console.error);
