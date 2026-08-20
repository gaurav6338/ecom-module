import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { User, Package, Heart, ShoppingBag, MapPin, Settings, LogOut, ShieldAlert } from 'lucide-react';
import { useApp } from '../../context/AppContext';
import OrderStatusBadge from '../../components/OrderStatusBadge';
import UserProfile from './UserProfile';
import UserOrders from './UserOrders';
import UserAddresses from './UserAddresses';

export default function UserDashboard() {
  const [activeTab, setActiveTab] = useState('overview');
  const { currentUser, orders, wishlist, cart, logout } = useApp();

  const userOrders = orders.filter(o => o.userId === currentUser?.id || o.customerEmail === currentUser?.email);

  const formatCurrency = (amt) => `₹${amt.toLocaleString('en-IN')}`;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
        {/* Dashboard Sidebar */}
        <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-6">
          <div className="text-center pb-6 border-b border-gray-100 dark:border-slate-700 space-y-3">
            <img
              src={currentUser?.avatarUrl || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80'}
              alt={currentUser?.name}
              className="w-20 h-20 rounded-full mx-auto object-cover border-2 border-indigo-500 shadow-md"
            />
            <div>
              <h2 className="font-bold text-gray-900 dark:text-white text-base">{currentUser?.name || 'Rishi Kumar'}</h2>
              <p className="text-xs text-gray-400">{currentUser?.email || 'rishi@gmail.com'}</p>
              <span className="inline-block mt-2 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-wider bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 rounded-md">
                {currentUser?.role === 'admin' ? 'Role: Administrator' : 'Customer Account'}
              </span>
            </div>
          </div>

          <nav className="space-y-1 text-sm font-semibold">
            <button
              onClick={() => setActiveTab('overview')}
              className={`w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl transition-all ${
                activeTab === 'overview'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700'
              }`}
            >
              <User size={18} />
              <span>Overview</span>
            </button>

            <button
              onClick={() => setActiveTab('orders')}
              className={`w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl transition-all ${
                activeTab === 'orders'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700'
              }`}
            >
              <Package size={18} />
              <span>My Orders ({userOrders.length})</span>
            </button>

            <button
              onClick={() => setActiveTab('profile')}
              className={`w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl transition-all ${
                activeTab === 'profile'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700'
              }`}
            >
              <Settings size={18} />
              <span>Edit Profile</span>
            </button>

            <button
              onClick={() => setActiveTab('addresses')}
              className={`w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl transition-all ${
                activeTab === 'addresses'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700'
              }`}
            >
              <MapPin size={18} />
              <span>Saved Addresses</span>
            </button>

            {currentUser?.role === 'admin' && (
              <Link
                to="/admin/dashboard"
                className="w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl text-indigo-600 dark:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-slate-700 font-bold"
              >
                <ShieldAlert size={18} />
                <span>Switch to Admin Panel</span>
              </Link>
            )}

            <button
              onClick={logout}
              className="w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl text-red-600 hover:bg-red-50 dark:hover:bg-slate-700 font-bold"
            >
              <LogOut size={18} />
              <span>Logout</span>
            </button>
          </nav>
        </div>

        {/* Content Pane */}
        <div className="md:col-span-3 space-y-6">
          {activeTab === 'overview' && (
            <div className="space-y-6">
              {/* Stat Cards */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div className="bg-white dark:bg-slate-800 p-5 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm flex items-center space-x-4">
                  <div className="p-3 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 rounded-2xl">
                    <Package size={24} />
                  </div>
                  <div>
                    <p className="text-2xl font-black text-gray-900 dark:text-white">{userOrders.length}</p>
                    <p className="text-xs text-gray-400">Total Orders</p>
                  </div>
                </div>

                <div className="bg-white dark:bg-slate-800 p-5 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm flex items-center space-x-4">
                  <div className="p-3 bg-red-50 dark:bg-red-950/60 text-red-500 rounded-2xl">
                    <Heart size={24} />
                  </div>
                  <div>
                    <p className="text-2xl font-black text-gray-900 dark:text-white">{wishlist.length}</p>
                    <p className="text-xs text-gray-400">Wishlist Items</p>
                  </div>
                </div>

                <div className="bg-white dark:bg-slate-800 p-5 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm flex items-center space-x-4">
                  <div className="p-3 bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 rounded-2xl">
                    <ShoppingBag size={24} />
                  </div>
                  <div>
                    <p className="text-2xl font-black text-gray-900 dark:text-white">{cart.length}</p>
                    <p className="text-xs text-gray-400">Active Cart Items</p>
                  </div>
                </div>
              </div>

              {/* Recent Orders Table */}
              <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-gray-100 dark:border-slate-700 shadow-sm space-y-4">
                <div className="flex items-center justify-between">
                  <h3 className="font-extrabold text-gray-900 dark:text-white text-base">Recent Orders</h3>
                  <button onClick={() => setActiveTab('orders')} className="text-xs text-indigo-600 font-bold hover:underline">
                    View All
                  </button>
                </div>

                <div className="space-y-3">
                  {userOrders.slice(0, 3).map((order) => (
                    <div key={order.id} className="p-4 bg-gray-50 dark:bg-slate-900 rounded-2xl flex items-center justify-between">
                      <div>
                        <p className="font-bold text-sm text-gray-900 dark:text-white">{order.id}</p>
                        <p className="text-xs text-gray-400">{new Date(order.createdAt).toLocaleDateString()}</p>
                      </div>
                      <OrderStatusBadge status={order.orderStatus} />
                      <span className="font-extrabold text-indigo-600 text-sm">{formatCurrency(order.totalAmount)}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {activeTab === 'profile' && <UserProfile />}
          {activeTab === 'orders' && <UserOrders />}
          {activeTab === 'addresses' && <UserAddresses />}
        </div>
      </div>
    </div>
  );
}
