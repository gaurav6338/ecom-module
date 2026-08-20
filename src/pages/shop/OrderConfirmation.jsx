import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { CheckCircle2, ArrowRight, Package } from 'lucide-react';

export default function OrderConfirmation() {
  const location = useLocation();
  const order = location.state?.order || {
    id: 'ORD-98421',
    totalAmount: 18473,
    paymentMethod: 'Credit Card',
    createdAt: new Date().toISOString(),
  };

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  return (
    <div className="max-w-3xl mx-auto px-4 py-16 text-center space-y-8">
      <div className="p-6 bg-emerald-50 dark:bg-emerald-950/60 rounded-full w-24 h-24 mx-auto flex items-center justify-center text-emerald-600 dark:text-emerald-400">
        <CheckCircle2 size={48} />
      </div>

      <div className="space-y-2">
        <h1 className="text-3xl font-black text-gray-900 dark:text-white">Order Confirmed!</h1>
        <p className="text-sm text-gray-500 max-w-md mx-auto">
          Thank you for shopping with us! Your order <span className="font-mono font-bold text-gray-900 dark:text-white">#{order.id}</span> has been created.
        </p>
      </div>

      <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm text-left max-w-md mx-auto space-y-3 text-sm">
        <div className="flex justify-between">
          <span className="text-gray-500">Order ID:</span>
          <span className="font-bold text-gray-900 dark:text-white">{order.id}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-500">Payment Method:</span>
          <span className="font-bold text-gray-900 dark:text-white">{order.paymentMethod}</span>
        </div>
        <div className="flex justify-between border-t border-gray-100 dark:border-slate-700 pt-3">
          <span className="font-bold text-gray-900 dark:text-white">Total Amount Paid:</span>
          <span className="font-black text-indigo-600 dark:text-indigo-400 text-base">{formatCurrency(order.totalAmount)}</span>
        </div>
      </div>

      <div className="flex flex-col sm:flex-row gap-4 justify-center pt-4">
        <Link
          to="/user/orders"
          className="px-6 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-2xl shadow-lg shadow-indigo-200 dark:shadow-none flex items-center justify-center space-x-2"
        >
          <Package size={18} />
          <span>Track Order History</span>
        </Link>
        <Link
          to="/products"
          className="px-6 py-3.5 bg-gray-100 dark:bg-slate-800 text-gray-800 dark:text-gray-200 font-bold rounded-2xl flex items-center justify-center space-x-2"
        >
          <span>Continue Shopping</span>
          <ArrowRight size={18} />
        </Link>
      </div>
    </div>
  );
}
