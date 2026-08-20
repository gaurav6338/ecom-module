import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Heart, ShoppingBag } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import RatingStars from '../../components/RatingStars';

export default function ProductDetails() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { products, wishlist, toggleWishlist, addToCart } = useApp();

  const product = products.find((p) => p.id === id) || products[0];
  const isWishlisted = wishlist.includes(product.id);

  const [selectedColor, setSelectedColor] = useState(product.colors[0] || 'Default');
  const [selectedSize, setSelectedSize] = useState(product.sizes[0] || 'Standard');
  const [quantity, setQuantity] = useState(1);

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const handleBuyNow = () => {
    addToCart(product, selectedSize, selectedColor, quantity);
    navigate('/checkout');
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-12">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-start">
        {/* Left Column: Product Image Gallery */}
        <div className="space-y-4">
          <div className="aspect-square rounded-3xl overflow-hidden bg-white dark:bg-slate-800 border border-gray-100 dark:border-slate-700 shadow-lg relative">
            <img
              src={product.imageUrl}
              alt={product.name}
              className="w-full h-full object-cover"
            />
            {product.discountPercentage > 0 && (
              <span className="absolute top-4 left-4 bg-red-500 text-white font-bold text-xs px-3 py-1.5 rounded-full shadow-lg">
                {product.discountPercentage}% OFF
              </span>
            )}
            <button
              onClick={() => toggleWishlist(product.id)}
              className="absolute top-4 right-4 p-3 rounded-full bg-white/90 dark:bg-slate-800/90 text-gray-700 dark:text-gray-200 hover:text-red-500 shadow-md backdrop-blur-sm"
            >
              <Heart size={20} className={isWishlisted ? 'fill-red-500 text-red-500' : ''} />
            </button>
          </div>
        </div>

        {/* Right Column: Product Information & Purchase Actions */}
        <div className="space-y-6">
          <div>
            <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 dark:text-indigo-400">
              {product.category}
            </span>
            <h1 className="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white mt-1">
              {product.name}
            </h1>
            <div className="flex items-center space-x-3 mt-3">
              <RatingStars rating={product.rating} size={18} />
              <span className="text-sm font-bold text-gray-900 dark:text-white">{product.rating}</span>
              <span className="text-sm text-gray-400">({product.reviewCount} customer reviews)</span>
              <span className="text-gray-300">|</span>
              <span className={`text-xs font-bold px-2.5 py-1 rounded-full ${
                product.stock > 0 ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300' : 'bg-red-100 text-red-800'
              }`}>
                {product.stock > 0 ? `In Stock (${product.stock} left)` : 'Out of Stock'}
              </span>
            </div>
          </div>

          {/* Pricing */}
          <div className="flex items-baseline space-x-4 p-4 bg-gray-50 dark:bg-slate-800/50 rounded-2xl border border-gray-100 dark:border-slate-700">
            <span className="text-3xl font-black text-indigo-600 dark:text-indigo-400">
              {formatCurrency(product.price)}
            </span>
            {product.originalPrice > product.price && (
              <span className="text-base text-gray-400 line-through">
                {formatCurrency(product.originalPrice)}
              </span>
            )}
          </div>

          <p className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
            {product.description}
          </p>

          {/* Color Selection */}
          {product.colors.length > 0 && (
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-2">
                Available Color: <span className="text-indigo-600">{selectedColor}</span>
              </label>
              <div className="flex flex-wrap gap-2">
                {product.colors.map((color) => (
                  <button
                    key={color}
                    onClick={() => setSelectedColor(color)}
                    className={`px-4 py-2 text-xs font-semibold rounded-xl border transition-all ${
                      selectedColor === color
                        ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-300'
                        : 'border-gray-200 dark:border-slate-700 text-gray-700 dark:text-gray-300'
                    }`}
                  >
                    {color}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Size Selection */}
          {product.sizes.length > 0 && (
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-2">
                Available Size: <span className="text-indigo-600">{selectedSize}</span>
              </label>
              <div className="flex flex-wrap gap-2">
                {product.sizes.map((size) => (
                  <button
                    key={size}
                    onClick={() => setSelectedSize(size)}
                    className={`px-4 py-2 text-xs font-semibold rounded-xl border transition-all ${
                      selectedSize === size
                        ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-300'
                        : 'border-gray-200 dark:border-slate-700 text-gray-700 dark:text-gray-300'
                    }`}
                  >
                    {size}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Quantity Selector */}
          <div>
            <label className="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-2">
              Quantity
            </label>
            <div className="flex items-center space-x-3">
              <div className="flex items-center border border-gray-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800">
                <button
                  onClick={() => setQuantity(Math.max(1, quantity - 1))}
                  className="px-3 py-2 text-gray-600 hover:bg-gray-100 dark:hover:bg-slate-700 font-bold"
                >
                  -
                </button>
                <span className="px-4 font-bold text-sm text-gray-900 dark:text-white">{quantity}</span>
                <button
                  onClick={() => setQuantity(quantity + 1)}
                  className="px-3 py-2 text-gray-600 hover:bg-gray-100 dark:hover:bg-slate-700 font-bold"
                >
                  +
                </button>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 pt-4">
            <button
              onClick={() => addToCart(product, selectedSize, selectedColor, quantity)}
              className="flex-1 py-3.5 bg-indigo-50 hover:bg-indigo-100 dark:bg-indigo-950/60 dark:hover:bg-indigo-900/60 text-indigo-600 dark:text-indigo-300 font-bold rounded-2xl border border-indigo-200 dark:border-indigo-800 flex items-center justify-center space-x-2 transition-all"
            >
              <ShoppingBag size={18} />
              <span>Add to Cart</span>
            </button>

            <button
              onClick={handleBuyNow}
              className="flex-1 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-lg shadow-indigo-200 dark:shadow-none flex items-center justify-center space-x-2 transition-all"
            >
              <span>Buy Now</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
