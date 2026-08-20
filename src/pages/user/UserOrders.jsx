import React from 'react';
import { useApp } from '../../context/AppContext';
import OrderStatusBadge from '../../components/OrderStatusBadge';

export default function UserOrders() {
  const { currentUser, orders } = useApp();
  const userOrders = orders.filter(o => o.userId === currentUser?.id || o.customerEmail === currentUser?.email);

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  return (
    <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-6">
      <h2 className="text-xl font-extrabold text-gray-900 dark:text-white">Order History & Tracking</h2>

      {userOrders.length === 0 ? (
        <p className="text-sm text-gray-400 text-center py-10">No orders placed yet.</p>
      ) : (
        <div className="space-y-4">
          {userOrders.map((order) => (
            <div key={order.id} className="p-4 bg-gray-50 dark:bg-slate-900 rounded-2xl border border-gray-100 dark:border-slate-800 space-y-3">
              <div className="flex flex-wrap items-center justify-between gap-2 border-b border-gray-200 dark:border-slate-800 pb-3">
                <div>
                  <span className="font-bold text-sm text-gray-900 dark:text-white">{order.id}</span>
                  <span className="text-xs text-gray-400 block">{new Date(order.createdAt).toLocaleString()}</span>
                </div>
                <OrderStatusBadge status={order.orderStatus} />
              </div>

              <div className="space-y-2">
                {order.items.map((item, idx) => (
                  <div key={idx} className="flex items-center space-x-3 text-xs">
                    <img src={item.product.imageUrl} alt={item.product.name} className="w-10 h-10 object-cover rounded-lg" />
                    <div className="flex-1">
                      <p className="font-bold text-gray-900 dark:text-white line-clamp-1">{item.product.name}</p>
                      <p className="text-gray-400">Qty: {item.quantity} | {item.selectedColor}</p>
                    </div>
                    <span className="font-bold text-gray-900 dark:text-white">{formatCurrency(item.totalPrice || item.product.price * item.quantity)}</span>
                  </div>
                ))}
              </div>

              <div className="pt-2 border-t border-gray-200 dark:border-slate-800 flex justify-between items-center text-xs font-bold">
                <span className="text-gray-500">Payment: {order.paymentMethod}</span>
                <span className="text-indigo-600 dark:text-indigo-400 text-sm font-extrabold">Total: {formatCurrency(order.totalAmount)}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
