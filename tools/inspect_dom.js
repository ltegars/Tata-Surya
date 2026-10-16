const fs = require('fs');

async function main() {
    const res = await fetch('http://127.0.0.1:60120/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('localhost:60108'));
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
        // Enable accessibility
        console.log('Enabling semantics...');
        await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const ph = document.querySelector('flt-semantics-placeholder');
                    if (ph) ph.click();
                    return 'clicked placeholder';
                })()
            `
        });
        await new Promise(r => setTimeout(r, 1000));

        // Inspect semantics tree
        const tree = await send('Runtime.evaluate', {
            expression: `
                (() => {
                    const elements = Array.from(document.querySelectorAll('flt-semantics, [aria-label], button, a')).map(el => ({
                        tag: el.tagName,
                        aria: el.getAttribute('aria-label'),
                        role: el.getAttribute('role'),
                        rect: el.getBoundingClientRect()
                    }));
                    return elements;
                })()
            `,
            returnByValue: true
        });
        console.log('Semantics elements:', JSON.stringify(tree.result.value, null, 2));

        ws.close();
    };
}
main();
