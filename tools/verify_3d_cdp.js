const fs = require('fs');

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    const res = await fetch('http://127.0.0.1:60120/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.title && t.title.includes('Jelajah Tata Surya'));
    if (!tab) {
        console.error('Target tab not found!');
        process.exit(1);
    }
    console.log('Connecting to tab:', tab.title, 'at', tab.webSocketDebuggerUrl);

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
            console.error('Error in onmessage:', e);
        }
    };

    function send(method, params = {}) {
        return new Promise((resolve) => {
            const id = msgId++;
            callbacks.set(id, resolve);
            ws.send(JSON.stringify({ id, method, params }));
        });
    }

    async function clickAt(x, y) {
        console.log(`Clicking at (${x}, ${y})`);
        await send('Input.dispatchMouseEvent', {
            type: 'mousePressed',
            x,
            y,
            button: 'left',
            clickCount: 1,
        });
        await wait(50);
        await send('Input.dispatchMouseEvent', {
            type: 'mouseReleased',
            x,
            y,
            button: 'left',
            clickCount: 1,
        });
    }

    async function takeScreenshot(filename) {
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync(filename, Buffer.from(shot.data, 'base64'));
        console.log(`Saved screenshot: ${filename}`);
    }

    ws.onopen = async () => {
        console.log('Connected to Chrome DevTools Protocol!');
        await wait(1000);

        // 1. Capture current screen (Home)
        await takeScreenshot('screen_0_home.png');

        // 2. Click Planet tab in bottom nav (approx x=154, y=890)
        await clickAt(154, 890);
        await wait(1500);
        await takeScreenshot('screen_1_planet_explorer.png');

        // 3. Find where Mars card is: In 2-col grid, row 2 is Earth (left) & Mars (right)
        // Col 1 is x ~ 105, Col 2 is x ~ 305
        // Row 1 (Mercury, Venus): y ~ 260
        // Row 2 (Earth, Mars): y ~ 450
        // Let's click Mars at x=305, y=450
        console.log('Clicking Mars card in grid...');
        await clickAt(305, 450);
        await wait(1500);
        await takeScreenshot('screen_2_mars_detail.png');

        // 4. In Mars Detail, scroll down to "Jelajahi 3D" button
        // Let's scroll down by sending wheel event
        console.log('Scrolling down Mars detail...');
        await send('Input.dispatchMouseEvent', {
            type: 'mouseWheel',
            x: 200,
            y: 400,
            deltaX: 0,
            deltaY: 500,
        });
        await wait(800);
        await send('Input.dispatchMouseEvent', {
            type: 'mouseWheel',
            x: 200,
            y: 400,
            deltaX: 0,
            deltaY: 400,
        });
        await wait(1000);
        await takeScreenshot('screen_3_mars_detail_scrolled.png');

        // 5. Look for the Jelajahi 3D button at approx x=200, y=700-800
        // Let's click around the Jelajahi 3D button
        // Or check model-viewer in DOM
        const evalCheck = await send('Runtime.evaluate', {
            expression: `(() => {
                const buttons = Array.from(document.querySelectorAll('*')).filter(el => el.innerText && el.innerText.includes('Jelajahi 3D'));
                return buttons.length;
            })()`,
        });
        console.log('Jelajahi 3D text elements:', evalCheck);

        // Click Jelajahi 3D button
        await clickAt(200, 720);
        await wait(3000);

        // Take screenshot of Mars 3D screen
        await takeScreenshot('screen_4_mars_3d.png');

        // Check if model-viewer exists in DOM now
        const mvCheck = await send('Runtime.evaluate', {
            expression: `(() => {
                const mv = document.querySelector('model-viewer');
                if (!mv) return 'No model-viewer tag';
                return {
                    src: mv.getAttribute('src'),
                    loaded: mv.loaded,
                    paused: mv.paused,
                    modelIsVisible: mv.modelIsVisible,
                    clientHeight: mv.clientHeight,
                    clientWidth: mv.clientWidth
                };
            })()`,
            returnByValue: true,
        });
        console.log('model-viewer status:', JSON.stringify(mvCheck.result.value));

        // Let's wait another 3 seconds for full load and take another screenshot
        await wait(3000);
        await takeScreenshot('screen_5_mars_3d_loaded.png');

        // 6. Test Earth
        // Click back button (top left: x=36, y=56)
        console.log('Clicking back button...');
        await clickAt(36, 56);
        await wait(1000);
        // Back from detail to explorer
        await clickAt(36, 56);
        await wait(1000);

        // In explorer, Earth is at x=105, y=450
        console.log('Clicking Earth card in grid...');
        await clickAt(105, 450);
        await wait(1500);

        // Scroll down
        await send('Input.dispatchMouseEvent', {
            type: 'mouseWheel',
            x: 200,
            y: 400,
            deltaX: 0,
            deltaY: 800,
        });
        await wait(1000);

        // Click Jelajahi 3D button
        console.log('Clicking Jelajahi 3D for Earth...');
        await clickAt(200, 720);
        await wait(4000);

        // Take screenshot of Earth 3D screen
        await takeScreenshot('screen_6_earth_3d.png');

        const earthMvCheck = await send('Runtime.evaluate', {
            expression: `(() => {
                const mv = document.querySelector('model-viewer');
                if (!mv) return 'No model-viewer tag';
                return {
                    src: mv.getAttribute('src'),
                    loaded: mv.loaded,
                    modelIsVisible: mv.modelIsVisible,
                    clientHeight: mv.clientHeight,
                    clientWidth: mv.clientWidth
                };
            })()`,
            returnByValue: true,
        });
        console.log('Earth model-viewer status:', JSON.stringify(earthMvCheck.result.value));

        console.log('Done verification!');
        ws.close();
    };
}

main().catch(console.error);
