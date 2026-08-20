import React from 'react';
import { Link, Outlet, useLocation, useNavigate } from 'react-router-dom';
import {
  LayoutDashboard,
  BarChart3,
  Package,
  ShoppingBag,
  Users,
  ShieldAlert,
  Store,
  LogOut,
  UserCheck
} from 'lucide-react';
import { useApp } from '../../context/AppContext';

export default function AdminLayout() {
  const { currentUser, logout } = useApp();
  const location = useLocation();
  const navigate = useNavigate();

  // Role Guard Enforcement
  if (!currentUser || currentUser.role !== 'admin') {
    return (
      <div className="max-w-md mx-auto my-20 p-8 bg-white dark:bg-slate-800 rounded-3xl border border-red-200 dark:border-red-900 shadow-xl text-center space-y-4">
        <ShieldAlert size={64} className="mx-auto text-red-500" />
        <h2 className="text-2xl font-black text-gray-900 dark:text-white">Access Restricted</h2>
        <p className="text-sm text-gray-500">
          You must be logged in as an Administrator (`admin@gmail.com`) to access the Admin Control Panel.
        </p>
        <div className="pt-2 flex flex-col gap-2">
          <Link to="/login" className="py-3 bg-indigo-600 text-white font-bold text-sm rounded-xl">
            Go to Sign In Page
          </Link>
          <Link to="/" className="py-3 bg-gray-100 dark:bg-slate-700 text-gray-800 dark:text-gray-200 font-bold text-sm rounded-xl">
            Return to Customer Store
          </Link>
        </div>
      </div>
    );
  }

  const navItems = [
    { label: 'Overview', path: '/admin/dashboard', icon: LayoutDashboard },
    { label: 'Analytics', path: '/admin/analytics', icon: BarChart3 },
    { label: 'Products', path: '/admin/products', icon: Package },
    { label: 'Orders', path: '/admin/orders', icon: ShoppingBag },
    { label: 'Users', path: '/admin/users', icon: Users },
    { label: 'Admin Profile', path: '/admin/profile', icon: UserCheck },
  ];

  return (
    <div className="min-h-screen bg-slate-100 dark:bg-slate-950 flex flex-col md:flex-row">
      {/* Admin Sidebar */}
      <aside className="w-full md:w-64 bg-slate-900 text-slate-300 p-6 flex flex-col justify-between space-y-6">
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <Link to="/admin/dashboard" className="flex items-center space-x-2">
              <div className="p-2 bg-indigo-600 rounded-xl text-white">
                <ShieldAlert size={20} />
              </div>
              <span className="font-extrabold text-white text-lg">AdminPanel</span>
            </Link>
            <span className="text-[10px] font-bold px-2 py-0.5 bg-indigo-500/20 text-indigo-400 rounded-md">PRO</span>
          </div>

          <div className="p-3 bg-slate-800/80 rounded-2xl border border-slate-700/60 flex items-center space-x-3">
            <img src={currentUser.avatarUrl} alt={currentUser.name} className="w-10 h-10 rounded-full object-cover" />
            <div className="overflow-hidden">
              <p className="font-bold text-white text-sm truncate">{currentUser.name}</p>
              <p className="text-[10px] text-indigo-400 font-semibold">Administrator</p>
            </div>
          </div>

          <nav className="space-y-1 text-sm font-semibold">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = location.pathname === item.path;
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={`flex items-center space-x-3 px-4 py-3 rounded-xl transition-all ${
                    isActive
                      ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/30'
                      : 'text-slate-400 hover:bg-slate-800 hover:text-white'
                  }`}
                >
                  <Icon size={18} />
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </nav>
        </div>

        <div className="space-y-2 pt-6 border-t border-slate-800">
          <Link
            to="/"
            className="flex items-center space-x-3 px-4 py-2.5 rounded-xl text-slate-400 hover:bg-slate-800 hover:text-white text-sm font-bold"
          >
            <Store size={18} />
            <span>Customer Store</span>
          </Link>

          <button
            onClick={() => {
              logout();
              navigate('/login');
            }}
            className="w-full flex items-center space-x-3 px-4 py-2.5 rounded-xl text-red-400 hover:bg-red-950/40 text-sm font-bold"
          >
            <LogOut size={18} />
            <span>Sign Out</span>
          </button>
        </div>
      </aside>

      {/* Main Content View */}
      <main className="flex-1 p-6 md:p-10 overflow-y-auto">
        <Outlet />
      </main>
    </div>
  );
}
