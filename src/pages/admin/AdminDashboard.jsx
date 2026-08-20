import React from 'react';
import { Package, Users, ShoppingBag, DollarSign, Clock, CheckCircle2, AlertTriangle } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { useApp } from '../../context/AppContext';

export default function AdminDashboard() {
  const { products, users, orders } = useApp();

  const totalRevenue = orders.reduce((sum, o) => sum + o.totalAmount, 0);
  const pendingOrders = orders.filter(o => o.orderStatus === 'Pending' || o.orderStatus === 'Confirmed' || o.orderStatus === 'Processing');
  const completedOrders = orders.filter(o => o.orderStatus === 'Delivered');
  const lowStockProducts = products.filter(p => p.stock <= 5);

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  const chartData = [
    { name: 'Mon', revenue: 12000 },
    { name: 'Tue', revenue: 25000 },
    { name: 'Wed', revenue: 18000 },
    { name: 'Thu', revenue: 34000 },
    { name: 'Fri', revenue: 29000 },
    { name: 'Sat', revenue: 42000 },
    { name: 'Sun', revenue: 58000 },
  ];

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-black text-gray-900 dark:text-white">Admin Dashboard Overview</h1>
        <p className="text-sm text-gray-500 mt-1">Real-time metrics calculated from application state</p>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center space-x-4">
          <div className="p-3.5 bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 rounded-2xl">
            <DollarSign size={28} />
          </div>
          <div>
            <p className="text-2xl font-black text-gray-900 dark:text-white">{formatCurrency(totalRevenue)}</p>
            <p className="text-xs text-gray-400 font-medium">Total Revenue</p>
          </div>
        </div>

        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center space-x-4">
          <div className="p-3.5 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 rounded-2xl">
            <ShoppingBag size={28} />
          </div>
          <div>
            <p className="text-2xl font-black text-gray-900 dark:text-white">{orders.length}</p>
            <p className="text-xs text-gray-400 font-medium">Total Orders</p>
          </div>
        </div>

        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center space-x-4">
          <div className="p-3.5 bg-purple-50 dark:bg-purple-950/60 text-purple-600 rounded-2xl">
            <Package size={28} />
          </div>
          <div>
            <p className="text-2xl font-black text-gray-900 dark:text-white">{products.length}</p>
            <p className="text-xs text-gray-400 font-medium">Total Products</p>
          </div>
        </div>

        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center space-x-4">
          <div className="p-3.5 bg-amber-50 dark:bg-amber-950/60 text-amber-600 rounded-2xl">
            <Users size={28} />
          </div>
          <div>
            <p className="text-2xl font-black text-gray-900 dark:text-white">{users.length}</p>
            <p className="text-xs text-gray-400 font-medium">Registered Users</p>
          </div>
        </div>
      </div>

      {/* Secondary Status Row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <Clock className="text-amber-500" size={24} />
            <span className="font-bold text-gray-900 dark:text-white text-sm">Pending Orders</span>
          </div>
          <span className="text-xl font-black text-amber-500">{pendingOrders.length}</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <CheckCircle2 className="text-emerald-500" size={24} />
            <span className="font-bold text-gray-900 dark:text-white text-sm">Completed Orders</span>
          </div>
          <span className="text-xl font-black text-emerald-500">{completedOrders.length}</span>
        </div>
      </div>

      {/* Low Stock Warning Alert */}
      {lowStockProducts.length > 0 && (
        <div className="bg-red-50 dark:bg-red-950/60 p-4 rounded-2xl border border-red-200 dark:border-red-900 flex items-center space-x-3 text-red-700 dark:text-red-300">
          <AlertTriangle size={24} className="text-red-500" />
          <div className="text-xs">
            <p className="font-bold">{lowStockProducts.length} Products Low in Stock!</p>
            <p>Update stock quantity in Product Management to avoid stockout.</p>
          </div>
        </div>
      )}

      {/* Recharts Revenue Trend */}
      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm space-y-4">
        <h2 className="text-lg font-bold text-gray-900 dark:text-white">Weekly Revenue Trend (Recharts)</h2>
        <div className="h-64 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" opacity={0.1} />
              <XAxis dataKey="name" stroke="#888888" fontSize={12} />
              <YAxis stroke="#888888" fontSize={12} />
              <Tooltip />
              <Area type="monotone" dataKey="revenue" stroke="#6366f1" fill="#818cf8" fillOpacity={0.2} />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}
