async function captureConsole() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    const tab = tabs.find(t => t.url && t.url.includes('test_mars_viewer.html'));
    const ws = new WebSocket(tab.webSocketDebuggerUrl);

    const logs = [];
    ws.onmessage = (e) => {
        const d = JSON.parse(e.data);
        if (d.method === 'Console.messageAdded') {
            logs.push(d.params.message);
        } else if (d.method === 'Runtime.consoleAPICalled') {
            logs.push(d.params);
        }
    };

    ws.onopen = async () => {
        ws.send(JSON.stringify({ id: 1, method: 'Console.enable' }));
        ws.send(JSON.stringify({ id: 2, method: 'Runtime.enable' }));
        ws.send(JSON.stringify({ id: 3, method: 'Page.reload' }));

        await new Promise(r => setTimeout(r, 4000));
        console.log('Captured logs:\n', JSON.stringify(logs, null, 2));

        ws.close();
    };
}
captureConsole().catch(console.error);
