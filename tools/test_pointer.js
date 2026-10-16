const fs = require('fs');

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    const res = await fetch('http://127.0.0.1:60120/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:60108'));
    if (!tab) {
        console.error('Target tab not found!');
        return;
    }

    const ws = new WebSocket(tab.webSocketDebuggerUrl);
    let msgId = 1;
    const callbacks = new Map();

    ws.onmessage = (event) => {
        try {
            const data = JSON.parse(event.data);
            if (data.id && callbacks.has(data.id)) {
                const cb = callbacks.get(data.id);
                callbacks.delete(data.id);
                cb(data.result);
            }
        } catch (e) {
            console.error('onmessage error:', e);
        }
    };

    function send(method, params = {}) {
        return new Promise((resolve) => {
            const id = msgId++;
            callbacks.set(id, resolve);
            ws.send(JSON.stringify({ id, method, params }));
        });
    }

    async function evalCode(code) {
        const r = await send('Runtime.evaluate', {
            expression: code,
            returnByValue: true,
        });
        return r.result ? r.result.value : null;
    }

    async function dispatchClick(x, y) {
        console.log(`Dispatching pointer events at (${x}, ${y})`);
        const code = `
            (() => {
                const x = ${x};
                const y = ${y};
                const el = document.elementFromPoint(x, y) || document.body;
                const opts = { clientX: x, clientY: y, pointerId: 1, isPrimary: true, button: 0, buttons: 1, bubbles: true };
                el.dispatchEvent(new PointerEvent('pointerdown', opts));
                el.dispatchEvent(new MouseEvent('mousedown', opts));
                opts.buttons = 0;
                el.dispatchEvent(new PointerEvent('pointerup', opts));
                el.dispatchEvent(new MouseEvent('mouseup', opts));
                el.dispatchEvent(new MouseEvent('click', opts));
                return 'Clicked ' + el.tagName;
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
        console.log('Connected to CDP');
        await wait(1000);

        // 1. Initial screenshot
        await screenshot('step1_current.png');

        // 2. Click "Mulai Eksplorasi" button on Home screen (center of screen, around x=206, y=560)
        console.log('Clicking Mulai Eksplorasi button...');
        await dispatchClick(206, 560);
        await wait(1500);
        await screenshot('step2_explorer.png');

        // 3. In Planet Explorer:
        // Let's click Mars card (row 2, col 2: x=305, y=430)
        console.log('Clicking Mars card...');
        await dispatchClick(305, 430);
        await wait(1500);
        await screenshot('step3_mars_detail.png');

        // 4. In Mars Detail: scroll down
        console.log('Scrolling down Mars Detail...');
        await evalCode(`
            (() => {
                window.scrollBy(0, 800);
                const scrollable = document.querySelector('flt-scene-host') || document.body;
                scrollable.dispatchEvent(new WheelEvent('wheel', { deltaY: 800, bubbles: true }));
            })()
        `);
        await wait(1000);
        await screenshot('step4_mars_scrolled.png');

        // Let's also check if we can inspect the DOM or tap "Jelajahi 3D"
        console.log('Clicking Jelajahi 3D button...');
        // The Jelajahi 3D button is at approx x=206, y=780
        await dispatchClick(206, 780);
        await wait(4000);
        await screenshot('step5_mars_3d.png');

        // Check model-viewer
        const mvInfo = await evalCode(`
            (() => {
                const mv = document.querySelector('model-viewer');
                if (!mv) return 'No model-viewer tag';
                return {
                    src: mv.getAttribute('src'),
                    loaded: mv.loaded,
                    modelIsVisible: mv.modelIsVisible,
                    paused: mv.paused,
                    h: mv.clientHeight,
                    w: mv.clientWidth
                };
            })()
        `);
        console.log('Mars model-viewer info:', mvInfo);

        ws.close();
    };
}

main().catch(console.error);
