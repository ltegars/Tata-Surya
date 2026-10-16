const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testOpen3D() {
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
        await wait(120);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', buttons: 0, clickCount: 1 });
    }

    ws.onopen = async () => {
        console.log('Connected');
        await send('Emulation.setFocusEmulationEnabled', { enabled: true });
        await send('Page.bringToFront');

        // Let's click at several y positions across the card: y=860, y=875, y=890
        console.log('Clicking Jelajahi 3D at (206, 875)...');
        await click(206, 875);
        await wait(4000);

        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('step_3d_result_opened.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved step_3d_result_opened.png');

        ws.close();
    };
}
testOpen3D().catch(console.error);
