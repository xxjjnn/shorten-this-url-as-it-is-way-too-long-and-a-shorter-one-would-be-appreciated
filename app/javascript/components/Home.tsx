import React, { useState } from 'react';
import CopyToClipboardButton from './CopyToClipboardButton';

interface ShrunkenUrl {
  body: string;
}

const Home: React.FC = () => {
  const [data, setData] = useState<ShrunkenUrl[]>(null);
  const [input, setInput] = useState<string>('');

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInput(event.target.value);
  };

  const getCsrfToken = () => {
	const csrfMetaTag = document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement;
	return csrfMetaTag?.content;
  };

  const fetchData = async () => {
    try {
      const csrfToken = getCsrfToken();
	  const response = await fetch('/shorten', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken || '',
        },
        body: JSON.stringify({ data: input }),
      });
      const json: ShrunkenUrl[] = await response.json();
      setData(json.data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    fetchData();
  };

  // Render the component
  return (
	<div className="fl w-100 pv1">
	  <h1 className="db">Shorten this url as it is way too long and a shorter one would be appreciated</h1>
	  <p className="db">
		Move over, TinyUrl, there's a new URL shortener in metaphorical-town!
	  </p>
      <form onSubmit={handleSubmit}>
        <input className='db w-100' type="text" value={input} onChange={handleInputChange} />
        <button className='db w-100 underline blue pointer bg-light-green hover-bg-green hover-white' type="submit">
          Shortenification
        </button>
      </form>
      { data && <div className='db pt4'>
          <span className='db pb1'>Success!</span>
          {data}
          <CopyToClipboardButton text={data} />
        </div>
      }
    </div>
  );
};

export default Home;

