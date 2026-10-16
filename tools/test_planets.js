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
    console.log('Target tab found:', tab.webSocketDebuggerUrl);

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

    async function click(x, y) {
        console.log(`Clicking (${x}, ${y})`);
        await send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
        await wait(50);
        await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
    }

    async function scroll(dy) {
        console.log(`Scrolling dy=${dy}`);
        await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 200, y: 400, deltaX: 0, deltaY: dy });
    }

    async function screenshot(name) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync(name, Buffer.from(shot.data, 'base64'));
        console.log(`Saved ${name}`);
    }

    ws.onopen = async () => {
        console.log('Connected to CDP');
        await wait(2000);
        await screenshot('step1_home.png');

        // Click Planet tab (x=154, y=890)
        await click(154, 890);
        await wait(1200);
        await screenshot('step2_planets.png');

        // In 2-col grid:
        // Col 1: Mercury (top), Earth (row 2, y~430, x~105)
        // Col 2: Venus (top), Mars (row 2, y~430, x~305)
        // Click Mars
        console.log('Opening Mars...');
        await click(305, 430);
        await wait(1500);
        await screenshot('step3_mars_detail.png');

        // Scroll down to "Jelajahi 3D" button
        await scroll(600);
        await wait(500);
        await scroll(600);
        await wait(800);
        await screenshot('step4_mars_scrolled.png');

        // Tap "Jelajahi 3D" (button is at center bottom, around y=780, x=206)
        console.log('Tapping Jelajahi 3D...');
        await click(206, 780);
        await wait(4000);
        await screenshot('step5_mars_3d.png');

        // Query model-viewer state
        const marsMv = await send('Runtime.evaluate', {
            expression: `(() => {
                const mv = document.querySelector('model-viewer');
                if (!mv) return null;
                return {
                    src: mv.getAttribute('src'),
                    loaded: mv.loaded,
                    modelIsVisible: mv.modelIsVisible,
                    paused: mv.paused,
                    h: mv.clientHeight,
                    w: mv.clientWidth
                };
            })()`,
            returnByValue: true
        });
        console.log('Mars model-viewer status:', marsMv.result.value);

        // Now test Earth:
        // Click Back button at top left (x=36, y=56)
        console.log('Navigating back to Mars detail...');
        await click(36, 56);
        await wait(1000);

        // Click Back button again to return to Planet Explorer
        console.log('Navigating back to Planet Explorer...');
        await click(36, 56);
        await wait(1000);

        // Click Earth (row 2, col 1: x~105, y~430)
        console.log('Opening Earth...');
        await click(105, 430);
        await wait(1500);

        // Scroll down to "Jelajahi 3D"
        await scroll(600);
        await wait(500);
        await scroll(600);
        await wait(800);

        // Tap "Jelajahi 3D"
        console.log('Tapping Jelajahi 3D for Earth...');
        await click(206, 780);
        await wait(4000);
        await screenshot('step6_earth_3d.png');

        const earthMv = await send('Runtime.evaluate', {
            expression: `(() => {
                const mv = document.querySelector('model-viewer');
                if (!mv) return null;
                return {
                    src: mv.getAttribute('src'),
                    loaded: mv.loaded,
                    modelIsVisible: mv.modelIsVisible,
                    paused: mv.paused,
                    h: mv.clientHeight,
                    w: mv.clientWidth
                };
            })()`,
            returnByValue: true
        });
        console.log('Earth model-viewer status:', earthMv.result.value);

        console.log('Verification finished successfully!');
        ws.close();
    };
}

main().catch(console.error);
