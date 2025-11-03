import { useEffect, useRef, useState } from 'react';
import './ViewerCount.css';

type ViewerCountMessage = {
	action: string;
	message: number;
}

function ViewerCount() {
	const initialized = useRef(false);
	const [viewers, setViewers] = useState<number | null>(null);
	const [isClosed, setIsClosed] = useState(false);

	useEffect(() => {
		if (initialized.current) return;  // only run once in dev mode
		initialized.current = true;
		
		const socket = new WebSocket('/api/dev');
		let pingInterval: number;
		socket.onopen = () => {
			socket.send(JSON.stringify({ action: 'ping' }));
			pingInterval = setInterval(() => {
				socket.send(JSON.stringify({ action: 'ping' }));
			}, 5*60*1000 /* 5 minutes */);
		};
		socket.onmessage = (event) => {
			const data: ViewerCountMessage = JSON.parse(event.data);
			if (data.action !== 'broadcast' || data.message === undefined) return;
			setViewers(data.message);
		};
		socket.onclose = () => {
			setIsClosed(true);
			clearInterval(pingInterval);
		}
		return () => {
			if (socket.readyState === WebSocket.OPEN)
				socket.close();
		};
	}, []);
	return (
		<span className='viewer-count'>
			Views: {viewers !== null ? viewers : '...'} {isClosed && ' (refresh to see live changes)'}
		</span>
	);
}

export default ViewerCount;