const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testScrollMore() {
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

        // Scroll down more
        console.log('Scrolling down by 400...');
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 200, y: 400, deltaX: 0, deltaY: 400 });
        await wait(1000);

        const shot1 = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('step_scrolled_center.png', Buffer.from(shot1.data, 'base64'));
        console.log('Saved step_scrolled_center.png');

        ws.close();
    };
}
testScrollMore().catch(console.error);
