import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { MapPin, CreditCard, Wallet, Truck, CheckCircle2 } from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function Checkout() {
  const {
    currentUser,
    cart,
    cartSubtotal,
    cartDiscountAmount,
    cartTax,
    cartShippingFee,
    cartTotalAmount,
    createOrder
  } = useApp();

  const [paymentMethod, setPaymentMethod] = useState('Credit Card');
  const [isProcessing, setIsProcessing] = useState(false);
  const navigate = useNavigate();

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const handlePlaceOrder = () => {
    setIsProcessing(true);
    setTimeout(() => {
      const order = createOrder({
        items: cart,
        subtotal: cartSubtotal,
        tax: cartTax,
        shippingFee: cartShippingFee,
        discountAmount: cartDiscountAmount,
        totalAmount: cartTotalAmount,
        paymentMethod,
      });

      setIsProcessing(false);
      navigate(`/order-confirmation/${order.id}`, { state: { order } });
    }, 1000);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
      <h1 className="text-3xl font-black text-gray-900 dark:text-white">Checkout</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
        {/* Shipping & Payment Form */}
        <div className="lg:col-span-2 space-y-6">
          {/* Shipping Address */}
          <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-4">
            <h2 className="text-lg font-bold text-gray-900 dark:text-white flex items-center space-x-2">
              <MapPin className="text-indigo-600" size={20} />
              <span>Shipping Address</span>
            </h2>

            <div className="p-4 bg-gray-50 dark:bg-slate-900 rounded-2xl border border-gray-100 dark:border-slate-700 space-y-1">
              <p className="font-bold text-gray-900 dark:text-white text-sm">{currentUser?.name || 'Rishi Kumar'}</p>
              <p className="text-xs text-gray-600 dark:text-gray-400">
                {currentUser?.address || '42 Lotus Heights, MG Road, Bengaluru, Karnataka - 560001'}
              </p>
              <p className="text-xs text-gray-500 pt-1">Phone: {currentUser?.phone || '+91 98765 43210'}</p>
            </div>
          </div>

          {/* Payment Method */}
          <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-4">
            <h2 className="text-lg font-bold text-gray-900 dark:text-white flex items-center space-x-2">
              <CreditCard className="text-indigo-600" size={20} />
              <span>Payment Method</span>
            </h2>

            <div className="space-y-3">
              <label
                onClick={() => setPaymentMethod('Credit Card')}
                className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-all ${
                  paymentMethod === 'Credit Card'
                    ? 'border-indigo-600 bg-indigo-50/50 dark:bg-indigo-950/40'
                    : 'border-gray-200 dark:border-slate-700'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <CreditCard className="text-indigo-600" />
                  <div>
                    <p className="font-bold text-sm text-gray-900 dark:text-white">Credit / Debit Card</p>
                    <p className="text-xs text-gray-500">Visa, Mastercard, RuPay</p>
                  </div>
                </div>
                <input type="radio" name="payment" checked={paymentMethod === 'Credit Card'} readOnly className="text-indigo-600" />
              </label>

              <label
                onClick={() => setPaymentMethod('UPI')}
                className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-all ${
                  paymentMethod === 'UPI'
                    ? 'border-indigo-600 bg-indigo-50/50 dark:bg-indigo-950/40'
                    : 'border-gray-200 dark:border-slate-700'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <Wallet className="text-emerald-600" />
                  <div>
                    <p className="font-bold text-sm text-gray-900 dark:text-white">UPI / Google Pay / PhonePe</p>
                    <p className="text-xs text-gray-500">Instant virtual payment</p>
                  </div>
                </div>
                <input type="radio" name="payment" checked={paymentMethod === 'UPI'} readOnly className="text-indigo-600" />
              </label>

              <label
                onClick={() => setPaymentMethod('COD')}
                className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-all ${
                  paymentMethod === 'COD'
                    ? 'border-indigo-600 bg-indigo-50/50 dark:bg-indigo-950/40'
                    : 'border-gray-200 dark:border-slate-700'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <Truck className="text-amber-600" />
                  <div>
                    <p className="font-bold text-sm text-gray-900 dark:text-white">Cash on Delivery (COD)</p>
                    <p className="text-xs text-gray-500">Pay cash upon delivery</p>
                  </div>
                </div>
                <input type="radio" name="payment" checked={paymentMethod === 'COD'} readOnly className="text-indigo-600" />
              </label>
            </div>
          </div>
        </div>

        {/* Order Summary */}
        <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-xl space-y-6">
          <h2 className="text-lg font-bold text-gray-900 dark:text-white">Items Breakdown</h2>

          <div className="space-y-3 max-h-60 overflow-y-auto pr-1">
            {cart.map((item, idx) => (
              <div key={idx} className="flex items-center space-x-3 text-xs">
                <img src={item.product.imageUrl} alt={item.product.name} className="w-10 h-10 object-cover rounded-lg" />
                <div className="flex-1">
                  <p className="font-bold text-gray-900 dark:text-white line-clamp-1">{item.product.name}</p>
                  <p className="text-gray-400">Qty: {item.quantity}</p>
                </div>
                <span className="font-bold text-gray-900 dark:text-white">{formatCurrency(item.totalPrice)}</span>
              </div>
            ))}
          </div>

          <div className="space-y-2 text-sm border-t border-gray-100 dark:border-slate-700 pt-4">
            <div className="flex justify-between text-gray-600 dark:text-gray-400">
              <span>Subtotal</span>
              <span>{formatCurrency(cartSubtotal)}</span>
            </div>
            {cartDiscountAmount > 0 && (
              <div className="flex justify-between text-emerald-600 font-bold">
                <span>Discount</span>
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
            onClick={handlePlaceOrder}
            disabled={isProcessing}
            className="w-full py-4 bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white font-bold rounded-2xl shadow-lg shadow-indigo-200 dark:shadow-none flex items-center justify-center space-x-2 transition-all"
          >
            {isProcessing ? (
              <span>Processing Payment...</span>
            ) : (
              <>
                <CheckCircle2 size={18} />
                <span>Place Order Now</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
