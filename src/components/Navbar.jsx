import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import {
  ShoppingBag,
  Heart,
  Search,
  User as UserIcon,
  Sun,
  Moon,
  ShieldAlert,
  LogOut,
  SlidersHorizontal,
  ChevronDown
} from 'lucide-react';
import { useApp } from '../context/AppContext';

export default function Navbar() {
  const {
    currentUser,
    cart,
    wishlist,
    darkMode,
    setDarkMode,
    searchQuery,
    setSearchQuery,
    setSelectedCategory,
    logout
  } = useApp();

  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const navigate = useNavigate();

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate('/products');
    }
  };

  return (
    <header className="sticky top-0 z-50 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md border-b border-gray-100 dark:border-slate-800 transition-colors">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-4">
        {/* Brand Logo */}
        <Link to="/" className="flex items-center space-x-2">
          <div className="p-2 bg-indigo-600 rounded-xl text-white shadow-md shadow-indigo-200 dark:shadow-none">
            <ShoppingBag size={22} />
          </div>
          <span className="text-xl font-extrabold tracking-tight text-gray-900 dark:text-white">
            Style<span className="text-indigo-600">Nest</span>
          </span>
        </Link>

        {/* Live Search Bar */}
        <form onSubmit={handleSearchSubmit} className="flex-1 max-w-md hidden md:block">
          <div className="relative">
            <input
              type="text"
              placeholder="Search laptops, sneakers, watches..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 bg-gray-100 dark:bg-slate-800 text-sm rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500 border border-transparent dark:border-slate-700 dark:text-white transition-all"
            />
            <Search className="absolute left-3 top-2.5 text-gray-400" size={18} />
          </div>
        </form>

        {/* Actions Menu */}
        <div className="flex items-center space-x-3">
          {/* Dark Mode Toggle */}
          <button
            onClick={() => setDarkMode(!darkMode)}
            className="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-800 rounded-xl transition-colors"
          >
            {darkMode ? <Sun size={20} className="text-amber-400" /> : <Moon size={20} />}
          </button>

          {/* Wishlist Icon */}
          <Link
            to="/wishlist"
            className="relative p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-800 rounded-xl transition-colors"
          >
            <Heart size={20} />
            {wishlist.length > 0 && (
              <span className="absolute top-1 right-1 bg-red-500 text-white text-[10px] font-bold h-4 w-4 rounded-full flex items-center justify-center">
                {wishlist.length}
              </span>
            )}
          </Link>

          {/* Cart Icon */}
          <Link
            to="/cart"
            className="relative p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-800 rounded-xl transition-colors"
          >
            <ShoppingBag size={20} />
            {cart.length > 0 && (
              <span className="absolute top-1 right-1 bg-indigo-600 text-white text-[10px] font-bold h-4 w-4 rounded-full flex items-center justify-center">
                {cart.reduce((sum, item) => sum + item.quantity, 0)}
              </span>
            )}
          </Link>

          {/* User Profile Menu / Login */}
          {currentUser ? (
            <div className="relative">
              <button
                onClick={() => setIsProfileOpen(!isProfileOpen)}
                className="flex items-center space-x-2 p-1.5 rounded-xl hover:bg-gray-100 dark:hover:bg-slate-800 transition-colors"
              >
                <img
                  src={currentUser.avatarUrl}
                  alt={currentUser.name}
                  className="h-8 w-8 rounded-full object-cover border border-indigo-200"
                />
                <span className="text-sm font-semibold text-gray-800 dark:text-gray-200 hidden sm:inline-block">
                  {currentUser.name.split(' ')[0]}
                </span>
                <ChevronDown size={14} className="text-gray-500" />
              </button>

              {/* Profile Dropdown */}
              {isProfileOpen && (
                <div
                  className="absolute right-0 mt-2 w-56 bg-white dark:bg-slate-800 rounded-2xl shadow-xl border border-gray-100 dark:border-slate-700 py-2 z-50"
                  onMouseLeave={() => setIsProfileOpen(false)}
                >
                  <div className="px-4 py-2 border-b border-gray-100 dark:border-slate-700">
                    <p className="text-sm font-bold text-gray-900 dark:text-white">{currentUser.name}</p>
                    <p className="text-xs text-gray-500 truncate">{currentUser.email}</p>
                    <span className="inline-block mt-1 text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 rounded-md">
                      Role: {currentUser.role}
                    </span>
                  </div>

                  <Link
                    to="/user/dashboard"
                    onClick={() => setIsProfileOpen(false)}
                    className="flex items-center space-x-2 px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700"
                  >
                    <UserIcon size={16} />
                    <span>User Dashboard</span>
                  </Link>

                  {currentUser.role === 'admin' && (
                    <Link
                      to="/admin/dashboard"
                      onClick={() => setIsProfileOpen(false)}
                      className="flex items-center space-x-2 px-4 py-2 text-sm text-indigo-600 dark:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-slate-700 font-semibold"
                    >
                      <ShieldAlert size={16} />
                      <span>Admin Control Panel</span>
                    </Link>
                  )}

                  <button
                    onClick={() => {
                      logout();
                      setIsProfileOpen(false);
                      navigate('/login');
                    }}
                    className="w-full text-left flex items-center space-x-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-slate-700"
                  >
                    <LogOut size={16} />
                    <span>Sign Out</span>
                  </button>
                </div>
              )}
            </div>
          ) : (
            <Link
              to="/login"
              className="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm rounded-xl shadow-md transition-all"
            >
              Sign In
            </Link>
          )}
        </div>
      </div>
    </header>
  );
}
