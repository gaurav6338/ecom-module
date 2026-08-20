import React from 'react';
import { ShoppingBag, ShieldCheck, Truck, RefreshCw, Headphones } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-slate-900 text-slate-300 border-t border-slate-800 mt-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Features Row */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 pb-10 border-b border-slate-800">
          <div className="flex items-center space-x-3">
            <div className="p-3 bg-indigo-600/20 text-indigo-400 rounded-xl">
              <Truck size={24} />
            </div>
            <div>
              <h4 className="font-bold text-white text-sm">Free Express Shipping</h4>
              <p className="text-xs text-slate-400">On orders over ₹2,000</p>
            </div>
          </div>

          <div className="flex items-center space-x-3">
            <div className="p-3 bg-emerald-600/20 text-emerald-400 rounded-xl">
              <ShieldCheck size={24} />
            </div>
            <div>
              <h4 className="font-bold text-white text-sm">100% Secure Checkout</h4>
              <p className="text-xs text-slate-400">Encrypted payment gateway</p>
            </div>
          </div>

          <div className="flex items-center space-x-3">
            <div className="p-3 bg-amber-600/20 text-amber-400 rounded-xl">
              <RefreshCw size={24} />
            </div>
            <div>
              <h4 className="font-bold text-white text-sm">30 Days Easy Returns</h4>
              <p className="text-xs text-slate-400">No questions asked policy</p>
            </div>
          </div>

          <div className="flex items-center space-x-3">
            <div className="p-3 bg-purple-600/20 text-purple-400 rounded-xl">
              <Headphones size={24} />
            </div>
            <div>
              <h4 className="font-bold text-white text-sm">24/7 Dedicated Support</h4>
              <p className="text-xs text-slate-400">Instant expert assistance</p>
            </div>
          </div>
        </div>

        {/* Links Footer */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 pt-10">
          <div>
            <div className="flex items-center space-x-2 mb-4">
              <div className="p-1.5 bg-indigo-600 rounded-lg text-white">
                <ShoppingBag size={18} />
              </div>
              <span className="text-lg font-bold text-white">StyleNest</span>
            </div>
            <p className="text-xs text-slate-400 leading-relaxed">
              Premium production-level E-Commerce shopping platform delivering luxury acoustics, fashion, footwear, electronics, and accessories.
            </p>
          </div>

          <div>
            <h5 className="font-bold text-white text-sm mb-3">Shop Categories</h5>
            <ul className="space-y-2 text-xs text-slate-400">
              <li>Electronics & Laptops</li>
              <li>Audio & Noise Cancellation</li>
              <li>Smart Watches & Fitness</li>
              <li>Footwear & Athletic Sneakers</li>
              <li>Fashion & Apparel</li>
            </ul>
          </div>

          <div>
            <h5 className="font-bold text-white text-sm mb-3">Customer Support</h5>
            <ul className="space-y-2 text-xs text-slate-400">
              <li>Track Order History</li>
              <li>Shipping & Delivery Policy</li>
              <li>Returns & Refunds</li>
              <li>Terms of Service</li>
              <li>Privacy Policy</li>
            </ul>
          </div>

          <div>
            <h5 className="font-bold text-white text-sm mb-3">Demo Accounts</h5>
            <div className="bg-slate-800 p-3 rounded-xl border border-slate-700 text-xs space-y-1">
              <p className="font-semibold text-indigo-400">Customer: Rishi Kumar</p>
              <p className="text-slate-400">rishi@gmail.com / rishi123</p>
              <p className="font-semibold text-emerald-400 pt-1">Administrator: Admin</p>
              <p className="text-slate-400">admin@gmail.com / admin123</p>
            </div>
          </div>
        </div>

        <div className="mt-10 pt-6 border-t border-slate-800 text-center text-xs text-slate-500">
          © 2026 StyleNest E-Commerce Inc. All rights reserved.
        </div>
      </div>
    </footer>
  );
}
