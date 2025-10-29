import { useState } from 'react';
import './Resume.css';
import { IoIosArrowDown, IoIosArrowUp } from "react-icons/io";

function Resume({ children } : { children: React.ReactNode }) {
	return <div id='my_resume'>{children}</div>
}

function Name({ children } : { children: string }) {
	return <h1>{children}</h1>
}

function Topic({ label, children } : { label: React.ReactNode, children: React.ReactNode }) {
	const [active, setActive] = useState(true);

	return (
		<section className='resume-topic'>
			<div className='resume-topic-header'>
				<h2>{label}</h2>
				<button onClick={() => setActive(!active)}>
					{active ? <IoIosArrowDown size={18} /> : <IoIosArrowUp size={18} />}
				</button>
			</div>
			{active && children}
		</section>
	)
}

function Subtopic({ label, link, dateFrom, dateTo, children } : { label: React.ReactNode, link?: string, dateFrom?: string, dateTo?: string, children?: React.ReactNode }) {
	return (
		<section className='resume-subtopic'>
			<div className='resume-subtopic-header'>
				{link ? <a href={link}>{label}</a> : <span>{label}</span>}
				<span style={{fontWeight: "normal"}}>{dateFrom} {dateTo && `- ${dateTo}`}</span>
			</div>
			{children}
		</section>
	)
}

Resume.Name = Name;
Resume.Topic = Topic;
Resume.Subtopic = Subtopic;

export default Resume;