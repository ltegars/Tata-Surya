const fs = require('fs');

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    const res = await fetch('http://127.0.0.1:60120/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:60108'));
    const ws = new WebSocket(tab.webSocketDebuggerUrl);

    let id = 1;
    function send(method, params = {}) {
        return new Promise((resolve) => {
            const curId = id++;
            const h = (e) => {
                const d = JSON.parse(e.data);
                if (d.id === curId) {
                    ws.removeEventListener('message', h);
                    resolve(d.result);
                }
            };
            ws.addEventListener('message', h);
            ws.send(JSON.stringify({ id: curId, method, params }));
        });
    }

    async function evalCode(code) {
        const r = await send('Runtime.evaluate', {
            expression: code,
            returnByValue: true,
        });
        return r.result ? r.result.value : null;
    }

    async function clickCanvas(x, y) {
        console.log(`Clicking canvas at (${x}, ${y})`);
        const code = `
            (() => {
                const pane = document.querySelector('flt-glass-pane');
                const target = pane ? (pane.shadowRoot ? (pane.shadowRoot.querySelector('canvas') || pane.shadowRoot.firstElementChild) : pane) : document.body;
                const opts = {
                    clientX: ${x},
                    clientY: ${y},
                    screenX: ${x},
                    screenY: ${y},
                    pointerId: 1,
                    pointerType: 'mouse',
                    isPrimary: true,
                    button: 0,
                    buttons: 1,
                    bubbles: true,
                    composed: true
                };
                target.dispatchEvent(new PointerEvent('pointerdown', opts));
                opts.buttons = 0;
                target.dispatchEvent(new PointerEvent('pointerup', opts));
                return 'dispatched to ' + target.tagName;
            })()
        `;
        return await evalCode(code);
    }

    async function screenshot(name) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync(name, Buffer.from(shot.data, 'base64'));
        console.log(`Saved screenshot: ${name}`);
    }

    ws.onopen = async () => {
        console.log('Connected');
        await wait(500);

        // Click "Mulai Eksplorasi" button at x=206, y=568
        const r1 = await clickCanvas(206, 568);
        console.log('Result 1:', r1);
        await wait(1500);
        await screenshot('click_res_1.png');

        ws.close();
    };
}

main().catch(console.error);
