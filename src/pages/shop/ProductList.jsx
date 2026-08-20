import React, { useState } from 'react';
import { SlidersHorizontal, Search, X } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import ProductCard from '../../components/ProductCard';

export default function ProductList() {
  const { products, categories, searchQuery, setSearchQuery, selectedCategory, setSelectedCategory } = useApp();
  const [maxPrice, setMaxPrice] = useState(150000);
  const [sortBy, setSortBy] = useState('featured');

  const filteredProducts = products.filter((product) => {
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchName = product.name.toLowerCase().includes(q);
      const matchCat = product.category.toLowerCase().includes(q);
      const matchDesc = product.description.toLowerCase().includes(q);
      if (!matchName && !matchCat && !matchDesc) return false;
    }

    if (selectedCategory !== 'All' && product.category !== selectedCategory) {
      return false;
    }

    if (product.price > maxPrice) {
      return false;
    }

    return true;
  }).sort((a, b) => {
    if (sortBy === 'price-low') return a.price - b.price;
    if (sortBy === 'price-high') return b.price - a.price;
    if (sortBy === 'rating') return b.rating - a.rating;
    return 0;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
      {/* Header Bar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-gray-200 dark:border-slate-800">
        <div>
          <h1 className="text-3xl font-black text-gray-900 dark:text-white">Product Catalog</h1>
          <p className="text-sm text-gray-500 mt-1">Showing {filteredProducts.length} items</p>
        </div>

        {/* Controls */}
        <div className="flex flex-wrap items-center gap-3">
          <div className="relative flex-1 sm:w-64">
            <input
              type="text"
              placeholder="Filter catalog..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-8 py-2 bg-white dark:bg-slate-800 text-sm rounded-xl border border-gray-200 dark:border-slate-700 dark:text-white focus:ring-2 focus:ring-indigo-500"
            />
            <Search className="absolute left-3 top-2.5 text-gray-400" size={16} />
            {searchQuery && (
              <button onClick={() => setSearchQuery('')} className="absolute right-2.5 top-2.5 text-gray-400">
                <X size={16} />
              </button>
            )}
          </div>

          <select
            value={selectedCategory}
            onChange={(e) => setSelectedCategory(e.target.value)}
            className="px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm font-semibold text-gray-700 dark:text-gray-200 focus:ring-2 focus:ring-indigo-500"
          >
            <option value="All">All Categories</option>
            {categories.map((cat) => (
              <option key={cat.id} value={cat.name}>
                {cat.name}
              </option>
            ))}
          </select>

          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value)}
            className="px-3 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm font-semibold text-gray-700 dark:text-gray-200 focus:ring-2 focus:ring-indigo-500"
          >
            <option value="featured">Featured</option>
            <option value="price-low">Price: Low to High</option>
            <option value="price-high">Price: High to Low</option>
            <option value="rating">Top Rated</option>
          </select>
        </div>
      </div>

      {/* Grid */}
      {filteredProducts.length === 0 ? (
        <div className="text-center py-20 bg-white dark:bg-slate-800 rounded-3xl border border-gray-100 dark:border-slate-700">
          <Search size={48} className="mx-auto text-gray-400 mb-4" />
          <h3 className="text-lg font-bold text-gray-900 dark:text-white">No products found</h3>
          <p className="text-sm text-gray-500 mt-1">Try adjusting your search or category filters</p>
          <button
            onClick={() => {
              setSearchQuery('');
              setSelectedCategory('All');
            }}
            className="mt-4 px-4 py-2 bg-indigo-600 text-white font-bold rounded-xl text-sm"
          >
            Reset All Filters
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {filteredProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  );
}
