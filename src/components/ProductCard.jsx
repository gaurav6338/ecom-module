import React from 'react';
import { Link } from 'react-router-dom';
import { Heart, ShoppingBag, Star } from 'lucide-react';
import { useApp } from '../context/AppContext';
import RatingStars from './RatingStars';

export default function ProductCard({ product }) {
  const { wishlist, toggleWishlist, addToCart } = useApp();
  const isWishlisted = wishlist.includes(product.id);

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  return (
    <div className="group relative bg-white dark:bg-slate-800 rounded-2xl border border-gray-100 dark:border-slate-700 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden">
      {/* Image Header */}
      <div className="relative aspect-square overflow-hidden bg-gray-100 dark:bg-slate-900">
        <img
          src={product.imageUrl}
          alt={product.name}
          className="h-full w-full object-cover object-center group-hover:scale-108 transition-transform duration-500"
        />
        {/* Discount Badge */}
        {product.discountPercentage > 0 && (
          <span className="absolute top-3 left-3 bg-red-500 text-white text-xs font-bold px-2.5 py-1 rounded-full shadow-md">
            {product.discountPercentage}% OFF
          </span>
        )}
        {/* Wishlist Button */}
        <button
          onClick={(e) => {
            e.preventDefault();
            toggleWishlist(product.id);
          }}
          className="absolute top-3 right-3 p-2 rounded-full bg-white/90 dark:bg-slate-800/90 text-gray-700 dark:text-gray-200 hover:text-red-500 transition-colors shadow-md backdrop-blur-sm"
        >
          <Heart size={18} className={isWishlisted ? 'fill-red-500 text-red-500' : ''} />
        </button>
      </div>

      {/* Details Body */}
      <div className="p-4 flex-1 flex flex-col justify-between">
        <div>
          <span className="text-xs font-semibold text-indigo-600 dark:text-indigo-400 tracking-wider uppercase">
            {product.category}
          </span>
          <Link to={`/product/${product.id}`}>
            <h3 className="text-sm font-bold text-gray-900 dark:text-white line-clamp-1 mt-1 hover:text-indigo-600 transition-colors">
              {product.name}
            </h3>
          </Link>
          <div className="flex items-center space-x-1.5 mt-2">
            <RatingStars rating={product.rating} size={14} />
            <span className="text-xs font-semibold text-gray-700 dark:text-gray-300">{product.rating}</span>
            <span className="text-xs text-gray-400">({product.reviewCount})</span>
          </div>
        </div>

        <div className="flex items-center justify-between mt-4 pt-3 border-t border-gray-100 dark:border-slate-700">
          <div>
            {product.originalPrice > product.price && (
              <span className="text-xs text-gray-400 line-through block">
                {formatCurrency(product.originalPrice)}
              </span>
            )}
            <span className="text-base font-bold text-indigo-600 dark:text-indigo-400">
              {formatCurrency(product.price)}
            </span>
          </div>
          <button
            onClick={() => addToCart(product)}
            className="p-2.5 bg-indigo-600 hover:bg-indigo-700 active:scale-95 text-white rounded-xl shadow-md shadow-indigo-200 dark:shadow-none transition-all flex items-center justify-center"
            title="Add to Cart"
          >
            <ShoppingBag size={16} />
          </button>
        </div>
      </div>
    </div>
  );
}
