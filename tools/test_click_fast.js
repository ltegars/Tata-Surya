const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testClick() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:50280'));
    const ws = new WebSocket(tab.webSocketDebuggerUrl);

    let id = 1;
    function sendRaw(method, params = {}) {
        ws.send(JSON.stringify({ id: id++, method, params }));
    }

    function sendAsync(method, params = {}) {
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

    async function click(x, y) {
        console.log(`Clicking at (${x}, ${y})`);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseMoved', x, y });
        await wait(30);
        sendRaw('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
        await wait(50);
        sendRaw('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
    }

    ws.onopen = async () => {
        console.log('Connected');
        await wait(1000);

        // Click "Mulai Eksplorasi" button (x: 206, y: 568)
        await click(206, 568);
        await wait(1500);

        const shot = await sendAsync('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('test_nav_result.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved test_nav_result.png');

        ws.close();
    };
}
testClick();
