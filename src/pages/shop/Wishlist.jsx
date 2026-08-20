import React from 'react';
import { Heart } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import ProductCard from '../../components/ProductCard';

export default function Wishlist() {
  const { products, wishlist } = useApp();
  const wishlistedProducts = products.filter((p) => wishlist.includes(p.id));

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      <h1 className="text-3xl font-black text-gray-900 dark:text-white flex items-center space-x-3">
        <Heart className="text-red-500 fill-red-500" />
        <span>My Wishlist ({wishlistedProducts.length})</span>
      </h1>

      {wishlistedProducts.length === 0 ? (
        <div className="text-center py-20 bg-white dark:bg-slate-800 rounded-3xl border border-gray-100 dark:border-slate-700">
          <Heart size={48} className="mx-auto text-gray-400 mb-4" />
          <h3 className="text-lg font-bold text-gray-900 dark:text-white">Your wishlist is empty</h3>
          <p className="text-sm text-gray-500 mt-1">Explore catalog and save your favorite products</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {wishlistedProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  );
}
