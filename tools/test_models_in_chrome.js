const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testModelsInChrome() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:50280'));
    if (!tab) {
        console.error('Target tab not found!');
        return;
    }
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
        console.log('Connected to Chrome tab');

        // Navigate to test_mars_viewer.html
        console.log('Navigating to test_mars_viewer.html...');
        await send('Page.navigate', { url: 'http://localhost:50280/test_mars_viewer.html' });

        // Wait 6 seconds for models to download and render
        console.log('Waiting 6s for models to load and render in <model-viewer>...');
        await wait(6000);

        // Check model-viewer load status from page DOM
        const status = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    return ['mars', 'earth', 'saturn'].map(id => {
                        const mv = document.getElementById('mv-' + id);
                        const p = document.getElementById(id + '-status');
                        return {
                            id,
                            loaded: mv ? mv.loaded : null,
                            modelIsVisible: mv ? mv.modelIsVisible : null,
                            statusText: p ? p.innerText : null
                        };
                    });
                })()
            `,
            returnByValue: true
        });
        console.log('Model Viewer statuses:\n', JSON.stringify(status.result.value, null, 2));

        // Capture screenshot of the models rendering in Chrome!
        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('chrome_models_rendered.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved chrome_models_rendered.png!');

        ws.close();
    };
}
testModelsInChrome().catch(console.error);
