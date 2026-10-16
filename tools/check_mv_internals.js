async function checkModelViewerInternals() {
    const res = await fetch('http://127.0.0.1:49348/json');
    const tabs = await res.json();
    let tab = tabs.find(t => t.url && t.url.includes('test_mars_viewer.html'));
    if (!tab) {
        tab = tabs.find(t => t.url && t.url.includes('localhost:50280'));
    }
    if (!tab) {
        console.log('No matching tab found');
        return;
    }
    const ws = new WebSocket(tab.webSocketDebuggerUrl);
    ws.onopen = () => {
        ws.send(JSON.stringify({
            id: 1,
            method: 'Runtime.evaluate',
            params: {
                expression: `
                    (() => {
                        const mv = document.getElementById('mv-mars') || document.querySelector('model-viewer');
                        if (!mv) return 'No model-viewer in DOM';
                        return {
                            loaded: mv.loaded,
                            modelIsVisible: mv.modelIsVisible,
                            paused: mv.paused,
                            cameraOrbit: mv.getCameraOrbit ? mv.getCameraOrbit() : null,
                            cameraTarget: mv.getCameraTarget ? mv.getCameraTarget() : null,
                            fieldOfView: mv.getFieldOfView ? mv.getFieldOfView() : null,
                            dimensions: mv.getDimensions ? mv.getDimensions() : null
                        };
                    })()
                `,
                returnByValue: true
            }
        }));
    };
    ws.onmessage = (e) => {
        const d = JSON.parse(e.data);
        console.log('Model Viewer Internals:\n', JSON.stringify(d.result.result.value, null, 2));
        ws.close();
    };
}
checkModelViewerInternals();
