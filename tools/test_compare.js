const fs = require('fs');

function wait(ms) { return new Promise(r => setTimeout(r, ms)); }

async function testCompare() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('test_mars_viewer.html'));
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
        console.log('Connected. Reloading page...');
        await send('Page.reload', { ignoreCache: true });
        console.log('Waiting 8s for Astronaut and Mars to load...');
        await wait(8000);

        const status = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    return ['mars', 'astro'].map(id => {
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
        console.log('Comparison results:\n', JSON.stringify(status.result.value, null, 2));

        const shot = await send('Page.captureScreenshot', { format: 'png' });
        fs.writeFileSync('compare_result.png', Buffer.from(shot.data, 'base64'));
        console.log('Saved compare_result.png');

        ws.close();
    };
}
testCompare().catch(console.error);
