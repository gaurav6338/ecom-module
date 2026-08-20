import React from 'react';
import { BarChart, Bar, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { useApp } from '../../context/AppContext';

export default function AdminAnalytics() {
  const { products, orders } = useApp();

  const categoryData = [
    { name: 'Audio', sales: 12 },
    { name: 'Fashion', sales: 18 },
    { name: 'Footwear', sales: 10 },
    { name: 'Watches', sales: 8 },
    { name: 'Home', sales: 15 },
  ];

  const pieData = [
    { name: 'Pending', value: orders.filter(o => o.orderStatus !== 'Delivered').length || 1, color: '#f59e0b' },
    { name: 'Delivered', value: orders.filter(o => o.orderStatus === 'Delivered').length || 1, color: '#10b981' },
  ];

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-black text-gray-900 dark:text-white">Sales & Analytics (Recharts)</h1>
        <p className="text-sm text-gray-500 mt-1">Category performance and order status charts</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Category Sales Bar Chart */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm space-y-4">
          <h2 className="text-lg font-bold text-gray-900 dark:text-white">Sales by Category</h2>
          <div className="h-64 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={categoryData}>
                <CartesianGrid strokeDasharray="3 3" opacity={0.1} />
                <XAxis dataKey="name" stroke="#888888" fontSize={12} />
                <YAxis stroke="#888888" fontSize={12} />
                <Tooltip />
                <Bar dataKey="sales" fill="#6366f1" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Order Status Pie Chart */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm space-y-4">
          <h2 className="text-lg font-bold text-gray-900 dark:text-white">Order Status Breakdown</h2>
          <div className="h-64 w-full flex items-center justify-center">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={pieData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} label>
                  {pieData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
}
