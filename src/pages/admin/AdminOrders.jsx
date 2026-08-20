import React from 'react';
import { useApp } from '../../context/AppContext';
import OrderStatusBadge from '../../components/OrderStatusBadge';

export default function AdminOrders() {
  const { orders, updateOrderStatus } = useApp();

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const statusOptions = ['Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered'];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-black text-gray-900 dark:text-white">Order Management</h1>
        <p className="text-sm text-gray-500 mt-1">View customer orders and update status in real-time</p>
      </div>

      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 dark:bg-slate-800/50 text-gray-500 uppercase text-[10px] tracking-wider border-b border-gray-100 dark:border-slate-800">
              <tr>
                <th className="px-6 py-4">Order ID</th>
                <th className="px-6 py-4">Customer</th>
                <th className="px-6 py-4">Amount</th>
                <th className="px-6 py-4">Payment</th>
                <th className="px-6 py-4">Current Status</th>
                <th className="px-6 py-4 text-right">Update Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100 dark:divide-slate-800">
              {orders.map((order) => (
                <tr key={order.id} className="hover:bg-gray-50/50 dark:hover:bg-slate-800/50">
                  <td className="px-6 py-4 font-bold text-gray-900 dark:text-white">{order.id}</td>
                  <td className="px-6 py-4">
                    <p className="font-bold text-gray-900 dark:text-white text-xs">{order.customerName}</p>
                    <p className="text-[10px] text-gray-400">{order.customerEmail}</p>
                  </td>
                  <td className="px-6 py-4 font-bold text-indigo-600 dark:text-indigo-400">{formatCurrency(order.totalAmount)}</td>
                  <td className="px-6 py-4 text-xs font-semibold text-gray-600 dark:text-gray-400">{order.paymentMethod}</td>
                  <td className="px-6 py-4">
                    <OrderStatusBadge status={order.orderStatus} />
                  </td>
                  <td className="px-6 py-4 text-right">
                    <select
                      value={order.orderStatus}
                      onChange={(e) => updateOrderStatus(order.id, e.target.value)}
                      className="px-3 py-1.5 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-xs font-bold text-indigo-600 dark:text-indigo-400 focus:ring-2 focus:ring-indigo-500"
                    >
                      {statusOptions.map((s) => (
                        <option key={s} value={s}>
                          {s}
                        </option>
                      ))}
                    </select>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
