const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testFocusAndClick() {
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

    ws.onopen = async () => {
        console.log('Connected');

        // Emulate focus!
        await send('Emulation.setFocusEmulationEnabled', { enabled: true });
        await send('Page.bringToFront');
        await send('Runtime.evaluate', {
            expression: 'window.focus(); document.body.focus();'
        });

        // Click Planet tab at x=154, y=894
        console.log('Clicking Planet tab with focus enabled...');
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseMoved', x: 154, y: 894 });
        await wait(50);
        sendRaw('Input.dispatchMouseEvent', { type: 'mousePressed', x: 154, y: 894, button: 'left', buttons: 1, clickCount: 1 });
        await wait(100);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseReleased', x: 154, y: 894, button: 'left', buttons: 0, clickCount: 1 });

        await wait(2000);

        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('focus_click_result.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved focus_click_result.png');

        ws.close();
    };
}
testFocusAndClick().catch(console.error);
