import React from 'react';
import { ShieldCheck, LogOut, Store } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useApp } from '../../context/AppContext';

export default function AdminProfile() {
  const { currentUser, logout } = useApp();
  const navigate = useNavigate();

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="bg-white dark:bg-slate-900 p-8 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm text-center space-y-4">
        <img
          src={currentUser?.avatarUrl}
          alt={currentUser?.name}
          className="w-24 h-24 rounded-full mx-auto object-cover border-4 border-indigo-500 shadow-lg"
        />
        <div>
          <h1 className="text-2xl font-black text-gray-900 dark:text-white">{currentUser?.name}</h1>
          <p className="text-xs text-gray-400">{currentUser?.email}</p>
          <span className="inline-block mt-2 px-3 py-1 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 font-bold text-xs rounded-full">
            System Administrator
          </span>
        </div>
      </div>

      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-gray-100 dark:border-slate-800 shadow-sm space-y-4">
        <h2 className="text-lg font-bold text-gray-900 dark:text-white">Admin Controls</h2>
        <div className="space-y-2">
          <Link
            to="/"
            className="flex items-center justify-between p-4 bg-gray-50 dark:bg-slate-800 rounded-2xl text-sm font-bold text-gray-800 dark:text-gray-200 hover:bg-gray-100"
          >
            <div className="flex items-center space-x-3">
              <Store className="text-indigo-600" />
              <span>Customer Storefront</span>
            </div>
          </Link>

          <button
            onClick={() => {
              logout();
              navigate('/login');
            }}
            className="w-full flex items-center justify-between p-4 bg-red-50 dark:bg-red-950/60 text-red-600 rounded-2xl text-sm font-bold hover:bg-red-100"
          >
            <div className="flex items-center space-x-3">
              <LogOut />
              <span>Sign Out of Admin Panel</span>
            </div>
          </button>
        </div>
      </div>
    </div>
  );
}
