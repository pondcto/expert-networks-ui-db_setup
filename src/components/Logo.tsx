
import { Link } from 'react-router-dom';

export default function Logo() {
  return (
    <Link to="/" className="flex items-end ml-[0.1in] select-none gap-3" title="Go to home">
      {/* Light mode logo - gradient */}
      <img
        src="/images/windshift-wordmark-gradient.png"
        alt="WindShift"
        width={120}
        height={30}
        className="h-[1.9rem] w-auto dark:hidden"
      />
      {/* Dark mode logo - sky blue */}
      <img
        src="/images/windshift-wordmark-sky-blue.png"
        alt="WindShift"
        width={120}
        height={30}
        className="h-[1.9rem] w-auto hidden dark:inline"
      />
      <span className="text-body font-medium text-primary-600/80 dark:text-primary-300/80 whitespace-nowrap pb-[1px]">
        Expert Networks Module
      </span>
    </Link>
  );
}


