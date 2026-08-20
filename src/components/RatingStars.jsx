import React from 'react';
import { Star, StarHalf } from 'lucide-react';

export default function RatingStars({ rating, size = 16 }) {
  const stars = [];
  for (let i = 1; i <= 5; i++) {
    if (rating >= i) {
      stars.push(<Star key={i} size={size} className="fill-amber-400 text-amber-400" />);
    } else if (rating >= i - 0.5) {
      stars.push(<StarHalf key={i} size={size} className="fill-amber-400 text-amber-400" />);
    } else {
      stars.push(<Star key={i} size={size} className="text-gray-300 dark:text-gray-600" />);
    }
  }

  return <div className="flex items-center space-x-0.5">{stars}</div>;
}
