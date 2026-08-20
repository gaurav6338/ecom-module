import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Sparkles, ArrowRight, TrendingUp, ShieldCheck, Award } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import ProductCard from '../../components/ProductCard';

export default function Home() {
  const { products, categories, setSelectedCategory } = useApp();
  const navigate = useNavigate();

  const featuredProducts = products.filter(p => p.isFeatured);
  const trendingProducts = products.filter(p => p.isTrending);

  return (
    <div className="space-y-16 pb-16">
      {/* Hero Promotional Banner */}
      <section className="relative rounded-3xl overflow-hidden bg-gradient-to-r from-indigo-600 via-indigo-700 to-indigo-900 text-white shadow-2xl">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.15),transparent_50%)]" />
        <div className="max-w-7xl mx-auto px-6 lg:px-12 py-16 lg:py-24 relative z-10 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-6">
            <span className="inline-flex items-center space-x-2 px-3.5 py-1.5 rounded-full bg-white/10 backdrop-blur-md border border-white/20 text-xs font-bold uppercase tracking-wider text-indigo-200">
              <Sparkles size={14} className="text-amber-400" />
              <span>Special Offer • 20% OFF</span>
            </span>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-tight">
              Upgrade Your <br />
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-300 to-amber-500">
                Tech & Lifestyle
              </span>
            </h1>
            <p className="text-indigo-100 text-base sm:text-lg max-w-xl leading-relaxed">
              Explore luxury noise-cancelling headphones, AMOLED retina smart watches, athletic footwear, and high-performance laptops. Use code <span className="font-mono font-bold text-amber-300">DISCOUNT20</span> at checkout.
            </p>
            <div className="flex flex-wrap gap-4 pt-2">
              <Link
                to="/products"
                className="px-6 py-3.5 bg-amber-400 hover:bg-amber-300 text-slate-900 font-bold rounded-2xl shadow-lg shadow-amber-500/30 transition-all flex items-center space-x-2"
              >
                <span>Shop Catalog Now</span>
                <ArrowRight size={18} />
              </Link>
            </div>
          </div>

          <div className="hidden lg:block relative">
            <div className="relative mx-auto max-w-md aspect-square rounded-3xl overflow-hidden shadow-2xl border-4 border-white/20 transform rotate-2 hover:rotate-0 transition-transform duration-500">
              <img
                src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80"
                alt="Hero Product"
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent flex items-end p-6">
                <div>
                  <span className="text-xs font-bold text-amber-400 uppercase">Top Seller</span>
                  <p className="text-lg font-bold text-white">Pro Noise-Cancelling Headphones X1</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Categories Grid */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-extrabold text-gray-900 dark:text-white">Featured Categories</h2>
            <p className="text-sm text-gray-500 mt-1">Browse top trending products by category</p>
          </div>
          <Link to="/products" className="text-indigo-600 dark:text-indigo-400 font-bold text-sm hover:underline flex items-center space-x-1">
            <span>Explore All</span>
            <ArrowRight size={16} />
          </Link>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
          {categories.map((cat) => (
            <div
              key={cat.id}
              onClick={() => {
                setSelectedCategory(cat.name);
                navigate('/products');
              }}
              className="group cursor-pointer bg-white dark:bg-slate-800 rounded-2xl p-3 border border-gray-100 dark:border-slate-700 shadow-sm hover:shadow-lg hover:border-indigo-500 transition-all text-center"
            >
              <div className="aspect-square rounded-xl overflow-hidden mb-3 bg-gray-100">
                <img
                  src={cat.imageUrl}
                  alt={cat.name}
                  className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                />
              </div>
              <h3 className="font-bold text-xs text-gray-900 dark:text-white line-clamp-1">{cat.name}</h3>
              <p className="text-[10px] text-gray-400 mt-0.5">{cat.count}+ Products</p>
            </div>
          ))}
        </div>
      </section>

      {/* Featured Products */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-extrabold text-gray-900 dark:text-white flex items-center space-x-2">
              <Award className="text-amber-500" />
              <span>Featured Products</span>
            </h2>
            <p className="text-sm text-gray-500 mt-1">Handpicked premium products for you</p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {featuredProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </section>

      {/* Trending Deals Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-extrabold text-gray-900 dark:text-white flex items-center space-x-2">
              <TrendingUp className="text-indigo-600" />
              <span>Trending Deals & Offers 🔥</span>
            </h2>
            <p className="text-sm text-gray-500 mt-1">Popular items moving fast today</p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {trendingProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </section>
    </div>
  );
}
