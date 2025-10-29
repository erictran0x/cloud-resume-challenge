import { useState } from 'react';
import './ViewerCount.css';

function ViewerCount() {
	const [viewers, setViewers] = useState<number | null>(null);
	return <span className='viewer-count'>Views: {viewers !== null ? viewers : '...'}</span>;
}

export default ViewerCount;