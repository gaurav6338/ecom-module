import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Trash2, Plus, Minus, ArrowRight, ShoppingBag, Tag } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function Cart() {
  const {
    cart,
    updateCartQty,
    removeFromCart,
    cartSubtotal,
    cartDiscountAmount,
    cartTax,
    cartShippingFee,
    cartTotalAmount,
    appliedCoupon,
    setAppliedCoupon
  } = useApp();

  const [couponInput, setCouponInput] = useState('');
  const navigate = useNavigate();

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const handleApplyCoupon = (e) => {
    e.preventDefault();
    const clean = couponInput.trim().toUpperCase();
    if (clean === 'DISCOUNT20' || clean === 'WELCOME10') {
      setAppliedCoupon(clean);
    } else {
      alert('Invalid coupon code. Try DISCOUNT20');
    }
  };

  if (cart.length === 0) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
        <div className="max-w-md mx-auto bg-white dark:bg-slate-800 p-8 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm">
          <ShoppingBag size={64} className="mx-auto text-gray-400 mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white">Your Shopping Cart is Empty</h2>
          <p className="text-sm text-gray-500 mt-2">Explore items and add products to your cart</p>
          <Link
            to="/products"
            className="inline-block mt-6 px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-md transition-all"
          >
            Explore Catalog
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      <h1 className="text-3xl font-black text-gray-900 dark:text-white">Shopping Cart ({cart.length})</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
        {/* Cart Items List */}
        <div className="lg:col-span-2 space-y-4">
          {cart.map((item, index) => (
            <div
              key={`${item.product.id}-${index}`}
              className="bg-white dark:bg-slate-800 p-4 rounded-2xl border border-gray-100 dark:border-slate-700 shadow-sm flex flex-col sm:flex-row items-center gap-4"
            >
              <img
                src={item.product.imageUrl}
                alt={item.product.name}
                className="w-20 h-20 object-cover rounded-xl bg-gray-100"
              />
              <div className="flex-1 text-center sm:text-left">
                <h3 className="font-bold text-gray-900 dark:text-white text-sm line-clamp-1">{item.product.name}</h3>
                <p className="text-xs text-gray-400 mt-0.5">
                  Color: {item.selectedColor} | Size: {item.selectedSize}
                </p>
                <p className="text-sm font-bold text-indigo-600 dark:text-indigo-400 mt-1">
                  {formatCurrency(item.product.price)}
                </p>
              </div>

              {/* Quantity Controls */}
              <div className="flex items-center space-x-2 border border-gray-200 dark:border-slate-700 rounded-xl px-2 py-1">
                <button
                  onClick={() => updateCartQty(index, -1)}
                  className="p-1 hover:bg-gray-100 dark:hover:bg-slate-700 rounded text-gray-600"
                >
                  <Minus size={14} />
                </button>
                <span className="px-2 text-sm font-bold text-gray-900 dark:text-white">{item.quantity}</span>
                <button
                  onClick={() => updateCartQty(index, 1)}
                  className="p-1 hover:bg-gray-100 dark:hover:bg-slate-700 rounded text-gray-600"
                >
                  <Plus size={14} />
                </button>
              </div>

              <div className="text-right">
                <p className="font-bold text-gray-900 dark:text-white text-sm">
                  {formatCurrency(item.totalPrice)}
                </p>
                <button
                  onClick={() => removeFromCart(index)}
                  className="text-xs text-red-500 hover:text-red-700 font-semibold mt-1 inline-flex items-center space-x-1"
                >
                  <Trash2 size={14} />
                  <span>Remove</span>
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Cart Summary Card */}
        <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-xl space-y-6">
          <h2 className="text-lg font-bold text-gray-900 dark:text-white">Order Summary</h2>

          {/* Coupon Code Input */}
          <form onSubmit={handleApplyCoupon} className="flex gap-2">
            <input
              type="text"
              placeholder="Coupon code (DISCOUNT20)"
              value={couponInput}
              onChange={(e) => setCouponInput(e.target.value)}
              className="flex-1 px-3 py-2 bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-xl text-xs uppercase font-bold focus:ring-2 focus:ring-indigo-500 dark:text-white"
            />
            <button type="submit" className="px-4 py-2 bg-indigo-600 text-white font-bold text-xs rounded-xl">
              Apply
            </button>
          </form>

          {appliedCoupon && (
            <div className="flex items-center justify-between text-xs text-emerald-600 dark:text-emerald-400 font-bold bg-emerald-50 dark:bg-emerald-950/60 p-2.5 rounded-xl">
              <span className="flex items-center space-x-1">
                <Tag size={14} />
                <span>Coupon ({appliedCoupon}) Applied</span>
              </span>
              <button onClick={() => setAppliedCoupon(null)} className="text-red-500 hover:underline">
                Remove
              </button>
            </div>
          )}

          <div className="space-y-3 text-sm border-t border-gray-100 dark:border-slate-700 pt-4">
            <div className="flex justify-between text-gray-600 dark:text-gray-400">
              <span>Subtotal</span>
              <span>{formatCurrency(cartSubtotal)}</span>
            </div>
            {cartDiscountAmount > 0 && (
              <div className="flex justify-between text-emerald-600 font-bold">
                <span>Discount Savings</span>
                <span>-{formatCurrency(cartDiscountAmount)}</span>
              </div>
            )}
            <div className="flex justify-between text-gray-600 dark:text-gray-400">
              <span>Tax (5% GST)</span>
              <span>{formatCurrency(cartTax)}</span>
            </div>
            <div className="flex justify-between text-gray-600 dark:text-gray-400">
              <span>Delivery Fee</span>
              <span>{cartShippingFee === 0 ? 'FREE' : formatCurrency(cartShippingFee)}</span>
            </div>
            <div className="flex justify-between text-base font-extrabold text-gray-900 dark:text-white pt-2 border-t border-gray-100 dark:border-slate-700">
              <span>Total Amount</span>
              <span className="text-indigo-600 dark:text-indigo-400">{formatCurrency(cartTotalAmount)}</span>
            </div>
          </div>

          <button
            onClick={() => navigate('/checkout')}
            className="w-full py-4 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-lg shadow-indigo-200 dark:shadow-none flex items-center justify-center space-x-2 transition-all"
          >
            <span>Proceed to Checkout</span>
            <ArrowRight size={18} />
          </button>
        </div>
      </div>
    </div>
  );
}
