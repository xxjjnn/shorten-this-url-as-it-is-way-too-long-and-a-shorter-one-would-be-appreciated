import React, { useState } from 'react';
import { CopyToClipboard } from 'react-copy-to-clipboard';

interface CopyToClipboardButtonProps {
  text: string;
}

const CopyToClipboardButton: React.FC<CopyToClipboardButtonProps> = ({ text }) => {
  const [isCopied, setIsCopied] = useState(false);

  const handleCopy = () => {
    setIsCopied(true);
    setTimeout(() => setIsCopied(false), 2000);
  };

  return (
    <div>
      <CopyToClipboard text={text} onCopy={handleCopy}>
        <button>
          {isCopied ? 'Copied!' : 'Copy to clipboard'}
        </button>
      </CopyToClipboard>
    </div>
  );
};

export default CopyToClipboardButton;

